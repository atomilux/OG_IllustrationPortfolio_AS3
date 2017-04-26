package atlx {
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import atlx.Debugger;
	import atlx.Gallery;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	public class MasterLoader {
		
		private static var totalBytes:Number;
		private static var loadedBytes:Number;
		
		private static var loadObjs:Object = new Object();
		
		private static var id:Number = 0;
		
		public function MasterLoader() {
			Debugger.debug("MasterLoader init()");
		}
		
		static public function registerLoader(ldr:Loader) {
			Debugger.debug("registerLoader() - ldr: " + ldr.name);
			loadObjs[id] = ldr;
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
			Gallery.addLoaderToGallery(ldr);//drop it into the Gallery Obj and MC
			
			id++;
		}
		
		static public function updateTotalBytes():void {
			
			var tmpTotal:Number = 0;
			
			for (var i in loadObjs) {
				
				var tmpLdr:Loader = loadObjs[i] as Loader;
				
				trace("updateLoadedBytes() - i: " + loadObjs[i] + " - name: " + tmpLdr.name + " -parent:" + tmpLdr.parent.name);
								
				Debugger.debug("updateTotalBytes() - tmpLdr: " + tmpLdr.name);
				Debugger.debug("updateTotalBytes() - tmpLdr.bytesLoaded: " + String(tmpLdr.contentLoaderInfo.bytesLoaded));
				Debugger.debug("updateTotalBytes() - tmpLdr.bytesTotal: " + String(tmpLdr.contentLoaderInfo.bytesTotal));
				
				tmpTotal += tmpLdr.contentLoaderInfo.bytesTotal;
				
			}//end for
			
			Debugger.debug("updateTotalBytes() - tmpTotal: " + tmpTotal);
			
			totalBytes += tmpTotal;
			
			Debugger.debug("updateLoadedBytes() - totalBytes: " + totalBytes);
			
		}//end function
		
		static public function updateLoadedBytes():void {
			
			var tmpTotal:Number = 0;
			
			for (var i in loadObjs) {
				
				trace("updateLoadedBytes() - i: " + i);
				
				var tmpLdr:Loader = loadObjs[i] as Loader;
				
				Debugger.debug("updateLoadedBytes() - tmpLdr: " + tmpLdr.name + " -parent:" + tmpLdr.parent.name);
				Debugger.debug("updateLoadedBytes() - tmpLdr.contentLoaderInfo.bytesLoaded: " + tmpLdr.contentLoaderInfo.bytesLoaded);
				Debugger.debug("updateLoadedBytes() - tmpLdr.contentLoaderInfo.bytesTotal: " + tmpLdr.contentLoaderInfo.bytesTotal);
				
				tmpTotal += tmpLdr.contentLoaderInfo.bytesLoaded;
				
			}//end for
			
			Debugger.debug("updateLoadedBytes() - tmpTotal: " + tmpTotal);
			
			loadedBytes += tmpTotal;
			
			Debugger.debug("updateLoadedBytes() - loadedBytes: " + loadedBytes);
			
		}//end function
		
		public static function get_totalBytes():Number {
			Debugger.debug("get_loadedBytes() - totalBytes: " + totalBytes);
			return Number(totalBytes.toString());
		}
		
		public static function get_loadedBytes():Number {
			Debugger.debug("get_loadedBytes() - loadedBytes: " + loadedBytes);
			return Number(loadedBytes.toString());
		}
		
		private static function progressHandler(e:ProgressEvent):void {
			var ldr:LoaderInfo = e.currentTarget as LoaderInfo;
			Debugger.debug("progressHandler() - Loader: " + ldr.loader.name);
			Debugger.debug("progressHandler() - progress: " + ldr.bytesTotal);
		}
		
		private static function completeHandler(e:Event):void {
			var tmpLdr:LoaderInfo = e.currentTarget as LoaderInfo;
			Debugger.debug("loadComplete() - load complete: " + tmpLdr.loader.name);
		}
		
		private static function errorHandler(e:IOErrorEvent):void {
			var tmpLdr:LoaderInfo = e.currentTarget as LoaderInfo;
			Debugger.debug("loadError() - load ERROR: " + tmpLdr.loader.name + " -- " + e);
		}

	}//end class
	
}//end package
