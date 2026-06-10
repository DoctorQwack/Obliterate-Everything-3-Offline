package  
{
	import flash.display.MovieClip;
	
	public class HelpScreen extends MovieClip
	{
		var mom;
		
		public function HelpScreen(m) 
		{
			var i:int;
			var j:int = 0;
			var a;
			mom = m;
			kx.mom = mom;
			
			subscreen.gotoAndStop(1);
			for(i = 0; i < numChildren; i++){
				a = getChildAt(i);
				if(a is HelpTextKnob){
					a.mom = mom;
					a.txt.alpha = .5;
					a.id = j;
					switch(j){
						case 0:
							a.txt.text = "Basics";
							a.txt.alpha = 1;
						break;
						case 1:
							a.txt.text = "Resources";
						break;
						case 2:
							a.txt.text = "Ships";
						break;
						case 3:
							a.txt.text = "Structures";
						break;
						case 4:
							a.txt.text = "Technologies";
						break;
						case 5:
							a.txt.text = "Upgrades";
						break;
						case 6:
							a.txt.text = "Effects";
						break;
						case 7:
							a.txt.text = "Munitions";
						break;
					}
					j++;
				}
			}
		}

	}
	
}
