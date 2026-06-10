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
	
	public class PostProcess
	{
		public static function Sharpen(s:BitmapData)
		{
			// Create the convolution matrix. 
			var matrix:Array = [-1, -1, -1, 
								-1, 12, -1, 
								-1, -1, -1]; 
			 
			var convolution:ConvolutionFilter = new ConvolutionFilter(); 
			convolution.matrixX = 3; 
			convolution.matrixY = 3; 
			convolution.matrix = matrix; 
			convolution.divisor = 4; 
				 
			//s.filters = [convolution]; 
			s.applyFilter(s,new Rectangle(0,0,s.width,s.height),new Point(0,0), convolution)
		}
		
		public static function Bloom(s:BitmapData, v1:int, v2:Number)
		{
			try {
				var b:BitmapData = new BitmapData(s.width,s.height,true,0x00000000);
				var blur:BlurFilter = new BlurFilter();
				blur.blurX = v1; 
				blur.blurY = v1; 
				blur.quality = BitmapFilterQuality.LOW;
				
				b.draw(s);
				b.applyFilter(s,new Rectangle(0,0,s.width,s.height),new Point(0,0), blur);
				s.draw(b,null,(new Rectangle(0, 0, b.width, b.height), new ColorTransform(1,1,1,v2) ),"screen",null,false);
			} catch (e:Error) {
				trace("PostProcess.Bloom error: " + e.message);
			}
		}
		
		public static function Glow(s:BitmapData, v1:int, v2:Number, v3:Boolean, r:int, g:int, b:int)
		{
			//var b:BitmapData = new BitmapData(s.width,s.height,true,0x00000000);
			var glow:GlowFilter = new GlowFilter();
            glow.blurX = v1; 
            glow.blurY = v1;
			glow.strength = v2;
            glow.quality = BitmapFilterQuality.HIGH;
			glow.color = 256 * 256 * r + 256 * g + b;
			glow.inner = v3;
			
			//b.draw(s);
			s.applyFilter(s,new Rectangle(0,0,s.width,s.height),new Point(0,0), glow);
			//s.draw(b,null,(new Rectangle(0, 0, b.width, b.height), new ColorTransform(1,1,1,v2) ),"screen",null,false);
		}
		
		public static function Shrink(a,s:Number)
		{
			var scale:Number = s;
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			
			var b:BitmapData = new BitmapData(a.width * scale, a.height * scale, true, 0x000000);
			b.draw(a, matrix, null, null, null, true);
			return b;
		}
		
		public static function ColorShift(a,s)
		{
			var matrix:Array = new Array();
			switch(s){
				//Light Blue to ___
				case -1: //Black
					matrix=matrix.concat([0,0,0,0,0]);// red
					matrix=matrix.concat([0,0,0,0,0]);// green
					matrix=matrix.concat([0,0,0,0,0]);// blue
					matrix=matrix.concat([0,0,0,1,0]);// alpha
				break;
				case 0: //Light Blue
					matrix=matrix.concat([1,0,0,0,0]);// red
					matrix=matrix.concat([0,1,0,0,0]);// green
					matrix=matrix.concat([0,0,1,0,0]);// blue
					matrix=matrix.concat([0,0,0,1,0]);// alpha
				break;
				case 1: //Yellow Green
					matrix=matrix.concat([0,1,0,0,0]);// red
					matrix=matrix.concat([0,0,1,0,0]);// green
					matrix=matrix.concat([1,0,0,0,0]);// blue
					matrix=matrix.concat([0,0,0,1,0]);// alpha
				break;
				case 2: //Pink
					matrix=matrix.concat([0,0,1,0,0]);// red
					matrix=matrix.concat([1,0,0,0,0]);// green
					matrix=matrix.concat([0,1,0,0,0]);// blue
					matrix=matrix.concat([0,0,0,1,0]);// alpha
				break;
				case 3: //Orange
					matrix=matrix.concat([0,0,1,0,0]);// red
					matrix=matrix.concat([0,1,0,0,0]);// green
					matrix=matrix.concat([1,0,0,0,0]);// blue
					matrix=matrix.concat([0,0,0,1,0]);// alpha
				break;
				case 4: //Violet
					matrix=matrix.concat([0,1,0,0,0]);// red
					matrix=matrix.concat([1,0,0,0,0]);// green
					matrix=matrix.concat([0,0,1,0,0]);// blue
					matrix=matrix.concat([0,0,0,1,0]);// alpha
				break;
				case 5: //NeonGreen
					matrix=matrix.concat([1,0,0,0,0]);// red
					matrix=matrix.concat([0,0,1,0,0]);// green
					matrix=matrix.concat([0,1,0,0,0]);// blue
					matrix=matrix.concat([0,0,0,1,0]);// alpha
				break;
				case 6: //Red
					matrix=matrix.concat([0,0,1,0,0]);// red
					matrix=matrix.concat([1,0,0,0,0]);// green
					matrix=matrix.concat([1,0,0,0,0]);// blue
					matrix=matrix.concat([0,0,0,1,0]);// alpha
				break;
				case 7: //Yellow
					matrix=matrix.concat([0,0,1,0,0]);// red
					matrix=matrix.concat([0,0,1,0,0]);// green
					matrix=matrix.concat([1,0,0,0,0]);// blue
					matrix=matrix.concat([0,0,0,1,0]);// alpha
				break;
				case 8: //Blue
					matrix=matrix.concat([1,0,0,0,0]);// red
					matrix=matrix.concat([1,0,0,0,0]);// green
					matrix=matrix.concat([0,0,1,0,0]);// blue
					matrix=matrix.concat([0,0,0,1,0]);// alpha
				break;
				case 9: //White
					matrix=matrix.concat([0,0,1,0,0]);// red
					matrix=matrix.concat([0,0,1,0,0]);// green
					matrix=matrix.concat([0,0,1,0,0]);// blue
					matrix=matrix.concat([0,0,0,1,0]);// alpha
				break;
				case 100: //Freeze
					matrix=matrix.concat([0,0,1,0,0]);// red
					matrix=matrix.concat([0,0,1.6,0,0]);// green
					matrix=matrix.concat([.2,.2,2.7,0,0]);// blue
					matrix=matrix.concat([0,0,0,1,0]);// alpha
				break;
				case 110: //Rarity Green
					matrix=matrix.concat([.8,0,0,0,0]);// red
					matrix=matrix.concat([0,1,0,0,0]);// green
					matrix=matrix.concat([0,0,.8,0,0]);// blue
					matrix=matrix.concat([0,0,0,1,0]);// alpha
				break;
				case 111: //Rarity Blue
					matrix=matrix.concat([.8,0,0,0,0]);// red
					matrix=matrix.concat([0,.8,0,0,0]);// green
					matrix=matrix.concat([0,0,1,0,0]);// blue
					matrix=matrix.concat([0,0,0,1,0]);// alpha
				break;
				case 112: //Rarity Red
					matrix=matrix.concat([1,0,0,0,0]);// red
					matrix=matrix.concat([0,.5,0,0,0]);// green
					matrix=matrix.concat([0,0,.5,0,0]);// blue
					matrix=matrix.concat([0,0,0,1,0]);// alpha
				break;
			}
			var my_filter:ColorMatrixFilter=new ColorMatrixFilter(matrix);
			a.applyFilter(a,new Rectangle(0,0,a.width,a.height),new Point(0,0), my_filter);
		}
	}
}