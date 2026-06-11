package playerio {
	import flash.net.SharedObject;
	import flash.utils.getTimer;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.setInterval;

	public class OfflineServer {
		private static var _instance:OfflineServer;

		private var _saveData:SharedObject;
		private var _player:Object;
		private var _config:Object = null;
		private var _prices:Array; // Array of [creditPrice, platPrice]
		private var _vault:Array;  // Array of Array of 4 ints (item + 3 upgrades)
		private var _packs:Array;  // Array of Pack Objects: { name: String, price: int, items: Array of Array of 4 ints }
		
		private var _connections:Array;

		private var _vaultHour:int = 0;
		private var _vaultMinute:int = 0;
		private var _lastVaultCheck:Number = 0;

		private var _rngSeed:uint = 0;
		private function seedRNG(seed:uint):void {
			_rngSeed = seed;
		}
		private function MathRandom():Number {
			_rngSeed = (1103515245 * _rngSeed + 12345) & 0x7FFFFFFF;
			return _rngSeed / 2147483647.0;
		}

		public static const MAX_STATIONS:int = 7;

		public static function getInstance():OfflineServer {
			if (!_instance) {
				_instance = new OfflineServer();
			}
			return _instance;
		}

		public function get config():Object {
			return _config;
		}

		public function OfflineServer() {
			_connections = [];
			_lastVaultCheck = getTimer();
			
			// 1. Initialize Default Prices (350 entries for items 100 to 450)
			_prices = [];
			for (var i:int = 0; i < 350; i++) {
				var itemId:int = i + 100;
				var baseCredits:int = 100;
				var basePlat:int = 2;
				
				if (itemId >= 100 && itemId < 175) { // Turrets
					baseCredits = 150; basePlat = 2;
				} else if (itemId >= 200 && itemId < 250) { // Fighters
					baseCredits = 200; basePlat = 3;
				} else if (itemId >= 250 && itemId < 350) { // Ships
					baseCredits = 250; basePlat = 4;
				} else if (itemId >= 350) { // Structures
					baseCredits = 300; basePlat = 5;
				}
				_prices.push([baseCredits, basePlat]);
			}

			// 2. Initialize Default Vault (11 slots)
			_vault = [];
			for (var j:int = 0; j < 11; j++) {
				_vault.push([-1, -1, -1, -1]);
			}
			refreshVault();

			// 3. Initialize Default Item Packs (10 packs with valid whitelisted item IDs)
			_packs = [];
			var packNames:Array = [
				"Starter Pack", "Turret Pack", "Fighter Wing", "Cruiser Squadron", "Heavy Defense Pack",
				"Advanced Weapons Pack", "Engineer Support Pack", "Carrier Pack", "Doomsday Tech Pack", "Elite Fleet"
			];
			var packContents:Array = [
				[100, 101, 102, 200, 250], // Starter Pack
				[100, 101, 102, 103, 104], // Turret Pack
				[200, 201, 202, 203, 204], // Fighter Wing
				[250, 251, 252, 253, 254], // Cruiser Squadron
				[105, 106, 107, 110, 111], // Heavy Defense Pack
				[116, 117, 150, 152, 153], // Advanced Weapons Pack
				[114, 350, 351, 352, 353], // Engineer Support Pack
				[252, 256, 301, 302, 308], // Carrier Pack
				[369, 370, 371, 372, 373], // Doomsday Tech Pack
				[311, 312, 313, 314, 315]  // Elite Fleet
			];
			for (var p:int = 0; p < 10; p++) {
				var packItems:Array = [];
				for (var k:int = 0; k < 5; k++) {
					packItems.push([packContents[p][k], -1, -1, -1]);
				}
				_packs.push({
					name: packNames[p],
					price: 40 + p * 10,
					items: packItems
				});
			}

			// 4. Initialize dynamic Guest profile by default
			_player = createNewProfile("GuestPlayer");
			
			// Start periodic config polling and time-based vault refreshes
			setInterval(tickServer, 10000);
		}

		private function tickServer():void {
			loadConfig();
			checkTimeRefresh();
		}

		private function checkTimeRefresh():void {
			var periodMinutes:int = (_config && _config.store_refresh_period_minutes) ? _config.store_refresh_period_minutes : 60;
			var currentPeriod:int = Math.floor(new Date().time / (1000 * 60 * periodMinutes));
			if (_vaultHour == 0) {
				_vaultHour = currentPeriod;
			}
			if (currentPeriod != _vaultHour) {
				_vaultHour = currentPeriod;
				refreshVault();
			}
		}

		private function createNewProfile(username:String):Object {
			var p:Object = {};
			p.username = username;
			p.callsign = username;
			p.password = "";
			p.credits = 500;
			p.stations = MAX_STATIONS;
			p.maxinventory = 50;
			p.wins = 0;
			p.losses = 0;
			p.rating = 1000;
			p.classlock = 0;
			p.dangerClass = 0; // "class" in C#
			p.campaignseed = 0;
			p.campaignstart = -1;
			p.lasttime = new Date().getTime();
			p.laststations = new Date().getTime();
			p.lastbonus = 0;
			p.platinum = 30; // Starting platinum coins

			// Starting Armory (50 items of 4 ints)
			var arm:Array = [];
			for (var i:int = 0; i < 50; i++) {
				arm.push([-1, -1, -1, -1]);
			}
			p.armory = arm;
			
			// Starting Equipped mappings
			var eq:Array = [];
			for (var j:int = 0; j < 21; j++) {
				eq.push(-1);
			}
			p.equip = eq;

			// Starter items added to armory
			// Additem: 100, 101, 102, 200, 202, 250
			addItemToProfile(p, 100, -1, -1, -1);
			addItemToProfile(p, 101, -1, -1, -1);
			addItemToProfile(p, 102, -1, -1, -1);
			addItemToProfile(p, 200, -1, -1, -1);
			addItemToProfile(p, 202, -1, -1, -1);
			addItemToProfile(p, 250, -1, -1, -1);

			// Starter equip slots
			p.equip[0] = 3; // slot 0 maps to armory index 3
			p.equip[1] = 4;
			p.equip[3] = 5;
			p.equip[8] = 0;
			p.equip[9] = 1;
			p.equip[10] = 2;

			// Campaign grid progress
			var camp:Array = [];
			for (var k:int = 0; k < 36; k++) {
				camp.push(0);
			}
			p.campaign = camp;

			// Campaign prizes mapping
			var prz:Array = [];
			for (var l:int = 0; l < 36; l++) {
				prz.push([-1, -1, -1, -1]);
			}
			p.prizes = prz;

			return p;
		}

		private function saveProfile():void {
			if (!_player || !_player.username) return;
			try {
				var userSaveData:SharedObject = SharedObject.getLocal("OE3_Offline_SaveData_" + _player.username);
				userSaveData.data.player = _player;
				userSaveData.flush();
			} catch (e:Error) {
				trace("Failed to flush SharedObject: " + e.message);
			}
			saveToLocalFile();
		}

		private function getNativeJSON():Object {
			try {
				return getDefinitionByName("JSON");
			} catch (e:Error) {
				trace("Native JSON class not found at runtime.");
			}
			return null;
		}

		private function parseJSON(str:String):Object {
			var jsonClass:Object = getNativeJSON();
			if (jsonClass) {
				return jsonClass.parse(str);
			}
			return null;
		}

		private function stringifyJSON(obj:Object):String {
			var jsonClass:Object = getNativeJSON();
			if (jsonClass) {
				return jsonClass.stringify(obj);
			}
			return "";
		}

		private function logToServer(msg:String, level:String = "INFO"):void {
			try {
				var url:String = "/log";
				var request:URLRequest = new URLRequest(url);
				request.method = URLRequestMethod.POST;
				request.data = "[" + level + "] " + msg;
				request.contentType = "text/plain";
				var loader:URLLoader = new URLLoader();
				loader.load(request);
			} catch (e:Error) {
				trace("Failed to send log to server: " + e.message);
			}
		}

		private function loadConfig():void {
			try {
				var url:String = "/config";
				var request:URLRequest = new URLRequest(url);
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, function(e:Event):void {
					try {
						_config = parseJSON(loader.data);
						trace("Loaded launcher config from server.");
						if (_config && _config.force_vault_refresh) {
							refreshVault(true);
						}
					} catch (err:Error) {
						trace("Error parsing launcher config: " + err.message);
					}
				});
				loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
					trace("Failed to load launcher config from server.");
				});
				loader.load(request);
			} catch (e:Error) {
				trace("Error calling /config: " + e.message);
			}
		}

		private function loadAndLoginUser(username:String, connection:LocalConnection):void {
			loadConfig();
			var url:String = "/load?user=" + encodeURIComponent(username);
			var request:URLRequest = new URLRequest(url);
			var loader:URLLoader = new URLLoader();
			
			loader.addEventListener(Event.COMPLETE, function(e:Event):void {
				try {
					var data:Object = parseJSON(loader.data);
					if (data && data.username) {
						_player = data;
						if (!_player.username || _player.username.toLowerCase() != username.toLowerCase()) {
							_player.username = username;
						}
						if (!_player.callsign || _player.callsign.toLowerCase() != username.toLowerCase()) {
							_player.callsign = username;
						}
						trace("Loaded user save from file: " + username);
						logToServer("Loaded user save from file: " + username, "INFO");
					} else {
						_player = createNewProfile(username);
						logToServer("Corrupt or invalid local file save for " + username + ". Created new profile.", "WARNING");
					}
				} catch (err:Error) {
					_player = createNewProfile(username);
					logToServer("Error parsing local file save for " + username + ": " + err.message + ". Created new profile.", "ERROR");
				}
				completeLogin(connection);
			});
			
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
				trace("No local save file found for " + username + ". Checking SharedObject...");
				logToServer("No local save file found for " + username + ". Checking SharedObject...", "INFO");
				try {
					var userSaveData:SharedObject = SharedObject.getLocal("OE3_Offline_SaveData_" + username);
					if (userSaveData.data.player != null) {
						_player = userSaveData.data.player;
						trace("Loaded user save from SharedObject: " + username);
						logToServer("Loaded user save from SharedObject: " + username, "INFO");
					} else {
						_player = createNewProfile(username);
						logToServer("No SharedObject save found for " + username + ". Created new profile.", "INFO");
					}
				} catch (err:Error) {
					_player = createNewProfile(username);
					logToServer("Error accessing SharedObject for " + username + ": " + err.message + ". Created new profile.", "ERROR");
				}
				completeLogin(connection);
			});
			
			loader.load(request);
		}

		private function completeLogin(connection:LocalConnection):void {
			saveProfile();
			setStations(_player);
			sendServiceInitData(connection);
			connection.receiveFromServer(new LocalMessage("sloggedon"));
			logToServer("User login complete: " + _player.username, "INFO");
		}

		private function saveToLocalFile():void {
			if (!_player || !_player.username) return;
			try {
				var jsonStr:String = stringifyJSON(_player);
				var url:String = "/save?user=" + encodeURIComponent(_player.username);
				var request:URLRequest = new URLRequest(url);
				request.method = URLRequestMethod.POST;
				request.data = jsonStr;
				request.contentType = "application/json";
				var loader:URLLoader = new URLLoader();
				loader.load(request);
				logToServer("Saved profile changes to local save file.", "INFO");
			} catch (e:Error) {
				trace("Failed to save to local file: " + e.message);
				logToServer("Failed to save profile to local file: " + e.message, "ERROR");
			}
		}

		public function handleClientJoin(connection:LocalConnection, joinData:Object):void {
			_connections.push(connection);
			
			// Trigger local server join logic
			if (connection.roomType == "Service") {
				// Instant service connection handler
			} else if (connection.roomType == "Matcher") {
				// In matchmaking, instantly return a match room
				var msg:LocalMessage = new LocalMessage("mgo");
				msg.add("localGameRoom_" + Math.floor(MathRandom() * 1000));
				connection.receiveFromServer(msg);
			} else if (connection.roomType == "Game") {
				// Instantly start multiplayer room simulator
				var ginit:LocalMessage = new LocalMessage("ginit");
				ginit.add(1); // My Player ID
				connection.receiveFromServer(ginit);

				// Send Player stats (names and ratings)
				var grstats:LocalMessage = new LocalMessage("grstats");
				grstats.add(_player.callsign);
				grstats.add(_player.rating);
				grstats.add("CPU Bot");
				grstats.add(1000);
				connection.receiveFromServer(grstats);

				// Send armory configuration to match game load expectations
				var grarmory:LocalMessage = new LocalMessage("grarmory");
				var i:int, j:int;
				// Send our equipped armory items
				for (i = 0; i < 21; i++) {
					var armIndex:int = _player.equip[i];
					var item:Array = (armIndex >= 0 && armIndex < _player.armory.length) ? _player.armory[armIndex] : [-1, -1, -1, -1];
					for (j = 0; j < 4; j++) {
						grarmory.add(item[j]);
					}
				}
				// Send CPU equipped items (filler items)
				for (i = 0; i < 21; i++) {
					var botItem:Array = [100 + (i % 3), -1, -1, -1];
					for (j = 0; j < 4; j++) {
						grarmory.add(botItem[j]);
					}
				}
				connection.receiveFromServer(grarmory);
			}
		}

		public function handleClientDisconnect(connection:LocalConnection):void {
			var idx:int = _connections.indexOf(connection);
			if (idx != -1) {
				_connections.splice(idx, 1);
			}
		}

		public function handleIncomingMessage(connection:LocalConnection, message:Message):void {
			// Seed with a dynamic value (milliseconds) by default to keep gameplay rewards and matchmaking dynamic
			seedRNG(uint(new Date().time & 0x7FFFFFFF));

			var type:String = message.type;
			var i:int, j:int;

			if (connection.roomType == "Service") {
				switch (type) {
					case "slogin":
						var username:String = message.getString(0);
						loadAndLoginUser(username, connection);
						break;

					case "screateaccount":
						var newUsername:String = message.getString(0);
						_player = createNewProfile(newUsername);
						saveProfile();

						sendServiceInitData(connection);
						connection.receiveFromServer(new LocalMessage("screated"));
						logToServer("Created new user account: " + newUsername, "INFO");
						break;

					case "skong":
						var kongUsername:String = message.getString(0);
						loadAndLoginUser(kongUsername, connection);
						break;

					case "stequip":
						// Update equipped items list
						for (i = 0; i < message.length; i++) {
							_player.equip[i] = message.getInt(i);
						}
						saveProfile();
						break;

					case "snewcampaign":
						var selectedDangerClass:int = message.getInt(0);
						if (selectedDangerClass <= _player.classlock && _player.stations > 0) {
							generateCampaign(_player, selectedDangerClass);
							_player.stations -= 1;
							saveProfile();
							sendAccount(connection);
							sendCampaign(connection);
							logToServer("Started new campaign with danger class: " + selectedDangerClass, "INFO");
						}
						break;

					case "srequestmission":
						var missionId:int = message.getInt(0);
						if (_player.stations > 0) {
							_player.currentmission = missionId;
							_player.stations -= 1;
							saveProfile();
							connection.receiveFromServer(new LocalMessage("sstartmission"));
							logToServer("Player requested mission ID: " + missionId, "INFO");
						}
						break;

					case "sfixmission":
						_player.currentmission = message.getInt(0);
						break;

					case "sgameover":
						var result:int = message.getInt(0);
						if (_player.currentmission != -1) {
							logToServer("Mission over. ID: " + _player.currentmission + " | Result: " + (result == 1 ? "Victory" : "Defeat"), "INFO");
							if (result == 1) { // Victory
								_player.stations += 1;
								if (_player.currentmission != 1000) {
									_player.campaign[_player.currentmission] = 2; // Marked as completed
									giveMissionPrize(connection, _player.currentmission);
								} else { // Campaign boss completed
									completeCampaign(connection);
								}
							}
							_player.currentmission = -1;
							saveProfile();

							// Confirm result back to client
							var confirmedMsg:LocalMessage = new LocalMessage("sresultconfirmed");
							confirmedMsg.add(result);
							connection.receiveFromServer(confirmedMsg);

							// Send updated player state
							sendAccount(connection);
							sendCampaign(connection);
							sendArmory(connection);
							sendEquip(connection);
							sendPlatinum(connection);
						}
						break;

					case "sbuy":
						var vaultSlot:int = message.getInt(0);
						var isPlatBuy:int = message.getInt(1); // 0 = Credits, 1 = Platinum
						
						if (vaultSlot >= 0 && vaultSlot < _vault.length && checkFreeSlots(_player, 1)) {
							var vaultItem:Array = _vault[vaultSlot];
							var baseItem:int = vaultItem[0];
							
							var pp:Array = _prices[baseItem - 100];
							var mult:int = 1;
							if (vaultItem[1] > -1) mult *= 3;
							if (vaultItem[2] > -1) mult *= 3;
							if (vaultItem[3] > -1) mult *= 3;

							var cost:int = mult * (isPlatBuy == 0 ? pp[0] : pp[1]);
							var transactionSuccess:Boolean = false;

							if (isPlatBuy == 0 && _player.credits >= cost) {
								_player.credits -= cost;
								transactionSuccess = true;
							} else if (isPlatBuy == 1 && _player.platinum >= cost) {
								_player.platinum -= cost;
								transactionSuccess = true;
							}

							if (transactionSuccess) {
								addItemToProfile(_player, vaultItem[0], vaultItem[1], vaultItem[2], vaultItem[3]);
								saveProfile();

								sendAccount(connection);
								sendArmory(connection);
								sendPlatinum(connection);
								connection.receiveFromServer(new LocalMessage("sbought"));
								logToServer("Bought item from vault slot " + vaultSlot + " (Item ID: " + vaultItem[0] + ")", "INFO");
							}
						} else {
							connection.receiveFromServer(new LocalMessage("snospace"));
						}
						break;

					case "ssell":
						var sellSlot:int = message.getInt(0);
						var sellMode:int = message.getInt(1); // 0 = Credits

						var armItem:Array = _player.armory[sellSlot];
						if (armItem && armItem[0] >= 0) {
							if (sellMode == 0) {
								_player.credits += Math.ceil(0.1 * getCreditPrice(armItem[0], armItem[1], armItem[2], armItem[3]));
							}
							
							// Clear armory slot
							_player.armory[sellSlot] = [-1, -1, -1, -1];
							
							// Clear equipped reference if matched
							var equipChanged:Boolean = false;
							for (var eqIdx:int = 0; eqIdx < _player.equip.length; eqIdx++) {
								if (_player.equip[eqIdx] == sellSlot) {
									_player.equip[eqIdx] = -1;
									equipChanged = true;
								}
							}

							saveProfile();
							sendAccount(connection);
							sendArmory(connection);
							if (equipChanged) {
								sendEquip(connection);
							}
							connection.receiveFromServer(new LocalMessage("ssold"));
							logToServer("Sold item from armory slot " + sellSlot, "INFO");
						}
						break;

					case "sbuystations":
						var numStations:int = MAX_STATIONS - _player.stations;
						var stationCost:int = 4 * numStations;
						if (_player.platinum >= stationCost) {
							_player.platinum -= stationCost;
							_player.stations = MAX_STATIONS;
							saveProfile();
							sendPlatinum(connection);
							sendAccount(connection);
						}
						break;

					case "sbuycredits":
						var creditTier:int = message.getInt(0);
						var platCost:int = creditTier == 0 ? 1 : (creditTier == 1 ? 10 : 50);
						var creditsAdd:int = creditTier == 0 ? 100 : (creditTier == 1 ? 1000 : 5000);

						if (_player.platinum >= platCost) {
							_player.platinum -= platCost;
							_player.credits += creditsAdd;
							saveProfile();
							sendAccount(connection);
							sendPlatinum(connection);
						}
						break;

					case "sbuypack":
						// Upgrade maximum inventory size (+10)
						if (_player.platinum >= 50) {
							_player.platinum -= 50;
							_player.maxinventory += 10;
							for (var pIdx:int = 0; pIdx < 10; pIdx++) {
								_player.armory.push([-1, -1, -1, -1]);
							}
							saveProfile();
							sendAccount(connection);
							sendArmory(connection);
							sendPlatinum(connection);
						}
						break;

					case "sbuyitempack":
						var packId:int = message.getInt(0);
						if (packId >= 0 && packId < _packs.length) {
							var pack:Object = _packs[packId];
							if (_player.platinum >= pack.price && checkFreeSlots(_player, 5)) {
								_player.platinum -= pack.price;
								for (var pk:int = 0; pk < 5; pk++) {
									var pkItem:Array = pack.items[pk];
									addItemToProfile(_player, pkItem[0], pkItem[1], pkItem[2], pkItem[3]);
								}
								saveProfile();
								sendArmory(connection);
								sendPlatinum(connection);
							}
						}
						break;

					case "sclaimprize":
						// Claim daily bonus
						var todayDay:int = new Date().getDate();
						if (_player.lastbonus != todayDay) {
							var bonusCoins:int = 10;
							_player.platinum += bonusCoins;
							_player.lastbonus = todayDay;
							saveProfile();

							var claimedMsg:LocalMessage = new LocalMessage("claimed");
							claimedMsg.add(bonusCoins);
							connection.receiveFromServer(claimedMsg);
							sendPlatinum(connection);
							sendAccount(connection);
						}
						break;

					case "sbuyplatinum":
						var tier:int = message.getInt(0);
						var platAdd:int = 0;
						switch (tier) {
							case 0: platAdd = 50; break;
							case 1: platAdd = 110; break;
							case 2: platAdd = 250; break;
							case 3: platAdd = 700; break;
							case 4: platAdd = 1500; break;
						}
						if (_config && _config.disable_plat_purchase == true) {
							logToServer("Platinum purchase blocked (Disabled in terminal config)", "WARNING");
						} else {
							_player.platinum += platAdd;
							saveProfile();
							sendPlatinum(connection);
						}
						break;

					case "supgrade":
						var upgradeSlot:int = message.getInt(0);
						if (_player.credits >= 250) {
							var upItem:Array = _player.armory[upgradeSlot];
							if (upItem && upItem[0] >= 100) {
								_player.credits -= 250;
								
								var seed:int = Math.floor(MathRandom() * 900000000);
								var upBase:int = upItem[0];
								
								upItem[1] = -1;
								upItem[2] = -1;
								upItem[3] = -1;
								
								// Generate randomized upgrades
								upItem[1] = generateUpgrade(upBase, MathRandom() * 90000000);
								if (MathRandom() * 100 > 40) {
									upItem[2] = generateUpgrade(upBase, MathRandom() * 90000000);
									if (MathRandom() * 100 > 70) {
										upItem[3] = generateUpgrade(upBase, MathRandom() * 90000000);
									}
								}
								fixItem(upItem);
								saveProfile();

								// Return upgrade result
								var upgradeConfirm:LocalMessage = new LocalMessage("supgraderesult");
								upgradeConfirm.add(upItem[0], upItem[1], upItem[2], upItem[3]);
								connection.receiveFromServer(upgradeConfirm);

								sendAccount(connection);
								sendArmory(connection);
								logToServer("Upgraded item in slot " + upgradeSlot + " (New upgrades: " + upItem[1] + ", " + upItem[2] + ", " + upItem[3] + ")", "INFO");
							}
						}
						break;

					case "scallsign":
						var newCallsign:String = message.getString(0);
						_player.callsign = newCallsign;
						saveProfile();
						break;

					case "sping":
						connection.receiveFromServer(new LocalMessage("srping"));
						break;
				}
			} else if (connection.roomType == "Game") {
				switch (type) {
					case "glogin":
						// Re-send status and start triggers for multiplayer sync
						var ggo:LocalMessage = new LocalMessage("ggo");
						ggo.add(Math.floor(MathRandom() * 5)); // Random level index
						connection.receiveFromServer(ggo);
						break;

					case "gcheckin":
						// Echo moves back to simulate network updates in multiplayer loop
						var move0:int = message.getInt(0);
						var move1:int = message.getInt(1);
						var move2:int = message.getInt(2);
						var hash:int = message.getInt(3);
						
						var gupdate:LocalMessage = new LocalMessage("gupdate");
						gupdate.add(1); // increment clock
						gupdate.add(move0);
						gupdate.add(move1);
						gupdate.add(move2);
						// Bot's dummy moves
						gupdate.add(0);
						gupdate.add(0);
						gupdate.add(0);
						connection.receiveFromServer(gupdate);
						break;

					case "ggameover":
						// Send end game results
						var resultsList:Array = [];
						for (i = 0; i < message.length; i++) {
							resultsList.push(message.getInt(i));
						}
						var myResult:int = resultsList[0]; // Victory = 1

						if (_player.rating < 1000) _player.rating = 1000;
						if (myResult == 1) {
							_player.wins += 1;
							_player.rating += 15;
						} else {
							_player.losses += 1;
							_player.rating -= 10;
						}
						saveProfile();

						var gresult:LocalMessage = new LocalMessage("gresult");
						gresult.add(myResult);
						connection.receiveFromServer(gresult);
						break;
				}
			}
		}

		private function sendServiceInitData(connection:LocalConnection):void {
			if (!_player) {
				_player = createNewProfile("GuestPlayer");
			}
			if (_player.credits == undefined) _player.credits = 500;
			if (_player.stations == undefined) _player.stations = MAX_STATIONS;
			if (_player.maxinventory == undefined) _player.maxinventory = 50;
			if (_player.wins == undefined) _player.wins = 0;
			if (_player.losses == undefined) _player.losses = 0;
			if (_player.rating == undefined) _player.rating = 1000;
			if (_player.platinum == undefined) _player.platinum = 30;
			if (_player.classlock == undefined) _player.classlock = 0;
			if (_player.dangerClass == undefined) _player.dangerClass = 0;
			if (_player.campaignseed == undefined) _player.campaignseed = 0;
			if (_player.campaignstart == undefined) _player.campaignstart = -1;
			if (_player.campaignstart == -1) {
				generateCampaign(_player, _player.classlock);
				saveProfile();
			}

			var i:int;
			if (!_player.armory) {
				_player.armory = [];
			}
			while (_player.armory.length < _player.maxinventory) {
				_player.armory.push([-1, -1, -1, -1]);
			}
			for (i = 0; i < _player.armory.length; i++) {
				if (!(_player.armory[i] is Array) || _player.armory[i].length < 4) {
					_player.armory[i] = [-1, -1, -1, -1];
				}
			}
			if (!_player.equip) {
				_player.equip = [];
			}
			while (_player.equip.length < 21) {
				_player.equip.push(-1);
			}
			if (!_player.campaign) {
				_player.campaign = [];
			}
			while (_player.campaign.length < 36) {
				_player.campaign.push(0);
			}
			if (!_player.prizes) {
				_player.prizes = [];
			}
			while (_player.prizes.length < 36) {
				_player.prizes.push([-1, -1, -1, -1]);
			}
			for (i = 0; i < 36; i++) {
				if (!(_player.prizes[i] is Array) || _player.prizes[i].length < 4) {
					_player.prizes[i] = [-1, -1, -1, -1];
				}
			}

			sendAccount(connection);
			sendArmory(connection);
			sendEquip(connection);
			sendCampaign(connection);
			sendPrices(connection);
			sendVault(connection);
			sendVaultClock(connection);
			sendPacks(connection);
			sendPlatinum(connection);
		}

		private function sendAccount(connection:LocalConnection):void {
			var todayDay:int = new Date().getDate();
			var bonusAvailable:int = (_player.lastbonus != todayDay) ? 1 : 0;
			
			var msg:LocalMessage = new LocalMessage("sstats");
			msg.add(_player.credits);
			msg.add(_player.stations);
			msg.add(_player.maxinventory);
			msg.add(bonusAvailable);
			msg.add(_player.rating);
			msg.add(_player.wins);
			msg.add(_player.losses);
			connection.receiveFromServer(msg);
		}

		private function sendPlatinum(connection:LocalConnection):void {
			var msg:LocalMessage = new LocalMessage("splat");
			msg.add(_player.platinum);
			connection.receiveFromServer(msg);
		}

		private function sendArmory(connection:LocalConnection):void {
			var msg:LocalMessage = new LocalMessage("srarmory");
			for (var i:int = 0; i < _player.armory.length; i++) {
				var item:Array = _player.armory[i];
				msg.add(item[0]);
				msg.add(item[1]);
				msg.add(item[2]);
				msg.add(item[3]);
			}
			connection.receiveFromServer(msg);
		}

		private function sendEquip(connection:LocalConnection):void {
			var msg:LocalMessage = new LocalMessage("srequip");
			for (var i:int = 0; i < _player.equip.length; i++) {
				msg.add(_player.equip[i]);
			}
			connection.receiveFromServer(msg);
		}

		private function sendCampaign(connection:LocalConnection):void {
			var msg:LocalMessage = new LocalMessage("srcampaign");
			msg.add(_player.campaignseed);
			msg.add(_player.dangerClass);
			msg.add(_player.classlock);
			msg.add(_player.campaignstart);
			
			var i:int;
			for (i = 0; i < 36; i++) {
				msg.add(_player.campaign[i]);
			}
			for (i = 0; i < 36; i++) {
				var prize:Array = _player.prizes[i];
				msg.add(prize[0]);
				msg.add(prize[1]);
				msg.add(prize[2]);
				msg.add(prize[3]);
			}
			connection.receiveFromServer(msg);
		}

		private function sendPrices(connection:LocalConnection):void {
			var msg:LocalMessage = new LocalMessage("srprices");
			for (var i:int = 0; i < _prices.length; i++) {
				msg.add(_prices[i][0]); // Credits
				msg.add(_prices[i][1]); // Platinum
			}
			connection.receiveFromServer(msg);
		}

		private function sendVault(connection:LocalConnection):void {
			var periodMinutes:int = (_config && _config.store_refresh_period_minutes) ? _config.store_refresh_period_minutes : 60;
			var currentPeriod:int = Math.floor(new Date().time / (1000 * 60 * periodMinutes));
			if (_vaultHour == 0) {
				_vaultHour = currentPeriod;
			}
			if (currentPeriod != _vaultHour) {
				_vaultHour = currentPeriod;
				refreshVault();
			}

			var msg:LocalMessage = new LocalMessage("srvault");
			for (var i:int = 0; i < _vault.length; i++) {
				msg.add(_vault[i][0]);
				msg.add(_vault[i][1]);
				msg.add(_vault[i][2]);
				msg.add(_vault[i][3]);
			}
			connection.receiveFromServer(msg);
		}

		private function sendPacks(connection:LocalConnection):void {
			var msg:LocalMessage = new LocalMessage("srpacks");
			for (var i:int = 0; i < _packs.length; i++) {
				var p:Object = _packs[i];
				for (var j:int = 0; j < 5; j++) {
					var item:Array = p.items[j];
					msg.add(item[0]);
					msg.add(item[1]);
					msg.add(item[2]);
					msg.add(item[3]);
				}
				msg.add(p.price);
				msg.add(p.name);
			}
			connection.receiveFromServer(msg);
		}

		private function sendVaultClock(connection:LocalConnection):void {
			var periodMinutes:int = (_config && _config.store_refresh_period_minutes) ? _config.store_refresh_period_minutes : 60;
			var currentPeriod:int = Math.floor(new Date().time / (1000 * 60 * periodMinutes));
			if (_vaultHour == 0) {
				_vaultHour = currentPeriod;
			}
			if (currentPeriod != _vaultHour) {
				_vaultHour = currentPeriod;
				refreshVault();
			}
			
			var totalMinutes:int = Math.floor(new Date().time / (1000 * 60));
			var elapsedMinutesInPeriod:int = totalMinutes % periodMinutes;
			var minutesRemaining:int = periodMinutes - elapsedMinutesInPeriod;
			
			var hoursRemaining:int = Math.floor(minutesRemaining / 60);
			var minutesRemainingInHour:int = minutesRemaining % 60;
			
			var msg:LocalMessage = new LocalMessage("svaultclock");
			msg.add(hoursRemaining); // Hours remaining
			msg.add(minutesRemainingInHour); // Minutes remaining
			connection.receiveFromServer(msg);
		}

		private function setStations(profile:Object):void {
			// Fast refill stations offline
			profile.stations = MAX_STATIONS;
		}

		private function refreshVault(isForced:Boolean = false):void {
			var periodMinutes:int = (_config && _config.store_refresh_period_minutes) ? _config.store_refresh_period_minutes : 60;
			var seed:uint;
			if (isForced) {
				seed = uint(new Date().time) & 0x7FFFFFFF;
			} else {
				seed = uint(Math.floor(new Date().time / (1000 * 60 * periodMinutes))) & 0x7FFFFFFF;
			}
			seedRNG(seed);

			// Populate shop vault with 11 random items
			for (var i:int = 0; i < 11; i++) {
				var itemId:int = generateRandomItem(0, MathRandom() * 90000000);
				_vault[i][0] = itemId;
				_vault[i][1] = -1;
				_vault[i][2] = -1;
				_vault[i][3] = -1;
				
				// 70% chance of getting randomized upgrades
				if (MathRandom() * 10 > 2) {
					_vault[i][1] = generateUpgrade(itemId, MathRandom() * 90000000);
					if (MathRandom() * 10 > 2) {
						_vault[i][2] = generateUpgrade(itemId, MathRandom() * 90000000);
						if (MathRandom() * 10 > 6) {
							_vault[i][3] = generateUpgrade(itemId, MathRandom() * 90000000);
						}
					}
				}
				fixItem(_vault[i]);
			}

			// Notify all active connections
			if (_connections) {
				for (var j:int = 0; j < _connections.length; j++) {
					sendVault(_connections[j]);
					sendVaultClock(_connections[j]);
				}
			}
		}

		private function addItemToProfile(p:Object, a:int, b:int, c:int, d:int):void {
			for (var i:int = 0; i < p.armory.length; i++) {
				if (p.armory[i][0] == -1) {
					p.armory[i][0] = a;
					p.armory[i][1] = b;
					p.armory[i][2] = c;
					p.armory[i][3] = d;
					break;
				}
			}
		}

		private function checkFreeSlots(p:Object, spots:int):Boolean {
			var freeCount:int = 0;
			for (var i:int = 0; i < p.maxinventory; i++) {
				if (p.armory[i][0] == -1) {
					freeCount++;
				}
			}
			return (freeCount >= spots);
		}

		private function generateRandomItem(zone:int, seed:Number):int {
			var itemsList:Array = [];
			var i:int;
			
			// Base lists matching the C# switches
			// 100-174 Turrets, 200-249 Fighters, 250-349 Ships, 350+ Structs
			for (i = 100; i < 112; i++) itemsList.push(i);
			for (i = 113; i < 115; i++) itemsList.push(i);
			for (i = 116; i < 118; i++) itemsList.push(i);
			for (i = 150; i < 151; i++) itemsList.push(i);
			for (i = 152; i < 154; i++) itemsList.push(i);
			for (i = 175; i < 184; i++) itemsList.push(i);
			for (i = 200; i < 211; i++) itemsList.push(i);
			for (i = 214; i < 216; i++) itemsList.push(i);
			for (i = 250; i < 262; i++) itemsList.push(i);
			for (i = 263; i < 266; i++) itemsList.push(i);
			for (i = 300; i < 304; i++) itemsList.push(i);
			for (i = 306; i < 309; i++) itemsList.push(i);
			for (i = 311; i < 317; i++) itemsList.push(i);

			if (zone == 0 || zone == 2 || zone == 3) { // Advanced Zones
				for (i = 350; i < 361; i++) {
					if (MathRandom() > 0.5) itemsList.push(i);
				}
				for (i = 361; i < 369; i++) {
					if (MathRandom() > 0.9) itemsList.push(i);
				}
				for (i = 369; i < 380; i++) {
					if (MathRandom() > 0.5) itemsList.push(i);
				}
			}
			
			var randIdx:int = Math.floor(MathRandom() * itemsList.length);
			return itemsList[randIdx];
		}

		private function generateUpgrade(itemId:int, seed:Number):int {
			var upgrades:Array = [];
			var i:int;
			
			var category:int = getUpgradeCategory(itemId);
			switch (category) {
				case 0: // Turrets General
					for (i = 6; i < 19; i++) upgrades.push(i);
					for (i = 40; i < 52; i++) upgrades.push(i);
					upgrades.push(80);
					break;
				case 1: // Turrets Special Gun
					for (i = 6; i < 11; i++) upgrades.push(i);
					for (i = 40; i < 52; i++) upgrades.push(i);
					upgrades.push(80);
					break;
				case 8: // Fighters Special Gun
					for (i = 1; i < 11; i++) upgrades.push(i);
					for (i = 40; i < 50; i++) upgrades.push(i);
					upgrades.push(80);
					break;
				case 9: // Fighters General
					for (i = 1; i < 19; i++) upgrades.push(i);
					for (i = 40; i < 50; i++) upgrades.push(i);
					upgrades.push(80);
					break;
				case 10: // Ships General
					for (i = 1; i < 19; i++) upgrades.push(i);
					for (i = 40; i < 50; i++) upgrades.push(i);
					upgrades.push(60);
					upgrades.push(80);
					break;
				case 11: // Ships Special Gun
					for (i = 1; i < 11; i++) upgrades.push(i);
					for (i = 40; i < 50; i++) upgrades.push(i);
					upgrades.push(60);
					upgrades.push(80);
					break;
				case 12: // Carriers
					for (i = 1; i < 19; i++) upgrades.push(i);
					for (i = 21; i < 29; i++) upgrades.push(i);
					for (i = 37; i < 40; i++) upgrades.push(i);
					for (i = 40; i < 50; i++) upgrades.push(i);
					upgrades.push(80);
					break;
				case 13: // Special Carriers
					for (i = 1; i < 19; i++) upgrades.push(i);
					for (i = 37; i < 40; i++) upgrades.push(i);
					for (i = 40; i < 50; i++) upgrades.push(i);
					upgrades.push(80);
					break;
				default:
					return -1;
			}
			
			var randIdx:int = Math.floor(MathRandom() * upgrades.length);
			return upgrades[randIdx];
		}

		private function getUpgradeCategory(s:int):int {
			if (s >= 100 && s < 175) {
				if (s == 110 || s == 111 || s == 113 || s == 114 || s == 117 || s == 151 || s == 152 || s == 153) return 1;
				return 0;
			}
			if (s >= 200 && s < 250) {
				if (s == 204 || s == 205 || s == 209 || s == 210 || s == 215) return 8;
				return 9;
			}
			if (s >= 250 && s < 350) {
				if (s == 257 || s == 260 || s == 263 || s == 264 || s == 265 || s == 303 || s == 310 || s == 311 || s == 313) return 11;
				if (s == 252 || s == 256 || s == 301 || s == 302 || s == 308 || s == 312) return 12;
				if (s == 261 || s == 316) return 13;
				return 10;
			}
			return -1;
		}

		private function fixItem(a:Array):void {
			var sa:int, sb:int;
			for (var i:int = 2; i < 4; i++) {
				sa = a[i];
				for (var j:int = 1; j < 4; j++) {
					if (j != i) {
						sb = a[j];
						if (sb == sa && sa != -1) { // Duplicate mods
							sa = -1;
							a[i] = -1;
						}
						if (sb > 0 && sb < 6 && sa > 0 && sa < 6) { // Multiple engines
							sa = -1;
							a[i] = -1;
						}
						if (sb > 5 && sb < 11 && sa > 5 && sa < 11) { // Multiple shields
							sa = -1;
							a[i] = -1;
						}
						if (sb > 10 && sb < 19 && sa > 10 && sa < 19) { // Multiple ammo
							sa = -1;
							a[i] = -1;
						}
						if (sb > 20 && sb < 37 && sa > 20 && sa < 37) { // Multiple hangar mods
							sa = -1;
							a[i] = -1;
						}
					}
				}
				if (a[0] >= 350 || (a[0] >= 175 && a[0] < 200)) { // Special structures / non-upgradable
					a[1] = -1;
					a[2] = -1;
					a[3] = -1;
				}
			}
		}

		private function getCreditPrice(a:int, b:int, c:int, d:int):int {
			var p:int = 0;
			if ((a - 100) > -1 && (a - 100) < 350) {
				p = _prices[a - 100][0];
			}
			if (b >= 0) p *= 3;
			if (c >= 0) p *= 3;
			if (d >= 0) p *= 3;
			return p;
		}

		private function giveMissionPrize(connection:LocalConnection, missionId:int):void {
			var prizeItem:Array = _player.prizes[missionId];
			if (prizeItem && prizeItem[0] > 0) {
				var itemId:int = prizeItem[0];
				
				if (itemId < 1000 && checkFreeSlots(_player, 1)) {
					addItemToProfile(_player, itemId, prizeItem[1], prizeItem[2], prizeItem[3]);
					saveProfile();
					
					var prizeMsg:LocalMessage = new LocalMessage("prize");
					prizeMsg.add(3); // Loot item
					prizeMsg.add(itemId);
					prizeMsg.add(prizeItem[1]);
					prizeMsg.add(prizeItem[2]);
					prizeMsg.add(prizeItem[3]);
					connection.receiveFromServer(prizeMsg);
				} else if (itemId >= 1000) {
					var creditPrize:int = itemId - 1000;
					_player.credits += creditPrize;
					saveProfile();
					
					var credPrizeMsg:LocalMessage = new LocalMessage("prize");
					credPrizeMsg.add(1); // Currency
					credPrizeMsg.add(creditPrize);
					credPrizeMsg.add(0);
					credPrizeMsg.add(0);
					credPrizeMsg.add(0);
					connection.receiveFromServer(credPrizeMsg);
				}
			}
		}

		private function completeCampaign(connection:LocalConnection):void {
			var currentDanger:int = _player.dangerClass;
			var platReward:int = 2 * currentDanger + 2;
			if (platReward > 30) platReward = 30;
			
			_player.platinum += platReward;
			
			// Unlock next danger tier
			if (_player.dangerClass == _player.classlock) {
				_player.classlock += 1;
				generateCampaign(_player, _player.classlock);
			} else {
				generateCampaign(_player, _player.dangerClass + 1);
			}
			saveProfile();
			
			var platPrizeMsg:LocalMessage = new LocalMessage("prize");
			platPrizeMsg.add(2); // Platinum
			platPrizeMsg.add(platReward);
			platPrizeMsg.add(0);
			platPrizeMsg.add(0);
			platPrizeMsg.add(0);
			connection.receiveFromServer(platPrizeMsg);
		}

		private function generateCampaign(p:Object, dangerclass:int):void {
			var i:int, j:int;
			p.campaignseed = Math.floor(Math.random() * 9999999);
			p.dangerClass = dangerclass;

			// Generate 6x6 campaign map (1 = active mission node, 0 = gap)
			for (i = 0; i < 36; i++) {
				p.campaign[i] = 1;
			}
			
			// Poke holes in map layout
			var gaps:int = 9;
			var timeout:int = 500;
			while (gaps > 0 && timeout > 0) {
				var xx:int = Math.floor(Math.random() * 6);
				var yy:int = Math.floor(Math.random() * 6);
				var safe:Boolean = true;
				for (i = -1; i < 2; i++) {
					for (j = -1; j < 2; j++) {
						if (xx + i >= 0 && xx + i <= 5 && yy + j >= 0 && yy + j <= 5) {
							if (p.campaign[xx + i + (yy + j) * 6] == 0) {
								safe = false;
							}
						}
					}
				}
				if (safe) {
					p.campaign[xx + yy * 6] = 0;
					gaps--;
				}
				timeout--;
			}

			// Choose starting node
			p.campaignstart = -1;
			for (i = 0; i < 36; i++) {
				if (p.campaign[i] == 1) {
					p.campaignstart = i;
					break;
				}
			}

			// Generate mission rewards (prizes)
			var itemclass:int = dangerclass;
			var rareodds:int = 70 - 2 * (dangerclass - 3);
			if (dangerclass == 0) {
				rareodds = 100; itemclass = 1;
			} else if (dangerclass == 1) {
				rareodds = 80; itemclass = 2;
			} else if (dangerclass == 2) {
				rareodds = 75;
			} else if (dangerclass == 3) {
				rareodds = 70;
			}

			for (i = 0; i < 36; i++) {
				var reward:Array = p.prizes[i];
				
				// 70% chance of random weapon/ship, otherwise currency reward
				if (MathRandom() * 100 <= 70) {
					reward[0] = generateRandomItem(itemclass, MathRandom() * 900000);
					reward[1] = -1;
					reward[2] = -1;
					reward[3] = -1;
					
					// Upgrade chance based on odds
					if (dangerclass > 0 && MathRandom() * 100 > rareodds) {
						reward[1] = generateUpgrade(reward[0], MathRandom() * 900000);
						if (dangerclass > 1 && MathRandom() * 100 > 70) {
							reward[2] = generateUpgrade(reward[0], MathRandom() * 900000);
							if (dangerclass > 2 && MathRandom() * 100 > 70) {
								reward[3] = generateUpgrade(reward[0], MathRandom() * 900000);
							}
						}
					}
					fixItem(reward);
				} else {
					// Currency reward (1000 + base reward depending on dangerclass)
					reward[0] = 1000 + 75 + (25 * dangerclass) + Math.floor(MathRandom() * 100);
					reward[1] = -1;
					reward[2] = -1;
					reward[3] = -1;
				}
			}
		}
	}
}
