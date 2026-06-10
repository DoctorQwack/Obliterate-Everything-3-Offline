package 
{
	import flash.display.MovieClip;
	import flash.text.TextField
	import flash.events.MouseEvent;
		
	public class Alliances extends MovieClip 
	{
		var mom;
		
		var a:Array = new Array();
		
		public function Alliances()
		{
			//0 Enemies
			//1 Neutral
			//2 Allies
			a[0] = [1,1,1,1,1,1,1,1,1,1,1,1]; //Nature
			a[1] = [1,2,0,0,0,0,0,0,0,0,0,0]; //Player
			a[2] = [1,0,2,0,0,0,0,0,0,0,0,0]; //
			a[3] = [1,0,0,2,0,0,0,0,0,0,0,0]; //
			a[4] = [1,0,0,0,2,0,0,0,0,0,0,0]; //
			a[5] = [1,0,0,0,0,2,0,0,0,0,0,0]; //
			a[6] = [1,0,0,0,0,0,2,0,0,0,0,0]; //
			a[7] = [1,0,0,0,0,0,0,2,0,0,0,0]; //
			a[8] = [1,0,0,0,0,0,0,0,2,0,0,0]; //
			a[9] = [1,0,0,0,0,0,0,0,0,2,0,0]; //
			a[10] = [1,0,0,0,0,0,0,0,0,0,2,0]; //
			a[11] = [1,0,0,0,0,0,0,0,0,0,0,2]; //
		}
	}
}