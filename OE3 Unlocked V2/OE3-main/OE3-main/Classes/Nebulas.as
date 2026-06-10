package 
{
	import flash.display.*;
    //import flash.sampler.*;
    //import flash.events.*;
    //import flash.utils.*;
    //import flash.text.*;
    import flash.geom.*;
	//import flash.ui.*;
	import flash.filters.*;
	
	public class Nebulas
	{
		public static function GenNebulas(wide:int,high:int, s:Number, v:int)
		{
			var xx:int;
			var yy:int;
			var temp:int;
			var b:BitmapData = new BitmapData(wide,high,false,0x00000000);
			var tempscreen:BitmapData = new BitmapData(wide,high,false,0x00000000);
			var invertscreen:BitmapData = new BitmapData(wide,high,false,0x00000000);
			var finalscreen:BitmapData = new BitmapData(wide,high,false,0x00000000);
			var starscreen:BitmapData;
			
			b = GenCloud(wide,high,s,v);
					   
			starscreen = GenStars(wide,high,s,null);
			finalscreen.draw(b,null,(new Rectangle(0, 0, b.width, b.height), new ColorTransform(1,1,1,1) ),"normal",null,false);
			finalscreen.draw(starscreen,null,(new Rectangle(0, 0, b.width, b.height), new ColorTransform(1,1,1,1) ),"add",null,false);

			return finalscreen;
		}
		
		public static function BloomCloud(wide:int,high:int,ss)
		{
			var xx:Number;
			var yy:Number;
			var r:int;
			var g:int;
			var b:int;
			var bright:Number;
			var nebula:BitmapData = new flash.display.BitmapData(wide,high, false, 0);
			for(xx = 0; xx < wide; xx++){
				for(yy = 0; yy < high; yy++){
					r = ss.getPixel(xx, yy) >> 16 & 0xFF
					g = ss.getPixel(xx, yy) >> 8 & 0xFF
					b = ss.getPixel(xx, yy) & 0xFF
					bright = (r / 256 + g / 256 + b / 256)/3;
					if((bright > 0.1 && bright < 0.1025) || (bright > 0.2 && bright < 0.2025) || (bright > 0.3 && bright < 0.3025)){
						r = 4 * r + 5;
						g = 4 * g + 5;
						b = 4 * b + 5;
						if(r > 255){
							 r = 255;
						}
						if(g > 255){
							g = 255;
						}
						if(b > 255){
							b = 255;
						}
						nebula.setPixel(xx,yy,b + 256*g + 256*256*r);
					}
				}
			}
			Blur(nebula,25,1);
			Bloom(nebula,5,1);
			ss.draw(nebula,null,(new Rectangle(0, 0, nebula.width, nebula.height), new ColorTransform(1,1,1,1) ),"add",null,false);
		}
		
		public static function GenCloud(wide:int,high:int,s:Number, v:int)
		{
			var xx:Number;
			var yy:Number;
			var rr:Number;
			var gg:Number;
			var bb:Number;
			var rrr:Number;
			var ggg:Number;
			var bbb:Number;
			var r:Number;
			var g:Number;
			var b:Number;
			var i:Number;
			var j:Number;
			var temp:Bitmap = new Bitmap;
			var pixelvalue:uint;
			var red:uint;// = pixelValue >> 16 & 0xFF;
			var green:uint;// = pixelValue >> 8 & 0xFF;
			var blue:uint;// = pixelValue & 0xFF;
			var fractal:Boolean;

			var buffer:BitmapData = new flash.display.BitmapData(wide/4,high/4, false, 0);
			var buffer2:BitmapData = new flash.display.BitmapData(wide/4,high/4, false, 0);
			var buffer3:BitmapData = new flash.display.BitmapData(wide/4,high/4, false, 0);
			var buffer4:BitmapData = new flash.display.BitmapData(wide/4,high/4, false, 0);
			var nebula:BitmapData = new flash.display.BitmapData(wide,high, false, 0);
			var nebulab:BitmapData = new flash.display.BitmapData(wide/2,high/2, false, 0);
			var a;
			var c;

			fractal = false;
			buffer.perlinNoise(wide/4, high/4, 8, Math.floor(s * 10000), false, fractal, 1, true, null);
			buffer2.perlinNoise(wide/4, high/4, 8, Math.floor(s * 10000 + 1), false, fractal, 1, true, null);
			buffer3.perlinNoise(wide/4, high/4, 8, Math.floor(s * 10000 + 2), false, fractal, 1, true, null);
			buffer4.perlinNoise(wide/4, high/4, 8, Math.floor(s * 10000 + 3), false, fractal, 1, true, null);
			
			rr = 1
			gg = 1
			bb = 1
			
			rrr = .75;
			ggg = .15;
			bbb = .75;

			
			for(yy = 0; yy < high / 4;yy++){
				for(xx = 0; xx < wide / 4;xx++){
					pixelvalue = 0+Math.floor(bb*(buffer4.getPixel(xx,yy)& 0xFF))+256*Math.floor(gg*(buffer.getPixel(xx,yy) & 0xFF))+256*256*Math.floor(rr*(buffer2.getPixel(xx,yy) & 0xFF));
					nebula.setPixel(xx * 2,yy * 2,pixelvalue);
				}
			}
			
			for(yy = 0; yy < high / 4;yy++){
				for(xx = 0; xx < wide / 4;xx++){
					rr = buffer3.getPixel(xx, yy) >> 16 & 0xFF
					r = nebula.getPixel(xx * 2, yy * 2) >> 16 & 0xFF
					g = nebula.getPixel(xx * 2, yy * 2) >> 8 & 0xFF
					b = nebula.getPixel(xx * 2, yy * 2) & 0xFF
					r = Math.round(rrr * r - .5*rr);//.3
					g = Math.round(ggg * g - .5*rr);//.25
					b = Math.round(bbb * b - .5*rr);//.5
					if(r < 0){ r = 0 };
					if(g < 0){ g = 0 };
					if(b < 0){ b = 0 };
					buffer.setPixel(xx,yy,b+256*g+256*256*r);
				}
			}
			for(i = 0; i < 2; i++){
				if(i == 0){
					j = 4;
					a = nebulab;
					c = buffer;
				}
				if(i == 1){
					j = 2;
					a = nebula;
					c = nebulab;
				}
				for(yy = 0; yy < high / j;yy++){
					for(xx = 0; xx < wide / j;xx++){
						r = xx+1.5*Math.sin(.02*yy);
						if(r < 0){
							r = 0;
						}
						if(r > wide / j){
							r = (wide / j) - 1;
						}
						g = yy+1.5*Math.cos(.02*xx);
						if(g < 0){
							g = 0;
						}
						if(g > high / j){
							g = (high / j)-1;
						}
						pixelvalue = c.getPixel(r,g)
						a.setPixel(2 * xx,2 * yy,pixelvalue);
						a.setPixel(2 * xx + 1,2 * yy,pixelvalue);
						a.setPixel(2 * xx + 1,2 * yy + 1,pixelvalue);
						a.setPixel(2 * xx,2 * yy + 1,pixelvalue);
					}
				}
			}
			Blur(nebula,5,1);
			Bloom(nebula,10,.5);
			
			var matrix:Array = new Array();
			if(v == 1){ //Tan Grey
				matrix=matrix.concat([.25,.3,.3,0,0]);// red
				matrix=matrix.concat([.3,.25,.3,0,0]);// green
				matrix=matrix.concat([.3,.3,.25,0,0]);// blue
				matrix=matrix.concat([0,0,0,1,0]);// alpha
			}
			if(v == 2){ //Red
				matrix=matrix.concat([.5,.1,.1,0,0]);// red
				matrix=matrix.concat([.1,.075,.1,0,0]);// green
				matrix=matrix.concat([.1,.1,.075,0,0]);// blue
				matrix=matrix.concat([0,0,0,1,0]);// alpha
			}
			if(v == 3){ //Purple
				matrix=matrix.concat([.3,.25,.3,0,0]);// red
				matrix=matrix.concat([.25,.3,.3,0,0]);// green
				matrix=matrix.concat([.3,.3,.25,0,0]);// blue
				matrix=matrix.concat([0,0,0,1,0]);// alpha
			}
			if(v == 4){ //Blue
				matrix=matrix.concat([.2,.15,.2,0,0]);// red
				matrix=matrix.concat([.2,.2,.15,0,0]);// green
				matrix=matrix.concat([.35,.2,.2,0,0]);// blue
				matrix=matrix.concat([0,0,0,1,0]);// alpha
			}
			if(v == 5){ //Green
				matrix=matrix.concat([.2,.15,.2,0,0]);// red
				matrix=matrix.concat([.2,.2,.35,0,0]);// green
				matrix=matrix.concat([.15,.2,.2,0,0]);// blue
				matrix=matrix.concat([0,0,0,1,0]);// alpha
			}
			if(v == 6){ //Orange
				matrix=matrix.concat([.35,.1,.1,0,0]);// red
				matrix=matrix.concat([.25,.1,.1,0,0]);// green
				matrix=matrix.concat([.1,.1,.1,0,0]);// blue
				matrix=matrix.concat([0,0,0,1,0]);// alpha
			}
			var my_filter:ColorMatrixFilter=new ColorMatrixFilter(matrix);
			nebula.applyFilter(nebula,new Rectangle(0,0,nebula.width,nebula.height),new Point(0,0), my_filter);
			buffer = null;
			buffer2 = null;
			buffer3 = null;
			buffer4 = null;
			
			BloomCloud(wide,high,nebula);
			
			Bloom(nebula,6,3);
			
			return nebula
		}
		
		public static function GenOneStar()
		{
			var r:int;
			var g:int;
			var b:int;
			var blue:Number;
			
			var starbuffer:BitmapData = new flash.display.BitmapData(16,16, false, 0);
			blue = 130 * Math.pow(Math.random(),3) + 120;
			r = Math.floor(blue / (Math.random() + 1));
			g = Math.floor(blue / (Math.random() * .5 + 1));
			b = Math.floor(blue);
			
			// Mathematically generate radial glow/bloom to bypass expensive applyFilter calls and Vulkan driver crashes.
			for (var xx:int = 0; xx < 16; xx++) {
				for (var yy:int = 0; yy < 16; yy++) {
					var dx:Number = xx - 8;
					var dy:Number = yy - 8;
					var d2:Number = dx * dx + dy * dy;
					var intensity:Number = 0.5 * Math.exp(-d2 / 3.0) + 0.5 * Math.exp(-d2 / 12.0);
					if (intensity > 0.005) {
						var pixR:int = Math.min(255, Math.floor(r * intensity));
						var pixG:int = Math.min(255, Math.floor(g * intensity));
						var pixB:int = Math.min(255, Math.floor(b * intensity));
						
						// Replicate the white core in the center
						if (xx == 8 && yy == 8) {
							pixR = Math.min(255, pixR + 150);
							pixG = Math.min(255, pixG + 150);
							pixB = Math.min(255, pixB + 150);
						}
						
						starbuffer.setPixel(xx, yy, (pixR << 16) | (pixG << 8) | pixB);
					}
				}
			}
			
			return(starbuffer);
		}
		
		public static function GenStars(wide:int,high:int,s:Number,ss)
		{
			var xx:int;
			var yy:int;
			var r:int;
			var g:int;
			var b:int;
			var blue:Number;
			var bright:Number;
			var starbuffer:BitmapData = new flash.display.BitmapData(wide,high, false, 0);
			//stars
			for(yy = 0; yy < high; yy++){
				for(xx = 0; xx < wide; xx++){
					bright = 0;
					if(ss != null){
						r = ss.getPixel(xx, yy) >> 16 & 0xFF
						g = ss.getPixel(xx, yy) >> 8 & 0xFF
						b = ss.getPixel(xx, yy) & 0xFF
						bright = (r / 256 + g / 256 + b / 256)/3;
					}
					s = Rand(s);
					if(s > 0.998) {
						s = Rand(s);
						blue = 200 * Math.pow(s,6) + 5;
						blue = blue * (1 - 3 * bright);
						s = Rand(s);
						r = Math.floor(blue / (s + 1));
						s = Rand(s);
						g = Math.floor(blue / (s * .5 + 1));
						b = Math.floor(blue);
						/*s = Rand(s);
						if(s > 0.95){
							r = Math.floor(blue );
							s = Rand(s);
							g = Math.floor(blue / (s * .5 + 1));
							s = Rand(s);
							b = Math.floor(blue / (s + 1));
						}*/
						starbuffer.setPixel(xx,yy,b+256*g+256*256*r);
					}else{
						starbuffer.setPixel(xx,yy,0);
					}
				}
			}
			Bloom(starbuffer,3,1);
			Bloom(starbuffer,8,1);			
 
			return(starbuffer);
		}
		
		public static function Veronoi(wide:int,high:int,density:int)
		{
			var xx:int;
			var yy:int;
			var i:int;
			var j:int;
			var temp:Number;
			var featurex:Array = new Array(density * density);
			var featurey:Array = new Array(density * density);
			var fd:Array = new Array(density * density);
			var b:BitmapData = new BitmapData(wide,high,false,0x00000000);
			
			for(i = 0; i < density; i++){
				for(j = 0; j < density; j++){
					temp = wide / (2 * density)
					featurex[i*density + j] = temp + i * wide / density + Math.round(-1 * temp + 2 * Math.random() * temp);
					temp = high / (2 * density)
					featurey[i*density + j] = temp + j * high / density + Math.round(-1 * temp + 2 * Math.random() * temp);
				}
			}
			for(xx = 0; xx < wide; xx++){
				for(yy = 0; yy < high; yy++){
					for(i = 0; i < featurex.length; i++){
						fd[i] = Math.pow((xx - featurex[i]),2)+Math.pow((yy - featurey[i]),2);
					}
					fd.sort(Array.NUMERIC);
					temp = Math.floor(-1 * Math.sqrt(fd[0])+Math.sqrt(fd[1]));
					if(temp < 0){
						temp = 0;
					}
					b.setPixel(xx,yy,temp + 256 * temp + 256 * 256 * temp);
				}
			}
			/*for(i = 0; i < featurex.length; i++){
				b.setPixel(featurex[i],featurey[i], 0xFFFFFFFF);
			}*/
			return b;
		}
		
		public static function Bloom(s:BitmapData, v1:int, v2:Number)
		{
			try {
				var b:BitmapData = new BitmapData(s.width,s.height,true,0x00000000);
				var blur:BlurFilter = new BlurFilter();
				blur.blurX = v1; 
				blur.blurY = v1; 
				blur.quality = BitmapFilterQuality.HIGH;
				
				b.draw(s);
				b.applyFilter(s,new Rectangle(0,0,s.width,s.height),new Point(0,0), blur);
				s.draw(b,null,(new Rectangle(0, 0, b.width, b.height), new ColorTransform(1,1,1,v2) ),"screen",null,false);
			} catch (e:Error) {
				trace("Nebulas.Bloom error: " + e.message);
			}
		}
		
		public static function Blur(s:BitmapData, v1:int, v2:Number)
		{
			try {
				var blur:BlurFilter = new BlurFilter();
				blur.blurX = v1; 
				blur.blurY = v1; 
				blur.quality = BitmapFilterQuality.HIGH;
				
				s.applyFilter(s,new Rectangle(0,0,s.width,s.height),new Point(0,0), blur);
			} catch (e:Error) {
				trace("Nebulas.Blur error: " + e.message);
			}
		}
		
		public static function Rand(s:Number): Number
        {
			s = s * 233280.0
            s = (s*9301+49297) % 233280;
            return s / 233280.0;
        }
	}
}