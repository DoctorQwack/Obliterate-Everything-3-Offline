package 
{
	import flash.display.MovieClip;
	import flash.text.TextField
	import flash.events.MouseEvent;
	import flash.display.BitmapData;

		
	public class Sun extends MovieClip 
	{
		var clicking:Boolean;
		var clicked:Boolean;
		var mousing:Boolean;
		var moused:Boolean;
		var swidth:int;
		var sheight:int;
		var xcell:int;
		var ycell:int;
		var mom;
		var onoff:Boolean;
		var players:Array;
		var id:int;
		public var difficulty:Number = 0;
		var firstlevel:Boolean;
		public var nextpack:int = 1;
		
		public function Sun(m)
		{
			var i:int;
			stop();
			addEventListener(MouseEvent.MOUSE_DOWN, mouseClick);
			addEventListener(MouseEvent.MOUSE_UP, mouseLift);
			addEventListener(MouseEvent.MOUSE_OVER, mouseRoll);
			addEventListener(MouseEvent.ROLL_OUT, mouseRoll);

			clicked = false;
			clicking = false;
			moused = false;
			onoff = false;
			
			cacheAsBitmap = true;
			gotoAndStop(1);
			
			mom = m;
		}		
		
		public function mouseClick(event:MouseEvent)
		{
			if(clicking == false){
				moused = true;
				if(currentFrame == 2){
					gotoAndStop(3);
				}
			}
			clicking = true;
		}
		
		public function mouseLift(event:MouseEvent)
		{
			var i:int;
			
			
			if(clicking == true){
				clicked = true;
				if(currentFrame == 3){
					gotoAndStop(2);
					Go();
				}
			}
			clicking = false;
		}
		
		public function mouseRoll(e:MouseEvent)
		{
			var d:Number = 0;
			var t:Number = 0;
			var i:int = 0;
			var a;
			if(true){
				if(currentFrame == 4){
					useHandCursor = false;
					buttonMode = false;
				}else{
					useHandCursor = true;
					buttonMode = true;
				}
				switch (e.type) {
					case "mouseOver":
						if(currentFrame == 1){
							gotoAndStop(currentFrame + 1);
						}
						mousing = true;
						d = Math.sqrt(Math.pow(x,2)+Math.pow(y,2));
						t = Math.atan2(y,x);
						if(currentFrame == 2){
							mom.basescreen.sunpopup.difftxt.text = String(Math.round(100 * (mom.account.campaigndanger + difficulty)));
							mom.missions.nextpack = nextpack;
							mom.missions.nextdifficulty = CalcD();
							trace(mom.account.campaigndanger);
							trace(difficulty);
							mom.missions.nextsun = id;
							mom.missions.RollDice(1);
							mom.basescreen.sunpopup.mtype.text = mom.missions.nextmission;
							mom.basescreen.sunpopup.visible = true;
							mom.basescreen.sunpopup.x = d * Math.cos(t + 3.141592 / 4) + mom.basescreen.campaignscreen.x;
							mom.basescreen.sunpopup.y = d * Math.sin(t + 3.141592 / 4) + mom.basescreen.campaignscreen.y;
							t = 0;
							if(mom.account.prizes[id][0] < 200){
								a = new StructData(mom.account.prizes[id]);
							}
							if(mom.account.prizes[id][0] >= 200 && mom.account.prizes[id][0] < 350){
								a = new ShipData(mom.account.prizes[id]);
							}
							if(mom.account.prizes[id][0] >= 350 && mom.account.prizes[id][0] < 1000){
								a = new TechData(mom.account.prizes[id]);
							}
							if(mom.account.prizes[id][0] >= 1000){
								a = null;
							}
							if(a != null){
								mom.l.StoreIcon(a.s[0],a.rarity);
								mom.basescreen.sunbitmap.bitmapData = mom.l.sslargeicons[a.s[0]][a.rarity];
							}else{
								mom.basescreen.sunbitmap.bitmapData = new Credits(0,0);
							}
							mom.sounds[11]++;
						}
					break;
					case "rollOut":
						if(currentFrame != 4){
							gotoAndStop(1);
						}
						mousing = false;
						clicking = false;
						if(mom.basescreen != null){
							mom.basescreen.sunpopup.visible = false;
						}
					break;
				}
			}
		}
		
		public function Go()
		{
			var i:int;
			var j:int = 0;
			
			if(mom.account.stations > 0){
				for(i = 0; i < mom.account.armory.length; i++){
					if(mom.account.armory[i] != null){
						j++;
					}
				}
				if(j < mom.account.maxinventory ){
					mom.missions.nextpack = nextpack;
					mom.missions.nextdifficulty = CalcD();
					mom.missions.nextsun = id;
					mom.StartMission();
				}else{
					mom.basescreen.ScreenAnimation(9);
				}
			}else{
				mom.basescreen.ScreenAnimation(8);
			}
		}
		
		public function CalcD()
		{
			var d:Number;
			var i:int;
			var lastd:Number = 0;
			var nextd:Number = 0;
			var currentd:Number = 0;
			for(i = 0; i < mom.account.campaigndanger + 1; i++){
				if(i == 0){
					currentd = 0;
				}
				if(i == 1){
					currentd = currentd + 1;
				}
				if(i == 2){
					currentd = currentd + .5;
				}
				if(i == 3){
					currentd = currentd + .25;
				}
				if(i == 4){
					currentd = currentd + .15;
				}
				if(i > 4){
					currentd = currentd + .1;
				}
				if(i == mom.account.campaigndanger - 1){
					lastd = currentd;
				}
				if(i == mom.account.campaigndanger){
					nextd = currentd;
				}
			}
			d = lastd + difficulty * (nextd - lastd);
			return d;
		}
		
		public function Cleared()
		{
			var i:int;
			var j:int;
			for(i = -1; i < 2; i++){
				for(j = -1; j < 2; j++){ 
					if(Math.abs(i+j) == 1){
						if(mom.map.suns[i+xcell][j+ycell].currentFrame == 1 && mom.map.suns[i+xcell][j+ycell].visible == true ){
							mom.map.suns[i+xcell][j+ycell].gotoAndStop(3);
							//mom.map.suns[i+xcell][j+ycell].scaled = scaled * 2;
						}
					}
				}
			}
			gotoAndStop(5);
			cacheAsBitmap = true;
		}
		
		public function SetDice()
		{
			if(difficulty == 0){
				nextpack = 0;
			}
			if(difficulty > 0){
				nextpack = 1;
			}
		}
	}
}