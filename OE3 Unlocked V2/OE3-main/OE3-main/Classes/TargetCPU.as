package
{
	public class TargetCPU
	{
		public var mom;
		public var up;
		
		public var ships;
		public var structs;
		public var shots;
		
		public var miner:Boolean = false;
		public var healer:Boolean = false;
		public var tstructs:Boolean = false;
		public var tships:Boolean = false;
		public var tshots:Boolean = false;
		
		public function TargetCPU(m,upp)
		{
			mom = m;
			up = upp;
			
			ships = mom.ships;
			structs = mom.structs;
			shots = mom.shots;
		}
		
		public function DoAITargets(targets,s,xx:Number,yy:Number,scanrange:Number)
		{
			var i:int;
			var j:int;
			var tx:Number;
			var ty:Number;
			var d:Number;
			var davg:Number;
			var did:int;
			var cull:int = 10;
			var backup;
			var db:Number = 1000000;
			var dc:Number = 0;
			
			switch(s){
				case 0:
					if(tships == true){
						for(i = 0; i < ships.length; i++){
							if(ships[i].armor > 0 && ((healer == false && mom.alliances.a[ships[i].faction][up.faction] == 0) || (healer == true && ships[i].armor < ships[i].armormax && mom.alliances.a[ships[i].faction][up.faction] == 2))){
								targets.push(ships[i]);
							}
						}
					}
					if(tstructs == true){
						for(i = 0; i < structs.length; i++){
							if(structs[i].armor > 0 && ((healer == false && mom.alliances.a[structs[i].faction][up.faction] == 0) || (healer == true && structs[i].armor < structs[i].armormax && mom.alliances.a[structs[i].faction][up.faction] == 2))){
								targets.push(structs[i]);
							}
							if(miner == true && structs[i].armor > 0 && structs[i].rock == true){
								targets.push(structs[i]);
							}
						}
					}
					if(tshots == true){
						for(i = 0; i < shots.length; i++){
							if(shots[i].laser == 0 && shots[i].shrink == 0 && shots[i].armor > 0 && mom.alliances.a[up.faction][shots[i].faction] == 0){
								targets.push(shots[i]);
							}
						}
					}
				break;
				case 1:
					d = scanrange * scanrange;
					backup = null;
					if(tships == true){
						for(i = 0; i < ships.length; i++){
							if(ships[i].armor > 0 && ships[i].cloaked == 0 && ((healer == false && mom.alliances.a[ships[i].faction][up.faction] == 0) || (healer == true && ships[i].armor < ships[i].armormax && mom.alliances.a[ships[i].faction][up.faction] == 2))){
								tx = ships[i].xx;
								ty = ships[i].yy;
								dc = (tx - xx) * (tx - xx) + (ty - yy) * (ty - yy)
								if(dc < d){
									targets.push(ships[i]);
								}
								if(dc < db){
									db = dc;
									backup = ships[i];
								}
							}
						}
					}
					if(tstructs == true){
						for(i = 0; i < structs.length; i++){
							if(structs[i].armor > 0 && structs[i].cloaked == 0 && ((healer == false && mom.alliances.a[structs[i].faction][up.faction] == 0) || (healer == true && structs[i].armor < structs[i].armormax && mom.alliances.a[structs[i].faction][up.faction] == 2))){
								tx = structs[i].xx;
								ty = structs[i].yy;
								dc = (tx - xx) * (tx - xx) + (ty - yy) * (ty - yy)
								if(dc < d){
									targets.push(structs[i]);
								}
								if(dc < db){
									db = dc;
									backup = structs[i];
								}
							}
							if(miner == true && structs[i].rock == true){
								tx = structs[i].xx;
								ty = structs[i].yy;
								dc = (tx - xx) * (tx - xx) + (ty - yy) * (ty - yy)
								if(dc < d){
									targets.push(structs[i]);
								}
								if(dc < db){
									db = dc;
									backup = structs[i];
								}
							}
						}
					}
					if(tshots == true){
						for(i = 0; i < shots.length; i++){
							if(shots[i].armor > 0 && shots[i].laser == 0 && shots[i].shrink == 0 && mom.alliances.a[shots[i].faction][up.faction] == 0){
								tx = shots[i].xx;
								ty = shots[i].yy;
								dc = (tx - xx) * (tx - xx) + (ty - yy) * (ty - yy)
								if(dc < d){
									targets.push(shots[i]);
								}
								if(dc < db){
									db = dc;
									backup = shots[i];
								}
							}
						}
					}
					if(targets.length == 0 && backup != null){
						targets.push(backup);
					}
					backup = null;
					if(healer == true){ //Remove Self
						for(i = 0; i < targets.length; i++){
							if(up is Ship && targets[i] is Ship && up.shipid == targets[i].shipid){
								targets.splice(i,1);
								i--;
							}
						}
					}
				break;
			}
		}
		
		public function DoAICleanTargets(targets)
		{
			var i:int;
			for(i = 0; i < targets.length; i++){
				if(targets[i] == null || (targets[i] != null && targets[i].armor <= 0) || (targets[i] != null && targets[i].cloaked > 0)){
					targets.splice(i,1);
					i--;
				}
			}
		}
	}
}