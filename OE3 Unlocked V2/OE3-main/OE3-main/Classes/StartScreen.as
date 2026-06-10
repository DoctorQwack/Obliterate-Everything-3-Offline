package 
{
	import flash.display.MovieClip;
	import flash.text.TextField
	import flash.events.MouseEvent;
	import flash.display.Graphics;
		
	public class StartScreen extends MovieClip 
	{
		var mom;
		
		var knobstart:KnobStart;
		
		public function StartScreen(m)
		{
			mom = m;
			
			var i:int;
			var j:int;
			var k:int;
			var p:int;
			
			knobstart = new KnobStart();
			knobstart.mom = mom;
			addChild(knobstart);
			knobstart.x = .5 * mom.resX;
			knobstart.y = .75 * mom.resY;
		}
	}
}