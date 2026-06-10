package 
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	
	public class Obj extends MovieClip 
	{
		public var mom;
		public var s:Array;
		public var xx:Number = 0;
		public var yy:Number = 0;
		public var xv:Number = 0;
		public var yv:Number = 0;
		public var t:Number = 0;
		public var tv:Number = 0;
		public var faction:int = 0;
		public var teamcolor:int = 0;
		
		public var spriteW:Number = 32;
		public var spriteH:Number = 32;
		public var sheetW:int = 6;
		public var sheetH:int = 6;
		public var wide:Number = 10;
		public var high:Number = 8;
		public var redrawme:Boolean = false;
		public var oldvisible:Boolean = false;
		public var oldIndex:int = -1;
		public var spriteIndex:int = 0;
		public var lights:int = 0;
		public var lightclock:int = 0;
		public var oldlightvisible:Boolean = false;
		public var oldlightIndex:int = -1;
		public var lightIndex:int = 0;
		public var lightW:int = 6;
		public var lightH:int = 6;
		public var anim:Boolean = false;
		public var dying:int = 0;
		public var frozen:int = 0;
		public var acid:Number = 0;
		public var animspeed:Number = 0;
		public var animclock:int = 0;
		public var clock:int = 0;
		public var transformcool:int = 0;
		
		public var cloak:int = 0;
		public var cloaked:int = 0;
		public var cloakcool:int = 0;
		public var cloakheat:int = 35;
		public var cloakfieldr:int = 0;
		public var shrink:int = 0;
		
		public var ienergy:int = 0;
		public var imetal:int = 0;
		public var armor:Number = 0;
		public var shield:Number = 0;
		public var tacshield:Number = 0;
		public var tacshieldr:int = 0;
		public var armormax:Number = 100;
		public var shieldmax:Number = 100;
		public var tacshieldmax:Number = 0;
		public var armorregen:Number = 0;
		public var shieldregen:Number = 1;
		public var tacshieldregen:Number = 1;
		public var shieldt:int = 0;
		public var mass:Number = 50;
		public var energy:Number = 0;
		public var metal:Number = 0;
		public var shieldglow:Number = 0;
		public var debris:int;
		public var debrisammo:Array = new Array(3);
		public var damage:Boolean = false;
		public var transformed:Boolean = false;
		public var buildt:int = 0;
		
		public var hangars:Array = new Array();
		public var turrets:Array = new Array();
		
		public var picref;
		public var lightref;
		public var shieldref;
		public var burnref;
		public var tpicref;
		public var tlightref;
		public var tshieldref;
		public var tburnref;
		public var pic:Bitmap;
		public var lightpic:Bitmap;
		public var shieldpic:Bitmap;
		public var burnpic:Bitmap;
		public var tacshieldpic;
		
		public function Obj()
		{
			
		}
		
		public function Die()
		{
			
		}
		
		public function DoAll()
		{
			var i:int;
			var a;
			clock++;
			if(frozen > 0){
				frozen = frozen - 1;
				if(frozen == 0){
					redrawme = true;
					for(i = 0; i < turrets.length; i++){
						turrets[i].redrawme = true;
					}
				}
				if(cloaked > 0){
					cloaked = 0;
					cloakcool = cloakheat;
				}
			}
			if(shrink > 0){
				shrink = shrink - 1;
				if(shrink == 0){
					armor = -1000
				}
			}
			if(acid > 0){
				acid = acid - 1;
				armor = armor - 1;
				shield = 0;
				mom.GenEffect([7,4,0],x - wide + 2 * Math.random() * wide,y - high + 2 * Math.random() * high,0,0);
			}
			if(frozen == 0){
				armor = armor + armorregen;
				if(armor < armormax && armorregen > 0){
					mom.GenEffect([8,1,0],x - wide + 2 * Math.random() * wide,y - high + 2 * Math.random() * high,-3 + 6 * Math.random(),-3 + 6 * Math.random())
				}
				if(shieldt == 0){
					shield = shield + shieldregen;
					tacshield = tacshield + tacshieldregen;
				}else{
					shieldt--;
				}
				if(cloaked == 0 && cloakcool > 0){
					cloakcool = cloakcool - 1;
				}
				if(cloakcool == 0 && cloak > 0){
					cloaked = 1;
				}
				if(cloakcool < 0){
					cloakcool = cloakcool + 1;
				}
				if(cloakcool == 0 && cloak == 0){
					cloaked = 0;
				}
				if(cloakfieldr > 0){
					for(i = 0; i < mom.structs.length; i++){
						a = mom.structs[i];
						if(a.faction == faction && a.cloakcool <= 0 && a.cloak == 0 && a.frozen == 0 && a.cloakfieldr == 0){
							if(Math.pow((a.xx - xx),2) + Math.pow((a.yy - yy),2) < Math.pow(cloakfieldr,2)){
								a.cloaked = 1;
								a.cloakcool = -5;
							}
						}
					}
					for(i = 0; i < mom.ships.length; i++){
						a = mom.ships[i];
						if(a.faction == faction && a.cloakcool <= 0 && a.cloak == 0 && a.frozen == 0 && a.cloakfieldr == 0){
							if(Math.pow((a.xx - xx),2) + Math.pow((a.yy - yy),2) < Math.pow(cloakfieldr,2)){
								a.cloaked = 1;
								a.cloakcool = -5;
							}
						}
					}					
				}
			}
			if(armor > armormax){
				armor = armormax;
			}
			if(shield > shieldmax){
				shield = shieldmax;
			}
			if(shield < 0){
				shield = 0;
			}
			if(tacshield > tacshieldmax){
				tacshield = tacshieldmax;
			}
			if(tacshield < 0){
				tacshield = 0;
			}
		}
		
		public function DoAllStuff()
		{
			var i:int;
			if(frozen == 0){
				for(i = 0; i < hangars.length; i++){
					hangars[i].DoStuff();
				}
				for(i = 0; i < turrets.length; i++){
					turrets[i].Move();
				}
			}
		}
		
		public function Explode()
		{
			var i:int;
			var j:int;
			var k:int;
			var r;
			var reverse:int;
			
			if(armor <= 0 && scaleX == 1){
				//Debris
				if(ienergy > 0 || imetal > 0){
					for(i = 0; i < mom.players.length; i++){
						if(mom.players[i].faction == faction){
							mom.players[i].energy = mom.players[i].energy + ienergy;
							mom.players[i].metal = mom.players[i].metal + imetal;
						}
					}
					if(ienergy > 0){
						mom.GenEffect([9,4,0],xx - 10,yy,0,-2);
					}
					if(imetal > 0){
						mom.GenEffect([10,4,0],xx + 10,yy,0,-2);
					}
				}
				switch(debris){
					case 0: //Fighter
						for(i = 0; i < 4; i++){
							r = Math.floor(2.99 * Math.random());
							if(Math.random() > 0.5){ reverse = 0; }else{ reverse = 1; }
							mom.GenEffect([20 + r,2,reverse],xx - wide + 2 * Math.random() * wide,yy - high + 2 * Math.random() * high,(xv / 4) - 4 + 8 * Math.random(),(yv / 4) - 4 + 8 * Math.random());
						}
					break;
					case 1: //Medium
						for(j = 2; j < 5; j++){
							for(i = 0; i < 2; i++){
								r = Math.floor(2.99 * Math.random());
								if(Math.random() > 0.5){ reverse = 0; }else{ reverse = 1; }
								mom.GenEffect([20 + r,j,reverse],xx - wide + 2 * Math.random() * wide,yy - high + 2 * Math.random() * high,(xv / 4) - 4 + 8 * Math.random(),(yv / 4) - 4 + 8 * Math.random());
							}
						}
					break;
					case 2: //Large
						for(j = 2; j < 5; j++){
							for(i = 0; i < 2; i++){
								r = Math.floor(2.99 * Math.random());
								if(Math.random() > 0.5){ reverse = 0; }else{ reverse = 1; }
								mom.GenEffect([20 + r,j,reverse],xx - wide + 2 * Math.random() * wide,yy - high + 2 * Math.random() * high,(xv / 4) - 4 + 8 * Math.random(),(yv / 4) - 4 + 8 * Math.random());
							}
						}
					break;
					case 3: //Large Struct
						for(j = 2; j < 5; j++){
							for(i = 0; i < 5; i++){
								r = Math.floor(2.99 * Math.random());
								if(Math.random() > 0.5){ reverse = 0; }else{ reverse = 1; }
								mom.GenEffect([20 + r,j,reverse],xx - wide + 2 * Math.random() * wide,yy - high + 2 * Math.random() * high,(xv / 4) - 4 + 8 * Math.random(),(yv / 4) - 4 + 8 * Math.random());
							}
						}
					break;
					case 10: //Fury
						if(mass < 10){
							mom.GenShot(debrisammo,faction,xx,yy,xv,yv,t,this);
						}
						if(mass >= 10 && mass < 50){
							mom.GenShot(debrisammo,faction,xx-5,yy-5,xv-3,yv-3,t,this);
							mom.GenShot(debrisammo,faction,xx+5,yy-5,xv+3,yv-3,t,this);
							mom.GenShot(debrisammo,faction,xx-5,yy+5,xv-3,yv+3,t,this);
							mom.GenShot(debrisammo,faction,xx+5,yy+5,xv+3,yv+3,t,this);
						}
						if(mass >= 50){
							mom.GenShot(debrisammo,faction,xx-5,yy-5,xv-3,yv-3,t,this);
							mom.GenShot(debrisammo,faction,xx+5,yy-5,xv+3,yv-3,t,this);
							mom.GenShot(debrisammo,faction,xx-5,yy+5,xv-3,yv+3,t,this);
							mom.GenShot(debrisammo,faction,xx+5,yy+5,xv+3,yv+3,t,this);
							mom.GenShot(debrisammo,faction,xx,yy-5,xv,yv-3,t,this);
							mom.GenShot(debrisammo,faction,xx,yy+5,xv,yv+3,t,this);
							mom.GenShot(debrisammo,faction,xx-5,yy,xv-3,yv,t,this);
							mom.GenShot(debrisammo,faction,xx+5,yy,xv+3,yv,t,this);
						}
					break;
					case 20: //Small Alien
					
					break;
				}
				
				//Explosions
				if(debris == 0 || debris == 1 || debris == 2 || debris == 3 || debris == 10){
					if(mass < 50){
						mom.GenEffect([0,3,0],xx,yy,0,0);
					}else{
						mom.GenEffect([0,4,0],xx,yy,0,0);
					}
					k = Math.round(Math.sqrt(high * wide) / 10);
					for(i = 0; i < k * k; i++){
						if(Math.random() > 0.5){
							mom.GenEffect([0,3,2],xx - wide + 2 * Math.random() * wide,yy - high + 2 * Math.random() * high,0,0)
						}else{
							mom.GenEffect([1,3,2],xx - wide + 2 * Math.random() * wide,yy - high + 2 * Math.random() * high,0,0)
						}
					}
				}
				if(debris == 20 || debris == 21 || debris == 22){
					if(mass < 10){
						mom.GenEffect([50,2,0],xx,yy,0,0);
					}
					if(mass >= 10 && mass < 50){
						mom.GenEffect([50,3,0],xx,yy,0,0);
					}
					if(mass >= 50){
						mom.GenEffect([50,4,0],xx,yy,0,0);
					}
					k = Math.round(Math.sqrt(high * wide) / 10);
					for(i = 0; i < k * k; i++){
						if(Math.random() > 0.5){
							mom.GenEffect([50,1,2],xx - wide + 2 * Math.random() * wide,yy - high + 2 * Math.random() * high,0,0)
						}else{
							mom.GenEffect([50,1,2],xx - wide + 2 * Math.random() * wide,yy - high + 2 * Math.random() * high,0,0)
						}
					}
				}
			}
		}
		
		public function Hit(ss)
		{
			var i:int;
			var spicy:Boolean = false;
			var rawsd:Number = 0;
			var rawad:Number = 0;
			var sd:Number = 0;
			var ad:Number = 0;
			var sum:Number = 0;
			var temp:Number = 0;
			
			rawsd = ss.sdamage;
			rawad = ss.adamage;
			if(ss.laser == 1 && mass < 10){
				rawad = rawad * 5;
				rawsd = rawsd * 5;
			}
			
			if(ss.force > 0 && this is Ship){
				if(mass < 10){
					temp = .5;
				}
				if(mass >= 10 && mass < 50){
					temp = .15;
				}
				if(mass >= 50){
					temp = .02;
				}
				xv = xv + ss.xv * temp;
				yv = yv + ss.yv * temp;
				if(Math.sqrt((xv + ss.xv) * (xv + ss.xv) + (yv + ss.yv) * (yv + ss.yv)) > 10){
					xv = xv * .9;
					yv = yv * .9;
				}
			}
			
			if(rawad > 0 || rawsd > 0){
				if(shield > 0){
					shieldglow = 1;
				}
				if(shield - rawsd <= 0){
					if(rawsd > 0){
						sd = rawsd - shield;
						ad = (sd / rawsd) * rawad;
						sd = shield;
					}else{
						ad = rawad;
					}
				}else{
					sd = rawsd;
					ad = 0;
				}
				if(shieldmax > 0){
					shieldt = 10;
				}
			}
			if(rawad < 0){
				ad = rawad;
				acid = 0;
				if(frozen > 1){
					frozen = 1;
				}
				mom.GenEffect([8,3,0],x - wide + 2 * Math.random() * wide,y - high + 2 * Math.random() * high,-3 + 6 * Math.random(),-3 + 6 * Math.random())
				mom.GenEffect([8,3,0],x - wide + 2 * Math.random() * wide,y - high + 2 * Math.random() * high,-3 + 6 * Math.random(),-3 + 6 * Math.random())
				mom.GenEffect([8,3,0],x - wide + 2 * Math.random() * wide,y - high + 2 * Math.random() * high,-3 + 6 * Math.random(),-3 + 6 * Math.random())
			}

			if(ss.minedamage > 0){
				for(i = 0; i < mom.players.length; i++){
					if(ss.faction == mom.players[i].faction){
						mom.players[i].metal = mom.players[i].metal + ss.minedamage;
						mom.players[i].metalmined = mom.players[i].metalmined + ss.minedamage;
						i = mom.players.length;
					}
				}
			}
			
			shield = shield - sd;
			armor = armor - ad;
			
			if(ss.freeze > 0 && shield <= 0){
				if(frozen == 0){
					RenderFreeze();
				}
				if(frozen < ss.freeze){
					frozen = ss.freeze;
				}
			}
			if(ss.acid > 0 && shield <= 0){
				acid = acid + ss.acid;
			}
			if(ss.shrink > 0 && shrink == 0){
				shrink = 10;
			}
			
			ss.armor = 0;
		}
		
		public function Render()
		{
			var frames:int = sheetW * sheetH;
			var a = null;
			var b = null;
			var c = null;
			var d = null;
			if(mom.paus == 0){
				if(shrink > 0 && scaleX > 0.01){
					scaleX = scaleX-.015/scaleX;
					scaleY = scaleX;
					wide = 0;
					high = 0;
				}
				if(anim == false){
					spriteIndex = Math.floor(frames*(t+.5*(1/frames)));
				}else{
					if(frozen == 0){
						animclock++;
					}
					if(animclock % Math.abs(animspeed) == 0 && frozen == 0){
						if(animspeed > 0){
							spriteIndex++;
						}else{
							spriteIndex--;
						}
					}
					if(animspeed < 1 && animspeed > 0 && frozen == 0){
						spriteIndex = spriteIndex + Math.floor(1/animspeed);
					}
				}
				if(damage == true){
					spriteIndex = Math.floor(frames * (1 - (armor / armormax)));
				}
				
				if(spriteIndex < 0){
					spriteIndex = spriteIndex + frames;
				}
				if(spriteIndex >= frames){
					spriteIndex = spriteIndex - frames;
				}
				if(cloaked == 1){
					if(alpha > .05){
						alpha = alpha - .05
					}else{
						alpha = .05;
					}
					/*if(faction == mom.players(me).faction){
						alpha = .25;
					}*/
				}
				if(cloaked == 0){
					if(alpha < 1){
						alpha = alpha + .05;
					}else{
						alpha = 1;
					}
				}
			}
			
			if(x + .5 * spriteW < -1 * mom.game.x || x - .5 * spriteW > -1 * mom.game.x + mom.resX || y + .5 * spriteH < -1 * mom.game.y || y - .5 * spriteH > -1 * mom.game.y + mom.resY){
				visible = false;
			}else{
				visible = true;
			}
			if(visible == true && frozen == 0 && (oldIndex != spriteIndex || oldvisible == false)){
				redrawme = true;
			}
			a = picref;
			b = burnref;
			c = shieldref;
			d = lightref;
			if(transformed == true){
				a = tpicref;
				b = tburnref;
				c = tshieldref;
				d = tlightref;
			}
			if(redrawme == true){
				pic.bitmapData.copyPixels(a, new Rectangle( (spriteIndex % sheetW) * spriteW, Math.floor(spriteIndex / sheetW) * spriteH, spriteW, spriteH), new Point(0,0));
				if(burnpic != null && b != null){
					burnpic.bitmapData.copyPixels(b, new Rectangle( (spriteIndex % sheetW) * spriteW, Math.floor(spriteIndex / sheetW) * spriteH, spriteW, spriteH), new Point(0,0));
				}
				if(shieldpic != null && shieldmax > 0){
					shieldpic.bitmapData.copyPixels(c, new Rectangle( (spriteIndex % sheetW) * spriteW, Math.floor(spriteIndex / sheetW) * spriteH, spriteW, spriteH), new Point(0,0));
				}
				redrawme = false;
			}
			if(lightpic != null && lights > 0 && visible == true && (oldlightIndex != lightIndex || oldlightvisible == false)){
				lightpic.bitmapData.copyPixels(d, new Rectangle( (lightIndex % lightW) * spriteW, Math.floor(lightIndex / lightW) * spriteH, spriteW, spriteH), new Point(0,0),null,null,false);
			}
			/*shieldpic.alpha = shieldglow;
			if(shieldpic.alpha > 0){
				shieldpic.visible = true;
			}else{
				shieldpic.visible = false;
			}*/
			oldIndex = spriteIndex;
			oldvisible = visible;
			if(lights > 0){
				oldlightIndex = lightIndex;
				oldlightvisible = lightpic.visible;
			}
			if(tacshieldpic != null){
				if(tacshieldpic.alpha > 0){
					tacshieldpic.alpha = tacshieldpic.alpha - .04;
				}
				if(tacshieldpic.alpha < 0){
					tacshieldpic.alpha = 0;
				}
			}
		}
		
		public function RenderFreeze()
		{
			var i:int;
			PostProcess.ColorShift(pic.bitmapData,100);
			PostProcess.Bloom(pic.bitmapData,2,1);
			for(i = 0; i < turrets.length; i++){
				PostProcess.ColorShift(turrets[i].pic.bitmapData,100);
				PostProcess.Bloom(turrets[i].pic.bitmapData,2,1);
			}
			
		}
	}
}