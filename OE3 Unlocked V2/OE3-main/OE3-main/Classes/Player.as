package
{
	public class Player
	{
		public var mom;
		public var structs;
		public var mystructs = new Array();
		public var rocks = new Array();
		public var structbag:Array = new Array();
		public var shipbag:Array = new Array();
		public var techbag:Array = new Array();
		public var faction:int = 0;
		public var race:int = 0;
		public var energy:Number = 500;
		public var energyrate:Number = 0;
		public var metal:Number = 0;
		public var metalrate:Number = 0;
		public var metalmined:Number = 0;
		public var metalclock:int = 20;
		public var building;
		public var map:Array = new Array();
		public var mapwide:int;
		public var maphigh:int;
		public var stations:Array = new Array();
		public var dead:Boolean = false;
		public var cpu:Boolean = false;
		public var teamcolor:int = 0;
		public var buildrange:Number = 4.8;
		
		//AI
		public var aiplanstruct:int = -1;
		public var aiupgradestruct;
		public var aienergystruct:int = -1;
		public var aiminingstruct:int = -1;
		public var aifighterstruct:int = -1;
		public var aimediumstruct:int = -1;
		public var aicapitalstruct:int = -1;
		public var aifighteraship:int = -1;
		public var aifighterbship:int = -1;
		public var aimediumaship:int = -1;
		public var aimediumbship:int = -1;
		public var aicapitalship:int = -1;
		public var aiturreta:int = -1;
		public var aiturretb:int = -1;
		public var aiphalanx:int = -1;
		public var aishield:int = -1;
		public var aiprocessorstruct:int = -1;
		public var aireactionmax:int = 5; //Frames in between moves.
		public var aireactiont:int = 0;
		public var aibasex:int;
		public var aibasey:int;
		public var aieconx:int;
		public var aiecony:int;
		public var aiminingx:int;
		public var aiminingy:int;
		public var aiturretx:int;
		public var aiturrety:int;
		
		public var aiupgradescore:Number = 0;
		public var aieconscore:Number = 0;
		public var aimetalscore:Number = 0;
		public var aidefensescore:Number = 0;
		public var aioffensescore:Number = 0;
		public var aitechascore:Number = 0;
		public var aitechbscore:Number = 0;
		public var aiturretascore:Number = 0;
		public var aifighterascore:Number = 0;
		public var aifighterbscore:Number = 0;
		public var aimediumascore:Number = 0;
		public var aimediumbscore:Number = 0;
		public var aicapitalscore:Number = 0;
		public var aitechamax:Number = 4;
		public var aitechbmax:Number = 2;
		public var aifighteramax:Number = 3;
		public var aimediumamax:Number = 2;
		public var aiturretamax:Number = 3;
		
		public var aieconscoreco:Number = 1;
		public var aimetalscoreco:Number = 3;
		public var aidefensescoreco:Number = 3;//4
		public var aioffensescoreco:Number = 2;
		
		public var aimetalscoreoff:Number = 7;
		public var aioffensescoreoff:Number = 3;
		
		public var aihandicap:Number = 1;
		
		public function Player(m,f:int,tc:int,a,b,c,ccpu:Boolean)
		{
			var i:int;
			mom = m;
			structs = mom.structs;
			faction = f;
			cpu = ccpu;
			teamcolor = tc;
			
			if(a.length > 0 && a[0].s[0] == 0){
				race = 0;
			}
			if(a.length > 0 && a[0].s[0] == 80){
				race = 0;
				c.push(new TechData([355,0,0,0]));
				c.push(new TechData([355,0,0,0]));
			}
			if(a.length > 0 && a[0].s[0] == 1){
				race = 1;
			}
			if(a.length > 0 && a[0].s[0] == 2){
				race = 2;
			}
			
			//VARIATION
			if(Math.random() > 0.5){
				aifighteramax = aifighteramax - 1;
			}
			if(Math.random() > 0.75){
				aitechbmax = aitechbmax - 1;
			}
			if(Math.random() > 0.5){
				aimediumamax = aimediumamax - 1;
			}
			
			SetupArmory(a,b,c);
			SetupTech();
		}
		
		public function AIAssignStructs()
		{
			var i:int;
			var j:int;
			var temp:int;
			var a;
			var b;
			//Structs
			for(i = 0; i < structbag.length; i++){
				a = structbag[i];
				if(a != null){
					if(a.energy > 0 && a.base == false){
						aienergystruct = i;
					}
					if(a.miner == true && a.base == false){
						aiminingstruct = i;
					}
					if(a.hangars.length > 0 && a.tech == 1){
						aifighterstruct = i;
					}
					if(a.hangars.length > 0 && a.tech == 2){
						aimediumstruct = i;
					}
					if(a.hangars.length > 0 && a.tech == 3){
						aicapitalstruct = i;
					}
					if(a.metal < 0 && a.energy > 0){
						aiprocessorstruct = i;
					}
					if(a.s[0] == 175){
						aishield = i;
					}
				}
			}
			temp = 10000;
			for(i = 0; i < structbag.length; i++){
				a = structbag[i];
				if(a != null){
					if(a.costenergy < temp && a.costmetal == 0 && a.turrets.length == 1 && a.s[0] != 113){
						aiturreta = i;
						temp = a.costenergy;
					}
				}
			}
			for(i = 0; i < structbag.length; i++){
				a = structbag[i];
				if(a != null){
					if(a.turrets.length == 1 && aiturreta != i && a.s[0] != 113){
						aiturretb = i;
					}
				}
			}
			for(i = 0; i < structbag.length; i++){
				a = structbag[i];
				if(a != null){
					if(a.turrets.length == 1 && a.s[0] == 113){
						aiphalanx = i;
					}
				}
			}
		}
		
		public function AIAssignShips()
		{
			var i:int;
			var j:int;
			var temp:int;
			var a;
			var b;
			//Ships
			for(i = 0; i < shipbag.length; i++){
				a = shipbag[i];
				if(a != null && a.tech == 3){
					aicapitalship = i;
				}
			}
			temp = 10000;
			for(i = 0; i < shipbag.length; i++){
				a = shipbag[i];
				if(a != null && a.costenergy < temp && a.costmetal == 0 && a.tech == 1){
					aifighteraship = i;
					temp = a.costenergy;
				}
			}
			temp = 10000;
			for(i = 0; i < shipbag.length; i++){
				a = shipbag[i];
				if(a != null && a.costenergy + a.costmetal < temp && a.tech == 2){
					aimediumaship = i;
					temp = a.costenergy + a.costmetal;
				}
			}
			for(i = 0; i < shipbag.length; i++){
				a = shipbag[i];
				if(a != null && a.tech == 1 && aifighteraship != i){
					aifighterbship = i;
				}
				if(a != null && a.tech == 2 && aimediumaship != i){
					aimediumbship = i;
				}
			}
			if(aifighterbship == -1){
				aifighterbship = aifighteraship;
			}
			if(aimediumbship == -1){
				aimediumbship = aimediumaship;
			}
		}
		
		public function AICalculatePlan()
		{
			var plan:int = -1;
			var i:int;
			var lastscore:Number = 1000000;
			aiplanstruct = -1;
			aiupgradestruct = null;
			if(aieconscore <= lastscore){
				plan = 1; //Build Energy
				lastscore = aieconscore;
			}
			if(aimetalscore <= lastscore && aiminingstruct != -1){
				plan = 2; //Build Metal
				lastscore = aimetalscore;
			}
			if(aidefensescore <= lastscore && (aiturreta != -1 || aiturretb != -1)){
				plan = 3; //Build Turret
				lastscore = aidefensescore;
			}
			if(aioffensescore <= lastscore){
				plan = 4; //Build Offense
				lastscore = aioffensescore;
			}
			if(aiupgradescore <= lastscore){
				plan = 5; //Upgrade
				lastscore = aiupgradescore;
			}
			//Contingencies
			if(aiprocessorstruct != -1 && metalrate > energyrate){
				plan = 6;
			}
			//Plans
			if(plan == 1){
				aiplanstruct = aienergystruct;
			}
			if(plan == 2){
				aiplanstruct = aiminingstruct;
			}
			if(plan == 3){
				if(aiturretb != -1){
					if(aiturretascore < aiturretamax){
						aiplanstruct = aiturreta;
					}else{
						aiplanstruct = aiturretb;
					}
					if(metalrate == 0){
						aiplanstruct = aiturreta;
					}
				}else{
					aiplanstruct = aiturreta
				}
			}
			if(plan == 4){
				if(aitechascore < aitechamax){
					aiplanstruct = aifighterstruct;
				}else{
					if(aitechbscore < aitechbmax){
						aiplanstruct = aimediumstruct;
						if(structbag[aimediumstruct].costmetal > metal && metalrate == 0){
							aiplanstruct = aifighterstruct;
							if(aitechascore >= aitechamax){
								aitechamax++;
							}
						}
					}else{
						aiplanstruct = aicapitalstruct;
						if(structbag[aicapitalstruct].costmetal > metal && metalrate == 0){
							aiplanstruct = aimediumstruct;
							if(aitechbscore >= aitechbmax){
								aitechbmax++;
							}
						}
					}
				}
			}
			if(plan == 5){
				aiplanstruct = -1;
				for(i = 0; i < mystructs.length;i++){
					if(mystructs[i].hangars.length > 0 && mystructs[i].upgraded == false){
						aiupgradestruct = mystructs[i];
					}
				}
			}
			if(plan == 6){
				aiplanstruct = aiprocessorstruct;
			}
		}
		
		public function AICalculateScores()
		{
			var i:int;
			var j:int;
			//Calculate Energy
			aieconscore = energyrate * aieconscoreco;
			if(energyrate >= 18){
				aieconscore = aieconscore + 10000;
			}
			//Calculate Metal
			aimetalscore = metalrate * aimetalscoreco + aimetalscoreoff;
			j = 0;
			for(i = 0; i < mystructs.length; i++){
				if(mystructs[i].miner == true){
					j++;
				}
			}
			if(j >= 3 || metalrate >= 8){
				aimetalscore = aimetalscore + 10000;
			}
			//Calculate Defense
			aidefensescore = 0;
			for(i = 0; i < mystructs.length; i++){
				if(mystructs[i].turrets.length == 1){
					aidefensescore = aidefensescore + mystructs[i].turrets.length;
				}
			}
			aidefensescore = aidefensescore * aidefensescoreco;
			aiturretascore = 0;
			for(i = 0; i < mystructs.length; i++){
				if(mystructs[i].turrets.length > 0 && mystructs[i].s[0] == structbag[aiturreta].s[0]){
					aiturretascore++;
				}
			}
			//Calculate Offense
			aioffensescore = 0;
			aitechascore = 0;
			aitechbscore = 0;
			for(i = 0; i < mystructs.length; i++){
				if(mystructs[i].hangars.length > 0 && mystructs[i].tech > 0){
					aioffensescore = aioffensescore + mystructs[i].tech;
					if(mystructs[i].tech == 1){
						aitechascore++;
					}
					if(mystructs[i].tech == 2){
						aitechbscore++;
					}
				}
			}
			aioffensescore = aioffensescore * aioffensescoreco + aioffensescoreoff;
			//Calculate Upgrade
			aiupgradescore = 10000;
			aifighterascore = 0;
			aimediumascore = 0;
			for(i = 0; i < mystructs.length; i++){
				if(mystructs[i].hangars.length > 0 && mystructs[i].upgraded == false){
					aiupgradescore = 0;
				}
				if(mystructs[i].upgraded == true && mystructs[i].hangars[0].shiptype.s[0] == shipbag[aifighteraship].s[0]){
					aifighterascore++;
				}
				if(mystructs[i].upgraded == true && mystructs[i].hangars[0].shiptype.s[0] == shipbag[aimediumaship].s[0]){
					aimediumascore++;
				}
			}
		}
		
		public function AICalculateSpots()
		{
			var i:int;
			var xx:int;
			var yy:int;
			var bestxx:int;
			var bestyy:int;
			var bestnum:int = 0;
			var num:int;
			var r:Number;
			var rock;
			var a;
			var good:Boolean;
			if(aiminingstruct > -1 && structbag[aiminingstruct].turrets.length > 0 && structbag[aiminingstruct].metal == 0){
				bestnum = 0;
				bestxx = -1;
				bestyy = -1;
				r = structbag[aiminingstruct].turretrange;
				for(xx = -5; xx < 5; xx++){
					for(yy = -5; yy < 5; yy++){
						num = 0;
						for(i = 0; i < rocks.length; i++){
							rock = rocks[i];
							if(Math.sqrt(Math.pow(aibasex+xx-(rock.xx)/32,2)+Math.pow(aibasey+yy-(rock.yy)/32,2)) < r/64){
								num++;
							}
						}
						if(num > bestnum){
							good = true;
							for(i = 0; i < mystructs.length; i++){
								a = mystructs[i];
								if((a.xx + a.wide)/32 > aibasex+xx && (a.xx - a.wide)/32 < aibasex+xx && (a.yy + a.high)/32 > aibasey+yy && (a.yy - a.high)/32 < aibasey+yy){
									good = false;
								}
							}
							if(good == true){
								bestnum = num;
								bestxx = xx;
								bestyy = yy;
							}
						}
					}
				}
				if(bestnum > 0){
					aiminingx = bestxx + aibasex;
					aiminingy = bestyy + aibasey;
					//trace("SPOT FOUND");
					//trace(String(bestnum) + " " + String(bestxx) + " " + String(bestyy));
				}
			}
			aieconx = aibasex;
			if(aibasex > mapwide * .66){
				aieconx = aibasex + 3;
			}
			if(aibasex < mapwide * .33){
				aieconx = aibasex - 2;
			}
			aiecony = aibasey;
			if(aibasey > maphigh * .66){
				aiecony = aibasey + 3;
			}
			if(aibasey < maphigh * .33){
				aiecony = aibasey - 2;
			}
			
			aiturretx = aibasex;
			if(aibasex > mapwide * .66){
				aiturretx = aibasex - 3;
			}
			if(aibasex < mapwide * .33){
				aiturretx = aibasex + 4;
			}
			aiturrety = aibasey;
			if(aibasey > maphigh * .66){
				aiturrety = aibasey - 3;
			}
			if(aibasey < maphigh * .33){
				aiturrety = aibasey + 4;
			}
			if(Math.random() > 0.8){
				aiturretx = aibasex;
				aiturrety = aibasey;
			}
			/*if(Math.random() > 0.8 && aidefensescore > 2){
				aiturretx = aieconx;
				aiturrety = aiecony;
			}*/
			aiturretx = aiturretx + Math.round(-1+2*Math.random());
			aiturrety = aiturrety + Math.round(-1+2*Math.random());
			aieconx = aieconx + Math.round(-1+2*Math.random());
			aiecony = aiecony + Math.round(-1+2*Math.random());
			if(aiminingstruct > -1 && structbag[aiminingstruct].metal > 0){
				aiminingx = aieconx;
				aiminingy = aiecony;
			}
		}
		
		public function AICalculateStructs()
		{
			var i:int;
			mystructs = new Array();
			rocks = new Array();
			for(i = 0; i < structs.length; i++){
				if(structs[i].faction == faction){
					mystructs.push(structs[i]);
				}
				if(structs[i].rock == true){
					rocks.push(structs[i]);
				}
			}
			stations = new Array();
			for(i = 0; i < mystructs.length; i++){
				if(mystructs[i].base == true && mystructs[i].faction == faction){
					stations.push(mystructs[i]);
				}
			}
		}
		
		public function AIDifficulty(d:Number)
		{
			aihandicap = .7 + .5 * d;
			if(aihandicap < 1){
				energy = energy * aihandicap;
				metal = metal * aihandicap;
			}else{
				//energy = energy + d * 25;
			}
			/*if(aihandicap < .8){
				aioffensescoreoff = aioffensescoreoff + 2;
				aimetalscoreoff = aimetalscoreoff + 2;
				aioffensescoreco = aioffensescoreco + 2;
			}*/
		}
		
		public function AIPlaceStruct(vv:int)
		{
			var xx:int;
			var yy:int;
			var i:int;
			var j:int;
			var done:Boolean;
			var output:Array = new Array();			
			var v;
			
			//trace("AIPLACESTRUCT");
			v = structbag[vv];
			DoRadar();
			xx = aibasex + Math.round(Math.random()*4-2);
			yy = aibasey + Math.round(Math.random()*4-2);
			if(v.energy > 0){
				xx = aieconx;
				yy = aiecony;
			}
			if(v.tech > 0){
				xx = aibasex + Math.round(Math.random()*4-2);
				yy = aibasey + Math.round(Math.random()*4-2);
			}
			if(v.turrets.length == 1){
				xx = aiturretx;
				yy = aiturrety;
			}
			if(v.miner == true){
				xx = aiminingx;
				yy = aiminingy;
			}
			
			output = AISpiral(xx,yy,v.buildwide,v.buildhigh,1);
			if(output[0] == 1){
				//trace("AIBUILD");
				mom.rmove[(faction-1)*3] = vv;
				mom.rmove[(faction-1)*3 + 1] = output[1];
				mom.rmove[(faction-1)*3 + 2] = output[2];
				done = true;
			}
			if(output[0] == 0){
				done = false;
				if(vv == aicapitalstruct){
					aitechbmax++;
					if(Math.random() > 0.5){
						aimediumamax++;
					}
				}
				if(vv == aimediumstruct){
					aitechamax++;
					if(Math.random() > 0.5){
						aifighteramax++;
					}
				}
				if(vv == aiminingstruct){
					aimetalscoreoff++;
				}
			}
			return done;
		}
		
		public function AIUpgradeStruct(s)
		{
			var i:int;
			var b:int;
			var ready:Boolean = false;
			
			if(s.tech == 1){
				if(aifighterascore < aifighteramax){
					b = aifighteraship;
					ready = true;
				}else{
					b = aifighterbship;
					ready = true;
				}
				if(shipbag[b].costmetal > 0 && metalrate == 0){
					b = aifighteraship;
				}
			}
			if(s.tech == 2){
				if(aimediumascore < aimediumamax){
					b = aimediumaship;
					ready = true;
				}else{
					b = aimediumbship;
					ready = true;
				}
				if(shipbag[b].costmetal > 0 && metalrate == 0){
					b = aimediumaship;
				}
			}
			if(s.tech == 3){
				b = aicapitalship;
				ready = true;
			}
			if(shipbag[b].costmetal > metal || shipbag[b].costenergy > energy){
				ready = false;
			}
			if(ready == true){
				i = s.faction - 1;
				mom.rmove[i * 3 + 0] = 100; 
				mom.rmove[i * 3 + 1] = s.structid; 
				mom.rmove[i * 3 + 2] = b;
			}
		}
		
		public function AISpiral(xx:int, yy:int, wide:int, high:int, spacing:int)
		{
			var dir:int;
			var clockwise:int;
			var steps:int;
			var i:int;
			var j:int;
			var searching:Boolean;
			var timeout:int;
			var xxx:int;
			var yyy:int;
			var output:Array = new Array();
			
			output = [0,0,0];
			if(Math.random() > 0.5){
				clockwise = 1;
			}else{
				clockwise = -1;
			}
			dir = Math.floor(Math.random()*3);
			searching = true;
			steps = 0;
			timeout = 20;
			xxx = xx;
			yyy = yy;
			
			while(searching && timeout > 0){
				if(timeout % 2 == 0){
					steps++
				}
				j = 0;
				while(searching && j < steps){
					switch(dir){
						case 0: //North
							yyy = yyy - 1;
						break;
						case 1: //East
							xxx = xxx + 1;
						break;
						case 2: //South
							yyy = yyy + 1;
						break;
						case 3: //West
							xxx = xxx - 1;
						break;
					}
					if(Buildability(xxx,yyy,wide,high) == true){
						output[1] = xxx;
						output[2] = yyy;
						output[0] = 1;
						searching = false;
					}
					j++;
				}
				dir = dir + clockwise;
				if(dir < 0){
					dir = dir + 4;
				}else{
					if(dir > 3){
						dir = dir - 4;
					}
				}
				timeout--;
			}
			return output;
		}
		
		public function Buildability(xx:int, yy:int, wide:int, high:int)
		{
			var i:int;
			var j:int;
			var k:int;
			var good:Boolean;
			var xxx:Number;
			var yyy:Number;
			good = true;
			for(i = 0; i < wide; i++){
				for(j = 0; j < high; j++){
					if(xx + i < mapwide && xx + i >= 0 && yy + i < maphigh && yy + i >= 0){
						if(map[xx + i][yy + j] > 0){
							good = false
						}
					}else{
						good = false;
					}
					if(good == true){
						good = false;
						for(k = 0; k < stations.length; k++){
							xxx = stations[k].x / 32 - .5;
							yyy = stations[k].y / 32 - .5;
							if( (xx+i-xxx)*(xx+i-xxx) + (yy+j-yyy)*(yy+j-yyy) < buildrange * buildrange){
								good = true;
							}
						}
					}
				}
			}
			return good;
		}
		
		public function BuildStruct(xx:int, yy:int, sd)
		{
			var xxx:int;
			var yyy:int;
			var i:int;
			//var d:StructData = new StructData(ss);
			
			xxx = 32 * xx + sd.buildwide * 16;
			yyy = 32 * yy + sd.buildhigh * 16;
			
			mom.GenStruct(sd,faction,xxx,yyy);
		}
		
		public function DoAI()
		{
			var success:Boolean = false;
			var a = null;
			if(aireactiont == 0){
				AIAssignStructs();
				AIAssignShips();
				AICalculateScores();
				AICalculatePlan();
				if(aiplanstruct > -1){
					a = structbag[aiplanstruct];
				}
				if(aiplanstruct == -1 && aiupgradestruct != null){
					//trace("UPGRADE PLAN");
					AIUpgradeStruct(aiupgradestruct);
				}
				if(a != null && a.costenergy <= energy && a.costmetal <= metal){
					AICalculateSpots();
					success = AIPlaceStruct(aiplanstruct);
					if(success == false){
						//trace("Fail");
					}
				}
				aireactiont = aireactionmax;
			}else{
				aireactiont--;
			}
		}
		
		public function DoRadar()
		{
			var i:int;
			var j:int;
			var k:int;
			var xx:int;
			var yy:int;
			var f:int;
			var temp = new Array();
			map = new Array();
			
			mapwide = mom.mapgridx;
			maphigh = mom.mapgridy;
			
			for(i = 0; i < maphigh; i++){
				temp.push(0);
			}
			for(i = 0; i < mapwide; i++){
				map[i] = new Array();
				for(j = 0; j < maphigh; j++){
					map[i].push(0);
				}
			}
			
			for(i = 0; i < structs.length; i++){
				if(structs[i].faction == faction){
					f = 1;
					if(structs[i].base == true){
						aibasex = (structs[i].x - structs[i].buildwide * 16) / 32;
						aibasey = (structs[i].y - structs[i].buildhigh * 16) / 32;
					}
				}else{
					f = 2;
				}
				xx = (structs[i].xx - structs[i].buildwide * 16) / 32;
				yy = (structs[i].yy - structs[i].buildhigh * 16) / 32;
				for(j = 0; j < structs[i].buildwide; j++){
					for(k = 0; k < structs[i].buildhigh; k++){
						map[xx+j][yy+k] = f;
					}
				}
			}
		}
		
		public function CheckLife()
		{
			var i:int;
			var safe:Boolean = false;
			for(i = 0; i < mystructs.length; i++){
				if(mystructs[i].base == true){
					safe = true;
				}
			}
			if(safe == false){
				dead = true;
				for(i = 0; i < mystructs.length; i++){
					mystructs[i].armor = -1000;
				}
				for(i = 0; i < mom.ships.length; i++){
					if(mom.ships[i].faction == faction){
						mom.ships[i].armor = -1000;
					}
				}
			}
		}
		
		public function DoResources()
		{
			var i:int;
			energyrate = 0;
			//Generators
			for(i = 0; i < mystructs.length; i++){
				if(mystructs[i].energy > 0 && mystructs[i].metal == 0 && mystructs[i].frozen == 0){
					if(cpu == true){
						energy = energy + mystructs[i].energy * aihandicap;
					}else{
						energy = energy + mystructs[i].energy;
					}
					energyrate = energyrate + mystructs[i].energy;
				}
				if(mystructs[i].metal > 0 && mystructs[i].energy == 0 && mystructs[i].frozen == 0){
					metal = metal + mystructs[i].metal;
					metalmined = metalmined + mystructs[i].metal;
				}
			}
			//Processors
			for(i = 0; i < mystructs.length; i++){
				if(mystructs[i].metal < 0 && mystructs[i].energy > 0 && mystructs[i].frozen == 0){
					if(metal > 0){
						metal = metal + mystructs[i].metal;
						metalmined = metalmined + mystructs[i].metal;
						if(cpu == true){
							energy = energy + mystructs[i].energy * aihandicap;
						}else{
							energy = energy + mystructs[i].energy;
						}
						energyrate = energyrate + mystructs[i].energy;
						mystructs[i].animspeed = 1;
					}else{
						mystructs[i].animspeed = 0;
					}
				}
			}
			
			energyrate = Math.round(energyrate * 10);
			
			if(metalclock > 0){
				metalclock--;
			}else{
				metalclock = 20;
				metalrate = Math.floor(metalmined / 2);
				metalmined = 0;
				if(cpu == true){
					metal = metal + metalrate * (aihandicap - 1);
				}
			}
			if(metal < 0){
				metal = 0;
			}
			if(energy < 0){
				energy = 0;
			}
		}
		
		public function DoStuff()
		{
			if(faction != 0){
				AICalculateStructs();
				if(cpu == true){
					DoAI();
				}
				DoResources();
				CheckLife();
			}
		}
		
		public function GenBase(xx:int, yy:int)
		{
			var i:int;
			var j:int = 0;
			var vv;
			var output:Array;
			BuildStruct(xx,yy,structbag[0]);
			
			if(cpu == true){
				AIAssignStructs();
				AICalculateStructs();
				DoRadar();
				AICalculateSpots();
				
				trace("AIHANDICAP");
				trace(aihandicap);

				//Turret
				if(aiturretb != -1){
					vv = structbag[aiturretb];
				}else{
					if(aiturreta != -1){
						vv = structbag[aiturreta];
					}
				}
				if(aihandicap > 1){
					j = 2;
				}
				if(aihandicap > 1.25){
					j = 3;
				}
				if(aihandicap > 1.5){
					j = 5;
				}
				if(aihandicap > 1.75){
					j = 6;
				}
				if(aihandicap > 2){
					j = 7;
				}
				if(aihandicap > 2.25){
					j = 8;
				}
				if(aihandicap > 2.5){
					j = 9;
				}
				if(vv != null){
					for(i = 0; i < j; i++){
						AICalculateSpots();
						DoRadar();
						output = AISpiral(aiturretx,aiturrety,vv.buildwide,vv.buildhigh,1);
						if(output[0] == 1){
							BuildStruct(output[1],output[2],vv);
						}
					}
				}
				//Defense
				vv = null;
				if(aiphalanx != -1){
					vv = structbag[aiphalanx];
					j = 1;
				}
				if(aishield != -1){
					vv = structbag[aishield];
					j = 1;
				}
				if(aihandicap > 2){
					j = 2;
				}
				if(aihandicap > 2.5){
					j = 3;
				}
				if(aihandicap > 3){
					j = 4;
				}
				if(vv != null){
					for(i = 0; i < j; i++){
						AICalculateSpots();
						DoRadar();
						output = AISpiral(aiturretx,aiturrety,vv.buildwide,vv.buildhigh,1);
						if(output[0] == 1){
							BuildStruct(output[1],output[2],vv);
						}
					}
				}
			}
		}
		
		public function SetupArmory(a,b,c)
		{
			var i:int;
			var biohack:Boolean = false;
			for(i = 0; i < a.length; i++){
				structbag[i] = a[i];
			}
			for(i = 0; i < b.length; i++){
				shipbag[i] = b[i];
			}
			for(i = 0; i < c.length; i++){
				techbag[i] = c[i];
			}
			/*while(shipbag.length < 8){
				shipbag.push(null);
			}*/
			//BIOLAB HACK
			for(i = 0; i < structbag.length; i++){
				if(structbag[i] != null && structbag[i].s[0] == 180 && biohack == false){
					shipbag.push(new ShipData([212,0,0,0]));
					shipbag.push(new ShipData([213,0,0,0]));
					shipbag.push(new ShipData([262,0,0,0]));
					shipbag.push(new ShipData([304,0,0,0]));
					shipbag.push(new ShipData([305,0,0,0]));
					biohack = true;
				}
			}
			for(i = 0; i < shipbag.length; i++){
				if(shipbag[i] != null && shipbag[i].s[0] == 311 && biohack == false){
					shipbag.push(new ShipData([212,0,0,0]));
					shipbag.push(new ShipData([213,0,0,0]));
					shipbag.push(new ShipData([262,0,0,0]));
					shipbag.push(new ShipData([304,0,0,0]));
					shipbag.push(new ShipData([305,0,0,0]));
					biohack = true;
				}
			}
		}
		
		public function SetupTech()
		{
			var i:int;
			var j:int;
			var a;
			var b;
			for(i = 0; i < techbag.length; i++){
				a = techbag[i];
				if(techbag[i] != null){
					SetupTechPlayerPlus(a);
				}
			}
			for(i = 0; i < techbag.length; i++){
				a = techbag[i];
				if(techbag[i] != null){
					for(j = 0; j < shipbag.length; j++){
						if(shipbag[j] != null){
							b = shipbag[j];
							SetupTechPlus(a,b);
						}
					}
					for(j = 0; j < structbag.length; j++){
						if(structbag[j] != null){
							b = structbag[j];
							SetupTechPlus(a,b);
						}
					}
				}
			}
			for(i = 0; i < techbag.length; i++){
				a = techbag[i];
				if(techbag[i] != null){
					for(j = 0; j < shipbag.length; j++){
						if(shipbag[j] != null){
							b = shipbag[j];
							SetupTechMult(a,b);
						}
					}
					for(j = 0; j < structbag.length; j++){
						if(structbag[j] != null){
							b = structbag[j];
							SetupTechMult(a,b);
						}
					}
				}
			}
			for(i = 0; i < structbag.length; i++){
				if(structbag[i] != null){
					structbag[i].CalcTurretRange();
				}
			}
		}
		
		public function SetupTechPlayerPlus(a)
		{
			var i:int;
			var b;
			energy = energy + a.plusenergy;
			metal = metal + a.plusmetal;
			buildrange = buildrange + a.plusbuildrange;
			
			if(a.basedefense > 0){
				for(i = 0; i < structbag.length; i++){
					b = structbag[i];
					if(b != null && (b.s[0] == 0 || b.s[0] == 15 || b.s[0] == 20) && b.turrets.length > 0){
						b.gunheatmod = b.gunheatmod * .8;
					}
					if(b != null && (b.s[0] == 183) && b.turrets.length == 0){
						b.turrets.push([a.basedefense,0,-15]);
					}
					if(b != null && (b.s[0] == 0 || b.s[0] == 15) && b.turrets.length == 0){
						b.turrets.push([a.basedefense,-25,-5]);
						b.turrets.push([a.basedefense,25,-5]);
					}
					if(b != null && (b.s[0] == 20 || b.s[0] == 182) && b.turrets.length == 0){
						b.turrets.push([a.basedefense,-30,-30]);
						b.turrets.push([a.basedefense,30,-30]);
						b.turrets.push([a.basedefense,-30,10]);
						b.turrets.push([a.basedefense,30,10]);
					}
				}
			}
			if(a.baseshields > 0)
			{
				for(i = 0; i < structbag.length; i++){
					b = structbag[i];
					if(b != null && b.s[0] == 0 && b.tacshieldmax > 0){
						b.tacshieldmax = b.tacshieldmax + 200;
					}
					if(b != null && b.s[0] == 0 && b.tacshieldmax == 0){
						b.tacshieldmax = 500;
						b.tacshieldregen = 10;
						b.tacshieldr = 150;
						b.turretrange = b.tacshieldr;
					}
				}
			}
		}
		
		public function SetupTechPlus(a,b)
		{
			var i:int;
			b.armorregen = b.armorregen + a.plusarmorregen;
			if(b.shieldmax > 0){
				b.shieldregen = b.shieldregen + a.plusshieldregen;
				b.tacshieldregen = b.tacshieldregen + a.plusshieldregen;
			}
			b.freezeboost = b.freezeboost + a.freezeboost;
			b.acidboost = b.acidboost + a.acidboost;
			if(a.specialrounds > -1){
				b.specialrounds = a.specialrounds;
			}
			if(a.plasmod > 0){
				b.plasmod = a.plasmod;
			}
			if(a.darkmod > 0){
				b.darkmod = a.darkmod;
			}
			if(a.blastermod > 0){
				b.blastermod = a.blastermod;
			}
			if(b.hangars.length > 0 && b is ShipData){
				b.hangarnummod = b.hangarnummod + a.hangarnummod;
			}
		}
		
		public function SetupTechMult(a,b)
		{
			var i:int;
			var j:int;
			var c;
			var d;
			b.armormax = b.armormax * a.multarmor;
			b.shieldmax = b.shieldmax * a.multshield;
			b.armorregen = b.armorregen * a.multarmorregen;
			b.shieldregen = b.shieldregen * a.multshieldregen;
			b.tacshieldregen = b.tacshieldregen * a.multshieldregen;
			b.energy = b.energy * a.multenergy;
			b.costenergy = Math.round(b.costenergy * a.multcostenergy);
			b.costmetal = Math.round(b.costmetal * a.multcostmetal);
			if(b.miner == false){
				b.gunheatmod = b.gunheatmod * a.multgunheatall;
				b.missileheatmod = b.missileheatmod * a.multmissileheatall;
				b.beamheatmod = b.beamheatmod * a.multbeamheatall;
				b.plasheatmod = b.plasheatmod * a.multplasheatall;
				b.darkheatmod = b.darkheatmod * a.multdarkheatall;
				b.gunrangemod = b.gunrangemod * a.multgunrangeall;
			}
			if(b.miner == true){
				b.gunheatmod = b.gunheatmod * a.multminergunheatall;
			}
			if(b.hangars.length > 0 && b is ShipData){
				b.hangarlaunchheatmod = b.hangarlaunchheatmod * a.multlaunchheatship;
			}
			if(b.hangars.length > 0 && b is StructData){
				b.hangarlaunchheatmod = b.hangarlaunchheatmod * a.multlaunchheatstruct;
			}
			if(b.hangars.length > 0 && b is StructData && b.tech == 1){
				b.hangarlaunchheatmod = b.hangarlaunchheatmod * a.multlaunchheatfbay;
			}
		}
	}
}