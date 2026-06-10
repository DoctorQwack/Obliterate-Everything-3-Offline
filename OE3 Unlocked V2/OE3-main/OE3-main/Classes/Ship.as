package 
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	
	public class Ship extends Obj 
	{
		public var speedmax:Number = 5;
		public var turn:Number = 1;
		public var thrust:Number = .5;
		public var jamming:Number = 0;
		public var scanrange:Number = 0;
		
		public var engineburn:Boolean = true;

		public var burn:Number = 0;
		
		public var lowai:int = 0;
		public var midai:int = 0;
		public var highai:int = 0;
		public var targetx:Number;
		public var targety:Number;
		public var targetxv:Number;
		public var targetyv:Number;
		public var targethot:Boolean = false;
		public var targetclock:int = 0;
		public var aitime:int = 0;
		public var aihitclock:int = 100000;
		public var aistopdistance:Number = 100;
		public var aipeacedistance:Number = 300;
		public var aistandoff:int = 120;
		public var aiobj:int;
		public var ships;
		public var structs;
		public var targets:Array = new Array();
		public var guns:Array = new Array();
		public var tech:int = 0;
		public var saucer:Boolean = false;
		public var shipid:int = 0;
		
		public var tstructs:Boolean = true;
		public var tships:Boolean = true;
		public var tshots:Boolean = false;
		public var miner:Boolean = false;
		public var healer:Boolean = false;
		
		public var drawx:Number;
		public var drawy:Number;
		
		public var tcpu:TargetCPU;
		
		public function Ship(m,sd,f,xxx:Number,yyy:Number,xxv:Number,yyv:Number,tt:Number)
		{
			var i:int;
			var j:int;
			var k:int;
			var a:String;
			
			s = new Array();
			for(i = 0; i < sd.s.length;i++){
				s.push(sd.s[i]);
			}
			mom = m;
			xx = xxx;
			yy = yyy;
			drawx = xx;
			drawy = yy;
			x = drawx;
			y = drawy;
			xv = xxv;
			yv = yyv;
			t = tt;
			tv = 0;
			
			ships = mom.ships;
			structs = mom.structs;
			
			highai = sd.highai;
			aistandoff = sd.aistandoff;
			armormax = sd.armormax;
			shieldmax = sd.shieldmax;
			tacshieldmax = sd.tacshieldmax;
			tacshieldr = sd.tacshieldr;
			armorregen = sd.armorregen;
			shieldregen = sd.shieldregen;
			tacshieldregen = sd.tacshieldregen;
			mass = sd.mass;
			speedmax = sd.speedmax;
			turn = sd.turn;
			thrust = sd.thrust;
			energy = sd.energy;
			tech = sd.tech;
			saucer = sd.saucer;
			anim = sd.anim;
			animspeed = sd.animspeed;
			debris = sd.debris;
			debrisammo = sd.debrisammo;
			cloak = sd.cloakmod;
			cloakfieldr = sd.cloakfieldr;
			
			shipid = mom.shipid;
			mom.shipid = mom.shipid + 1;
			
			tstructs = sd.tstructs;
			tships = sd.tships;
			tshots = sd.tshots;
			miner = sd.miner;
			healer = sd.healer;
			
			sheetW = sd.sheetW;
			sheetH = sd.sheetH;
			picref = mom.l.ssships[sd.picid][f];
			burnref = mom.l.ssshipburns[sd.picid][sd.burnmod];
			lightref = mom.l.ssshiplights[sd.picid];
			if(shieldmax > 0){
				shieldref = mom.l.ssshipshields[sd.picid];
			}
			if(sd.transformid >= 0){
				tpicref = mom.l.ssships[sd.transformid][f];
				tburnref = mom.l.ssshipburns[sd.transformid][sd.burnmod];
				tlightref = mom.l.ssshiplights[sd.transformid];
				if(shieldmax > 0){
					tshieldref = mom.l.ssshipshields[sd.transformid];
				}
			}
			spriteW = picref.width / sheetW;
			spriteH = picref.height / sheetH;
			wide = sd.wide;
			high = sd.high;
			lights = sd.lights
			lightclock = 0;
			if(sheetW == 8 && sheetH == 8){
				lightW = sheetW;
				lightH = sheetH;
			}
			
			armor = armormax;
			shield = shieldmax;
			targetx = xx;
			targety = yy;
			targetxv = xv;
			targetyv = yv;
			faction = f;
			targetclock = 30;
			
			armor = armormax;
			shield = shieldmax;
			jamming = 0;
			
			pic = new Bitmap();
			pic.bitmapData = new BitmapData(spriteW,spriteH,true,0x00000000);
			addChild(pic);
			pic.x = Math.round(-.5 * spriteW);
			pic.y = Math.round(-.5 * spriteH);
			
			burnpic = new Bitmap();
			burnpic.bitmapData = new BitmapData(spriteW,spriteH,true,0x00000000);
			addChild(burnpic);
			burnpic.x = Math.round(-.5 * spriteW);
			burnpic.y = Math.round(-.5 * spriteH);
			burnpic.blendMode = "add";
			
			lightpic = new Bitmap();
			lightpic.bitmapData = new BitmapData(spriteW,spriteH,true,0x00000000);
			addChild(lightpic);
			lightpic.x = Math.round(-.5 * spriteW);
			lightpic.y = Math.round(-.5 * spriteH);
			lightpic.blendMode = "add";
			
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
			
			for(i = 0; i < sd.hangars.length; i++){
				mom.GenHangar(this,sd.hangars[i][0],sd.hangars[i][1],sd.hangars[i][2]);
				hangars[i].shiptype = new ShipData(sd.hangarships[i]);
				hangars[i].launchheat = hangars[i].launchheat * sd.hangarlaunchheatmod;
				hangars[i].launchcool = hangars[i].launchheat;
				hangars[i].shipspeed = hangars[i].shipspeed * sd.hangarlaunchspeedmod;
				hangars[i].launchburstmax = hangars[i].launchburstmax + sd.hangarnummod;
				hangars[i].launchburst = hangars[i].launchburstmax;
				
				//TECH MODS
				hangars[i].shiptype.gunrangemod = sd.gunrangemod;
				hangars[i].shiptype.gunheatmod = sd.gunheatmod;
				hangars[i].shiptype.missileheatmod = sd.missileheatmod;
				hangars[i].shiptype.beamheatmod = sd.beamheatmod;
				hangars[i].shiptype.plasheatmod = sd.plasheatmod;
				hangars[i].shiptype.darkheatmod = sd.darkheatmod;
				hangars[i].shiptype.freezeboost = sd.freezeboost;
				hangars[i].shiptype.acidboost = sd.acidboost;
				hangars[i].shiptype.specialrounds = sd.specialrounds;
				hangars[i].shiptype.plasmod = sd.plasmod;
				hangars[i].shiptype.darkmod = sd.darkmod;
				hangars[i].shiptype.blastermod = sd.blastermod;
				
				//Exhumer Nerf
				if(s[0] == 260)
				{
					hangars[i].launchheat = hangars[i].launchheat + 15;
					hangars[i].launchcool = hangars[i].launchcool + 15;
				}
			}
			if(sd.plasmod > 0 && debris == 10 && debrisammo[0] == 4){
				debrisammo[0] = 10;
			}
			for(i = 0; i < sd.guns.length; i++){
				guns[i] = new Gun(mom, this, sd.guns[i],sd.ammos[i]);
				if(sd.gunrangemod != 1){
					guns[i].gunrange = guns[i].gunrange * sd.gunrangemod;
					guns[i].AdjustRange();
				}
				if(guns[i].gunrange > scanrange){
					scanrange = guns[i].gunrange;
				}
				guns[i].gunheat = Math.floor(guns[i].gunheat * sd.gunheatmod);
				if(guns[i].ammo[0] == 5 || guns[i].ammo[0] == 6 || guns[i].ammo[0] == 7 || guns[i].ammo[0] == 9 || guns[i].ammo[0] == 11 || guns[i].ammo[0] == 12 || guns[i].ammo[0] == 13 || guns[i].ammo[0] == 14){
					guns[i].gunheat = Math.floor(guns[i].gunheat * sd.missileheatmod);
				}
				if(guns[i].ammo[0] >= 100 && guns[i].ammo[0] != 101  && guns[i].ammo[0] != 105){
					guns[i].gunheat = Math.floor(guns[i].gunheat * sd.beamheatmod);
				}
				if(guns[i].ammo[0] == 4){
					guns[i].gunheat = Math.floor(guns[i].gunheat * sd.plasheatmod);
					if(sd.plasmod > 0){
						guns[i].ammo[0] = 10;
					}
				}
				if(guns[i].ammo[0] == 0 && sd.blastermod > 0){
					guns[i].ammo[0] = sd.blastermod;
					guns[i].gunheat = Math.ceil(guns[i].gunheat * 1.25);
				}
				if(guns[i].ammo[0] == 15){
					guns[i].gunheat = Math.floor(guns[i].gunheat * sd.darkheatmod);
					if(sd.darkmod > 0){
						guns[i].ammo[0] = sd.darkmod;
					}
				}
			}
			
			for(i = 0; i < sd.turrets.length; i++){
				mom.GenTurret(this,new Array(sd.turrets[i][0],sd.turrets[i][3],sd.turrets[i][4],sd.turrets[i][5]),sd.turrets[i][1],sd.turrets[i][2]);
			}
			for(i = 0; i < turrets.length; i++){
				for(j = 0; j < turrets[i].guns.length; j++){
					if(sd.gunrangemod != 1){
						turrets[i].guns[j].gunrange = turrets[i].guns[j].gunrange * sd.gunrangemod;
						turrets[i].guns[j].AdjustRange();
					}
					if(turrets[i].guns[j].gunrange > scanrange){
						scanrange = turrets[i].guns[j].gunrange;
					}
					turrets[i].guns[j].gunheat = Math.floor(turrets[i].guns[j].gunheat * sd.gunheatmod);
					if(turrets[i].guns[j].ammo[0] == 5 || turrets[i].guns[j].ammo[0] == 6 || turrets[i].guns[j].ammo[0] == 7 || turrets[i].guns[j].ammo[0] == 9 || turrets[i].guns[j].ammo[0] == 11 || turrets[i].guns[j].ammo[0] == 12 || turrets[i].guns[j].ammo[0] == 13 || turrets[i].guns[j].ammo[0] == 14){
						turrets[i].guns[j].gunheat = Math.floor(turrets[i].guns[j].gunheat * sd.missileheatmod);
					}
					if(turrets[i].guns[j].ammo[0] >= 100 && turrets[i].guns[j].ammo[0] != 101  && turrets[i].guns[j].ammo[0] != 105){
						turrets[i].guns[j].gunheat = Math.floor(turrets[i].guns[j].gunheat * sd.beamheatmod);
					}
					if(turrets[i].guns[j].ammo[0] == 4){
						turrets[i].guns[j].gunheat = Math.floor(turrets[i].guns[j].gunheat * sd.plasheatmod);
						if(sd.plasmod > 0){
							turrets[i].guns[j].ammo[0] = 10;
						}
					}
					if(turrets[i].guns[j].ammo[0] == 0 && sd.blastermod > 0){
						turrets[i].guns[j].ammo[0] = sd.blastermod;
						turrets[i].guns[j].gunheat = Math.ceil(turrets[i].guns[j].gunheat * 1.5);
					}
					if(turrets[i].guns[j].ammo[0] == 15){
						turrets[i].guns[j].gunheat = Math.floor(turrets[i].guns[j].gunheat * sd.darkheatmod);
						if(sd.darkmod > 0){
							turrets[i].guns[j].ammo[0] = sd.darkmod;
						}
					}
				}
			}
			
			if(sd.freezeboost > 0 || sd.acidboost > 0 || sd.specialrounds > -1){
				for(i = 0; i < guns.length; i++){
					if(sd.specialrounds > -1 && guns[i].ammo[0] < 100 && (guns[i].ammo[2] == 3 || guns[i].ammo[2] == 6)){
						guns[i].ammo[2] = sd.specialrounds;
					}
					if(sd.freezeboost > 0 && guns[i].ammo[2] == 8){
						guns[i].ammo[2] = 10 + sd.freezeboost;
					}
					if(sd.acidboost > 0 && guns[i].ammo[2] == 1){
						guns[i].ammo[2] = 14 + sd.acidboost;
					}
				}
				for(j = 0; j < turrets.length; j++){
					for(i = 0; i < turrets[j].guns.length; i++){
						if(sd.specialrounds > -1 && turrets[j].guns[i].ammo[0] < 100 && (turrets[j].guns[i].ammo[2] == 3 || turrets[j].guns[i].ammo[2] == 6)){
							turrets[j].guns[i].ammo[2] = sd.specialrounds;
						}
						if(sd.freezeboost > 0 && turrets[j].guns[i].ammo[2] == 8){
							turrets[j].guns[i].ammo[2] = 10 + sd.freezeboost;
						}
						if(sd.acidboost > 0 && turrets[j].guns[i].ammo[2] == 1){
							turrets[j].guns[i].ammo[2] = 14 + sd.acidboost;
						}
					}
				}
				if(debris == 10){
					if(sd.specialrounds > -1){
						debrisammo[2] = sd.specialrounds;
					}
					if(sd.freezeboost > 0 && debrisammo[2] == 8){
						debrisammo[2] = 10 + sd.freezeboost;
					}
					if(sd.acidboost > 0 && debrisammo[2] == 1){
						debrisammo[2] = 14 + sd.acidboost;
					}
				}
			}
			if(cloak > 0){
				cloaked = 1;
				alpha = .05;
			}
			
			tcpu = new TargetCPU( mom, this);
			tcpu.miner = miner;
			tcpu.healer = healer;
			tcpu.tshots = tshots;
			tcpu.tships = tships;
			tcpu.tstructs = tstructs;
			
			redrawme = true;
			
			//Spectre Hack
			if(s[0] == 214){
				for(i = 0; i < guns.length; i++)
				{
					if(guns[i].gunrange > aistandoff){
						aistandoff = guns[i].gunrange;
					}
				}
			}
		}
		
		/*public function Die()
		{
			var i:int;
			var j:int;
			var a;
			var b;
			for(i = 0; i < mom.ships.length; i++){
				a = mom.ships[i];
				for(j = 0; j < a.targets.length; j++){
					if(a.targets[j] == this){
						a.targets.splice(j,1);
						j = a.targets.length;
					}
				}
			}
			if(engineburn == true){
				burnpic.bitmapData.dispose();
			}
			if(shieldpic != null){
				shieldpic.bitmapData.dispose();
			}
			if(lights > 0){
				lightpic.bitmapData.dispose();
			}
			pic.bitmapData.dispose();
			targets = [];
		}*/
		
		public function DoAI()
		{
			var i:int;
			
			if(aihitclock < 100000){
				aihitclock++;
			}
			DoAITargets()
			DoAIHigh();
			DoAIMid();
			DoAILow();
			if(targethot == true){
				DoAIGuns();
			}
			targetclock++;
		}
		
		public function DoAIGuns()
		{
			var i:int;
			var j:int;
			var k:int;
			var tb:Number; //PositionThetaToTarget
			var d:Number; //RotateDistance
			var dd:Number; //Target Distance
			var g;
			tb = (Math.atan2(yy-targety,xx-targetx)-1.57)/(6.283)
			d = Tools.MathRotateDirection(t,tb);
			dd = (xx-targetx)*(xx-targetx)+(yy-targety)*(yy-targety);
			for(i = 0; i < guns.length; i++){
				g = guns[i];
				g.active = false;
				if(Math.abs(d) < g.gunangle && g.gunrange * g.gunrange > dd){
					g.active = true;
				}
				if(targets.length == 0){
					g.active = false;
				}
				if(armor <= 0){
					g.active = false;
				}
				g.DoStuff();
			}
		}
		
		/*public function DoAITargets()
		{
			var i:int;
			var j:int;
			var tx:Number;
			var ty:Number;
			var d:Number;
			var davg:Number;
			var did:int;
			var cull:int = 10;
			var bad:Boolean;
			
			//CullDead
			i = targets.length - 1;
			while(i > -1){
				if(targets[i] == null || (targets[i] != null && targets[i].armor <= 0)){
					targets.splice(i,1);
				}
				i--;
			}
			
			//Slow Scan Check
			if(targetclock == 0 && aiscanhostile == true){
				//targets = new Array();
				d = scanrange * scanrange;
				//Ships
				for(i = 0; i < ships.length; i++){
					if(this != ships[i] && mom.alliances.a[faction][ships[i].faction] == 0 && ships[i].armor > 0){
						tx = ships[i].x;
						ty = ships[i].y;
						if((tx - x) * (tx - x) + (ty - y) * (ty - y) < d){
							bad = false;
							for(j = 0; j < targets.length; j++){
								if(ships[i] == targets[j]){
									bad = true;
								}
							}
							if(bad == false){
								targets.push(ships[i]);
							}
						}
					}
				}
				
				targetclock = Math.floor(ships.length);
				if(targetclock > 120){
					targetclock = 120;
				}
				if(targetclock < 30){
					targetclock = 30;
				}
			}else{
				targetclock = targetclock - 1
			}
		}*/
		
		public function DoAITargets()
		{
			var i:int;
			var r:Number;
			if(targetclock % 10 == 0 || targets.length == 0){
				targets = new Array();
				r = scanrange * 1.25;
				tcpu.DoAITargets(targets,1,xx,yy,r);
			}else{
				tcpu.DoAICleanTargets(targets);
			}
		}
		
		public function DoAIHigh()
		{
			var i:int;
			var j:int;
			var k:int;
			var aitempa:int;
			var good:Boolean;
			if(armor <= 0){
				highai = 0;
				midai = 0;
				lowai = 0;
			}
			if(aitime > 0){
				aitime = aitime - 1;
			}
			switch(highai){
				case 1: //Regular 
					midai = 1;
				break;
				case 10: //Saucer 
					midai = 10;
				break;
				case 11: //Mine 
					midai = 11;
				break;
				case 12: //Infestor 
					midai = 12;
				break;
				case 13: //Combat Form 
					midai = 1;
					if(clock > 200){
						armor = -100;
						for(i = 0; i < mom.players.length; i++){
							if(mom.players[i].faction == faction){
								j = i;
							}
						}
						aitempa = -1;
						for(k = 0; k < mom.players[j].shipbag.length; k++){
							if(s[0] == 213 && mom.players[j].shipbag[k] != null && mom.players[j].shipbag[k].s[0] == 262){
								aitempa = k;
							}
							if(s[0] == 262 && mom.players[j].shipbag[k] != null && mom.players[j].shipbag[k].s[0] == 304){
								aitempa = k;
							}
							if(s[0] == 304 && mom.players[j].shipbag[k] != null && mom.players[j].shipbag[k].s[0] == 305){
								aitempa = k;
							}
						}
						if(aitempa != -1){
							mom.GenShip(mom.players[j].shipbag[aitempa],faction,xx,yy,xv,yv,t);
						}
					}
				break;
				case 14: //Spectre
					midai = 14;
				break;
			}
		}
		
		public function DoAIMid()
		{
			var i:int;
			var j:int;
			var k:int;
			var aitempa:int;
			var aitempb:int;
			var tx:Number;
			var ty:Number;
			var tr:Number;
			var tt:Number;
			var tb:Number;
			var d:Number;
			var dd:Number;
			var davg:Number;
			var did:int;
			var a;
			targethot = false;
			switch(midai){
				case 1: //Combat
					//QuickScan
					a = DoAIQuickScan();
					did = a[0];
					d = a[1];
					if(did > -1){
						targetx = targets[did].xx;
						targety = targets[did].yy;
						targetxv = targets[did].xv;
						targetyv = targets[did].yv;
						targethot = true;
						if(d < aistandoff){
							lowai = 1;
						}else{
							lowai = 6;
						}
					}else{
						lowai = 2;
						targetx = .5 * mom.mapx;
						targety = .5 * mom.mapy;
						targetxv = 0;
						targetyv = 0;
					}
					if(xx < -100 || xx > mom.mapx + 100 || yy < -100 || yy > mom.mapy + 100 ){
						targetx = .5 * mom.mapx;
						targety = .5 * mom.mapy;
						lowai = 6;
					}
				break;
				case 2: //Combat Large
					//QuickScan
					a = DoAIQuickScan();
					did = a[0];
					d = a[1];
					if(did > -1){
						targetx = targets[did].xx;
						targety = targets[did].yy;
						targetxv = targets[did].xv;
						targetyv = targets[did].yv;
						targethot = true;
						if(d < aistandoff){
							lowai = 1;
						}else{
							lowai = 6;
						}
					}else{
						lowai = 2;
						targetx = .5 * mom.mapx;
						targety = .5 * mom.mapy;
						targetxv = 0;
						targetyv = 0;
					}
					if(xx < -100 || xx > mom.mapx + 100 || yy < -100 || yy > mom.mapy + 100 ){
						targetx = .5 * mom.mapx;
						targety = .5 * mom.mapy;
						lowai = 5;
					}
				break;
				case 10: //Saucer
					//QuickScan
					a = DoAIQuickScan();
					did = a[0];
					d = a[1];
					if(did > -1){
						targetx = targets[did].xx;
						targety = targets[did].yy;
						targetxv = targets[did].xv;
						targetyv = targets[did].yv;
						targethot = true;
						if(d < aistandoff){
							lowai = -1;
						}else{
							lowai = 7;
						}
					}else{
						lowai = 2;
						targetx = .5 * mom.mapx;
						targety = .5 * mom.mapy;
						targetxv = 0;
						targetyv = 0;
					}
					if(xx < -100 || xx > mom.mapx + 100 || yy < -100 || yy > mom.mapy + 100 ){
						targetx = .5 * mom.mapx;
						targety = .5 * mom.mapy;
						lowai = 7;
						trace("GO CENTER");
					}
				break;
				case 11: //Mine
					//QuickScan
					a = DoAIQuickScan();
					did = a[0];
					d = a[1];
					if(did > -1 && d < aistandoff){
						targetx = targets[did].xx;
						targety = targets[did].yy;
						targetxv = targets[did].xv;
						targetyv = targets[did].yv;
						targethot = true;
						lowai = 7;
						if(d < 15){
							armor = -100;
							xv = 0;
							yv = 0;
						}
					}else{
						lowai = -1;
						targetx = .5 * mom.mapx;
						targety = .5 * mom.mapy;
						targetxv = 0;
						targetyv = 0;
					}
					xv = xv * .9;
					yv = yv * .9;
					if(xx < -100 || xx > mom.mapx + 100 || yy < -100 || yy > mom.mapy + 100 ){
						armor = -100;
					}
					if(clock > 200){
						armor = -100;
					}
				break;
				case 12: //Infestors
					//QuickScan
					a = DoAIQuickScan();
					did = a[0];
					d = a[1];
					if(did > -1){
						targetx = targets[did].xx;
						targety = targets[did].yy;
						targetxv = targets[did].xv;
						targetyv = targets[did].yv;
						targethot = true;
						lowai = 6;
						if(d < targets[did].wide + wide){
							armor = -100;
							xv = 0;
							yv = 0;
							if(targets[did].shield == 0){
								targets[did].xv = 0;
								targets[did].yv = 0;
								targets[did].armor = -100;
								if(targets[did].debris != 10){
									targets[did].debris = 20;
									for(i = 0; i < mom.players.length; i++){
										if(mom.players[i].faction == faction){
											j = i;
										}
									}
									aitempa = -1;
									if(targets[did] is Ship){
										for(k = 0; k < mom.players[j].shipbag.length; k++){
											if(mom.players[j].shipbag[k] != null){
												if(targets[did].mass < 10 && mom.players[j].shipbag[k].s[0] == 213){
													aitempa = k;
												}
												if(targets[did].mass >= 10 && targets[did].mass < 50 && mom.players[j].shipbag[k].s[0] == 262){
													aitempa = k;
												}
												if(targets[did].mass >= 50 && mom.players[j].shipbag[k].s[0] == 304){
													aitempa = k;
												}
											}
										}
										if(aitempa != -1){
											mom.GenShip(mom.players[j].shipbag[aitempa],faction,targets[did].xx,targets[did].yy,targets[did].xv,targets[did].yv,targets[did].t);
										}
									}
								}
							}
						}
					}
					if(xx < -100 || xx > mom.mapx + 100 || yy < -100 || yy > mom.mapy + 100 ){
						armor = -100;
					}
					if(clock > 200){
						armor = -100;
					}
				break;
				case 14: //Spectre
					//QuickScan
					a = DoAIQuickScan();
					did = a[0];
					d = a[1];
					if(transformed == true){
						DoCommand(4);
						DoCommand(4);
					}
					if(transformcool > 0){
						transformcool--;
					}
					if(did > -1){
						targetx = targets[did].xx;
						targety = targets[did].yy;
						targetxv = targets[did].xv;
						targetyv = targets[did].yv;
						tb = (Math.atan2(yy-targety,xx-targetx)-1.57)/(6.283)
						dd = Tools.MathRotateDirection(t,tb);
						if(transformcool == 0){
							if(d < aistandoff && Math.abs(dd) < .05){
								lowai = -1;
								if(transformed == false){
									redrawme = true;
									transformcool = 5;
								}
								transformed = true;
							}else{
								lowai = 6;
								if(transformed == true){
									redrawme = true;
									transformcool = 5;
								}
								transformed = false;
							}
						}
					}else{
						if(transformcool == 0){
							lowai = 2;
							targetx = .5 * mom.mapx;
							targety = .5 * mom.mapy;
							targetxv = 0;
							targetyv = 0;
							if(transformed == true){
								redrawme = true;
								transformcool = 5;
							}
							transformed = false;
						}
					}
					if(xx < -100 || xx > mom.mapx + 100 || yy < -100 || yy > mom.mapy + 100 ){
						if(transformcool == 0){
							targetx = .5 * mom.mapx;
							targety = .5 * mom.mapy;
							lowai = 6;
							if(transformed == true){
								redrawme = true;
								transformcool = 5;
							}
							transformed = false;
						}
					}
					targethot = transformed;
				break;
			}
		}
		
		public function DoAILow()
		{
			var i:int;
			
			var tb:Number; //PositionThetaToTarget
			var d:Number; //RotateDistance
			var v:Number; //Velocity
			var vt:Number; //VelocityTheta
			var c:Number; //tuning constant
			
			var d_vx:Number; //desired velocity
			var d_vy:Number; //desired velocity
			var s_vx:Number; //steering velocity
			var s_vy:Number; //steering velocity
			var st:Number; //steering theta
			
			var dt:Number; //Distance to Target
			
			var db:Number; //Alternate distance
			var dc:Number; //Alternate distance
			
			if(targetx == xx){
				targetx = targetx + 1;
			}
			if(targety == yy){
				targety = targety + 1;
			}
			
			switch(lowai){
				case 1: //Point at Target
					tb = (Math.atan2(yy-targety,xx-targetx)-1.57)/(6.283)
					d = Tools.MathRotateDirection(t,tb);
					if(Math.abs(d) < turn){
						d = 0;
						t = tb;
					}
					if(d < -.01){
						DoCommand(1);
					}
					if(d > .01){
						DoCommand(2);
					}
				break;
				case 2: //Seek Static Target Flyby
					d_vx = -1*speedmax*(xx-targetx)/Math.sqrt(Math.pow(xx-targetx,2)+Math.pow(yy-targety,2));
					d_vy = -1*speedmax*(yy-targety)/Math.sqrt(Math.pow(xx-targetx,2)+Math.pow(yy-targety,2));
					s_vx = d_vx - xv;
					s_vy = d_vy - yv;
					st = (Math.atan2(s_vy,s_vx)+1.57)/(6.283)
					if(st < 0){
						st = st + 1;
					}
					//Calculate Turns
					d = -1*Tools.MathRotateDirection(st,t);
					if(Math.abs(d) < turn){
						d = 0;
						t = st;
					}
					if(d < -.01){
						DoCommand(1);
					}
					if(d > .01){
						DoCommand(2);
					}
					//Do Thrust
					d = Tools.MathRotateDirection(t,st);
					if(Math.abs(d) < .01){
						DoCommand(3);
					}
				break;
				case 3: //Seek Static Target and Dock
					aistopdistance = 100;
					d_vx = -1*speedmax*(xx-targetx)/Math.sqrt(Math.pow(xx-targetx,2)+Math.pow(yy-targety,2));
					d_vy = -1*speedmax*(yy-targety)/Math.sqrt(Math.pow(xx-targetx,2)+Math.pow(yy-targety,2));
					s_vx = d_vx - xv;
					s_vy = d_vy - yv;
					st = (Math.atan2(s_vy,s_vx)+1.57)/(6.283)
					if(st < 0){
						st = st + 1
					}
					//Calculate Turns
					d = -1*Tools.MathRotateDirection(st,t);
					if(Math.abs(d) < turn){
						d = 0;
						t = st;
					}
					if(d < -.01){
						DoCommand(1);
					}
					if(d > .01){
						DoCommand(2);
					}
					//Do Thrust
					dt = Math.sqrt(Math.pow(xx-targetx,2)+Math.pow(yy-targety,2))
					d = Tools.MathRotateDirection(t,st);
					if(Math.abs(d) < .01 && dt > aistopdistance + 1){
						DoCommand(3);
					}
					if(dt < aistopdistance){
						DoCommand(4);
					}
				break;
				case 4: //Flee and Stop
					aistopdistance = 200;
					d_vx = -1*speedmax*(xx-targetx)/Math.sqrt(Math.pow(xx-targetx,2)+Math.pow(yy-targety,2));
					d_vy = -1*speedmax*(yy-targety)/Math.sqrt(Math.pow(xx-targetx,2)+Math.pow(yy-targety,2));
					s_vx = -1*(d_vx - xv);
					s_vy = -1*(d_vy - yv);
					st = (Math.atan2(s_vy,s_vx)+1.57)/(6.283)
					if(st < 0){
						st = st + 1;
					}
					//Calculate Turns
					d = -1*Tools.MathRotateDirection(st,t);
					if(Math.abs(d) < turn){
						d = 0;
						t = st;
					}
					if(d < -.01){
						DoCommand(1);
					}
					if(d > .01){
						DoCommand(2);
					}
					//Do Thrust
					dt = Math.sqrt(Math.pow(xx-targetx,2)+Math.pow(yy-targety,2))
					d = Tools.MathRotateDirection(t,st);
					if(Math.abs(d) < .25 && dt < aistopdistance - 10){
						DoCommand(3);
					}
					if(dt > aistopdistance){
						DoCommand(4);
					}
				break;
				case 5: //Pursuit
					c = .2*Math.sqrt(Math.pow(xx-targetx,2)+Math.pow(yy-targety,2))
					if(Math.sqrt(targetxv*targetxv + targetyv*targetyv) > 6){
						c = .1*Math.sqrt(Math.pow(xx-targetx,2)+Math.pow(yy-targety,2));
					}
					d_vx = -1*speedmax*(xx-targetx-c*targetxv)/Math.sqrt(Math.pow(xx-targetx-c*targetxv,2)+Math.pow(yy-targety-c*targetyv,2));
					d_vy = -1*speedmax*(yy-targety-c*targetyv)/Math.sqrt(Math.pow(xx-targetx-c*targetxv,2)+Math.pow(yy-targety-c*targetyv,2));
					s_vx = d_vx - xv;
					s_vy = d_vy - yv;
					st = (Math.atan2(s_vy,s_vx)+1.57)/(6.283)
					if(st < 0){
						st = st + 1
					}
					//Calculate Turns
					d = -1*Tools.MathRotateDirection(st,t);
					if(Math.abs(d) < turn){
						d = 0;
						t = st;
					}
					if(d < -.01){
						DoCommand(1);
					}
					if(d > .01){
						DoCommand(2);
					}
					//Do Thrust
					d = Tools.MathRotateDirection(t,st);
					if(Math.abs(d) < .05){
						DoCommand(3);
					}
				break;
				case 6: //Point and Thrust
					d_vx = -1*speedmax*(xx-targetx)/Math.sqrt(Math.pow(xx-targetx,2)+Math.pow(yy-targety,2));
					d_vy = -1*speedmax*(yy-targety)/Math.sqrt(Math.pow(xx-targetx,2)+Math.pow(yy-targety,2));
					/*s_vx = d_vx - xv;
					//s_vy = d_vy - yv;
					st = (Math.atan2(s_vy,s_vx)+3.141592/2)/(3.141592*2)
					if(st < 0){
						st = st + 1;
					}*/
					st = (Math.atan2(d_vy,d_vx)+1.57)/(6.283)
					if(st < 0){
						st = st + 1;
					}
					//Calculate Turns
					d = -1*Tools.MathRotateDirection(st,t);
					if(Math.abs(d) < turn){
						d = 0;
						t = st;
					}
					if(d < -.01){
						DoCommand(1);
					}
					if(d > .01){
						DoCommand(2);
					}
					//Do Thrust
					d = Tools.MathRotateDirection(t,st);
					db = (Math.atan2(yv,xv)+1.57)/(6.283)
					if(db < 0){
						db = db + 1;
					}
					dc = Tools.MathRotateDirection(db,st);
					if(Math.abs(d) < .01 && ((xv*xv + yv*yv) < (.9 * speedmax) * (.9 * speedmax) || Math.abs(dc) > 0.009)){
						DoCommand(3);
					}
				break;
				case 7: //Saucer Intercept
					d_vx = -1*speedmax*(xx-targetx)/Math.sqrt(Math.pow(xx-targetx,2)+Math.pow(yy-targety,2));
					d_vy = -1*speedmax*(yy-targety)/Math.sqrt(Math.pow(xx-targetx,2)+Math.pow(yy-targety,2));
					
					st = (Math.atan2(d_vy,d_vx)+1.57)/(6.283)
					if(st < 0){
						st = st + 1;
					}
					
					t = st;
					
					//Do Thrust
					db = (Math.atan2(yv,xv)+1.57)/(6.283)
					if(db < 0){
						db = db + 1;
					}
					dc = Tools.MathRotateDirection(db,st);
					if((xv*xv + yv*yv) < (.9 * speedmax) * (.9 * speedmax)|| Math.abs(dc) > 0.009){
						DoCommand(3);
					}
				break;
			}
		}
		
		public function DoAIQuickScan()
		{
			var i:int;
			var d:Number;
			var did:int;
			var tx:Number;
			var ty:Number;
			
			did = -1
			d = 10000000;
			for(i = 0; i < targets.length; i++){
				if(targets[i] != null && targets[i].armor > 0){
					tx = targets[i].xx;
					ty = targets[i].yy;
					if(Math.sqrt((tx - xx) * (tx - xx) + (ty - yy) * (ty - yy)) < d){
						d = Math.sqrt((tx - xx) * (tx - xx) + (ty - yy) * (ty - yy));
						did = i;
					}
				}
			}
			
			return(new Array(did,d));
		}
		
		public function DoCommand(c:int)
		{
			if(1){
				switch(c){
					case 1: //turn left
						t = t - turn
					break;
					case 2: //turn right
						t = t + turn
					break;
					case 3: //thrust
						if(Math.sqrt(Math.pow(xv + (thrust)*Math.sin(t*6.283),2)+Math.pow(yv - (thrust)*Math.cos(t*6.283),2)) < speedmax){
							xv = xv + thrust*Math.sin(t*6.283);
							yv = yv - thrust*Math.cos(t*6.283);
						}else{
							xv = xv *.9;
							yv = yv *.9;
						}
						if(engineburn == true){
							if(burn + .5 < 1){
								burn = burn + .5;
							}else{
								burn = 1;
							}
						}
					break;
					case 4: //brake
						xv = xv *.9;
						yv = yv *.9;
						if(Math.abs(xv) < .1){
							xv = 0;
						}
						if(Math.abs(yv) < .1){
							yv = 0;
						}
					break;
				}
			}
		}
		
		public function DoGraphics()
		{
			var d;
			//Interpolate
			d = .02 * Math.sqrt((xx - drawx) * (xx - drawx) + (yy - drawy) * (yy - drawy));
			drawx = drawx + (xx - drawx) * .25;
			drawy = drawy + (yy - drawy) * .25;
			x = Math.floor(drawx);
			y = Math.floor(drawy);
			//Lights
			DoLights();
			
			//Burn
			burn = burn - .05;
			if(burn > 1){
				burn = 1;
			}
			if(burn < 0){
				burn = 0;
			}
			if(burnpic != null){
				burnpic.alpha = burn;
				if(burn > 0){
					burnpic.visible = true;
				}else{
					burnpic.visible = false;
				}
			}
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
		
		public function DoLights()
		{
			lightpic.visible = false;
			if(frozen == 0){
				switch(lights){
					case 1: //Piranha
						lightpic.alpha = .8;
						if(lightclock > 1 && lightclock < 6){
							lightpic.visible = true;
						}
						if(lightclock > 10 && lightclock < 15){
							lightpic.visible = true;
						}
						if(lightclock > 70){
							lightclock = 0;
						}
					break;
					case 50: //Puma
						lightpic.alpha = .8;
						if(lightclock > 1 && lightclock < 4){
							lightpic.visible = true;
						}
						if(lightclock > 50){
							lightclock = 0;
						}
					break;
					case 150: //Shielded
						lightclock = 0;
						lightpic.visible = true;
						lightpic.alpha = .6 * tacshield / tacshieldmax + .2;
						if(tacshield == 0){
							lightpic.alpha = 0;
						}
					break;
				}
				lightIndex = spriteIndex;
				lightclock++;
			}
		}
		
		public function Move()
		{
			var i:int;
			//Mutual
			DoAll();
			//AI
			if(frozen == 0){
				DoAI();
			}
			
			//State Update
			xx = xx + xv;
			yy = yy + yv;
			t = t + tv;
			if(miner == true && clock > 150){
				tcpu.miner = false;
			}
			if(healer == true && clock > 150){
				//tcpu.healer = false;
			}
			
			//Boundary Conditions
			if(xv * xv + yv * yv > speedmax * speedmax){
				xv = xv * .95;
				yv = yv * .95;
			}
			if(t > 1){
				t = t - 1;
			}
			if(t < 0){
				t = t + 1;
			}
			if(Math.abs(tv) > turn){
				tv = tv * .95;
			}
			
			//Events
			Explode();
			if(armor < 0){
				//DIE
			}
			
			DoAllStuff();
		}
	}
}