package 
{
	public class ShotData
	{
		public var ammotype:String;
		public var adamage:Number = 0;
		public var sdamage:Number = 0;
		public var minedamage:Number = 0;
		public var lifespan:int = 0;
		public var laser:int = 0;
		public var missile:int = 0;
		public var vectored:int = 0;
		public var smash:int = 0;
		public var sheetW:int = 6;
		public var sheetH:int = 6;
		public var wide:int = 2;
		public var high:int = 2;
		public var shotidi:int = 0;
		public var shotidj:int = 0;
		public var shotidk:int = 0;
		public var boomtype:Array = new Array(3);
		public var blendmode:String = "normal";
		public var freeze:int = 0;
		public var acid:int = 0;
		public var ghost:Number = 1;
		public var force:Number = 0;
		public var popp:int = 0;
		public var nuker:Number = 0;
		public var shrink:int = 0;
		public var armor:int = 1;
		
		public var scanrange:int = 1000;
		public var igniteT:int = 0;
		public var burnT:int = 0;
		public var thrust:Number = 0;
		public var drag:Number = 1;
		public var turn:Number = 0;
		public var speedmax:Number = 20;
		public var smart:Boolean = false;
		public var engineburn:Boolean = false;
		public var animated:Boolean = false;
		
		public var tstructs:Boolean = true;
		public var tships:Boolean = true;
		public var tshots:Boolean = false;
		
		public var mods:Array = new Array();
		public var lasercolora:int = 0;
		public var lasercolorb:int = 0;
		
		public function ShotData(ss)
		{
			var d:Number;
			switch(ss[0]){
				//GUN
				case 0: //Blaster
					shotidi = 0;
					adamage = 1;
					sdamage = 1;
					lifespan = 7;
					wide = 6;
					high = 6;
				break;
				case 1: //Rail
					shotidi = 1;
					adamage = 2;
					sdamage = 2;
					lifespan = 7;
					smash = 1;
					wide = 6;
					high = 6;
				break;
				case 2: //Donut
					shotidi = 2;
					adamage = 4;
					sdamage = 4;
					lifespan = 10;
					smash = 1;
					wide = 2;
					high = 2;
				break;
				case 3: //Spinner
					shotidi = 3;
					adamage = 3;
					sdamage = 3;
					lifespan = 15;
					sheetW = 4;
					sheetH = 1;
					wide = 4;
					high = 4;
					animated = true;
					missile = 1;
					vectored = 1;
					drag = .98;
					scanrange = 150;
					popp = 1;
				break;
				case 4: //Plasma
					shotidi = 4;
					adamage = 10;
					sdamage = 10;
					lifespan = 15;
					sheetW = 4;
					sheetH = 4;
					wide = 6;
					high = 6;
					animated = true;
					blendmode = "add";
					popp = 1;
					//armor = 3;
				break;
				case 5: //Bomb
					shotidi = 5;
					adamage = 5;
					sdamage = 5;
					lifespan = 15;
					sheetW = 6;
					sheetH = 6;
					wide = 6;
					high = 6;
					missile = 2;
					igniteT = 3;
					burnT = 10;
					thrust = 4;
					vectored = 0;
					drag = 1;
					scanrange = 400;
					engineburn = true;
					popp = 1;
				break;
				case 6: //Missile
					shotidi = 6;
					adamage = 3;
					sdamage = 3;
					lifespan = 15;
					sheetW = 6;
					sheetH = 6;
					wide = 4;
					high = 4;
					missile = 1;
					vectored = 1;
					igniteT = 3;
					burnT = 14;
					drag = .98;
					thrust = 4;
					turn = .05;
					scanrange = 400;
					engineburn = true;
					popp = 1;
				break;
				case 7: //MissileB
					shotidi = 7;
					adamage = 3;
					sdamage = 3;
					lifespan = 15;
					sheetW = 6;
					sheetH = 6;
					wide = 4;
					high = 4;
					missile = 1;
					vectored = 1;
					igniteT = 2;
					burnT = 20;
					drag = .99;
					thrust = 7;
					turn = .06;
					scanrange = 400;
					engineburn = true;
					popp = 1;
				break;
				case 8: //Shell
					shotidi = 8;
					adamage = 14;
					sdamage = 14;
					lifespan = 16;
					sheetW = 6;
					sheetH = 6;
					wide = 6;
					high = 6;
					popp = 1;
				break;
				case 9: //Rocket
					shotidi = 9;
					adamage = 5;
					sdamage = 5;
					lifespan = 20;
					sheetW = 6;
					sheetH = 6;
					wide = 6;
					high = 6;
					missile = 2;
					igniteT = 1;
					burnT = 5;
					thrust = 8;
					vectored = 0;
					drag = 1;
					scanrange = 600;
					engineburn = true;
					popp = 1;
				break;
				case 10: //Homing Plasma
					shotidi = 4;
					adamage = 10;
					sdamage = 10;
					lifespan = 11;
					sheetW = 4;
					sheetH = 4;
					wide = 6;
					high = 6;
					animated = true;
					missile = 1;
					vectored = 1;
					drag = .93;
					scanrange = 300;
					blendmode = "add";
					popp = 1;
					//armor = 3;
				break;
				case 11: //Nuclear Missile
					shotidi = 5;
					adamage = 200;
					sdamage = 200;
					lifespan = 100;
					sheetW = 6;
					sheetH = 6;
					wide = 6;
					high = 6;
					missile = 2;
					igniteT = 6;
					burnT = 20;
					thrust = 4;
					vectored = 0;
					drag = 1;
					scanrange = 2000;
					engineburn = true;
					popp = 2; //Nuke
					nuker = 150;
				break;
				case 12: //Nuclear Homing Missile
					shotidi = 7;
					adamage = 200;
					sdamage = 200;
					lifespan = 100;
					sheetW = 6;
					sheetH = 6;
					wide = 6;
					high = 6;
					igniteT = 6;
					burnT = 20;
					thrust = 4;
					missile = 1;
					vectored = 1;
					drag = .98;
					thrust = 7;
					turn = .06;
					scanrange = 2000;
					engineburn = true;
					popp = 2; //Nuke
					nuker = 100;
				break;
				case 13: //Acid Rocket
					shotidi = 9;
					adamage = 5;
					sdamage = 5;
					lifespan = 15;
					sheetW = 6;
					sheetH = 6;
					wide = 6;
					high = 6;
					igniteT = 6;
					burnT = 20;
					thrust = 4;
					missile = 1;
					vectored = 1;
					drag = .98;
					thrust = 7;
					turn = .1;
					scanrange = 1000;
					engineburn = true;
					shotidk = 1;
					popp = 3; //Acid
					nuker = 100;
					acid = 50;
				break;
				case 14: //Freeze Rocket
					shotidi = 6;
					adamage = 5;
					sdamage = 5;
					lifespan = 15;
					sheetW = 6;
					sheetH = 6;
					wide = 6;
					high = 6;
					igniteT = 6;
					burnT = 20;
					thrust = 4;
					missile = 1;
					vectored = 1;
					drag = .98;
					thrust = 7;
					turn = .1;
					scanrange = 1000;
					engineburn = true;
					shotidk = 8;
					popp = 4; //Freeze
					nuker = 100;
					freeze = 15;
				break;
				case 15: //Singularity
					shotidi = 10;
					adamage = 0;
					sdamage = 0;
					lifespan = 10;
					wide = 6;
					high = 6;
					shrink = 1;
				break;
				case 16: //Homing Singularity
					shotidi = 10;
					adamage = 0;
					sdamage = 0;
					lifespan = 10;
					wide = 6;
					high = 6;
					missile = 1;
					vectored = 1;
					drag = .95;
					thrust = .5;
					turn = .2;
					shrink = 1;
				break;
				case 17: //EMP Shell
					shotidi = 8;
					adamage = 14;
					sdamage = 100;
					lifespan = 16;
					sheetW = 6;
					sheetH = 6;
					wide = 6;
					high = 6;
					shotidk = 0;
					popp = 5; //EMP
					nuker = 100;
					ss[2] = 0;
				break;
				case 100: //Laser
					laser = 1;
					adamage = 5;
					sdamage = 5;
					lifespan = 3;
					lasercolora = 0xFFAAFF;
					lasercolorb = 0xFF00FF;
				break;
				case 101: //Mining Laser
					laser = 1;
					adamage = .5;
					sdamage = .5;
					minedamage = 1;
					lifespan = 3;
					lasercolora = 0xFFAA00;
					lasercolorb = 0xFF0000;
				break;
				case 102: //Phalanx Laser
					laser = 1;
					adamage = 1;
					sdamage = 0;
					minedamage = 0;
					lifespan = 1;
					lasercolora = 0xFF3333;
					lasercolorb = 0xFF3333;
					ghost = 0.4;
				break;
				case 103: //Green Laser
					laser = 1;
					adamage = 8;
					sdamage = 8;
					lifespan = 3;
					lasercolora = 0xAAFFAA;
					lasercolorb = 0x00FF00;
				break;
				case 104: //Spartan Laser
					laser = 1;
					adamage = 25;
					sdamage = 25;
					lifespan = 6;
					lasercolora = 0xFFBB88;
					lasercolorb = 0xFF0000;
				break;
				case 105: //Healing Laser
					laser = 1;
					adamage = -5;
					sdamage = 0;
					lifespan = 3;
					lasercolora = 0xBBFF88;
					lasercolorb = 0x55FF00;
					ghost = 0.4;
				break;
				case 106: //Freeze Laser
					laser = 1;
					adamage = 8;
					sdamage = 8;
					lifespan = 3;
					lasercolora = 0xAAAAFF;
					lasercolorb = 0xAAAAFF;
				break;
				case 107: //MicroLaser
					laser = 1;
					adamage = 2;
					sdamage = 2;
					lifespan = 3;
					lasercolora = 0xFFAAAA;
					lasercolorb = 0xFF0000;
				break;
			}
			switch(ss[1]){
				case 0: //S
					shotidj = 0;
					adamage = adamage * 1;
					sdamage = sdamage * 1;
					minedamage = minedamage * 1;
					wide = wide * 1;
					high = high * 1;
					lifespan = Math.floor(lifespan * 1);
					boomtype[1] = 0;
				break;
				case 1: //M
					shotidj = 1;
					adamage = adamage * 2;
					sdamage = sdamage * 2;
					minedamage = minedamage * 2;
					wide = wide * 1.25;
					high = high * 1.25;
					lifespan = Math.floor(lifespan * 1.1);
					boomtype[1] = 1;
				break;
				case 2: //L
					shotidj = 2;
					adamage = adamage * 4;
					sdamage = sdamage * 4;
					minedamage = minedamage * 4;
					wide = wide * 1.75;
					high = high * 1.75;
					lifespan = Math.floor(lifespan * 1.2);
					boomtype[1] = 2;
				break;
				case 3: //XL
					shotidj = 3;
					adamage = adamage * 8;
					sdamage = sdamage * 8;
					minedamage = minedamage * 8;
					wide = wide * 3;
					high = high * 3;
					lifespan = Math.floor(lifespan * 1.3);
					boomtype[1] = 3;
				break;
				case 4: //XXL
					shotidj = 4;
					adamage = adamage * 16;
					sdamage = sdamage * 16;
					minedamage = minedamage * 16;
					wide = wide * 4;
					high = high * 4;
					lifespan = Math.floor(lifespan * 1.4);
					boomtype[1] = 4;
				break;
			}
			switch(ss[2]){
				case 0: //Cyan
					shotidk = 0;
					adamage = adamage * 1;
					sdamage = sdamage * 3;
					boomtype[0] = 6;
				break;
				case 1: //YGreen
					shotidk = 1;
					adamage = adamage * .75;
					sdamage = sdamage * .75;
					acid = int(3 * adamage + 1);
					boomtype[0] = 50;
				break;
				case 2: //Pink
					shotidk = 2;
					adamage = adamage * 1.1;
					sdamage = sdamage * 1.1;
					boomtype[0] = 51;
				break;
				case 3: //Orange
					shotidk = 3;
					adamage = adamage * 1;
					sdamage = sdamage * 1;
					boomtype[0] = 0;
				break;
				case 4: //Violet
					shotidk = 4;
					adamage = adamage * 1.2;
					sdamage = sdamage * 1.2;
					boomtype[0] = 2;
				break;
				case 5: //Neon
					shotidk = 5;
					adamage = adamage * 1.15;
					sdamage = sdamage * 2;
					boomtype[0] = 54;
				break;
				case 6: //Red
					shotidk = 6;
					adamage = adamage * 1;
					sdamage = sdamage * 1;
					boomtype[0] = 1;
				break;
				case 7: //Yello
					shotidk = 7;
					adamage = adamage * 1.3;
					sdamage = sdamage * 1;
					boomtype[0] = 4;
				break;
				case 8: //Blue
					shotidk = 8;
					adamage = adamage * .8;
					sdamage = sdamage * .4;
					if(freeze == 0){
						freeze = 7;
					}
					boomtype[0] = 53;
				break;
				case 9: //White
					shotidk = 9;
					adamage = adamage * 1.15;
					sdamage = sdamage * 1.15;
					force = .05;
					boomtype[0] = 3;
				break;
				case 10: //Fusion
					shotidk = 6;
					adamage = adamage * 1.5;
					sdamage = sdamage * .5;
					boomtype[0] = 5;
				break;
				case 11: //Blue 2
					shotidk = 8;
					adamage = adamage * .8;
					sdamage = sdamage * .4;
					freeze = 10;
					boomtype[0] = 53;
				break;
				case 12: //Blue 3
					shotidk = 8;
					adamage = adamage * .8;
					sdamage = sdamage * .4;
					freeze = 13;
					boomtype[0] = 53;
				break;
				case 13: //Blue 4
					shotidk = 8;
					adamage = adamage * .8;
					sdamage = sdamage * .4;
					freeze = 16;
					boomtype[0] = 53;
				break;
				case 14: //Blue 5
					shotidk = 8;
					adamage = adamage * .8;
					sdamage = sdamage * .4;
					freeze = 19;
					boomtype[0] = 53;
				break;
				case 15: //YGreen 2
					shotidk = 1;
					adamage = adamage * .75;
					sdamage = sdamage * .75;
					if(acid == 0){
						acid = int(3 * adamage + 1);
					}
					acid = Math.round(1.25 * acid);
					boomtype[0] = 50;
				break;
				case 16: //YGreen 3
					shotidk = 1;
					adamage = adamage * .75;
					sdamage = sdamage * .75;
					if(acid == 0){
						acid = int(3 * adamage + 1);
					}
					acid = Math.round(1.5 * acid);
					boomtype[0] = 50;
				break;
				case 17: //YGreen 4
					shotidk = 1;
					adamage = adamage * .75;
					sdamage = sdamage * .75;
					if(acid == 0){
						acid = int(3 * adamage + 1);
					}
					acid = Math.round(1.75 * acid);
					boomtype[0] = 50;
				break;
				case 18: //YGreen 5
					shotidk = 1;
					adamage = adamage * .75;
					sdamage = sdamage * .75;
					if(acid == 0){
						acid = int(3 * adamage + 1);
					}
					acid = Math.round(2 * acid);
					boomtype[0] = 50;
				break;
				case 19: //Singularity
					shotidk = 0;
					adamage = adamage * 1;
					sdamage = sdamage * 1;
					boomtype[0] = 55;
					boomtype[1] = 2;
				break;
			}
			//EXPLOSION SIZE
			d = 0;
			if(adamage >= sdamage){
				d = adamage;
			}
			if(sdamage > adamage){
				d = sdamage;
			}
			if(boomtype[1] == 0){
				if(d >= 0 && d < 3){
					boomtype[1] = 0;
				}
				if(d >= 3 && d < 10){
					boomtype[1] = 1;
				}
				if(d >= 10 && d < 25){
					boomtype[1] = 2;
				}
				if(d >= 25 && d < 50){
					boomtype[1] = 3;
				}
				if(d >= 50){
					boomtype[1] = 4;
				}
			}
		}
	}
}