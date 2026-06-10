package
{
	public class StructData
	{
		public var s:Array = new Array(4);
		public var modtxt:Array = new Array();
		public var nametext:String = "";
		public var desctext:String = "";
		public var iconid:int;
		public var rarity:int = 0;
		public var itemclass:int = 0;//Station,Factory,Energy,Mining,Turret,Aux,Fighters,Medium,Capital,Research
		
		public var wide:int = 10;
		public var high:int = 8;
		public var mass:int = 1; 
		public var costenergy:int = 0;
		public var costmetal:int = 0;
		public var energy:Number = 0;
		public var metal:Number = 0;
		public var tech:int = 0;
		public var rock:Boolean = false;
		public var turretrange:int = 0;
		public var debris:int = 0;
		public var damage:Boolean = false;
		
		public var base:Boolean = false;
		public var miner:Boolean = false;
		public var buildwide:int = 1;
		public var buildhigh:int = 1;
		public var armormax:Number = 0;
		public var shieldmax:Number = 0;
		public var armorregen:Number = 0;
		public var shieldregen:Number = 0;
		public var tacshieldregen:Number = 0;
		public var tacshieldmax:Number = 0;
		public var tacshieldr:int = 0;
		
		public var sheetW:int = 1;
		public var sheetH:int = 1;
		public var anim:Boolean = false;
		public var animspeed:Number = 0;
		public var picid:int = 0;
		public var lights:int = 0;
		
		public var hangarlaunchheatmod:Number = 1;
		public var gunheatmod:Number = 1;
		public var missileheatmod:Number = 1;
		public var beamheatmod:Number = 1;
		public var gunrangemod:Number = 1;
		public var plasheatmod:Number = 1;
		public var darkheatmod:Number = 1;
		public var freezeboost:int = 0;
		public var acidboost:int = 0;
		public var specialrounds:int = -1;
		public var plasmod:int = 0;
		public var darkmod:int = 0;
		public var blastermod:int = 0;
		public var insurancemod:Number = 0;
		public var cloakmod:int = 0;
		public var cloakfieldr:int = 0;
		
		public var hangars:Array = new Array();
		public var turrets:Array = new Array();
		public var debrisammo:Array = new Array(3);
		
		public var buildsound:int = 0;
		
		public function StructData(ss)
		{
			var g;
			var t;
			var i:int;
			var j:int;
			
			s[0] = ss[0];
			for(i = 0; i < s.length; i++){
				s[i] = 0;
			}
			for(i = 0; i < ss.length; i++){
				s[i] = ss[i];
			}
			iconid = s[0];
			turretrange = 0;
			debrisammo = [-1,-1,-1];
			switch(s[0])
			{
				case 0: //Station
					nametext = "Station";
					desctext = "Main base.";
					itemclass = 0;
					wide = 27;
					high = 24;
					buildwide = 2;
					buildhigh = 2;
					sheetW = 6;
					sheetH = 6;
					picid = 0;
					base = true;
					anim = true;
					animspeed = 3;
					energy = .8;
					buildsound = 6;
					mass = 100;
					armormax = 1000;
				break;
				case 1: //Queen
					nametext = "Queen";
					desctext = "Roar.";
					itemclass = 0;
					wide = 27;
					high = 24;
					buildwide = 2;
					buildhigh = 2;
					sheetW = 5;
					sheetH = 4;
					picid = 1;
					base = true;
					anim = true;
					animspeed = -3;
					energy = .8;
					debris = 20;
					mass = 100;
					armormax = 1000;
				break;
				case 2: //BotBase
					nametext = "Bot Base";
					desctext = "Main base.";
					itemclass = 0;
					wide = 27;
					high = 24;
					buildwide = 2;
					buildhigh = 2;
					sheetW = 5;
					sheetH = 2;
					picid = 2;
					base = true;
					anim = true;
					animspeed = 1;
					energy = .8;
					
					mass = 100;
					armormax = 500;
					shieldmax = 500;
					shieldregen = .7;
					tacshieldmax = 500;
					tacshieldr = 150;
				break;
				case 5: //Reactor
					nametext = "Reactor";
					desctext = "Generates Energy.";
					itemclass = 2;
					wide = 10;
					high = 8;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 10;
					sheetH = 1;
					picid = 5;
					anim = true;
					energy = .3;
					costenergy = 150;
					animspeed = 1;
					buildsound = 5;
					mass = 30;
					armormax = 150;
				break;
				case 6: //Powersac
					nametext = "Powersac";
					desctext = "Roar.";
					itemclass = 2;
					wide = 10;
					high = 8;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 5;
					sheetH = 4;
					picid = 6;
					anim = true;
					energy = .3;
					costenergy = 150;
					animspeed = -2;
					debris = 20;
					mass = 30;
					armormax = 150;
				break;
				case 7: //Bot Generator
					nametext = "Bot Generator";
					desctext = "Generates Energy.";
					itemclass = 2;
					wide = 10;
					high = 8;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 5;
					sheetH = 2;
					picid = 7;
					anim = true;
					energy = .3;
					costenergy = 150;
					animspeed = 1;
					
					mass = 30;
					armormax = 25;
					shieldmax = 75;
					shieldregen = .5;
				break;
				case 10: //FighterBay
					nametext = "Fighter Bay";
					desctext = "Constructs Fighters.";
					itemclass = 1;
					wide = 10;
					high = 8;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 6;
					sheetH = 6;
					picid = 10;
					lights = 2;
					anim = true;
					animspeed = -4;
					hangars.push([1,0,0]);
					costenergy = 35;
					buildsound = 6;
					mass = 30;
					armormax = 150;
					tech = 1;
				break;
				case 11: //Eggsac
					nametext = "Eggsac";
					desctext = "Roar.";
					itemclass = 1;
					wide = 10;
					high = 8;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 5;
					sheetH = 4;
					picid = 11;
					anim = true;
					animspeed = -4;
					hangars.push([1,0,0]);
					costenergy = 35;
					debris = 20;
					mass = 30;
					armormax = 100;
					tech = 1;
				break;
				case 12: //BotBay
					nametext = "Bot Bay";
					desctext = "Constructs Fighters.";
					itemclass = 1;
					wide = 10;
					high = 8;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 5;
					sheetH = 2;
					picid = 12;
					anim = true;
					animspeed = 1;
					hangars.push([5,0,0]);
					costenergy = 50;
					
					mass = 30;
					armormax = 25;
					shieldmax = 100;
					shieldregen = .5;
					tech = 1;
				break;
				case 15: //Stardock
					nametext = "Stardock";
					desctext = "Constructs Medium Ships.";
					itemclass = 1;
					wide = 27;
					high = 24;
					buildwide = 2;
					buildhigh = 2;
					sheetW = 6;
					sheetH = 6;
					picid = 15;
					anim = true;
					animspeed = -3;
					hangars.push([2,0,0]);
					costenergy = 200;
					costmetal = 100;
					buildsound = 6;
					mass = 100;
					armormax = 400;
					tech = 2;
				break;
				case 16: //Spawner
					nametext = "Spawner";
					desctext = "Roar.";
					itemclass = 1;
					wide = 27;
					high = 24;
					buildwide = 2;
					buildhigh = 2;
					sheetW = 5;
					sheetH = 4;
					picid = 16;
					anim = true;
					animspeed = -3;
					hangars.push([2,0,0]);
					costenergy = 300;
					costmetal = 0//100;
					debris = 20;
					mass = 100;
					armormax = 400;
					tech = 2;
				break;
				case 17: //Bot Stardock
					nametext = "Bot Stardock";
					desctext = "Constructs Medium Ships.";
					itemclass = 1;
					wide = 27;
					high = 24;
					buildwide = 2;
					buildhigh = 2;
					sheetW = 5;
					sheetH = 2;
					picid = 17;
					anim = true;
					animspeed = 1;
					hangars.push([6,0,0]);
					costenergy = 300;
					costmetal = 100;
					
					mass = 100;
					armormax = 50;
					shieldmax = 200;
					shieldregen = .5;
					tech = 2;
				break;
				case 20: //Starport
					nametext = "Starport";
					desctext = "Constructs Capital Ships.";
					itemclass = 1;
					wide = 40;
					high = 35;
					buildwide = 3;
					buildhigh = 3;
					sheetW = 4;
					sheetH = 3;
					picid = 20;
					anim = true;
					animspeed = 3;
					hangars.push([3,0,0]);
					costenergy = 400;
					costmetal = 300;
					buildsound = 6;
					mass = 200;
					armormax = 700;
					tech = 3;
				break;
				case 21: //Hive
					nametext = "Hive";
					desctext = "Roar.";
					itemclass = 1;
					wide = 40;
					high = 35;
					buildwide = 3;
					buildhigh = 3;
					sheetW = 5;
					sheetH = 4;
					picid = 21;
					anim = true;
					animspeed = -3;
					hangars.push([3,0,0]);
					costenergy = 600;
					costmetal = 0//300;
					debris = 20;
					mass = 200;
					armormax = 700;
					tech = 3;
				break;
				case 22: //Bot Starport
					nametext = "Bot Starport";
					desctext = "Constructs Capital Ships.";
					itemclass = 1;
					wide = 40;
					high = 35;
					buildwide = 3;
					buildhigh = 3;
					sheetW = 5;
					sheetH = 2;
					picid = 22;
					anim = true;
					animspeed = 1;
					hangars.push([7,0,0]);
					costenergy = 500;
					costmetal = 300;
					
					mass = 200;
					armormax = 100;
					shieldmax = 500;
					shieldregen = .5;
					tech = 3;
				break;
				case 25: //Extractor
					nametext = "Extractor";
					desctext = "Mines nearby asteroids for metal.";
					itemclass = 3;
					wide = 27;
					high = 24;
					buildwide = 2;
					buildhigh = 2;
					sheetW = 10;
					sheetH = 1;
					picid = 25;
					anim = true;
					animspeed = 1;
					costenergy = 250;
					turrets.push([12,-20,-20]);
					turrets.push([12,20,-20]);
					turrets.push([12,-20,10]);
					turrets.push([12,20,10]);
					miner = true;
					buildsound = 6;
					mass = 100;
					armormax = 500;
				break;
				case 27: //Bot Miner
					nametext = "Bot Miner";
					desctext = "Generates Metal.";
					itemclass = 3;
					wide = 27;
					high = 24;
					buildwide = 2;
					buildhigh = 2;
					sheetW = 5;
					sheetH = 2;
					picid = 27;
					anim = true;
					animspeed = 1;
					costenergy = 300;
					metal = 3;
					miner = true;
					
					mass = 100;
					armormax = 100;
					shieldmax = 300;
					shieldregen = .5;
				break;
				case 80: //MegaStation
					nametext = "MegaStation";
					desctext = "Main base.";
					itemclass = 0;
					wide = 54;
					high = 48;
					buildwide = 4;
					buildhigh = 4;
					sheetW = 4;
					sheetH = 4;
					picid = 80;
					base = true;
					anim = true;
					animspeed = 3;
					energy = .2;
					buildsound = 6;
					mass = 400;
					armormax = 2000;
					shieldregen = 4;
					tacshieldmax = 1000;
					tacshieldr = 150;
					
					turrets.push([7,-40,-40]);
					turrets.push([7,40,-40]);
					turrets.push([7,-40,10]);
					turrets.push([7,40,10]);
				break;
				case 98: //Small Asteroid
					wide = 12;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 6;
					sheetH = 6;
					picid = 98;
					anim = true;
					costenergy = 0;
					rock = true;
					animspeed = 0;
					
					mass = 100;
					armormax = 250;
				break;
				case 99: //Medium Asteroid
					wide = 27;
					high = 24;
					buildwide = 2;
					buildhigh = 2;
					sheetW = 6;
					sheetH = 6;
					picid = 99;
					anim = true;
					costenergy = 0;
					rock = true;
					animspeed = 0;
					
					mass = 400;
					armormax = 1000;
				break;
				case 100: //Turret
					nametext = "Blaster";
					desctext = "Basic defense turret.";
					itemclass = 4;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 1;
					sheetH = 1;
					picid = 100;
					costenergy = 50;
					turrets.push([0,0,-3]);
					
					mass = 20;
					armormax = 150;
				break;
				case 101: //Double Blaster
					nametext = "Double Blaster";
					desctext = "Heavier version of the Blaster.";
					itemclass = 4;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 1;
					sheetH = 1;
					picid = 100;
					costenergy = 90;
					turrets.push([1,0,-3]);
					mass = 20;
					armormax = 150;
				break;
				case 102: //Autogun
					nametext = "Autogun";
					desctext = "Machine gun for close defense.";
					itemclass = 4;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 1;
					sheetH = 1;
					picid = 100;
					costenergy = 100;
					turrets.push([2,0,-3]);
					mass = 20;
					armormax = 150;
				break;
				case 103: //Bomb Rack
					nametext = "Bomb Rack";
					desctext = "Launches bombs.";
					itemclass = 4;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 1;
					sheetH = 1;
					picid = 100;
					costenergy = 125;
					turrets.push([3,0,-6]);
					mass = 20;
					armormax = 150;
				break;
				case 104: //MicroMissiles
					nametext = "Micromissiles";
					desctext = "Light missile launcher.";
					itemclass = 4;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 1;
					sheetH = 1;
					picid = 100;
					costenergy = 50;
					turrets.push([4,0,-4]);
					mass = 20;
					armormax = 150;
				break;
				case 105: //Artillery
					nametext = "Artillery";
					desctext = "Bombard enemy base over long range.";
					itemclass = 4;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 1;
					sheetH = 1;
					picid = 100;
					costenergy = 300;
					costmetal = 25;
					turrets.push([5,0,-4]);
					mass = 20;
					armormax = 150;
				break;
				case 106: //QuadMicroMissiles
					nametext = "Quad Micromissiles";
					desctext = "Heavy missile launcher.";
					itemclass = 4;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 1;
					sheetH = 1;
					picid = 100;
					costenergy = 150;
					turrets.push([6,0,-4]);
					mass = 20;
					armormax = 150;
				break;
				case 107: //Autocannon
					nametext = "Autocannon";
					desctext = "Heavy version of the Autogun.";
					itemclass = 4;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 1;
					sheetH = 1;
					picid = 100;
					costenergy = 150;
					costmetal = 25;
					turrets.push([7,0,-4]);
					mass = 20;
					armormax = 150;
				break;
				case 108: //Edgeslasher
					nametext = "Edgeslasher";
					desctext = "Homing boomerang attack.";
					itemclass = 4;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 1;
					sheetH = 1;
					picid = 100;
					costenergy = 100;
					turrets.push([8,0,-4]);
					mass = 20;
					armormax = 150;
				break;
				case 109: //Plasmacaster
					nametext = "Plasmacaster";
					desctext = "Plasma weapon dealing heavy damage.";
					itemclass = 4;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 1;
					sheetH = 1;
					picid = 100;
					costenergy = 75;
					costmetal = 75;
					turrets.push([9,0,-5]);
					mass = 20;
					armormax = 150;
				break;
				case 110: //Laser
					nametext = "Laser";
					desctext = "Destroys fighters.";
					itemclass = 4;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 1;
					sheetH = 1;
					picid = 100;
					costenergy = 200;
					turrets.push([10,0,-6]);
					mass = 20;
					armormax = 150;
				break;
				case 111: //Lasercannon
					nametext = "Lasercannon";
					desctext = "Long-range beam weapon.";
					itemclass = 4;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 1;
					sheetH = 1;
					picid = 100;
					costenergy = 200;
					costmetal = 25;
					turrets.push([11,0,-6]);
					mass = 20;
					armormax = 150;
				break;
				case 113: //Phalanx
					nametext = "Phalanx";
					desctext = "Destroys incoming projectiles.";
					itemclass = 4;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 1;
					sheetH = 1;
					picid = 100;
					costenergy = 150;
					turrets.push([13,0,-1]);
					mass = 20;
					armormax = 150;
				break;
				case 114: //Repair
					nametext = "Repair Turret";
					desctext = "Repairs ships and structures.";
					itemclass = 4;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 1;
					sheetH = 1;
					picid = 100;
					costenergy = 75;
					turrets.push([14,0,-4]);
					mass = 20;
					armormax = 150;
				break;
				case 116: //Autocaster
					nametext = "Autocaster";
					desctext = "Rapid fire plasma weapon.";
					itemclass = 4;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 1;
					sheetH = 1;
					picid = 100;
					costenergy = 100;
					costmetal = 25;
					turrets.push([16,0,-5]);
					mass = 20;
					armormax = 150;
				break;
				case 117: //Microlaser
					nametext = "Microlaser";
					desctext = "Short-range beam weapon.";
					itemclass = 4;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 1;
					sheetH = 1;
					picid = 100;
					costenergy = 50;
					turrets.push([17,0,-6]);
					mass = 20;
					armormax = 150;
				break;
				case 147: //TurretB
					nametext = "BotTurret";
					desctext = "Beam Weapon.";
					itemclass = 4;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 5;
					sheetH = 2;
					picid = 104;
					anim = true;
					animspeed = 1;
					costenergy = 150;
					turrets.push([47,0,-3]);
					
					mass = 20;
					armormax = 25;
					shieldmax = 150;
					shieldregen = .5;
				break;
				case 148: //CrystalA
					nametext = "BotCrystal";
					desctext = "Beam Weapon.";
					itemclass = 4;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 5;
					sheetH = 2;
					picid = 104;
					anim = true;
					animspeed = 1;
					costenergy = 50;
					turrets.push([48,0,-3]);
					
					mass = 20;
					armormax = 25;
					shieldmax = 150;
					shieldregen = .5;
				break;
				case 149: //AlienFang
					nametext = "Fang";
					desctext = "Roar.";
					itemclass = 4;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 5;
					sheetH = 4;
					picid = 102;
					anim = true;
					animspeed = -3;
					costenergy = 50;
					turrets.push([49,0,-3]);
					debris = 20;
					
					mass = 20;
					armormax = 75;
				break;
				case 150: //Mjolnir
					nametext = "Mjolnir";
					desctext = "Gigantic Artillery Cannon.";
					itemclass = 4;
					wide = 20;
					high = 20;
					buildwide = 2;
					buildhigh = 2;
					sheetW = 1;
					sheetH = 1;
					picid = 101;
					costenergy = 500;
					costmetal = 200;
					turrets.push([50,0,-6]);
					
					mass = 50;
					armormax = 600;
				break;
				case 151: //Apocalypse
					nametext = "Apocalypse";
					desctext = "Nuclear Missile Launcher.";
					itemclass = 4;
					wide = 20;
					high = 20;
					buildwide = 2;
					buildhigh = 2;
					sheetW = 1;
					sheetH = 1;
					picid = 101;
					costenergy = 750;
					costmetal = 750;
					turrets.push([51,0,-6]);
					
					mass = 50;
					armormax = 600;
				break;
				case 152: //Void Lance
					nametext = "Void Lance";
					desctext = "Micro black-hole cannon destroys targets in one shot.";
					itemclass = 4;
					wide = 20;
					high = 20;
					buildwide = 2;
					buildhigh = 2;
					sheetW = 1;
					sheetH = 1;
					picid = 101;
					costenergy = 200;
					costmetal = 150;
					turrets.push([52,0,-4]);
					
					mass = 50;
					armormax = 600;
				break;
				case 153: //Hyper Repair
					nametext = "Hyper Repair";
					desctext = "Large repair array.";
					itemclass = 4;
					wide = 20;
					high = 20;
					buildwide = 2;
					buildhigh = 2;
					sheetW = 1;
					sheetH = 1;
					picid = 101;
					costenergy = 175;
					costmetal = 175;
					turrets.push([53,0,-4]);
					
					mass = 50;
					armormax = 600;
				break;
				case 175: //Tactical Shield
					nametext = "Tactical Shield";
					desctext = "Protects a small area of your base.";
					itemclass = 5;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 6;
					sheetH = 6;
					picid = 175;
					costenergy = 50;
					lights = 10;
					anim = true;
					animspeed = 1;
					buildsound = 5;
					mass = 15;
					armormax = 50;
					tacshieldmax = 200;
					tacshieldregen = 5;
					tacshieldr = 100;
					turretrange = tacshieldr;
				break;
				case 176: //Mega Shield
					nametext = "Mega Shield";
					desctext = "Protects an area of your base.";
					itemclass = 5;
					wide = 20;
					high = 20;
					buildwide = 2;
					buildhigh = 2;
					sheetW = 6;
					sheetH = 6;
					picid = 176;
					costenergy = 150;
					costmetal = 25;
					lights = 10;
					anim = true;
					animspeed = 1;
					buildsound = 5;
					mass = 15;
					armormax = 100;
					tacshieldmax = 500;
					tacshieldregen = 10;
					tacshieldr = 150;
					turretrange = tacshieldr;
				break;
				case 177: //Barricade
					nametext = "Barricade";
					desctext = "Good for blocking incoming shots.";
					itemclass = 5;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 6;
					sheetH = 6;
					picid = 177;
					costmetal = 25;
					damage = true;
					buildsound = 7;
					mass = 15;
					armormax = 350;
				break;
				case 178: //Processor
					nametext = "Processor";
					desctext = "Turns metal into energy.";
					itemclass = 5;
					wide = 10;
					high = 8;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 10;
					sheetH = 1;
					picid = 178;
					anim = true;
					metal = -.3;
					energy = .4;
					costenergy = 100;
					animspeed = 1;
					lights = 2;
					buildsound = 5;
					mass = 20;
					armormax = 100;
				break;
				case 179: //Constructor
					nametext = "Constructor";
					desctext = "Expands build range.";
					itemclass = 5;
					wide = 27;
					high = 24;
					buildwide = 2;
					buildhigh = 2;
					sheetW = 4;
					sheetH = 4;
					picid = 179;
					base = true;
					anim = true;
					animspeed = 4;
					costenergy = 75;
					costmetal = 75;
					lights = 2;
					buildsound = 6;
					mass = 70;
					armormax = 50;
				break;
				case 180: //Biolab
					nametext = "Biolab";
					desctext = "Launches captured aliens.";
					itemclass = 5;
					wide = 27;
					high = 24;
					buildwide = 2;
					buildhigh = 2;
					sheetW = 6;
					sheetH = 6;
					picid = 180;
					anim = true;
					animspeed = 4;
					costenergy = 100;
					costmetal = 100;
					hangars.push([4,0,0]);
					buildsound = 6;
					mass = 70;
					armormax = 400;
				break;
				case 181: //CloakField
					nametext = "Cloak Field";
					desctext = "Cloaks an area of your base.";
					itemclass = 5;
					wide = 10;
					high = 10;
					buildwide = 1;
					buildhigh = 1;
					sheetW = 4;
					sheetH = 4;
					picid = 181;
					costenergy = 50;
					costmetal = 25;
					lights = 11;
					anim = true;
					animspeed = 1;
					buildsound = 5;
					mass = 15;
					armormax = 50;
					cloakfieldr = 150;
					animspeed = 1;
					turretrange = cloakfieldr;
				break;
				case 182: //Navy Yard
					nametext = "Naval Yard";
					desctext = "Constructs fleets of medium ships.";
					itemclass = 5;
					wide = 40;
					high = 35;
					buildwide = 3;
					buildhigh = 3;
					sheetW = 6;
					sheetH = 6;
					picid = 182;
					anim = true;
					animspeed = 3;
					hangars.push([8,.125,35]);
					hangars.push([8,.375,35]);
					hangars.push([8,.625,35]);
					hangars.push([8,.875,35]);
					costenergy = 300;
					costmetal = 400;
					buildsound = 6;
					mass = 200;
					armormax = 700;
					tech = 2;
				break;
				case 183: //Fighter Yard
					nametext = "Fighter Yard";
					desctext = "Constructs squads of Fighters.";
					itemclass = 5;
					wide = 20;
					high = 15;
					buildwide = 2;
					buildhigh = 2;
					sheetW = 6;
					sheetH = 6;
					picid = 183;
					anim = true;
					animspeed = 2;
					hangars.push([9,0,15]);
					hangars.push([10,.25,15]);
					hangars.push([11,.5,15]);
					hangars.push([12,.75,15]);
					costenergy = 200;
					costmetal = 200;
					buildsound = 6;
					mass = 100;
					armormax = 300;
					tech = 1;
				break;
			}
			if(debris == 0){
				if(mass < 50){
					debris = 1;
				}
				if(mass >= 50){
					debris = 3;
				}
			}
			DoMods();
			for(i = 0; i < turrets.length; i++){
				while(turrets[i].length < 6){
					turrets[i].push(-1);
				}
			}
			
			if(turretrange == 0){
				CalcTurretRange();
			}
			
			if(buildsound == 0){
				if(s[0] >= 100 && s[0] < 200){
					buildsound = 4;
				}
			}
		}
		
		public function CalcTurretRange()
		{
			var i:int;
			var j:int;
			var t;
			var g;
			for(i = 0; i < turrets.length; i++){
				t = new TurretData(new Array(turrets[i][0],turrets[i][3],turrets[i][4],turrets[i][5]));
				for(j = 0; j < t.guns.length; j++){
					g = new Gun(null,null,t.guns[j],t.ammos[j]);
					if(g.gunrange * gunrangemod > turretrange){
						turretrange = g.gunrange * gunrangemod;
					}
				}
			}
			t = null;
			g = null;
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
						for(k = 0; k < turrets.length; k++){
							turrets[k].push(s[i])
						}
						debrisammo[2] = 0;
						modtxt.push("EMP Rounds");
					break;
					case 12: //YGreen
						for(k = 0; k < turrets.length; k++){
							turrets[k].push(s[i])
						}
						debrisammo[2] = 1;
						modtxt.push("Acid Rounds");
					break;
					case 13: //White
						for(k = 0; k < turrets.length; k++){
							turrets[k].push(s[i])
						}
						debrisammo[2] = 9;
						modtxt.push("Force Rounds");
					break;
					case 14: //Violet
						for(k = 0; k < turrets.length; k++){
							turrets[k].push(s[i])
						}
						debrisammo[2] = 4;
						modtxt.push("Neutron Rounds");
					break;
					case 15: //NeonGreen
						for(k = 0; k < turrets.length; k++){
							turrets[k].push(s[i])
						}
						debrisammo[2] = 5;
						modtxt.push("Iridium Rounds");
					break;
					case 16: //Yellow
						for(k = 0; k < turrets.length; k++){
							turrets[k].push(s[i])
						}
						debrisammo[2] = 7;
						modtxt.push("Thermal Rounds");
					break;
					case 17: //Blue
						for(k = 0; k < turrets.length; k++){
							turrets[k].push(s[i])
						}
						debrisammo[2] = 8;
						modtxt.push("Freeze Rounds");
					break;
					case 18: //Fusion
						for(k = 0; k < turrets.length; k++){
							turrets[k].push(s[i])
						}
						debrisammo[2] = 10;
						modtxt.push("Fusion Rounds");
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
								debrisammo[1] = 1;
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
					case 50: //Insurance
						insurancemod = .5;
						modtxt.push("Insurance");
					break;
					case 51: //Mini Reactor
						energy = energy + .05
						modtxt.push("Mini-Reactor");
					break;
					case 80: //Cloak
						cloakmod = 1;
						modtxt.push("Cloak Module");
					break;
				}
			}
		}
	}
}