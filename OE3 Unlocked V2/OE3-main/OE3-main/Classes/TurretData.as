package
{
	public class TurretData
	{
		public var s:Array = new Array(4);
		
		public var costenergy:int = 0;
		public var turn:Number = 1;
		public var miner:Boolean = false;
		public var healer:Boolean = false;

		public var tstructs:Boolean = true;
		public var tships:Boolean = true;
		public var tshots:Boolean = false;
		
		public var sheetW:int = 6;
		public var sheetH:int = 6;
		public var anim:Boolean = false;
		public var picid:int = 0;
		
		public var guns:Array = new Array();
		public var ammos:Array = new Array();
		
		public function TurretData(ss)
		{
			var i:int;
			s[0] = ss[0];
			for(i = 0; i < s.length; i++){
				s[i] = 0;
			}
			for(i = 0; i < ss.length; i++){
				s[i] = ss[i];
			}
			
			switch(s[0])
			{
				case 0: //Blaster
					turn = .09;
					picid = 0;
					guns[0] = new Array(3);guns[0][0] = 100;guns[0][1] = 0;guns[0][2] = 22;
					ammos[0] = [0,1,6];
				break;
				case 1: //Double Blaster
					turn = .08;
					picid = 1;
					guns[0] = new Array(3);guns[0][0] = 101;guns[0][1] = .025;guns[0][2] = 22;
					guns[1] = new Array(3);guns[1][0] = 101;guns[1][1] = -.025;guns[1][2] = 22;
					ammos[0] = [0,1,6];
					ammos[1] = [0,1,6];
				break;
				case 2: //Autogun
					turn = .1;
					picid = 2;
					guns[0] = new Array(3);guns[0][0] = 102;guns[0][1] = .05;guns[0][2] = 18;
					guns[1] = new Array(3);guns[1][0] = 102;guns[1][1] = -.05;guns[1][2] = 18;
					guns[2] = new Array(3);guns[2][0] = 102;guns[2][1] = 0;guns[2][2] = 18;
					ammos[0] = [1,0,3];
					ammos[1] = [1,0,3];
					ammos[2] = [1,0,3];
				break;
				case 3: //Bomb Rack
					turn = .03;
					picid = 3;
					guns[0] = new Array(3);guns[0][0] = 103;guns[0][1] = .04;guns[0][2] = 16;
					guns[1] = new Array(3);guns[1][0] = 103;guns[1][1] = -.04;guns[1][2] = 16;
					ammos[0] = [5,3,6];
					ammos[1] = [5,3,6];
				break;
				case 4: //MicroMissiles
					turn = .07;
					picid = 4;
					guns[0] = new Array(3);guns[0][0] = 104;guns[0][1] = 0;guns[0][2] = 16;
					ammos[0] = [7,1,6];
				break;
				case 5: //Artillery
					turn = .03;
					picid = 5;
					tships = false;
					guns[0] = new Array(3);guns[0][0] = 105;guns[0][1] = 0;guns[0][2] = 22;
					ammos[0] = [8,2,6];
				break;
				case 6: //QuadMicroMissiles
					turn = .05;
					picid = 6;
					guns[0] = new Array(3);guns[0][0] = 106;guns[0][1] = .05;guns[0][2] = 16;
					guns[1] = new Array(3);guns[1][0] = 106;guns[1][1] = -.05;guns[1][2] = 16;
					ammos[0] = [7,2,6];
					ammos[1] = [7,2,6];
				break;
				case 7: //Autocannon
					turn = .08;
					picid = 7;
					guns[0] = new Array(3);guns[0][0] = 107;guns[0][1] = .055;guns[0][2] = 20;
					guns[1] = new Array(3);guns[1][0] = 107;guns[1][1] = -.055;guns[1][2] = 20;
					guns[2] = new Array(3);guns[2][0] = 107;guns[2][1] = 0;guns[2][2] = 20;
					ammos[0] = [1,2,3];
					ammos[1] = [1,2,3];
					ammos[2] = [1,2,3];
				break;
				case 8: //Edgeslasher
					turn = .07;
					picid = 8;
					guns[0] = new Array(3);guns[0][0] = 108;guns[0][1] = 0;guns[0][2] = 16;
					ammos[0] = [3,2,3];
				break;
				case 9: //Plasmacaster
					turn = .02;
					picid = 9;
					guns[0] = new Array(3);guns[0][0] = 109;guns[0][1] = 0;guns[0][2] = 16;
					ammos[0] = [4,3,6];
				break;
				case 10: //Laser
					turn = .1;
					picid = 10;
					guns[0] = new Array(3);guns[0][0] = 110;guns[0][1] = 0;guns[0][2] = 16;
					ammos[0] = [100,0,3];
				break;
				case 11: //Lasercannon
					turn = .03;
					picid = 11;
					guns[0] = new Array(3);guns[0][0] = 111;guns[0][1] = 0;guns[0][2] = 18;
					ammos[0] = [100,3,3];
					//ammos[0] = [13,4,1];
					//ammos[0] = [14,4,8];
				break;
				case 12: //Miningturret
					turn = .05;
					picid = 12;
					miner = true;
					guns[0] = new Array(3);guns[0][0] = 112;guns[0][1] = 0;guns[0][2] = 12;
					ammos[0] = [101,0,3];
				break;
				case 13: //Phalanx
					turn = .1;
					picid = 13;
					tstructs = false;
					tships = false;
					tshots = true;
					guns[0] = new Array(3);guns[0][0] = 113;guns[0][1] = 0;guns[0][2] = 8;
					ammos[0] = [102,0,-1];
				break;
				case 14: //Repair
					turn = .1;
					picid = 14;
					healer = true;
					guns[0] = new Array(3);guns[0][0] = 114;guns[0][1] = -.07;guns[0][2] = 14;
					guns[1] = new Array(3);guns[1][0] = 114;guns[1][1] = .07;guns[1][2] = 14;
					ammos[0] = [105,1,5];
					ammos[1] = [105,1,5];
				break;
				case 16: //Autocaster
					turn = .05;
					picid = 16;
					guns[0] = new Array(3);guns[0][0] = 116;guns[0][1] = .05;guns[0][2] = 16;
					guns[1] = new Array(3);guns[1][0] = 116;guns[1][1] = -.05;guns[1][2] = 16;
					ammos[0] = [4,0,6];
					ammos[1] = [4,0,6];
				break;
				case 17: //Microlaser
					turn = .1;
					picid = 17;
					guns[0] = new Array(3);guns[0][0] = 117;guns[0][1] = .03;guns[0][2] = 12;
					guns[1] = new Array(3);guns[1][0] = 117;guns[1][1] = -.03;guns[1][2] = 12;
					ammos[0] = [107,0,6];
					ammos[1] = [107,0,6];
				break;
				case 47: //Turret
					turn = .1;
					picid = 47;
					guns[0] = new Array(3);guns[0][0] = 147;guns[0][1] = 0;guns[0][2] = 16;
					ammos[0] = [106,2,8];
				break; 
				case 48: //Crystal
					turn = .1;
					picid = 48;
					guns[0] = new Array(3);guns[0][0] = 148;guns[0][1] = 0;guns[0][2] = 16;
					ammos[0] = [0,1,8];
				break;
				case 49: //Fang
					turn = .09;
					picid = 49;
					guns[0] = new Array(3);guns[0][0] = 149;guns[0][1] = 0;guns[0][2] = 22;
					ammos[0] = [0,1,1];
				break;
				case 50: //Mjolnir
					turn = .05;
					picid = 50;
					tships = false;
					guns[0] = new Array(3);guns[0][0] = 150;guns[0][1] = 0;guns[0][2] = 40;
					ammos[0] = [8,4,6];
				break;
				case 51: //Apocalypse
					turn = .025;
					picid = 51;
					tships = false;
					guns[0] = new Array(3);guns[0][0] = 151;guns[0][1] = .075;guns[0][2] = 20;
					ammos[0] = [11,4,10];
				break;
				case 52: //Void Lance
					turn = .05;
					picid = 52;
					guns[0] = new Array(3);guns[0][0] = 152;guns[0][1] = .075;guns[0][2] = 20;
					guns[1] = new Array(3);guns[1][0] = 152;guns[1][1] = -.075;guns[1][2] = 20;
					ammos[0] = [15,4,19];
					ammos[1] = [15,4,19];
				break;
				case 53: //HyperRepair
					turn = .05;
					picid = 53;
					healer = true;
					guns[0] = new Array(3);guns[0][0] = 153;guns[0][1] = -.07;guns[0][2] = 28;
					guns[1] = new Array(3);guns[1][0] = 153;guns[1][1] = .07;guns[1][2] = 28;
					guns[2] = new Array(3);guns[2][0] = 153;guns[2][1] = 0;guns[2][2] = 24;
					ammos[0] = [105,3,5];
					ammos[1] = [105,3,5];
					ammos[2] = [105,3,5];
				break;
			}
			
			DoMods();
		}
		
		public function DoMods()
		{
			var i:int;
			var j:int;
			var k:int;
			for(i = 1; i < 4; i++){
				switch(s[i]){
					case 11: //Cyan
						for(j = 0; j < ammos.length; j++){
							if(ammos[j][0] < 100){
								ammos[j][2] = 0;
							}
						}					
						break;
					case 12: //YGreen
						for(j = 0; j < ammos.length; j++){
							if(ammos[j][0] < 100){
								ammos[j][2] = 1;
							}
						}
					break;
					case 13: //White
						for(j = 0; j < ammos.length; j++){
							if(ammos[j][0] < 100){
								ammos[j][2] = 9;
							}
						}
					break;
					case 14: //Violet
						for(j = 0; j < ammos.length; j++){
							if(ammos[j][0] < 100){
								ammos[j][2] = 4;
							}
						}
					break;
					case 15: //NeonGreen
						for(j = 0; j < ammos.length; j++){
							if(ammos[j][0] < 100){
								ammos[j][2] = 5;
							}
						}
					break;
					case 16: //Yellow
						for(j = 0; j < ammos.length; j++){
							if(ammos[j][0] < 100){
								ammos[j][2] = 7;
							}
						}
					break;
					case 17: //Blue
						for(j = 0; j < ammos.length; j++){
							if(ammos[j][0] < 100){
								ammos[j][2] = 8;
							}
						}
					break;
					case 18: //Fusion
						for(j = 0; j < ammos.length; j++){
							if(ammos[j][0] < 100){
								ammos[j][2] = 10;
							}
						}
					break;
				}
			}
		}
	}
}