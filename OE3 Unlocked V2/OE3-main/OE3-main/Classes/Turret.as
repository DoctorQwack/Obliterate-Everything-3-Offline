package 
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	
	public class Turret extends MovieClip
	{
		public var mom;
		public var up;
		public var turn:Number = 1;
		public var xx:Number;
		public var yy:Number;
		public var t:Number = 0;
		public var tv:Number = 0;
		public var faction:Number = 0;
		public var teamcolor:int = 0;
		
		public var spriteW:Number = 32;
		public var spriteH:Number = 32;
		public var sheetW:int = 6;
		public var sheetH:int = 6;
		public var oldvisible:Boolean = false;
		public var oldIndex:int = -1;
		public var spriteIndex:int = 0;
		public var redrawme:Boolean = false;
		
		public var lowai:int = 1;
		public var targetx:Number;
		public var targety:Number;
		public var targetxv:Number;
		public var targetyv:Number;
		public var targethot:Boolean = false;
		public var targetclock:int;
		public var scanrange:int = 1000;
		public var aitime:int = 0;
		public var aihitclock:int = 100000;
		public var aiobj:int;
		public var ships;
		public var structs;
		public var targets:Array = new Array();
		public var guns:Array = new Array();
		
		public var tstructs:Boolean = true;
		public var tships:Boolean = true;
		public var tshots:Boolean = false;
		public var miner:Boolean = false;
		public var healer:Boolean = false;
		
		public var tcpu:TargetCPU;
		
		public var picref;
		public var pic:Bitmap;

		
		public function Turret(m,upp,d,xxx:Number,yyy:Number)
		{
			var i:int;
			var j:int;
			var k:int;
			var a:String;
			
			mom = m;
			up = upp;
			xx = xxx;
			yy = yyy;
			x = Math.round(xx);
			y = Math.round(yy);
			t = 0;
			tv = 0;
			faction = up.faction;
			
			ships = mom.ships;
			structs = mom.structs;
			
			turn = d.turn;
			miner = d.miner;
			healer = d.healer;
			tshots = d.tshots;
			tstructs = d.tstructs;
			tships = d.tships;
			
			sheetW = d.sheetW;
			sheetH = d.sheetH;
			picref = mom.l.ssturrets[d.picid][faction];
			spriteW = picref.width / sheetW;
			spriteH = picref.height / sheetH;
			
			targetx = up.xx;
			targety = up.yy + 1;
			targetxv = 0;
			targetyv = 0;
			targetclock = 30;
			
			pic = new Bitmap();
			pic.bitmapData = new BitmapData(spriteW,spriteH,true,0x00000000);
			addChild(pic);
			pic.x = Math.round(-.5 * spriteW);
			pic.y = Math.round(-.5 * spriteH);
			
			for(i = 0; i < d.guns.length; i++){
				guns[i] = new Gun(mom, this, d.guns[i],d.ammos[i]);
			}
			
			tcpu = new TargetCPU( mom, this);
			tcpu.miner = miner;
			tcpu.healer = healer;
			tcpu.tshots = tshots;
			tcpu.tships = tships;
			tcpu.tstructs = tstructs;
			
			Render();
		}
		
		/*public function Die()
		{
			var i:int;
			var j:int;
			var a;
			var b;
			for(i = 0; i < mom.ships.length; i++){
				a = mom.ships[i];
				for(j = 0; j < a.targets.length; j++){
					if(a.targets[j] == this){
						a.targets.splice(j,1);
						j = a.targets.length;
					}
				}
			}
			if(engineburn == true){
				burnpic.bitmapData.dispose();
			}
			if(shieldpic != null){
				shieldpic.bitmapData.dispose();
			}
			if(lights > 0){
				lightpic.bitmapData.dispose();
			}
			pic.bitmapData.dispose();
			targets = [];
		}*/
		
		public function DoAI()
		{
			var i:int;
			
			if(aihitclock < 100000){
				aihitclock++;
			}
			DoAITargets();
			DoAILow();
			if(targethot == true){
				DoAIGuns();
			}
			targetclock++;
		}
		
		public function DoAIGuns()
		{
			var i:int;
			var j:int;
			var k:int;
			var tb:Number; //PositionThetaToTarget
			var d:Number; //RotateDistance
			var dd:Number; //Target Distance
			var g;
			var xxx:Number = xx + up.xx;
			var yyy:Number = yy + up.yy;
			tb = (Math.atan2(yyy-targety,xxx-targetx)-3.141592/2)/(3.141592*2)
			d = Tools.MathRotateDirection(t,tb);
			dd = (xxx-targetx)*(xxx-targetx)+(yyy-targety)*(yyy-targety);
			for(i = 0; i < guns.length; i++){
				g = guns[i];
				g.active = false;
				if(Math.abs(d) < g.gunangle && g.gunrange * g.gunrange > dd){
					g.active = true;
				}
				if(targets.length == 0){
					g.active = false;
				}
				if(up.armor <= 0){
					g.active = false;
				}
				g.DoStuff();
			}
		}
		
		public function DoAITargets()
		{
			var i:int;
			var r:Number = 0;
			if(targetclock % 10 == 0 || tshots == true){
				for(i = 0; i < guns.length; i++){
					if(guns[i].gunrange > r){
						r = guns[i].gunrange;
					}
				}
				r = r * 1.25;
				targets = new Array();
				tcpu.DoAITargets(targets,1,xx + up.xx,yy + up.yy,r);
			}else{
				tcpu.DoAICleanTargets(targets);
			}
		}
		
		public function DoAILow()
		{
			var i:int;
			
			var tb:Number; //PositionThetaToTarget
			var d:Number; //RotateDistance
			var v:Number; //Velocity
			var vt:Number; //VelocityTheta
			var c:Number; //tuning constant
			
			var d_vx:Number; //desired velocity
			var d_vy:Number; //desired velocity
			var s_vx:Number; //steering velocity
			var s_vy:Number; //steering velocity
			var st:Number; //steering theta
			
			var dt:Number; //Distance to Target
			
			var db:Number; //Alternate distance
			var dc:Number; //Alternate distance
			
			var xxx:Number;
			var yyy:Number;
			var a;
			var did:int;
			
			switch(lowai){
				case 1: //Point at Target
					if(healer == false){
						a = DoAIQuickScan();
					}else{
						a = DoAIQuickScanHealer();
					}
					did = a[0];
					d = a[1];
					if(did > -1){
						targetx = targets[did].xx;
						targety = targets[did].yy;
						targetxv = targets[did].xv;
						targetyv = targets[did].yv;
						targethot = true;
					}else{
						if(up is Ship){
							targetx = up.xx + 100 * Math.sin(up.t*6.283);
							targety = up.yy - 100 * Math.cos(up.t*6.283);
							targetxv = up.xv;
							targetyv = up.yv;
						}
					}
					
					xxx = xx + up.xx;
					yyy = yy + up.yy;
					tb = (Math.atan2(yyy - targety,xxx - targetx)-3.141592/2)/(3.141592*2)
					d = Tools.MathRotateDirection(t,tb);
					if(Math.abs(d) < turn){
						d = 0;
						t = tb;
					}
					if(d < -.01){
						DoCommand(1);
					}
					if(d > .01){
						DoCommand(2);
					}
				break;
			}
		}
		
		public function DoAIQuickScan()
		{
			var i:int;
			var d:Number;
			var did:int;
			var tx:Number;
			var ty:Number;
			var xxx:Number;
			var yyy:Number;
			xxx = xx + up.xx;
			yyy = yy + up.yy;
			did = -1
			d = 10000000;
			for(i = 0; i < targets.length; i++){
				if(targets[i] != null && targets[i].armor > 0){
					tx = targets[i].xx;
					ty = targets[i].yy;
					if(Math.sqrt((tx - xxx) * (tx - xxx) + (ty - yyy) * (ty - yyy)) < d){
						d = Math.sqrt((tx - xxx) * (tx - xxx) + (ty - yyy) * (ty - yyy));
						did = i;
					}
				}
			}
			
			return(new Array(did,d));
		}
		
		public function DoAIQuickScanHealer()
		{
			var i:int;
			var d:Number;
			var arm:Number;
			var did:int;
			var tx:Number;
			var ty:Number;
			var xxx:Number;
			var yyy:Number;
			xxx = xx + up.xx;
			yyy = yy + up.yy;
			did = -1
			arm = 10000000;
			d = guns[0].gunrange;
			for(i = 0; i < targets.length; i++){
				if(targets[i] != null && targets[i].armor > 0 && targets[i].armor < arm && targets[i].armor < targets[i].armormax){
					if(Math.pow(targets[i].xx - (xx + up.xx),2) + Math.pow(targets[i].yy - (yy + up.yy),2) < d * d){
						arm = targets[i].armor;
						did = i;
					}
				}
			}
			
			return(new Array(did,d));
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
				}
			}
		}
		
		public function Move()
		{
			//AI
			DoAI();
			
			t = t + tv;
			if(t > 1){
				t = t - 1;
			}
			if(t < 0){
				t = t + 1;
			}
			if(Math.abs(tv) > turn){
				tv = tv * .95;
			}
		}
		
		public function Render()
		{
			var frames:int = sheetW * sheetH;
			spriteIndex = Math.floor(frames*(t+.5*(1/frames)));
				
			if(spriteIndex < 0){
				spriteIndex = 0;
			}
			if(spriteIndex >= frames){
				spriteIndex = spriteIndex - frames;
			}
			
			if(up.x + .5 * spriteW < -1 * mom.game.x || up.x - .5 * spriteW > -1 * mom.game.x + mom.resX || up.y + .5 * spriteH < -1 * mom.game.y || up.y - .5 * spriteH > -1 * mom.game.y + mom.resY){
				visible = false;
			}else{
				visible = true;
			}
			if(visible == true && (oldIndex != spriteIndex || oldvisible == false)){
				redrawme = true;
			}
			if(redrawme == true){
				pic.bitmapData.copyPixels(picref, new Rectangle( (spriteIndex % sheetW) * spriteW, Math.floor(spriteIndex / sheetW) * spriteH, spriteW, spriteH), new Point(0,0));
				redrawme = false;
			}
			oldIndex = spriteIndex;
			oldvisible = visible;
		}
	}
}