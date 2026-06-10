package
{
	import flash.display.MovieClip;
	import flash.text.TextField
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import flash.filters.*;
    import flash.geom.*;
	import flash.display.*;
	
	public class Missions
	{
		public var mom;
		public var startx:Array = new Array();
		public var starty:Array = new Array();
		
		public var cpustructbag:Array = new Array();
		public var cpushipbag:Array = new Array();
		public var cputechbag:Array = new Array();
		public var teamcolors:Array = new Array(8);
		
		public var nextsun:int = 0;
		public var nextpack:int = 0;
		public var nextdifficulty:Number = 0;
		public var nextmission:String = "";
		public var nextfactions:Array = new Array();
		public var multlevel:int = 0;
		
		public var bosslevel:Boolean = false;
		
		public function Missions(m)
		{
			var i:int;
			mom = m;
		}
		
		public function AsteroidFix()
		{
			var i:int;
			var j:int;
			var k:int;
			var a;
			var b;
			var c:Number;
			var n:int;
			var good:Boolean;
			var xxx:int = 0;
			var yyy:int = 0;
			var smallasteroid;
			for(k = 0; k < mom.players.length; k++){
				if(mom.players[k].faction == 0){
					n = k;
				}
			}
			for(k = 0; k < mom.players[n].structbag.length; k++){
				if(mom.players[n].structbag[k].rock == true && mom.players[n].structbag[k].buildwide == 1){
					smallasteroid = mom.players[n].structbag[k];
				}
			}
			for(i = 0; i < mom.structs.length; i++){
				a = mom.structs[i]
				if(a.base == true){
					good = false;
					for(j = 0; j < mom.structs.length; j++){
						b = mom.structs[j]
						if(b.rock == true && Math.sqrt(Math.pow(a.xx-b.xx,2)+Math.pow(a.yy-b.yy,2)) < 100){
							good = true;
						}
					}
					trace(good);
					if(good == false){
						c = Math.floor(mom.Rand() * 3.99);
						switch(c){
							case 0:
								xxx = -1;
								yyy = -1;
							break;
							case 1:
								xxx = 2;
								yyy = -1;
							break;
							case 2:
								xxx = 2;
								yyy = 2;
							break;
							case 3:
								xxx = -1;
								yyy = 2;
							break;
						}
						if(smallasteroid != null){
							mom.players[n].BuildStruct(a.xx/32+xxx - 1,a.yy/32+yyy - 1,smallasteroid);
						}
					}
				}
			}
		}
		
		public function ClearAsteroids()
		{
			var i:int;
			var j:int;
			var a;
			var b;
			for(i = 0; i < mom.structs.length; i++){
				if(mom.structs[i].faction > 0){
					b = mom.structs[i]
					for(j = 0; j < mom.structs.length; j++){
						a = mom.structs[j];
						if(a.faction == 0){
							if(a.xx + .5 * a.spriteW > b.xx - .5 * b.spriteW && a.xx - .5 * a.spriteW < b.xx + .5 * b.spriteW && a.yy + .5 * a.spriteH > b.yy - .5 * b.spriteH && a.yy - .5 * a.spriteH < b.yy + .5 * b.spriteH){
								a.deadasteroid = true;
							}
						}
					}
				}
			}
		}
		
		public function GenAsteroids(density:Number, smallasteroid, largeasteroid)
		{
			var i:int;
			var j:int;
			var n:int;
			var b:Number;
			var buffer:BitmapData = new flash.display.BitmapData(mom.mapgridx,mom.mapgridy, false, 0);
			buffer.perlinNoise(mom.mapgridx, mom.mapgridy, 8, Math.floor(mom.Rand() * 90000), false, true, 1, true, null);
			for(i = 0; i < mom.players.length; i++){
				if(mom.players[i].faction == 0){
					n = i;
				}
			}
			density = 4 - density;
			for(i = 0; i < mom.mapgridx - 2; i++){
				for(j = 0; j < mom.mapgridy - 2; j++){
					b = (buffer.getPixel(i, j) & 0xFF)/512;
					b = 1-Math.pow(b,density);
					if(b < .8){
						b = .8;
					}
					if(mom.Rand() > b){
						mom.players[n].DoRadar();
						mom.players[n].BuildStruct(i,j,smallasteroid);
					}
					if(mom.Rand() > b && mom.Rand() > 0.7){
						mom.players[n].DoRadar();
						mom.players[n].BuildStruct(i,j,largeasteroid);
					}

				}
			}
		}
		
		public function ModAsteroids(v:int)
		{
			var matrix:Array = new Array();
			var a;
			var i:int;
			if(v == 1){ //Normal
				matrix=matrix.concat([1,0,0,0,0]);// red
				matrix=matrix.concat([0,1,0,0,0]);// green
				matrix=matrix.concat([0,0,1,0,0]);// blue
				matrix=matrix.concat([0,0,0,1,0]);// alpha
			}
			if(v == 2){ //Red
				matrix=matrix.concat([1,0,0,0,0]);// red
				matrix=matrix.concat([0,.5,0,0,0]);// green
				matrix=matrix.concat([0,0,.5,0,0]);// blue
				matrix=matrix.concat([0,0,0,1,0]);// alpha
			}
			if(v == 3){ //Purple
				matrix=matrix.concat([1,0,0,0,0]);// red
				matrix=matrix.concat([1,0,0,0,0]);// green
				matrix=matrix.concat([1,0,0,0,0]);// blue
				matrix=matrix.concat([0,0,0,1,0]);// alpha
			}
			if(v == 4){ //Blue
				matrix=matrix.concat([.8,0,0,0,0]);// red
				matrix=matrix.concat([0,.8,0,0,0]);// green
				matrix=matrix.concat([0,0,1,0,0]);// blue
				matrix=matrix.concat([0,0,0,1,0]);// alpha
			}
			if(v == 5){ //Green
				matrix=matrix.concat([.5,0,0,0,0]);// red
				matrix=matrix.concat([0,.6,0,0,0]);// green
				matrix=matrix.concat([0,0,.5,0,0]);// blue
				matrix=matrix.concat([0,0,0,1,0]);// alpha
			}
			if(v == 6){ //Orange
				matrix=matrix.concat([.7,0,0,0,0]);// red
				matrix=matrix.concat([0,.6,0,0,0]);// green
				matrix=matrix.concat([0,0,.5,0,0]);// blue
				matrix=matrix.concat([0,0,0,1,0]);// alpha
			}
			var my_filter:ColorMatrixFilter=new ColorMatrixFilter(matrix);
			if(matrix.length > 0){
				a = mom.l.ssstructs[mom.players[0].structbag[0].picid][0];
				a.applyFilter(a,new Rectangle(0,0,a.width,a.height),new Point(0,0), my_filter);
				a = mom.l.ssstructs[mom.players[0].structbag[1].picid][0];
				a.applyFilter(a,new Rectangle(0,0,a.width,a.height),new Point(0,0), my_filter);
			}
			if(mom.planetimage != null && mom.planetimage.a.currentFrame < 3){
				mom.planetimage.filters = [my_filter];
			}
		}
		
		public function GenMission(v:Array)
		{
			//0: Mission Type
			//1: Economy Type
			//2: Difficulty
			//3: Terrain
			//4: Players
			//4-0: CPU
			//4-1: faction
			//5: Nebula
			
			var i:int;
			
			switch(v[0]){
				case 1: //Duel
					mom.mapgridx = 24 + Math.floor(mom.Rand()*8);
					mom.mapgridy = 24 + Math.floor(mom.Rand()*8);
					mom.mapx = 32*(mom.mapgridx);
					mom.mapy = 32*(mom.mapgridy);
					StartSpots([1]);
					SetupPlayers(v[4],v[2]);
				break;
				case 2: //Pincer
					if(mom.Rand() > 0.5){
						mom.mapgridx = 40 + Math.floor(mom.Rand()*16);
						mom.mapgridy = 20 + Math.floor(mom.Rand()*8);
						mom.mapx = 32*(mom.mapgridx);
						mom.mapy = 32*(mom.mapgridy);
					}else{
						mom.mapgridx = 20 + Math.floor(mom.Rand()*8);
						mom.mapgridy = 40 + Math.floor(mom.Rand()*16);
						mom.mapx = 32*(mom.mapgridx);
						mom.mapy = 32*(mom.mapgridy);

					}
					StartSpots([2]);
					SetupPlayers(v[4],v[2]);
				break;
				case 3: //Circle
					mom.mapgridx = Math.round(13 * (Math.sqrt(v[4].length)) + 3 + mom.Rand()*8);
					mom.mapgridy = mom.mapgridx;
					mom.mapx = 32*(mom.mapgridx);
					mom.mapy = 32*(mom.mapgridy);
					StartSpots([3, v[4].length]);
					SetupPlayers(v[4],v[2]);
				break;
				case 4: //Circle Scatter
					mom.mapgridx = Math.round(18 * (Math.sqrt(v[4].length)) + 3 + mom.Rand()*8);
					mom.mapgridy = mom.mapgridx;
					mom.mapx = 32*(mom.mapgridx);
					mom.mapy = 32*(mom.mapgridy);
					StartSpots([4, v[4].length]);
					SetupPlayers(v[4],v[2]);
				break;
				case 5: //Center Defense
					mom.mapgridx = 24;
					mom.mapgridy = 24;
					mom.mapx = 32*(mom.mapgridx);
					mom.mapy = 32*(mom.mapgridy);
					StartSpots([5]);
					SetupPlayers(v[4],v[2]);
				break;
				case 6: //Line Defense
					if(mom.Rand() > 0.5){
						mom.mapgridx = 28;
						mom.mapgridy = 20;
					}else{
						mom.mapgridx = 20;
						mom.mapgridy = 28;
					}
					mom.mapx = 32*(mom.mapgridx);
					mom.mapy = 32*(mom.mapgridy);
					StartSpots([6]);
					SetupPlayers(v[4],v[2]);
				break;
				case 7: //Surround
					if(mom.Rand() > 0.5){
						mom.mapgridx = 40 + Math.floor(mom.Rand()*16);
						mom.mapgridy = 22 + Math.floor(mom.Rand()*8);
						mom.mapx = 32*(mom.mapgridx);
						mom.mapy = 32*(mom.mapgridy);
					}else{
						mom.mapgridx = 22 + Math.floor(mom.Rand()*8);
						mom.mapgridy = 40 + Math.floor(mom.Rand()*16);
						mom.mapx = 32*(mom.mapgridx);
						mom.mapy = 32*(mom.mapgridy);
					}
					StartSpots([7]);
					SetupPlayers(v[4],v[2]);
				break;
				case 8: //Surround Circle Scatter
					mom.mapgridx = Math.round(18 * (Math.sqrt(v[4].length)) + 4 + mom.Rand()*6);
					mom.mapgridy = mom.mapgridx;
					mom.mapx = 32*(mom.mapgridx);
					mom.mapy = 32*(mom.mapgridy);
					StartSpots([8, v[4].length]);
					SetupPlayers(v[4],v[2]);
				break;
			}
			
			mom.StartSystem(0,v[5]);

			StartPlayers();
			if(v[0] == 2){
				mom.players[1].energy = mom.players[1].energy + 250;
			}
			if(v[1] == 1){
				for(i = 0; i < mom.players.length; i++){
					mom.players[i].energy = mom.players[i].energy + 500;
				}
			}
			if(v[1] == 2){
				for(i = 0; i < mom.players.length; i++){
					mom.players[i].energy = mom.players[i].energy + 1500;
				}
			}
			
			GenStar(v[3][1][1],v[3][1][2]);
			if(v[3][2] != null){
				GenPlanet(v[3][2][0],v[3][2][1]);
			}
			
			if(v[3][0] > 0){
				GenAsteroids(v[3][0],mom.players[0].structbag[1],mom.players[0].structbag[0]);
				ModAsteroids(v[5]);
				ClearAsteroids();
			}
		}
		
		public function GenMultiMission(s:int)
		{
			startx = new Array();
			starty = new Array();
			switch(s){
				case 0:
					startx[0] = 7;
					starty[0] = 10;
					startx[1] = 22;
					starty[1] = 6;
					mom.mapgridx = 32;
					mom.mapgridy = 20;
					mom.mapx = mom.mapgridx * 32;
					mom.mapy = mom.mapgridy * 32;
				break;
				case 1:
					startx[0] = 5;
					starty[0] = 6;
					startx[1] = 9;
					starty[1] = 18;
					mom.mapgridx = 20;
					mom.mapgridy = 26;
					mom.mapx = mom.mapgridx * 32;
					mom.mapy = mom.mapgridy * 32;
				break;
				case 2:
					startx[0] = 11;
					starty[0] = 7;
					startx[1] = 5;
					starty[1] = 19;
					mom.mapgridx = 22;
					mom.mapgridy = 28;
					mom.mapx = mom.mapgridx * 32;
					mom.mapy = mom.mapgridy * 32;
				break;
				case 3:
					startx[0] = 32;
					starty[0] = 10;
					startx[1] = 7;
					starty[1] = 6;
					mom.mapgridx = 42;
					mom.mapgridy = 20;
					mom.mapx = mom.mapgridx * 32;
					mom.mapy = mom.mapgridy * 32;
				break;
				case 4:
					startx[0] = 38;
					starty[0] = 10;
					startx[1] = 7;
					starty[1] = 6;
					mom.mapgridx = 48;
					mom.mapgridy = 20;
					mom.mapx = mom.mapgridx * 32;
					mom.mapy = mom.mapgridy * 32;
				break;
			}
		}
		
		public function GenPlanet(pa:int, pr:Number)
		{
			var i:int;
			var a;
			trace("GEN PLANET");
			trace(pa);
			if(pa > 0){
				trace("OKAY");
				mom.planetimage = new PlanetImage();
				a = mom.planetimage;
				a.x = .5 * mom.mapx - .5 * (.5 * (mom.mapx - mom.resX));
				a.y = .5 * mom.mapy - .5 * (.5 * (mom.mapy - mom.resY));
				a.cacheAsBitmap = true;
				a.a.gotoAndStop(pa);
				mom.addChild(a);
			}
		}
		
		public function GenStar(sa:int, sar:Number)
		{
			var matrix:Array = new Array();
			var pop:int;
			var r:Number;
			var j:Number;
			var a;
			var s;
			var i:int = 0;
			var my_filter:ColorMatrixFilter;
			
			while(i < 1){
				if(i == 0){
					mom.starimage = new StarImage();
					a = mom.starimage;
					r = sar;
					s = sa;
				}
				a.x = .5 * mom.resX -100 + 200 * mom.Rand();
				a.y = .5 * mom.resY -100 + 200 * mom.Rand();
				a.cacheAsBitmap = true;
				a.gotoAndStop(s);
				mom.addChild(a);
				
				if(s == 2){
					a.cacheAsBitmap = false;
					a.x = .5 * mom.resX;
					a.y = .5 * mom.resY;
				}
				if(s == 4 || s == 7){
					a.rotation = mom.Rand() * 360;
				}
				a.scaleX = r
				a.scaleY = r;
				i++;
			}
			if(sa == 0){
				mom.starimage.visible = false;
			}
			if(sa > 0){
				mom.starimage.visible = true;
			}
			
		}
		
		public function StartSpots(v:Array)
		{
			//0: Mission Type
			var i:int;
			var tempa:Number;
			var tempb:Number;
			var tempc:Number;
			
			startx = new Array();
			starty = new Array();
			switch(v[0]){
				case 1: //Duel
					if(mom.mapgridy > mom.mapgridx){
						startx[0] = Math.round(.5 * mom.mapgridx - .3 *  mom.Rand() * mom.mapgridx);
						starty[0] = Math.round(.35 * mom.mapgridy - .15 *  mom.Rand() * mom.mapgridy);
						if(mom.Rand() > 0.5){
							startx[0] = Math.round(mom.mapgridx - startx[0]);
							starty[0] = Math.round(mom.mapgridy - starty[0]);
						}
						startx[1] = Math.round(mom.mapgridx - startx[0]);
						starty[1] = Math.round(mom.mapgridy - starty[0]);
					}else{
						startx[0] = Math.round(.35 * mom.mapgridx - .15 *  mom.Rand() * mom.mapgridx);
						starty[0] = Math.round(.5 * mom.mapgridy - .3 *  mom.Rand() * mom.mapgridy);
						if(mom.Rand() > 0.5){
							startx[0] = Math.round(mom.mapgridx - startx[0]);
							starty[0] = Math.round(mom.mapgridy - starty[0]);
						}
						startx[1] = Math.round(mom.mapgridx - startx[0]);
						starty[1] = Math.round(mom.mapgridy - starty[0]);
					}
				break;
				case 2: //Pincer
					if(mom.mapgridy > mom.mapgridx){
						startx[0] = Math.round(.5 * mom.mapgridx - 6 + 10 * mom.Rand());
						starty[0] = Math.round(.5 * mom.mapgridy);
						startx[1] = Math.round(.5 * mom.mapgridx  - 6 + 10 * mom.Rand());
						starty[1] = Math.round(.2 * mom.mapgridy);
						if(mom.Rand() > 0.5){
							starty[1] = Math.round(.8 * mom.mapgridy);
						}
						startx[2] = Math.round(.5 * mom.mapgridx - 6 + 10 * mom.Rand());
						starty[2] = Math.round(mom.mapgridy - starty[1]);
					}else{
						startx[0] = Math.round(.5 * mom.mapgridx);
						starty[0] = Math.round(.5 * mom.mapgridy - 6 + 10 * mom.Rand());
						startx[1] = Math.round(.2 * mom.mapgridx);
						starty[1] = Math.round(.5 * mom.mapgridy - 6 + 10 * mom.Rand());
						if(mom.Rand() > 0.5){
							startx[1] = Math.round(.8 * mom.mapgridx);
						}
						starty[2] = Math.round(.5 * mom.mapgridy - 6 + 10 * mom.Rand());
						startx[2] = Math.round(mom.mapgridx - startx[1]);
					}
				break;
				case 3: //Circle
					tempa = mom.Rand() * 2 * 3.141592;
					tempb = .325 * mom.mapgridx;
					for(i = 0; i < v[1]; i++){
						startx[i] = Math.round(.5 * mom.mapgridx - tempb * Math.cos(tempa + i * 2 * 3.141592 / (v[1])));
						starty[i] = Math.round(.5 * mom.mapgridy + tempb * Math.sin(tempa + i * 2 * 3.141592 / (v[1])));
					}
				break;
				case 4: //Scatter Circle
					tempa = mom.Rand() * 2 * 3.141592;
					tempb = .25 * mom.mapgridx;
					for(i = 0; i < v[1]; i++){
						startx[i] = Math.round((-3 + 6 * mom.Rand()) + .5 * mom.mapgridx - tempb * Math.cos(tempa + i * 2 * 3.141592 / (v[1])));
						starty[i] = Math.round((-3 + 6 * mom.Rand()) + .5 * mom.mapgridy + tempb * Math.sin(tempa + i * 2 * 3.141592 / (v[1])));
					}
				break;
				case 5: //Center Defense
					startx[0] = Math.round(.5 * mom.mapgridx);
					starty[0] = Math.round(.5 * mom.mapgridy);
				break;
				case 6: //Line Defense
					if(mom.mapgridy > mom.mapgridx){
						startx[0] = Math.round(.5 * mom.mapgridx);
						starty[0] = Math.round(.25 * mom.mapgridy);
						if(mom.Rand() > 0.5){
							starty[0] = Math.round(.75 * mom.mapgridy);
						}
					}else{
						startx[0] = Math.round(.25 * mom.mapgridx);
						starty[0] = Math.round(.5 * mom.mapgridy);
						if(mom.Rand() > 0.5){
							startx[0] = Math.round(.75 * mom.mapgridx);
						}
					}
				break;
				case 7: //Flank
					if(mom.mapgridy > mom.mapgridx){
						startx[1] = Math.round(.5 * mom.mapgridx - 6 + 10 * mom.Rand());
						starty[1] = Math.round(.5 * mom.mapgridy);
						startx[0] = Math.round(.5 * mom.mapgridx  - 6 + 10 * mom.Rand());
						starty[0] = Math.round(.2 * mom.mapgridy);
						if(mom.Rand() > 0.5){
							starty[0] = Math.round(.8 * mom.mapgridy);
						}
						startx[2] = Math.round(.5 * mom.mapgridx - 6 + 10 * mom.Rand());
						starty[2] = Math.round(mom.mapgridy - starty[0]);
					}else{
						startx[1] = Math.round(.5 * mom.mapgridx);
						starty[1] = Math.round(.5 * mom.mapgridy - 6 + 10 * mom.Rand());
						startx[0] = Math.round(.2 * mom.mapgridx);
						starty[0] = Math.round(.5 * mom.mapgridy - 6 + 10 * mom.Rand());
						if(mom.Rand() > 0.5){
							startx[0] = Math.round(.8 * mom.mapgridx);
						}
						starty[2] = Math.round(.5 * mom.mapgridy - 6 + 10 * mom.Rand());
						startx[2] = Math.round(mom.mapgridx - startx[0]);
					}
				break;
				case 8: //Surround Scatter Circle
					tempa = mom.Rand() * 2 * 3.141592;
					tempb = .35 * mom.mapgridx;
					for(i = 1; i < v[1]; i++){
						startx[i] = Math.round((-3 + 6 * mom.Rand()) + .5 * mom.mapgridx - tempb * Math.cos(tempa + i * 2 * 3.141592 / (v[1] - 1)));
						starty[i] = Math.round((-3 + 6 * mom.Rand()) + .5 * mom.mapgridy + tempb * Math.sin(tempa + i * 2 * 3.141592 / (v[1] - 1)));
					}
					startx[0] = Math.round(.5 * mom.mapgridx);
					starty[0] = Math.round(.5 * mom.mapgridy);
				break;
			}
		}
		
		public function RollDice(ss:int)
		{
			var v:Array = new Array(4);
			var i:int;
			var j:int;
			var t:Number;
			var flag:Boolean = false;
			var pname:String;
			v[0] = 0; //Mission
			v[1] = 0; //Economy
			v[2] = nextdifficulty; //Difficulty
			v[3] = new Array(); //Terrain
			v[4] = new Array(); //Players
			v[5] = 1; //Nebula
			
			trace("Next SUN")
			trace(nextsun);
			trace("Difficulty");
			trace(nextdifficulty); //RANGE 0 - 1
			mom.seed = nextsun + 100 * mom.account.campaignseed;
			nextfactions = new Array();
			bosslevel = false;
			switch(nextpack){
				case 0: //First Level Easy
					v[0] = 3;
					v[1] = 0;
					v[3][0] = 1.00;
					v[3][1] = new Array(5);
					SetStars(nextdifficulty, v[3][1]);
					v[5] = 1;
					nextfactions.push(1);
				break;
				case 1: //Normal
					v[0] = 3;
					v[1] = 0;
					if(mom.Rand() > 0.75){
						v[1] = 1;
					}
					v[3][0] = 1.00;
					v[3][1] = new Array(5);
					v[3][2] = new Array(2);
					SetStars(nextdifficulty, v[3][1]);
					SetPlanets(v[3][2]);
					v[5] = 1;
					if(mom.Rand() > 0.5){
						v[5] = 1 + Math.round(mom.Rand() * 4.99);
					}
					i = 0;
					j = 1;
					if(mom.Rand() > 0.5){
						j = 2;
					}
					while(i < j){
						t = 1 + Math.floor(4.99 * mom.Rand());
						if(nextdifficulty > 0.5 && mom.Rand() > 0.8){
							t = 20;
						}
						if(nextdifficulty > 0.5 && mom.Rand() > 0.7){
							t = 10;
						}
						nextfactions.push(t);
						i++;
					}
					CullDuplicates();
					if(nextfactions.length > 1 && mom.Rand() > 0.6){
						v[0] = 7;
					}
					if(nextfactions.length > 1 && mom.Rand() > 0.75){
						v[0] = 2;
						nextdifficulty = nextdifficulty * .7;
					}
				break;
				case 2: //BOSS
					v[0] = 3;
					v[1] = 2;
					v[3][0] = 1.00;
					v[3][1] = new Array(5);
					SetStars(nextdifficulty, v[3][1]);
					v[5] = 1;
					t = 1 + Math.floor(2.99 * mom.Rand());
					nextfactions.push(t);
					bosslevel = true;
				break;
			}
			if(v[0] == 2){
				v[2] = v[2] - .3;
			}
			v[4].push(0);
			for(i = 0; i < nextfactions.length; i++){
				if(nextfactions[i] > 0){
					v[4].push(nextfactions[i]);
				}
			}
			if(ss == 0){
				GenMission(v);
			}
			if(ss == 1){
				if(v[0] == 3){
					nextmission = "Duel";
				}
				if(v[0] == 3 && nextfactions.length > 1){
					nextmission = "Skirmish";
				}
				if(v[0] == 2){
					nextmission = "Pincer";
				}
				if(v[0] == 7){
					nextmission = "Flank";
				}
			}
		}
		
		public function CullDuplicates()
		{
			var i:int;
			var j:int;
			var t:Number;
			var flag:Boolean = false;
			i = nextfactions.length - 1;
			while(i > -1){
				j = nextfactions.length - 1;
				flag = false;
				while(j > - 1){
					if(i != j){
						if(nextfactions[i] == nextfactions[j]){
							flag = true;
						}
					}
					j--;
				}
				if(flag == true){
					nextfactions.splice(i,1);
				}
				i--;
			}
		}
		
		public function SetPlanets(v)
		{
			//EVEN PLANET NUMBER
			//ODD PLANET SCALE
			v[0] = 0;
			v[1] = 0;
			if(mom.Rand() > 0.75){
				v[0] = 1;
				if(mom.Rand() > 0.5){
					v[0] = 2;
				}
				v[1] = 1;
			}
		}
		
		public function SetStars(difficulty:Number, v)
		{
			var stara:int;
			var starar:Number;
			var solar:Number = 0;
			var temp:Number;
			var gravity:Number = 0;
			
			stara = 0;
			starar = 0;
			if(mom.Rand() > 0.5){
				temp = mom.Rand();
				if(temp >= 0 && temp < .4){
					stara = 1;
				}
				if(temp >= .4 && temp < .6){
					stara = 6;
				}
				if(temp >= .6 && temp < .8){
					stara = 5;
				}
				if(temp >= .8 && temp < .9){
					stara = 3;
				}
				if(temp >= .9){
					stara = 4;
				}
				if(temp >= .95){
					stara = 7;
				}
				/*if((difficulty > 20 && mom.Rand() > 0.8) || (difficulty > 60 && mom.Rand() > 0.7)){
					stara = 2;
				}*/
			}
			if(stara > 0){
				starar = .6 - .1 * mom.Rand();
				solar = 2 * (starar) * 20;
			}
			if(stara > 0 && mom.Rand() > 0.6 && difficulty > 0){
				starar = 1 + .2 * mom.Rand();
				if(stara == 4 || stara == 7){
					stara = 1;
				}
				if(difficulty > 50){
					starar = 1 + .5 * mom.Rand();
				}
				solar = 2 * (starar) * 20;
			}
			if(stara == 2){
				starar = .005+.0025
				gravity = 1.001;
				solar = 0;
			}
			if(stara == 7){
				starar = 1;
				solar = 0;
			}
			v[0] = solar;
			v[1] = stara;
			v[2] = starar;
		}
		
		public function SetupPlayers(v:Array, difficulty:Number)
		{
			//Cpu,faction
			var i:int;
			var j:int;
			
			cpustructbag = new Array(v.length-1);
			cpushipbag = new Array(v.length-1);
			cputechbag = new Array(v.length-1);

			for(i = 0; i < v.length-1; i++){
				cpustructbag[i] = new Array();
				cpushipbag[i] = new Array();
				cputechbag[i] = new Array();
			}
			
			for(i = 0; i < v.length-1; i++){
				switch(v[i+1]){
					case 1: //Red Humans
						if(bosslevel == false){
							cpustructbag[i].push(new StructData([0]));
						}else{
							cpustructbag[i].push(new StructData([80]));
						}
						cpustructbag[i].push(new StructData([5]));
						cpustructbag[i].push(new StructData([25]));
						cpustructbag[i].push(new StructData([10]));
						cpustructbag[i].push(new StructData([15]));
						cpustructbag[i].push(new StructData([20]));
						if(mom.account.campaigndanger > 5){
							cpustructbag[i].push(new StructData([100,6]));
							cpustructbag[i].push(new StructData([102,6]));
						}else{
							cpustructbag[i].push(new StructData([100]));
							cpustructbag[i].push(new StructData([102]));
						}
						if(mom.account.campaigndanger > 3){
							cpustructbag[i].push(new StructData([175]));
						}
						
						cpushipbag[i].push(new ShipData([200]));
						cpushipbag[i].push(new ShipData([202]));
						cpushipbag[i].push(new ShipData([250]));
						cpushipbag[i].push(new ShipData([251]));
						cpushipbag[i].push(new ShipData([300]));
						
						teamcolors[i+2] = 2;
						if(mom.account.campaigndanger > 4){
							cputechbag[i].push(new TechData([367]));
						}
					break;
					case 2: //Teal Humans
						if(bosslevel == false){
							cpustructbag[i].push(new StructData([0]));
						}else{
							cpustructbag[i].push(new StructData([80]));
						}
						cpustructbag[i].push(new StructData([5]));
						cpustructbag[i].push(new StructData([25]));
						cpustructbag[i].push(new StructData([10]));
						cpustructbag[i].push(new StructData([15]));
						cpustructbag[i].push(new StructData([20]));
						if(mom.account.campaigndanger > 5){
							cpustructbag[i].push(new StructData([100,6]));
							cpustructbag[i].push(new StructData([110,6]));
						}else{
							cpustructbag[i].push(new StructData([100]));
							cpustructbag[i].push(new StructData([110]));
						}
						if(mom.account.campaigndanger > 3){
							cpustructbag[i].push(new StructData([175]));
						}
						
						cpushipbag[i].push(new ShipData([203]));
						cpushipbag[i].push(new ShipData([204]));
						if(mom.account.campaigndanger > 7){
							cpushipbag[i].push(new ShipData([252,23]));
						}else{
							cpushipbag[i].push(new ShipData([252]));
						}
						cpushipbag[i].push(new ShipData([257]));
						if(mom.account.campaigndanger > 7){
							cpushipbag[i].push(new ShipData([301,23]));
						}else{
							cpushipbag[i].push(new ShipData([301]));
						}
						
						teamcolors[i+2] = 3;
						if(mom.account.campaigndanger > 4){
							cputechbag[i].push(new TechData([362]));
						}
					break;
					case 3: //Yellow Humans
						if(bosslevel == false){
							cpustructbag[i].push(new StructData([0]));
						}else{
							cpustructbag[i].push(new StructData([80]));
						}
						cpustructbag[i].push(new StructData([5]));
						cpustructbag[i].push(new StructData([25]));
						cpustructbag[i].push(new StructData([10]));
						cpustructbag[i].push(new StructData([15]));
						cpustructbag[i].push(new StructData([20]));
						if(mom.account.campaigndanger > 5){
							cpustructbag[i].push(new StructData([104,6]));
							cpustructbag[i].push(new StructData([106,6]));
						}else{
							cpustructbag[i].push(new StructData([104]));
							cpustructbag[i].push(new StructData([106]));
						}
						if(mom.account.campaigndanger > 3){
							cpustructbag[i].push(new StructData([113]));
						}
						
						cpushipbag[i].push(new ShipData([201]));
						cpushipbag[i].push(new ShipData([202]));
						cpushipbag[i].push(new ShipData([258]));
						cpushipbag[i].push(new ShipData([254]));
						if(mom.account.campaigndanger > 7){
							cpushipbag[i].push(new ShipData([302,26]));
						}else{
							cpushipbag[i].push(new ShipData([302]));
						}
						
						teamcolors[i+2] = 4;
						if(mom.account.campaigndanger > 4){
							cputechbag[i].push(new TechData([368]));
						}
					break;
					case 4: //Orange Humans
						cpustructbag[i].push(new StructData([0]));
						cpustructbag[i].push(new StructData([178]));
						cpustructbag[i].push(new StructData([25]));
						cpustructbag[i].push(new StructData([10]));
						cpustructbag[i].push(new StructData([15]));
						cpustructbag[i].push(new StructData([20]));
						if(mom.account.campaigndanger > 5){
							cpustructbag[i].push(new StructData([108,6]));
							cpustructbag[i].push(new StructData([109,6]));
						}else{
							cpustructbag[i].push(new StructData([108]));
							cpustructbag[i].push(new StructData([109]));
						}
						if(mom.account.campaigndanger > 3){
							cpustructbag[i].push(new StructData([175]));
						}
						
						cpushipbag[i].push(new ShipData([209]));
						cpushipbag[i].push(new ShipData([208]));
						cpushipbag[i].push(new ShipData([260]));
						cpushipbag[i].push(new ShipData([259]));
						cpushipbag[i].push(new ShipData([303]));
						
						teamcolors[i+2] = 5;
						if(mom.account.campaigndanger > 4){
							cputechbag[i].push(new TechData([352]));
						}
					break;
					case 5: //Purple Humans
						cpustructbag[i].push(new StructData([0]));
						cpustructbag[i].push(new StructData([178]));
						cpustructbag[i].push(new StructData([25]));
						cpustructbag[i].push(new StructData([10]));
						cpustructbag[i].push(new StructData([15]));
						cpustructbag[i].push(new StructData([20]));
						if(mom.account.campaigndanger > 5){
							cpustructbag[i].push(new StructData([100,6]));
							cpustructbag[i].push(new StructData([107,6]));
						}else{
							cpustructbag[i].push(new StructData([100]));
							cpustructbag[i].push(new StructData([107]));
						}
						if(mom.account.campaigndanger > 3){
							cpustructbag[i].push(new StructData([113]));
						}
						
						cpushipbag[i].push(new ShipData([209]));
						cpushipbag[i].push(new ShipData([204]));
						cpushipbag[i].push(new ShipData([255]));
						cpushipbag[i].push(new ShipData([259]));
						cpushipbag[i].push(new ShipData([306]));
						
						teamcolors[i+2] = 6;
						if(mom.account.campaigndanger > 4){
							cputechbag[i].push(new TechData([352]));
						}
					break;
					case 10: //Infestors
						cpustructbag[i].push(new StructData([1]));
						cpustructbag[i].push(new StructData([6]));
						cpustructbag[i].push(new StructData([11]));
						cpustructbag[i].push(new StructData([16]));
						cpustructbag[i].push(new StructData([21]));
						cpustructbag[i].push(new StructData([149]));
						
						cpushipbag[i].push(new ShipData([212]));
						cpushipbag[i].push(new ShipData([213]));
						cpushipbag[i].push(new ShipData([262]));
						cpushipbag[i].push(new ShipData([304]));
						cpushipbag[i].push(new ShipData([305]));
						
						teamcolors[i+2] = 7;
						if(mom.account.campaigndanger > 4){
							cputechbag[i].push(new TechData([364]));
						}
						if(mom.account.campaigndanger > 5){
							cputechbag[i].push(new TechData([357]));
						}
					break;
					case 20: //Bot
						cpustructbag[i].push(new StructData([2]));
						cpustructbag[i].push(new StructData([7]));
						cpustructbag[i].push(new StructData([27]));
						cpustructbag[i].push(new StructData([12]));
						cpustructbag[i].push(new StructData([17]));
						cpustructbag[i].push(new StructData([22]));
						cpustructbag[i].push(new StructData([148]));
						cpustructbag[i].push(new StructData([147]));
						
						cpushipbag[i].push(new ShipData([249]));
						cpushipbag[i].push(new ShipData([299]));
						cpushipbag[i].push(new ShipData([309]));
						
						teamcolors[i+2] = 8;
						if(mom.account.campaigndanger > 4){
							cputechbag[i].push(new TechData([360]));
						}
						if(mom.account.campaigndanger > 5){
							cputechbag[i].push(new TechData([360]));
						}
					break;
				}
				if(mom.account.campaigndanger > 2){
					cputechbag[i].push(new TechData([373]));
				}
				if(mom.account.campaigndanger > 3){
					cputechbag[i].push(new TechData([355]));
				}
				if(mom.account.campaigndanger > 4){
					cputechbag[i].push(new TechData([353]));
				}
				if(mom.account.campaigndanger > 5){
					cputechbag[i].push(new TechData([373]));
				}
				if(mom.account.campaigndanger > 6){
					cputechbag[i].push(new TechData([358]));
				}
				if(mom.account.campaigndanger > 7){
					cputechbag[i].push(new TechData([350]));
				}
				if(mom.account.campaigndanger > 8){
					cputechbag[i].push(new TechData([359]));
				}
				if(mom.account.campaigndanger > 9){
					cputechbag[i].push(new TechData([350]));
				}
				if(mom.account.campaigndanger > 10){
					cputechbag[i].push(new TechData([373]));
				}
				if(mom.account.campaigndanger > 11){
					cputechbag[i].push(new TechData([354]));
				}
			}
		}
		
		public function StartPlayers()
		{
			var a:Array = new Array();
			var b:Array = new Array();
			var c:Array = new Array();
			var d;
			var i:int;
			var j:int;
			
			teamcolors[1] = 1;
			
			a.push(new StructData([99]));
			a.push(new StructData([98]));
			mom.GenPlayer(0,teamcolors[0],a,b,c,false);
			
			a = new Array();
			b = new Array();
			c = new Array();
			
			a.push(new StructData([0,-1,-1,-1]));
			for(i = 0; i < mom.account.equipmap.length; i++){
				if(i >= 0 && i < 8){
					if(mom.account.equipmap[i] >= 0){
						b.push(mom.account.armory[mom.account.equipmap[i]]);
					}else{
						b.push(null);
					}
				}
				if(i >= 8 && i < 15){
					if(mom.account.equipmap[i] >= 0){
						a.push(mom.account.armory[mom.account.equipmap[i]]);
					}else{
						a.push(null);
					}
				}
				if(i == 15){
					a.push(new StructData([5,-1,-1,-1]));
					a.push(new StructData([25,-1,-1,-1]));
					a.push(new StructData([10,-1,-1,-1]));
					a.push(new StructData([15,-1,-1,-1]));
					a.push(new StructData([20,-1,-1,-1]));
				}
				if(i >= 15 && i < 17){
					if(mom.account.equipmap[i] >= 0){
						a.push(mom.account.armory[mom.account.equipmap[i]]);
					}else{
						a.push(null);
					}
				}
				if(i >= 17 && i < 21){
					if(mom.account.equipmap[i] >= 0){
						c.push(mom.account.armory[mom.account.equipmap[i]]);
					}else{
						c.push(null);
					}
				}
			}
			mom.GenPlayer(1,teamcolors[1],a,b,c,false);
			for(i = 0; i < cpustructbag.length; i++){
				a = new Array();
				b = new Array();
				c = new Array();
				for(j = 0; j < cpustructbag[i].length; j++){
					a.push(cpustructbag[i][j]);
				}
				for(j = 0; j < cpushipbag[i].length; j++){
					b.push(cpushipbag[i][j]);
				}
				for(j = 0; j < cputechbag[i].length; j++){
					c.push(cputechbag[i][j]);
				}
				mom.GenPlayer(2+i,teamcolors[2+i],a,b,c,true);
			}
			StartPlayersClean();
			for(i = 1; i < mom.players.length; i++){
				if(mom.players[i].cpu > 0){
					mom.players[i].AIDifficulty(nextdifficulty);
				}
				mom.players[i].GenBase(startx[i-1],starty[i-1]);
			}
			AsteroidFix();
		}
		
		public function StartPlayersMulti()
		{
			var a:Array = new Array();
			var b:Array = new Array();
			var c:Array = new Array();
			var d;
			var i:int;
			var j:int;
			var l:int = 4;
			
			a.push(new StructData([99]));
			a.push(new StructData([98]));
			mom.GenPlayer(0,0,a,b,c,false);
			StartMultiAsteroids();
			
			for(i = 0; i < 2; i++){
				a = new Array();
				b = new Array();
				c = new Array();
				j = 0;
				while(j < mom.arm[i].length){
					if(j < 8*l){
						if(mom.arm[i][j] > -1){
							d = new ShipData([mom.arm[i][j],mom.arm[i][j+1],mom.arm[i][j+2],mom.arm[i][j+3]]);
							b.push(d);
						}else{
							b.push(null);
						}
					}
					if(j >= 8*l && j < 23*l){
						if(mom.arm[i][j] > -1){
							d = new StructData([mom.arm[i][j],mom.arm[i][j+1],mom.arm[i][j+2],mom.arm[i][j+3]]);
							a.push(d);
						}else{
							a.push(null);
						}
					}
					if(j >= 23*l && j < 27*l){
						if(mom.arm[i][j] > -1){
							d = new TechData([mom.arm[i][j],mom.arm[i][j+1],mom.arm[i][j+2],mom.arm[i][j+3]]);
							c.push(d);
						}else{
							c.push(null);
						}
					}
					j = j + 4;
				}
				mom.GenPlayer(i+1,i+1,a,b,c,false);
			}
			StartPlayersClean();
			for(i = 1; i < mom.players.length; i++){
				mom.players[i].GenBase(startx[i-1],starty[i-1]);
			}
		}
		
		public function StartPlayersClean()
		{
			var i:int;
			var j:int;
			var k:int;
			var t:int;
			for(i = 0; i < mom.players.length; i++){
				for(k = 1; k < 4; k++){
					t = 0
					for(j = 0; j < mom.players[i].shipbag.length; j++){
						if(mom.players[i].shipbag[j] != null && mom.players[i].shipbag[j].tech == k && mom.players[i].shipbag[j].race == mom.players[i].race){
							t++;
						}
					}
					if(t == 0){
						for(j = 0; j < mom.players[i].structbag.length; j++){
							if(mom.players[i].structbag[j] != null && mom.players[i].structbag[j].tech == k){
								mom.players[i].structbag[j] = null;
							}
						}
					}
				}
			}
		}
		
		public function StartMultiAsteroids()
		{
			trace("LEVEL: " + String(multlevel));
			switch(multlevel){
				case 0:
					mom.players[0].BuildStruct(startx[0]-4,starty[0]-2,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[0]-4,starty[0]+3,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[0]-2,starty[0]+4,mom.players[0].structbag[1]);
					mom.players[0].BuildStruct(startx[0]-4,starty[0],mom.players[0].structbag[1]);
					
					mom.players[0].BuildStruct(startx[1]+4,starty[1]-2,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[1]+5,starty[1]+3,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[1]+4,starty[1]+4,mom.players[0].structbag[1]);
					mom.players[0].BuildStruct(startx[1]+5,starty[1],mom.players[0].structbag[1]);
				break;
				case 1:
					mom.players[0].BuildStruct(startx[0]-1,starty[0]-4,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[0]-3,starty[0]-3,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[0]+3,starty[0]-3,mom.players[0].structbag[1]);
					mom.players[0].BuildStruct(startx[0]+1,starty[0]-4,mom.players[0].structbag[1]);
					
					mom.players[0].BuildStruct(startx[1]-1,starty[1]+4,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[1]-3,starty[1]+3,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[1]+3,starty[1]+4,mom.players[0].structbag[1]);
					mom.players[0].BuildStruct(startx[1]+1,starty[1]+5,mom.players[0].structbag[1]);
				break;
				case 2:
					mom.players[0].BuildStruct(startx[0]-1,starty[0]-4,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[0]-3,starty[0]-3,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[0]+3,starty[0]-3,mom.players[0].structbag[1]);
					mom.players[0].BuildStruct(startx[0]+1,starty[0]-4,mom.players[0].structbag[1]);
					
					mom.players[0].BuildStruct(startx[1]-1,starty[1]+4,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[1]-3,starty[1]+3,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[1]+3,starty[1]+4,mom.players[0].structbag[1]);
					mom.players[0].BuildStruct(startx[1]+1,starty[1]+5,mom.players[0].structbag[1]);
				break;
				case 3:
					mom.players[0].BuildStruct(startx[0]-4,starty[0]-2,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[0]-4,starty[0]+3,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[0]-2,starty[0]+4,mom.players[0].structbag[1]);
					mom.players[0].BuildStruct(startx[0]-4,starty[0],mom.players[0].structbag[1]);
					
					mom.players[0].BuildStruct(startx[1]+4,starty[1]-2,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[1]+4,starty[1]+3,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[1]+3,starty[1]+4,mom.players[0].structbag[1]);
					mom.players[0].BuildStruct(startx[1]+5,starty[1],mom.players[0].structbag[1]);
				break;
				case 4:
					mom.players[0].BuildStruct(startx[0]-1,starty[0]-4,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[0]-3,starty[0]-3,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[0]+3,starty[0]-3,mom.players[0].structbag[1]);
					mom.players[0].BuildStruct(startx[0]+1,starty[0]-4,mom.players[0].structbag[1]);
					mom.players[0].BuildStruct(startx[0]-1,starty[0]+4,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[0]-3,starty[0]+3,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[0]+3,starty[0]+4,mom.players[0].structbag[1]);
					mom.players[0].BuildStruct(startx[0]+1,starty[0]+5,mom.players[0].structbag[1]);
					
					mom.players[0].BuildStruct(startx[1]-1,starty[1]+4,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[1]-3,starty[1]+3,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[1]+3,starty[1]+4,mom.players[0].structbag[1]);
					mom.players[0].BuildStruct(startx[1]+1,starty[1]+5,mom.players[0].structbag[1]);
					mom.players[0].BuildStruct(startx[1]-1,starty[1]-4,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[1]-3,starty[1]-3,mom.players[0].structbag[0]);
					mom.players[0].BuildStruct(startx[1]+3,starty[1]-3,mom.players[0].structbag[1]);
					mom.players[0].BuildStruct(startx[1]+1,starty[1]-4,mom.players[0].structbag[1]);
				break;
			}
		}
	}
}