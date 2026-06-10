package 
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Effect extends MovieClip 
	{
		public var xx:Number = 0;
		public var yy:Number = 0;
		public var xv:Number = 0;
		public var yv:Number = 0;
		public var spriteW:Number = 8;
		public var spriteH:Number = 8;
		public var sheetW:Number = 6;
		public var sheetH:Number = 6;
		public var oldvisible:Boolean = false;
		public var oldIndex:int = -1;
		public var spriteIndex:int = 0;
		public var delayt:int = 0;
		public var explodemode:int = 0;
		public var effectref;
		
		public var clock:int = 0;
		public var lifespan:int = 0;
		
		public var reverse:Boolean = false;
		
		public var mom;
		
		public var pic:Bitmap;
		
		public function Effect(m, ed, xxx:Number, yyy:Number, xxv:Number, yyv:Number)
		{
			xx = xxx;
			yy = yyy;
			xv = xxv;
			yv = yyv;
			mom = m;
			
			visible = false;
			
			lifespan = ed.lifespan;
			delayt = ed.delayt;
			reverse = ed.reverse;
			sheetW = ed.sheetW;
			sheetH = ed.sheetH;
			explodemode = ed.explodemode;
			blendMode = ed.blendmode;
			if(mom.l.sseffects[ed.effectidi][ed.effectidj] == null){
				mom.l.StoreEffect(ed.effectidi,ed.effectidj);
			}
			effectref = mom.l.sseffects[ed.effectidi][ed.effectidj];

			spriteW = effectref.width / sheetW;
			spriteH = effectref.height / sheetH;
			
			pic = new Bitmap();
			pic.bitmapData = new BitmapData(spriteW,spriteH,true,0xFFFFFFFF);
			this.addChild(pic);
			pic.x = -.5*spriteW;
			pic.y = -.5*spriteH;
			
			if(reverse == true){
				spriteIndex = lifespan - 1;
			}
		}
		
		public function Die()
		{
			var i:int;
			pic.bitmapData.dispose();
		}
		
		public function Explode()
		{
			var i:int;
			var j:int;
			var k:int;

			switch(explodemode){
				case 0:
					//Nothing
				break;
				case 1:
					if(clock == lifespan){
						mom.GenEffect([0,0,0],xx,yy,0,0);
					}
				break;
			}
		}
		
		public function Move():void
		{
			xx = xx + xv;
			yy = yy + yv;
			
			if(delayt == 0){
				clock++;
			}else{
				delayt--;
				if(delayt == 0){
					clock++;
				}
			}
			Explode();
			if(reverse == false){
				if(delayt == 0){
					spriteIndex++;
				}
			}else{
				if(delayt == 0){
					spriteIndex--;
				}
			}
		}
		
		public function Render()
		{
			x = xx;
			y = yy;
			if(spriteIndex < 0 && reverse == false){
				spriteIndex = 0;
			}
			if(spriteIndex < 0 && reverse == true){
				spriteIndex = sheetW * sheetH - 1;
			}
			if(spriteIndex >= sheetW * sheetH){
				spriteIndex = 0;
			}
			pic.x = -.5*spriteW;
			pic.y = -.5*spriteH;
			if(x + .5 * spriteW < -1 * mom.game.x || x - .5 * spriteW > -1 * mom.game.x + mom.resX || y + .5 * spriteH < -1 * mom.game.y || y - .5 * spriteH > -1 * mom.game.y + mom.resY){
				visible = false;
			}else{
				if(delayt == 0){
					visible = true;
				}else{
					visible = false;
				}
			}
			if(visible == true && (oldIndex != spriteIndex || oldvisible == false)){
				pic.bitmapData.copyPixels(effectref, new Rectangle( (spriteIndex % sheetW) * spriteW, Math.floor(spriteIndex / sheetW) * spriteH, spriteW, spriteH), new Point(0,0));
			}
			oldIndex = spriteIndex;
			oldvisible = visible;
		}
	}
}