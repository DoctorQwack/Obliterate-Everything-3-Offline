package 
{
	public class EffectData
	{
		public var lifespan:Number = 0;
		public var sheetW:Number = 6;
		public var sheetH:Number = 6;
		public var effectidi:int = 0;
		public var effectidj:int = 0;
		public var effectidk:int = 2;
		public var reverse:Boolean = false;
		public var delayt:int = 0;
		public var blendmode:String = "normal";
		public var explodemode:int = 0;
		
		public var mods:Array = new Array();
		
		public function EffectData(ss)
		{

			switch(ss[0]){
				case 0: //Boom
					effectidi = 0;
					lifespan = 24;
					sheetW = 6;
					sheetH = 4;
					blendmode = "screen";
				break;
				case 1: //BoomB
					effectidi = 1;
					lifespan = 20;
					sheetW = 5;
					sheetH = 4;
					blendmode = "screen";
				break;
				case 2: //ConfettiA
					effectidi = 2;
					lifespan = 16;
					sheetW = 4;
					sheetH = 4;
				break;
				case 3: //FireworkA
					effectidi = 3;
					lifespan = 20;
					sheetW = 5;
					sheetH = 4;
				break;
				case 4: //HaloA
					effectidi = 4;
					lifespan = 18;
					sheetW = 6;
					sheetH = 3;
				break;
				case 5: //NovaA
					effectidi = 5;
					lifespan = 24;
					sheetW = 6;
					sheetH = 4;
					blendmode = "add";
				break;
				case 6: //SparksA
					effectidi = 6;
					lifespan = 14;
					sheetW = 7;
					sheetH = 2;
				break;
				case 7: //Bubbles
					effectidi = 7;
					lifespan = 10;
					sheetW = 10;
					sheetH = 1;
				break;
				case 8: //Heal
					effectidi = 8;
					lifespan = 6;
					sheetW = 1;
					sheetH = 1;
				break;
				case 9: //Bolt
					effectidi = 9;
					lifespan = 23;
					sheetW = 1;
					sheetH = 1;
				break;
				case 10: //Metal
					effectidi = 10;
					lifespan = 23;
					sheetW = 1;
					sheetH = 1;
				break;
				case 20: //Debris1
					effectidi = 20;
					lifespan = 24 + Math.floor(Math.random() * 20);
					sheetW = 4;
					sheetH = 4;
					explodemode = 1;
				break;
				case 21: //Debris2
					effectidi = 21;
					lifespan = 24 + Math.floor(Math.random() * 20);
					sheetW = 4;
					sheetH = 4;
					explodemode = 1;
				break;
				case 22: //Debris3
					effectidi = 22;
					lifespan = 24 + Math.floor(Math.random() * 20);
					sheetW = 4;
					sheetH = 4;
					explodemode = 1;
				break;
				
				
				case 50: //HaloB
					effectidi = 50;
					lifespan = 18;
					sheetW = 6;
					sheetH = 3;
				break;
				case 51: //BoomC
					effectidi = 51;
					lifespan = 20;
					sheetW = 5;
					sheetH = 4;
					//blendmode = "screen";
				break;
				case 52: //GFireworkA
					effectidi = 52;
					lifespan = 20;
					sheetW = 5;
					sheetH = 4;
				break;
				case 53: //NovaB
					effectidi = 53;
					lifespan = 24;
					sheetW = 6;
					sheetH = 4;
					blendmode = "add";
				break;
				case 54: //SparksB
					effectidi = 54;
					lifespan = 14;
					sheetW = 7;
					sheetH = 2;
				break;
				case 55: //BlackFireworkA
					effectidi = 55;
					lifespan = 20;
					sheetW = 5;
					sheetH = 4;
				break;
			}
			
			//SIZE
			effectidj = ss[1];
			
			//SPECIAL
			switch(ss[2]){
				case 1: //Reverse
					reverse = true;
				break;
				case 2: //Delay
					delayt = Math.round(Math.random() * 20);
				break;
			}
		}
	}
}