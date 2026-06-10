package 
{
	import flash.display.MovieClip;
	public class Hangar extends MovieClip 
	{
		public var shipspeed:Number = 0;
		
		public var launchcool:int;
		public var launchheat:int = 50;
		public var launchburstmax:int = 3;
		public var launchburst:int = launchburstmax;
		public var launchburstcool:int = 0;
		public var launcht:Number = 0;
		public var launchburstheat:int = 3;
		public var builder:Boolean = false;
		public var t:Number;
		public var r:Number;
		public var s:int;
		public var shiptype;
		
		public var active:Boolean;
		
		public var aivalue:Number;
		public var aitier:Number;
		
		public var up;
		public var mom;
		public var myship;
		
		public function Hangar(m,upp,ss:int,tt:Number,rr:Number)
		{
			x = 0;
			y = 0;
			mom = m;
			up = upp;
			
			t = tt;
			r = rr;
			s = ss;
			active = false;
			aivalue = 1;
			aitier = 1;
			
			switch(s){
				case 1: //FighterBay
					shipspeed = 0;
					launchheat = 75;
					launchburstcool = 0;
					launchburstheat = 0;
					launchburstmax = 1;
					launchburst = launchburstmax;
					active = true;
					aitier = 1;
					launchcool = 0;
					//builder = true;
					builder = false;
				break;
				case 2: //Stardock
					shipspeed = 0;
					launchheat = 100;
					launchburstcool = 0;
					launchburstheat = 0;
					launchburstmax = 1;
					launchburst = launchburstmax;
					active = true;
					aitier = 1;
					launchcool = 0;
					//builder = true;
					builder = false;
				break;
				case 3: //Starport
					shipspeed = 0;
					launchheat = 100;
					launchburstcool = 0;
					launchburstheat = 0;
					launchburstmax = 1;
					launchburst = launchburstmax;
					active = true;
					aitier = 1;
					launchcool = 0;
					//builder = true;
					builder = false;
				break;
				case 4: //Biolab
					shipspeed = 0;
					launchheat = 50;
					launchburstcool = 0;
					launchburstheat = 5;
					launchburstmax = 3;
					launchburst = launchburstmax;
					active = true;
					aitier = 1;
					launchcool = 0;
					builder = false;
				break;
				case 5: //Bot FighterBay
					shipspeed = 0;
					launchheat = 200;
					launchburstcool = 0;
					launchburstheat = 0;
					launchburstmax = 1;
					launchburst = launchburstmax;
					active = true;
					aitier = 1;
					launchcool = 0;
					//builder = true;
					builder = false;
				break;
				case 6: //Bot Stardock
					shipspeed = 0;
					launchheat = 200;
					launchburstcool = 0;
					launchburstheat = 0;
					launchburstmax = 1;
					launchburst = launchburstmax;
					active = true;
					aitier = 1;
					launchcool = 0;
					//builder = true;
					builder = false;
				break;
				case 7: //Bot Starport
					shipspeed = 0;
					launchheat = 200;
					launchburstcool = 0;
					launchburstheat = 0;
					launchburstmax = 1;
					launchburst = launchburstmax;
					active = true;
					aitier = 1;
					launchcool = 0;
					//builder = true;
					builder = false;
				break;
				case 8: //Naval Yard
					shipspeed = 0;
					launchheat = 120;
					launchburstcool = 0;
					launchburstheat = 0;
					launchburstmax = 1;
					launchburst = launchburstmax;
					active = true;
					aitier = 1;
					launchcool = 0;
					//builder = true;
					builder = false;
				break;
				case 9: //Fighter Yard
					shipspeed = 10;
					launcht = 0;
					launchheat = 40;
					launchburstcool = 0;
					launchburstheat = 4;
					launchburstmax = 1;
					launchburst = launchburstmax;
					active = true;
					aitier = 1;
					launchcool = 0;
					//builder = true;
					builder = false;
				break;
				case 10: //Fighter Yard B
					shipspeed = 10;
					launcht = .25;
					launchheat = 40;
					launchburstcool = 0;
					launchburstheat = 4;
					launchburstmax = 1;
					launchburst = launchburstmax;
					active = true;
					aitier = 1;
					launchcool = 0;
					//builder = true;
					builder = false;
				break;
				case 11: //Fighter Yard C
					shipspeed = 10;
					launcht = .5;
					launchheat = 40;
					launchburstcool = 0;
					launchburstheat = 4;
					launchburstmax = 1;
					launchburst = launchburstmax;
					active = true;
					aitier = 1;
					launchcool = 0;
					//builder = true;
					builder = false;
				break;
				case 12: //Fighter Yard D
					shipspeed = 10;
					launcht = -.25;
					launchheat = 40;
					launchburstcool = 0;
					launchburstheat = 4;
					launchburstmax = 1;
					launchburst = launchburstmax;
					active = true;
					aitier = 1;
					launchcool = 0;
					//builder = true;
					builder = false;
				break;
				case 30: //Mod Hangar
					shipspeed = 5;
					launchheat = 35;
					launchcool = launchheat;
					launchburstcool = 0;
					launchburstheat = 5;
					launchburstmax = 1;
					launchburst = launchburstmax;
					active = true;
					aitier = 1;
					builder = false;
				break;
				case 31: //Mod Hangar
					shipspeed = 5;
					launchheat = 30;
					launchcool = launchheat;
					launchburstcool = 0;
					launchburstheat = 3;
					launchburstmax = 5;
					launchburst = launchburstmax;
					active = true;
					aitier = 1;
					builder = false;
				break;
				case 52: //OdysseyBay
					shipspeed = 7;
					launchheat = 60;
					launchcool = launchheat;
					launchburstcool = 0;
					launchburstheat = 5;
					launchburstmax = 4;
					launchburst = launchburstmax;
					active = true;
					aitier = 1;
					builder = false;
				break;
				case 101: //LegionBay Left
					shipspeed = 7;
					launchheat = 100;
					launchcool = launchheat;
					launchburstcool = 0;
					launchburstheat = 5;
					launchburstmax = 3;
					launchburst = launchburstmax;
					launcht = -.25;
					active = true;
					aitier = 1;
					builder = false;
				break;
				case 102: //LegionBay Right
					shipspeed = 7;
					launchheat = 100;
					launchcool = launchheat;
					launchburstcool = 0;
					launchburstheat = 5;
					launchburstmax = 3;
					launchburst = launchburstmax;
					launcht = .25;
					active = true;
					aitier = 1;
					builder = false;
				break;
				case 103: //Mastodon Bay
					shipspeed = 12;
					launchheat = 100;
					launchcool = launchheat;
					launchburstcool = 0;
					launchburstheat = 5;
					launchburstmax = 3;
					launchburst = launchburstmax;
					active = true;
					aitier = 1;
					builder = false;
				break;
				case 104: //TremorBay Left
					shipspeed = 5;
					launchheat = 25;
					launchcool = launchheat;
					launchburstcool = 0;
					launchburstheat = 4;
					launchburstmax = 1;
					launchburst = launchburstmax;
					launcht = -.25;
					active = true;
					aitier = 1;
					builder = false;
				break;
				case 105: //TremorBay Right
					shipspeed = 5;
					launchheat = 25;
					launchcool = launchheat;
					launchburstcool = 0;
					launchburstheat = 4;
					launchburstmax = 1;
					launchburst = launchburstmax;
					launcht = .25;
					active = true;
					aitier = 1;
					builder = false;
				break;
				case 106: //Basilisk Left
					shipspeed = 7;
					launchheat = 50;
					launchcool = launchheat;
					launchburstcool = 0;
					launchburstheat = 4;
					launchburstmax = 1;
					launchburst = launchburstmax;
					launcht = -.25;
					active = true;
					aitier = 1;
					builder = false;
				break;
				case 107: //Basilisk Right
					shipspeed = 7;
					launchheat = 50;
					launchcool = launchheat;
					launchburstcool = 0;
					launchburstheat = 4;
					launchburstmax = 1;
					launchburst = launchburstmax;
					launcht = .25;
					active = true;
					aitier = 1;
					builder = false;
				break;
				case 108: //Jupiter Bay
					shipspeed = 14;
					launchheat = 100;
					launchcool = launchheat;
					launchburstcool = 0;
					launchburstheat = 5;
					launchburstmax = 4;
					launchburst = launchburstmax;
					active = true;
					aitier = 1;
					builder = false;
				break;
				case 109: //CorvetteBay Left
					shipspeed = 7;
					launchheat = 50;
					launchcool = launchheat;
					launchburstcool = 0;
					launchburstheat = 4;
					launchburstmax = 1;
					launchburst = launchburstmax;
					launcht = -.25;
					active = true;
					aitier = 1;
					builder = false;
				break;
				case 110: //CorvetteBay Right
					shipspeed = 7;
					launchheat = 50;
					launchcool = launchheat;
					launchburstcool = 0;
					launchburstheat = 4;
					launchburstmax = 1;
					launchburst = launchburstmax;
					launcht = .25;
					active = true;
					aitier = 1;
					builder = false;
				break;
				case 111: //Biohazard Left
					shipspeed = 7;
					launchheat = 9;
					launchcool = launchheat;
					launchburstcool = 0;
					launchburstheat = 6;
					launchburstmax = 1;
					launchburst = launchburstmax;
					launcht = -.25;
					active = true;
					aitier = 1;
					builder = false;
				break;
				case 112: //Biohazard Right
					shipspeed = 7;
					launchheat = 9;
					launchcool = launchheat;
					launchburstcool = 0;
					launchburstheat = 6;
					launchburstmax = 1;
					launchburst = launchburstmax;
					launcht = .25;
					active = true;
					aitier = 1;
					builder = false;
				break;
				case 113: //Archangel Left
					shipspeed = 7;
					launchheat = 100;
					launchcool = launchheat;
					launchburstcool = 0;
					launchburstheat = 4;
					launchburstmax = 3;
					launchburst = launchburstmax;
					launcht = -.25;
					active = true;
					aitier = 1;
					builder = false;
				break;
				case 114: //Archangel Right
					shipspeed = 7;
					launchheat = 100;
					launchcool = launchheat;
					launchburstcool = 0;
					launchburstheat = 4;
					launchburstmax = 3;
					launchburst = launchburstmax;
					launcht = .25;
					active = true;
					aitier = 1;
					builder = false;
				break;
				case 115: //Tyrant Hangar
					shipspeed = 15;
					launchheat = 100;
					launchcool = launchheat;
					launchburstcool = 0;
					launchburstheat = 4;
					launchburstmax = 3;
					launchburst = launchburstmax;
					launcht = 0;
					active = true;
					aitier = 1;
					builder = false;
				break;
			}
			//TEST
			shiptype = null;
		}
		
		public function Die()
		{
			/*if(builder == true && myship != null){
				myship.armor = -100;
				myship = null;
			}*/
			up = null;
		}
		
		public function DoStuff()
		{
			if(shiptype != null){
				if(launchcool > 0){
					launchcool = launchcool - 1;
				}
				if(launchburstcool > 0){
					launchburstcool = launchburstcool - 1;
				}
				if(active == true || (active == false && launchburst < launchburstmax)){
					LaunchControl();
				}
			}
		}
		
		public function LaunchControl()
		{
			if(builder == false && launchcool == 0 && launchburstcool == 0){
				//Fire
				Launch();
				//Timing
				launchburst = launchburst - 1;
				launchburstcool = launchburstheat;
				if(launchburst == 0){
					launchburst = launchburstmax;
					launchburstcool = 0;
					launchcool = launchheat;
				}
			}
			if(builder == true && launchcool == launchheat - 1 && myship == null){
				//Fire
				Launch();
				//mom.ships[mom.ships.length-1].BuildMode();
				//myship = mom.ships[mom.ships.length-1];
			}
			if(builder == true && myship != null){
				/*myship.alpha = 1 - (launchcool / launchheat);
				if(myship.dying == 0){
					if(myship.armor < myship.maxarmor){
						myship.armor = myship.armor + myship.maxarmor * (1 / launchheat);
					}else{
						myship.armor = myship.maxarmor;
					}
				}*/
			}
			if(builder == true && launchcool == 0){
				/*myship.building = false;
				myship.alpha = 1;
				myship = null;
				//Timing
				launchcool = launchheat;*/
			}
			if(builder == true && launchcool > 0 && launchcool < launchheat - 1 && myship.armor <= 0){
				/*launchcool = launchheat;
				myship = null;*/
			}
		}
		
		public function Launch()
		{
			var i:int;
			var xx:Number;
			var yy:Number;
			var xv:Number;
			var yv:Number;
			var tt:Number;
			tt = up.t;
			xx = up.xx + r*Math.sin((up.t+t)*6.283);
			yy = up.yy - .75*r*Math.cos((up.t+t)*6.283);
			xv = up.xv+shipspeed*Math.sin((up.t+launcht)*6.283);
			yv = up.yv-1*shipspeed*Math.cos((up.t+launcht)*6.283);
			mom.GenShip(shiptype,up.faction,xx,yy,xv,yv,tt+launcht);
		}
	}
}