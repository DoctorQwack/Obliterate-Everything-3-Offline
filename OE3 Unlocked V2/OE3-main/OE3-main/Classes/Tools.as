package
{
	public class Tools
	{
		public static function MathRotateDirection(a:Number,b:Number)
		{
			var dir:Number
			var distance1:Number
			var distance2:Number
			distance1 = 0
			distance2 = 0
			dir = 0
			if( a < b ){
				distance1 =  b-a
				distance2 = a+1-b
				if (distance1 < distance2){
					dir = distance1 - distance2 + 1//1
				}
				if (distance1 > distance2){
					dir = distance1 - distance2 - 1//-1
				}
			}
			if( a > b ){
				distance1 =  a-b
				distance2 = b+1-a
				if (distance1 < distance2){
					dir = distance2 - distance1 - 1//-1
				}
				if (distance1 > distance2){
					dir = distance2 - distance1 + 1//1
				}
			}
			dir = dir /2
			return dir
		}
	}
}