package
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
    import flash.geom.ColorTransform;
    import flash.utils.*
	import flash.system.ApplicationDomain;
	
	public class Library
	{
		public var mom;
		public var ssstructs:Array = new Array();
		public var ssstructlights:Array = new Array();
		public var ssstructshields:Array = new Array();
		public var ssships:Array = new Array();
		public var ssshiplights:Array = new Array();
		public var ssshipburns:Array = new Array();
		public var ssshipshields:Array = new Array();
		public var ssshots:Array = new Array();
		public var ssshotburns:Array = new Array();
		public var sseffects:Array = new Array();
		public var sseffecttemplate:Array = new Array();
		public var ssturrets:Array = new Array();
		public var ssicons:Array = new Array();
		public var sslargeicons:Array = new Array();
		
		public function Library(m)
		{
			var i:int;
			var j:int;
			var k:int;
			mom = m;
			
			ssstructs = new Array(200);
			for(i = 0; i < ssstructs.length; i++){
				ssstructs[i] = new Array(8);
			}
			
			ssturrets = new Array(100);
			for(i = 0; i < ssturrets.length; i++){
				ssturrets[i] = new Array(8);
			}
			ssstructlights = new Array(200);
			for(i = 0; i < ssstructlights.length; i++){
				ssstructlights[i] = null;
			}
			ssstructshields = new Array(200);
			for(i = 0; i < ssstructshields.length; i++){
				ssstructshields[i] = null;
			}
			
			ssships = new Array(150);
			for(i = 0; i < ssships.length; i++){
				ssships[i] = new Array(8);
			}
			
			ssshipburns = new Array(150);
			for(i = 0; i < ssshipburns.length; i++){
				ssshipburns[i] = new Array(8);
			}
			
			ssshiplights = new Array(150);
			for(i = 0; i < ssshiplights.length; i++){
				ssshiplights[i] = null;
			}
			
			ssshipshields = new Array(150);
			for(i = 0; i < ssshipshields.length; i++){
				ssshipshields[i] = null;
			}
			
			ssshots = new Array(15);
			ssshotburns = new Array(15);
			for(i = 0; i < ssshots.length; i++){
				ssshots[i] = new Array(5);
				ssshotburns[i] = new Array(5);
				for(j = 0; j < ssshots[i].length; j++){
					ssshots[i][j] = new Array(10);
				}
			}
			
			sseffects = new Array(100);
			for(i = 0; i < sseffects.length; i++){
				sseffects[i] = new Array(5);
				for(j = 0; j < sseffects[i].length; j++){
					sseffects[i][j] = null;
				}
			}
			
			sseffecttemplate = new Array(100);
			for(i = 0; i < 50; i++){
				sseffecttemplate[i] = "E" + String(i);
			}
			sseffecttemplate[50] = "E4";
			sseffecttemplate[51] = "E1";
			sseffecttemplate[52] = "E3";
			sseffecttemplate[53] = "E0";
			sseffecttemplate[54] = "E6";
			sseffecttemplate[55] = "E3";
			
			ssicons = new Array(400);
			for(i = 0; i < ssicons.length; i++){
				ssicons[i] = new Array(3);
			}
			
			sslargeicons = new Array(400);
			for(i = 0; i < sslargeicons.length; i++){
				sslargeicons[i] = new Array(3);
			}
		}
		
		public function FactionColors(s:int)
		{
			var rr:Number;
			var gg:Number;
			var bb:Number;
			
			switch(s){
				case 0:
					rr = 0;
					gg = 0;
					bb = 0;
				break;
				case 1: //Bluish
					rr = .15;
					gg = .25;
					bb = 1;
				break;
				case 2: //Reddish
					rr = 1;
					gg = .1;
					bb = .15;
				break;
				case 3: //Greenish
					rr = 0;
					gg = 1;
					bb = .5;
				break;
				case 4: //Yellow
					rr = 1;
					gg = 1;
					bb = .15;
				break;
				case 5: //Orange
					rr = 1;
					gg = .65;
					bb = .3;
				break;
				case 6: //Purple
					rr = .7;
					gg = .4;
					bb = .7;
				break;
				case 7: //Infestor
					rr = .61;
					gg = .78;
					bb = .02;
				break;
				case 8: //White
					rr = 1;
					gg = 1;
					bb = 1;
				break;
			}
			return([rr,gg,bb]);
		}
		
		public function GenImage(s:int,id:int,f:int,tc:int,b:int)
		{
			var newBitmap;
			var maskBitmap;
			var classname;
			var maskclassname;
			var pixelvalue:Number;
			var xx:int;
			var yy:int;
			var rr:Number;
			var gg:Number;
			var bb:Number;
			var a;

			//MAIN
			if(s == 0){
				classname = getDefinitionByName("S" + String(id)) as Class;
				if(ApplicationDomain.currentDomain.hasDefinition("S" + String(id) + "M") ){
					maskclassname = getDefinitionByName("S" + String(id) + "M") as Class;
				}
			}
			if(s == 1){
				classname = getDefinitionByName("U" + String(id)) as Class;
				if(ApplicationDomain.currentDomain.hasDefinition("U" + String(id) + "M") ){
					maskclassname = getDefinitionByName("U" + String(id) + "M") as Class;
				}
			}
			if(s == 2){
				classname = getDefinitionByName("T" + String(id)) as Class;
				if(ApplicationDomain.currentDomain.hasDefinition("T" + String(id) + "M") ){
					maskclassname = getDefinitionByName("T" + String(id) + "M") as Class;
				}
			}
			newBitmap = new classname(0,0);
			if(maskclassname != null){
				maskBitmap = new maskclassname(0,0);
			}
			
			//Colors
			a = FactionColors(tc);
			rr = a[0];
			gg = a[1];
			bb = a[2];
			if(maskclassname != null){
				for(xx = 0; xx < newBitmap.width; xx++){
					for(yy = 0; yy < newBitmap.height; yy++){
						if(maskBitmap.getPixel(xx,yy) > 256){
							pixelvalue = 0+Math.floor(bb*(newBitmap.getPixel(xx,yy)& 0xFF))+256*Math.floor(gg*(newBitmap.getPixel(xx,yy) & 0xFF))+256*256*Math.floor(rr*(newBitmap.getPixel(xx,yy) & 0xFF));
							newBitmap.setPixel(xx,yy,pixelvalue);
						}
					}
				}
			}
			ProImage(newBitmap,id,s);
			if(s == 0){
				ssstructs[id][f] = newBitmap;
				//LIGHTS
				if(ApplicationDomain.currentDomain.hasDefinition("S" + String(id) + "L") ){
					classname = getDefinitionByName("S" + String(id) + "L") as Class;
					newBitmap = new classname(0,0);
					PostProcess.Glow(newBitmap,3,.75,true,50,170,255);
					PostProcess.Glow(newBitmap,4,.5,false,0,0,255);
					PostProcess.Bloom(newBitmap,5,1.5);
					ssstructlights[id] = newBitmap;
				}
				if(true){
					classname = getDefinitionByName("S" + String(id)) as Class;
					newBitmap = new classname(0,0);
					PostProcess.ColorShift(newBitmap,-1);
					PostProcess.Glow(newBitmap,10,.25,true,50,100,255);
					PostProcess.Glow(newBitmap,3,1,true,150,200,255);
					PostProcess.Glow(newBitmap,3,1,false,50,100,255);
					PostProcess.Bloom(newBitmap,2,2);
					ProShield(newBitmap,id,s);
					ssstructshields[id] = newBitmap;
				}
			}
			if(s == 1){
				ssships[id][f] = newBitmap;
				//LIGHTS
				if(ApplicationDomain.currentDomain.hasDefinition("U" + String(id) + "L") ){
					classname = getDefinitionByName("U" + String(id) + "L") as Class;
					newBitmap = new classname(0,0);
					PostProcess.Glow(newBitmap,3,.75,true,50,170,255);
					PostProcess.Glow(newBitmap,4,.5,false,0,0,255);
					PostProcess.Bloom(newBitmap,5,1.5);
					ssshiplights[id] = newBitmap;
				}
				//BURNS
				if(ApplicationDomain.currentDomain.hasDefinition("U" + String(id) + "B") ){
					classname = getDefinitionByName("U" + String(id) + "B") as Class;
					newBitmap = new classname(0,0);
					
					ProBurn(b,newBitmap);
					
					ssshipburns[id][b] = newBitmap;
				}
				//SHIELDS
				if(true){
					classname = getDefinitionByName("U" + String(id)) as Class;
					newBitmap = new classname(0,0);
					PostProcess.ColorShift(newBitmap,-1);
					PostProcess.Glow(newBitmap,10,.25,true,50,100,255);
					PostProcess.Glow(newBitmap,3,1,true,150,200,255);
					PostProcess.Glow(newBitmap,3,1,false,50,100,255);
					PostProcess.Bloom(newBitmap,2,2);
					ProShield(newBitmap,id,s);
					ssshipshields[id] = newBitmap;
				}
			}
			if(s == 2){
				ssturrets[id][f] = newBitmap;
			}
		}
		
		public function ProImage(newBitmap, id:int, s:int)
		{
			if(s == 0){
				if(id == 2 || id == 7 || id == 12 || id == 17 || id == 22 || id == 27 || id == 104){
					PostProcess.Bloom(newBitmap,2,3);
					PostProcess.Bloom(newBitmap,2,3);
					PostProcess.Glow(newBitmap,2,1,true,255,255,255);
				}
			}
			if(s == 1){
				if(id == 49 || id == 99 || id == 109){
					PostProcess.Bloom(newBitmap,2,3);
					PostProcess.Bloom(newBitmap,2,3);
					PostProcess.Glow(newBitmap,2,1,true,255,255,255);
				}
			}
			if(s == 2){
				if(id == 48 || id == 47){
					PostProcess.Bloom(newBitmap,2,3);
					PostProcess.Bloom(newBitmap,2,3);
					PostProcess.Glow(newBitmap,2,1,true,255,255,255);
				}
			}
		}
		
		public function ProShield(newBitmap, id:int, s:int)
		{
			if(s == 0){
				if(id == 2 || id == 7 || id == 12 || id == 17 || id == 22 || id == 27 || id == 104){
					PostProcess.Glow(newBitmap,3,10,false,150,200,255);
					PostProcess.Glow(newBitmap,10,10,true,150,200,255);
				}
			}
			if(s == 1){
				if(id == 49 || id == 99 || id == 109){
					PostProcess.Glow(newBitmap,3,10,false,150,200,255);
					PostProcess.Glow(newBitmap,10,10,true,150,200,255);
				}
			}
		}
		
		public function StoreShot(i:int, j:int, k:int)
		{
			var newBitmap;
			var classname;
			
			classname = getDefinitionByName("B" + String(i)) as Class;
			newBitmap = new classname(0,0);
			
			ProShot(i,k,newBitmap);
			
			newBitmap = PostProcess.Shrink(newBitmap,.3 + .175 * j);
			PostProcess.ColorShift(newBitmap,k);
			ssshots[i][j][k] = newBitmap;
			
			//BURN
			if(ApplicationDomain.currentDomain.hasDefinition("B" + String(i) + "B")){
				classname = getDefinitionByName("B" + String(i) + "B") as Class;
				newBitmap = new classname(0,0);
				PostProcess.Glow(newBitmap,1,.75,true,255,0,0);
				PostProcess.Glow(newBitmap,1,.5,false,255,0,0);
				newBitmap = PostProcess.Shrink(newBitmap,.3 + .175 * j);
				//PostProcess.ColorShift(newBitmap,k);
				ssshotburns[i][j] = newBitmap;
			}
		}
		
		public function StoreEffect(i:int, j:int)
		{
			var newBitmap;
			var classname;
			
			classname = getDefinitionByName(sseffecttemplate[i]) as Class;
			newBitmap = new classname(0,0);
			
			ProEffect(i,newBitmap);
			
			newBitmap = PostProcess.Shrink(newBitmap,.3 + .175 * j);
			sseffects[i][j] = newBitmap;
		}
		
		public function ProBurn(i:int,r)
		{
			switch(i){
				case 0: //Red
					PostProcess.Glow(r,3,.75,true,255,50,25);
					PostProcess.Glow(r,4,.5,false,255,0,0);
					PostProcess.Bloom(r,3,1.5);
				break;
				case 1: //Dark Purple
					PostProcess.Glow(r,3,.5,true,150,50,255);
					PostProcess.Glow(r,4,.5,false,150,50,255);
					PostProcess.Bloom(r,3,1.5);
				break;
				case 2: //Purplish
					PostProcess.Glow(r,3,.5,true,200,100,255);
					PostProcess.Glow(r,4,.5,false,200,100,255);
					PostProcess.Bloom(r,3,1.5);
				break;
				case 3: //Cyan
					PostProcess.Glow(r,10,10,true,30,255,200);
					PostProcess.Glow(r,4,.5,false,30,200,255);
					PostProcess.Bloom(r,3,1.5);
				break;
				case 4: //Bright Cyan
					PostProcess.Glow(r,10,10,true,60,255,220);
					PostProcess.Glow(r,4,.5,false,60,220,255);
					PostProcess.Bloom(r,3,1.5);
				break;
				case 5: //Brighter Cyan
					PostProcess.Glow(r,10,10,true,90,255,230);
					PostProcess.Glow(r,4,.5,false,90,230,255);
					PostProcess.Bloom(r,3,1.5);
				break;
			}
		}
		
		public function ProEffect(i:int,r)
		{
			switch(i){
				case 0:
					PostProcess.Bloom(r,3,1);
				break;
				case 1:
					PostProcess.Bloom(r,3,1);
				break;
				case 2:
					PostProcess.Glow(r,13,1,true,200,150,255);
					PostProcess.Bloom(r,3,4);
				break;
				case 3:
					PostProcess.Bloom(r,8,8);
				break;
				case 6:
					//PostProcess.Glow(r,2,.5,true,0,0,255);
					//PostProcess.Glow(r,2,.7,false,50,150,255);   
					PostProcess.Bloom(r,7,4)
				break;
				case 50:
					PostProcess.ColorShift(r,4);
					PostProcess.Glow(r,2,.5,true,0,255,0);
					PostProcess.Glow(r,2,2,false,150,255,50); 
				break;
				case 51:
					PostProcess.ColorShift(r,5);
					PostProcess.Glow(r,5,.5,true,255,50,150);
					PostProcess.Glow(r,2,1,false,255,50,150);
					PostProcess.Bloom(r,3,1)
				break;
				case 52:
					PostProcess.Glow(r,10,1,true,0,255,0);
					PostProcess.Glow(r,5,1,false,50,255,150);
					PostProcess.Bloom(r,2,2);
				break;
				case 53:
					PostProcess.ColorShift(r,3);
					PostProcess.Glow(r,15,.25,true,0,0,100);
					PostProcess.Glow(r,10,.5,true,0,0,255);
					PostProcess.Bloom(r,3,.5);
				break;
				case 54:  
					PostProcess.Bloom(r,7,4)
					PostProcess.ColorShift(r,5);
				break;
				case 55:
					PostProcess.Glow(r,10,10,true,0,0,0);
					PostProcess.Glow(r,5,1,false,0,0,0);
				break;
			}
		}
		
		public function ProShot(i:int,k:int,r)
		{
			switch(i){
				case 0:
					PostProcess.Glow(r,4,.5,true,0,0,255);
					PostProcess.Glow(r,7,.7,false,50,150,255);
					PostProcess.Bloom(r,3,1);
				break;
				case 1:
					PostProcess.Glow(r,4,.5,true,0,0,255);
					PostProcess.Glow(r,7,.7,false,50,150,255);
					PostProcess.Bloom(r,3,1);
				break;
				case 2:
					PostProcess.Glow(r,4,.5,true,0,0,255);
					PostProcess.Glow(r,7,.7,false,50,150,255);  
					PostProcess.Bloom(r,3,1);
				break;
				case 3:
					PostProcess.Glow(r,4,.5,true,0,0,255);
					PostProcess.Glow(r,7,.7,false,50,150,255); 
					PostProcess.Bloom(r,3,1);
				break;
				case 4:
					PostProcess.Glow(r,4,.5,true,0,0,255);
					PostProcess.Glow(r,7,.7,false,50,150,255);
					PostProcess.Bloom(r,3,1);
				break;
			}
			switch(k){
				case 8:
					PostProcess.Bloom(r,3,2);
				break;
			}
		}
		
		public function ProIcon(i:int,r)
		{
			if(i > 360 && i < 369){
				PostProcess.Bloom(r,7,.5);
			}
		}
		
		public function StoreIcon(i:int,j:int)
		{
			var iconBitmap;
			var newBitmap;
			var newBitmapb;
			var classname;
			
			classname = getDefinitionByName("Rare") as Class;
			newBitmap = new classname(0,0);
			classname = getDefinitionByName("I" + String(i)) as Class;
			iconBitmap = new classname(0,0);
			ProIcon(i,iconBitmap);
			
			if(j == 1){
				PostProcess.ColorShift(newBitmap,110);
			}
			if(j == 2){
				PostProcess.ColorShift(newBitmap,111);
			}
			if(j == 3){
				PostProcess.ColorShift(newBitmap,112);
			}
			
			newBitmap.copyPixels(iconBitmap,new Rectangle(0,0,64,64),new Point(0,0),null,null,true);
			
			if(j == 0){
				PostProcess.Glow(newBitmap,7,.25,false,255,255,255);
			}
			if(j == 1){
				PostProcess.Glow(newBitmap,7,.4,false,100,255,100);
			}
			if(j == 2){
				PostProcess.Glow(newBitmap,7,.4,false,100,100,255);
			}
			if(j == 3){
				PostProcess.Glow(newBitmap,7,1,false,255,0,50);
			}
			
			sslargeicons[i][j] = newBitmap;
			newBitmapb = PostProcess.Shrink(newBitmap,.5);
			ssicons[i][j] = newBitmapb;
		}
	}
}