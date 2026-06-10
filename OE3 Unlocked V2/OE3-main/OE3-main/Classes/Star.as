package 
{
	import flash.display.Bitmap;
	
	public class Star extends Bitmap 
	{
		public var yy:Number;
		public var xx:Number;
		
		public function Star()
		{

		}
		
		public function Die()
		{

		}
		
		public function Move()
		{
			x = Math.floor(xx);
			y = Math.floor(yy);
		}
	}
}