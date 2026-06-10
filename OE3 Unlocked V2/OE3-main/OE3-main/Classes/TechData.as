package
{
	public class TechData
	{
		public var s:Array = new Array(4);
		public var modtxt:Array = new Array();
		public var nametext:String = "";
		public var desctext:String = "";
		public var iconid:int;
		public var rarity:int = 0;
		public var itemclass:int = 9;//Station,Factory,Energy,Mining,Turret,Aux,Fighters,Medium,Capital,Research
		
		//All
		public var multarmor:Number = 1;
		public var multshield:Number = 1;
		public var multarmorregen:Number = 1;
		public var multshieldregen:Number = 1;
		public var multenergy:Number = 1;
		public var multcostenergy:Number = 1;
		public var multcostmetal:Number = 1
		
		public var plusarmorregen:Number = 0;
		public var plusshieldregen:Number = 0;
		
		public var freezeboost:int = 0;
		public var acidboost:int = 0;
		public var specialrounds:int = -1;
		public var plasmod:int = 0;
		public var blastermod:int = 0;
		public var hangarnummod:int = 0;
		public var darkmod:int = 0;
		
		//All Weapons
		public var multgunrangeall:Number = 1;
		public var multgunheatall:Number = 1;
		public var multmissileheatall:Number = 1;
		public var multbeamheatall:Number = 1;
		public var multplasheatall:Number = 1;
		public var multdarkheatall:Number = 1;
		public var multminergunheatall:Number = 1;
		
		//Structs
		public var multlaunchheatstruct:Number = 1;
		public var multlaunchheatship:Number = 1;
		public var multlaunchheatfbay:Number = 1;
		
		//Turrets
		public var multturnturret:Number = 1;
		
		//Player
		public var plusenergy:int = 0;
		public var plusmetal:int = 0;
		public var plusbuildrange:Number = 0;
		public var basedefense:int = 0;
		public var baseshields:int = 0;
		
		public function TechData(ss)
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
			
			switch(s[0])
			{
				case 350: //Manufacturing
					nametext = "Manufacturing";
					multlaunchheatstruct = .93;
					desctext = "Increase ship production by 7%.";
				break;
				case 351: //Power Core
					nametext = "Power Core";
					multenergy = 1.05;
					desctext = "Increase energy production by 5%.";
				break;
				case 352: //Mining Beams
					nametext = "Mining Beams";
					multminergunheatall = .9;
					desctext = "Increase mining rate by 10%.";
				break;
				case 353: //Battery Pack
					nametext = "Battery Pack";
					plusenergy = 50;
					desctext = "Start with 50 extra energy.";
				break;
				case 354: //Supplies
					nametext = "Supplies";
					plusmetal = 25;
					desctext = "Start with 25 extra metal.";
				break;
				case 355: //Expansion
					nametext = "Expansion";
					plusbuildrange = 1;
					plusenergy = -50;
					desctext = "Increase build radius by 1 at the cost of 50 starting energy.";
				break;
				case 356: //Armor
					nametext = "Armor Plating";
					multarmor = 1.2;
					desctext = "Increase all armor by 20%";
				break;
				case 357: //Repair Organ
					nametext = "Repair Organ";
					plusarmorregen = .6;
					desctext = "Increase armor regeneration by 6.";
				break;
				case 358: //Heatsink
					nametext = "Heatsink";
					multgunheatall = .9;
					desctext = "All weapons fire 10% faster.";
				break;
				case 359: //Primer
					nametext = "Primer";
					multgunrangeall = 1.1;
					plusenergy = -25;
					desctext = "All weapon ranges increase by 10% at the cost of 25 starting energy.";
				break;
				case 360: //Freeze Boost
					nametext = "Freeze Boost";
					freezeboost = 1;
					desctext = "Freeze attacks freeze longer.";
				break;
				case 361: //Force Rounds
					nametext = "Force Rounds";
					specialrounds = 9;
					desctext = "Weapon knocks target back. +15% damage boost.";
				break;
				case 362: //Iridium Rounds
					nametext = "Iridium Rounds";
					specialrounds = 5;
					desctext = "Double shield damage. +15% armor damage boost.";
				break;
				case 363: //EMP Rounds
					nametext = "EMP Rounds";
					specialrounds = 0;
					desctext = "Triple shield damage.";
				break;
				case 364: //Acid Rounds
					nametext = "Acid Rounds";
					specialrounds = 1;
					desctext = "Damages armor over time.";
				break;
				case 365: //Freeze Rounds
					nametext = "Freeze Rounds";
					specialrounds = 8;
					desctext = "Freezes target for a short time. Weak against shields.";
				break;
				case 366: //Fusion Rounds
					nametext = "Fusion Rounds";
					specialrounds = 10;
					desctext = "+50% armor damage boost. Weak against shields.";
				break;
				case 367: //Neutron Rounds
					nametext = "Neutron Rounds";
					specialrounds = 4;
					desctext = "+20% damage to shields and armor.";
				break;
				case 368: //Thermal Rounds
					nametext = "Thermal Rounds";
					specialrounds = 7;
					desctext = "+30% armor damage boost.";
				break;
				case 369: //Acid Boost
					nametext = "Acid Boost";
					acidboost = 1;
					desctext = "Increase duration of acid weapon effect.";
				break;
				case 370: //Flash Charge
					nametext = "Flash Charge";
					plusshieldregen = 1;
					desctext = "+10 Shield Regeneration.";
				break;
				case 371: //Missile Doctrine
					nametext = "Missile Doctrine";
					multmissileheatall = .85;
					desctext = "Missile weapons fire 15% faster.";
				break;
				case 372: //Beam Doctrine
					nametext = "Beam Doctrine";
					multbeamheatall = .85;
					desctext = "Beam weapons fire 15% faster.";
				break;
				case 373: //Fighter Rush
					nametext = "Fighter Rush";
					multlaunchheatfbay = .9;
					desctext = "Fighters build 10% faster.";
				break;
				case 374: //Plasma Mastery
					nametext = "Plasma Mastery";
					multplasheatall = .85;
					plasmod = 1;
					desctext = "Plasma weapons fire 15% faster and gain homing.";
				break;
				case 375: //Cannon Mod
					nametext = "Cannon Mod";
					blastermod = 1;
					desctext = "Blaster weapons replaced by cannon rounds. Double damage, but slower fire rate.";
				break;
				case 376: //Carrier Rack
					nametext = "Carrier Rack";
					hangarnummod = 1;
					multlaunchheatship = 1.2;
					desctext = "Carrier hangars launch an extra fighter per wave. Waves delayed 20%.";
				break;
				case 377: //Dark Mastery
					nametext = "Dark Mastery";
					multdarkheatall = .80;
					darkmod = 16;
					desctext = "Black-hole weapons fire 20% faster and gain homing.";
				break;
				case 378: //Base Cannons
					nametext = "Base Cannons";
					basedefense = 7;
					desctext = "Stations, Stardocks, Starports, Naval Yard have autocannons. Stacking adds +20% fire-rate each.";
				break;
				case 379: //Base Shields
					nametext = "Base Shield";
					baseshields = 1;
					desctext = "Stations start with a mega-shield. Stacking adds +200 max to this shield.";
				break;
			}
			
			DoMods();
		}
		
		public function DoMods()
		{
			var i:int;
			for(i = 1; i < 3; i++){
				if(s[i] > 0){
					rarity++;
				}
				switch(s[i]){
					case 0:
						//NOTHING
					break;
				}
			}
		}
	}
}