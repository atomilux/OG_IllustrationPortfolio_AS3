package atlx {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.display.Stage;
	import atlx.Debugger;
	import atlx.MasterLoader;
	import atlx.Gallery;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	public class Gallery {
		
		static public var fullSizeImageContainer:MovieClip;
		static public var shell:MovieClip;
		static public var gallery_bg:MovieClip;
		static public var current_img:Loader;
		static public var soundEffect:SE_06 = new SE_06();
		static public var closeSoundFX:SE_018 = new SE_018();
		static public var soundFXchannel:SoundChannel = new SoundChannel();
		
		// constructor code
		public function Gallery() {
			
		}
		
		static public function resizeBackground(evt:Event):void {
			Debugger.debug("Gallery::resizeBackground() - stageWidth: " + gallery_bg.stage.stageWidth);
			Debugger.debug("Gallery::resizeBackground() - stageHeight: " + gallery_bg.stage.stageHeight);
			gallery_bg.width = gallery_bg.stage.stageWidth;
			gallery_bg.height = gallery_bg.stage.stageHeight;
			gallery_bg.x = ((gallery_bg.stage.stageWidth/2) - (gallery_bg.width/2)) - shell.x;
			
		}
		
		static public function setContainer(cont:MovieClip):void {
			fullSizeImageContainer = cont;
			shell = cont.parent as MovieClip;
			setMouseEnable(false);
		}
		
		static public function getContainer():MovieClip {
			return fullSizeImageContainer;
		}
		
		static public function setBgRef(ref:MovieClip):void {
			gallery_bg = ref;
			gallery_bg.stage.addEventListener(Event.RESIZE, resizeBackground);
			
			//background will always be live. Also helps if we have a misload to hide MC
			gallery_bg.addEventListener(MouseEvent.CLICK,bgClick);
		}
		
		static public function addLoaderToGallery(ldr:Loader):void {
			Debugger.debug("addLoaderToGallery() - ldr: " + ldr.name);
			fullSizeImageContainer.addChild(ldr);
			ldr.addEventListener(MouseEvent.CLICK,fullImageClick);
			ldr.x = -5000;
			ldr.y = -5000;
		}
		
		static public function loadGalleryItem(str:String):void {
			
			Debugger.debug("loadGalleryItem() - str: " + str);
			Debugger.debug("loadGalleryItem() - fullSizeImageContainer: " + fullSizeImageContainer);
			var itm:Loader = fullSizeImageContainer.getChildByName(str) as Loader;
			Debugger.debug("loadGalleryItem() - itm: " + itm);
			
			Debugger.debug("loadGalleryItem() - itm.stage.stageWidth: " + itm.stage.stageWidth);
			Debugger.debug("loadGalleryItem() - itm.stage.stageHeight: " + itm.stage.stageHeight);
			
			Debugger.debug("loadGalleryItem() - itm.width: " + itm.width);
			Debugger.debug("loadGalleryItem() - itm.height: " + itm.height);			
			
			var xLoc = (itm.stage.stageWidth/2) - (itm.width/2);
			var yLoc = (itm.stage.stageHeight/2) - (itm.height/2);
			
			current_img = itm;
			
			turnOffAllGalleryItems();
			
			shell.gotoAndPlay("over");
			
			itm.alpha = 1;
			itm.x = xLoc;
			itm.y = yLoc;
			
		}//end function
		
		static public function turnOffAllGalleryItems():void {
			for (var i=0;i<fullSizeImageContainer.numChildren;i++) {
				var tmpI:Loader = fullSizeImageContainer.getChildAt(i) as Loader;
				tmpI.alpha = 0;
				tmpI.x = -5000;
				tmpI.y = -5000;
			}//end for
		}//end function
		
		static public function connectPortfolioThumb(mc:MovieClip):void {
			
			//a little string magic to make things simpler
			var idStr:String = mc.name;
			var imgPath:String = "images2/"+idStr+".jpg";
			
			//bake up the big portfolio item
			//Note:the thumbnail and big image MC names are identical
			//but not in conflict due to the different containers
			var ldr:Loader = new Loader();
			ldr.load(new URLRequest(imgPath));
			ldr.name = idStr;
			
			//connect the big image with our fancy shmancy classes
			MasterLoader.registerLoader(ldr);
			Gallery.addLoaderToGallery(ldr);
			
			//make something happen when you click on the thumbnail
			mc.addEventListener(MouseEvent.CLICK,portThumbnailClick);
			
		}
		
		//Each time we click on a thumbnail we need to load up the big pic
		static public function portThumbnailClick(e:MouseEvent):void {
			
			var mc:MovieClip = e.currentTarget as MovieClip;
			Debugger.debug(mc.name + "THUMB CLICK");
			loadGalleryItem(mc.name);
			setMouseEnable(true);
			
			playFXsound();
		}
		
		static public function playFXsound():void {
			//play sound effect
			soundFXchannel = soundEffect.play();
		}
		
		static public function fullImageClick(e:MouseEvent):void {
			var ldr:Loader = e.currentTarget as Loader;
			Debugger.debug(ldr.name + "FULL SIZE CLICK");
			
			shell.gotoAndPlay("out");
			
			ldr.x = -5000;
			ldr.y = -5000;
			
			soundFXchannel = closeSoundFX.play();
		}
		
		static public function bgClick():void {
			Debugger.debug("Gallery::bgClick()");
			shell.gotoAndPlay("out");
			current_img.x = -5000;
			current_img.y = -5000;
			soundFXchannel = closeSoundFX.play();  
		}
		
		static private function setMouseEnable(switchOn:Boolean):void {
			if (switchOn == true) { 
				fullSizeImageContainer.mouseEnabled = true;
				fullSizeImageContainer.mouseChildren = true;
				gallery_bg.mouseEnabled = true;
				gallery_bg.mouseChildren = true;
			
				shell.mouseChildren = true;
				shell.mouseEnabled = true;
			}
			
			if (switchOn == false) {
				fullSizeImageContainer.mouseEnabled = false;
				fullSizeImageContainer.mouseChildren = false;
				gallery_bg.mouseEnabled = false;
				gallery_bg.mouseChildren = false;
			
				shell.mouseChildren = false;
				shell.mouseEnabled = false;
				
			}
		}
		
	}//end class
	
}//end package
