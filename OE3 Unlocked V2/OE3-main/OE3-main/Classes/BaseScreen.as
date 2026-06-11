package 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import flash.display.Graphics;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import playerio.OfflineServer;
		
	public class BaseScreen extends MovieClip 
	{
		var mom;
		
		public var ptab:int = 0;
		public var invtab:int = 0;
		public var invtabb:int = 0;
		public var selltab:int = 0;
		public var lasttab:int = 0;
		public var currenttab:int = 0;
		public var upgradeid:int = 0;
		public var salet:int = 0;
		public var saletab:int = 0;
		public var sellid:int = 0;
		
		//System Stuff
		
		var armoryscreen:ArmoryScreen;
		var resultscreen:ResultScreen;
		var invscreen:InvScreen;
		var campaignscreen:CampaignScreen;
		var multiscreen:MultiScreen;
		var privatescreen:PrivateScreen;
		var storescreen:StoreScreen;
		var profilescreen:ProfileScreen;
		var vaultscreen:VaultScreen;
		var packsscreen:PacksScreen;
		var sellscreen:SellScreen;
		var salescreen:SaleScreen;
		var surescreen:SureScreen;
		var upgradescreen:UpgradeScreen;
		var swapplatinumscreen:SwapPlatinumScreen;
		var swapcreditscreen:SwapCreditScreen;
		var swapstationscreen:SwapStationScreen;
		var buypackscreen:BuyPackScreen;
		var newcampaignscreen:NewCampaignScreen;
		var sunpopup:SunPopup;
		public var armdata:ARMData;
		
		var map:Map;
		var menuship:Menuship;
		
		var basebar:BaseBar;
		var knobquickmatch:KnobQuickMatch;
		var knobprivatematch:KnobPrivateMatch;
		var knobarmory:KnobArmory;
		var knobmultiplayer:KnobMultiplayer;
		var knobcampaign:KnobCampaign;
		var knobstore:KnobStore;
		var knobexclam:KnobExclam;
		var knobmute:KnobMute;
		var knobhelp:KnobHelp;
		var knoboe1:KnobOE1;
		var knoboe2:KnobOE2;
		
		var knobpacks:KnobPacks;
		var knobvault:KnobVault;
		var knobsell:KnobSell;
		var knobupgrade:KnobUpgrade;
		
		var packknobs:Array = new Array();
		var equipknobs:Array = new Array();
		var invknobs:Array = new Array();
		var sellboxes:Array = new Array();
		var sellpics:Array = new Array();
		var buyboxes:Array = new Array();
		var buypics:Array = new Array();
		var armstuff:Array = new Array();
		
		var selectedknob;
		//var backdrop:Bitmap;
		var sunbitmap:Bitmap;
		var resultbitmap:Bitmap;
		
		public function BaseScreen(m)
		{
			mom = m;
			
			var i:int;
			var j:int;
			var k:int;
			var p:int;
			var a;
			var b;
			var temp;
			
			/*backdrop = new Bitmap(mom.basebackdrop.bitmapData);
			addChild(backdrop);*/
			
			menuship = new Menuship();
			addChild(menuship);
			menuship.x = .5 * mom.resX;
			menuship.y = .5 * mom.resY;
			
			basebar = new BaseBar();
			addChild(basebar);
			basebar.x = .5 * mom.resX;
			basebar.y = .9 * mom.resY;
			
			multiscreen = new MultiScreen();
			addChild(multiscreen);
			multiscreen.visible = false;
			multiscreen.x = .5 * mom.resX;
			multiscreen.y = .5 * mom.resY;
			multiscreen.ra.gotoAndStop(1);
			multiscreen.rb.gotoAndStop(1);
			
			privatescreen = new PrivateScreen();
			addChild(privatescreen);
			privatescreen.visible = false;
			privatescreen.x = .5 * mom.resX;
			privatescreen.y = .5 * mom.resY;
			privatescreen.knobstart.mom = mom;
			privatescreen.knobc.mom = mom;
			
			knobmute = new KnobMute();
			addChild(knobmute);
			knobmute.x = 0 + .5 * knobmute.width;
			knobmute.y = 0 + .5 * knobmute.height;
			knobmute.mom = mom;
			if(mom.mute == 0){
				knobmute.a.gotoAndStop(4);
			}else{
				knobmute.a.gotoAndStop(1);
			}
			
			knobhelp = new KnobHelp();
			addChild(knobhelp);
			knobhelp.mom = mom;
			knobhelp.x = 0 + .5 * knobhelp.width;//knobpause.x - 42;
			knobhelp.y = 0 + 1.5 * knobhelp.height;
			knobhelp.visible = true;
			
			knoboe1 = new KnobOE1();
			addChild(knoboe1);
			knoboe1.x = 0 + .5 * knoboe1.width;
			knoboe1.y = 200;		
			knoboe1.visible = true;
			
			knoboe2 = new KnobOE2();
			addChild(knoboe2);
			knoboe2.x = 0 + .5 * knoboe2.width;
			knoboe2.y = 200 + knoboe2.height;
			knoboe2.visible = true;
			
			knobquickmatch = multiscreen.knobq;
			knobquickmatch.mom = mom;
			knobprivatematch = multiscreen.knobp;
			knobprivatematch.mom = mom;
			
			knobarmory = basebar.knoba;
			knobarmory.mom = mom;
			
			knobcampaign = basebar.knobc;
			knobcampaign.mom = mom;
			
			knobmultiplayer = basebar.knobm;
			knobmultiplayer.mom = mom;
			
			knobstore = basebar.knobs;
			knobstore.mom = mom;
			
			resultscreen = new ResultScreen();
			addChild(resultscreen);
			resultscreen.visible = false;
			resultscreen.x = .5 * mom.resX;
			resultscreen.y = .5 * mom.resY;
			resultscreen.kok.mom = mom;
			
			resultbitmap = new Bitmap(new BitmapData(64,64));
			resultscreen.addChild(resultbitmap);
			resultbitmap.x = resultscreen.prizeobj.x - 32;
			resultbitmap.y = resultscreen.prizeobj.y - 32;
			
			armoryscreen = new ArmoryScreen();
			addChild(armoryscreen);
			armoryscreen.visible = false;
			armoryscreen.x = .5 * mom.resX;
			armoryscreen.y = .5 * mom.resY;
			j = 0;
			for(i = 0; i < armoryscreen.numChildren; i++){
				a = armoryscreen.getChildAt(i);
				if(a is KnobEquip){
					a.mom = mom;
					if(j < 3){
						a.idb = 6;
					}
					if(j >= 3 && j < 6){
						a.idb = 7;
					}
					if(j >= 6 && j < 8){
						a.idb = 8;
					}
					if(j >= 8 && j < 15){
						a.idb = 4;
					}
					if(j >= 15 && j < 17){
						a.idb = 5;
					}
					if(j >= 17){
						a.idb = 9;
					}
					a.id = j;
					j++;
					equipknobs.push(a);
				}
			}
			SetupArmoryScreen();
			
			invscreen = new InvScreen();
			addChild(invscreen);
			invscreen.visible = false;
			invscreen.x = .5 * mom.resX;
			invscreen.y = .5 * mom.resY;
			invscreen.kx.mom = mom;
			invscreen.ku.mom = mom;
			invscreen.kd.mom = mom;
			j = 0;
			for(i = 0; i < invscreen.numChildren; i++){
				a = invscreen.getChildAt(i);
				if(a is KnobEquip){
					a.mom = mom;
					a.id = j;
					j++;
					invknobs.push(a);
				}
			}
			
			newcampaignscreen = new NewCampaignScreen();
			addChild(newcampaignscreen);
			newcampaignscreen.visible = false;
			newcampaignscreen.x = .5 * mom.resX;
			newcampaignscreen.y = .5 * mom.resY;
			newcampaignscreen.knobstarta.mom = mom;
			newcampaignscreen.ku.mom = mom;
			newcampaignscreen.kd.mom = mom;
			newcampaignscreen.dtxt.text = "1";
			newcampaignscreen.knobx.mom = mom;
			
			sunpopup = new SunPopup();
			addChild(sunpopup);
			sunpopup.visible = false;
			sunpopup.x = .5 * mom.resX;
			sunpopup.y = .5 * mom.resY;
			
			sunbitmap = new Bitmap(new BitmapData(64,64));
			sunpopup.addChild(sunbitmap);
			sunbitmap.x = 16;
			sunbitmap.y = -96;
			
			campaignscreen = new CampaignScreen();
			addChild(campaignscreen);
			campaignscreen.visible = false;
			campaignscreen.x = .5 * mom.resX;
			campaignscreen.y = .5 * mom.resY;
			campaignscreen.cbar.gotoAndStop(1);
			campaignscreen.kb.mom = mom;
			campaignscreen.kb.visible = false;
			
			addChild(sunpopup);
			
			SetupCampaignScreen();
			
			storescreen = new StoreScreen();
			addChild(storescreen);
			storescreen.visible = false;
			storescreen.x = .5 * mom.resX;
			storescreen.y = .5 * mom.resY;
			storescreen.knobplus.mom = mom;
			storescreen.knobplus.id = 10;
			
			knobpacks = storescreen.knobp;
			knobpacks.mom = mom;
			knobvault = storescreen.knobv;
			knobvault.mom = mom;
			knobsell = storescreen.knobs;
			knobsell.mom = mom;
			knobupgrade = storescreen.knobu;
			knobupgrade.mom = mom;
			
			vaultscreen = new VaultScreen();
			storescreen.addChild(vaultscreen);
			vaultscreen.visible = false;
			vaultscreen.x = 0;
			vaultscreen.y = 25;
			j = 0;
			for(i = 0; i < vaultscreen.numChildren; i++){
				a = vaultscreen.getChildAt(i);
				if(a is BuyBox){
					a.knobbt.mom = mom;
					a.knobbt.id = j;
					buyboxes.push(a);
					a.knobe.mom = mom;
					buypics.push(a.knobe)
					buypics[buypics.length - 1].id = j;
					j++;
				}
			}
			
			packsscreen = new PacksScreen();
			storescreen.addChild(packsscreen);
			packsscreen.visible = false;
			packsscreen.x = 0;
			packsscreen.y = 25;
			j = 0;
			for(i = 0; i < packsscreen.numChildren; i++){
				a = packsscreen.getChildAt(i);
				if(a is PackBox){
					a.kbt.mom = mom;
					a.kb.mom = mom;
					packknobs.push(new Array());
					for(j = 0; j < a.numChildren; j++){
						b = a.getChildAt(j);
						if(b is KnobEquip){
							b.mom = mom;
							packknobs[packknobs.length - 1].push(b);
						}
					}
				}
			}
			packsscreen.ku.mom = mom;
			packsscreen.kd.mom = mom;
			
			sellscreen = new SellScreen();
			storescreen.addChild(sellscreen);
			sellscreen.visible = false;
			sellscreen.x = 0;
			sellscreen.y = 25;
			sellscreen.knobsu.mom = mom;
			sellscreen.knobsd.mom = mom;
			j = 0;
			for(i = 0; i < sellscreen.numChildren; i++){
				a = sellscreen.getChildAt(i);
				if(a is SellBox){
					a.knobst.mom = mom;
					a.knobst.id = j;
					a.knobst.cobj.gotoAndStop(1);
					sellboxes.push(a);
					a.knobse.mom = mom;
					a.knobse.id = j;
					sellpics.push(a.knobse);
					j++;
				}
			}
			
			upgradescreen = new UpgradeScreen();
			storescreen.addChild(upgradescreen);
			upgradescreen.visible = false;
			upgradescreen.x = 0;
			upgradescreen.y = 25;
			upgradescreen.ke.mom = mom;
			upgradescreen.kst.mom = mom;
			upgradescreen.ku.mom = mom;
			upgradescreen.kst.price.text = "750";
			upgradescreen.kst.visible = false;
			upgradescreen.ku.visible = false;
			SetupUpgradeScreen();
			
			salescreen = new SaleScreen();
			storescreen.addChild(salescreen);
			salescreen.visible = false;
			salescreen.x = 0;
			salescreen.y = 25;
			
			surescreen = new SureScreen();
			storescreen.addChild(surescreen);
			surescreen.visible = false;
			surescreen.x = 0;
			surescreen.y = 25;
			surescreen.ky.mom = mom;
			surescreen.kn.mom = mom;
			
			profilescreen = new ProfileScreen();
			addChild(profilescreen);
			profilescreen.x = .85 * mom.resX;
			profilescreen.y = 15;
			profilescreen.kpluscredits.mom = mom;
			profilescreen.kpluscredits.id = 0;
			profilescreen.kplusplatinum.mom = mom;
			profilescreen.kplusplatinum.id = 1;
			profilescreen.kplusstations.mom = mom;
			profilescreen.kplusstations.id = 2;
			
			// Dynamic Logout Button
			var logoutBtn:Sprite = new Sprite();
			logoutBtn.graphics.beginFill(0x1C1C24);
			logoutBtn.graphics.drawRoundRect(0, 0, 70, 20, 6, 6);
			logoutBtn.graphics.endFill();
			logoutBtn.buttonMode = true;
			logoutBtn.useHandCursor = true;
			
			var logoutTf:TextFormat = new TextFormat();
			logoutTf.font = "Outfit";
			logoutTf.size = 10;
			logoutTf.color = 0xFFFFFF;
			logoutTf.bold = true;
			logoutTf.align = "center";
			
			var logoutTxt:TextField = new TextField();
			logoutTxt.defaultTextFormat = logoutTf;
			logoutTxt.text = "LOGOUT";
			logoutTxt.width = 70;
			logoutTxt.height = 18;
			logoutTxt.y = 2;
			logoutTxt.selectable = false;
			logoutTxt.mouseEnabled = false;
			logoutBtn.addChild(logoutTxt);
			
			logoutBtn.x = 5;
			logoutBtn.y = knobhelp.y + (0.5 * knobhelp.height) + 10;
			addChild(logoutBtn);
			
			logoutBtn.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {
				logoutBtn.graphics.clear();
				logoutBtn.graphics.beginFill(0xD32F2F); // sleek red hover
				logoutBtn.graphics.drawRoundRect(0, 0, 70, 20, 6, 6);
				logoutBtn.graphics.endFill();
			});
			logoutBtn.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {
				logoutBtn.graphics.clear();
				logoutBtn.graphics.beginFill(0x1C1C24);
				logoutBtn.graphics.drawRoundRect(0, 0, 70, 20, 6, 6);
				logoutBtn.graphics.endFill();
			});
			logoutBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				if (mom.n && mom.n.conn) {
					mom.n.conn.disconnect();
				}
				mom.SwitchScreen(5);
			});
			
			knobexclam = new KnobExclam();
			addChild(knobexclam);
			knobexclam.visible = false;
			knobexclam.x = profilescreen.x - 100;
			knobexclam.y = profilescreen.y + 48;
			knobexclam.mom = mom;
			
			swapplatinumscreen = new SwapPlatinumScreen();
			addChild(swapplatinumscreen);
			swapplatinumscreen.visible = false;
			swapplatinumscreen.x = .5 * mom.resX;
			swapplatinumscreen.y = .5 * mom.resY;
			j = 0;
			for(i = 0; i < swapplatinumscreen.numChildren; i++){
				a = swapplatinumscreen.getChildAt(i);
				if(a is KnobBuyThing){
					a.mom = mom;
					a.id = j;
					j++;
				}
			}
			
			swapcreditscreen = new SwapCreditScreen();
			addChild(swapcreditscreen);
			swapcreditscreen.visible = false;
			swapcreditscreen.x = .5 * mom.resX;
			swapcreditscreen.y = .5 * mom.resY;
			j = 0;
			for(i = 0; i < swapcreditscreen.numChildren; i++){
				a = swapcreditscreen.getChildAt(i);
				if(a is KnobBuyThing){
					a.mom = mom;
					a.id = j;
					j++;
				}
			}
			
			swapstationscreen = new SwapStationScreen();
			addChild(swapstationscreen);
			swapstationscreen.visible = false;
			swapstationscreen.x = .5 * mom.resX;
			swapstationscreen.y = .5 * mom.resY;
			j = 0;
			for(i = 0; i < swapstationscreen.numChildren; i++){
				a = swapstationscreen.getChildAt(i);
				if(a is KnobBuyThing){
					a.mom = mom;
					a.id = j;
					j++;
				}
			}
			
			buypackscreen = new BuyPackScreen();
			addChild(buypackscreen);
			buypackscreen.visible = false;
			buypackscreen.x = .5 * mom.resX;
			buypackscreen.y = .5 * mom.resY;
			for(i = 0; i < buypackscreen.numChildren; i++){
				a = buypackscreen.getChildAt(i);
				if(a is KnobBuyThing){
					a.mom = mom;
				}
			}
			
			armdata = new ARMData();
			addChild(armdata);
			armdata.visible = false;
			armdata.x = .5 * mom.resX;
			armdata.y = .5 * mom.resY;
		}
		
		public function DoStuff()
		{
			if (OfflineServer.getInstance().config && OfflineServer.getInstance().config.force_logout == true) {
				OfflineServer.getInstance().config.force_logout = false;
				if (mom.n && mom.n.conn) {
					mom.n.conn.disconnect();
				}
				mom.SwitchScreen(5);
				return;
			}
			
			var a;
			var i:int;
			var j:int;
			var rpic:int = 1;
			if(salet > 0){
				salet--;
				if(salet == 0){
					SwitchSaleScreenB();
				}
			}
			profilescreen.credittxt.text = String(mom.account.credits);
			profilescreen.platinumtxt.text = String(mom.account.platinum);
			profilescreen.stationtxt.text = String(mom.account.stations);
			
			multiscreen.rtxt.text = String(mom.account.rating);
			if(mom.account.wins + mom.account.losses < 5){
				multiscreen.rtxt.text = "NEWB";
			}
			multiscreen.wtxt.text = String(mom.account.wins);
			multiscreen.ltxt.text = String(mom.account.losses);
			
			rpic = Math.floor((mom.account.rating - 600) / 200) + 2
			if(mom.account.rating < 600){
				rpic = 1
			}
			if(mom.account.wins + mom.account.losses < 5){
				rpic = 1;
			}
			if(rpic > 9){
				rpic = 9;
			}
			multiscreen.ra.gotoAndStop(rpic);
			multiscreen.rb.gotoAndStop(rpic);
			
			var storePeriod:int = 60;
			if (OfflineServer.getInstance().config && OfflineServer.getInstance().config.store_refresh_period_minutes) {
				storePeriod = OfflineServer.getInstance().config.store_refresh_period_minutes;
			}
			var totalMinutes:int = Math.floor(new Date().time / (1000 * 60));
			var elapsedMinutesInPeriod:int = totalMinutes % storePeriod;
			var minutesRemaining:int = storePeriod - elapsedMinutesInPeriod;
			
			mom.account.vaulthours = Math.floor(minutesRemaining / 60);
			mom.account.vaultminutes = minutesRemaining % 60;
			
			if(mom.account.vaulthours > 0){
				vaultscreen.updatetxt.text = "Updating in " + String(mom.account.vaulthours) + "h " + String(mom.account.vaultminutes) + "m";
			}else{
				vaultscreen.updatetxt.text = "Updating in " + String(mom.account.vaultminutes) + "m";
			}
			
			j = 0;
			for(i = 0; i < mom.account.armory.length; i++){
				if(mom.account.armory[i] != null){
					j++;
				}
			}
			armoryscreen.invtxt.text = "Inventory: " + String(j) + "/" + String(mom.account.maxinventory);
			storescreen.invtxt.text = "Inventory: " + String(j) + "/" + String(mom.account.maxinventory);
			
			for(i = 1; i < 12; i++){
				if(i == 1){
					a = armoryscreen;
				}
				if(i == 2){
					a = storescreen;
				}
				if(i == 3){
					a = campaignscreen;
				}
				if(i == 4){
					a = multiscreen;
				}
				if(i == 5){
					a = invscreen;
				}
				if(i == 6){
					a = swapplatinumscreen;
				}
				if(i == 7){
					a = swapcreditscreen;
				}
				if(i == 8){
					a = swapstationscreen;
				}
				if(i == 9){
					a = buypackscreen;
				}
				if(i == 10){
					a = newcampaignscreen;
				}
				if(i == 11){
					a = privatescreen;
				}
				if(a != null && a.visible == true){
					if(a.scaleX < 1){
						a.scaleX = a.scaleX * 1.5;
					}
					if(a.scaleY < 1){
						a.scaleY = a.scaleY * 1.5;
					}
					if(a.scaleX > 1){
						a.scaleX = 1;
					}
					if(a.scaleY > 1){
						a.scaleY = 1;
					}
				}
			}
		}
		
		public function ScreenAnimation(s:int)
		{
			var a;
			lasttab = currenttab;
			currenttab = s;
			mom.helpscreen.visible = false;
			knobhelp.a.gotoAndStop(1);
			swapstationscreen.visible = false;
			swapplatinumscreen.visible = false;
			swapcreditscreen.visible = false;
			multiscreen.visible = false;
			privatescreen.visible = false;
			armoryscreen.visible = false;
			campaignscreen.visible = false;
			storescreen.visible = false;
			resultscreen.visible = false;
			invscreen.visible = false;
			buypackscreen.visible = false;
			newcampaignscreen.visible = false;
			if(s == 1){
				a = armoryscreen;
				SetupArmoryScreen();
			}
			if(s == 2){
				a = storescreen;
			}
			if(s == 3){
				a = campaignscreen;
				SetupMap();
				SetupCampaignScreen();
			}
			if(s == 4){
				a = multiscreen;
			}
			if(s == 5){
				a = invscreen;
			}
			if(s == 6){
				a = swapplatinumscreen;
			}
			if(s == 7){
				a = swapcreditscreen;
			}
			if(s == 8){
				a = swapstationscreen;
				SetupStationRefill();
			}
			if(s == 9){
				a = buypackscreen;
			}
			if(s == 10){
				a = newcampaignscreen;
			}
			if(s == 11){
				a = privatescreen;
			}
			if(s != 0){
				a.visible = true;
				a.scaleX = .25;
				a.scaleY = .25
			}
		}
		
		public function SetupStationRefill()
		{
			if(mom.account.maxstations - mom.account.stations > 0){
				swapstationscreen.pricetxt.text = String(4 * (mom.account.maxstations - mom.account.stations));
				swapstationscreen.stationtxt.text = String(mom.account.maxstations - mom.account.stations);
			}else{
				swapstationscreen.pricetxt.text = "";
				swapstationscreen.stationtxt.text = "";
				swapstationscreen.kbt.lock = true;
				swapstationscreen.kbt.alpha = .25;
			}
		}
		
		public function SetupResultScreen(r:int)
		{
			resultscreen.prizeobj.visible = false;
			resultscreen.prizetxt.visible = false;
			resultbitmap.visible = false;
			resultscreen.modatxt.visible = false;
			resultscreen.modbtxt.visible = false;
			resultscreen.modctxt.visible = false;
			resultscreen.classtxt.visible = false;
			if(r == 0){ //DEFEAT
				resultscreen.rtxt.gotoAndStop(2);
			}
			if(r == 1){ //VICTORY
				resultscreen.rtxt.gotoAndStop(1);
				SetupPrizes();
			}
			if(r == 2){ //DISCONNECT
				resultscreen.rtxt.gotoAndStop(3);
			}
			if(r == 4){ //UPGRADE
				resultscreen.rtxt.gotoAndStop(4);
				SetupPrizes();
			}
			if(r == 5){ //BONUS
				resultscreen.rtxt.gotoAndStop(5);
				SetupPrizes();
			}
			resultscreen.visible = true;
		}
		
		public function SetupPrizes()
		{
			var a;
			var prize:Array;
			if(mom.account.prizea == 0){
				resultscreen.prizeobj.visible = false;
				resultscreen.prizetxt.visible = false;
			}
			if(mom.account.prizea == 1){
				resultscreen.prizeobj.gotoAndStop(1);
				resultscreen.prizeobj.visible = true;
				resultscreen.prizetxt.text = "You have won " + String(mom.account.prizeb) + " credits!";
				resultscreen.prizetxt.visible = true;
			}
			if(mom.account.prizea == 2){
				resultscreen.prizeobj.gotoAndStop(2);
				resultscreen.prizeobj.visible = true;
				resultscreen.prizetxt.text = "You have won " + String(mom.account.prizeb) + " tons of platinum!";
				if(mom.account.prizeb == 1){
					resultscreen.prizetxt.text = "You have won " + String(mom.account.prizeb) + " ton of platinum!";
				}
				resultscreen.prizetxt.visible = true;
			}
			if(mom.account.prizea == 3 || mom.account.prizea == 4){
				prize = new Array();
				prize.push(mom.account.prizeb);
				prize.push(mom.account.prizec);
				prize.push(mom.account.prized);
				prize.push(mom.account.prizee);
				resultscreen.prizeobj.gotoAndStop(2);
				resultscreen.prizeobj.visible = false;
				if(prize[0] < 200){
					a = new StructData(prize);
				}
				if(prize[0] >= 200 && prize[0] < 350){
					a = new ShipData(prize);
				}
				if(prize[0] >= 350){
					a = new TechData(prize);
				}
				mom.l.StoreIcon(a.s[0],a.rarity);
				resultbitmap.bitmapData = mom.l.sslargeicons[a.s[0]][a.rarity];
				resultbitmap.visible = true;
				if(mom.account.prizea == 3){
					resultscreen.prizetxt.text = "You found " + String(a.nametext);
				}
				if(mom.account.prizea == 4){
					resultscreen.prizetxt.text = "You upgraded " + String(a.nametext);
				}
				resultscreen.prizetxt.visible = true;
				resultscreen.modatxt.text = "";
				resultscreen.modbtxt.text = "";
				resultscreen.modctxt.text = "";
				if(a.modtxt.length > 0){
					resultscreen.modatxt.text = "- " + a.modtxt[0];
				}
				if(a.modtxt.length > 1){
					resultscreen.modbtxt.text = "- " + a.modtxt[1];
				}
				if(a.modtxt.length > 2){
					resultscreen.modctxt.text = "- " + a.modtxt[2];
				}
				resultscreen.modatxt.visible = true;
				resultscreen.modbtxt.visible = true;
				resultscreen.modctxt.visible = true;
				resultscreen.classtxt.visible = true;
				if(a.itemclass == 4){
					resultscreen.classtxt.text = "TURRET";
				}
				if(a.itemclass == 5){
					resultscreen.classtxt.text = "AUXILIARY";
				}
				if(a.itemclass == 6){
					resultscreen.classtxt.text = "FIGHTER";
				}
				if(a.itemclass == 7){
					resultscreen.classtxt.text = "MEDIUM SHIP";
				}
				if(a.itemclass == 8){
					resultscreen.classtxt.text = "CAPITAL SHIP";
				}
				if(a.itemclass == 9){
					resultscreen.classtxt.text = "TECHNOLOGY";
				}
			}
			if(mom.account.prizea == 5){
				resultscreen.prizeobj.gotoAndStop(2);
				resultscreen.prizeobj.visible = true;
				resultscreen.prizetxt.text = "Daily bonus of " + String(mom.account.prizeb) + " platinum!";
				resultscreen.prizetxt.visible = true;
			}
			mom.account.prizea = 0;
			mom.account.prizeb = 0;
			mom.account.prizec = 0;
			mom.account.prized = 0;
			mom.account.prizee = 0;
		}
		
		public function SetupUpgradeScreen()
		{
			var i:int;
			var j:int;
			upgradescreen.ke.mom = mom;
			upgradescreen.ke.ref = null;
			upgradescreen.ke.b.bitmapData = new BitmapData(64,64,true,0x00000000);
			upgradescreen.kst.visible = false;
			upgradescreen.ku.visible = false;
		}
		
		public function SetupArmDataPush(s:int, h:int, t:String)
		{
			var tb:TextField;
			var f:TextFormat;
			tb = new TextField();
			f = new TextFormat();
			if(s == 0){
				f.color = 0xBBBBBB
				f.font = "Audiowide";
				f.size = 8;
			}
			if(s == 1){
				f.color = 0xFFFF99
				f.font = "Audiowide";
				f.size = 10;
			}
			if(s == 2){
				f.color = 0xBBBBBB
				f.font = "Audiowide";
				f.size = 9;
			}
			armdata.addChild(tb);
			tb.y = h;
			tb.x = 10;
			tb.text = t;
			tb.width = tb.width + 45;
			tb.setTextFormat(f);
			tb.selectable = false;
			tb.multiline = true;
			tb.wordWrap = true;
			tb.autoSize = TextFieldAutoSize.LEFT;
			if(t.length > 20){
				tb.height = tb.height * 2;
			}
			armstuff.push(tb);
		}
		
		public function SetupArmData(a)
		{
			var i:int;
			var j:int;
			var k:int;
			var h:int;
			var b;
			var t;
			var c:Number;
			var dmod:Number;
			var temp:String;
			var damages:Array;
			var rates:Array;
			var ranges:Array;
			var hplus:int = 10;
			for(i = 0; i < armstuff.length; i++){
				armdata.removeChild(armstuff[i]);
			}
			armstuff = new Array();
			h = armdata.nametxt.y + 20;
			armdata.nametxt.text = a.nametext;
			if(a is ShipData || a is StructData){
				armdata.etxt.text = String(a.costenergy);
				armdata.mtxt.text = String(a.costmetal);
				armdata.epic.y = h + .5 * armdata.epic.height;
				armdata.mpic.y = h + .5 * armdata.mpic.height;
				armdata.etxt.y = h;
				armdata.mtxt.y = h;
				armdata.epic.visible = true;
				armdata.mpic.visible = true;
				armdata.etxt.visible = true;
				armdata.mtxt.visible = true;
				if(armdata.mtxt.text == "0"){
					armdata.mtxt.visible = false;
					armdata.mpic.visible = false;
				}
				h = h + 20;
				if(a.itemclass == 4){
					SetupArmDataPush(1,h, "TURRET");
				}
				if(a.itemclass == 5){
					SetupArmDataPush(1,h, "AUXILIARY");
				}
				if(a.itemclass == 6){
					SetupArmDataPush(1,h, "FIGHTER");
				}
				if(a.itemclass == 7){
					SetupArmDataPush(1,h, "MEDIUM SHIP");
				}
				if(a.itemclass == 8){
					SetupArmDataPush(1,h, "CAPITAL SHIP");
				}
				h = h + 15;
				SetupArmDataPush(2,h, a.desctext);
				h = h + 35;
				//CALC DPS
				damages = new Array();
				rates = new Array();
				ranges = new Array();
				temp = "";
				if(a is ShipData && a.guns.length > 0){
					for(i = 0; i < a.ammos.length; i++){
						b = new ShotData(a.ammos[i]);
						damages.push(b.adamage);
						temp = temp + String(Math.round(b.adamage));
						if(i < a.ammos.length - 1){
							temp = temp + ", ";
						}
					}
					SetupArmDataPush(0,h, "Gun Damage: " + String(temp));
					h = h + hplus;
					if(a.guns.length > 4){
						h = h + hplus;
					}
					temp = ""
					for(i = 0; i < a.guns.length; i++){
						b = new Gun(null,null,a.guns[i],a.ammos[i]);
						c = 600/(((b.gunheat * a.gunheatmod) + b.gunburstmax * b.gunburstheat) / b.gunburstmax);
						rates.push(c);
						ranges.push(b.gunrange);
						temp = temp + String(Math.round(c));
						if(i < a.ammos.length - 1){
							temp = temp + ", ";
						}
					}
					//SetupArmDataPush(0,h, "Rounds/Min: " + String(temp));
					//h = h + hplus;
				}
				if(a.turrets.length > 0){
					temp = "";
					k = a.turrets.length;
					/*if(k > 4){
						k = 4;
					}*/
					for(j = 0; j < a.turrets.length; j++){
						t = new TurretData(a.turrets[j]);
						for(i = 0; i < t.ammos.length; i++){
							b = new ShotData(t.ammos[i]);
							damages.push(b.adamage);
							if(j < k){
								temp = temp + String(Math.round(b.adamage));
							}
							if(i < t.ammos.length - 1){
								temp = temp + ", ";
							}
						}
						if(i < a.turrets.length - 1){
							temp = temp + ", ";
						}
					}
					SetupArmDataPush(0,h, "Turret Damage: " + String(temp));
					if(a.turrets.length >= 4){
						h = h + hplus;
					}
					h = h + hplus;
				}
				if(a.turrets.length > 0){
					temp = "";
					for(j = 0; j < a.turrets.length; j++){
						t = new TurretData(a.turrets[j]);
						for(i = 0; i < t.ammos.length; i++){
							b = new Gun(null,null,t.guns[i],t.ammos[i]);
							c = 600/(((b.gunheat * a.gunheatmod) + b.gunburstmax * b.gunburstheat) / b.gunburstmax);
							rates.push(c);
							ranges.push(b.gunrange);
							temp = temp + String(Math.round(c));
							if(i < t.ammos.length - 1){
								temp = temp + ", ";
							}
						}
					}
					//SetupArmDataPush(0,h, "Turret Rds/min: " + String(temp));
					//h = h + hplus;
				}
				if(damages.length > 0){
					temp = "";
					c = 0;
					for(i = 0; i < damages.length; i++){
						c = c + (damages[i] * rates[i])/60;
					}
					SetupArmDataPush(0,h, "Damage/Second: " + String(Math.round(c)));
					h = h + hplus;
				}
				if(ranges.length > 0){
					c = 0;
					for(i = 0; i < ranges.length; i++){
						if(ranges[i] > c){
							c = ranges[i];
						}
					}
					c = c * a.gunrangemod;
					SetupArmDataPush(0,h, "Range: " + String(Math.round(c)));
					h = h + hplus;
				}
				h = h + hplus;
				//ARMOR
				SetupArmDataPush(0,h, "Armor: " + String(a.armormax));
				h = h + hplus;
				if(a.armorregen > 0){
					SetupArmDataPush(0,h, "Armor Regen: " + String(10 * a.armorregen));
					h = h + hplus;
				}
				if(a.shieldmax > 0){
					SetupArmDataPush(0,h, "Shield: " + String(a.shieldmax));
					h = h + hplus;
				}
				if(a is StructData && a.tacshieldmax > 0){
					SetupArmDataPush(0,h, "Tac Shield: " + String(a.tacshieldmax));
					h = h + hplus;
				}
				if(a.shieldregen > 0){
					SetupArmDataPush(0,h, "Shield Regen: " + String(10 * a.shieldregen));
					h = h + hplus;
				}
				if(a is StructData && a.tacshieldr > 0){
					SetupArmDataPush(0,h, "Shield Radius: " + String(a.tacshieldr));
					h = h + hplus;
				}
				h = h + hplus;
				//ENGINES
				if(a is ShipData && a.thrust > 0){
					SetupArmDataPush(0,h, "Thrust: " + String(Math.round(10 * a.thrust)));
					h = h + hplus;
				}
				if(a is ShipData && a.speedmax > 0){
					SetupArmDataPush(0,h, "Max Speed: " + String(Math.round(10 * a.speedmax)));
					h = h + hplus;
				}
				if(a is ShipData && a.turn > 0){
					SetupArmDataPush(0,h, "Turn: " + String(Math.round(360 * a.turn)) + " deg");
					h = h + hplus;
				}
				if(a is StructData && a.turrets.length > 0){
					b = new TurretData(a.turrets[0]);
					SetupArmDataPush(0,h, "Turret Turn: " + String(Math.round(360 * b.turn)) + " deg");
					h = h + hplus;
					b = null;
				}
				h = h + hplus;
				//EXTRA
				if(a is StructData && a.energy > 0){
					SetupArmDataPush(0,h, "Energy Gen: " + String(10 * a.energy));
					h = h + hplus;
				}
			}else{
				armdata.epic.visible = false;
				armdata.mpic.visible = false;
				armdata.etxt.visible = false;
				armdata.mtxt.visible = false;
				SetupArmDataPush(1,h, "TECHNOLOGY");
				h = h + 15;
				SetupArmDataPush(2,h, a.desctext);
				h = h + 80;
			}
			if(a.modtxt.length > 0){
				h = h + hplus;
				hplus = 12;
				SetupArmDataPush(1,h, "SPECIAL MODS:");
				h = h + hplus;
				for(i = 0; i < a.modtxt.length; i++){
					SetupArmDataPush(1,h, a.modtxt[i]);
					h = h + hplus;
				}
			}
			armdata.armdb.scaleY = h / 200 + .05;
			armdata.visible = true;
		}
		
		public function SetupArmoryScreen()
		{
			var i:int;
			var j:int;
			armoryscreen.knobp.mom = mom;
			armoryscreen.knobp.id = 10;
			for(i = 0; i < equipknobs.length; i++){
				equipknobs[i].ref = null;
				equipknobs[i].b.bitmapData = new BitmapData(64,64,true,0x00000000);
			}
			for(i = 0; i < mom.account.equipmap.length; i++){
				if(mom.account.equipmap[i] >= 0 && mom.account.armory[mom.account.equipmap[i]] != null){
					equipknobs[i].ref = mom.account.armory[mom.account.equipmap[i]];
					mom.l.StoreIcon(equipknobs[i].ref.iconid,equipknobs[i].ref.rarity);
					equipknobs[i].b.bitmapData = mom.l.sslargeicons[equipknobs[i].ref.iconid][equipknobs[i].ref.rarity];
				}
			}
		}
		
		public function SetupCampaignScreen()
		{
			var i:int;
			var j:int;
			var a;
			campaignscreen.lvltxt.text = String(mom.account.campaigndanger + 1);
			campaignscreen.knobnew.mom = mom;
			//campaignscreen.gctxt.text = "Difficulty " + String(mom.account.campaigndanger);
			
			newcampaignscreen.knobstarta.lock = false;
			newcampaignscreen.knobstarta.alpha = 1;
			newcampaignscreen.dtxt.text = String(mom.account.campaigndanger + 1);
			
			if(int(newcampaignscreen.dtxt.text) > mom.account.campaignlock){
				newcampaignscreen.ku.lock = true;
				newcampaignscreen.ku.alpha = .1;
				newcampaignscreen.ku.a.gotoAndStop(1);
			}else{
				newcampaignscreen.ku.lock = false;
				newcampaignscreen.ku.alpha = 1;
			}
			if(int(newcampaignscreen.dtxt.text) == 1){
				newcampaignscreen.kd.lock = true;
				newcampaignscreen.kd.alpha = .1;
				newcampaignscreen.kd.a.gotoAndStop(1);
			}else{
				newcampaignscreen.kd.lock = false;
				newcampaignscreen.kd.alpha = 1;
			}
		}
		
		public function SetupMap()
		{
			var i:int;
			var j:int;
			var c:int;
			var a;
			if(map != null){
				campaignscreen.removeChild(map);
				map = null;
			}
			map = new Map(mom);
			campaignscreen.addChild(map);
			map.x = 0;
			map.y = 0;
			map.GenMap(6,6);
			map.GenLines();
			
			j = 0;
			for(i = 0; i < mom.account.campaign.length; i++){
				if(mom.account.campaign[i] == 2){
					j++;
				}
			}
			c = Math.round(180 * j / mom.account.campaign.length) + 1; //300
			if(c >= 100){
				c = 100;
				campaignscreen.kb.visible = true;
			}else{
				campaignscreen.kb.visible = false;
			}
			campaignscreen.cbar.gotoAndStop(c);
		}
		
		public function SetupPackScreen(a:int)
		{
			var i:int;
			var j:int;
			for(i = 0; i < 3; i++){
				if(mom.account.packs[a+i] != null){
					for(j = 0; j < 5; j++){
						if(mom.account.packs[a+i][j] != null){
							packknobs[i][j].ref = mom.account.packs[a+i][j];
							packknobs[i][j].lock = false;
							mom.l.StoreIcon(mom.account.packs[a+i][j].iconid,mom.account.packs[a+i][j].rarity);
							packknobs[i][j].b.bitmapData = mom.l.sslargeicons[mom.account.packs[a+i][j].iconid][mom.account.packs[a+i][j].rarity];
							packknobs[i][j].b.visible = true;
							packknobs[i][j].alpha = 1;
						}else{
							packknobs[i][j].ref = null;
							packknobs[i][j].lock = true;
							packknobs[i][j].b.bitmapData = new BitmapData(64,64,true,0x00000000);
							packknobs[i][j].b.visible = false;
							packknobs[i][j].alpha = .5;
						}
					}
				}else{
					for(j = 0; j < 5; j++){
						packknobs[i][j].ref = null;
						packknobs[i][j].lock = true;
						packknobs[i][j].b.bitmapData = new BitmapData(64,64,true,0x00000000);
						packknobs[i][j].b.visible = false;
						packknobs[i][j].alpha = .5;
					}
				}
			}
			packsscreen.pa.kb.cobj.gotoAndStop(2);
			packsscreen.pa.kb.price.text = String(mom.account.packprices[a]);
			packsscreen.pa.ptxt.text = mom.account.packnames[a];
			packsscreen.pa.kb.id = a;
			packsscreen.pa.kbt.id = a;
			packsscreen.pb.kb.cobj.gotoAndStop(2);
			packsscreen.pb.kb.price.text = String(mom.account.packprices[a+1]);
			packsscreen.pb.ptxt.text = mom.account.packnames[a+1];
			packsscreen.pb.kb.id = a+1;
			packsscreen.pb.kbt.id = a+1;
			packsscreen.pc.kb.cobj.gotoAndStop(2);
			packsscreen.pc.kb.price.text = String(mom.account.packprices[a+2]);
			packsscreen.pc.ptxt.text = mom.account.packnames[a+2];
			packsscreen.pc.kb.id = a+2;
			packsscreen.pc.kbt.id = a+2;
			
			storescreen.setChildIndex(packsscreen,1);
			ptab = a;
			packsscreen.ku.alpha = 1;
			packsscreen.ku.lock = false;
			packsscreen.kd.alpha = 1;
			packsscreen.kd.lock = false;
			if(a == 0){
				packsscreen.ku.alpha = .1;
				packsscreen.ku.lock = true;
				packsscreen.ku.a.gotoAndStop(1);
			}
			if(a == 3){
				packsscreen.kd.alpha = .1;
				packsscreen.kd.lock = true;
				packsscreen.kd.a.gotoAndStop(1);
			}
		}
		
		public function SetupInvScreen(s:int, a:int)
		{
			var i:int;
			var j:int;
			var k:int;
			var o;
			var stuffsort:Array = new Array();
			var stuff:Array = new Array();
			if(a < 0){
				a = 0;
			}
			for(i = 0; i < invknobs.length; i++){
				invknobs[i].ref = null;
				invknobs[i].lock = true;
				invknobs[i].b.bitmapData = new BitmapData(64,64,true,0x00000000);
				invknobs[i].b.visible = false;
				invknobs[i].alpha = .5;
			}
			j = 0;
			//SORT
			for(i = 0; i < mom.account.armory.length; i++){
				if(mom.account.armory[i] != null && (mom.account.armory[i].itemclass == s || (s == 100 && mom.account.armory[i].rarity == 0 && mom.account.armory[i].itemclass != 5 && mom.account.armory[i].itemclass != 9))){
					o = new Object();
					o.ref = mom.account.armory[i].s[0];
					o.rarity = mom.account.armory[i].rarity;
					o.moda = mom.account.armory[i].s[1];
					o.modb = mom.account.armory[i].s[2];
					o.modc = mom.account.armory[i].s[3];
					o.num = i;
					stuffsort.push(o);
				}
			}
			stuffsort.sortOn(["ref","rarity","moda","modb","modc"], [Array.NUMERIC,Array.NUMERIC,Array.NUMERIC,Array.NUMERIC,Array.NUMERIC]);
			for(i = 0; i < stuffsort.length; i++){
				stuff.push(stuffsort[i].num);
			}
			//
			k = 0;
			for(i = 0; i < stuff.length; i++){
				if(k >= a && j < invknobs.length){
					invknobs[j].ref = mom.account.armory[stuff[i]];
					invknobs[j].idb = stuff[i];
					mom.l.StoreIcon(invknobs[j].ref.iconid,invknobs[j].ref.rarity);
					invknobs[j].b.bitmapData = mom.l.sslargeicons[invknobs[j].ref.iconid][invknobs[j].ref.rarity];
					invknobs[j].lock = false;
					invknobs[j].b.visible = true;
					invknobs[j].alpha = 1;
					j++;
				}
				k++;
			}
			invtab = a;
			invtabb = s;
			invscreen.kd.lock = false;
			invscreen.kd.alpha = 1;
			invscreen.ku.lock = false;
			invscreen.ku.alpha = 1;
			if(a == 0){
				invscreen.ku.lock = true;
				invscreen.ku.alpha = .15;
				invscreen.ku.a.gotoAndStop(1);
			}
			if(a + 19 > k){
				invscreen.kd.lock = true;
				invscreen.kd.alpha = .15;
				invscreen.kd.a.gotoAndStop(1);
			}
		}
		
		public function SetupVaultScreen()
		{
			var i:int;
			var j:int;
			var k:int;
			
			for(i = 0; i < buyboxes.length; i++){
				buyboxes[i].knobbt.ref = null;
				buyboxes[i].knobbt.lock = true;
				buyboxes[i].knobbt.visible = false;
				buyboxes[i].alpha = 0.5;
				buypics[i].b.bitmapData = new BitmapData(64,64,true,0x00000000);
				buypics[i].b.visible = false;
				if(i < mom.account.vault.length && mom.account.vault[i] != null){
					mom.l.StoreIcon(mom.account.vault[i].iconid,mom.account.vault[i].rarity);
					buypics[i].b.bitmapData = mom.l.sslargeicons[mom.account.vault[i].iconid][mom.account.vault[i].rarity];
					buypics[i].b.visible = true;
					buypics[i].ref = mom.account.vault[i];
					buyboxes[i].knobbt.lock = false;
					buyboxes[i].knobbt.visible = true;
					buyboxes[i].knobbt.id = i;
					if(mom.account.vault[i].rarity < 2){
						k = Math.ceil(mom.account.prices[mom.account.vault[i].s[0]-100][0] * Math.pow(3,mom.account.vault[i].rarity));
						buyboxes[i].knobbt.cobj.gotoAndStop(1);
					}else{
						k = Math.ceil(mom.account.prices[mom.account.vault[i].s[0]-100][1] * Math.pow(3,mom.account.vault[i].rarity));
						buyboxes[i].knobbt.cobj.gotoAndStop(2);
					}
					buyboxes[i].knobbt.price.text = String(k);
					buyboxes[i].alpha = 1;
				}
			}
		}
		
		public function SwitchSureScreen()
		{
			vaultscreen.visible = false;
			packsscreen.visible = false;
			sellscreen.visible = false;
			upgradescreen.visible = false;
			surescreen.visible = true;
			salescreen.visible = false;
		}
		
		public function SwitchSaleScreenA()
		{
			vaultscreen.visible = false;
			packsscreen.visible = false;
			sellscreen.visible = false;
			upgradescreen.visible = false;
			surescreen.visible = false;
			salescreen.visible = true;
			salet = 25;
			mom.sounds[12]++;
		}
		
		public function SwitchSaleScreenB()
		{
			vaultscreen.visible = false;
			packsscreen.visible = false;
			sellscreen.visible = false;
			upgradescreen.visible = false;
			surescreen.visible = false;
			salescreen.visible = false;			
			switch(saletab){
				case 0:
					vaultscreen.visible = true;
				break;
				case 1:
					packsscreen.visible = true;
				break;
				case 2:
					sellscreen.visible = true;
				break;
				case 3:
					upgradescreen.visible = true;
				break;
			}
			salet = 0;
		}
		
		public function SetupSellScreen(a:int)
		{
			var i:int;
			var j:int;
			var k:int;
			var o;
			var stuffsort:Array = new Array();
			var stuff:Array = new Array();
			if(a < 0){
				a = 0;
			}
			j = 0;
			for(i = 0; i < mom.account.armory.length; i++){
				if(mom.account.armory[i] != null){
					o = new Object();
					o.ref = mom.account.armory[i].s[0];
					o.rarity = mom.account.armory[i].rarity;
					o.moda = mom.account.armory[i].s[1];
					o.modb = mom.account.armory[i].s[2];
					o.modc = mom.account.armory[i].s[3];
					o.num = i;
					stuffsort.push(o);
				}
			}
			stuffsort.sortOn(["ref","rarity","moda","modb","modc"], [Array.NUMERIC,Array.NUMERIC,Array.NUMERIC,Array.NUMERIC,Array.NUMERIC]);
			for(i = 0; i < stuffsort.length; i++){
				stuff.push(stuffsort[i].num);
				trace(stuffsort[i].ref);
			}
			for(i = 0; i < sellboxes.length; i++){
				sellboxes[i].knobst.ref = null;
				sellboxes[i].knobse.ref = null;
				sellboxes[i].knobst.lock = true;
				sellboxes[i].knobst.visible = false;
				sellboxes[i].knobse.lock = true;
				sellboxes[i].alpha = 0.5;
				sellpics[i].b.bitmapData = new BitmapData(64,64,true,0x00000000);
				sellpics[i].b.visible = false;
				
				if(a+i < stuff.length && mom.account.armory[stuff[a+i]] != null){
					mom.l.StoreIcon(mom.account.armory[stuff[a+i]].iconid,mom.account.armory[stuff[a+i]].rarity);
					sellpics[i].b.bitmapData = mom.l.sslargeicons[mom.account.armory[stuff[a+i]].iconid][mom.account.armory[stuff[a+i]].rarity];
					sellpics[i].b.visible = true;
					sellboxes[i].knobst.lock = false;
					sellboxes[i].knobst.visible = true;
					sellboxes[i].knobse.lock = false;
					sellboxes[i].knobse.id = stuff[a+i];
					sellboxes[i].knobse.ref = mom.account.armory[stuff[a+i]];
					k = Math.ceil(.1 * mom.account.prices[mom.account.armory[stuff[a+i]].s[0]-100][0] * Math.pow(3,mom.account.armory[stuff[a+i]].rarity));
					sellboxes[i].knobst.price.text = String(k);
					sellboxes[i].alpha = 1;
				}
				
				if(sellboxes[i].knobse.a.currentFrame == 2){
					if(sellboxes[i].knobse.ref != null){
						SetupArmData(sellboxes[i].knobse.ref);
					}else{
						sellboxes[i].knobse.a.gotoAndStop(1);
					}
				}
			}
			selltab = a;
			sellscreen.knobsd.lock = false;
			sellscreen.knobsd.alpha = 1;
			sellscreen.knobsu.lock = false;
			sellscreen.knobsu.alpha = 1;
			if(a == 0){
				sellscreen.knobsu.lock = true;
				sellscreen.knobsu.alpha = .15;
				sellscreen.knobsu.a.gotoAndStop(1);
			}
			if(a + 12 >= stuff.length){
				sellscreen.knobsd.lock = true;
				sellscreen.knobsd.alpha = .15;
				sellscreen.knobsd.a.gotoAndStop(1);
			}
		}
	}
}