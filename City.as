package atlx {
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	
	public class City extends MovieClip{
		
		//Vars used in city move calcs
		protected var cityMoveObj:Object = new Object();
		public var timer:Timer
		public var allowPort = true;
		
		protected var newTweenMoveX:Tween;
		protected var newTweenMoveY:Tween;
		
		protected var id:String = "City::";
		
		public function City() {
			
			timer = new Timer(50,100000);
			timer.addEventListener("timer",timerTick);
			
			cityMoveObj.sliderDecayIncrementX = 0;
			cityMoveObj.sliderDecayIncrementY = 0;
			
			cityMoveObj.startDragX = null;
			cityMoveObj.startDragY = null;
			
			cityMoveObj.stopDragX = null;
			cityMoveObj.stopDragY = null;
			
			cityMoveObj.skidX = null
			cityMoveObj.skidY = null;
			
			cityMoveObj.destX = 0;
			cityMoveObj.destY = 0;
			
			cityMoveObj.distTravX = 0;
			cityMoveObj.distTravY = 0;
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,dragStartTrack);
			this.addEventListener(MouseEvent.MOUSE_UP,dragStopCalc);
			
			newTweenMoveX = new Tween(this,"alpha", Strong.easeOut, 1, 1, 0);
			newTweenMoveY = new Tween(this,"alpha", Strong.easeOut, 1, 1, 0);
			
			trace(id + "constructor");
		
		}//end function
		
		public function get_allowPort():Boolean {
			return allowPort;
		}
		
		public function set_allowPort(md:Boolean):void {
			trace(id + "set_allowPort - md: " + md);
			allowPort = md;
		}
		
		public function get_timerActive():Boolean {
			trace(id + "get_timerActive - timer.running: " + timer.running);
			return timer.running; 
		}
		
		//---------------------------------------------
		// 				TRACKING CITY
		//---------------------------------------------
		
		//a per loop multiplier to gauge the speed of which
		//the item is dragged
		
		//i.e. larger nums = greater intensity 
		//smaller nums = smaller intensity
		protected function timerTick(evt:TimerEvent):void {
			
			trace(id + "timerTick()");
			
			var tmpX = this.x;
			var tmpY = this.y;
			
			var minX = Math.min(tmpX,cityMoveObj.skidX);
			var maxX = Math.max(tmpX,cityMoveObj.skidX);
			
			var minY = Math.min(tmpY,cityMoveObj.skidY);
			var maxY = Math.max(tmpY,cityMoveObj.skidY);
			
			cityMoveObj.distTravX = (maxX - minX) * 2;
			cityMoveObj.distTravY = (maxY - minY) * 2;
			
			//update for next
			cityMoveObj.skidX = this.x;
			cityMoveObj.skidY = this.y;
			
		}//end function
		
		
		
		
		// ---------- when a user STARTS DRAGGING the city -------------
		protected function dragStartTrack(evt:MouseEvent):void {
			
			trace(id + "dragStartTrack()");	
			
			if (allowPort == false) {
				trace(id + "dragStartTrack() - die");	
				return;
			}
			
			var checkTween = newTweenMoveX.isPlaying;			
			
			if (newTweenMoveX.isPlaying == true) { newTweenMoveX.stop();}
			if (newTweenMoveY.isPlaying == true) { newTweenMoveY.stop();}
			
			timer.start();
			this.startDrag();
			
			//check for first time run
			if (cityMoveObj.skidX == null || cityMoveObj.skidY == null) {
				
				cityMoveObj.skidX = this.x;
				cityMoveObj.skidY = this.y;
				
			}//end if	
			
			cityMoveObj.startDragX = this.x;
			cityMoveObj.startDragY = this.y;
			
		}//end function
		
		
		
		
		// ---------- when a user STOPS DRAGGING the city -------------
		protected function dragStopCalc(evt:MouseEvent):void {
			
			trace(id + "dragStopCalc()");
			
			if (allowPort == false) {
				return;
			}
			
			timer.stop();
			this.stopDrag();
			
			cityMoveObj.stopDragX = this.x;
			cityMoveObj.stopDragY = this.y;
			
			//which way are we moving
			if (cityMoveObj.startDragX < cityMoveObj.stopDragX) {
				cityMoveObj.destX = (cityMoveObj.stopDragX + cityMoveObj.distTravX) ;
			}
			
			if (cityMoveObj.startDragX > cityMoveObj.stopDragX) {
				cityMoveObj.destX = cityMoveObj.stopDragX - cityMoveObj.distTravX;
			}
			
			if (cityMoveObj.startDragY < cityMoveObj.stopDragY) {
				cityMoveObj.destY = cityMoveObj.stopDragY + cityMoveObj.distTravY;
			}
			
			if (cityMoveObj.startDragY > cityMoveObj.stopDragY) {
				cityMoveObj.destY = cityMoveObj.stopDragY - cityMoveObj.distTravY;
			}
			
			//Insure we're not too far off the grid
			if (cityMoveObj.destY > -100) {
				cityMoveObj.destY = -100;
			}
			
			if (cityMoveObj.destX > -100) {
				cityMoveObj.destX = -100;
			}
				
			trace(id + "dragStopCalc() - cityMoveObj.destX: " + cityMoveObj.destX);	
			trace(id + "dragStopCalc() - cityMoveObj.destY: " + cityMoveObj.destY);	
				
			var tooFarX = -this.width + stage.stageWidth;
			var tooFarY = -this.height + stage.stageHeight;
			
			if (cityMoveObj.destX < tooFarX) {
				//trace("City has been moved on X too far");
				cityMoveObj.destX = tooFarX;
			} 
			
			if (cityMoveObj.destY < tooFarY) {
				//trace("City has been moved on Y too far");
				cityMoveObj.destY = tooFarY;
			}
			
			newTweenMoveX = new Tween(this,"x", Strong.easeOut, this.x, cityMoveObj.destX, 50);
			newTweenMoveY = new Tween(this,"y", Strong.easeOut, this.y, cityMoveObj.destY, 50);
			
		}//end function

	}//end class
	
}//end package