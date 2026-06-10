package 
{
	import flash.display.MovieClip;
	import flash.text.*;
	import flash.events.MouseEvent;
	import flash.display.Graphics;
		
	public class GUI extends MovieClip 
	{
		var mom;
		
		var nukeflash:Nukeflash;
		var reticle:MovieClip;
		var armorbar:ArmorBar;
		var shieldbar:ShieldBar;
		var buildbar:BuildBar;
		var buildrad:MovieClip;
		var buildradb:MovieClip;
		var buildspot:BuildSpot;
		var guidata:GUIData;
		var guibuild:GUIBuild;
		var guienergy:GUIEnergy;
		var guimetal:GUIMetal;
		var guiupgrade:GUIUpgrade;
		var guidisctxt:GUIDiscTxt;
		var buildwide:int;
		var buildhigh:int;
		var buildmine:Boolean;
		var buildspots:Array = new Array();
		var buildknobs:Array = new Array();
		var upgradeknobs:Array = new Array();
		var knobquit:KnobQuit;
		var knobmute:KnobMute;
		var knobpause:KnobPause;
		var knobhelp:KnobHelp;
		var tutorial:Tutorial;
		
		public var playersscreen:PlayersScreen;
		
		public function GUI(m)
		{
			mom = m;
			
			var i:int;
			var j:int;
			var k:int;
			var p:int;
			var tier:int;
			
			nukeflash = new Nukeflash();
			addChild(nukeflash);
			nukeflash.visible = false;
			nukeflash.x = 0;
			nukeflash.y = 0;
			nukeflash.blendMode = "screen";
			nukeflash.gotoAndStop(1);
			
			reticle = new MovieClip();
			addChild(reticle);
			reticle.visible = false;
			reticle.x = -1000;
			reticle.y = -1000;
			reticle.alpha = .75;
			reticle.cacheAsBitmap = true;
			
			buildrad = new MovieClip();
			addChild(buildrad);
			buildrad.visible = false;
			buildrad.x = -1000;
			buildrad.y = -1000;
			
			buildradb = new MovieClip();
			addChild(buildradb);
			buildradb.visible = false;
			buildradb.x = -1000;
			buildradb.y = -1000;
			buildradb.alpha = .7
			buildradb.blendMode = "add";
			
			buildspot = new BuildSpot();
			addChild(buildspot);
			buildspot.visible = false;
			buildspot.x = -1000;
			buildspot.y = -1000;
			
			armorbar = new ArmorBar();
			addChild(armorbar);
			armorbar.visible = false;
			armorbar.x = -1000;
			armorbar.y = -1000;
			armorbar.alpha = 1;
			
			shieldbar = new ShieldBar();
			addChild(shieldbar);
			shieldbar.visible = false;
			shieldbar.x = -1000;
			shieldbar.y = -1000;
			shieldbar.alpha = 1;
			
			buildbar = new BuildBar();
			addChild(buildbar);
			buildbar.visible = false;
			buildbar.x = -1000;
			buildbar.y = -1000;
			buildbar.alpha = 1;
			
			guibuild = new GUIBuild();
			addChild(guibuild);
			guibuild.y = mom.resY;
			guibuild.x = 0;
			
			guidisctxt = new GUIDiscTxt();
			addChild(guidisctxt);
			guidisctxt.y = 60
			guidisctxt.x = .5 * mom.resX;
			guidisctxt.visible = false;
			
			guienergy = new GUIEnergy();
			addChild(guienergy);
			guienergy.x = .5 * mom.resX - 50;
			guienergy.a.cacheAsBitmap = true;
			
			guimetal = new GUIMetal();
			addChild(guimetal);
			guimetal.x = .5 * mom.resX - 50;
			guimetal.y = guienergy.height;
			guimetal.a.cacheAsBitmap = true;
			
			/*knobpause.mom = mom;
			knobpause.x = mom.resX * .5;
			knobpause.y = 20;*/
			
			knobmute = new KnobMute();
			addChild(knobmute);
			knobmute.mom = mom;
			knobmute.x = 150;//knobpause.x - 42;
			knobmute.y = .5 * knobmute.height;
			if(mom.mute == 0){
				knobmute.a.gotoAndStop(4);
			}else{
				knobmute.a.gotoAndStop(1);
			}
			
			knobpause = new KnobPause();
			addChild(knobpause);
			knobpause.mom = mom;
			knobpause.x = 150 + knobmute.width;//knobpause.x - 42;
			knobpause.y = .5 * knobpause.height;
			if(mom.paus == 1){
				knobpause.a.gotoAndStop(4);
			}else{
				knobpause.a.gotoAndStop(1);
			}
			if(mom.GameMode == 1){
				knobpause.visible = false;
			}else{
				knobpause.visible = true;
			}
			
			knobhelp = new KnobHelp();
			addChild(knobhelp);
			knobhelp.mom = mom;
			knobhelp.x = 150 - knobhelp.width;//knobpause.x - 42;
			knobhelp.y = .5 * knobhelp.height;
			if(mom.GameMode == 1){
				knobhelp.visible = false;
			}else{
				knobhelp.visible = true;
			}
			
			/*knobquit.mom = mom;
			knobquit.x = 0;
			knobquit.y = 0;
			
			knobhelp.mom = mom;
			knobhelp.x = 0;
			knobhelp.y = 30;*/
			
			guiupgrade = new GUIUpgrade();
			addChild(guiupgrade);
			guiupgrade.y = mom.resY;
			guiupgrade.x = 0;
			guiupgrade.visible = false;
			
			guidata = new GUIData();
			addChild(guidata);
			guidata.y = mom.resY;
			guidata.x = 0;
			guidata.visible = false;
			
			playersscreen = new PlayersScreen();
			addChild(playersscreen);
			playersscreen.y = 0.05 * mom.resY;
			playersscreen.x = 10;
			playersscreen.visible = false;
			
			if(mom.GameMode == 1 && mom.playernames.length > 1){
				var rattxt:String;
				if(mom.playerratings[0] == 0){
					rattxt = "NEWB";
				}else{
					rattxt = String(mom.playerratings[0]);
				}
				playersscreen.pblue.text = rattxt + " " + mom.playernames[0];
				if(mom.playerratings[1] == 0){
					rattxt = "NEWB";
				}else{
					rattxt = String(mom.playerratings[1]);
				}
				playersscreen.pred.text = rattxt + " " + mom.playernames[1];
				playersscreen.visible = true;
			}
			
			for(i = 0; i < guibuild.numChildren; i++){
				if(guibuild.getChildAt(i) is KnobBuild){
					buildknobs.push(guibuild.getChildAt(i));
					buildknobs[i].mom = mom;
					buildknobs[i].b.visible = true;
					buildknobs[i].s = i + 1;
					if(i > mom.players[mom.me].structbag.length - 1 ||  mom.players[mom.me].structbag[i+1] == null){
						buildknobs[i].alpha = .25;
						buildknobs[i].b.visible = false;
						buildknobs[i].lock = true;
					}else{
						buildknobs[i].b.bitmapData = mom.l.ssicons[mom.players[mom.me].structbag[i+1].iconid][mom.players[mom.me].structbag[i+1].rarity];
					}
					/*if(buildknobs[i].v[0] == 2){
						buildknobs[i].Disable();
					}*/
				}
			}
			
			for(i = 0; i < guiupgrade.numChildren; i++){
				if(guiupgrade.getChildAt(i) is KnobBuild){
					upgradeknobs.push(guiupgrade.getChildAt(i));
					upgradeknobs[i].mom = mom;
					upgradeknobs[i].s = 0;
				}
			}
			guiupgrade.knobkill.mom = mom;
			
			knobquit = new KnobQuit();
			knobquit.mom = mom;
			knobquit.x = .5 * knobquit.width;
			knobquit.y = .5 * knobquit.height;
			addChild(knobquit);

			setChildIndex(armorbar,0);
			setChildIndex(shieldbar,0);
			setChildIndex(buildbar,0);
			
			trace("STUFF");
			trace(mom.account.campaignstart);
			trace(mom.missions.nextsun);
			trace(mom.account.campaigndanger);
			if(mom.GameMode == 0 && mom.missions.nextsun == mom.account.campaignstart && mom.account.campaigndanger == 0){
				tutorial = new Tutorial();
				addChild(tutorial);
				tutorial.x = 0;
				tutorial.y = 0;
				tutorial.visible = true;
				mom.paus = 1;
				tutorial.tf.gotoAndStop(1);
				tutorial.kn.mom = mom;
			}
		}
		
		public function DoGUI()
		{
			var s;
			var i:int;
			if(nukeflash.visible == true){
				nukeflash.gotoAndStop(nukeflash.currentFrame + 1);
				if(nukeflash.currentFrame == nukeflash.totalFrames){
					nukeflash.visible = false;
					nukeflash.gotoAndStop(1);
					trace("Reset Nuke Effect");
				}
			}
			if(buildspot.visible == true){
				mom.players[mom.me].DoRadar();
				DoBuildSpot();
			}
			if(buildspot.visible == false){
				buildrad.visible = false;
			}
			if(guiupgrade.visible == true && mom.selectid != null && mom.selectid.armor < 0){
				guiupgrade.visible = false;
				reticle.visible = false;
				mom.selectid = null;
			}
			if(mom.selectid != null && mom.selectid.armor < 0){
				mom.selectid = null;
				reticle.visible = false;
			}
			if(mom.selectid == null){
				reticle.visible = false;
			}
			if(guiupgrade.visible == true && mom.selectid != null){
				guiupgrade.x = mom.selectid.x + mom.game.x;
				guiupgrade.y = mom.selectid.y + mom.game.y;
			}
			buildbar.visible = false;
			armorbar.visible = false;
			shieldbar.visible = false;
			buildradb.visible = false;
			for(i = 0; i < mom.structs.length; i++){
				s = mom.structs[i];
				if(mom.mouseX - mom.game.x > s.x - 1.5 * s.wide && mom.mouseX - mom.game.x < s.x + 1.5 * s.wide && mom.mouseY - mom.game.y > s.y - 1.5 * s.high && mom.mouseY - mom.game.y < s.y + 1.5 * s.high){
					armorbar.x = s.x + mom.game.x;
					armorbar.y = s.y + s.high + 18 + mom.game.y;
					armorbar.gotoAndStop(int(100 * s.armor/s.armormax));
					armorbar.scaleX = s.armormax/300;
					armorbar.scaleX = Math.pow(armorbar.scaleX,1/3);
					armorbar.visible = true;
					if(s.shield > 0){
						shieldbar.x = s.x + mom.game.x;
						shieldbar.y = s.y + s.high + 18 + mom.game.y + armorbar.height;
						shieldbar.gotoAndStop(int(100 * s.shield/s.shieldmax));
						shieldbar.scaleX = s.armormax/300;
						shieldbar.scaleX = Math.pow(shieldbar.scaleX,1/3);
						shieldbar.visible = true;
					}
					if(s.tacshield > 0){
						shieldbar.x = s.x + mom.game.x;
						shieldbar.y = s.y + s.high + 18 + mom.game.y + armorbar.height;
						shieldbar.gotoAndStop(int(100 * s.tacshield/s.tacshieldmax));
						shieldbar.scaleX = s.armormax/300;
						shieldbar.scaleX = Math.pow(shieldbar.scaleX,1/3);
						shieldbar.visible = true;
					}
					if(s.upgraded == true && s.hangars.length > 0){
						buildbar.x = armorbar.x;
						buildbar.y = armorbar.y + armorbar.height;
						if(s.shield > 0 || s.tacshield > 0){
							buildbar.y = armorbar.y + 2 * armorbar.height;
						}
						buildbar.gotoAndStop(int(100 - 100 * s.hangars[0].launchcool / s.hangars[0].launchheat));
						buildbar.visible = true;
					}
					if(s.turretrange > 0){
						buildradb.x = s.x + mom.game.x;
						buildradb.y = s.y + mom.game.y;
						buildradb.graphics.clear();
						buildradb.graphics.lineStyle(2,0xFF3333);
						buildradb.graphics.drawCircle(0,0,s.turretrange);
						buildradb.visible = true;
						buildradb.alpha = .7;
						buildradb.blendMode = "screen";
					}
				}
			}
			for(i = 0; i < mom.ships.length; i++){
				s = mom.ships[i];
				if(mom.mouseX - mom.game.x > s.x - 1.5 * s.wide && mom.mouseX - mom.game.x < s.x + 1.5 * s.wide && mom.mouseY - mom.game.y > s.y - 1.5 * s.high && mom.mouseY - mom.game.y < s.y + 1.5 * s.high){
					armorbar.x = s.x + mom.game.x;
					armorbar.y = s.y + s.high + 18 + mom.game.y;
					armorbar.gotoAndStop(int(100 * s.armor/s.armormax));
					armorbar.scaleX = s.armormax/300;
					armorbar.scaleX = Math.pow(armorbar.scaleX,1/3);
					armorbar.visible = true;
					if(s.shield > 0){
						shieldbar.x = s.x + mom.game.x;
						shieldbar.y = s.y + s.high + 18 + mom.game.y + armorbar.height;
						shieldbar.gotoAndStop(int(100 * s.shield/s.shieldmax));
						shieldbar.scaleX = s.armormax/300;
						shieldbar.scaleX = Math.pow(shieldbar.scaleX,1/3);
						shieldbar.visible = true;
					}
					if(s.tacshield > 0){
						shieldbar.x = s.x + mom.game.x;
						shieldbar.y = s.y + s.high + 18 + mom.game.y + armorbar.height;
						shieldbar.gotoAndStop(int(100 * s.tacshield/s.tacshieldmax));
						shieldbar.scaleX = s.armormax/300;
						shieldbar.scaleX = Math.pow(shieldbar.scaleX,1/3);
						shieldbar.visible = true;
					}
					if(buildbar.visible == true){
						buildbar.visible = false;
					}
				}
			}
			armorbar.scaleX = armorbar.scaleX * .75;
			shieldbar.scaleX = armorbar.scaleX;
			buildbar.scaleX = armorbar.scaleX;
			
			guienergy.b.text = String(Math.floor(mom.players[mom.me].energy));
			if(Math.floor(mom.players[mom.me].energyrate) >= 0){
				guienergy.c.text = "+" + String(Math.floor(mom.players[mom.me].energyrate));
			}else{
				guienergy.c.text = String(Math.floor(mom.players[mom.me].energyrate));
			}
			guimetal.b.text = String(Math.floor(mom.players[mom.me].metal));
			if(Math.floor(mom.players[mom.me].metalrate) >= 0){
				guimetal.c.text = "+" + String(Math.floor(mom.players[mom.me].metalrate));
			}else{
				guimetal.c.text = String(Math.floor(mom.players[mom.me].metalrate));
			}
			
			if(guidata.visible == true && guidata.nametxt.text != "Sell"){
				DoGUIDataColors()
			}
		}
		
		public function DoBuildSpot()
		{
			var i:int;
			var j:int;
			var xx:int;
			var yy:int;
			var xxx:int;
			var yyy:int;
			this.setChildIndex(buildspot,0);
			xx = 32*Math.round((mouseX -16*(buildwide % 2) - mom.game.x)/32)+16*(buildwide % 2);
			yy = 32*Math.round((mouseY -16*(buildhigh % 2) - mom.game.y)/32)+16*(buildhigh % 2);
			buildspot.x = xx + mom.game.x;
			buildspot.y = yy + mom.game.y;
			buildrad.x = buildspot.x;
			buildrad.y = buildspot.y;
			for(i = 0; i < buildwide; i++){
				for(j = 0; j < buildhigh; j++){
					xx = buildspot.x + buildspots[0].x + 32 * i;
					yy = buildspot.y + buildspots[0].y + 32 * j;
					xxx = Math.floor((xx - 16 * buildwide + 16 - mom.game.x)/32);
					yyy = Math.floor((yy - 16 * buildhigh + 16 - mom.game.y)/32);
					if(buildwide == 3){
						xxx = xxx + 1;
					}
					if(buildhigh == 3){
						yyy = yyy + 1;
					}
					if(mom.players[mom.me].Buildability( xxx,yyy,1,1) == true){
						buildspots[i * buildhigh + j].gotoAndStop(1);
					}else{
						buildspots[i * buildhigh + j].gotoAndStop(2);
					}
				}
			}
		}
		
		public function DoGraphics()
		{
			
		}
		
		public function DrawReticle(w:Number)
		{
			var l:int = 5;
			w = w + 5;
			reticle.graphics.clear();
			reticle.graphics.lineStyle(2,0xFFFFFF);
			
			reticle.graphics.moveTo(-w, -w+l);
			reticle.graphics.lineTo(-w, -w);
			reticle.graphics.lineTo(-w+l, -w);
			
			reticle.graphics.moveTo(w, -w+l);
			reticle.graphics.lineTo(w, -w);
			reticle.graphics.lineTo(w-l, -w);
			
			reticle.graphics.moveTo(-w, w-l);
			reticle.graphics.lineTo(-w, w);
			reticle.graphics.lineTo(-w+l, w);
			
			reticle.graphics.moveTo(w, w-l);
			reticle.graphics.lineTo(w, w);
			reticle.graphics.lineTo(w-l, w);
		}
		
		public function UnPushBuildKnobs()
		{
			var i:int;
			for(i = 0; i < buildknobs.length; i++){
				if(buildknobs[i].a.currentFrame != 3){
					buildknobs[i].a.gotoAndStop(1);
				}
			}
			buildspot.visible = false;
		}
		
		public function SetupBuildRad(s:int)
		{
			var i:int;
			var r:Number;
			r = 0;
			
			buildrad.blendMode = "screen";
			buildrad.alpha = .7;
			buildrad.visible = true;
			buildrad.x = -2000;
			buildrad.y = -2000;
			buildrad.graphics.clear();
			if(s > 0){
				buildrad.graphics.lineStyle(2,0xFF3333);
				buildrad.graphics.drawCircle(0,0,s);
			}
		}
		
		
		public function SetupBuildSpot(b)
		{
			var i:int;
			var j:int;
			var a;
			var xx:int = b.buildwide;
			var yy:int = b.buildhigh;
			for(i = 0; i < buildspots.length; i++){
				buildspot.removeChild(buildspots[i]);
			}
			buildspots = new Array();
			
			for(i = 0; i < xx; i++){
				for(j = 0; j < yy; j++){
					a = new BuildBlip();
					a.x = -32*(xx/2)+i*32+16;
					a.y = -32*(yy/2)+j*32+16;
					a.gotoAndStop(1);
					buildspot.addChild(a);
					buildspots.push(a);
				}
			}
			buildspot.blendMode = "add";
			buildspot.visible = true;
			buildspot.x = -1000;
			buildspot.y = -1000;
			buildwide = xx;
			buildhigh = yy;
		}
		
		public function SetupGUIData(s,i:int,b:int)
		{
			var j:int;
			var k:int;
			var t:String;
			guidata.nametxt.text = s.nametext;
			guidata.etxt.text = s.costenergy;
			guidata.mtxt.text = s.costmetal;
			guidata.dtxt.text = s.desctext;
			for(j = 0; j < mom.keymap.length; j++){
				if(mom.keymap[j] == i-1){
					k = j;
				}
			}
			switch(k){
				case 49:
					t = "1";
				break;
				case 50:
					t = "2";
				break;
				case 51:
					t = "3";
				break;
				case 52:
					t = "4";
				break;
				case 53:
					t = "5";
				break;
				case 54:
					t = "6";
				break;
				case 55:
					t = "7";
				break;
				case 81:
					t = "q";
				break;
				case 87:
					t = "w";
				break;
				case 69:
					t = "e";
				break;
				case 65:
					t = "a";
				break;
				case 83:
					t = "s";
				break;
				case 68:
					t = "d";
				break;
				case 90:
					t = "z";
				break;
				case 88:
					t = "x";
				break;
				case 67:
					t = "c";
				break;
				case 86:
					t = "v";
				break;
			}
			if(b == 0){
				guidata.hktxt.text = "Hotkey: " + t;
			}else{
				guidata.hktxt.text = "";
			}
			guidata.visible = true;
		}
		
		public function SetupGUIDataB(s)
		{
			guidata.nametxt.text = "Sell";
			guidata.etxt.text = "+" + s.sellenergy;
			guidata.mtxt.text = "+" + s.sellmetal;
			guidata.dtxt.text = "Destroy this structure to regain resources.";
			guidata.hktxt.text = "";
			guidata.visible = true;
			
			var tf:TextFormat = new TextFormat();
			tf.size = 13;
			tf.font = "Impact"
			tf.color = 0xFFFFFF;
			guidata.etxt.setTextFormat(tf);
			guidata.mtxt.setTextFormat(tf);
			if(int(guidata.mtxt.text) == 0){
				guidata.mpic.visible = false;
				guidata.mtxt.visible = false;
			}else{
				guidata.mpic.visible = true;
				guidata.mtxt.visible = true;
			}
			if(int(guidata.etxt.text) == 0){
				guidata.epic.visible = false;
				guidata.etxt.visible = false;
			}else{
				guidata.epic.visible = true;
				guidata.etxt.visible = true;
			}
		}
		
		public function DoGUIDataColors()
		{
			var tf:TextFormat = new TextFormat();
			tf.size = 13;
			tf.font = "Impact"
			tf.color = 0xFFFFFF;
			if(int(guidata.etxt.text) > mom.players[mom.me].energy){
				tf.color = 0xFF0000;
				guidata.etxt.setTextFormat(tf);
			}else{
				tf.color = 0xFFFFFF;
				guidata.etxt.setTextFormat(tf);
			}
			if(int(guidata.mtxt.text) > mom.players[mom.me].metal){
				tf.color = 0xFF0000;
				guidata.mtxt.setTextFormat(tf);
			}else{
				tf.color = 0xFFFFFF;
				guidata.mtxt.setTextFormat(tf);
			}
			if(int(guidata.mtxt.text) == 0){
				guidata.mpic.visible = false;
				guidata.mtxt.visible = false;
			}else{
				guidata.mpic.visible = true;
				guidata.mtxt.visible = true;
			}
			if(int(guidata.etxt.text) == 0){
				guidata.epic.visible = false;
				guidata.etxt.visible = false;
			}else{
				guidata.epic.visible = true;
				guidata.etxt.visible = true;
			}
			guidata.visible = true;
		}
	}
}