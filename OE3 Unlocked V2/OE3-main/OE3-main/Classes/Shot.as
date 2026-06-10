package 
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.filters.*;
	
	public class Shot extends MovieClip 
	{
		public var drawx:Number = 0;
		public var drawy:Number = 0;
		public var xx:Number = 0;
		public var yy:Number = 0;
		public var xv:Number = 0;
		public var yv:Number = 0;
		public var t:Number = 0;
		public var tv:Number = 0;
		public var faction:int = 0;
		public var spriteW:Number = 8;
		public var spriteH:Number = 8;
		public var sheetW:int = 6;
		public var sheetH:int = 6;
		public var wide:int = 10;
		public var high:int = 8;
		public var oldvisible:Boolean = false;
		public var oldIndex:int = -1;
		public var spriteIndex:int = 0;
		public var picref;
		public var burnref;
		public var targetclock:int = 0;
		
		public var armor:Number = 1;
		public var clock:int = 0;
		public var clockb:int = 0;
		public var lifespan:int = 0;
		public var adamage:Number = 0;
		public var sdamage:Number = 0;
		public var minedamage:Number = 0;
		public var freeze:int = 0;
		public var acid:int = 0;
		public var ghost:Number = 0;
		public var force:Number = 0;
		public var popp:int = 0;
		public var cloaked:int = 0;
		public var nuker:Number = 0;
		public var shrink:int = 0;
		
		public var scanrange:int = 1000;
		public var mass:int = 0;
		public var missile:int = 0;
		public var vectored:int = 0;
		public var smash:int = 0;
		public var laser:int = 0;
		public var igniteT:int = 0;
		public var burnT:int = 0;
		public var thrust:Number = 0;
		public var turn:Number = 0;
		public var drag:Number = 0;
		public var smart:Boolean = false;
		public var animated:Boolean = false;
		public var speedmax:Number = 100;
		public var engineburn:Boolean = false;
		public var burn:Number = 0;
		public var boomtype:Array = new Array(3);
		
		public var shotowner;
		public var ships;
		public var structs;
		public var mom;
		public var targets:Array = new Array();
		public var tcpu:TargetCPU;
		
		public var tstructs:Boolean = true;
		public var tships:Boolean = true;
		public var tshots:Boolean = false;
		
		public var pic:Bitmap;
		public var burnpic:Bitmap;
		public var filt:GlowFilter = new GlowFilter; 
		
		public function Shot(m, sd, f:int, xxx:Number, yyy:Number, xxv:Number, yyv:Number, tt:Number, o)
		{
			xx = xxx;
			yy = yyy;
			drawx = xx;
			drawy = yy;
			x = drawx;
			y = drawy;
			xv = xxv;
			yv = yyv;
			t = tt;
			faction = f;
			armor = 1;
			mom = m;
			ships = mom.ships;
			structs = mom.structs;
			shotowner = o;
			
			tstructs = sd.tstructs;
			tships = sd.tships;
			tshots = sd.tshots;
			
			armor = sd.armor;
			adamage = sd.adamage;
			sdamage = sd.sdamage;
			minedamage = sd.minedamage;
			freeze = sd.freeze;
			acid = sd.acid;
			force = sd.force;
			ghost = sd.ghost;
			lifespan = sd.lifespan;
			laser = sd.laser;
			missile = sd.missile;
			wide = sd.wide;
			high = sd.high;
			thrust = sd.thrust;
			drag = sd.drag;
			turn = sd.turn;
			speedmax = sd.speedmax;
			igniteT = sd.igniteT;
			burnT = sd.burnT;
			vectored = sd.vectored;
			smash = sd.smash;
			popp = sd.popp;
			nuker = sd.nuker;
			shrink = sd.shrink;
			engineburn = sd.engineburn;
			animated = sd.animated;
			scanrange = sd.scanrange;
			if(sd.boomtype != null){
				boomtype[0] = sd.boomtype[0];
				boomtype[1] = sd.boomtype[1];
				boomtype[2] = sd.boomtype[2];
			}else{
				boomtype = null;
			}
			blendMode = sd.blendmode;
			
			if(laser == 0){
				sheetW = sd.sheetW;
				sheetH = sd.sheetH;
				if(mom.l.ssshots[sd.shotidi][sd.shotidj][sd.shotidk] == null){
					mom.l.StoreShot(sd.shotidi,sd.shotidj,sd.shotidk);
				}
				picref = mom.l.ssshots[sd.shotidi][sd.shotidj][sd.shotidk];
				if(engineburn == true){
					/*if(mom.l.ssshotburns[sd.shotidi][sd.shotidj][sd.shotidk] == null){
						mom.l.StoreShotBurn(sd.shotidi,sd.shotidj,sd.shotidk);
					}*/
					burnref = mom.l.ssshotburns[sd.shotidi][sd.shotidj];
				}
	
				spriteW = picref.width / sheetW;
				spriteH = picref.height / sheetH;
			}
			
			if(laser == 0){
				pic = new Bitmap();
				pic.bitmapData = new BitmapData(Math.floor(spriteW),Math.floor(spriteH),true,0xFFFFFFFF);
				this.addChild(pic);
				pic.x = -.5*spriteW;
				pic.y = -.5*spriteH;
				
				if(engineburn == true){
					burnpic = new Bitmap();
					burnpic.bitmapData = new BitmapData(Math.floor(spriteW),Math.floor(spriteH),true,0xFFFFFFFF);
					this.addChild(burnpic);
					burnpic.x = -.5*Math.floor(spriteW);
					burnpic.y = -.5*Math.floor(spriteH);
					burnpic.blendMode = "add";
				}
			}
			if(laser == 1){
				graphics.lineStyle(sd.shotidj+1,sd.lasercolora);
				graphics.beginFill(0xFF0000); 
				graphics.moveTo(0, 0); 
				graphics.lineTo(xxv-x, yyv-y);
				filt.color = sd.lasercolorb;
				filt.blurX = 10; 
				filt.blurY = 10;
				filt.strength = .6;
				this.filters = [filt]
			}
			if(t > 1){
				t = t -1;
			}
			if(t < 0){
				t = t +1;
			}
			visible = false;
			
			if(laser == 0){
				tcpu = new TargetCPU(mom,this);
				tcpu.tshots = tshots;
				tcpu.tships = tships;
				tcpu.tstructs = tstructs;
			}
		}
		
		public function Die()
		{
			var i:int;
			if(laser == 0){
				pic.bitmapData.dispose();
				if(engineburn == true){
					burnpic.bitmapData.dispose();
				}
			}
			targets = [];
			shotowner = null;
		}
		
		public function Boom()
		{
			var a;
			var i:int;
			var d:Number;
			var db:Number;
			var dd:Number;
			var t:Number;
			if(boomtype != null && laser == 0){
				mom.GenEffect(boomtype,drawx,drawy,0,0);
			}
			if(boomtype != null && laser == 1){
				mom.GenEffect(boomtype,xv,yv,0,0);
			}
			if(popp == 2){ //Nuke
				for(i = 0; i < mom.structs.length; i++){
					a = mom.structs[i];
					a.shield = 0;
					a.tacshield = 0;
					a.shieldt = 10;
					d = nuker - Math.sqrt(Math.pow(xx - a.xx,2)+Math.pow(yy - a.yy,2));
					db = d + 2 * nuker;
					d = d / nuker
					db = d / (3 * nuker);
					if(d < 0){
						d = 0;
					}
					if(db < 0){
						db = 0;
					}
					a.armor = a.armor - adamage * d;
				}
				for(i = 0; i < mom.ships.length; i++){
					a = mom.ships[i];
					a.shield = 0;
					a.tacshield = 0;
					a.shieldt = 10;
					d = nuker - Math.sqrt(Math.pow(xx - a.xx,2)+Math.pow(yy - a.yy,2));
					d = d / nuker
					if(d < 0){
						d = 0;
					}
					a.armor = a.armor - adamage * d;
					a.xv = a.xv + 5 * db * (a.xx - xx) / Math.sqrt(Math.pow(xx - a.xx,2)+Math.pow(yy - a.yy,2));
					a.yv = a.yv + 5 * db * (a.yy - yy) / Math.sqrt(Math.pow(xx - a.xx,2)+Math.pow(yy - a.yy,2));
				}
				for(i = 0; i < mom.shots.length; i++){
					a = mom.shots[i];
					d = nuker - Math.sqrt(Math.pow(xx - a.xx,2)+Math.pow(yy - a.yy,2));
					if(d > 0){
						a.armor = 0;
					}
				}
				for(i = 0; i < nuker/3; i++){
					t = Math.random() * 2 * 3.141592;
					d = Math.random() * nuker;
					mom.GenEffect([5,Math.floor(Math.random() * 4.99),2],xx + d * Math.cos(t),yy + d * Math.sin(t),0,0);
					mom.effects[mom.effects.length - 1].delayt = Math.floor(d/10);
				}
				if(mom.gui.nukeflash.visible == true){
					mom.gui.nukeflash.gotoAndStop(5);
				}
				mom.gui.nukeflash.visible = true;
			}
			if(popp == 3){ //Acid
				for(i = 0; i < mom.structs.length; i++){
					a = mom.structs[i];
					d = nuker - Math.sqrt(Math.pow(xx - a.xx,2)+Math.pow(yy - a.yy,2));
					d = d / nuker
					if(d < 0){
						d = 0;
					}
					if(a.shield == 0){
						a.acid = a.acid + acid * d;
					}
				}
				for(i = 0; i < mom.ships.length; i++){
					a = mom.ships[i];
					d = nuker - Math.sqrt(Math.pow(xx - a.xx,2)+Math.pow(yy - a.yy,2));
					d = d / nuker
					if(d < 0){
						d = 0;
					}
					if(a.shield == 0){
						a.acid = a.acid + acid * d;
					}
				}
				for(i = 0; i < nuker/3; i++){
					t = Math.random() * 2 * 3.141592;
					d = Math.random() * nuker;
					mom.GenEffect([50,Math.floor(Math.random() * 4.99),2],xx + d * Math.cos(t),yy + d * Math.sin(t),0,0);
					mom.effects[mom.effects.length - 1].delayt = Math.floor(d/10);
				}
				for(i = 0; i < nuker/6; i++){
					t = Math.random() * 2 * 3.141592;
					d = Math.random() * nuker;
					mom.GenEffect([7,Math.floor(Math.random() * 4.99),2],xx + d * Math.cos(t),yy + d * Math.sin(t),0,0);
					mom.effects[mom.effects.length - 1].delayt = Math.floor(d/10);
				}
			}
			if(popp == 4){ //Freeze
				for(i = 0; i < mom.structs.length; i++){
					a = mom.structs[i];
					d = nuker - Math.sqrt(Math.pow(xx - a.xx,2)+Math.pow(yy - a.yy,2));
					d = d / nuker
					if(d < 0){
						d = 0;
					}
					if(a.shield == 0 && d > 0){
						if(a.frozen == 0){
							a.RenderFreeze();
						}
						if(a.frozen < freeze){
							a.frozen = freeze;
						}
					}
				}
				for(i = 0; i < mom.ships.length; i++){
					a = mom.ships[i];
					d = nuker - Math.sqrt(Math.pow(xx - a.xx,2)+Math.pow(yy - a.yy,2));
					d = d / nuker
					if(d < 0){
						d = 0;
					}
					if(a.shield == 0 && d > 0){
						a.xv = a.xv * .2;
						a.yv = a.yv * .2;
						if(a.frozen == 0){
							a.RenderFreeze();
						}
						if(a.frozen < freeze){
							a.frozen = freeze;
						}
					}
				}
				for(i = 0; i < nuker/3; i++){
					t = Math.random() * 2 * 3.141592;
					d = Math.random() * nuker;
					mom.GenEffect([53,Math.floor(Math.random() * 4.99),2],xx + d * Math.cos(t),yy + d * Math.sin(t),0,0);
					mom.effects[mom.effects.length - 1].delayt = Math.floor(d/10);
				}
			}
			if(popp == 5){ //Emp
				for(i = 0; i < mom.structs.length; i++){
					a = mom.structs[i];
					d = nuker - Math.sqrt(Math.pow(xx - a.xx,2)+Math.pow(yy - a.yy,2));
					d = d / nuker
					if(d < 0){
						d = 0;
					}
					if(d > 0){
						a.shield = 0;
						a.tacshield = 0;
						a.shieldt = 10;
					}
				}
				for(i = 0; i < mom.ships.length; i++){
					a = mom.ships[i];
					d = nuker - Math.sqrt(Math.pow(xx - a.xx,2)+Math.pow(yy - a.yy,2));
					d = d / nuker
					if(d < 0){
						d = 0;
					}
					if(d > 0){
						a.shield = 0;
						a.tacshield = 0;
						a.shieldt = 10;
					}
				}
				for(i = 0; i < nuker/5; i++){
					t = Math.random() * 2 * 3.141592;
					d = Math.random() * nuker;
					mom.GenEffect([6,Math.floor(Math.random() * 4.99),2],xx + d * Math.cos(t),yy + d * Math.sin(t),0,0);
					mom.effects[mom.effects.length - 1].delayt = Math.floor(d/10);
				}
			}
		}
		
		public function DoAIMissile()
		{
			var i:int;
			var j:int;
			var tx:Number;
			var ty:Number;
			var txv:Number;
			var tyv:Number;
			var d:Number;
			var davg:Number;
			var did:int;
			
			var c:Number; //tuning constant
			var d_vx:Number; //desired velocity
			var d_vy:Number; //desired velocity
			var s_vx:Number; //steering velocity
			var s_vy:Number; //steering velocity
			var st:Number; //steering theta
			
			switch(missile){
				case 1: //Homing
					//QuickScan
					did = -1
					d = 100000000;
					for(i = 0; i < targets.length; i++){
						tx = targets[i].xx;
						ty = targets[i].yy;
						if((tx - xx) * (tx - xx) + (ty - yy) * (ty - yy) < d){
							d = (tx - xx) * (tx - xx) + (ty - yy) * (ty - yy);
							did = i;
						}
					}
					if(did > -1){
						tx = targets[did].xx;
						ty = targets[did].yy;
						if(1){
							tx = tx// + (-500 + Math.random() * 1000)*targets[did].jamming;
							ty = ty// + (-500 + Math.random() * 1000)*targets[did].jamming;
						}
						if(vectored > 0){
							d = Math.sqrt((tx - xx) * (tx - xx) + (ty - yy) * (ty - yy));
							xv = .9 * xv + 4 * (tx - xx) / d;
							yv = .9 * yv + 4 * (ty - yy) / d;
							d = 0;
						}
						if(smart == true){
							txv = targets[did].xv;
							tyv = targets[did].yv;
							c = .2 * Math.sqrt(Math.pow(xx-tx,2)+Math.pow(yy-ty,2))
							d_vx = -1*speedmax*(xx-tx-c*txv)/Math.sqrt(Math.pow(xx-tx-c*txv,2)+Math.pow(yy-ty-c*tyv,2));
							d_vy = -1*speedmax*(yy-ty-c*tyv)/Math.sqrt(Math.pow(xx-tx-c*txv,2)+Math.pow(yy-ty-c*tyv,2));
							s_vx = d_vx - xv;
							s_vy = d_vy - yv;
							st = (Math.atan2(s_vy,s_vx)+1.57)/(6.283)
							if(st < 0){
								st = st + 1
							}
							d = -1 * Tools.MathRotateDirection(t,st);
						}
						if(smart == false){
							st = (Math.atan2(yy-ty,xx-tx)-1.57)/(6.283)
							d = Tools.MathRotateDirection(t,st);
						}
						
						if(Math.abs(d) < turn){
							d = 0;
							t = st;
						}
						if(d < -.01){
							DoCommand(1);
						}
						if(d > .01){
							DoCommand(2);
						}
						if(burnT > 0){
							DoCommand(3);
							burnT--;
						}
						xv = xv * drag;
						yv = yv * drag;
					}
				break;
				case 2:
					if(burnT > 0){
						DoCommand(3);
						burnT--;
					}
				break;
			}
		}
		
		public function DoAITargets()
		{
			var i:int;
			if(missile == 0 || missile == 2){
				targets = new Array();
				tcpu.DoAITargets(targets,1,xx,yy,scanrange)
			}
			if(missile == 1 && shotowner != null && (shotowner is Turret || shotowner is Ship)){
				targets = new Array();
				for(i = 0; i < shotowner.targets.length; i++){
					targets.push(shotowner.targets[i]);
				}
			}
			if(missile == 1 && (shotowner == null || shotowner is Struct)){
				targets = new Array();
				tcpu.DoAITargets(targets,1,xx,yy,scanrange)
			}
		}
		
		public function Move():void
		{
			if(laser == 0){
				if(clock == 0){
					DoAITargets();
				}
				if(clock > 0){
					if(missile > 0 && clock > igniteT){
						if(targets.length == 0 && clock % 2 == 0){
							DoAITargets();
						}
						tcpu.DoAICleanTargets(targets);
						DoAIMissile();
					}
				}
				/*if(clock > lifespan){
					armor = 0;
				}*/
				xx = xx + xv;
				yy = yy + yv;
				if(t > 1){
					t = t - 1;
				}
				if(t < 0){
					t = t + 1;
				}
			}
			/*if(laser == 1){
				if(clock > lifespan){
					armor = 0;
					graphics.clear();
				}
			}*/
			if(shotowner != null && ((shotowner is Turret && shotowner.up.armor <= 0) || (!(shotowner is Turret) && shotowner.armor <= 0))){
				shotowner = null;
			}
			clock = clock + 1
		}
		
		public function DoCommand(c:int)
		{
			if(1){
				switch(c){
					case 1: //turn left
						t = t - turn
					break;
					case 2: //turn right
						t = t + turn
					break;
					case 3: //thrust
						//xv = xv + thrust*Math.sin(t*2*3.141592);
						//yv = yv - thrust*Math.cos(t*2*3.141592);
						if(Math.sqrt(Math.pow(xv + thrust * Math.sin(t*6.283),2)+Math.pow(yv - thrust * Math.cos(t*6.283),2)) < speedmax){
							xv = xv + thrust*Math.sin(t*6.283);
							yv = yv - thrust*Math.cos(t*6.283);
						}else{
							xv = xv *.9;
							yv = yv *.9;
						}
						if(engineburn == true){
							if(burn + .5 < 1){
								burn = burn + .5;
							}else{
								burn = 1;
							}
						}
					break;
				}
			}
			if(t > 1){
				t = t - 1;
			}
			if(t < 0){
				t = t + 1;
			}
		}
		
		public function DoGraphics()
		{
			var d;
			//Interpolate
			d = .02 * Math.sqrt((xx - drawx) * (xx - drawx) + (yy - drawy) * (yy - drawy));
			drawx = drawx + (xx - drawx) * .25;
			drawy = drawy + (yy - drawy) * .25;
			x = Math.floor(drawx);
			y = Math.floor(drawy);
			
			//Burn
			burn = burn - .05;
			if(burn > 1){
				burn = 1;
			}
			if(burn < 0){
				burn = 0;
			}
			if(burnpic != null){
				burnpic.alpha = burn;
				if(burn > 0){
					burnpic.visible = true;
				}else{
					burnpic.visible = false;
				}
			}
		}
		
		public function Hit(ss)
		{
			armor = armor - ss.adamage;
			if(armor <= 0)
			{
				armor = 0;
			}
			ss.armor = 0;
		}
		
		public function Render()
		{
			var frames:int = sheetW * sheetH;
			//SpecialEffect
			if(mom.paus == false){
				if(popp == 2 && clock > igniteT){
					mom.GenEffect([5,0],drawx,drawy,0,0);
				}
				if(popp == 3 && clock > igniteT){
					mom.GenEffect([50,0],drawx,drawy,0,0);
				}
				if(popp == 4 && clock > igniteT){
					mom.GenEffect([53,0],drawx,drawy,0,0);
				}
				if(shrink > 0){
					clockb++;
					scaleX = .7 + .3 *Math.sin(clockb);
					scaleY = scaleX;
				}
			}
			//
			if(laser > 0){
				visible = true;
			}
			alpha = ghost;
			if(missile >= 0 && laser == 0 && animated == false){
				spriteIndex = Math.floor(frames * (t+.5*(1/(frames))));
			}
			if(animated == true){
				spriteIndex = spriteIndex+1;//clock % (sheetW * sheetH);
			}
			if(spriteIndex < 0){
				spriteIndex = 0;
			}
			if(spriteIndex >= frames){
				spriteIndex = spriteIndex - frames;
			}
			if(laser == 0){
				/*pic.x = -.5*spriteW;
				pic.y = -.5*spriteH;
				if(burnpic != null){
					burnpic.x = -.5*spriteW;
					burnpic.y = -.5*spriteH;
				}*/
			}			
			if(x + .5 * spriteW < -1 * mom.game.x || x - .5 * spriteW > -1 * mom.game.x + mom.resX || y + .5 * spriteH < -1 * mom.game.y || y - .5 * spriteH > -1 * mom.game.y + mom.resY){
				visible = false;
			}else{
				visible = true;
			}
			if(laser == 0 && visible == true && (oldIndex != spriteIndex || oldvisible == false)){
				pic.bitmapData.copyPixels(picref, new Rectangle( (spriteIndex % sheetW) * spriteW, Math.floor(spriteIndex / sheetW) * spriteH, spriteW, spriteH), new Point(0,0));
				if(engineburn == true){
					burnpic.bitmapData.copyPixels(burnref, new Rectangle( (spriteIndex % sheetW) * spriteW, Math.floor(spriteIndex / sheetW) * spriteH, spriteW, spriteH), new Point(0,0));
				}
			}
			if(engineburn == true){
				burnpic.alpha = burn;
			}
			oldIndex = spriteIndex;
			oldvisible = visible;
		}
	}
}