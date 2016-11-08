package {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import com.greensock.TweenNano;
	
	public class PreloaderImgLoader extends Sprite {
		
		private var $bm:Bitmap;
		private var $loaderThumb:Loader;
		private var $bmd:BitmapData;
		private var $loadedImage:DisplayObject;
		private var $lc:LoaderContext;
		private var $imgPath:String;
		
		public function PreloaderImgLoader(img:String) {
			$imgPath = img;
			
			addEventListener(Event.ADDED_TO_STAGE, _added);
		}
		
		private function _added(e:Event):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, _added);
			addEventListener(Event.REMOVED_FROM_STAGE, _removed);

			$lc = new LoaderContext(true);
			$lc.checkPolicyFile = true;
			$loaderThumb = new Loader;
			$loaderThumb.contentLoaderInfo.addEventListener(Event.COMPLETE, avatarIonLoad);
			$loaderThumb.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			$loaderThumb.load(new URLRequest($imgPath), $lc);
			
		
		}
		
		private function _removed(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _removed);
			stage.removeEventListener(Event.RESIZE, resizeListener);
			
			try {
				$loaderThumb.close();
			} catch (e:Error) {
				
			}
			TweenNano.killTweensOf($bm);
			$bm = null;
			$loaderThumb.contentLoaderInfo.removeEventListener(Event.COMPLETE, avatarIonLoad);
			$loaderThumb.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			$loaderThumb = null;
			if ($bmd) $bmd.dispose();
			
			$loadedImage = null;
			$lc = null;
			
			this.removeChildren();
		}
		
		private function avatarIonLoad(event:Event):void {
			if (!stage) return;
			try {
				
				var $loadedImage:DisplayObject = DisplayObject(event.target.content);
				
				$bmd = new BitmapData($loadedImage.width, $loadedImage.height, true, 0x00000000);
				$bmd.draw($loadedImage);
				$bm = new Bitmap($bmd);
				$bm.smoothing = true;
				//$cont.x = int(stage.stageWidth / 2 - $cont.width / 2);
				addChild($bm);
				$bm.alpha = 0;
				TweenNano.to($bm, .3, {alpha: 1});
				event.target.contentLoaderInfo.addEventListener(Event.COMPLETE, avatarIonLoad);
				event.target.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				
				stage.addEventListener(Event.RESIZE, resizeListener);
				resizeListener(null);
				
			} catch (error:Error) {
				
				//MainSettings.instance.container.loaderDebugTxt.appendText('\nBig Avatar load Error: '+error.message);
			}
		
		}
		
		private function resizeListener(e:Event):void {
			if ($bm){
				$bm.width = stage.stageWidth;
				$bm.height = stage.stageHeight;
			}
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
				Tracer._log('ssssssssssssssssss' + event);
		}
	
	}

}