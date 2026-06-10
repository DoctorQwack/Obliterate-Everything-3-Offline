package
{
	import flash.events.Event
	import playerio.*
	
	public class NetStuff
	{
		public var conn:Connection;
		public var myId:int
		private var mom;
		public var c;
		public var currentroom:int = 0;
		public var pinged:Boolean = true;
		public var matchcode:String = "";
		public var privatematch:Boolean = false;
		
		public function NetStuff(m)
		{
			mom = m;
			
			if(mom.lockmode == 0){
				PlayerIO.connect(
					mom.stage,							//Referance to stage
					"oe3-hhlfzgqgj0sqfwiil8jj4w",		//Game id (Get your own at playerio.com. 1: Create user, 2:Goto admin pannel, 3:Create game, 4: Copy game id inside the "")
					"public",							//Connection id, default is public
					"GuestUser",						//Username
					"",									//User auth. Can be left blank if authentication is disabled on connection
					null,								//Current PartnerPay partner.
					handleConnect,						//Function executed on successful connect
					handleError							//Function executed if we recive an error
				);  
			}
			if(mom.lockmode == 1){
				 
				//Get Kongregate user credentials
				var userid:String = mom.kongregate.services.getUserId();
				var token:String = mom.kongregate.services.getGameAuthToken();
				//var username:String = kongregate.services.getUsername();
				
				mom.username = "kong" + userid;
				mom.userpassword = "kong" + userid;
				//Connect to Player.IO
				PlayerIO.quickConnect.kongregateConnect(
					mom.stage,
					"oe3-hhlfzgqgj0sqfwiil8jj4w",
					userid,
					token,
					handleConnectK,
					handleError
				);
			}
		}
		
		private function handleConnect(client:Client):void{
			trace("Successfully connected to player.io");
			
			c = client;
			//DoRooms(2);
		}
		
		private function handleConnectK(client:Client):void{
			trace("Successfully connected to player.io");
			
			c = client;
			mom.createaccount = true;
			DoRooms(3);
		}
		
		public function DoRooms(s:int)
		{
			var roomstring:String = "";
			if(s == 1){ //GAME
				c.multiplayer.createJoinRoom(
					mom.gameroom,							//Room id. If set to null a random roomid is used
					"Game",								//Game,Matcher,Service The game type started on the server
					true,								//Should the room be visible in the lobby?
					{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
					{},									//User join data
					GhandleJoin,						//Function executed on successful joining of the room
					GhandleError							//Function executed if we got a join error
				);
			}
			if(s == 2){ //MATCHER
				c.multiplayer.createJoinRoom(
					"matcher",							//Room id. If set to null a random roomid is used
					"Matcher",							//Game,Matcher,Service The game type started on the server
					true,								//Should the room be visible in the lobby?
					{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
					{},									//User join data
					MhandleJoin,						//Function executed on successful joining of the room
					MhandleError							//Function executed if we got a join error
				);
			}
			if(s == 3){ //Service
				c.multiplayer.createJoinRoom(
					"$service-room$",						//Room id. If set to null a random roomid is used
					"Service",							//Game,Matcher,Service The game type started on the server
					true,								//Should the room be visible in the lobby?
					{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
					{},									//User join data
					ShandleJoin,						//Function executed on successful joining of the room
					ShandleError							//Function executed if we got a join error
				);
			}
			if(s == 4){ //PRIVATE MATCHER
				roomstring = "matcherp" + matchcode;
				trace(roomstring);
				c.multiplayer.createJoinRoom(
					roomstring,		        //Room id. If set to null a random roomid is used
					"Matcher",							//Game,Matcher,Service The game type started on the server
					true,								//Should the room be visible in the lobby?
					{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
					{},									//User join data
					MhandleJoin,						//Function executed on successful joining of the room
					MhandleError							//Function executed if we got a join error
				);
			}
		}
		
		//SERVICE**********
		
		private function ShandleJoin(connection:Connection):void{
			trace("Successfully connected to the service server");
			conn = connection;
			mom.freezecounter = 0;
			if(mom.GameState != 2){
				currentroom = 3;
				if(mom.loggedon == false && mom.createaccount == true && mom.lockmode == 0){
					trace("Creating account...");
					conn.send("screateaccount",mom.username,mom.userpassword);
				}
				if(mom.createaccount == false && mom.lockmode == 0){
					trace("Logging on...");
					conn.send("slogin",mom.username,mom.userpassword);
				}
				if(mom.lockmode == 1){
					trace("Creating Kong account...");
					conn.send("skong",mom.username,mom.userpassword);
				}
			}
			if(mom.GameState == 2){
				//DISCONNECT RECOVERY
				pinged = true;
				mom.freezecounter = 0;
				trace("Disconnect Recovery");
				if(mom.lockmode == 0){
					trace("Logging on...");
					conn.send("slogin",mom.username,mom.userpassword);
					conn.send("sfixmission",mom.missions.nextsun);
					trace(mom.missions.nextsun);
				}
				if(mom.lockmode == 1){
					trace("Creating Kong account...");
					conn.send("skong",mom.username,mom.userpassword);
					conn.send("sfixmission",mom.missions.nextsun);
				}
			}
			connection.addMessageHandler("screated", function(m:Message){
				trace("Successfully created account!");
				mom.loggedon = true;
				mom.createaccount = false;
				mom.SwitchScreen(4);
				if(mom.lockmode == 1){
					SendCallsign();
				}
			})
			connection.addMessageHandler("sloggedon", function(m:Message){
				trace("Successfully logged on!");
				mom.loggedon = true;
				if(mom.GameState != 2){
					if(mom.GameState != 4){
						mom.SwitchScreen(4);
					}
					if(mom.lockmode == 1){
						SendCallsign();
					}
				}
				if(mom.GameState == 2){
					trace("Logged on!");
					if(mom.gui != null){
						mom.gui.guidisctxt.visible = false;
					}
				}
			})
			connection.addMessageHandler("sreboot", function(m:Message){
				mom.discflag = 1;
				mom.roomflag = 3;
			})
			connection.addMessageHandler("snametaken", function(m:Message){
				mom.discflag = 1;
				mom.accountscreen.visible = true;
				trace("Username taken");
			})
			connection.addMessageHandler("sstats", function(m:Message, c:int, s:int, inv:int, b:int, r:int, w:int, l:int){
				trace("Received Stats");
				mom.account.credits = c;
				mom.account.stations = s;
				mom.account.maxinventory = inv;
				mom.account.bonus = b;
				if(b != 0 && mom.basescreen != null){
					mom.basescreen.knobexclam.visible = true;
				}
				mom.account.rating = r;
				mom.account.wins = w;
				mom.account.losses = l;
				if(mom.lockmode == 1 && w + l >= 5){
					mom.kongregate.stats.submit("Rating",r);
				}
				if(mom.lockmode == 1){
					mom.kongregate.stats.submit("Wins",w);
				}
			})
			connection.addMessageHandler("splat", function(m:Message, p:int){
				trace("Received Plat");
				mom.account.platinum = p;
			})
			connection.addMessageHandler("srarmory", function(m:Message){
				var i:int;
				trace("Armory Received");
				mom.account.armory = new Array();
				mom.account.armorymap = new Array();
				for(i = 0; i < m.length / 4; i++){
					mom.account.PushArmory([m.getInt(i*4),m.getInt(i*4 + 1),m.getInt(i*4 + 2),m.getInt(i*4 + 3)]);
				}
			})
			connection.addMessageHandler("srequip", function(m:Message){
				var i:int;
				trace("Equip received.");
				mom.account.equipmap = new Array();
				for(i = 0; i < m.length; i++){
					mom.account.PushEquip(m.getInt(i));
				}
				if(mom.basescreen != null){
					mom.basescreen.SetupArmoryScreen();
				}
			})
			connection.addMessageHandler("srcampaign", function(m:Message){
				var i:int;
				var j:int = 0;
				trace("Campaign received.");
				
				mom.account.campaignseed = m.getInt(0);
				mom.account.campaigndanger = m.getInt(1);
				mom.account.campaignlock = m.getInt(2);
				mom.account.campaignstart = m.getInt(3);
				
				mom.account.campaign = new Array();
				for(i = 4; i < 6*6+4; i++){
					mom.account.campaign.push(m.getInt(i));
				}
				mom.account.prizes = new Array();
				for(i = 0; i < 6*6; i++){
					mom.account.prizes[i] = new Array();
					for(j = 0; j < 4; j++){
						mom.account.prizes[i].push(m.getInt(i * 4 + j + 6*6 + 4));
					}
				}
				if(mom.GameState == 4 && mom.basescreen != null){
					mom.basescreen.SetupMap();
					mom.basescreen.SetupCampaignScreen();
				}
				
				if(mom.lockmode == 1){
					mom.kongregate.stats.submit("Level",mom.account.campaignlock);
				}
			})
			connection.addMessageHandler("srprices", function(m:Message){
				var i:int;
				var j:int = -1;
				trace("Prices received.");
				mom.account.prices = new Array(350);
				for(i = 0; i < m.length; i++){
					if(i % 2 == 0){
						j++;
						mom.account.prices[j] = new Array();
					}
					mom.account.prices[j].push(m.getInt(i));
					
				}
				if(mom.basescreen != null){
					mom.basescreen.SetupSellScreen(0);
				}
			})
			connection.addMessageHandler("srvault", function(m:Message){
				var i:int;
				trace("Vault received.");
				mom.account.vault = new Array();
				mom.account.vaultmap = new Array();
				for(i = 0; i < m.length / 4; i++){
					mom.account.PushVault([m.getInt(i*4),m.getInt(i*4 + 1),m.getInt(i*4 + 2),m.getInt(i*4 + 3)]);
				}
				if(mom.basescreen != null){
					mom.basescreen.SetupVaultScreen();
				}
			})
			connection.addMessageHandler("srpacks", function(m:Message){
				var i:int;
				var j:int;
				trace("Packs received.");
				mom.account.packs = new Array(10);
				mom.account.packprices = new Array();
				mom.account.packnames = new Array();
				for(j = 0; j < m.length / 22; j++){
					mom.account.packs[j] = new Array();
					for(i = 0; i < 5; i++){
						mom.account.PushPack(j,[m.getInt(j*22 + i*4),m.getInt(j*22 + i*4 + 1),m.getInt(j*22 + i*4 + 2),m.getInt(j*22 + i*4 + 3)]);
					}
					mom.account.packnames.push(m.getString(j*22 + 21));
					mom.account.packprices.push(m.getInt(j*22 + 20));
				}
				if(mom.basescreen != null){
					mom.basescreen.SetupPackScreen(0);
				}
			})
			connection.addMessageHandler("claimed", function(m:Message, p:int){
				trace("Received Bonus " + String(p));
				mom.basescreen.ScreenAnimation(0);
				mom.account.prizea = 5;
				mom.account.prizeb = p;
				mom.account.prizec = 0;
				mom.account.prized = 0;
				mom.account.prizee = 0;
				mom.basescreen.SetupResultScreen(5);
				mom.basescreen.knobexclam.visible = false;
			})
			connection.addMessageHandler("ssold", function(m:Message){
				trace("SOLD");
				mom.basescreen.SetupSellScreen(mom.basescreen.selltab);
			})
			connection.addMessageHandler("sbought", function(m:Message){
				trace("BOUGHT");
			})
			connection.addMessageHandler("snospace", function(m:Message){
				trace("NO SPACE");
				mom.basescreen.ScreenAnimation(9);
			})
			connection.addMessageHandler("sstartmission", function(m:Message){
				trace("Start Mission!");
				mom.flag = 1;
			})
			connection.addMessageHandler("sresultconfirmed", function(m:Message){
				trace("RESULT RECEIVED");
				mom.StartGameOver(m.getInt(0));
			})
			connection.addMessageHandler("supgraderesult", function(m:Message){
				trace("Upgrade receive");
				mom.account.prizea = 4;
				mom.account.prizeb = m.getInt(0);
				mom.account.prizec = m.getInt(1);
				mom.account.prized = m.getInt(2);
				mom.account.prizee = m.getInt(3);
				mom.basescreen.storescreen.visible = false;
				mom.basescreen.SetupResultScreen(4);
			})
			connection.addMessageHandler("sleft", function(m:Message){
				
			})
			connection.addMessageHandler("srping", function(m:Message){
				"Receive Ping";
				pinged = true;
				mom.freezecounter = 0;
			})
			connection.addMessageHandler("svaultclock", function(m:Message, a:int, b:int){
				trace("Vault Clock");
				mom.account.vaulthours = a;
				mom.account.vaultminutes = b;
			})
			connection.addMessageHandler("prize", function(m:Message, a:int, b:int, c:int, d:int, e:int){
				trace("Prize Received!");
				mom.account.prizea = a;
				mom.account.prizeb = b;
				mom.account.prizec = c;
				mom.account.prized = d;
				mom.account.prizee = e;
				if(mom.GameState == 4){
					mom.basescreen.SetupPrizes();
				}
			})
		}
		
		//MATCHER**********
		
		private function MhandleJoin(connection:Connection):void{
			trace("Successfully connected to the matching server");
			conn = connection;
			currentroom = 2;
			mom.loadscreen.loadscreentext.gotoAndStop(2);
			mom.loadscreen.knobcancel.visible = true;
			connection.addMessageHandler("minit", function(m:Message){
																			   
			})
			
			connection.addMessageHandler("mgo", function(m:Message, gr:String){
				mom.gameroom = gr;
				mom.loadscreen.knobcancel.visible = false;
				mom.loadscreen.loadscreentext.gotoAndStop(4);
				mom.discflag = 1;
				mom.roomflag = 1;
			})
			
			connection.addMessageHandler("mleft", function(m:Message){
				
			})
		}
		
		//GAME*************
		
		private function GhandleJoin(connection:Connection):void{
			trace("Sucessfully connected to the multiplayer server");
			conn = connection;
			currentroom = 1;
			//Handle init message
			conn.send("glogin",mom.username,mom.userpassword);
			if(privatematch == true)
			{
				SendPrivate();
			}
			connection.addMessageHandler("ginit", function(m:Message, myid:int){
				//Set my id so we know who we are
				myId = myid
				trace("My ID: " + String(myId));
				//connection.send("activate",target.Id)
			})
			
			connection.addMessageHandler("grarmory", function(m:Message){
				//Receive Armory stuff
				var i:int = 0;
				var j:int = 0;
				var k:int = 0;
				var l:int = 4; //Length of descriptor
				for(i = 0; i < m.length; i++){
					mom.arm[k][j] = m.getInt(i);
					//trace(String(i) + " " + String(mom.arm[k][j]));
					j++;
					if(j == 27 * l){ //Next player
						j = 0;
						k++;
					}
					//INSERT SPECIAL
					if(j == 8 * l){
						mom.arm[k][8*l] = 0; mom.arm[k][8*l + 1] = -1; mom.arm[k][8*l + 2] = -1; mom.arm[k][8*l + 3] = -1;
						j = 9 * l;
					}
					if(j == 16 * l){
						mom.arm[k][16*l] = 5; mom.arm[k][16*l+1] = -1; mom.arm[k][16*l+2] = -1; mom.arm[k][16*l+3] = -1;
						mom.arm[k][17*l] = 25; mom.arm[k][17*l+1] = -1; mom.arm[k][17*l+2] = -1; mom.arm[k][17*l+3] = -1;
						mom.arm[k][18*l] = 10; mom.arm[k][18*l+1] = -1; mom.arm[k][18*l+2] = -1; mom.arm[k][18*l+3] = -1;
						mom.arm[k][19*l] = 15; mom.arm[k][19*l+1] = -1; mom.arm[k][19*l+2] = -1; mom.arm[k][19*l+3] = -1;
						mom.arm[k][20*l] = 20; mom.arm[k][20*l+1] = -1; mom.arm[k][20*l+2] = -1; mom.arm[k][20*l+3] = -1;
						j = 21*l;
					}
				}
				connection.send("gready");
			})
			connection.addMessageHandler("grstats", function(m:Message){
				var i:int = 0;
				var j:int = 0;
				var k:int = 0;
				var l:int = 4; //Length of descriptor
				for(i = 0; i < m.length; i++){
					if(i % 2 == 0){
						mom.playernames.push(m.getString(i));
					}
					if(i % 2 == 1){
						mom.playerratings.push(m.getInt(i));
					}
				}
				if(mom.gui != null){
					mom.gui.playersscreen.pblue.text = String(mom.playerratings[0]) + " " + mom.playernames[0];
					mom.gui.playersscreen.pred.text = String(mom.playerratings[1]) + " " + mom.playernames[1];
					mom.gui.playersscreen.visible = true;
				}
			})
			
			connection.addMessageHandler("ggo", function(m:Message,l:int){
				mom.flag = 1;
				mom.GameMode = 1;
				mom.missions.multlevel = l;
				connection.send("gcheckin",0,0,0,0);
			})
			
			connection.addMessageHandler("gleft", function(m:Message, s:int){
				if(mom.players != null){
					if(mom.players.length >= s){
						if(mom.players[s] != null){
							mom.players[s].dead = true;
						}
					}
				}
			})
			connection.addMessageHandler("glag", function(m:Message){
				var i:int;
				trace("lag");
			})
			
			connection.addMessageHandler("gtrace", function(m:Message){
				trace("TRACE");
			})
			
			connection.addMessageHandler("gupdate", function(m:Message){
				var i:int;
				//trace("clock: " + String(m.getInt(0)));
				for(i = 1; i < m.length; i++){
					mom.rmove[i-1] = m.getInt(i);
				}
				if(mom.GameState == 2){
					mom.DoRMove();
					mom.TickStep();
				}
				if(mom.victoryt != 1){
					//TEST
					if(mom.pausetrick == false){
						connection.send("gcheckin",mom.qumove[0],mom.qumove[1],mom.qumove[2],mom.hash);
						mom.qumove[0] = 0; mom.qumove[1] = 0; mom.qumove[2] = 0;
					}
				}else{
					GameOver(connection);
					mom.victoryt = 1000000;
				}
			})
			
			connection.addMessageHandler("gdesync", function(m:Message){
				mom.ErrorDesync();
			})
			
			connection.addMessageHandler("gresult", function(m:Message, r:int){
				trace("OMG IT WORKED");
				trace(r);
				mom.discflag = 1;
				mom.roomflag = 3;
				mom.StartGameOver(r);
			})
			
			connection.addMessageHandler("prize", function(m:Message, a:int, b:int){
				trace("Prize Received!");
				trace(b);
				mom.account.prizea = a;
				mom.account.prizeb = b;
				if(mom.GameState == 4){
					mom.basescreen.SetupPrizes();
				}
			})
		}
		
		private function handleMessages(m:Message){
			trace("Recived the message", m)
		}
		
		private function handleDisconnect():void{
			trace("Disconnected from server")
			
		}
		
		private function handleError(error:PlayerIOError):void{
			trace("Got", error);
		}
		
		private function MhandleError(error:PlayerIOError):void{
			trace("Got", error);
		}
		
		private function GhandleError(error:PlayerIOError):void{
			trace("Got", error);
		}
		
		private function ShandleError(error:PlayerIOError):void{
			trace("Got", error);
		}
		
		public function GameOver(connection:Connection)
		{
			var mm:Array = new Array();
			var i:int;
			mm.push("ggameover");
			for(i = 1; i < mom.players.length; i++){
				if(mom.players[i].dead == true){
					mm.push(0);
				}else{
					mm.push(1);
				}
			}
			connection.send.apply(null, mm);
			trace("ENDING SENT");
		}
		
		public function SendEquip()
		{
			var mm:Array = new Array();
			var i:int;
			mm.push("stequip");
			for(i = 0; i < mom.account.equipmap.length; i++){
				mm.push(mom.account.equipmap[i]);
			}
			conn.send.apply(null, mm);
			trace("Equip Send");
		}
		
		public function BuyCredits(s:int)
		{
			if(mom.netdelay == 0){
				switch(s)
				{
					case 0:
						if(mom.account.platinum >= 1){
							conn.send("sbuycredits",0);
							mom.sounds[12]++;
						}
					break;
					case 1:
						if(mom.account.platinum >= 10){
							conn.send("sbuycredits",1);
							mom.sounds[12]++;
						}
					break;
					case 2:
						if(mom.account.platinum >= 50){
							conn.send("sbuycredits",2);
							mom.sounds[12]++;
						}
					break;
				}
				mom.netdelay = 20;
			}
		}
		
		public function BuyPlatinum(s:int)
		{
			if(mom.lockmode == 0){
				if(conn != null){
					conn.send("sbuyplatinum", s);
					mom.sounds[12]++;
				}
			}
			if(mom.lockmode == 1){
				var plat:String;
				var p:int = 0;
				switch(s)
				{
					case 0:
						plat = "coins50";
						p = 0;
					break;
					case 1:
						plat = "coins110";
						p = 1;
					break;
					case 2:
						plat = "coins250";
						p = 2;
					break;
					case 3:
						plat = "coins700";
						p = 3;
					break;
					case 4:
						plat = "coins1500";
						p = 4;
					break;
				}
				mom.kongregate.mtx.purchaseItems(
					[plat],                                       //Buy coins
					function(result:Object) {
						if (result.success) {
							conn.send("supdateplatinum");
							mom.sounds[12]++;
						}
					}
				);
			}
		}
		
		public function BuyStations()
		{
			if(mom.account.platinum >= 2 * (mom.account.maxstations - mom.account.stations)){
				conn.send("sbuystations");
				mom.sounds[12]++;
				mom.basescreen.ScreenAnimation(mom.basescreen.lasttab);
			}else{
				mom.basescreen.ScreenAnimation(6);
			}
		}
		
		public function BuyPack()
		{
			if(mom.account.platinum >= 50){
				conn.send("sbuypack");
				mom.sounds[12]++;
				mom.basescreen.ScreenAnimation(mom.basescreen.lasttab);
			}else{
				mom.basescreen.ScreenAnimation(6);
			}
		}
		
		public function BuyItemPack(s:int,c:int)
		{
			var i:int;
			var j:int;
			if(mom.account.platinum >= c){
				j = 0;
				for(i = 0; i < mom.account.armory.length; i++){
					if(mom.account.armory[i] == null){
						j++;
					}
				}
				if(j < 5){
					mom.basescreen.ScreenAnimation(9);
				}else{
					mom.basescreen.SwitchSaleScreenA();
					conn.send("sbuyitempack",s);
				}
				
				//mom.basescreen.ScreenAnimation(mom.basescreen.lasttab);
				trace(s);
			}else{
				mom.basescreen.ScreenAnimation(6);
			}
		}
		
		public function BuyThing(s:int,c:int)
		{
			var mult:int = 1;
			var buy:Boolean = false;
			var p:int;
			var pb:int;
			trace(s);
			if(mom.netdelay == 0){
				p = mom.account.prices[mom.account.vaultmap[s][0]-100][0];
				pb = mom.account.prices[mom.account.vaultmap[s][0]-100][1];
				mult = Math.pow(3,mom.account.vault[s].rarity);
				trace(mult * pb);
				trace(mom.account.vaultmap[s][0]);
				trace(" ");
				if(c == 0 && mom.account.credits >= mult * p){
					buy = true;
				}
				if(c == 0 && mom.account.credits < mult * p){
					mom.basescreen.ScreenAnimation(7);
				}
				if(c == 1 && mom.account.platinum >= mult * pb){
					buy = true;
				}
				if(c == 1 && mom.account.platinum < mult * pb){
					mom.basescreen.ScreenAnimation(6);
					trace("works");
				}
				if(buy == true){
					mom.basescreen.SwitchSaleScreenA();
					conn.send("sbuy",s,c);
					mom.netdelay = 20;
				}
			}
		}
		
		public function ClaimPrize()
		{
			if(mom.account.bonus == 1){
				conn.send("sclaimprize");
				mom.sounds[12]++;
				//mom.basescreen.ScreenAnimation(mom.basescreen.lasttab);
			}else{
				//mom.basescreen.ScreenAnimation(6);
				trace("LOL WRONG");
			}
		}
		
		public function SellThing(s:int,c:int)
		{
			if(mom.netdelay == 0){
				conn.send("ssell",s,c);
				mom.sounds[12]++;
				mom.netdelay = 5;
			}
		}
		
		public function SendSingleResults()
		{
			trace("Send Results");
			conn.send("sfixmission",mom.missions.nextsun);
			if(mom.players[1].dead == false){
				conn.send("sgameover",1);
			}else{
				conn.send("sgameover",0);
			}
		}
		
		public function SendNewCampaign(s:int)
		{
			trace(s);
			conn.send("snewcampaign",s);
		}
		
		public function SendCallsign()
		{
			var s:String;
			s = mom.kongregate.services.getUsername();
			conn.send("scallsign",s);
		}
		
		public function UpgradeThing(s:int)
		{
			trace(s);
			if(mom.netdelay == 0){
				if(mom.account.credits >= 750){
					conn.send("supgrade",s);
					mom.sounds[12]++;
					mom.basescreen.SetupUpgradeScreen();
					mom.netdelay = 20;
				}else{
					mom.basescreen.ScreenAnimation(7);
				}
			}
		}
		
		public function SendPrivate()
		{
			conn.send("gprivate");
		}
		
		public function Ping()
		{
			conn.send("sping");
			pinged = false;
		}
	}
}