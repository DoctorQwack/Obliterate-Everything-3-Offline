package
{
	public class Account
	{
		public var mom;
		public var structs;
		public var armory:Array = new Array();
		public var armorymap:Array = new Array();
		public var equipmap:Array = new Array();
		public var prices:Array = new Array();
		public var vault:Array = new Array();
		public var vaultmap:Array = new Array();
		public var campaign:Array = new Array();
		public var prizes:Array = new Array();
		
		public var packs:Array = new Array(10);
		public var packprices:Array = new Array();
		public var packnames:Array = new Array();
		
		public var maxstations:int = 7;
		public var maxinventory:int = 50;
		
		public var credits:int = 0;
		public var platinum:int = 0;
		public var stations:int = 0;
		public var vaultminutes:int = 0;
		public var vaulthours:int = 0;
		public var bonus:int = 0;
		public var rating:int = 0;
		public var wins:int = 0;
		public var losses:int = 0;
		
		public var prizea:int = 0;
		public var prizeb:int = 0;
		public var prizec:int = 0;
		public var prized:int = 0;
		public var prizee:int = 0;
		
		//Campaign
		public var campaignseed:int = 0;
		public var campaigndanger:Number = 0;
		public var campaignstart:int = 0;
		public var campaignlock:int = 0;
		
		public function Account(m)
		{
			var i:int;
			mom = m;
			//SetupArmory();
		}
		
		public function PushEquip(s)
		{
			var i:int;
			equipmap.push(s);
		}
		
		public function PushArmory(s)
		{
			var i:int;
			if(s[0] >= 0){
				if(s[0] < 200){
					armory.push(new StructData([s[0],s[1],s[2],s[3]]));
				}
				if(s[0] >= 200 && s[0] < 350){
					armory.push(new ShipData([s[0],s[1],s[2],s[3]]));
				}
				if(s[0] >= 350){
					armory.push(new TechData([s[0],s[1],s[2],s[3]]));
				}
			}else{
				armory.push(null);
			}
			armorymap.push(s);
		}
		
		public function PushPack(ss:int,s)
		{
			var i:int;
			var j:int;
			if(s[0] >= 0){
				if(s[0] < 200){
					packs[ss].push(new StructData([s[0],s[1],s[2],s[3]]));
				}
				if(s[0] >= 200 && s[0] < 350){
					packs[ss].push(new ShipData([s[0],s[1],s[2],s[3]]));
				}
				if(s[0] >= 350){
					packs[ss].push(new TechData([s[0],s[1],s[2],s[3]]));
				}
			}else{
				packs[ss].push(null);
			}
		}
		
		public function PushVault(s)
		{
			var i:int;
			if(s[0] >= 0){
				if(s[0] < 200){
					vault.push(new StructData([s[0],s[1],s[2],s[3]]));
				}
				if(s[0] >= 200 && s[0] < 350){
					vault.push(new ShipData([s[0],s[1],s[2],s[3]]));
				}
				if(s[0] >= 350){
					vault.push(new TechData([s[0],s[1],s[2],s[3]]));
				}
			}else{
				vault.push(null);
			}
			vaultmap.push(s);
		}
	}
}