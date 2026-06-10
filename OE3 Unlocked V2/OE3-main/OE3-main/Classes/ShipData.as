package 
{
	public class ShipData
	{
		public var s:Array = new Array(4);
		public var modtxt:Array = new Array();
		public var nametext:String = "";
		public var desctext:String = "";
		public var iconid:int;
		public var rarity:int = 0;
		public var itemclass:int = 0;//Station,Factory,Energy,Mining,Turret,Aux,Fighters,Medium,Capital,Research

		public var costenergy:int = 0;
		public var costmetal:int = 0;
		public var highai:int = 0;
		public var aistandoff:int = 120;
		public var mass:Number = 50;
		public var speedmax:Number = 5;
		public var turn:Number = 1;
		public var thrust:Number = .5;
		public var sheetW:Number = 6;
		public var sheetH:Number = 6;
		public var wide:Number = 10;
		public var high:Number = 8;
		public var picid;
		public var transformid:int = -1;
		public var burnmod:int = 0;
		public var lights:int = 0;
		public var armormax:Number = 0;
		public var shieldmax:Number = 0;
		public var armorregen:Number = 0;
		public var shieldregen:Number = 0;
		public var tacshieldregen:Number = 0;
		public var tacshieldmax:Number = 0;
		public var tacshieldr:int = 0;
		public var energy:Number = 0;
		public var debris:int = -1;
		public var guns:Array = new Array();
		public var ammos:Array = new Array();
		public var debrisammo:Array = new Array(3);
		public var tech:int = 0;
		public var race:int = 0;
		public var saucer:Boolean = false;
		public var anim:Boolean = false;
		public var animspeed:Number = 0;
		
		public var hangarlaunchheatmod:Number = 1;
		public var hangarlaunchspeedmod:Number = 1;
		public var hangarnummod:Number = 0;
		public var gunheatmod:Number = 1;
		public var missileheatmod:Number = 1;
		public var beamheatmod:Number = 1;
		public var plasheatmod:Number = 1;
		public var darkheatmod:Number = 1;
		public var gunrangemod:Number = 1;
		public var freezeboost:int = 0;
		public var acidboost:int = 0;
		public var specialrounds:int = -1;
		public var plasmod:int = 0;
		public var darkmod:int = 0;
		public var blastermod:int = 0;
		public var insurancemod:Number = 0;
		public var cloakmod:int = 0;
		public var cloakfieldr:int = 0;
		
		public var tstructs:Boolean = true;
		public var tships:Boolean = true;
		public var tshots:Boolean = false;
		public var miner:Boolean = false;
		public var healer:Boolean = false;
		
		public var hangars:Array = new Array();
		public var hangarships:Array = new Array();
		public var turrets:Array = new Array();
		
		public function ShipData(ss)
		{
			var i:int;
			var temp:Number;
			s[0] = ss[0];
			for(i = 0; i < s.length; i++){
				s[i] = 0;
			}
			for(i = 0; i < ss.length; i++){
				s[i] = ss[i];
			}
			iconid = s[0];
			debrisammo = [-1,-1,-1];
			
			switch(s[0]){
				case 200: //Piranha
					nametext = "Piranha";
					desctext = "Basic Fighter.";
					itemclass = 6;
					highai = 1;
					armormax = 6;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 5;
					speedmax = 10;
					turn = .04;
					thrust = 1;
					sheetW = 6;
					sheetH = 6;
					wide = 8;
					high = 7;
					picid = 0;
					lights = 1;
					guns[0] = new Array(3);guns[0][0] = 0;guns[0][1] = 0;guns[0][2] = 15;
					guns[1] = new Array(3);guns[1][0] = 0.1;guns[1][1] = 0;guns[1][2] = 15;
					ammos[0] = [0,0,3];
					ammos[1] = [6,1,3];
					costenergy = 25;
				break;
				case 201: //Knight
					nametext = "Knight";
					desctext = "Heavy Fighter with missiles.";
					itemclass = 6;
					highai = 1;
					armormax = 15;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 5;
					speedmax = 12;
					turn = .07;
					thrust = 1.5;
					sheetW = 6;
					sheetH = 6;
					wide = 8;
					high = 7;
					picid = 1;
					lights = 1;
					guns[0] = new Array(3);guns[0][0] = 1;guns[0][1] = 0;guns[0][2] = 15;
					ammos[0] = [6,1,3];
					costenergy = 75;
					costmetal = 0;
				break;
				case 202: //Mosquito
					nametext = "Mosquito";
					desctext = "Bomber. Attacks structures.";
					itemclass = 6;
					highai = 1;
					armormax = 10;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 8;
					speedmax = 6;
					turn = .04;
					thrust = .8;
					sheetW = 6;
					sheetH = 6;
					wide = 8;
					high = 7;
					picid = 2;
					lights = 1;
					tstructs = true;
					tships = false;
					guns[0] = new Array(3);guns[0][0] = 2;guns[0][1] = 0;guns[0][2] = 15;
					ammos[0] = [5,2,6];
					costenergy = 75;
				break;
				case 203: //Mantis
					nametext = "Mantis";
					desctext = "Basic Fighter.";
					itemclass = 6;
					highai = 1;
					armormax = 12;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 5;
					speedmax = 8;
					turn = .035;
					thrust = .8;
					sheetW = 6;
					sheetH = 6;
					wide = 8;
					high = 7;
					picid = 3;
					lights = 1;
					guns[0] = new Array(3);guns[0][0] = 3;guns[0][1] = -.05;guns[0][2] = 15;
					guns[1] = new Array(3);guns[1][0] = 3;guns[1][1] = .05;guns[1][2] = 15;
					ammos[0] = [1,0,3];
					ammos[1] = [1,0,3];
					costenergy = 35;
					costmetal = 0;
				break;
				case 204: //Rapier
					nametext = "Rapier";
					desctext = "Interceptor. Destroys fighters.";
					itemclass = 6;
					highai = 1;
					armormax = 5;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 5;
					speedmax = 8;
					turn = .09;
					thrust = 1.3;
					sheetW = 6;
					sheetH = 6;
					wide = 8;
					high = 7;
					picid = 4;
					lights = 1;
					guns[0] = new Array(3);guns[0][0] = 4;guns[0][1] = 0;guns[0][2] = 15;
					ammos[0] = [100,0,3];
					costenergy = 50;
					costmetal = 35;
				break;
				case 205: //Cutlass
					nametext = "Cutlass";
					desctext = "Fighter designed for close combat.";
					itemclass = 6;
					highai = 1;
					aistandoff = 0;
					armormax = 20;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 5;
					speedmax = 9;
					turn = .1;
					thrust = 2;
					sheetW = 6;
					sheetH = 6;
					wide = 8;
					high = 7;
					picid = 5;
					lights = 1;
					guns[0] = new Array(3);guns[0][0] = 5;guns[0][1] = -.08;guns[0][2] = 13;
					guns[1] = new Array(3);guns[1][0] = 5;guns[1][1] = .08;guns[1][2] = 13;
					ammos[0] = [103,0,3];
					ammos[1] = [103,0,3];
					costenergy = 50;
					costmetal = 50;
				break;
				case 206: //Sapphire
					nametext = "Sapphire";
					desctext = "Heavily armed fighter.";
					itemclass = 6;
					highai = 1;
					aistandoff = 120;
					armormax = 25;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 5;
					speedmax = 8;
					turn = .07;
					thrust = 1;
					sheetW = 6;
					sheetH = 6;
					wide = 7;
					high = 6;
					picid = 6;
					lights = 1;
					guns[0] = new Array(3);guns[0][0] = 6;guns[0][1] = -.08;guns[0][2] = 10;
					guns[1] = new Array(3);guns[1][0] = 6;guns[1][1] = .08;guns[1][2] = 10;
					ammos[0] = [3,0,3];
					ammos[1] = [3,0,3];
					costenergy = 150;
					costmetal = 25;
				break;
				case 207: //Hawk
					nametext = "Hawk";
					desctext = "Fighter with long-range missiles.";
					itemclass = 6;
					highai = 1;
					armormax = 12;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 5;
					speedmax = 7;
					turn = .05;
					thrust = .5;
					sheetW = 6;
					sheetH = 6;
					wide = 7;
					high = 6;
					picid = 7;
					lights = 1;
					guns[0] = new Array(3);guns[0][0] = 7;guns[0][1] = -.08;guns[0][2] = 10;
					guns[1] = new Array(3);guns[1][0] = 7;guns[1][1] = .08;guns[1][2] = 10;
					ammos[0] = [9,1,3];
					ammos[1] = [9,1,3];
					costenergy = 90;
					costmetal = 0;
				break;
				case 208: //Fury
					nametext = "Fury";
					desctext = "Flying bomb.";
					itemclass = 6;
					highai = 1;
					armormax = 1;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 5;
					speedmax = 6;
					turn = .03;
					thrust = .3;
					sheetW = 6;
					sheetH = 6;
					wide = 7;
					high = 6;
					picid = 8;
					lights = 1;
					guns[0] = new Array(3);guns[0][0] = 8;guns[0][1] = 0;guns[0][2] = 10;
					ammos[0] = [4,0,6];
					debrisammo = [4,2,6];
					debris = 10;
					costenergy = 50;
					costmetal = 35;
				break;
				case 209: //Miner
					nametext = "Miner";
					desctext = "Mines asteroids.";
					itemclass = 6;
					highai = 1;
					aistandoff = 0;
					armormax = 12;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 5;
					speedmax = 4.5;
					turn = .06;
					thrust = .4;
					sheetW = 6;
					sheetH = 6;
					wide = 8;
					high = 7;
					picid = 9;
					lights = 1;
					guns[0] = new Array(3);guns[0][0] = 9;guns[0][1] = -.09;guns[0][2] = 10;
					guns[1] = new Array(3);guns[1][0] = 9;guns[1][1] = .09;guns[1][2] = 10;
					ammos[0] = [101,0,3];
					ammos[1] = [101,0,3];
					costenergy = 75;
					costmetal = 0;
					miner = true;
				break;
				case 210: //Engineer
					nametext = "Engineer";
					desctext = "Repairs things.";
					itemclass = 6;
					highai = 1;
					aistandoff = 0;
					armormax = 12;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 5;
					speedmax = 4.5;
					turn = .06;
					thrust = .4;
					sheetW = 6;
					sheetH = 6;
					wide = 8;
					high = 7;
					picid = 10;
					lights = 1;
					//guns[0] = new Array(3);guns[0][0] = 10;guns[0][1] = 0;guns[0][2] = 10;
					//ammos[0] = [105,0,3];
					guns[0] = new Array(3);guns[0][0] = 10;guns[0][1] = -.09;guns[0][2] = 10;
					guns[1] = new Array(3);guns[1][0] = 10;guns[1][1] = .09;guns[1][2] = 10;
					ammos[0] = [105,0,5];
					ammos[1] = [105,0,5];
					costenergy = 75;
					costmetal = 0;
					healer = true;
				break;
				case 211: //Mine
					nametext = "Mine";
					desctext = "Boom.";
					itemclass = 6;
					highai = 11;
					aistandoff = 100;
					armormax = 1;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 1;
					speedmax = 15;
					turn = 0;
					thrust = 4;
					sheetW = 4;
					sheetH = 4;
					wide = 6;
					high = 6;
					picid = 11;
					costenergy = 25;
					costmetal = 0;
					saucer = true;
					anim = true;
					animspeed = 1;
					debris = 10;
					debrisammo = [4,2,6];
				break;
				case 212: //Pod
					nametext = "Pod";
					desctext = "Alien pod.";
					itemclass = 6;
					highai = 12;
					armormax = 1;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 2;
					speedmax = 10;
					turn = .07;
					thrust = 1;
					sheetW = 6;
					sheetH = 6;
					wide = 8;
					high = 7;
					aistandoff = 0;
					debris = 20;
					picid = 12;
					costenergy = 25;
					race = 1;
				break;
				case 213: //Hydra
					nametext = "Hydra";
					desctext = "Roar.";
					itemclass = 6;
					highai = 13;
					armormax = 25;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 8;
					speedmax = 7;
					turn = .07;
					thrust = 1;
					sheetW = 6;
					sheetH = 6;
					wide = 8;
					high = 7;
					debris = 20;
					picid = 13;
					costenergy = 75;
					guns[0] = new Array(3);guns[0][0] = 3;guns[0][1] = -.05;guns[0][2] = 15;
					guns[1] = new Array(3);guns[1][0] = 3;guns[1][1] = .05;guns[1][2] = 15;
					ammos[0] = [1,0,1];
					ammos[1] = [1,0,1];
					race = 1;
				break;
				case 214: //Spectre
					nametext = "Spectre";
					desctext = "Transforming fighter fires a hail of blaster.";
					itemclass = 6;
					aistandoff = 150;
					highai = 14;
					armormax = 40;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 9;
					speedmax = 7;
					turn = .03;
					thrust = 2;
					sheetW = 6;
					sheetH = 6;
					wide = 8;
					high = 7;
					picid = 14;
					lights = 1;
					guns[0] = new Array(3);guns[0][0] = 14;guns[0][1] = -.2;guns[0][2] = 15;
					guns[1] = new Array(3);guns[1][0] = 14;guns[1][1] = .2;guns[1][2] = 15;
					guns[2] = new Array(3);guns[2][0] = 14.1;guns[2][1] = 0;guns[2][2] = 10;
					ammos[0] = [0,1,3];
					ammos[1] = [0,1,3];
					ammos[2] = [0,2,3];
					costenergy = 50;
					costmetal = 100;
					transformid = 48;
				break;
				case 215: //Gladiator
					nametext = "Gladiator";
					desctext = "Heavy interceptor with beams and mounted phalanx.";
					itemclass = 6;
					highai = 1;
					armormax = 20;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 9;
					speedmax = 6;
					turn = .07;
					thrust = 1.3;
					sheetW = 6;
					sheetH = 6;
					wide = 9;
					high = 8;
					picid = 15;
					guns[0] = new Array(3);guns[0][0] = 15;guns[0][1] = 0;guns[0][2] = 15;
					ammos[0] = [100,0,3];
					turrets.push([13,0,-1]);
					costenergy = 150;
					costmetal = 50;
				break;
				case 249: //Bot Saucer
					nametext = "Bot Saucer";
					desctext = "Bot Fighter.";
					itemclass = 6;
					highai = 10;
					armormax = 3;
					shieldmax = 15;
					armorregen = 0;
					shieldregen = .5;
					mass = 8;
					speedmax = 8;
					thrust = 1;
					sheetW = 6;
					sheetH = 6;
					wide = 8;
					high = 7;
					picid = 49;
					costenergy = 100;
					saucer = true;
					anim = true;
					animspeed = 1;
					turrets.push([48,0,-5]);
					race = 2;
				break;
				//MEDIUM
				case 250: //Puma
					nametext = "Puma";
					desctext = "Basic Frigate.";
					itemclass = 7;
					highai = 1;
					armormax = 150;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 15;
					speedmax = 7;
					turn = .02;
					thrust = 1;
					sheetW = 6;
					sheetH = 6;
					wide = 12;
					high = 8;
					picid = 50;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 50;guns[0][1] = -.05;guns[0][2] = 20;
					guns[1] = new Array(3);guns[1][0] = 50;guns[1][1] = .05;guns[1][2] = 20;
					guns[2] = new Array(3);guns[2][0] = 50.1;guns[2][1] = -.1;guns[2][2] = 15;
					guns[3] = new Array(3);guns[3][0] = 50.1;guns[3][1] = .1;guns[3][2] = 15;
					ammos[0] = [0,1,3];
					ammos[1] = [0,1,3];
					ammos[2] = [6,2,3];
					ammos[3] = [6,2,3];
					costenergy = 100;
				break;
				case 251: //Athena
					nametext = "Athena";
					desctext = "Bomber. Attacks Structures.";
					itemclass = 7;
					highai = 1;
					armormax = 150;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 15;
					speedmax = 4;
					turn = .02;
					thrust = .3;
					sheetW = 6;
					sheetH = 6;
					wide = 14;
					high = 11;
					picid = 51;
					lights = 50;
					tships = false;
					tstructs = true;
					guns[0] = new Array(3);guns[0][0] = 51;guns[0][1] = -.05;guns[0][2] = 20;
					guns[1] = new Array(3);guns[1][0] = 51;guns[1][1] = .05;guns[1][2] = 20;
					guns[2] = new Array(3);guns[2][0] = 51;guns[2][1] = -.13;guns[2][2] = 22;
					guns[3] = new Array(3);guns[3][0] = 51;guns[3][1] = .13;guns[3][2] = 22;
					ammos[0] = [5,2,6];
					ammos[1] = [5,2,6];
					ammos[2] = [5,2,6];
					ammos[3] = [5,2,6];
					costenergy = 150;
					costmetal = 0;
				break;
				case 252: //Odyssey
					nametext = "Odyssey";
					desctext = "Light Escort Carrier.";
					itemclass = 7;
					highai = 1;
					armormax = 125;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 15;
					speedmax = 5;
					turn = .03;
					thrust = .4;
					sheetW = 6;
					sheetH = 6;
					wide = 14;
					high = 11;
					picid = 52;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 52;guns[0][1] = -.08;guns[0][2] = 18;
					guns[1] = new Array(3);guns[1][0] = 52;guns[1][1] = .08;guns[1][2] = 18;
					ammos[0] = [0,1,3];
					ammos[1] = [0,1,3];
					hangars.push([52,0,18]);
					hangarships.push([200,0,0,0]);
					costenergy = 125;
					costmetal = 0;
				break;
				case 253: //Myrmidon
					nametext = "Myrmidon";
					desctext = "Heavy Cruiser.";
					itemclass = 7;
					highai = 1;
					armormax = 300;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 40;
					speedmax = 4;
					turn = .035;
					thrust = .4;
					sheetW = 6;
					sheetH = 6;
					wide = 18;
					high = 15;
					picid = 53;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 53;guns[0][1] = 0;guns[0][2] = 23;
					guns[1] = new Array(3);guns[1][0] = 53.1;guns[1][1] = -.1;guns[1][2] = 18;
					guns[2] = new Array(3);guns[2][0] = 53.1;guns[2][1] = .1;guns[2][2] = 18;
					ammos[0] = [4,2,6];
					ammos[1] = [1,1,3];
					ammos[2] = [1,1,3];
					costenergy = 150;
					costmetal = 100;
				break;
				case 254: //Grendel
					nametext = "Grendel";
					desctext = "Cruiser with mounted Phalanx turret.";
					itemclass = 7;
					highai = 1;
					armormax = 175;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 35;
					speedmax = 3.5;
					turn = .035;
					thrust = .5;
					sheetW = 6;
					sheetH = 6;
					wide = 18;
					high = 15;
					picid = 54;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 54;guns[0][1] = -.05;guns[0][2] = 20;
					guns[1] = new Array(3);guns[1][0] = 54;guns[1][1] = .05;guns[1][2] = 20;
					guns[2] = new Array(3);guns[2][0] = 54.1;guns[2][1] = -.1;guns[2][2] = 15;
					guns[3] = new Array(3);guns[3][0] = 54.1;guns[3][1] = .1;guns[3][2] = 15;
					ammos[0] = [1,1,6];
					ammos[1] = [1,1,6];
					ammos[2] = [6,1,3];
					ammos[3] = [6,1,3];
					turrets.push([13,0,-4]);
					costenergy = 175;
					costmetal = 75;
				break;
				case 255: //Minotaur
					nametext = "Minotaur";
					desctext = "Missile Cruiser.";
					itemclass = 7;
					highai = 1;
					armormax = 200;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 35;
					speedmax = 3.25;
					turn = .03;
					thrust = .5;
					sheetW = 6;
					sheetH = 6;
					wide = 16;
					high = 13;
					picid = 55;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 55;guns[0][1] = 0;guns[0][2] = 28;
					ammos[0] = [6,4,3];
					costenergy = 75;
					costmetal = 150;
				break;
				case 256: //Corvette
					nametext = "Corvette";
					desctext = "Warship and carrier.";
					itemclass = 7;
					highai = 1;
					armormax = 150;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 38;
					speedmax = 5;
					turn = .04;
					thrust = .3;
					sheetW = 6;
					sheetH = 6;
					wide = 14;
					high = 11;
					picid = 56;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 56;guns[0][1] = 0;guns[0][2] = 22;
					ammos[0] = [3,1,3];
					hangars.push([109,-.25,12]);
					hangars.push([110,.25,12]);
					hangarships.push([200,0,0,0]);
					hangarships.push([200,0,0,0]);
					costenergy = 100;
					costmetal = 75;
				break;
				case 257: //Spartan
					nametext = "Spartan";
					desctext = "Sniper Cruiser.";
					itemclass = 7;
					highai = 1;
					armormax = 225;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 35;
					speedmax = 2.5;
					turn = .025;
					thrust = .5;
					sheetW = 6;
					sheetH = 6;
					wide = 16;
					high = 13;
					picid = 57;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 57;guns[0][1] = 0;guns[0][2] = 25;
					ammos[0] = [104,4,6];
					costenergy = 200;
					costmetal = 100;
				break;
				case 258: //Falcon
					nametext = "Falcon";
					desctext = "Frigate armed with lasers and bombs.";
					itemclass = 7;
					highai = 1;
					armormax = 125;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 35;
					speedmax = 6.00;
					turn = .06;
					thrust = .6;
					sheetW = 6;
					sheetH = 6;
					wide = 16;
					high = 13;
					picid = 58;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 58;guns[0][1] = 0;guns[0][2] = 25;
					guns[1] = new Array(3);guns[1][0] = 58.1;guns[1][1] = -.05;guns[1][2] = 20;
					guns[2] = new Array(3);guns[2][0] = 58.1;guns[2][1] = .05;guns[2][2] = 20;
					ammos[0] = [100,1,3];
					ammos[1] = [5,2,6];
					ammos[2] = [5,2,6];
					costenergy = 100;
					costmetal = 25;
				break;
				case 259: //Scorpion
					nametext = "Scorpion";
					desctext = "Long-range Missile Cruiser.";
					itemclass = 7;
					highai = 1;
					armormax = 400;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 45;
					speedmax = 3.5;
					turn = .03;
					thrust = .3;
					sheetW = 6;
					sheetH = 6;
					wide = 20;
					high = 17;
					picid = 59;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 59;guns[0][1] = .08;guns[0][2] = 20;
					guns[1] = new Array(3);guns[1][0] = 59;guns[1][1] = -.08;guns[1][2] = 20;
					guns[2] = new Array(3);guns[2][0] = 59.1;guns[2][1] = .15;guns[2][2] = 22;
					guns[3] = new Array(3);guns[3][0] = 59.1;guns[3][1] = -.15;guns[3][2] = 22;
					ammos[0] = [9,2,3];
					ammos[1] = [9,2,3];
					ammos[2] = [9,2,3];
					ammos[3] = [9,2,3];
					costenergy = 25;
					costmetal = 225;
				break;
				case 260: //Exhumer
					nametext = "Exhumer";
					desctext = "Mines asteroids.";
					itemclass = 7;
					highai = 1;
					aistandoff = 0;
					armormax = 250;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 40;
					speedmax = 3;
					turn = .03;
					thrust = .2;
					sheetW = 6;
					sheetH = 6;
					wide = 20;
					high = 17;
					picid = 60;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 60;guns[0][1] = 0;guns[0][2] = 23;
					ammos[0] = [101,1,3];
					miner = true;
					costenergy = 75;
					costmetal = 50;
				break;
				case 261: //Tremor
					nametext = "Tremor";
					desctext = "Mine-Layer.";
					itemclass = 7;
					highai = 1;
					armormax = 75;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 13;
					speedmax = 5;
					turn = .03;
					thrust = .3;
					sheetW = 6;
					sheetH = 6;
					wide = 14;
					high = 11;
					picid = 61;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 61;guns[0][1] = 0;guns[0][2] = 20;
					ammos[0] = [0,1,3];
					hangars.push([104,-.25,12]);
					hangars.push([105,.25,12]);
					hangarships.push([211,0,0,0]);
					hangarships.push([211,0,0,0]);
					costenergy = 150;
					costmetal = 0;
				break;
				case 262: //Basilisk
					nametext = "Basilisk";
					desctext = "Roar.";
					itemclass = 7;
					highai = 13;
					armormax = 100;
					shieldmax = 0;
					armorregen = .2;
					shieldregen = 0;
					mass = 35;
					speedmax = 6;
					turn = .06;
					thrust = 1;
					sheetW = 6;
					sheetH = 6;
					wide = 14;
					high = 11;
					debris = 20;
					picid = 62;
					costenergy = 150;
					aistandoff = 5;
					guns[0] = new Array(3);guns[0][0] = 3;guns[0][1] = -.05;guns[0][2] = 19;
					guns[1] = new Array(3);guns[1][0] = 3;guns[1][1] = .05;guns[1][2] = 19;
					ammos[0] = [1,1,1];
					ammos[1] = [1,1,1];
					hangars.push([106,-.25,6]);
					hangars.push([107,.25,6]);
					hangarships.push([212,0,0,0]);
					hangarships.push([212,0,0,0]);
					race = 1;
				break;
				case 263: //Pandemic
					nametext = "Pandemic";
					desctext = "Acid Missile Cruiser. Area of effect.";
					itemclass = 7;
					highai = 1;
					armormax = 75;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 35;
					speedmax = 4;
					turn = .025;
					thrust = .4;
					sheetW = 6;
					sheetH = 6;
					wide = 16;
					high = 13;
					picid = 63;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 63;guns[0][1] = 0;guns[0][2] = 28;
					ammos[0] = [13,4,1];
					turrets.push([0,0,-4]);
					costenergy = 75;
					costmetal = 100;
				break;
				case 264: //Hades
					nametext = "Hades";
					desctext = "Experimental ship that fires small black-holes.";
					itemclass = 7;
					highai = 1;
					armormax = 100;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 35;
					speedmax = 2.25;
					turn = .03;
					thrust = .25;
					sheetW = 6;
					sheetH = 6;
					wide = 16;
					high = 13;
					picid = 64;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 64;guns[0][1] = 0;guns[0][2] = 28;
					ammos[0] = [15,4,19];
					costenergy = 100;
					costmetal = 150;
				break;
				case 265: //Cobra
					nametext = "Cobra";
					desctext = "EMP Artillery Cruiser destroys shields in a large area.";
					itemclass = 7;
					highai = 1;
					armormax = 175;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 35;
					speedmax = 3;
					turn = .025;
					thrust = .25;
					sheetW = 6;
					sheetH = 6;
					wide = 16;
					high = 15;
					picid = 65;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 65;guns[0][1] = 0;guns[0][2] = 25;
					ammos[0] = [17,2,3];
					costenergy = 125;
					costmetal = 125;
				break;
				case 299: //Bot MedSaucer
					nametext = "Bot Medium Saucer";
					desctext = "Bot Medium.";
					itemclass = 7;
					highai = 10;
					armormax = 25;
					shieldmax = 160;
					armorregen = 0;
					shieldregen = .5;
					mass = 35;
					speedmax = 4;
					thrust = 1;
					sheetW = 6;
					sheetH = 6;
					wide = 14;
					high = 11;
					picid = 99;
					costenergy = 125;
					saucer = true;
					anim = true;
					animspeed = 1;
					turrets.push([48,-10,-10]);
					turrets.push([48,10,-10]);
					turrets.push([48,-10,5]);
					turrets.push([48,10,5]);
					race = 2;
				break;
				case 300: //Trident
					nametext = "Trident";
					desctext = "Battleship with lots of guns.";
					itemclass = 8;
					highai = 1;
					armormax = 1200;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 75;
					speedmax = 2.5;
					turn = .01;
					thrust = .3;
					sheetW = 8;
					sheetH = 8;
					wide = 24;
					high = 22;
					picid = 100;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 300;guns[0][1] = -.05;guns[0][2] = 30;
					guns[1] = new Array(3);guns[1][0] = 300;guns[1][1] = .05;guns[1][2] = 30;
					guns[2] = new Array(3);guns[2][0] = 300;guns[2][1] = -.1;guns[2][2] = 25;
					guns[3] = new Array(3);guns[3][0] = 300;guns[3][1] = .1;guns[3][2] = 25;
					ammos[0] = [1,3,3];
					ammos[1] = [1,3,3];
					ammos[2] = [1,2,3];
					ammos[3] = [1,2,3];
					turrets.push([10,0,-7]);
					costenergy = 100;
					costmetal = 100;
				break;
				case 301: //Legion
					nametext = "Legion";
					desctext = "Fleet Carrier.";
					itemclass = 8;
					highai = 1;
					armormax = 1500;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 90;
					speedmax = 2.25;
					turn = .01;
					thrust = .3;
					sheetW = 8;
					sheetH = 8;
					wide = 24;
					high = 22;
					picid = 101;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 301;guns[0][1] = 0;guns[0][2] = 35;
					ammos[0] = [1,3,3];
					turrets.push([2,0,-10]);
					hangars.push([101,-.3,18]);
					hangars.push([102,.3,18]);
					hangars.push([101,-.15,18]);
					hangars.push([102,.15,18]);
					hangarships.push([200,0,0,0]);
					hangarships.push([200,0,0,0]);
					hangarships.push([200,0,0,0]);
					hangarships.push([200,0,0,0]);
					costenergy = 150;
					costmetal = 50;
				break;
				case 302: //Mastodon
					nametext = "Mastodon";
					desctext = "Carrier with mounted Phalanx.";
					itemclass = 8;
					highai = 1;
					armormax = 1000;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 90;
					speedmax = 3.25;
					turn = .02;
					thrust = .5;
					sheetW = 8;
					sheetH = 8;
					wide = 20;
					high = 18;
					picid = 102;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 302;guns[0][1] = -.8;guns[0][2] = 17;
					guns[1] = new Array(3);guns[1][0] = 302;guns[1][1] = .8;guns[1][2] = 17;
					ammos[0] = [6,3,3];
					ammos[1] = [6,3,3];
					turrets.push([13,0,-5]);
					hangars.push([103,-.06,28]);
					hangars.push([103,.06,28]);
					hangarships.push([200,0,0,0]);
					hangarships.push([200,0,0,0]);
					costenergy = 50;
					costmetal = 50;
				break;
				case 303: //Goliath
					nametext = "Goliath";
					desctext = "Dreadnought with powerful beams.";
					itemclass = 8;
					highai = 1;
					armormax = 1500;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 100;
					speedmax = 2.5;
					turn = .01;
					thrust = .2;
					sheetW = 8;
					sheetH = 8;
					wide = 26;
					high = 24;
					picid = 103;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 303;guns[0][1] = -.05;guns[0][2] = 30;
					guns[1] = new Array(3);guns[1][0] = 303;guns[1][1] = .05;guns[1][2] = 30;
					ammos[0] = [104,4,6];
					ammos[1] = [104,4,6];
					turrets.push([10,0,-9]);
					costenergy = 200;
					costmetal = 150;
				break;
				case 304: //Behemoth
					nametext = "Behemoth";
					desctext = "Roar.";
					itemclass = 8;
					highai = 13;
					armormax = 400;
					shieldmax = 0;
					armorregen = .4;
					shieldregen = 0;
					mass = 80;
					speedmax = 4;
					turn = .04;
					thrust = .5;
					sheetW = 8;
					sheetH = 8;
					wide = 26;
					high = 24;
					debris = 20;
					picid = 104;
					costenergy = 150;
					aistandoff = 5;
					guns[0] = new Array(3);guns[0][0] = 3;guns[0][1] = -.05;guns[0][2] = 19;
					guns[1] = new Array(3);guns[1][0] = 3;guns[1][1] = .05;guns[1][2] = 19;
					ammos[0] = [1,3,1];
					ammos[1] = [1,3,1];
					hangars.push([106,-.25,8]);
					hangars.push([107,.25,8]);
					hangarships.push([212,0,0,0]);
					hangarships.push([212,0,0,0]);
					race = 1;
				break;
				case 305: //Abomination
					nametext = "Abomination";
					desctext = "Roar.";
					itemclass = 8;
					highai = 1;
					armormax = 700;
					shieldmax = 0;
					armorregen = .6;
					shieldregen = 0;
					mass = 80;
					speedmax = 2;
					turn = .02;
					thrust = .2;
					sheetW = 8;
					sheetH = 8;
					wide = 28;
					high = 26;
					debris = 20;
					picid = 105;
					costenergy = 350;
					aistandoff = 5;
					guns[0] = new Array(3);guns[0][0] = 3;guns[0][1] = -.05;guns[0][2] = 22;
					guns[1] = new Array(3);guns[1][0] = 3;guns[1][1] = .05;guns[1][2] = 22;
					ammos[0] = [1,4,1];
					ammos[1] = [1,4,1];
					hangars.push([106,-.25,8]);
					hangars.push([107,.25,8]);
					hangarships.push([212,0,0,0]);
					hangarships.push([212,0,0,0]);
					race = 1;
				break;
				case 306: //Hammerhead
					nametext = "Hammerhead";
					desctext = "Battleship with long-range artillery.";
					itemclass = 8;
					highai = 1;
					armormax = 800;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 100;
					speedmax = 3;
					turn = .02;
					thrust = .2;
					sheetW = 8;
					sheetH = 8;
					wide = 26;
					high = 24;
					picid = 106;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 306;guns[0][1] = -.05;guns[0][2] = 30;
					guns[1] = new Array(3);guns[1][0] = 306;guns[1][1] = .05;guns[1][2] = 30;
					ammos[0] = [8,2,6];
					ammos[1] = [8,2,6];
					turrets.push([8,0,-9]);
					costenergy = 50;
					costmetal = 150;
				break;
				case 307: //Cataclysm
					nametext = "Cataclysm";
					desctext = "Battleship full of missiles.";
					itemclass = 8;
					highai = 1;
					armormax = 1600;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 100;
					speedmax = 3.5;
					turn = .02;
					thrust = .15;
					sheetW = 8;
					sheetH = 8;
					wide = 26;
					high = 24;
					picid = 107;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 307;guns[0][1] = -.05;guns[0][2] = 30;
					guns[1] = new Array(3);guns[1][0] = 307;guns[1][1] = .05;guns[1][2] = 30;
					guns[2] = new Array(3);guns[2][0] = 307.1;guns[2][1] = -.025;guns[2][2] = 30;
					guns[3] = new Array(3);guns[3][0] = 307.1;guns[3][1] = .025;guns[3][2] = 30;
					guns[4] = new Array(3);guns[4][0] = 307.2;guns[4][1] = -.075;guns[4][2] = 30;
					guns[5] = new Array(3);guns[5][0] = 307.2;guns[5][1] = .075;guns[5][2] = 30;
					ammos[0] = [6,3,3];
					ammos[1] = [6,3,3];
					ammos[2] = [6,3,3];
					ammos[3] = [6,3,3];
					ammos[4] = [9,4,3];
					ammos[5] = [9,4,3];
					costenergy = 75;
					costmetal = 75;
				break;
				case 308: //Jupiter
					nametext = "Jupiter";
					desctext = "Carrier with heavy plasma weapons.";
					itemclass = 8;
					highai = 1;
					armormax = 2000;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 120;
					speedmax = 2;
					turn = .01;
					thrust = .3;
					sheetW = 8;
					sheetH = 8;
					wide = 24;
					high = 22;
					picid = 108;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 308;guns[0][1] = -.25;guns[0][2] = 25;
					guns[1] = new Array(3);guns[1][0] = 308;guns[1][1] = .25;guns[1][2] = 25;
					guns[2] = new Array(3);guns[2][0] = 308;guns[2][1] = -.15;guns[2][2] = 25;
					guns[3] = new Array(3);guns[3][0] = 308;guns[3][1] = .15;guns[3][2] = 25;
					ammos[0] = [4,2,6];
					ammos[1] = [4,2,6];
					ammos[2] = [4,2,6];
					ammos[3] = [4,2,6];
					turrets.push([8,0,-8]);
					hangars.push([108,-.06,32]);
					hangars.push([108,.06,32]);
					hangars.push([108,0,32]);
					hangarships.push([200,0,0,0]);
					hangarships.push([200,0,0,0]);
					hangarships.push([200,0,0,0]);
					costenergy = 125;
					costmetal = 125;
				break;
				case 309: //Bot MegaSaucer
					nametext = "Bot Mega Saucer";
					desctext = "Bot Mega.";
					itemclass = 7;
					highai = 10;
					armormax = 300;
					shieldmax = 2000;
					armorregen = 0;
					shieldregen = .5;
					mass = 80;
					speedmax = 4;
					thrust = 1;
					sheetW = 8;
					sheetH = 8;
					wide = 24;
					high = 22;
					picid = 109;
					costenergy = 75;
					saucer = true;
					anim = true;
					animspeed = 1;
					
					temp = 15;
					i = -2;
					turrets.push([48,-temp * 1.5 * Math.cos(0), temp * Math.sin(0) + i]);
					turrets.push([48,-temp * 1.5 * Math.cos(3.14/2), temp * Math.sin(3.14/2) + i]);
					turrets.push([48,-temp * 1.5 * Math.cos(3.14), temp * Math.sin(3.14) + i]);
					turrets.push([48,-temp * 1.5 * Math.cos(3.14*1.5), temp * Math.sin(3.14*1.5) + i]);
					
					turrets.push([48,-temp * 1.5 * Math.cos(3.14/4), temp * Math.sin(3.14/4) + i]);
					turrets.push([48,-temp * 1.5 * Math.cos(3.14*3/4), temp * Math.sin(3.14*3/4) + i]);
					turrets.push([48,-temp * 1.5 * Math.cos(3.14*1.25), temp * Math.sin(3.14*1.25) + i]);
					turrets.push([48,-temp * 1.5 * Math.cos(3.14*1.75), temp * Math.sin(3.14*1.75) + i]);
					race = 2;
				break;
				case 310: //Ragnarok
					nametext = "Ragnarok";
					desctext = "Armed with nuclear missiles.";
					itemclass = 8;
					highai = 1;
					armormax = 2500;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 100;
					speedmax = 5;
					turn = .02;
					thrust = .75;
					sheetW = 8;
					sheetH = 8;
					wide = 28;
					high = 26;
					picid = 110;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 310;guns[0][1] = -.15;guns[0][2] = 20;
					guns[1] = new Array(3);guns[1][0] = 310;guns[1][1] = .15;guns[1][2] = 20;
					ammos[0] = [12,4,10];
					ammos[1] = [12,4,10];
					//turrets.push([10,0,-9]);
					costenergy = 500;
					costmetal = 300;
				break;
				case 311: //Biohazard
					nametext = "Biohazard";
					desctext = "Battleship with acid missiles and alien spores.";
					itemclass = 8;
					highai = 1;
					armormax = 1500;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 100;
					speedmax = 3;
					turn = .02;
					thrust = .5;
					sheetW = 8;
					sheetH = 8;
					wide = 28;
					high = 26;
					picid = 111;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 311;guns[0][1] = 0;guns[0][2] = 20;
					ammos[0] = [13,4,1];
					hangars.push([111,-.3,18]);
					hangars.push([112,.3,18]);
					hangarships.push([212,0,0,0]);
					hangarships.push([212,0,0,0]);
					costenergy = 200;
					costmetal = 250;
				break;
				case 312: //Archangel
					nametext = "Archangel";
					desctext = "Carrier with tactical shield, black-hole weapons, and blasters.";
					itemclass = 8;
					highai = 1;
					armormax = 1500;
					shieldmax = 0;
					armorregen = 0;
					tacshieldmax = 200;
					tacshieldregen = 5;
					tacshieldr = 100;
					mass = 100;
					speedmax = 3;
					turn = .02;
					thrust = .25;
					sheetW = 8;
					sheetH = 8;
					wide = 28;
					high = 26;
					picid = 112;
					lights = 150;
					guns[0] = new Array(3);guns[0][0] = 312.1;guns[0][1] = -.05;guns[0][2] = 30;
					guns[1] = new Array(3);guns[1][0] = 312.1;guns[1][1] = .05;guns[1][2] = 30;
					guns[2] = new Array(3);guns[2][0] = 312;guns[2][1] = -.05;guns[2][2] = 30;
					guns[3] = new Array(3);guns[3][0] = 312;guns[3][1] = .05;guns[3][2] = 30;
					ammos[0] = [0,3,3];
					ammos[1] = [0,3,3];
					ammos[2] = [15,4,19];
					ammos[3] = [15,4,19];
					hangars.push([113,-.25,20]);
					hangars.push([114,.25,20]);
					hangarships.push([200,0,0,0]);
					hangarships.push([200,0,0,0]);
					costenergy = 300;
					costmetal = 125;
				break;
				case 313: //Beam-Halo
					nametext = "Beam-Halo";
					desctext = "Ring with mounted lasercannons.";
					itemclass = 8;
					highai = 10;
					armormax = 1000;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 60;
					speedmax = 2;
					thrust = .15;
					sheetW = 4;
					sheetH = 3;
					wide = 38;
					high = 28;
					picid = 113;
					costenergy = 300;
					costmetal = 100;
					saucer = true;
					anim = true;
					animspeed = 2;
					
					temp = 28;
					i = -4;
					turrets.push([11,-temp * 1.5 * Math.cos(3.14/2), temp * Math.sin(3.14/2) + i]);
					turrets.push([11,-temp * 1.5 * Math.cos(3.14/4), temp * Math.sin(3.14/4) + i]);
					turrets.push([11,-temp * 1.5 * Math.cos(3.14*3/4), temp * Math.sin(3.14*3/4) + i]);
					turrets.push([11,-temp * 1.5 * Math.cos(0), temp * Math.sin(0) + i]);
					turrets.push([11,-temp * 1.5 * Math.cos(3.14), temp * Math.sin(3.14) + i]);
					turrets.push([11,-temp * 1.5 * Math.cos(3.14*1.25), temp * Math.sin(3.14*1.25) + i]);
					turrets.push([11,-temp * 1.5 * Math.cos(3.14*1.5), temp * Math.sin(3.14*1.5) + i]);
					turrets.push([11,-temp * 1.5 * Math.cos(3.14*1.75), temp * Math.sin(3.14*1.75) + i]);
				break;
				case 314: //Plasma-Halo
					nametext = "Plasma-Halo";
					desctext = "Ring with mounted plasmacasters.";
					itemclass = 8;
					highai = 10;
					armormax = 1000;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 60;
					speedmax = 4;
					thrust = .15;
					sheetW = 4;
					sheetH = 3;
					wide = 38;
					high = 28;
					picid = 113;
					costenergy = 100;
					costmetal = 250;
					saucer = true;
					anim = true;
					animspeed = 2;
					
					temp = 28;
					i = -4;
					turrets.push([9,-temp * 1.5 * Math.cos(3.14/2), temp * Math.sin(3.14/2) + i]);
					turrets.push([9,-temp * 1.5 * Math.cos(3.14/4), temp * Math.sin(3.14/4) + i]);
					turrets.push([9,-temp * 1.5 * Math.cos(3.14*3/4), temp * Math.sin(3.14*3/4) + i]);
					turrets.push([9,-temp * 1.5 * Math.cos(0), temp * Math.sin(0) + i]);
					turrets.push([9,-temp * 1.5 * Math.cos(3.14), temp * Math.sin(3.14) + i]);
					turrets.push([9,-temp * 1.5 * Math.cos(3.14*1.25), temp * Math.sin(3.14*1.25) + i]);
					turrets.push([9,-temp * 1.5 * Math.cos(3.14*1.5), temp * Math.sin(3.14*1.5) + i]);
					turrets.push([9,-temp * 1.5 * Math.cos(3.14*1.75), temp * Math.sin(3.14*1.75) + i]);
				break;
				case 315: //Artillery-Halo
					nametext = "Artillery-Halo";
					desctext = "Ring with mounted mjolnirs.";
					itemclass = 8;
					highai = 10;
					armormax = 1000;
					shieldmax = 0;
					armorregen = 0;
					shieldregen = 0;
					mass = 60;
					speedmax = 2;
					thrust = .15;
					sheetW = 4;
					sheetH = 3;
					wide = 38;
					high = 28;
					picid = 113;
					costenergy = 300;
					costmetal = 300;
					saucer = true;
					anim = true;
					animspeed = 2;
					tships = false;
					tstructs = true;
					turrets.push([50,24, -24]);
					turrets.push([50,24, 24]);
					turrets.push([50,-24, 24]);
					turrets.push([50,-24, -24]);
				break;
				case 316: //Tyrant
					nametext = "Tyrant";
					desctext = "Capital mine-warfare ship with freeze missiles and phalanx.";
					itemclass = 8;
					highai = 1;
					armormax = 1500;
					shieldmax = 0;
					armorregen = 0;
					mass = 100;
					speedmax = 3;
					turn = .02;
					thrust = .25;
					sheetW = 8;
					sheetH = 8;
					wide = 28;
					high = 26;
					picid = 116;
					lights = 50;
					guns[0] = new Array(3);guns[0][0] = 316.1;guns[0][1] = 0;guns[0][2] = 30;
					guns[1] = new Array(3);guns[1][0] = 316;guns[1][1] = -.05;guns[1][2] = 30;
					guns[2] = new Array(3);guns[2][0] = 316;guns[2][1] = .05;guns[2][2] = 30;
					ammos[0] = [14,4,19];
					ammos[1] = [0,3,3];
					ammos[2] = [0,3,3];
					hangars.push([115,-.15,10]);
					hangars.push([115,.15,10]);
					hangarships.push([211,0,0,0]);
					hangarships.push([211,0,0,0]);
					turrets.push([13,0,-6]);
					costenergy = 150;
					costmetal = 150;
				break;
				/*case 0:
					highai = 3;
					armormax = 10;
					shieldmax = 10;
					armorregen = 0;
					shieldregen = 0;
					mass = 5;
					speedmax = 3;
					turn = .015;
					thrust = .25;
					sheetW = 6;
					sheetH = 6;
					wide = 7;
					high = 6;
					picid = 0;
					lights = 1;
				break;*/
			}
			
			if(mass < 10 && tech == 0){
				if(debris == -1){
					debris = 0;
				}
				tech = 1;
			}
			if(mass >= 10 && mass < 50 && tech == 0){
				if(debris == -1){
					debris = 1;
				}
				tech = 2;
			}
			if(mass > 50 && tech == 0){
				if(debris == -1){
					debris = 2;
				}
				tech = 3;
			}
			
			DoMods();
			for(i = 0; i < turrets.length; i++){
				while(turrets[i].length < 6){
					turrets[i].push(-1);
				}
			}
		}
		
		public function DoMods()
		{
			var i:int;
			var j:int;
			var k:int;
			rarity = 0;
			for(i = 1; i < 4; i++){
				if(s[i] > 0){
					rarity++;
				}
				switch(s[i]){
					case 0:
						//NOTHING
					break;
					case 1: //Booster A;
						burnmod = 1;
						turn = turn * 1.2;
						speedmax = speedmax * 1.2;
						thrust = thrust * 1.2;
						modtxt.push("Engine A");
					break;
					case 2: //Booster B;
						burnmod = 2;
						turn = turn * 1.3;
						speedmax = speedmax * 1.3;
						thrust = thrust * 1.3;
						modtxt.push("Engine B");
					break;
					case 3: //Booster C;
						burnmod = 3;
						turn = turn * 1.4;
						speedmax = speedmax * 1.4;
						thrust = thrust * 1.4;
						modtxt.push("Engine C");
					break;
					case 4: //Booster D;
						burnmod = 4;
						turn = turn * 1.5;
						speedmax = speedmax * 1.5;
						thrust = thrust * 1.5;
						modtxt.push("Engine D");
					break;
					case 5: //Booster E;
						burnmod = 5;
						turn = turn * 1.6;
						speedmax = speedmax * 1.6;
						thrust = thrust * 1.6;
						modtxt.push("Engine E");
					break;
					case 6: //Shield A
						shieldmax = Math.ceil(.3 * armormax);
						shieldregen = .2;
						modtxt.push("Shield A");
					break;
					case 7: //Shield B
						shieldmax = Math.ceil(.275 * armormax);
						shieldregen = .25;
						modtxt.push("Shield B");
					break;
					case 8: //Shield C
						shieldmax = Math.ceil(.25 * armormax);
						shieldregen = .3;
						modtxt.push("Shield C");
					break;
					case 9: //Shield D
						shieldmax = Math.ceil(.225 * armormax);
						shieldregen = .35;
						modtxt.push("Shield D");
					break;
					case 10: //Shield E
						shieldmax = Math.ceil(.2 * armormax);
						shieldregen = .4;
						modtxt.push("Shield E");
					break;
					case 11: //Cyan
						for(j = 0; j < ammos.length; j++){
							if(ammos[j][0] < 100){
								ammos[j][2] = 0;
							}
						}
						for(k = 0; k < turrets.length; k++){
							turrets[k].push(s[i])
						}
						debrisammo[2] = 0;
						modtxt.push("EMP Rounds");
					break;
					case 12: //YGreen
						for(j = 0; j < ammos.length; j++){
							if(ammos[j][0] < 100){
								ammos[j][2] = 1;
							}
						}
						for(k = 0; k < turrets.length; k++){
							turrets[k].push(s[i])
						}
						debrisammo[2] = 1;
						modtxt.push("Acid Rounds");
					break;
					case 13: //White
						for(j = 0; j < ammos.length; j++){
							if(ammos[j][0] < 100){
								ammos[j][2] = 9;
							}
						}
						for(k = 0; k < turrets.length; k++){
							turrets[k].push(s[i])
						}
						debrisammo[2] = 9;
						modtxt.push("Force Rounds");
					break;
					case 14: //Violet
						for(j = 0; j < ammos.length; j++){
							if(ammos[j][0] < 100){
								ammos[j][2] = 4;
							}
						}
						for(k = 0; k < turrets.length; k++){
							turrets[k].push(s[i])
						}
						debrisammo[2] = 4;
						modtxt.push("Neutron Rounds");
					break;
					case 15: //NeonGreen
						for(j = 0; j < ammos.length; j++){
							if(ammos[j][0] < 100){
								ammos[j][2] = 5;
							}
						}
						for(k = 0; k < turrets.length; k++){
							turrets[k].push(s[i])
						}
						debrisammo[2] = 5;
						modtxt.push("Iridium Rounds");
					break;
					case 16: //Yellow
						for(j = 0; j < ammos.length; j++){
							if(ammos[j][0] < 100){
								ammos[j][2] = 7;
							}
						}
						for(k = 0; k < turrets.length; k++){
							turrets[k].push(s[i])
						}
						debrisammo[2] = 7;
						modtxt.push("Thermal Rounds");
					break;
					case 17: //Blue
						for(j = 0; j < ammos.length; j++){
							if(ammos[j][0] < 100){
								ammos[j][2] = 8;
							}
						}
						for(k = 0; k < turrets.length; k++){
							turrets[k].push(s[i])
						}
						debrisammo[2] = 8;
						modtxt.push("Freeze Rounds");
					break;
					case 18: //Fusion
						for(j = 0; j < ammos.length; j++){
							if(ammos[j][0] < 100){
								ammos[j][2] = 10;
							}
						}
						for(k = 0; k < turrets.length; k++){
							turrets[k].push(s[i])
						}
						debrisammo[2] = 10;
						modtxt.push("Fusion Rounds");
					break;
					case 21: //Hangar Mosquito
						for(j = 0; j < hangarships.length; j++){
							hangarships[j][0] = 202;
						}
						modtxt.push("Mosquito Hangar");
					break;
					case 22: //Hangar Mantis
						for(j = 0; j < hangarships.length; j++){
							hangarships[j][0] = 203;
						}
						modtxt.push("Mantis Hangar");
					break;
					case 23: //Hangar Rapier
						for(j = 0; j < hangarships.length; j++){
							hangarships[j][0] = 204;
						}
						modtxt.push("Rapier Hangar");
					break;
					case 24: //Hangar Cutlass
						for(j = 0; j < hangarships.length; j++){
							hangarships[j][0] = 205;
						}
						modtxt.push("Cutlass Hangar");
					break;
					case 25: //Hangar Sapphire
						for(j = 0; j < hangarships.length; j++){
							hangarships[j][0] = 206;
						}
						modtxt.push("Sapphire Hangar");
					break;
					case 26: //Hangar Hawk
						for(j = 0; j < hangarships.length; j++){
							hangarships[j][0] = 207;
						}
						modtxt.push("Hawk Hangar");
					break;
					case 27: //Hangar Fury
						for(j = 0; j < hangarships.length; j++){
							hangarships[j][0] = 208;
						}
						modtxt.push("Fury Hangar");
					break;
					case 28: //Hangar Miner
						for(j = 0; j < hangarships.length; j++){
							hangarships[j][0] = 209;
						}
						modtxt.push("Miner Hangar");
					break;
					case 37: //Extra Ship
						hangarnummod = 1;
						modtxt.push("Launches Extra Ships");
					break;
					case 38: //25% Launch Rate Boost
						hangarlaunchheatmod = .85;
						modtxt.push("+25% Hangar Rate");
					break;
					case 39: //25% Launch Power Boost
						hangarlaunchheatmod = .85;
						modtxt.push("+25% Hangar Rate");
					break;
					case 40: //15% Armor Boost
						armormax = Math.round(armormax * 1.15);
						modtxt.push("+15% Armor");
					break;
					case 41: //Armor Regen
						armorregen = armorregen + .6;
						modtxt.push("+6 Armor Regen");
					break;
					case 42: //Gun Cool A
						gunheatmod = gunheatmod * .8;
						modtxt.push("+20% Fire-Rate");
					break;
					case 43: //Gun Range
						gunrangemod = gunrangemod * 1.20;
						modtxt.push("+20% Range");
					break;
					case 44: //15% Armor Boost
						armormax = Math.round(armormax * 1.15);
						modtxt.push("+15% Armor");
					break;
					case 45: //Armor Regen
						armorregen = armorregen + .6;
						modtxt.push("+6 Armor Regen");
					break;
					case 46: //Gun Cool B
						gunheatmod = gunheatmod * .8;
						modtxt.push("+20% Fire-Rate");
					break;
					case 47: //Gun Range
						gunrangemod = gunrangemod * 1.20;
						modtxt.push("+20% Range");
					break;
					case 48: //Plasma Destruct
						if(debris != 10){
							if(debrisammo[0] == -1){
								debrisammo[0] = 4;
							}
							if(debrisammo[1] == -1){
								debrisammo[1] = 2;
								if(mass < 10)
								{
									debrisammo[1] = 1;
								}
							}
							if(debrisammo[2] == -1){
								debrisammo[2] = 6;
							}
							debris = 10;
							modtxt.push("Self-Destruct");
						}else{
							debrisammo[1] = debrisammo[1] + 1;
							modtxt.push("Improved Self-Destruct");
						}
					break;
					case 49: //Gun Cool C
						gunheatmod = gunheatmod * .8;
						modtxt.push("+20% Fire-Rate");
					break;
					case 60: //Piranha Bay
						if(mass >= 10 && mass < 50){
							hangars.push([30,0,15]);
							hangarships.push([200,0,0,0]);
							modtxt.push("Piranha Bay");
						}
						if(mass >= 50){
							hangars.push([31,0,15]);
							hangarships.push([200,0,0,0]);
							modtxt.push("Piranha Hangar");
						}
					break;
					case 80: //Cloak
						cloakmod = 1;
						modtxt.push("Cloak Module");
						if(s[0] == 212){
							cloakmod = 0;
						}
					break;
				}
			}
			for(i = 0; i < hangarships.length; i++){
				for(j = 1; j < 4; j++){
					hangarships[i][j] = s[j];
				}
			}
		}
	}
}