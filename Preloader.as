package {
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.system.Security;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	//keep your imports to a minimum!
	//avoid classes with embedded assets, like images or sounds.
	
	[SWF(frameRate = "60", width = "1200", height = "700", backgroundColor = "0x000000")]
	/**
	 * An example of a startup class that displays a preloader for a Starling
	 * app. Uses the <code>-frame</code> compiler argument to include the root
	 * Starling display object on the second frame of the SWF rather than on the
	 * first frame. The first frame loads quickly and can display things on the
	 * native display list while the second frame is still loading.
	 *
	 * <p>DO NOT import or reference anything in this class that you do not want
	 * to include in the first frame. Carefully consider any decision to
	 * import any class that has embedded assets like images or sounds. If you
	 * need embedded assets in the preloader, they should be separate from the
	 * rest of your embedded assets to keep the first frame nice and small.</p>
	 *
	 * <p>The following compiler argument is required to make this work:</p>
	 * <pre>-frame=two,com.example.StarlingRoot</pre>
	 *
	 * <p>Because our StarlingRoot class is a Starling display object, and
	 * because we don't import starling.core.Starling in this class, the
	 * Starling Framework will also be included on frame 2 instead of frame 1.</p>
	 */
	public class Preloader extends MovieClip {
		/**
		 * Just the height of the progress bar.
		 */
		
		public static var _cont:Preloader;
		private var $preloaderMc:MovieClip;
		private var $bgAlpha:MovieClip = new MovieClip;
		private var $bgLoader:PreloaderImgLoader;
		private var timer:Timer;
		private var dotStr:String = "";
		
		/**
		 * Constructor.
		 */
		public function Preloader() {
			//the document class must be a MovieClip so that things can go on
			//the second frame.
			
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			this.stop();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			_cont = this;
			
			
			$bgLoader = new PreloaderImgLoader(IniClass.GET_FILE_FULL_PATH("bg.jpg", true));
			addChild($bgLoader);
			
			
			$bgAlpha.graphics.beginFill(0x000000, 1);
			$bgAlpha.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			$bgAlpha.graphics.endFill();
			addChild($bgAlpha);
			$preloaderMc = new preloader_mc();
			addChild($preloaderMc);
			
			
			timer = new Timer(300,0);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			
			//we listen to ProgressEvent.PROGRESS to update the progress bar.
			this.loaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderInfo_progressHandler);
			
			//we listen to Event.COMPLETE to know when the SWF is completely loaded.
			this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
			stage.addEventListener(Event.RESIZE, resizeListener); 
			
			resizeListener(null);

		}
		
		private function resizeListener(e:Event):void {
			$preloaderMc.x = int(this.stage.stageWidth - $preloaderMc.width) / 2;
			$preloaderMc.y = int(this.stage.stageHeight - $preloaderMc.height) / 2;
			
			$bgAlpha.width = this.stage.stageWidth;
			$bgAlpha.height = this.stage.stageHeight;
			
		}
		
		

		/**
		 * This is typed as Object so that the compiler doesn't include the
		 * starling.core.Starling class in frame 1. We'll access the Starling
		 * class dynamically once the SWF is completely loaded.
		 */
		//private var _starling:Object;
		
		
		/**
		 * You'll get occasional progress updates here. event.bytesLoaded / event.bytesTotal
		 * will give you a value between 0 and 1. Multiply by 100 to get a value
		 * between 0 and 100. For the nearest integer, use Math.floor().
		 */
		private function loaderInfo_progressHandler(event:ProgressEvent):void {
			
			
			//this example draws a basic progress bar
			/*this.graphics.clear();
			this.graphics.beginFill(0xcccccc);
			this.graphics.drawRect(0, (this.stage.stageHeight - PROGRESS_BAR_HEIGHT) / 2, this.stage.stageWidth * event.bytesLoaded / event.bytesTotal, PROGRESS_BAR_HEIGHT);
			this.graphics.endFill();*/
			_loadingProgressCue(event.bytesTotal,event.bytesLoaded,null, 'LOADING...'), [0,10]
				
		}
		
		
		
		
		public function _loadingProgressCue(_byteTotal:Number = -1, _byteLoaded:Number = -1, callBack:Function = null, text:String = '', progPercent:Array = null):void{
			var bytesLoaded:Number = _byteLoaded;
			var bytesTotal:Number = _byteTotal;
			
			if (progPercent == null)
			{
				progPercent = [0, 100];
			}
			
			var totalWidth:int = 309;
			var curWidth:Number = progPercent[0] / 100 + (progPercent[1] / 100 - progPercent[0] / 100) * (bytesLoaded / bytesTotal);
			
			var $intBytes:int = curWidth * totalWidth;
			
			var s:String = "";
			var percent:Number = 0;
			if (bytesTotal>0){
				percent = Math.floor(progPercent[0] + (progPercent[1] - progPercent[0]) * (bytesLoaded / bytesTotal));
				
				s = String(percent)+' %';
			}
			if (_byteTotal == -1 && _byteLoaded == -1){
				$preloaderMc.loadingCont.percentBox.visible = false;
			}else{
				$preloaderMc.loadingCont.percentBox.visible = true;
			}
			
			$preloaderMc.loadingCont.percentBox.percent_txt.text = s; 
			//$preloaderMc.loadingCont.info_txt.text = text; 
			//$preloaderMc.loadingCont.info_txt.text = 'LOADING...'; 
			
			$preloaderMc.loadingCont.pregressMasker.width += ($intBytes - $preloaderMc.loadingCont.pregressMasker.width) / 1;
			//$preloaderMc.loadingCont.pregressMasker.masker.width += ($intBytes - $preloaderMc.loadingCont.pregressMasker.masker.width) / 5;
			
			if (bytesLoaded==bytesTotal || bytesTotal==0){ //  &&  MainSettings.instance.gameLoader.loader.contentLoaderInfo.bytesLoaded == MainSettings.instance.gameLoader.loader.contentLoaderInfo.bytesTotal
				//$preloaderMc.loadingCont.pregressMasker.width = $intBytes;
				//$preloaderMc.loadingCont.pregressMasker.masker.scaleX = 1;
				
				
				if (callBack != null) callBack();
			}
			$preloaderMc.loadingCont.percentBox.x = int($preloaderMc.loadingCont.pregressMasker.x + $preloaderMc.loadingCont.pregressMasker.width);
		}
		
		
		private function onTimer(e:TimerEvent):void
		{
			try 
			{
				if (dotStr.length == 3)
				{
					dotStr = "";
				}
				else
				{
					dotStr = dotStr + ".";
				}
				$preloaderMc.loadingCont.info_txt.text = "LOADING" + dotStr;
				trace("aaaaa");
			}
			catch (err:Error)
			{
				trace("aaaaa2222");
			}
		}
		
		
		public function _removeThis():void{
			stage.removeEventListener(Event.RESIZE, resizeListener); 
			
			
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			timer = null;
			
			this.removeChild($preloaderMc);
			this.removeChild($bgAlpha);
			this.removeChild($bgLoader);
			
			_cont = null;
			$preloaderMc = null;
			//this.removeChildren();
			//this.parent.removeChild(this);
		}
		
		/**
		 * The entire SWF has finished loading when this listener is called.
		 */
		private function loaderInfo_completeHandler(event:Event):void {
			this.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, loaderInfo_progressHandler);
			this.loaderInfo.removeEventListener(Event.COMPLETE, loaderInfo_completeHandler);
			//get rid of the progress bar
			this.graphics.clear();
			
			//go to frame two because that's where the classes we need are located
			this.gotoAndStop(2);
			
			//getDefinitionByName() will let us access the classes without importing
			var RootType:Class = getDefinitionByName("IniClass") as Class;
			addChild(new RootType);
			
			//that's it!
		}
	}
}