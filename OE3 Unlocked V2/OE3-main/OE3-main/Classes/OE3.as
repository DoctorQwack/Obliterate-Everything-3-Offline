package 
{
	//Includes
	import flash.ui.Keyboard;
	import flash.ui.ContextMenu;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
  //  import flash.sampler.*;
	import flash.events.Event;
	import flash.events.ProgressEvent;
    import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
    import flash.utils.Timer;
	import flash.utils.getTimer;
    //import flash.text.TextField;
    import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.filters.GlowFilter;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
    import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.system.Security;
	//import mdm.*;

	dynamic public class OE3 extends MovieClip 
	{
		//Variables
		public var fm_menu:ContextMenu = new ContextMenu();
		public var T:Timer;
		public var clock:int = 0;
		public var clockb:int = 0;
		
		public var downKey:Boolean = false;
		public var upKey:Boolean = false;
		public var leftKey:Boolean = false;
		public var rightKey:Boolean = false;
		public var shiftKey:Boolean = false;
		public var clicking:Boolean = false;
		public var clickx:int = 0;
		public var clicky:int = 0;
		
		public var resX:int = 800;
		public var resY:int = 600;
		public var mapgridx:int = 32;
		public var mapgridy:int = 32;
		public var mapx:int = mapgridx * 32;
		public var mapy:int = mapgridy * 20;
		public var GameState:int = 0;
		public var GameMode:int = 1;
		public var scrollxv:Number = 0;
		public var scrollyv:Number = 0;
		public var startheta:Number = 0;
		public var starv:Number = 0;
		public var structid:int = 0;
		public var shipid:int = 0;
		public var hash:int = 0;
		public var playermax:int = 2;
		public var victoryt:int = 0;
		public var flag:int = 0;
		public var discflag:int = 0;
		public var roomflag:int = 0;
		public var seed:int = 100000 * Math.random();
		public var musicclock:int;
		public var musicmax:int = 2500;
		public var mute:int = 0;
		public var paus:int = 0;
		public var netdelay:int = 0;
		
		public var lockmode:int = 0; //0 test, 1 kong
		
		public var sounds:Array;
		public var spots:Array;
		public var stars:Array;
		public var shots:Array;
		public var ships:Array;
		public var structs:Array;
		public var effects:Array;
		public var players:Array;
		public var qumove:Array;
		public var rmove:Array;
		public var arm:Array;
		public var armory:Array;
		public var keys:Array = new Array(200);
		public var keymap:Array = new Array(200);
		public var playernames:Array;
		public var playerratings:Array;
		
		public var gui:GUI;
		public var game:MovieClip;
		public var starlayer:MovieClip;
		public var backdrop:Bitmap;
		public var l:Library;
		public var n:NetStuff;
		public var missions:Missions;
		public var me:int = 0;
		public var selectid;
		public var alliances:Alliances;
		public var account:Account;
		public var basebackdrop:Bitmap;
		
		public var preloaderscreen:PreloaderScreen;
		public var startscreen:StartScreen;
		public var basescreen:BaseScreen;
		public var loadscreen:LoadScreen;
		public var armoryscreen:ArmoryScreen;
		public var loginscreen:LoginScreen;
		public var accountscreen:AccountScreen;
		public var starimage:StarImage;
		public var planetimage:PlanetImage;
		public var loadingscreen:LoadingScreen;
		public var helpscreen:HelpScreen;
		
		public var track;
		public var currenttrack;
		public var bgm:SoundChannel = new SoundChannel();
		
		//Sound
		public var sndbutton1:SndButton1;
		public var sndbutton2:SndButton2;
		public var sndbutton3:SndButton3;
		public var sndcock:SndCock;
		public var sndwrong:SndWrong;
		public var sndgenerator:SndGenerator;
		public var sndbuild:SndBuild;
		public var sndblock:SndBlock;
		public var sndship:SndShip;
		public var sndselect:SndSelect;
		public var sndswoosh:SndSwoosh;
		public var sndcash:SndCash;
		
		//Multiplayer
		public var gameroom:String;
		public var freezecounter:int = 0;
		public var loggedon:Boolean = false;
		public var createaccount:Boolean = false;
		public var username:String = "";
		public var userpassword:String = "";
		
		//GAME Constants
		
		//TEST
		public var pausetrick:Boolean = false;
		
		//KONG
		var kongregate:*;
		
		public function OE3()
		{
			trace("OE3")
			gotoAndStop(1);
			fm_menu.hideBuiltInItems();
			this.contextMenu = fm_menu;
			loaderInfo.addEventListener( Event.COMPLETE, onCompletelyDownloaded );
			loaderInfo.addEventListener( ProgressEvent.PROGRESS, onProgressMade );
			
			preloaderscreen = new PreloaderScreen();
			preloaderscreen.x = .5 * resX;
			preloaderscreen.y = .5 * resY;
			preloaderscreen.prebar.gotoAndStop(1);
			preloaderscreen.ksg.visible = false;
			preloaderscreen.ksg.mom = this;
			addChild(preloaderscreen);
			
			// Load the API
			if(lockmode == 1){
				var paramObj:Object = LoaderInfo(root.loaderInfo).parameters;
				var apiPath:String = paramObj.kongregate_api_path || 
				  "http://www.kongregate.com/flash/API_AS3_Local.swf";
				Security.allowDomain(apiPath);
				var request:URLRequest = new URLRequest(apiPath);
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
				loader.load(request);
				this.addChild(loader);
			}
		}
		
		// This function is called when loading is complete
		function loadComplete(event:Event):void
		{
			// Save Kongregate API reference
			kongregate = event.target.content;
		
			// Connect to the back-end
			kongregate.services.connect();
		
			// You can now access the API via:
			// kongregate.services
			// kongregate.user
			// kongregate.scores
			// kongregate.stats
			// etc...
		}
		
		public function onCompletelyDownloaded( event:Event ):void
		{
			var domain:String = this.root.loaderInfo.url.split("/")[2];
			var allowed_site:String = "kongregate.com";
			
			if(lockmode == 0){
				preloaderscreen.ksg.visible = true;
				preloaderscreen.loadtxt.text = "Loading Done";
			}
			if(lockmode == 1){
				//TEST
				//domain = "kongregate.com";
				//
				if (domain.indexOf(allowed_site) == (domain.length - allowed_site.length)) {
					preloaderscreen.ksg.visible = true;
					preloaderscreen.loadtxt.text = "Loading Done";
				} else if (domain.indexOf(allowed_site) != (domain.length - allowed_site.length)) {
					preloaderscreen.ksg.visible = false;
					preloaderscreen.loadtxt.text = "Game locked to Kongregate";
				}
			}
		}
		
		public function onProgressMade( progressEvent:ProgressEvent ):void
		{
			var percent;
			percent = loaderInfo.bytesLoaded / loaderInfo.bytesTotal;
			if(preloaderscreen != null){
				preloaderscreen.prebar.gotoAndStop(Math.floor(99 * percent) + 1)
				preloaderscreen.loadtxt.text = "Loading " + String(Math.floor(100 * percent));
				trace( Math.floor(100 * percent) );
			}
		}
		
		public function GameInit()
		{
			var i:int;
			removeChild(preloaderscreen);
			preloaderscreen = null;
			gotoAndStop(3);
			trace("start");
			
			stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyPress );
			stage.addEventListener( KeyboardEvent.KEY_UP, onKeyRelease );
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mousePosition);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseClick);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseLift);
			
			keymap[49] = 0; //1
			keymap[50] = 1; //2
			keymap[51] = 2; //3
			keymap[52] = 3; //4
			keymap[53] = 4; //5
			keymap[54] = 5; //6
			keymap[55] = 6; //7
			keymap[81] = 9; //q
			keymap[87] = 10; //w
			keymap[69] = 11; //e
			keymap[65] = 7; //a
			keymap[83] = 8; //s
			keymap[90] = 12; //z
			keymap[88] = 13; //x
			keymap[32] = 50; //space pause
			
			sndbutton1 = new SndButton1();
			sndbutton2 = new SndButton2();
			sndbutton3 = new SndButton3();
			sndcock = new SndCock();
			sndwrong = new SndWrong();
			sndgenerator = new SndGenerator();
			sndbuild = new SndBuild();
			sndblock = new SndBlock();
			sndship = new SndShip();
			sndselect = new SndSelect();
			sndswoosh = new SndSwoosh();
			sndcash = new SndCash();
			
			l = new Library(this);
			account = new Account(this);
			missions = new Missions(this);
			
			helpscreen = new HelpScreen(this);
			helpscreen.x = .5 * resX;
			helpscreen.y = .5 * resY;
			helpscreen.visible = false;
			addChild(helpscreen);
			
			basebackdrop = new Bitmap();
			//basebackdrop.bitmapData = Nebulas.GenNebulas(resX,resY,1,3);
			//HOLIDAY
			basebackdrop.bitmapData = Nebulas.GenNebulas(resX,resY,25,6);
			
			T = new Timer( 24 );//24
			T.addEventListener( TimerEvent.TIMER, onTick );
			T.start();
			
			sounds = new Array(100);
			for(i = 0; i < 100; i++){
				sounds[i] = 0;
			}
			
			if(lockmode == 0){
				SwitchScreen(5);
				n = new NetStuff(this);
			}
			if(lockmode == 1){
				SwitchScreen(6);
				if(kongregate.services.isGuest() == false){
					loadingscreen.gotoAndStop(2);
					loadingscreen.knoblogin.visible = false;
					n = new NetStuff(this);
				}else{
					loadingscreen.gotoAndStop(1);
					kongregate.services.showRegistrationBox();
					kongregate.services.addEventListener("login", onKongregateInPageLogin);
				}
			}
		}
		
		public function onKongregateInPageLogin(event:Event)
		{
			n = new NetStuff(this);
			if(loadingscreen != null){
				loadingscreen.gotoAndStop(2);
			}
		}
		
		public function SwitchScreen(s:int)
		{
			//CLEAR
			flag = 0;
			if(GameState == 2){
				if(loadscreen != null){
					removeChild(loadscreen);
					loadscreen = null;
				}
				ClearGame();
			}
			if(GameState == 3){
				removeChild(startscreen);
				startscreen = null;
			}
			if(GameState == 4){
				ClearGame();
				removeChild(basescreen);
				basescreen = null;
			}
			if(GameState == 5){
				removeChild(accountscreen);
				accountscreen = null;
				removeChild(loginscreen);
				loginscreen = null;
			}
			if(GameState == 6){
				removeChild(loadingscreen);
				loadingscreen = null;
			}
			//LOAD
			if(s == 2){
				if(loadscreen == null){
					loadscreen = new LoadScreen();
					loadscreen.x = .5 * resX;
					loadscreen.y = .5 * resY;
					addChild(loadscreen);
				}
				loadscreen.loadscreentext.gotoAndStop(1);
				loadscreen.knobcancel.mom = this;
				loadscreen.knobcancel.visible = false;
				loadscreen.visible = true;
				if(GameMode == 1){
					flag = 1;
				}
				startheta = Math.random() * 3.141592 * 2;
				starv = .5;
				freezecounter = 0;
			}
			if(s == 3){
				StartStartScreen();
			}
			if(s == 4){
				PlayMusic(1);
				StartBaseScreen();
			}
			if(s == 5){
				StartLoginScreen();
			}
			if(s == 6){
				if(loadingscreen == null){
					loadingscreen = new LoadingScreen();
					loadingscreen.x = .5 * resX;
					loadingscreen.y = .5 * resY;
					addChild(loadingscreen);
					loadingscreen.knoblogin.mom = this;
					loadingscreen.knoblogin.visible = true;
				}
				loadingscreen.gotoAndStop(1);
				loadingscreen.visible = true;
				GameState = 6;
			}
			DoDepths();
		}
		
		public function StartBaseScreen()
		{
			StartSystem(1,1);
			startheta = 3.141592 * 1;
			starv = 5;
			basescreen = new BaseScreen(this);
			addChild(basescreen);
			basescreen.visible = false;
			GameState = 4;
			flag = 0;
			
			if(loadscreen == null){
				loadscreen = new LoadScreen();
				loadscreen.x = .5 * resX;
				loadscreen.y = .5 * resY;
				addChild(loadscreen);
			}
			loadscreen.loadscreentext.gotoAndStop(5);
			loadscreen.knobcancel.mom = this;
			loadscreen.knobcancel.visible = false;
			this.setChildIndex(helpscreen,this.numChildren - 1);
		}
		
		public function StartLoginScreen()
		{
			loginscreen = new LoginScreen();
			addChild(loginscreen);
			loginscreen.x = .5 * resX;
			loginscreen.y = .5 * resY;
			loginscreen.knobca.mom = this;
			loginscreen.knobl.mom = this;
			
			accountscreen = new AccountScreen();
			addChild(accountscreen);
			accountscreen.x = .5 * resX;
			accountscreen.y = .5 * resY;
			accountscreen.visible = false;
			accountscreen.knobc.mom = this;
			accountscreen.knobcr.mom = this;

			GameState = 5;
		}
		
		public function StartQuickMatch()
		{
			//SetupArmory();
			if(n.conn != null){
				n.conn.disconnect();
			}
			GameMode = 1;
			roomflag = 2;
			SwitchScreen(2);
			playernames = new Array();
			playerratings = new Array();
		}
		
		public function StartPrivateMatch()
		{
			if(n.conn != null){
				n.conn.disconnect();
			}
			GameMode = 1;
			roomflag = 4;
			SwitchScreen(2);
			playernames = new Array();
			playerratings = new Array();
		}
		
		public function StartMission()
		{
			GameMode = 0;
			SwitchScreen(2);
			if(n.conn != null){
				n.conn.send("srequestmission", missions.nextsun);
			}
		}
		
		public function StartStartScreen()
		{
			startscreen = new StartScreen(this);
			addChild(startscreen);
			GameState = 3;
		}
		
		public function StartGame()
		{
			var i:int;
			var j:int;
			game = new MovieClip();
			addChild(game);
			
			gameroom = null;
			flag = 0;
			ships = new Array();
			structs = new Array();
			shots = new Array();
			effects = new Array();
			players = new Array();
			spots = new Array();
			qumove = new Array(3);
			qumove[0] = 0; qumove[1] = 0; qumove[2] = 0;
			rmove = new Array(8 * 3);
			for(i = 0; i < rmove.length; i++){ rmove[i] = 0;};
			
			alliances = new Alliances();
			
			arm = new Array(4);
			for(i = 0; i < 4; i++){
				arm[i] = new Array(27*4);
				for(j = 0; j < arm[i].length; j++){
					arm[i][j] = -1;
				}
			}
			
			victoryt = 0;
			structid = 0;
			shipid = 0;
			paus = 0;
			
			if(GameMode == 1){
				StartSystem(0,1);
			}
			
			scrollxv = .5 * (game.x - .5 * resX);
			scrollyv = .5 * (game.y - .5 * resY);
			
			if(loadscreen != null){
				loadscreen.loadscreentext.gotoAndStop(5);
				loadscreen.knobcancel.visible = false;
			}
			
			GameState = 2;
			if(GameMode == 0){
				Go();
			}
			
			DoDepths();
			//TEST
			pausetrick = false;
		}
		
		public function StartGameOver(r:int)
		{
			ClearGame();
			SwitchScreen(4);
			if(basescreen != null){
				basescreen.SetupResultScreen(r);
			}
		}
		
		public function StartSystem(q:int, v:int)
		{
			var i:int;
			var s;
			var a;
			//q == 0, normal, q == 1, basescreen
			backdrop = null;
			backdrop = new Bitmap();
			if(q == 0){
				backdrop.bitmapData = Nebulas.GenNebulas(resX,resY,Math.floor(Rand() * 1000000),v);
			}
			if(q == 1){
				backdrop.bitmapData = basebackdrop.bitmapData;
			}
			addChild(backdrop);
			//backdrop.visible = false;
			
			starlayer = new MovieClip();
			addChild(starlayer);
			stars = new Array(2);
			stars[0] = new Array();
			stars[1] = new Array();
			for(i = 0; i < 100; i++){
				s = new Star();
				s.bitmapData = Nebulas.GenOneStar();
				s.xx = Math.random() * resX;
				s.yy = Math.random() * resY;
				stars[0].push(s);
				stars[1].push(Math.pow(Math.random(),2));
				starlayer.addChild(s);
			}
		}
		
		public function CheckVictory()
		{
			var i:int;
			var j:int;
			var over:Boolean = true;
			var alive:Array = new Array();
			if(loadscreen == null){
				for(i = 1; i < players.length; i++){
					if(players[i].dead == false){
						alive.push(players[i]);
					}
				}
				for(i = 0; i < alive.length; i++){
					for(j = 0; j < alive.length; j++){
						if(j != i){
							if(alliances.a[alive[i].faction][alive[j].faction] != 2){
								over = false;
							}
						}
					}
				}
				if(players[me].dead == true){
					over = true;
				}
				alive = null;
				if(over == true && victoryt == 0){
					victoryt = 20;
				}
			}
		}
		
		public function ClearGame()
		{
			var i:int;
			var s;
			ships = null;
			spots = null;
			shots = null;
			effects = null;
			stars = null;
			players = null;
			structs = null;
			if(starimage != null){
				removeChild(starimage);
				starimage = null;
			}
			if(planetimage != null){
				removeChild(planetimage);
				planetimage = null;
			}
			if(game != null){
				removeChild(game);
				game = null;
			}
			if(gui != null){
				removeChild(gui);
				gui = null;
			}
			if(starlayer != null){
				removeChild(starlayer);
				starlayer = null;
			}
			if(backdrop != null){
				removeChild(backdrop);
				backdrop = null;
			}
		}
		
		public function Collide()
		{
			var i:int;
			var j:int;
			var r:Number = 0;
			var s;
			var t;
			var d;
			//SHIELDS
			for(i = 0; i < structs.length; i++){
				s = structs[i];
				if(s.tacshield > 0){
					for(j = 0; j < shots.length; j++){
						t = shots[j];
						if(alliances.a[s.faction][t.faction] == 0){
							r = Math.pow(s.xx - t.xx, 2) + Math.pow(s.yy - t.yy, 2);
							if(r < Math.pow(s.tacshieldr + 13, 2) && r > Math.pow(s.tacshieldr - 17, 2)){
								if(t.sdamage < s.tacshield && t.armor > 0){
									t.armor = -100;
									s.tacshield = s.tacshield - t.sdamage;
									GenEffect([6,2,0],t.drawx,t.drawy,0,0);
									if(s.tacshieldpic != null){
										s.tacshieldpic.visible = true;
										s.tacshieldpic.alpha = .2;
										s.tacshieldpic.rotation = (-90 + 360 * Math.atan2(s.yy - t.drawy, s.xx - t.drawx) / (2 * 3.141592));
									}
								}else{
									if(t.armor > 0){
										s.tacshield = 0;
										s.shieldt = 50;
										s.tacshieldpic.visible = false;
										GenEffect([6,4,0],s.xx,s.yy,0,0);
									}
								}
							}
						}
					}
				}
			}
			for(i = 0; i < ships.length; i++){
				s = ships[i];
				if(s.tacshield > 0){
					for(j = 0; j < shots.length; j++){
						t = shots[j];
						if(alliances.a[s.faction][t.faction] == 0){
							r = Math.pow(s.xx - t.xx, 2) + Math.pow(s.yy - t.yy, 2);
							if(r < Math.pow(s.tacshieldr + 10, 2) && r > Math.pow(s.tacshieldr - 15, 2)){
								if(t.sdamage < s.tacshield && t.armor > 0){
									t.armor = -100;
									s.tacshield = s.tacshield - t.sdamage;
									GenEffect([6,2,0],t.drawx,t.drawy,0,0);
									if(s.tacshieldpic != null){
										s.tacshieldpic.visible = true;
										s.tacshieldpic.alpha = .2;
										s.tacshieldpic.rotation = (-90 + 360 * Math.atan2(s.yy - t.drawy, s.xx - t.drawx) / (2 * 3.141592));
									}
								}else{
									if(t.armor > 0){
										s.tacshield = 0;
										s.shieldt = 50;
										s.tacshieldpic.visible = false;
										GenEffect([6,4,0],s.xx,s.yy,0,0);
									}
								}
							}
						}
					}
				}
			}
			for(i = 0; i < shots.length; i++){
				s = shots[i];
				if(s.armor > 0 && s.laser == 0){
					j = s.targets.length - 1;
					while(j > -1){
						if(s.targets[j] == null){
							s.targets.splice( j, 1);
						}else{
							t = s.targets[j];
							if(t.armor > 0){
								if(s.xx-s.wide < t.xx+t.wide && s.xx+s.wide > t.xx-t.wide && s.yy-s.high < t.yy+t.high && s.yy+s.high > t.yy-t.high){
									t.Hit(s);
								}
							}else{
								s.targets.splice( j, 1);
							}
						}
						j--;
					}
				}
			}
		}
		
		public function ControlHotKey(s:int)
		{
			var k;
			if(gui != null){
				if(s >= 0 && s < gui.buildknobs.length){
					k = gui.buildknobs[s];
					if(k.b.visible == true){
						gui.UnPushBuildKnobs();
						k.a.gotoAndStop(4);
						players[me].building = players[me].structbag[s + 1];
						gui.SetupBuildSpot(players[me].building);
						gui.SetupBuildRad(players[me].building.turretrange);
						selectid = null;
						gui.reticle.visible = false;
						gui.guiupgrade.visible = false;
					}
				}
				if(s == 50 && GameMode == 0 && GameState == 2 && gui != null){
					if(paus == 0){
						paus = 1;
						gui.knobpause.a.gotoAndStop(4);
					}else{
						paus = 0;
						gui.knobpause.a.gotoAndStop(1);
					}
				}
			}
		}
		
		public function CuteStarAnimation()
		{
			var i:int;
			var wide:int = 0;
			var s;
			if(stars != null){
				for(i = 0; i < stars[0].length; i++){
					s = stars[0][i];
					s.xx = s.xx + Math.cos(startheta) * starv * stars[1][i];
					s.yy = s.yy - Math.sin(startheta) * starv * stars[1][i];
					wide = .5 * s.width;
					
					if(s.xx + wide < -15){
						s.xx = resX + 15 - wide;
					}
					if(s.xx - wide > resX + 15){
						s.xx = -15 - wide;
					}
					if(s.yy + wide < -15){
						s.yy = resY + 15 - wide;
					}
					if(s.yy - wide > resY + 15){
						s.yy = -15 - wide;
					}
					s.Move();
					s.blendMode = "add";
				}
			}
		}
		
		public function DoCamera()
		{
			var s;
			var i:int;
			var wide:int;
			
			//scrollxv = Math.floor(-.5 * resX + (game.x + pilot.x + camx));
			//scrollyv = Math.floor(-.5 * resY + (game.y + pilot.y + camy));
			if(downKey){
				scrollyv = 15;
			}
			if(upKey){
				scrollyv = -15;
			}
			if(rightKey){
				scrollxv = 15;
			}
			if(leftKey){
				scrollxv = -15;
			}
			if(clock == 2){
				s = null;
				for(i = 0; i < structs.length; i++){
					if(structs[i].faction == players[me].faction && structs[i].base == true){
						s = structs[i];
					}
				}
				if(s != null){
					scrollxv = (game.x + s.x - .5 * resX);
					scrollyv = (game.y + s.y - .5 * resY);
				}
			}
			
			if(game.x - scrollxv > 0){
				scrollxv = game.x ;
			}
			if(game.y - scrollyv > 0){
				scrollyv = game.y;
			}
			if(game.x - resX - scrollxv < -mapx){
				scrollxv = (game.x - resX + mapx);
			}
			if(game.y - resY - scrollyv < -mapy){
				scrollyv = (game.y - resY + mapy);
			}
			
			if(planetimage != null){
				planetimage.x = planetimage.x - .5 * 1 * scrollxv;
				planetimage.y = planetimage.y - .5 * 1 * scrollyv;
			}
			
			for(i = 0; i < stars[0].length; i++){
				s = stars[0][i];
				s.xx = s.xx - .5 * stars[1][i] * scrollxv;
				s.yy = s.yy - .5 * stars[1][i] * scrollyv;
				wide = .5 * s.width;
				if(s.xx + wide < -20){
					s.xx = s.xx + resX + 20 - wide;
				}
				if(s.xx + wide > resX + 20){
					s.xx = s.xx - resX - 20 - wide;
				}
				if(s.yy + wide < -20){
					s.yy = s.yy + resY + 20 - wide;
				}
				if(s.yy + wide > resY + 20){
					s.yy = s.yy - resY - 20 - wide;
				}
				s.Move();
				s.blendMode = "add";
			}
			
			if(gui.reticle.visible == true){
				gui.reticle.x = gui.reticle.x - scrollxv;
				gui.reticle.y = gui.reticle.y - scrollyv;
				gui.reticle.x = Math.round(gui.reticle.x);
				gui.reticle.y = Math.round(gui.reticle.y);
			}
			
			game.x = game.x - scrollxv;
			game.y = game.y - scrollyv;
			game.x = Math.round(game.x);
			game.y = Math.round(game.y);

			scrollxv = 0;
			scrollyv = 0;
		}
		
		public function DoDepths()
		{
			var i:int;
			var j:int;
			
			if(GameState == 2){
				j = 0;
				this.setChildIndex(backdrop,j);
				j++;
				this.setChildIndex(starlayer,j);
				j++;
				if(starimage != null){
					this.setChildIndex(starimage,j);
					j++;
				}
				if(planetimage != null){
					this.setChildIndex(planetimage,j);
					j++;
				}
				this.setChildIndex(game,j);
				j++;
				if(gui != null){
					this.setChildIndex(gui,j);
					j++;
				}
				this.setChildIndex(helpscreen,j);
				j++;
				j= 0;
				for(i = 0; i < structs.length; i++){
					game.setChildIndex(structs[i],j);
					j++;
				}
				for(i = 0; i < ships.length; i++){
					game.setChildIndex(ships[i],j);
					j++;
				}
				for(i = 0; i < shots.length; i++){
					game.setChildIndex(shots[i],j);
					j++;
				}
				for(i = 0; i < effects.length; i++){
					game.setChildIndex(effects[i],j);
					j++;
				}
			}
			if(loadscreen != null){
				setChildIndex(loadscreen,numChildren-1);
			}
		}
		
		public function DoEffects()
		{
			var i:int;
			var remove:Boolean = false;
			var s;
			i = effects.length - 1;
			while(i > -1){
				remove = false;
				s = effects[i];
				s.Move();
				if(s.clock >= s.lifespan){
					remove = true;
				}
				if(remove){
					s.Die();
					game.removeChild( s );
					effects.splice( i, 1 );
				}
				i--;
			}
		}
		
		public function DoFreeze()
		{
			if(GameMode == 1){
				freezecounter++;
				if(freezecounter == 160){
					trace("LAG");
				}
				if(freezecounter >= 420){ //Disconnect
					if(n.conn != null){
						n.conn.disconnect();
					}
					ClearGame();
					roomflag = 3;
					SwitchScreen(4);
					basescreen.SetupResultScreen(2);
				}
			}
			if(GameMode == 0){
				freezecounter++;		
				//trace(freezecounter);
				if(freezecounter == 200 && n.pinged == true){
					trace("SEND PING");
					n.Ping()
				}
				if(freezecounter >= 800 && freezecounter % 200 == 0 && n.pinged == false){
					trace("DISCONNECTED OMFGWTFBBQ");
					if(gui != null){
						gui.guidisctxt.visible = true;
					}
					if(n.conn != null){
						n.conn.disconnect();
					}
					n.DoRooms(3);
				}
			}
		}
		
		public function DoMove(v)
		{
			qumove[0] = v[0];
			qumove[1] = v[1];
			qumove[2] = v[2];
		}
		
		public function DoMusic()
		{
			var t:int;
			var i:int;
			var j:int = 0;
			var st:SoundTransform;

			if(GameState == 2){
				musicclock = musicclock - 1;
				if(musicclock < 200){
					st = new SoundTransform(.5 * (musicclock/200));
					bgm.soundTransform = st;
				}
				if(currenttrack != 2 && currenttrack != 8){
					for(i = 0; i < ships.length; i++){
						if(ships[i].mass >= 50){
							PlayMusic(2);
							musicclock = musicmax;
							i = ships.length + 1;
						}
					}
				}
				if(musicclock < 1){
					while(j == 0){
						t = Math.floor(3 + Math.random() * 4.99);
						if(t != currenttrack){
							j = 1;
						}
					}
					if(missions.bosslevel == true){
						t = 8;
					}
					PlayMusic(t)
					musicclock = musicmax;
				}
			}
		}
		
		public function DoRMove()
		{
			var i:int;
			var j:int;
			for(i = 0; i < players.length - 1; i++){
				//BUILD
				if(rmove[i * 3] > 0 && rmove[i * 3] < 100){
					players[i+1].DoRadar();
					if(players[i+1].energy >= players[i+1].structbag[rmove[i*3]].costenergy && players[i+1].metal >= players[i+1].structbag[rmove[i*3]].costmetal && players[i+1].Buildability(rmove[i*3 + 1],rmove[i*3 + 2],players[i+1].structbag[rmove[i*3]].buildwide,players[i+1].structbag[rmove[i*3]].buildhigh) == true){
						players[i+1].BuildStruct(rmove[i*3 + 1],rmove[i*3 + 2],players[i+1].structbag[rmove[i*3]]);
						players[i+1].energy = players[i+1].energy - players[i+1].structbag[rmove[i*3]].costenergy;
						players[i+1].metal = players[i+1].metal - players[i+1].structbag[rmove[i*3]].costmetal;
						if(i+1 == me && structs[structs.length - 1].hangars.length > 0 && structs[structs.length - 1].upgraded == false){
							selectid = structs[structs.length - 1];
							ClickStruct();
						}
					}
				}
				//UPGRADE
				if(rmove[i * 3] == 100){
					for(j = 0; j < structs.length; j++){
						if(structs[j].structid == rmove[i * 3 + 1]){
							if(players[i+1].energy >= players[i+1].shipbag[rmove[i * 3 + 2]].costenergy && players[i+1].metal >= players[i+1].shipbag[rmove[i * 3 + 2]].costmetal){
								structs[j].Upgrade(rmove[i * 3 + 2]);
								j = structs.length;
								players[i+1].energy = players[i+1].energy - players[i+1].shipbag[rmove[i * 3 + 2]].costenergy;
								players[i+1].metal = players[i+1].metal - players[i+1].shipbag[rmove[i * 3 + 2]].costmetal;
							}
						}
					}
				}
				//SELF DESTRUCT
				if(rmove[i * 3] == 101){
					for(j = 0; j < structs.length; j++){
						if(structs[j].faction == players[i+1].faction){
							structs[j].armor = -1000;
						}
					}
				}
				//SELL
				if(rmove[i * 3] == 102){
					for(j = 0; j < structs.length; j++){
						if(structs[j].structid == rmove[i * 3 + 1]){
							structs[j].armor = -1000;
							structs[j].ienergy = structs[j].ienergy + structs[j].sellenergy;
							structs[j].imetal = structs[j].imetal + structs[j].sellmetal;
							if(structs[j].faction == players[me].faction){
								gui.guiupgrade.visible = false;
							}
							j = structs.length;
						}
					}
				}
				rmove[i * 3] = 0;
				rmove[i * 3 + 1] = 0;
				rmove[i * 3 + 2] = 0;
			}
		}
		
		public function DoPlayers()
		{
			var i:int;
			var p;
			for(i = 0; i < players.length; i++){
				p = players[i];
				p.DoStuff();
			}
		}
		
		public function DoShips()
		{
			var i:int;
			var remove:Boolean = false;
			var s;
			i = ships.length - 1;
			while(i > -1){
				remove = false;
				s = ships[i];
				s.Move();
				if(s.armor <= 0){
					remove = true;
				}
				if(remove){
					s.Die();
					game.removeChild( s );
					ships.splice( i, 1 );
				}
				i--;
			}
		}
		
		public function DoShots()
		{
			var i:int;
			var remove:Boolean = false;
			var s;
			i = shots.length - 1;
			while(i > -1){
				remove = false;
				s = shots[i];
				s.Move();
				if(s.armor <= 0){
					remove = true;
					s.Boom();
				}
				if(s.clock > s.lifespan && s.popp > 0){
					remove = true;
					s.Boom();
				}
				if(s.clock > s.lifespan){
					remove = true;
				}
				if(remove){
					s.Die();
					game.removeChild( s );
					shots.splice( i, 1 );
				}
				i--;
			}
		}
		
		public function DoSounds()
		{
			var i:int;
			var a:Number;
			
			if(mute == 0){
				for(i = 0; i < sounds.length; i++){
					if(sounds[i] > 0){
						switch(i){
							case 1: //Button 1
								sndbutton1.play();
							break;
							case 2: //Button 2
								sndbutton2.play();
							break;
							case 3: //Button 3
								sndbutton3.play();
							break;
							case 4:
								sndcock.play();
							break;
							case 5:
								sndgenerator.play();
							break;
							case 6:
								sndbuild.play();
							break;
							case 7:
								sndblock.play();
							break;
							case 8:
								sndship.play();
							break;
							case 9:
								sndselect.play();
							break;
							case 10:
								sndwrong.play();
							break;
							case 11:
								sndswoosh.play();
							break;
							case 12:
								sndcash.play();
							break;
						}
					}
				}
			}
			for(i = 0; i < sounds.length; i++){
				sounds[i] = 0;
			}
		}
		
		public function DoStructs()
		{
			var i:int;
			var remove:Boolean = false;
			var s;
			i = structs.length - 1;
			while(i > -1){
				remove = false;
				s = structs[i];
				s.Move();
				if(s.armor <= 0 || s.deadasteroid == true){
					remove = true;
				}
				if(remove){
					s.Die();
					game.removeChild( s );
					structs.splice( i, 1 );
				}
				i--;
			}
		}
		
		public function DoVictory()
		{
			var r:Array = new Array(players.length - 1);
			var i:int = 0;
			if(victoryt > 1){
				victoryt--;
			}
			if(victoryt == 2 && GameMode == 0){
				if(freezecounter < 200){
					if(n.conn != null){
						n.SendSingleResults();
					}
				}else{
					victoryt = 4;
				}
			}
		}
		
		public function Go()
		{
			var i:int;
			
			if(GameMode == 0){
				me = 1;
				missions.RollDice(0);
				n.pinged = true;
			}
			if(GameMode == 1){
				me = n.myId;
				missions.GenMultiMission(missions.multlevel);
				missions.StartPlayersMulti();
			}
			
			gui = new GUI(this);
			addChild(gui);
			
			clock = 0;
			clockb = 0;
			flag = 0;
			victoryt = 0;
			
			if(loadscreen != null){
				removeChild(loadscreen);
				loadscreen = null;
			}
			
			TickStep();
			musicclock = 0;
		}
		
		public function GenEffect(ss, xx:Number, yy:Number, xxv:Number, yyv:Number)
		{
			var newE;
			var ed:EffectData = new EffectData(ss);
			
			newE = new Effect(this,ed,xx,yy,xxv,yyv);
			effects.push( newE );
			game.addChild( newE );
			
			ed = null;
		}
		
		public function GenHangar(ref,s:int,tt:Number,rr:Number)
		{
			var newH;
			var i:int;
			newH = new Hangar(this,ref,s,tt,rr);
			ref.hangars.push( newH );
		}
		
		public function GenPlayer(f:int,tc:int,a,b,c,cpu:Boolean)
		{
			var newP;
			var a;
			var i:int;
			var j:int;
			newP = new Player(this,f,tc,a,b,c,cpu);
			players.push( newP );
			
			for(i = 0; i < newP.structbag.length; i++){
				if(newP.structbag[i] != null){
					l.GenImage(0,newP.structbag[i].picid,f,newP.teamcolor,0);
					for(j = 0; j < newP.structbag[i].turrets.length; j++){
						a = new TurretData(new Array(newP.structbag[i].turrets[j][0],-1,-1,-1));
						l.GenImage(2,a.picid,f,newP.teamcolor,0);
					}
					if(f > 0){
						l.StoreIcon(newP.structbag[i].iconid,newP.structbag[i].rarity);
					}
				}
			}
			for(i = 0; i < newP.shipbag.length; i++){
				if(newP.shipbag[i] != null){
					l.GenImage(1,newP.shipbag[i].picid,f,newP.teamcolor,newP.shipbag[i].burnmod);
					if(f > 0){
						l.StoreIcon(newP.shipbag[i].iconid,newP.shipbag[i].rarity);
					}
					for(j = 0; j < newP.shipbag[i].hangarships.length; j++){
						a = new ShipData(newP.shipbag[i].hangarships[j]);
						l.GenImage(1,a.picid,f,newP.teamcolor,a.burnmod);
					}
					for(j = 0; j < newP.shipbag[i].turrets.length; j++){
						a = new TurretData(new Array(newP.shipbag[i].turrets[j][0],-1,-1,-1));
						l.GenImage(2,a.picid,f,newP.teamcolor,0);
					}
					if(newP.shipbag[i].transformid >= 0){
						l.GenImage(1,newP.shipbag[i].transformid,f,newP.teamcolor,newP.shipbag[i].burnmod);
					}
				}
			}
		}
		
		public function GenShip(ss, f:int, xx:Number, yy:Number, xxv:Number, yyv:Number, tt:Number)
		{
			var newS;
			
			newS = new Ship(this,ss,f,xx,yy,xxv,yyv,tt);
			ships.push( newS );
			game.addChild( newS );
		}
		
		public function GenShot(ss, f:int, xx:Number, yy:Number, xxv:Number, yyv:Number, tt:Number, o)
		{
			var newShot;
			var sd:ShotData = new ShotData(ss);
			
			newShot = new Shot(this,sd,f,xx,yy,xxv,yyv,tt,o);
			shots.push( newShot );
			game.addChild( newShot );
			
			sd = null;
		}
		
		public function GenStruct(ss, f:int, xx:Number, yy:Number)
		{
			var newS;
			
			newS = new Struct(this,ss,f,xx,yy);
			structs.push( newS );
			game.addChild( newS );
		}
		
		public function GenTurret(ref,ss,xx:Number,yy:Number)
		{
			var newT;
			var d:TurretData = new TurretData(ss);
			var i:int;
			newT = new Turret(this,ref,d,xx,yy);
			ref.turrets.push( newT );
			ref.addChild(newT);
		}
		
		public function mouseLift(event:MouseEvent)
		{
			if(GameState == 2){
				clicking = false;
			}
		}
		
		public function mouseClick(event:MouseEvent)
		{
			var i:int;
			var xx:Number;
			var yy:Number;
			if(GameState == 2 && gui != null){
				clicking = true;
				clickx = mouseX;
				clicky = mouseY;
				if(gui.guidata.visible == false){//gui.guidata.visible == false
					selectid = null;
					gui.guiupgrade.visible = false;
					gui.reticle.visible = false;
					for(i = 0; i < structs.length; i++){
						xx = structs[i].x + game.x;
						yy = structs[i].y + game.y;
						if(structs[i].faction == players[me].faction && mouseX > xx - structs[i].wide && mouseX < xx + structs[i].wide && mouseY > yy - structs[i].high && mouseY < yy + structs[i].high){
							selectid = structs[i];
							sounds[9]++;
						}
					}
				}
				
				if(!(mouseX < gui.guibuild.width && mouseY > resY - gui.guibuild.height)){
					if(players[me].building != null && players[me].energy >= players[me].building.costenergy && players[me].metal >= players[me].building.costmetal){
						xx = Math.floor((mouseX - 16 * players[me].building.buildwide + 16 - game.x)/32);
						yy = Math.floor((mouseY - 16 * players[me].building.buildhigh + 16 - game.y)/32);
						if(players[me].Buildability(xx,yy,players[me].building.buildwide,players[me].building.buildhigh)){
							for(i = 0; i < players[me].structbag.length; i++){
								if(players[me].structbag[i] != null && players[me].structbag[i].s == players[me].building.s){
									qumove[0] = i;
									qumove[1] = xx;
									qumove[2] = yy;
									if(GameMode == 0){
										rmove[(me-1)*3] = i;
										rmove[(me-1)*3 + 1] = xx;
										rmove[(me-1)*3 + 2] = yy;
									}
									sounds[players[me].structbag[i].buildsound]++;
									if(paus == 1){
										DoRMove();
										TickStep();
									}
								}
							}
						}else{
							sounds[10]++;
						}
					}else{
						if(players[me].building != null){
							sounds[10]++;
						}
					}
				}
				if(selectid != null){
					gui.reticle.visible = true;
					gui.reticle.x = selectid.x + game.x;
					gui.reticle.y = selectid.y + game.y;
					gui.DrawReticle(selectid.wide);
				}
				if(selectid != null){
					ClickStruct();
				}
				if(shiftKey == false){
					gui.UnPushBuildKnobs();
					players[me].building = null;
					gui.buildspot.visible = false;
				}
			}
		}
		
		public function ClickStruct()
		{
			var i:int;
			gui.guiupgrade.visible = true;
			gui.guiupgrade.x = selectid.x + game.x;
			gui.guiupgrade.y = selectid.y + game.y;
			if(selectid.upgrades.length > 0 && selectid.upgraded == false){
				for(i = 0; i < gui.guiupgrade.numChildren; i++){
					if(gui.guiupgrade.getChildAt(i) is KnobBuild){
						if(i < selectid.upgrades.length){
							gui.upgradeknobs[i].s = selectid.upgrades[i];
							gui.upgradeknobs[i].visible = true;
							gui.upgradeknobs[i].b.bitmapData = l.ssicons[players[me].shipbag[gui.upgradeknobs[i].s].iconid][players[me].shipbag[gui.upgradeknobs[i].s].rarity];
						}else{
							gui.upgradeknobs[i].visible = false;
						}
					}
				}
			}else{
				for(i = 0; i < gui.guiupgrade.numChildren; i++){
					if(gui.guiupgrade.getChildAt(i) is KnobBuild){
						gui.upgradeknobs[i].visible = false;
					}
				}
			}
			gui.reticle.visible = true;
			gui.reticle.x = selectid.x + game.x;
			gui.reticle.y = selectid.y + game.y;
			gui.DrawReticle(selectid.wide);
		}
		
		public function mousePosition(event:MouseEvent)
		{
			if(GameState == 2){
				if(clicking == true){
					scrollxv = scrollxv - (mouseX - clickx);
					scrollyv = scrollyv - (mouseY - clicky);
					clickx = mouseX;
					clicky = mouseY;
				}
				if(gui != null){
					gui.guidata.x = mouseX + 5;
					gui.guidata.y = mouseY - 5;
					if(gui.guidata.y - gui.guidata.height < 0){
						gui.guidata.y = mouseY + 5 + gui.guidata.height;
					}
					if(gui.guidata.x + gui.guidata.width > resX){
						gui.guidata.x = mouseX - 5 - gui.guidata.width;
					}
				}
			}
		}
		
		public function onKeyPress(keyboardEvent:KeyboardEvent)
		{
			if ( keyboardEvent.keyCode == Keyboard.DOWN ){
				downKey = true;
			}
			if ( keyboardEvent.keyCode == Keyboard.UP ){
				upKey = true;
			}
			if ( keyboardEvent.keyCode == Keyboard.LEFT ){
				leftKey = true;
			}
			if ( keyboardEvent.keyCode == Keyboard.RIGHT ){
				rightKey = true;
			}
			if ( keyboardEvent.keyCode == Keyboard.SHIFT )
			{
				shiftKey = true;
			}
			keys[keyboardEvent.keyCode] = true;
			if(keymap[keyboardEvent.keyCode] != null){
				ControlHotKey(keymap[keyboardEvent.keyCode]);
			}
		}
		
		public function onKeyRelease(keyboardEvent:KeyboardEvent)
		{
			if ( keyboardEvent.keyCode == Keyboard.DOWN )
			{
				downKey = false;
			}
			if ( keyboardEvent.keyCode == Keyboard.UP )
			{
				upKey = false;
			}
			if ( keyboardEvent.keyCode == Keyboard.LEFT )
			{
				leftKey = false;
			}
			if ( keyboardEvent.keyCode == Keyboard.RIGHT )
			{
				rightKey = false;
			}
			if ( keyboardEvent.keyCode == Keyboard.SHIFT )
			{
				shiftKey = false;
			}
			keys[keyboardEvent.keyCode] = false;
		}
		
		public function onTick(timerEvent:TimerEvent)
		{
			if(GameState == 0){ //Preloader
				
			}
			if(GameState == 1){ //Splash
				
			}
			if(GameState == 2 && gui != null){	
				clockb++;
				if(clockb % 4 == 0 && GameMode == 0 && paus == 0){
					DoRMove();
					TickStep();
				}
				if(paus == 0){
					CuteStarAnimation();
					DoEffects();
				}
				DoCamera();
				RenderStuff();
				DoDepths();
				gui.DoGUI();
				DoFreeze();
				DoMusic();
			}
			if(GameState == 2 && gui == null){
				if(flag == 2){
					Go();
				}
				if(flag == 1){
					if(loadscreen != null){
						loadscreen.loadscreentext.gotoAndStop(3);
						loadscreen.knobcancel.visible = false;
					}
					flag = 2;
				}
				if(gameroom != null){
					DoFreeze();
				}
				CuteStarAnimation();
			}
			if(GameState == 3){ //Start
				
			}
			if(GameState == 4){ //Base
				CuteStarAnimation();
				if(netdelay > 0){
					netdelay--;
				}
				if(basescreen != null){
					if(n == null || (n != null && n.conn == null) || (n != null && n.currentroom != 3)){
						basescreen.visible = false;
						loadscreen.visible = true;
					}else{
						basescreen.visible = true;
						loadscreen.visible = false;
					}
					basescreen.DoStuff();
				}
				if(flag == 2){
					StartGame();
				}
				if(flag == 1){
					flag = 2;
				}
			}
			if(GameState == 5){ //Login
			
			}
			if(GameState == 6){ //Kongregate

			}
			if(discflag == 1){
				if(n != null && n.conn != null){
					n.conn.disconnect();
				}
				discflag = 0;
			}
			if(roomflag > 0){
				if(n != null){
					n.DoRooms(roomflag);
				}
				roomflag = 0;
			}
			
			DoSounds();
		}
		
		public function PlayMusic(s:int)
		{
			trace("MUSIC " + String(s));
			var st:SoundTransform;
			if(bgm != null){
				bgm.stop();
			}
			switch(s){
				case 1:
					track = new M1();
				break;
				case 2:
					track = new M2();
				break;
				case 3:
					track = new M3();
				break;
				case 4:
					track = new M4();
				break;
				case 5:
					track = new M5();
				break;
				case 6:
					track = new M6();
				break;
				case 7:
					track = new M7();
				break;
				case 8:
					track = new M8();
				break;/*
				case 9:
					track = m9;
				break;
				case 10:
					track = m10;
				break;
				case 11:
					track = m11;
				break;*/
			}
			if(mute == 0){
				bgm = track.play(0,99);
				st = new SoundTransform(.5);
				bgm.soundTransform = st;
			}
			currenttrack = s;
			musicclock = 0;
			if(GameState == 2){
				musicclock = musicmax;
			}
		}
		
		public function TickStep()
		{
			var i:int;
			var j:int;
			var beforeTime:Number = 0;
			var afterTime:Number = 0;
			var tracetimes:Boolean = false;
			var ta;
			var tb;
			var tc;
			var td;
			beforeTime = getTimer();
			
			clock++;
			if(GameMode == 1){
				freezecounter = 0;
			}
			Collide();
			ta = getTimer();
			DoShots();
			tb = getTimer();
			DoShips();
			tc = getTimer();
			DoStructs();
			td = getTimer();
			DoPlayers();
			Secure();
			CheckVictory();
			if(victoryt > 0){
				DoVictory();
			}
			
			afterTime = getTimer();
				
			if(tracetimes == true){
				trace("Total time: " + String(afterTime - beforeTime));
				trace("Collide: " + String(ta - beforeTime));
				trace("DoShots: " + String(tb - ta));
				trace("DoShips: " + String(tc - tb));
				trace("DoStructs: " + String(td - tc));
				trace("DoPlayers: " + String(afterTime - td));
			}
		}
		
		public function RenderStuff()
		{
			var i:int;
			var j:int;
			var beforeTime:Number = 0;
			var afterTime:Number = 0;
			var tracetimes:Boolean = false;
			
			beforeTime = getTimer();
			for(i = 0; i < structs.length; i++){
				if(paus == 0){
					structs[i].DoGraphics();
				}
				structs[i].Render();
				for(j = 0; j < structs[i].turrets.length; j++){
					structs[i].turrets[j].Render();
				}
			}
			for(i = 0; i < ships.length; i++){
				if(paus == 0){
					ships[i].DoGraphics();
				}
				ships[i].Render();
				for(j = 0; j < ships[i].turrets.length; j++){
					ships[i].turrets[j].Render();
				}
			}
			for(i = 0; i < shots.length; i++){
				if(paus == 0){
					shots[i].DoGraphics();
				}
				shots[i].Render();
			}
			for(i = 0; i < effects.length; i++){
				effects[i].Render();
			}
			afterTime = getTimer();
			if(tracetimes == true && clockb % 4 == 0){
				trace("Render Time: " + String(afterTime - beforeTime));
				trace(" ");
			}
		}
		
		public function Secure()
		{
			var i:int;
			hash = structs.length + ships.length;
		}
		
		public function SetupArmory()
		{
			armory = new Array();
			armory.push(new StructData([0]));
			if(Math.random() < 0.5){
				armory.push(new StructData([100]));
				armory.push(new StructData([101]));
				armory.push(new StructData([102]));
				armory.push(new StructData([103]));
				armory.push(new StructData([106]));
				armory.push(new StructData([110]));
				armory.push(new StructData([111]));
			}else{
				armory.push(new StructData([104]));
				armory.push(new StructData([103]));
				armory.push(new StructData([105]));
				armory.push(new StructData([107]));
				armory.push(new StructData([108]));
				armory.push(new StructData([109]));
				armory.push(new StructData([111]));
			}
			armory.push(new StructData([5]));
			armory.push(new StructData([25]));
			armory.push(new StructData([10]));
			armory.push(new StructData([15]));
			armory.push(new StructData([20]));
			armory.push(null);
			armory.push(null);
			armory.push(new ShipData([200,0]));
			armory.push(new ShipData([201,0]));
			armory.push(new ShipData([202,0]));
			armory.push(new ShipData([250,0]));
			armory.push(new ShipData([251,0]));
			armory.push(new ShipData([252,0]));
			armory.push(null);
			armory.push(null);
			//23
		}
		
		public function Rand(): Number
        {
            seed = (seed*9301+49297) % 233280;
            return seed / 233280.0;
        }
		
		public function ErrorDesync()
		{
			var i:int;
			trace("ERROR DESYNC");
			for(i = 0; i < ships.length; i++){
				ships[i].armor = -1000;
			}
			for(i = 0; i < structs.length; i++){
				structs[i].armor = -1000;
			}
		}
	}
}