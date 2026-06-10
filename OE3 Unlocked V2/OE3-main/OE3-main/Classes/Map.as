package 
{
	import flash.display.MovieClip;
	import flash.text.TextField
	import flash.events.MouseEvent;
	import flash.display.Graphics;
	import flash.filters.*;
		
	public class Map extends MovieClip 
	{
		var mom;
		var wide:int;
		var high:int;
		var startx:int;
		var starty:int;
		var suns:Array;
		var filt:GlowFilter = new GlowFilter;
		var shad:DropShadowFilter = new DropShadowFilter;
		
		//var startblurb:StartBlurb;
		
		var lines:MovieClip;
		
		public function Map(m)
		{
			var i:int;
			stop();
			gotoAndStop(1);
			lines = new MovieClip();
			addChild(lines);
			lines.cacheAsBitmap = true;
			
			/*startblurb = new StartBlurb();
			addChild(startblurb);
			startblurb.visible = false;*/
			
			//Glow
			filt.color = 0x55FFFF;
			filt.blurX = 5; 
			filt.blurY = 5;
			filt.strength = .6;
			
			//Shadow
			shad.color = 0x55FFFF;
			shad.blurX = 2; 
			shad.blurY = 2;
			shad.strength = .3;
			shad.alpha = .275;
			shad.distance = 10;
			
			//Colors
			if(m.account.campaigndanger == 0){
				filt.color = 0x55FFFF;
				shad.color = 0x55FFFF;
			}
			if(m.account.campaigndanger == 1){
				filt.color = 0xFF55FF;
				shad.color = 0xFF55FF;
			}
			if(m.account.campaigndanger == 2){
				filt.color = 0xFFFF55;
				shad.color = 0xFFFF55;
			}
			
			lines.filters = [shad,filt];
			mom = m;
		}
		
		public function GenMap(w:int, h:int)
		{
			var tilesize:int = 40//50,54;
			var tileshake:Number = 8//8,12;
			var gaps:int = 15//9;
			var i:int;
			var j:int;
			var k:int;
			var l:int;
			var xx:int;
			var yy:int;
			var fx:int = -1;
			var fy:int = -1;
			var s;
			var safe:Boolean;
			var timeout:int;
			var dist:Number;
			var sorted:Array = new Array();
			wide = w;
			high = h;
			suns = new Array(w);
			for(i = 0; i < w; i++){
				suns[i] = new Array();
				for(j = 0; j < h; j++){
					s = new Sun(mom);
					s.gotoAndStop(1);
					//s.mom = mom;
					s.x = -.5 * tilesize * w + i * tilesize - tileshake + 2 * tileshake * 1 + .5 * tilesize;
					s.y = -.5 * tilesize * h + j * tilesize - tileshake + 2 * tileshake * 1 + .5 * tilesize;
					addChild(s);
					suns[i].push(s);
					//suns[i][j].xcell = i;
					//suns[i][j].ycell = j;
				}
			}
			
			for(i = 0; i < wide; i++){
				for(j = 0; j < high; j++){
					suns[i][j].id = i + j * 6;
					if(mom.account.campaign[i + j * wide] == 0){
						suns[i][j].visible = false;
						suns[i][j].gotoAndStop(1);
					}
					if(mom.account.campaign[i + j * wide] == 1){
						suns[i][j].visible = false;
						suns[i][j].gotoAndStop(1);
					}
					if(mom.account.campaign[i + j * wide] == 2){
						suns[i][j].gotoAndStop(4);
					}
				}
			}
			if(mom.account.campaignstart >= 0 && mom.account.campaignstart < 36){
				startx = mom.account.campaignstart % 6;
				starty = (mom.account.campaignstart - (mom.account.campaignstart % 6))/6;
				if(suns[startx][starty].visible == false){
					suns[startx][starty].visible = true;
				}
			}else{
				startx = 0;
				starty = 0;
			}
			for(i = 0; i < wide; i++){
				for(j = 0; j < high; j++){
					if(mom.account.campaign[i + j * wide] == 1){
						for(k = i-1; k < i+2; k++){
							for(l = j-1; l < j+2; l++){
								if(k >= 0 && k < wide && l >= 0 && l < high){
									if(Math.abs(l-j) + Math.abs(k-i) < 2){
										if(mom.account.campaign[k + l * wide] == 2){
											suns[i][j].visible = true;
										}
									}
								}
							}
						}
					}
				}
			}
			
			//Difficulty
			dist = 0;
			for(i = 0; i < w; i++){
				for(j = 0; j < h; j++){
					suns[i][j].difficulty = Math.sqrt(Math.pow(i - startx,2) + Math.pow(j - starty,2));
					if(suns[i][j].difficulty > dist){
						dist = suns[i][j].difficulty;
					}
				}
			}
			for(i = 0; i < w; i++){
				for(j = 0; j < h; j++){
					if(suns[i][j].visible == true){
						suns[i][j].difficulty = 1 * (suns[i][j].difficulty / dist);
					}
				}
			}
			
			//Setup Level
			for(i = 0; i < w; i++){
				for(j = 0; j < h; j++){
					if(suns[i][j].visible == true){
						suns[i][j].SetDice();
					}
				}
			}
			
			//x = .5 * mom.resX;
			//y = .5 * mom.resY;
			rotation = 45;
		}
		
		public function GenLines()
		{
			var i:int;
			var j:int;
			var k:int;
			var l:int;
			for(i = 0; i < wide; i++){
				for(j = 0; j < high; j++){
					if(suns[i][j].visible == true){
						for(k = i-1; k < i+1; k++){
							for(l = j-1; l < j+1; l++){
								if(k >= 0 && k <= wide && l >= 0 && l <= high){
									if(suns[k][l].visible == true && Math.abs(l-j) + Math.abs(k-i) < 2){
										if(suns[k][l].currentFrame == 4 || suns[i][j].currentFrame == 4){
											//lines.graphics.lineStyle(2,0xAAAAFF);
											if(mom.account.campaigndanger % 3 == 0){
												lines.graphics.lineStyle(1,0x7777BB);
											}
											if(mom.account.campaigndanger % 3 == 1){
												lines.graphics.lineStyle(1,0xBB77BB);
											}
											if(mom.account.campaigndanger % 3 == 2){
												lines.graphics.lineStyle(1,0x77BB77);
											}
											lines.graphics.moveTo(suns[i][j].x, suns[i][j].y); 
											lines.graphics.lineTo(suns[k][l].x, suns[k][l].y);
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}