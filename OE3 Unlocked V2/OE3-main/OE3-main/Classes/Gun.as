package
{
	public class Gun
	{
		public var guncool:int = 0;
		public var gunheat:int = 0;
		public var gunburstmax:int = 1;
		public var gunburst:int = 1;
		public var gunburstcool:int = 0;
		public var gunburstheat:int = 0;
		public var gunrange:Number = 0;
		public var gunangle:Number = 0;
		public var gunlaser:int = 0;
		public var t:Number = 0;
		public var r:Number = 0;
		public var s:Number;
		public var ammo:Array = new Array(3);
		public var ammospeed:Number = 10;
		
		public var active:Boolean = false;
		
		public var up;
		public var mom;
		
		public function Gun(m, upp, guns, ammos)
		{
			var i:int;
			var adjrange:Boolean = true;
			mom = m;
			up = upp;
			s = guns[0];
			t = guns[1];
			r = guns[2];
			switch(s){
				case 0: //Piranha Gun
					gunheat = 13;
					gunrange = 120;
					gunangle = .025;
					gunburstmax = 3;
					gunburstheat = 1;
				break;
				case 0.1: //Piranha Missile
					gunheat = 100;
					gunrange = 100;
					gunangle = .05;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 1: //Knight Gun
					gunheat = 10;
					gunrange = 100;
					gunangle = .05;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 2: //Mosquito Bombs
					gunheat = 25;
					gunrange = 200;
					gunangle = .03;
					gunburstmax = 1;
					gunburstheat = 1;
					adjrange = false;
					ammospeed = 1;
				break;
				case 3: //Mantis Gun
					gunheat = 6;
					gunrange = 100;
					gunangle = .05;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 4: //Rapier Beam
					gunheat = 10;
					gunrange = 150;
					gunangle = .05;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 5: //Cutlass Beam
					gunheat = 10;
					gunrange = 40;
					gunangle = .1;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 6: //Valkyrie Spinners
					gunheat = 6;
					gunrange = 150;
					gunangle = .2;
					gunburstmax = 1;
					gunburstheat = 1;
					adjrange = false;
					ammospeed = 0;
				break;
				case 7: //Hawk Rockets
					gunheat = 40;
					gunrange = 320;
					gunangle = .025;
					gunburstmax = 2;
					gunburstheat = 3;
					adjrange = false;
					ammospeed = 2;
				break;
				case 8: //Fury Gun
					gunheat = 13;
					gunrange = 120;
					gunangle = .025;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 9: //Miner Beam
					gunheat = 35;
					gunrange = 45;
					gunangle = .1;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 10: //Engineer Beam
					gunheat = 20;
					gunrange = 60;
					gunangle = .1;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 14: //Spectre Gun
					gunheat = 4;
					gunrange = 120;
					gunangle = .15;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 14.1: //Spectre Mid Gun
					gunheat = 6;
					gunrange = 120;
					gunangle = .15;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 15: //Gladiator Beam
					gunheat = 30;
					gunrange = 125;
					gunangle = .1;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 50: //Puma Blaster
					gunheat = 20;
					gunrange = 150;
					gunangle = .05;
					gunburstmax = 3;
					gunburstheat = 1;
				break;
				case 50.1: //Puma Missiles
					gunheat = 50;
					gunrange = 150;
					gunangle = .05;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 51: //Athena Bombs
					gunheat = 35;
					gunrange = 200;
					gunangle = .025;
					gunburstmax = 2;
					gunburstheat = 5;
				break;
				case 52: //Odyssey Blaster
					gunheat = 7;
					gunrange = 100;
					gunangle = .03;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 53: //Myrmidon Plasma
					gunheat = 20;
					gunrange = 200;
					gunangle = .03;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 53.1: //Myrmidon Rail
					gunheat = 20;
					gunrange = 150;
					gunangle = .03;
					gunburstmax = 3;
					gunburstheat = 3;
				break;
				case 54: //Grendal Rail
					gunheat = 10;
					gunrange = 150;
					gunangle = .03;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 54.1: //Grendal Missiles
					gunheat = 50;
					gunrange = 150;
					gunangle = .05;
					gunburstmax = 3;
					gunburstheat = 3;
				break;
				case 55: //Minotaur Missiles
					gunheat = 18;
					gunrange = 250;
					gunangle = .05;
					gunburstmax = 1;
					gunburstheat = 1;
					adjrange = false;
					ammospeed = 1;
				break;
				case 56: //Corvette Spinners
					gunheat = 15;
					gunrange = 150;
					gunangle = .05;
					gunburstmax = 4;
					gunburstheat = 2;
				break;
				case 56.1: //Corvette Missiles
					gunheat = 50;
					gunrange = 150;
					gunangle = .05;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 57: //Spartan Laser
					gunheat = 100;
					gunrange = 250;
					gunangle = .025;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 58: //Falcon Laser
					gunheat = 14;
					gunrange = 160;
					gunangle = .05;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 58.1: //Falcon Bombs
					gunheat = 40;
					gunrange = 150;
					gunangle = .025;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 58.2: //Falcon Guns
					gunheat = 5;
					gunrange = 100;
					gunangle = .025;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 59: //Scorpion Rockets
					gunheat = 30;
					gunrange = 320;
					gunangle = .025;
					gunburstmax = 1;
					gunburstheat = 1;
					adjrange = false;
					ammospeed = 2;
				break;
				case 59.1: //Scorpion Rockets B
					gunheat = 45;
					gunrange = 320;
					gunangle = .025;
					gunburstmax = 1;
					gunburstheat = 1;
					adjrange = false;
					ammospeed = 2;
				break;
				case 60: //Exhumer Beam
					gunheat = 5;
					gunrange = 80;
					gunangle = .1;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 61: //Tremor Blaster
					gunheat = 17;
					gunrange = 150;
					gunangle = .05;
					gunburstmax = 3;
					gunburstheat = 1;
				break;
				case 63: //Pandemic Missiles
					gunheat = 50;
					gunrange = 200;
					gunangle = .1;
					gunburstmax = 1;
					gunburstheat = 1;
					adjrange = false;
					ammospeed = 1;
				break;
				case 64: //Hades Gun
					gunheat = 75;
					gunrange = 200;
					gunangle = .05;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 65: //Artillery
					gunheat = 25;
					gunrange = 500;
					gunangle = .01;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 100: //Blaster Gun
					gunheat = 8;
					gunrange = 150;
					gunangle = .025;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 101: //Double Blaster Gun
					gunheat = 12;
					gunrange = 175;
					gunangle = .025;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 102: //Autogun
					gunheat = 5;
					gunrange = 125;
					gunangle = .025;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 103: //Bomb Rack
					gunheat = 55;
					gunrange = 225;
					gunangle = .03;
					gunburstmax = 1;
					gunburstheat = 1;
					adjrange = false;
					ammospeed = 0;
				break;
				case 104: //MicroMissiles
					gunheat = 30;
					gunrange = 200;
					gunangle = .05;
					gunburstmax = 1;
					gunburstheat = 1;
					adjrange = false;
					ammospeed = 3;
				break;
				case 105: //Artillery
					gunheat = 25;
					gunrange = 500;
					gunangle = .01;
					gunburstmax = 2;
					gunburstheat = 5;
				break;
				case 106: //QuadMicroMissiles
					gunheat = 40;
					gunrange = 225;
					gunangle = .05;
					gunburstmax = 3;
					gunburstheat = 3;
					adjrange = false;
					ammospeed = 3;
				break;
				case 107: //Autocannon
					gunheat = 12;
					gunrange = 170;
					gunangle = .025;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 108: //Edgeslasher
					gunheat = 60;
					gunrange = 200;
					gunangle = .05;
					gunburstmax = 4;
					gunburstheat = 3;
				break;
				case 109: //Plasmacaster
					gunheat = 35;
					gunrange = 180;
					gunangle = .025;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 110: //Laser
					gunheat = 5;
					gunrange = 225;
					gunangle = .015;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 111: //Lasercannon
					gunheat = 30;
					gunrange = 250;
					gunangle = .015;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 112: //MiningLaser
					gunheat = 20;
					gunrange = 180;
					gunangle = .01;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 113: //Phalanx Beam
					gunheat = 3;
					gunrange = 90;
					gunangle = .05;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 114: //Repair Beam
					gunheat = 25;
					gunrange = 100;
					gunangle = .1;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 116: //Autocaster
					gunheat = 10;
					gunrange = 150;
					gunangle = .05;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 117: //Microlaser
					gunheat = 5;
					gunrange = 100;
					gunangle = .05;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 147: //Bot Laser
					gunheat = 20;
					gunrange = 225;
					gunangle = .01;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 148: //Bot Blaster
					gunheat = 9;
					gunrange = 150;
					gunangle = .01;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 149: //Alien Fang
					gunheat = 10;
					gunrange = 150;
					gunangle = .03;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 150: //Mjolnir
					gunheat = 100;
					gunrange = 800;
					gunangle = .01;
					gunburstmax = 3;
					gunburstheat = 2;
				break;
				case 151: //Apocalypse
					gunheat = 150;
					gunrange = 2000;
					gunangle = .01;
					gunburstmax = 1;
					gunburstheat = 1;
					adjrange = false;
					ammospeed = 3;
				break;
				case 152: //Void Lance
					gunheat = 50;
					gunrange = 170;
					gunangle = .01;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 153: //Hyper Repair Beam
					gunheat = 15;
					gunrange = 175;
					gunangle = .1;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 300: //Trident
					gunheat = 6;
					gunrange = 220;
					gunangle = .025;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 301: //Legion Gun
					gunheat = 6;
					gunrange = 220;
					gunangle = .025;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 302: //Mastodon Missiles
					gunheat = 70;
					gunrange = 250;
					gunangle = .05;
					gunburstmax = 4;
					gunburstheat = 3;
				break;
				case 303: //Goliath Laser
					gunheat = 60;
					gunrange = 200;
					gunangle = .025;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 306: //Hammerhead Shells
					gunheat = 10;
					gunrange = 500;
					gunangle = .02;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 307: //Cataclysm Missiles A
					gunheat = 10;
					gunrange = 200;
					gunangle = .05;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 307.1: //Cataclysm Missiles B
					gunheat = 14;
					gunrange = 200;
					gunangle = .05;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 307.2: //Cataclysm Missiles C
					gunheat = 80;
					gunrange = 250;
					gunangle = .05;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 308: //Jupiter Plasma A
					gunheat = 30;
					gunrange = 300;
					gunangle = .05;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 310: //Ragnarok Missiles
					gunheat = 100;
					gunrange = 500;
					gunangle = .025;
					gunburstmax = 1;
					gunburstheat = 1;
					adjrange = false;
					ammospeed = 3;
				break;
				case 311: //Biohazard Missiles
					gunheat = 15;
					gunrange = 200;
					gunangle = .1;
					gunburstmax = 1;
					gunburstheat = 1;
					adjrange = false;
					ammospeed = 1;
				break;
				case 312: //Archangel Gun
					gunheat = 75;
					gunrange = 200;
					gunangle = .05;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 312.1: //Archangel Blaster
					gunheat = 20;
					gunrange = 200;
					gunangle = .05;
					gunburstmax = 3;
					gunburstheat = 2;
				break;
				case 316: //Tyrant Gun
					gunheat = 5;
					gunrange = 200;
					gunangle = .05;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
				case 316.1: //Tyrant Rockets
					gunheat = 75;
					gunrange = 200;
					gunangle = .05;
					gunburstmax = 1;
					gunburstheat = 1;
				break;
			}
			
			gunburst = gunburstmax;
			for(i = 0; i < ammo.length; i++){
				ammo[i] = ammos[i];
			}
			if(ammo[0] > 99){
				gunlaser = 1;
			}
			if(adjrange == true){
				AdjustRange()
			}
			guncool = gunheat;
		}
		
		public function AdjustRange()
		{
			//Adjusts ammospeed to give desired range
			var d;
			d = new ShotData(ammo);
			ammospeed = Math.floor(gunrange / d.lifespan);
			d = null
		}
		
		public function DoStuff()
		{
			if(up is Ship && guncool > 0){
				guncool = guncool - 1;
			}
			if(up is Turret && guncool > 0){
				guncool = guncool - 1;
			}
			if(guncool > 0){
				guncool = guncool - 1;
			}
			if(gunburstcool > 0){
				gunburstcool = gunburstcool - 1;
			}
			if(active == true || (active == false && gunburst < gunburstmax)){
				FireControl();
			}
		}
		
		public function FireControl()
		{
			if(guncool == 0 && gunburstcool == 0){
				//Fire
				if(up is Ship){
					Shoot(up.xx,up.yy,up.xv,up.yv);
					if(up.cloaked > 0){
						up.cloaked = 0;
						up.cloakcool = up.cloakheat;
					}
				}
				if(up is Turret){
					Shoot(up.up.xx + up.xx, up.up.yy + up.yy, up.up.xv,up.up.yv);
					if(up.up.cloaked > 0){
						up.up.cloaked = 0;
						up.up.cloakcool = up.up.cloakheat;
					}
				}
				//Timing
				gunburst = gunburst - 1;
				gunburstcool = gunburstheat;
				if(gunburst == 0){
					gunburst = gunburstmax;
					gunburstcool = 0;
					guncool = gunheat;
				}
			}
		}
		
		public function Shoot(xxx:Number, yyy:Number, xxv:Number, yyv:Number)
		{
			var i:int;
			var j:int;
			var k:int;
			var xx:Number;
			var yy:Number;
			var xv:Number;
			var yv:Number;

			if(gunlaser == 0){
				xx = xxx + r*Math.sin((up.t+t)*6.283);
				yy = yyy - .75*r*Math.cos((up.t+t)*6.283);
				xv = xxv+ammospeed*Math.sin(up.t*6.283);
				yv = yyv-1*ammospeed*Math.cos(up.t*6.283);
				mom.GenShot(ammo,up.faction,xx,yy,xv,yv,up.t,up);
			}else{
				if((xxx-up.targetx)*(xxx-up.targetx)+(yyy-up.targety)*(yyy-up.targety) < gunrange * gunrange){
					xx = xxx + r*Math.sin((up.t+t)*6.283);
					yy = yyy - .75*r*Math.cos((up.t+t)*6.283);
					xv = up.targetx;
					yv = up.targety;
					mom.GenShot(ammo,up.faction,xx,yy,xv,yv,up.t,up);
					for(i = 0; i < up.targets.length; i++){
						if(up.targets[i].xx == xv && up.targets[i].yy == yv){
							up.targets[i].Hit(mom.shots[mom.shots.length - 1])
						}
					}
				}
			}
		}
	}
}1