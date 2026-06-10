package
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class Struct extends Obj
	{
		public var buildwide:int = 1;
		public var buildhigh:int = 1;
		public var base:Boolean = false;
		public var upgraded = false;
		public var upgrades:Array = new Array();
		public var tech:int = 0;
		public var structid:int = 0;
		public var rock:Boolean = false;
		public var turretrange:int = 0;
		public var miner:Boolean = false;
		public var sellenergy:int = 0;
		public var sellmetal:int = 0;
		
		public var deadasteroid:Boolean = false;
		
		public function Struct(m,d,f:int,xxx:Number,yyy:Number)
		{
			var i:int;
			var j:int;
			
			s = new Array();
			for(i = 0; i < d.s.length;i++){
				s.push(d.s[i]);
			}
			mom = m;
			xx = xxx;
			yy = yyy;
			x = xx;
			y = yy;
			xv = 0;
			yv = 0;
			t = 0;
			tv = 0;
			faction = f;
			picref = m.l.ssstructs[d.picid][f];
			structid = mom.structid;
			mom.structid = mom.structid + 1;
			wide = d.wide;
			high = d.high;
			armormax = d.armormax;
			shieldmax = d.shieldmax;
			armorregen = d.armorregen;
			shieldregen = d.shieldregen;
			tacshieldregen = d.tacshieldregen;
			tacshieldmax = d.tacshieldmax;
			tacshieldr = d.tacshieldr;
			buildwide = d.buildwide;
			buildhigh = d.buildhigh;
			base = d.base;
			energy = d.energy;
			metal = d.metal;
			tech = d.tech;
			rock = d.rock;
			turretrange = d.turretrange;
			debris = d.debris;
			mass = d.mass;
			miner = d.miner;
			sellenergy = Math.ceil(.25 * d.costenergy);
			sellmetal = Math.ceil(.25 * d.costmetal);
			if(shieldmax > 0){
				shieldref = mom.l.ssstructshields[d.picid];
			}
			damage = d.damage;
			debrisammo = d.debrisammo;
			if(d.insurancemod > 0){
				ienergy = Math.floor(d.costenergy * d.insurancemod);
				imetal = Math.floor(d.costmetal * d.insurancemod);
			}
			if(d.insurancemod >= 1){
				ienergy = d.costenergy;
				imetal = d.costmetal;
			}
			cloak = d.cloakmod;
			cloakfieldr = d.cloakfieldr;
			
			sheetW = d.sheetW;
			sheetH = d.sheetH;
			anim = d.anim;
			animspeed = d.animspeed;
			
			spriteW = picref.width / sheetW;
			spriteH = picref.height / sheetH;
			
			lights = d.lights;
			if(lights > 0){
				lightref = m.l.ssstructlights[d.picid];
				lightW = lightref.width / spriteW;
				lightH = lightref.height / spriteH;
			}
			
			pic = new Bitmap();
			pic.bitmapData = new BitmapData(spriteW,spriteH,true,0x00000000);
			addChild(pic);
			pic.x = Math.round(-.5 * spriteW);
			pic.y = Math.round(-.5 * spriteH);
			
			lightpic = new Bitmap();
			lightpic.bitmapData = new BitmapData(spriteW,spriteH,true,0x00000000);
			addChild(lightpic);
			lightpic.x = Math.round(-.5 * spriteW);
			lightpic.y = Math.round(-.5 * spriteH);
			
			if(shieldmax > 0){
				shieldpic = new Bitmap();
				shieldpic.bitmapData = new BitmapData(spriteW,spriteH,true,0x00000000);
				addChild(shieldpic);
				shieldpic.x = Math.round(-.5 * spriteW);
				shieldpic.y = Math.round(-.5 * spriteH);
				shieldpic.blendMode = "screen";
			}else{
				shieldpic = null;
			}
			if(tacshieldmax > 0){
				tacshieldpic = new TacShieldPic();
				addChild(tacshieldpic);
				tacshieldpic.x = 0;
				tacshieldpic.y = 0;
				tacshieldpic.blendMode = "screen";
				tacshieldpic.visible = false;
				tacshieldpic.scaleX = tacshieldr / 100;
				tacshieldpic.scaleY = tacshieldpic.scaleX;
			}else{
				tacshieldpic = null;
			}
			
			armor = armormax;
			shield = shieldmax;
			tacshield = tacshieldmax;
			/*if(d.hangars > 0){
				mom.GenHangar(this,d.hangar,0,0);
			}*/
			
			for(i = 0; i < d.hangars.length; i++){
				mom.GenHangar(this,d.hangars[i][0],d.hangars[i][1],d.hangars[i][2]);
				hangars[i].launchheat = hangars[i].launchheat * d.hangarlaunchheatmod;
				if(s[0] != 183)
				{
					if(f == 0)
					{
						hangars[i].launcht = 0;
					}
					if(f == 1)
					{
						hangars[i].launcht = .5;
					}
				}
			}
			if(d.plasmod > 0 && debris == 10 && debrisammo[0] == 4){
				debrisammo[0] = 10;
			}
			for(i = 0; i < d.turrets.length; i++){
				mom.GenTurret(this,new Array(d.turrets[i][0],d.turrets[i][3],d.turrets[i][4],d.turrets[i][5]),d.turrets[i][1],d.turrets[i][2]);
				for(j = 0; j < turrets[i].guns.length; j++){
					turrets[i].guns[j].gunheat = Math.floor(turrets[i].guns[j].gunheat * d.gunheatmod);
					if(d.gunrangemod != 1){
						turrets[i].guns[j].gunrange = turrets[i].guns[j].gunrange * d.gunrangemod;
						turrets[i].guns[j].AdjustRange();
					}
					if(turrets[i].guns[j].ammo[0] == 5 || turrets[i].guns[j].ammo[0] == 6 || turrets[i].guns[j].ammo[0] == 7 || turrets[i].guns[j].ammo[0] == 9 || turrets[i].guns[j].ammo[0] == 11 || turrets[i].guns[j].ammo[0] == 12 || turrets[i].guns[j].ammo[0] == 13 || turrets[i].guns[j].ammo[0] == 14){
						turrets[i].guns[j].gunheat = Math.floor(turrets[i].guns[j].gunheat * d.missileheatmod);
					}
					if(turrets[i].guns[j].ammo[0] >= 100 && turrets[i].guns[j].ammo[0] != 101  && turrets[i].guns[j].ammo[0] != 105){
						turrets[i].guns[j].gunheat = Math.floor(turrets[i].guns[j].gunheat * d.beamheatmod);
					}
					if(turrets[i].guns[j].ammo[0] == 4){
						turrets[i].guns[j].gunheat = Math.floor(turrets[i].guns[j].gunheat * d.plasheatmod);
						if(d.plasmod > 0){
							turrets[i].guns[j].ammo[0] = 10;
						}
					}
					if(turrets[i].guns[j].ammo[0] == 15){
						turrets[i].guns[j].gunheat = Math.floor(turrets[i].guns[j].gunheat * d.darkheatmod);
						if(d.darkmod > 0){
							turrets[i].guns[j].ammo[0] = d.darkmod;
						}
					}
					if(turrets[i].guns[j].ammo[0] == 0 && d.blastermod > 0){
						turrets[i].guns[j].ammo[0] = d.blastermod;
						turrets[i].guns[j].gunheat = Math.ceil(turrets[i].guns[j].gunheat * 1.5);
					}
				}
			}
			
			if(d.freezeboost > 0 || d.acidboost > 0 || d.specialrounds > -1){
				for(j = 0; j < turrets.length; j++){
					for(i = 0; i < turrets[j].guns.length; i++){
						if(d.specialrounds > -1 && turrets[j].guns[i].ammo[0] < 100 && (turrets[j].guns[i].ammo[2] == 3 || turrets[j].guns[i].ammo[2] == 6)){
							turrets[j].guns[i].ammo[2] = d.specialrounds;
						}
						if(d.freezeboost > 0 && turrets[j].guns[i].ammo[2] == 8){
							turrets[j].guns[i].ammo[2] = 10 + d.freezeboost;
						}
						if(d.acidboost > 0 && turrets[j].guns[i].ammo[2] == 1){
							turrets[j].guns[i].ammo[2] = 14 + d.acidboost;
						}
					}
				}
				if(debris == 10){
					if(d.specialrounds > -1){
						debrisammo[2] = d.specialrounds;
					}
					if(d.freezeboost > 0 && debrisammo[2] == 8){
						debrisammo[2] = 10 + d.freezeboost;
					}
					if(d.acidboost > 0 && debrisammo[2] == 1){
						debrisammo[2] = 14 + d.acidboost;
					}
				}
			}
			
			if(tech > 0){
				for(i = 0; i < mom.players.length; i++){
					if(mom.players[i].faction == faction){
						for(j = 0; j < mom.players[i].shipbag.length; j++){
							if(mom.players[i].shipbag[j] != null && mom.players[i].shipbag[j].tech == tech){
								if(mom.players[i].shipbag[j].race == mom.players[i].race){
									upgrades.push(j);
								}
							}
						}
					}
				}
			}
			if(cloak > 0){
				cloaked = 1;
				alpha = .05;
			}
			if(rock == true){
				t = .94 * Math.random();
				spriteIndex = Math.floor(sheetW * sheetH *(t+.5*(1/(sheetW * sheetH))));
				animspeed = Math.round(-4 + 8 * Math.random());
				if(mass > 200 && Math.abs(animspeed) == 1){
					animspeed = 0;
				}
			}
			redrawme = true;
			
			//BIOLAB HACK
			if(s[0] == 180){
				for(i = 0; i < mom.players.length; i++){
					if(mom.players[i].faction == faction){
						for(j = 0; j < mom.players[i].shipbag.length; j++){
							if(mom.players[i].shipbag[j] != null && mom.players[i].shipbag[j].s[0] == 212){
								hangars[0].shiptype = mom.players[i].shipbag[j];
								upgraded = true;
							}
						}
					}
				}
			}
		}
		
		public function Move()
		{
			var i:int;
			x = xx;
			y = yy;
			
			DoAll();
			DoAllStuff();
			
			Explode();
		}
		
		public function DoLights()
		{
			if(frozen == 0){
				switch(lights){
					case 1: //S0
						
					break;
					case 2: //S25
						lightIndex = spriteIndex;
						if(lightclock == 1){
							lightpic.visible = true;
							
						}
						if(lightclock == 3){
							lightpic.visible = false;
						}
						if(lightclock == 100){
							lightclock = 0;
						}
					break;
					case 10: //Shield
						lightIndex = spriteIndex;
						lightclock = 0;
						lightpic.visible = true;
						lightpic.alpha = .6 * tacshield / tacshieldmax + .2;
						if(tacshield == 0){
							lightpic.alpha = 0;
						}
						animspeed = .15 * tacshieldmax / (tacshield + .5);
						if(animspeed > 1){
							animspeed = Math.floor(animspeed);
						}
					break;
					case 11: //CloakField
						lightIndex = spriteIndex;
						lightclock = 0;
						lightpic.visible = true;
						lightpic.alpha = .6;
						lightpic.blendMode = "invert";
					break;
				}
				lightclock++;
			}
		}
		
		public function Upgrade(ss:int)
		{
			var i:int;
			var j:int;
			for(i = 0; i < mom.players.length; i++){
				if(mom.players[i].faction == faction){
					j = i;
					i = mom.players.length;
				}
			}
			if(upgraded == false){
				for(i = 0; i < hangars.length; i++){
					hangars[i].shiptype = mom.players[j].shipbag[ss];
				}
				upgraded = true;
			}
		}
		
		public function DoGraphics()
		{
			var d;
			
			//Lights
			DoLights();
			
			shieldglow = shieldglow - .1;
			if(shieldglow > 1){
				shieldglow = 1;
			}
			if(shieldglow < 0){
				shieldglow = 0;
			}
			if(shield > 0 && shieldglow < .25){
				shieldglow = .25;
			}
			if(shieldpic != null){
				if(shieldglow > 0 && shieldmax > 0){
					shieldpic.visible = true;
					shieldpic.alpha = shieldglow;
				}else{
					shieldpic.visible = false;
				}
			}
		}
	}
}