package atlx  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.display.Loader;
	import flash.utils.Timer;
	import atlx.City;
	import flash.geom.Matrix;
	import flash.geom.Transform;
	
	public class PortfolioItem extends MovieClip {
		
		//Vars used in deSkew and reSkewing of port images
		protected var originalCoords:Object = new Object();
		protected var scopedPortItem:MovieClip;
		protected var cityRef:City;
		protected var allowPort:Boolean;
		protected var nav:MovieClip;
		
		public function PortfolioItem() {
			this.addEventListener(MouseEvent.CLICK,clickHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER,function (e:MouseEvent):void { trace('OVER') });
			
			cityRef = this.parent as City;
			trace("PortfolioItem() - cityRef: " + cityRef);
			trace("PortfolioItem() - cityRef.allowPort: " + cityRef.allowPort);
		}//end function
		
		//set reference to city's timer
		public function setCityRefs(c:City):void {
			cityRef = c;
		}
		
		public function setNavRef(n:MovieClip):void {
			nav = n;
		}
		
		protected function allowPortCheck():Boolean {
			return cityRef.allowPort;
		}
		
		//---------------------------------------------
		// 				PORTFOLIO ITEM
		//---------------------------------------------
				
		function clickHandler(evt:MouseEvent):void {
			
			trace("clickHandler()");
			
			//kill any portfolio activities until the tween is done
			if (cityRef.timer.running == true) {
				return;
			}	
			
			//2nd trap - means we have a port piece up already
			if (cityRef.allowPort == false) {
				return;
			}
			
			//set this to kill until the user closes the port item
			allowPort = false;
			
			//scope it in
			var me:MovieClip = evt.currentTarget as MovieClip;
			scopedPortItem = me;//we'll need to remember this
			
			//move it to the display container
			//var cityMC:MovieClip = me.parent as MovieClip;
			var activePortItemCont:MovieClip = cityRef.getChildByName("activePortItemCont") as MovieClip;
			originalCoords.clickedMC = me;
			originalCoords.swappedMC = cityRef.getChildAt(cityRef.numChildren-1);
			
			//swap clicked port item to the highest level
			cityRef.swapChildren(originalCoords.clickedMC,originalCoords.swappedMC);
			
			var tst:Number = Math.abs(-10);
				
			//remember orignal values for reset
			originalCoords.x = me.x;
			originalCoords.y = me.y;
			originalCoords.width = me.width;
			originalCoords.height = me.height;
			originalCoords.mc = me;
			
			//grab the original transformation matrix props
			originalCoords.a = me.transform.matrix.a;
			originalCoords.b = me.transform.matrix.b;
			originalCoords.c = me.transform.matrix.c;
			originalCoords.d = me.transform.matrix.d;
			originalCoords.tx = me.transform.matrix.tx;
			originalCoords.ty = me.transform.matrix.ty;
			
			/*
			trace("clickHandler() originalCoords.x: " + originalCoords.x);
			trace("clickHandler() originalCoords.y: " + originalCoords.y);
			trace("clickHandler() originalCoords.width: " + originalCoords.width);
			trace("clickHandler() originalCoords.height: " + originalCoords.height);
			*/
			
			trace("clickHandler() originalCoords.a: " + originalCoords.a);
			trace("clickHandler() originalCoords.b: " + originalCoords.b);
			trace("clickHandler() originalCoords.c: " + originalCoords.c);
			trace("clickHandler() originalCoords.d: " + originalCoords.d);
			trace("clickHandler() originalCoords.tx: " + originalCoords.tx);
			trace("clickHandler() originalCoords.ty: " + originalCoords.ty);
			
			
			//deSkew artwork
			addEventListener(Event.ENTER_FRAME,deSkew);
			
			//when this is done we'll call resizePort()
		
		}//end func
		
		
		//called from clickHandler
		function deSkew(evt:Event):void {
			
			trace("deSkew()");
			//normal matrix: (a=1, b=0, c=0, d=1, tx=13, ty=26.3)
				
			var increment = .1;
			
			var nowA = scopedPortItem.transform.matrix.a;
			var nowB = scopedPortItem.transform.matrix.b;
			var nowC = scopedPortItem.transform.matrix.c;
			var nowD = scopedPortItem.transform.matrix.d;
			
			//trace("deSkew() - BEFORE nowA: " + nowA);
			//trace("deSkew() - BEFORE nowB: " + nowB);
			//trace("deSkew() - BEFORE nowC: " + nowC);
			//trace("deSkew() - BEFORE nowD: " + nowD);
			
			if (nowA > 1) { 
				nowA -= increment;
				if (nowA < 1.2) { nowA = 1 };
			}
			
			if (nowA < 1) {
				nowA += increment;
				if (nowA < .9) { nowA = 1 };
			}
			//----------------------------------------
			
			if (nowB > 0) { 
				nowB -= increment;
				if (nowB < .2) { nowB = 0 };
			}
			
			if (nowB < 0) { 
				nowB += increment;
				if (nowB < .9) { nowB = 0 };
			}
			//-----------------------------------------
		
			if (nowC > 0) { 
				nowC -= increment; 
				if (nowC < .2) { nowC = 0; }
			}
			
			if (nowC < 0) { 
				nowC += increment; 
				if (nowC < .9) { nowC = 0; }
			}	
			
			//------------------------------------------
			
			if (nowD > 1) { 
				nowD -= increment;
				if (nowD < 1.2) { nowD = 1; }
			}
			
			if (nowD < 1) { 
				nowD += increment;
				if (nowD < .9) { nowD = 1; }
			}
			
			//trace("deSkew() - AFTER nowA: " + nowA);
			//trace("deSkew() - AFTER nowB: " + nowB);
			//trace("deSkew() - AFTER nowC: " + nowC);
			//trace("deSkew() - AFTER nowD: " + nowD);
			
			var meMatrix:Matrix = new Matrix(nowA, nowB, nowC, nowD, originalCoords.width, originalCoords.height);
			var trans:Transform = new Transform(scopedPortItem);
			trans.matrix = meMatrix;
			
			scopedPortItem.x = originalCoords.x;
			scopedPortItem.y = originalCoords.y;
			
			if (nowA == 1 && nowB == 0 && nowC == 0 && nowD == 1) {
				
				trace("deSkew() time to turn off");
				
				//we're there, turn this thing off
				removeEventListener(Event.ENTER_FRAME,deSkew);
				
				//update these
				originalCoords.width = scopedPortItem.width;
				originalCoords.height = scopedPortItem.height;
				
				//move out of the city MC
				//city.parent.addChild(scopedPortItem);
				
				//now size port piece up
				resizePort(scopedPortItem);
				
			}
			
		}//end function
		
		//usually called when deSkew is done
		function resizePort(whichPortItem:MovieClip):void {
		
			//trace("whichPortItem: " + whichPortItem.name);
			//trace("matrix: " + whichPortItem.transform.matrix);
			
			//matrix: (a=1.0928802490234375, b=0.5330352783203125, c=0, d=0.39898681640625, tx=13, ty=26.3)
			//normal matrix: (a=1, b=0, c=0, d=1, tx=13, ty=26.3)
			
			var meHeight:Number = whichPortItem.height;
			var meWidth:Number = whichPortItem.width;
			trace("meHeight: " + meHeight);
			trace("meWidth: " + meWidth);
			
			//calculate where we want the piece to scale up to
			var destSize:Number = .8 * stage.stageHeight;
			//trace("destSize - (height): " + destSize);
				
			//calculate what that factor is
			var heightRatio = .9 * (stage.stageHeight/meHeight);
			var widthRatio = .9 * (stage.stageWidth/meWidth);
			//trace("heightRatio: " + heightRatio);
			//trace("widthRatio: " + widthRatio);
			
			var scaleUpRatio = Math.min(widthRatio,heightRatio);
			//trace("scaleUpRatio: " + scaleUpRatio);
			
			//calculate the corresponding width should be based on factor
			var scaleUpWidthNum = Math.round(whichPortItem.width * scaleUpRatio);
			var scaleUpHeightNum = Math.round(whichPortItem.height * scaleUpRatio);
			//trace("scaleUpWidthNum: " + scaleUpWidthNum);
			//trace("scaleUpHeightNum: " + scaleUpHeightNum);
				
			whichPortItem.width = scaleUpWidthNum;
			whichPortItem.height = scaleUpHeightNum;
			
			var destY = .1 * stage.stageHeight;
			var destX = (stage.stageWidth/2) - (scaleUpWidthNum/2);
			//trace("destY: " + destY);
			//trace("destX: " + destX);	
			
			if (cityRef.x > 0) {
				destX -= cityRef.x;
			} else {
				destX += -(cityRef.x);
			}
			
			if (cityRef.y > 0) {
				destY -= cityRef.y;
			} else {
				destY += -(cityRef.y);
			}
			
			trace("resizePort() - destX: " + destX);
			trace("resizePort() - destY: " + destY);
				
			var newTween:Tween = new Tween(whichPortItem,"height", Strong.easeOut, meHeight, scaleUpHeightNum, 50);
			var newTween2:Tween = new Tween(whichPortItem,"width", Strong.easeOut, meWidth, scaleUpWidthNum, 50);
			var newTween3:Tween = new Tween(whichPortItem,"x", Strong.easeOut, whichPortItem.x, destX, 50);
			var newTween4:Tween = new Tween(whichPortItem,"y", Strong.easeOut, whichPortItem.y, destY, 50);
			
			newTween4.addEventListener(TweenEvent.MOTION_FINISH,assignNav);
				
		}//end function
		
		function assignNav(evt:TweenEvent):void {
				
			nav.x = scopedPortItem.x;
			nav.y = scopedPortItem.y - nav.height;
			
			if (cityRef.x >= 0) {
				nav.x += cityRef.x;
			} else {
				nav.x -= -(cityRef.x);
			}
			
			if (cityRef.y >= 0) {
				nav.y += cityRef.y;
			} else {
				nav.y -= -(cityRef.y);
			}
			
			var bgBar:MovieClip = MovieClip(nav.getChildByName("bgBar"));
			var navX:MovieClip = MovieClip(nav.getChildByName("navX"));
			bgBar.width = scopedPortItem.width;
			
			navX.x = bgBar.width - navX.width;
			var newTween6:Tween = new Tween(nav,"alpha", Strong.easeOut, nav.alpha, 1, 100);
			navX.addEventListener(MouseEvent.CLICK,callReSkew);
			
		}
		
		
		
		
		
		/*==========================================
		
					RESET TO ORIGINAL
		
		===========================================*/
		
		function rawDiff(numA:Number,numB:Number):Number {
			var largerNum:Number = Math.max(numA, numB);
			var smallerNum:Number = Math.min(numA, numB);
			var rawDiffNum:Number = largerNum = smallerNum;
			return Math.abs(rawDiffNum);
		}
		
		//reset the port item
		function reSkew(evt:Event):void {
			
			//turn city click handlers back on
			//cityDragToggle("on");
			
			//normal matrix: (a=1, b=0, c=0, d=1, tx=13, ty=26.3)
				
			var increment = .1;
			
			var nowA = scopedPortItem.transform.matrix.a;
			var nowB = scopedPortItem.transform.matrix.b;
			var nowC = scopedPortItem.transform.matrix.c;
			var nowD = scopedPortItem.transform.matrix.d;
			var nowTX = scopedPortItem.transform.matrix.tx;
			var nowTY = scopedPortItem.transform.matrix.ty;
			
			/*
			trace("reSkew() - AFTER nowA: " + nowA);
			trace("reSkew() - AFTER nowB: " + nowB);
			trace("reSkew() - AFTER nowC: " + nowC);
			trace("reSkew() - AFTER nowD: " + nowD);		
			trace("reSkew() - AFTER nowTX: " + nowTX);	
			trace("reSkew() - AFTER nowTY: " + nowTY);	
			*/
			 
			var numDistA:Number = rawDiff(nowA,originalCoords.a);
			var numDistB:Number = rawDiff(nowB,originalCoords.b);
			var numDistC:Number = rawDiff(nowA,originalCoords.c);
			var numDistD:Number = rawDiff(nowA,originalCoords.d);
			
			var numDistTX:Number = rawDiff(nowTX,originalCoords.tx);
			var numDistTY:Number = rawDiff(nowTY,originalCoords.ty);
		
			
			if (nowA > originalCoords.a) { 
				nowA -= increment;
				if (nowA < 1.2) { nowA = originalCoords.a };
			}
			
			if (nowA < originalCoords.a) {
				nowA += increment;
				if (nowA < .9) { nowA = originalCoords.a };
			}
			//----------------------------------------
			
			if (nowB > originalCoords.b) { 
				nowB -= increment;
				if (nowB < .2) { nowB = originalCoords.b };
			}
			
			if (nowB < originalCoords.b) { 
				nowB += increment;
				if (nowB < .9) { nowB = originalCoords.b };
			}
			//-----------------------------------------
		
			if (nowC > originalCoords.c) { 
				nowC -= increment; 
				if (nowC < .2) { nowC = originalCoords.c; }
			}
			
			if (nowC < originalCoords.c) { 
				nowC += increment; 
				if (nowC < .9) { nowC = originalCoords.c; }
			}	
			
			//------------------------------------------
			
			if (nowD > originalCoords.d) { 
				nowD -= increment;
				if (nowD < 1.2) { nowD = originalCoords.d; }
			}
			
			if (nowD < originalCoords.d) { 
				nowD += increment;
				if (nowD < .9) { nowD = originalCoords.d; }
			}
			
			
			//trace("deSkew() - AFTER nowA: " + nowA);
			//trace("deSkew() - AFTER nowB: " + nowB);
			//trace("deSkew() - AFTER nowC: " + nowC);
			//trace("deSkew() - AFTER nowD: " + nowD);
			
			var meMatrix:Matrix = new Matrix(nowA, nowB, nowC, nowD, nowTX, nowTY);
			//var meMatrix:Matrix = new Matrix(originalCoords.a, originalCoords.b, originalCoords.c, originalCoords.d, originalCoords.tx, originalCoords.ty);
			var trans:Transform = new Transform(scopedPortItem);
			trans.matrix = meMatrix;
			
			scopedPortItem.x = originalCoords.x;
			scopedPortItem.y = originalCoords.y;
			
			// && nowTX == originalCoords.tx && nowTY == originalCoords.ty
			if (nowA == originalCoords.a && nowB == originalCoords.b && nowC == originalCoords.c && nowD == originalCoords.d) {
				
				trace("reSkew() time to turn off");
				
				//we're there, turn this thing off
				removeEventListener(Event.ENTER_FRAME,reSkew);
				
				//update these
				originalCoords.width = scopedPortItem.width;
				originalCoords.height = scopedPortItem.height;
				
				//now size port piece up
				movePortItemBack();
				
			}//end if
			
		}//end function
		
		
		function callReSkew(evt:MouseEvent):void {
				
			//deSkew artwork
			addEventListener(Event.ENTER_FRAME,reSkew);
			
		}//end function
		
		function movePortItemBack():void {
			
			var newTween8:Tween = new Tween(scopedPortItem,"x", Strong.easeOut, scopedPortItem.x, originalCoords.x, 50);
			var newTween9:Tween = new Tween(scopedPortItem,"y", Strong.easeOut, scopedPortItem.y, originalCoords.y, 50);
			var newTween10:Tween = new Tween(nav,"y", Strong.easeOut, nav.y, nav.y - 50, 50);
			var newTween11:Tween = new Tween(nav,"alpha", Strong.easeOut, nav.alpha, 0, 50);
			
			//allow the user to click on the port again
			allowPort = true;
			
			//reattach to the right level
			cityRef.addChild(originalCoords.mc);
			
		}//end function
		
	}//end class
	
}//end package
