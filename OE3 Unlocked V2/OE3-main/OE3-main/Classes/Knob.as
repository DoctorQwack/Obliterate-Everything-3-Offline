package 
{
	import flash.display.MovieClip;
	import flash.text.TextField
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class Knob extends MovieClip 
	{
		var clicking:Boolean;
		var clicked:Boolean;
		var mousing:Boolean;
		var moused:Boolean;
		var rolled:Boolean;
		var lock:Boolean = false;
		var mom;
		var a;
		var b;
		var c;
		var ref;
		var s:int = 0;
		var id:int = 0;
		var idb:int = 0;
		
		public function Knob()
		{
			var i:int;
			var temp;
			stop();
			addEventListener(MouseEvent.MOUSE_DOWN, mouseClick);
			addEventListener(MouseEvent.MOUSE_UP, mouseLift);
			addEventListener(MouseEvent.MOUSE_OVER, mouseRoll);
			addEventListener(MouseEvent.ROLL_OUT, mouseRoll);
			
			buttonMode = true;
			useHandCursor = false;
			mouseChildren = false;

			a = getChildAt(0);
			if(numChildren > 1){
				b = getChildAt(1);
				//b.stop();
			}
			if(numChildren > 2){
				c = getChildAt(2);
			}
			a.stop();
			
			if(this is KnobBuild){
				temp = new BitmapData(32,32);
				b = new Bitmap(temp);
				b.x = -.5 * b.width;
				b.y = -.5 * b.height;
				addChild(b);
			}
			if(this is KnobEquip){
				temp = new BitmapData(64,64);
				b = new Bitmap(temp);
				b.x = 0;
				b.y = 0;
				addChild(b);
			}
			/*if(this is KnobSellThis){
				cobj.gotoAndStop(1);
				price.text = String(0);
			}*/
			/*if(this is KnobBuyThis){
				cobj.gotoAndStop(1);
				price.text = String(0);
			}*/
		}
		
		public function mouseClick(event:MouseEvent)
		{
			if(lock == false){
				if(clicking == false){
					moused = true;
				}
				if(a.currentFrame == 2){
					a.gotoAndStop(3);
				}
				clicking = true;
			}
		}
		
		public function mouseLift(event:MouseEvent)
		{
			var i:int;
			var j:int;
			var aref;
			if(lock == false && clicking == true){
				if(clicking == true){
					clicked = true;
				}
				if(this is QRButton && clicking == true){
					navigateToURL(new URLRequest("http://www.quantumraptor.com/"), "_blank");
				}
				if(this is KnobOE1 && clicking == true){
					navigateToURL(new URLRequest("http://www.kongregate.com/games/cwwallis/obliterate-everything"), "_blank");
				}
				if(this is KnobOE2 && clicking == true){
					navigateToURL(new URLRequest("http://www.kongregate.com/games/cwwallis/obliterate-everything-2"), "_blank");
				}
				if(this is KnobStartGame){
					mom.GameInit();
				}
				if(!(this is KnobBuild) && mom != null && mom.GameState != 0){
					mom.sounds[3]++;
				}
			    if(this is KnobStart && (parent is PrivateScreen) == false){
					mom.SwitchScreen(4);
					mom.roomflag = 3;
				}
				if(this is KnobStart && parent is PrivateScreen)
				{
					mom.n.matchcode = mom.basescreen.privatescreen.matchcodetxt.text;
					trace(mom.n.matchcode);
					mom.StartPrivateMatch();
				}
				if(this is KnobNext){
					if(mom.gui.tutorial.tf.currentFrame < mom.gui.tutorial.tf.totalFrames){
						mom.gui.tutorial.tf.gotoAndStop(mom.gui.tutorial.tf.currentFrame + 1);
					}else{
						mom.gui.tutorial.visible = false;
						mom.paus = 0;
					}
				}
				if(this is KnobMute){
					if(mom.mute == 0){
						mom.mute = 1;
						if(mom.bgm != null){
							mom.bgm.stop();
						}
						a.gotoAndStop(2);
					}else{
						mom.mute = 0;
						mom.PlayMusic(mom.currenttrack);
						a.gotoAndStop(4);
					}
				}
				if(this is KnobPause){
					if(mom.paus == 0){
						mom.paus = 1;
						a.gotoAndStop(4);
					}else{
						mom.paus = 0;
						a.gotoAndStop(2);
					}
				}
				//Login
				if(this is KnobCreateAccount){
					mom.accountscreen.visible = true;
					mom.loginscreen.visible = false;
				}
				if(this is KnobCreate){
					if(mom.accountscreen.ptxt.text == mom.accountscreen.pptxt.text){
						mom.username = mom.accountscreen.utxt.text;
						mom.userpassword = mom.accountscreen.ptxt.text;
						mom.createaccount = true;
						mom.accountscreen.visible = false;
						mom.n.DoRooms(3);
					}else{
						
					}
				}
				if(this is KnobCancel && mom.GameState == 5){
					mom.loginscreen.visible = true;
					mom.accountscreen.visible = false;
				}
				if(this is KnobCancel && parent is PrivateScreen){
					mom.basescreen.ScreenAnimation(4);
				}
				if(this is KnobLogin){
					if(parent is LoginScreen){
						mom.username = mom.loginscreen.utxt.text;
						mom.userpassword = mom.loginscreen.ptxt.text;
						mom.createaccount = false;
						mom.loginscreen.visible = false;
						mom.n.DoRooms(3);
					}
					if(parent is LoadingScreen){
						mom.kongregate.services.showRegistrationBox();
					}
				}
				//BaseStuff
				if(this is HelpTextKnob){
					for(i = 0; i < mom.helpscreen.numChildren; i++){
						aref = mom.helpscreen.getChildAt(i);
						if(aref is HelpTextKnob){
							aref.b.alpha = .5;
						}
					}
					b.alpha = 1;
					mom.helpscreen.subscreen.gotoAndStop(id + 1);
				}
				if(this is KnobHelp){
					if(mom.helpscreen.visible == false){
						a.gotoAndStop(4);
						if(mom.GameState == 2){
							mom.paus = true;
							mom.gui.knobpause.a.gotoAndStop(4);
						}
						if(mom.GameState == 4){
							mom.basescreen.ScreenAnimation(0);
						}
						mom.helpscreen.visible = true;
					}else{
						mom.helpscreen.visible = false;
						a.gotoAndStop(2);
						if(mom.GameState == 2){
							mom.paus = false;
							mom.gui.knobpause.a.gotoAndStop(1);
						}
					}
					
				}
				if(this is KnobBoss){
					if(mom.account.stations > 0){
						for(i = 0; i < mom.account.armory.length; i++){
							if(mom.account.armory[i] != null){
								j++;
							}
						}
						if(j < mom.account.maxinventory ){
							mom.missions.nextpack = 2;
							mom.missions.nextdifficulty = mom.account.campaigndanger + 1;
							mom.missions.nextsun = 1000;
							mom.StartMission();
						}else{
							mom.basescreen.ScreenAnimation(9);
						}
					}else{
						mom.basescreen.ScreenAnimation(8);
					}
				}
				if(this is KnobOK){
					parent.visible = false;
					if(parent is ResultScreen){
						if(mom.basescreen.resultscreen.rtxt.currentFrame == 4){
							mom.basescreen.ScreenAnimation(2);
						}
					}else{
						if(mom.basescreen.lasttab > 0){
							mom.basescreen.ScreenAnimation(mom.basescreen.lasttab);
						}
					}
				}
				if(this is KnobBuyThing && parent is SwapCreditScreen){
					mom.n.BuyCredits(id);
				}
				if(this is KnobBuyThing && parent is SwapPlatinumScreen){
					mom.n.BuyPlatinum(id);
				}
				if(this is KnobBuyThing && parent is SwapStationScreen){
					if(mom.account.stations < mom.account.maxstations){
						mom.n.BuyStations();
						mom.basescreen.swapstationscreen.visible = false;
					}
				}
				if(this is KnobBuyThing && parent is BuyPackScreen){
					mom.n.BuyPack();
				}
				if(this is KnobBuyThing && parent is PackBox){
					mom.n.BuyItemPack(id,mom.account.packprices[id]);
				}
				if(this is KnobPlus && id == 10){
					mom.basescreen.ScreenAnimation(9);
				}
				if(this is KnobPlus && id == 2){
					mom.basescreen.ScreenAnimation(8);
				}
				if(this is KnobPlus && id == 1){
					mom.basescreen.ScreenAnimation(6);
				}
				if(this is KnobPlus && id == 0){
					mom.basescreen.ScreenAnimation(7);
				}
				if(this is KnobQuickMatch){
					mom.n.privatematch = false;
					mom.StartQuickMatch();
				}
				if(this is KnobPrivateMatch){
					mom.n.privatematch = true;
					mom.basescreen.ScreenAnimation(11);
				}
				if(this is KnobArmory){
					mom.basescreen.ScreenAnimation(1);
				}
				if(this is KnobCampaign){
					mom.basescreen.ScreenAnimation(3);
				}
				if(this is KnobMultiplayer){
					mom.basescreen.ScreenAnimation(4);
				}
				if(this is KnobNewCampaign){
					mom.basescreen.ScreenAnimation(10);
				}
				if(this is KnobNewThing){
					if(mom.account.stations > 0){
						mom.n.SendNewCampaign(int(mom.basescreen.newcampaignscreen.dtxt.text) - 1);
						mom.basescreen.ScreenAnimation(3);
					}else{
						mom.basescreen.ScreenAnimation(8);
					}
				}
				if(this is KnobStore){
					mom.basescreen.vaultscreen.visible = true;
					mom.basescreen.packsscreen.visible = false;
					mom.basescreen.sellscreen.visible = false;
					mom.basescreen.upgradescreen.visible = false;
					mom.basescreen.salescreen.visible = false;
					mom.basescreen.surescreen.visible = false;
					mom.basescreen.SetupVaultScreen();
					mom.basescreen.ScreenAnimation(2);
					mom.basescreen.saletab = 0;
				}
				if(this is KnobUpgradeThing){
					if(parent is UpgradeScreen){
						if(mom.n.conn != null){
							mom.n.UpgradeThing(mom.basescreen.upgradeid);
							this.visible = false;
						}
					}
				}
				/*if(this is KnobBuyThis){
					if(mom.n.conn != null){
						if(cobj.currentFrame == 1){
							mom.n.BuyThing(id,0);
						}
						if(cobj.currentFrame == 2){
							mom.n.BuyThing(id,1);
						}
					}
				}*/
				if(this is KnobScrollUp && parent is NewCampaignScreen){
					mom.basescreen.newcampaignscreen.dtxt.text = String(int(mom.basescreen.newcampaignscreen.dtxt.text) + 1);
					mom.basescreen.newcampaignscreen.kd.alpha = 1;
					mom.basescreen.newcampaignscreen.kd.lock = false;
					if(int(mom.basescreen.newcampaignscreen.dtxt.text) > mom.account.campaignlock){
						this.alpha = .1;
						this.lock = true;
					}
				}
				if(this is KnobScrollDown  && parent is NewCampaignScreen){
					mom.basescreen.newcampaignscreen.dtxt.text = String(int(mom.basescreen.newcampaignscreen.dtxt.text) - 1);
					mom.basescreen.newcampaignscreen.ku.alpha = 1;
					mom.basescreen.newcampaignscreen.ku.lock = false;
					if(int(mom.basescreen.newcampaignscreen.dtxt.text) == 1){
						this.alpha = .1;
						this.lock = true;
					}
				}
				//STORE
				if(this is KnobVault){
					mom.basescreen.vaultscreen.visible = true;
					mom.basescreen.packsscreen.visible = false;
					mom.basescreen.sellscreen.visible = false;
					mom.basescreen.upgradescreen.visible = false;
					mom.basescreen.salescreen.visible = false;
					mom.basescreen.surescreen.visible = false;
					mom.basescreen.SetupVaultScreen();
					mom.basescreen.saletab = 0;
				}
				if(this is KnobPacks){
					mom.basescreen.vaultscreen.visible = false;
					mom.basescreen.packsscreen.visible = true;
					mom.basescreen.sellscreen.visible = false;
					mom.basescreen.upgradescreen.visible = false;
					mom.basescreen.salescreen.visible = false;
					mom.basescreen.surescreen.visible = false;
					mom.basescreen.SetupPackScreen(0);
					mom.basescreen.saletab = 1;
				}
				if(this is KnobSell){
					mom.basescreen.vaultscreen.visible = false;
					mom.basescreen.packsscreen.visible = false;
					mom.basescreen.sellscreen.visible = true;
					mom.basescreen.upgradescreen.visible = false;
					mom.basescreen.salescreen.visible = false;
					mom.basescreen.surescreen.visible = false;
					mom.basescreen.SetupSellScreen(0);
					mom.basescreen.saletab = 2;
				}
				if(this is KnobUpgrade){
					mom.basescreen.vaultscreen.visible = false;
					mom.basescreen.packsscreen.visible = false;
					mom.basescreen.sellscreen.visible = false;
					mom.basescreen.upgradescreen.visible = true;
					mom.basescreen.salescreen.visible = false;
					mom.basescreen.surescreen.visible = false;
					mom.basescreen.SetupUpgradeScreen();
					mom.basescreen.saletab = 3;
				}
				if(this is KnobScrollUp && parent is SellScreen){
					mom.basescreen.SetupSellScreen(mom.basescreen.selltab - 12);
				}
				if(this is KnobScrollDown  && parent is SellScreen){
					mom.basescreen.SetupSellScreen(mom.basescreen.selltab + 12);
				}
				if(this is KnobScrollUp && parent is InvScreen){
					mom.basescreen.SetupInvScreen(mom.basescreen.invtabb, mom.basescreen.invtab - 6);
				}
				if(this is KnobScrollDown  && parent is InvScreen){
					mom.basescreen.SetupInvScreen(mom.basescreen.invtabb, mom.basescreen.invtab + 6);
				}
				if(this is KnobScrollUp && parent is PacksScreen){
					mom.basescreen.SetupPackScreen(mom.basescreen.ptab - 3);
				}
				if(this is KnobScrollDown  && parent is PacksScreen){
					mom.basescreen.SetupPackScreen(mom.basescreen.ptab + 3);
				}
				//
				if(this is KnobEquip && parent is ArmoryScreen){
					mom.basescreen.invscreen.visible = true;
					mom.basescreen.armoryscreen.visible = false;
					mom.basescreen.selectedknob = this;
					mom.basescreen.SetupInvScreen(idb,0);
					mom.basescreen.ScreenAnimation(5);
				}
				if(this is KnobEquip && parent is InvScreen){
					//mom.basescreen.invscreen.visible = false;
					//mom.basescreen.armoryscreen.visible = true;
					mom.basescreen.ScreenAnimation(mom.basescreen.lasttab);
					if(mom.basescreen.currenttab == 2){
						mom.basescreen.upgradescreen.kst.visible = true;
						mom.basescreen.upgradescreen.kst.cobj.gotoAndStop(1);
						mom.basescreen.selectedknob.ref = this.ref;
						mom.basescreen.selectedknob.b.bitmapData = this.b.bitmapData;
						mom.basescreen.upgradeid = idb;
						mom.basescreen.upgradescreen.ku.visible = true;
					}
					if(mom.basescreen.currenttab == 1){
						for(i = 0; i < mom.basescreen.equipknobs.length; i++){
							if(mom.basescreen.equipknobs[i].ref == this.ref){
								mom.account.equipmap[mom.basescreen.equipknobs[i].id] = -1;
								mom.basescreen.equipknobs[i].ref = null;
								mom.basescreen.equipknobs[i].b.bitmapData = new BitmapData(64,64,true,0x00000000);
							}
						}
						mom.basescreen.selectedknob.ref = this.ref;
						mom.basescreen.selectedknob.b.bitmapData = this.b.bitmapData;
						mom.account.equipmap[mom.basescreen.selectedknob.id] = idb;
						if(mom.n.conn != null){
							mom.n.SendEquip();
						}
					}
				}
				if(this is KnobEquip && parent is UpgradeScreen){
					mom.basescreen.invscreen.visible = true;
					mom.basescreen.storescreen.visible = false;
					mom.basescreen.selectedknob = this;
					mom.basescreen.SetupInvScreen(100,0);
					mom.basescreen.ScreenAnimation(5);
				}
				if(this is KnobEquip && parent is BuyBox){
					if(mom.n.conn != null){
						aref = parent
						trace(id);
						if(aref.knobbt.cobj.currentFrame == 1){
							mom.n.BuyThing(id,0);
						}
						if(aref.knobbt.cobj.currentFrame == 2){
							mom.n.BuyThing(id,1);
						}
					}
				}
				if(this is KnobEquip && parent is SellBox && a.currentFrame != 1){
					if(mom.n.conn != null){
						aref = parent;
						mom.basescreen.armdata.visible = false;
						if(mom.account.armory[id].rarity < 2){
							if(aref.knobst.cobj.currentFrame == 1){
								mom.n.SellThing(id,0);
							}
							if(aref.knobst.cobj.currentFrame == 2){
								mom.n.SellThing(id,1);
							}
						}else{
							mom.basescreen.sellid = id;
							mom.basescreen.SwitchSureScreen();
						}
					}
				}
				if(this is KnobSureYes){
					if(mom.n.conn != null){
						mom.basescreen.armdata.visible = false;
						//if(aref.knobst.cobj.currentFrame == 1){
						mom.n.SellThing(mom.basescreen.sellid,0);
						mom.basescreen.surescreen.visible = false;
						mom.basescreen.sellscreen.visible = true;
						/*}
						if(aref.knobst.cobj.currentFrame == 2){
							mom.n.SellThing(mom.basescreen.sellid,1);
						}*/
					}
				}
				if(this is KnobSureNo){
					mom.basescreen.surescreen.visible = false;
					mom.basescreen.sellscreen.visible = true;
				}
				if(this is KnobKill){
					mom.qumove[0] = 102;
					mom.qumove[1] = mom.selectid.structid;
					mom.qumove[2] = 0;
					if(mom.GameMode == 0){
						i = mom.selectid.faction - 1;
						mom.rmove[i * 3 + 0] = 102; 
						mom.rmove[i * 3 + 1] = mom.selectid.structid; 
						mom.rmove[i * 3 + 2] = 0;
						if(mom.paus == 1){
							mom.DoRMove();
							mom.TickStep();
						}
					}
				}
				if(this is KnobBuild && parent is GUIBuild){
					mom.gui.UnPushBuildKnobs();
					a.gotoAndStop(4);
					mom.players[mom.me].building = mom.players[mom.me].structbag[s];
					mom.gui.SetupBuildSpot(mom.players[mom.me].building);
					mom.gui.SetupBuildRad(mom.players[mom.me].building.turretrange);
					mom.selectid = null;
					mom.gui.reticle.visible = false;
					mom.gui.guiupgrade.visible = false;	
					mom.sounds[1]++;
				}
				if(this is KnobBuild && parent is GUIUpgrade){
					if(mom.players[mom.me].energy >= mom.players[mom.me].shipbag[s].costenergy && mom.players[mom.me].metal >= mom.players[mom.me].shipbag[s].costmetal){
						mom.gui.UnPushBuildKnobs();
						//mom.selectid.Upgrade(s);
						mom.qumove[0] = 100;
						mom.qumove[1] = mom.selectid.structid;
						mom.qumove[2] = s;
						if(mom.GameMode == 0){
							i = mom.selectid.faction - 1;
							mom.rmove[i * 3 + 0] = 100; 
							mom.rmove[i * 3 + 1] = mom.selectid.structid; 
							mom.rmove[i * 3 + 2] = s;
							if(mom.paus == 1){
								mom.DoRMove();
								mom.TickStep();
							}
						}
						a.gotoAndStop(1);
						mom.selectid = null;
						mom.gui.reticle.visible = false;
						mom.gui.guiupgrade.visible = false;	
						mom.sounds[8]++;
					}else{
						mom.sounds[10]++;
					}
				}
				if(this is KnobX){
					parent.visible = false;
					if(parent is InvScreen){
						mom.basescreen.armoryscreen.visible = true;
						mom.basescreen.ScreenAnimation(mom.basescreen.lasttab);
					}
					if(parent is NewCampaignScreen){
						mom.basescreen.campaignscreen.visible = true;
						mom.basescreen.ScreenAnimation(3);
					}
					if(parent is HelpScreen){
						if(mom.GameState == 2){
							mom.gui.knobpause.a.gotoAndStop(1);
							mom.gui.knobhelp.a.gotoAndStop(1);
							mom.paus = false;
						}
						if(mom.GameState == 4){
							mom.basescreen.knobhelp.a.gotoAndStop(1);
						}
					}
				}
				if(this is KnobCancel && mom.GameState == 2){
					if(mom.n.conn != null){
						mom.n.conn.disconnect();
					}
					mom.roomflag = 3;
					mom.SwitchScreen(4);
				}
				if(this is KnobExclam){
					if(mom.n.conn != null){
						mom.n.ClaimPrize();
					}
				}
				if(this is KnobQuit){
					if(mom.GameMode == 0){
						mom.rmove[(mom.me-1)*3] = 101;
					}else{
						mom.qumove[0] = 101;
					}
				}
				if(a.currentFrame == 3){
					a.gotoAndStop(2);
				}
				clicking = false;
			}
		}
		
		public function mouseRoll(e:MouseEvent)
		{
			var tempx:int = 0;
			var tempy:int = 0;
			if(lock == false){
				switch (e.type) {
					case "mouseOver":
						if(a.currentFrame == 1){
							a.gotoAndStop(2);
						}
						if(!(this is KnobBuild) && mom != null && mom.GameState != 0){
							mom.sounds[2]++;
						}
						if(this is KnobBuild){
							if(this.parent is GUIBuild && mom.players[mom.me].structbag[s] != null){
								mom.gui.SetupGUIData(mom.players[mom.me].structbag[s],s,0);
							}
							if(this.parent is GUIUpgrade && mom.players[mom.me].shipbag[s] != null){
								mom.gui.SetupGUIData(mom.players[mom.me].shipbag[s],s,1);
							}
							mom.gui.guidata.visible = true;
						}
						if(this is KnobKill){
							if(this.parent is GUIUpgrade){
								mom.gui.SetupGUIDataB(mom.selectid);
							}
							mom.gui.guidata.visible = true;
						}
						if(this is KnobEquip){
							if(ref != null && !(parent is UpgradeScreen)){
								mom.basescreen.SetupArmData(ref);
								if(parent is BuyBox || parent is SellBox || parent is PackBox){
									tempx = parent.parent.x + parent.parent.parent.x + parent.parent.parent.parent.x;
									tempy = parent.parent.y + parent.parent.parent.y + parent.parent.parent.parent.y;
								}
								mom.basescreen.armdata.x = this.x + parent.x + this.width + 5 + tempx;
								mom.basescreen.armdata.y = this.y + parent.y + tempy - 40;
								if(mom.basescreen.armdata.x + mom.basescreen.armdata.width > mom.resX){
									mom.basescreen.armdata.x = this.x + parent.x - mom.basescreen.armdata.width - 5 + tempx;
								}
							}
						}
					break;
					case "rollOut":
						if(lock == false && (a.currentFrame == 2 || a.currentFrame == 3)){
							a.gotoAndStop(1);
						}
						if(this is KnobBuild){
							mom.gui.guidata.visible = false;
						}
						if(this is KnobKill){
							mom.gui.guidata.visible = false;
						}
						if(this is KnobEquip){
							mom.basescreen.armdata.visible = false;
						}
					break;
				}
			}
		}
	}
}