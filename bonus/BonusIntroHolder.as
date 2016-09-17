package bonus 
{
	import com.utils.Buttons123;
	import com.utils.StaticGUI;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class BonusIntroHolder extends MovieClip
	{
		private var nc:NetConnection;
		private var vid:Video;
		private var ns:NetStream;
		private var pp:MovieClip;
		private var skip_btn:MovieClip;
		private var bmp:Bitmap;
		private var rectangle:Shape;
		
		public static var cont:BonusIntroHolder;
		
		//skip
		
		
		public function BonusIntroHolder(pp:MovieClip) 
		{
			this.pp = pp;
			
			cont = this;
		}
		
		private function onSkip(e:MouseEvent):void 
		{
			
			closeIntro();
		}
		
		public function closeIntro():void
		{
			Tracer._log("closeIntro");
			try 
			{
				ns.close();
			}
			catch (err:Error)
			{
				
			}
			skip_btn.removeEventListener(MouseEvent.CLICK, onSkip);
			removeEventListener(Event.ENTER_FRAME, onEnter);
			this.visible = false;
			//dispatchEvent(new GameEvents(GameEvents.VIDEO_CLOSE));
			
			ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler); 
			ns.removeEventListener(NetStatusEvent.NET_STATUS, statusChanged);
			
			
			/*this.parent.removeChild(this);*/
			this.removeChildren();
			
			rectangle = null;
			ns = null;
			nc = null;
			bmp = null;
			skip_btn = null;
			vid = null
			cont = null;
			
			pp.removeBonusIntroAndLoadBonus();
			pp = null;
		}
		
		public function showVideo():void
		{
			rectangle = new Shape(); 
			rectangle.graphics.beginFill(0x000000);
			rectangle.graphics.drawRect(0, 0, stage.stageWidth,stage.stageHeight); 
			rectangle.graphics.endFill(); 
			addChild(rectangle);
			
			nc = new NetConnection(); 
			nc.connect(null);

			ns = new NetStream(nc); 
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler); 
			ns.addEventListener(NetStatusEvent.NET_STATUS, statusChanged);
			ns.play("video/bonus.flv"); 
			

			vid = new Video(); 
			vid.attachNetStream(ns); 
			addChild(vid);
			//addChildAt(vid, 1);
			
			addEventListener(Event.ENTER_FRAME, onEnter);
			
			skip_btn = new MovieClip();
			bmp = new Assets.skipBonusIntroImg();
			bmp.smoothing = true;
			skip_btn.addChild(bmp);
			addChild(skip_btn);
			
			skip_btn.buttonMode = true;
			skip_btn.addEventListener(MouseEvent.CLICK, onSkip);
			
			
		}
		
		private function statusChanged(stats:NetStatusEvent):void
		{
			if (stats.info.code == 'NetStream.Play.Stop') 
			{
				closeIntro();
			}
		}
		
		
		private function asyncErrorHandler(event:AsyncErrorEvent):void 
		{ 
			// ignore error 
		}
		
		private function onEnter(e:Event):void
		{
			skip_btn.y = 0;
			skip_btn.x = stage.stageWidth  - skip_btn.width + skip_btn.width/11;
			skip_btn.scaleX = vid.scaleX/2.525;
			skip_btn.scaleY = vid.scaleY/2.316;
			//vid.y = -stage.stageHeight/2;
			//vid.x  = -stage.stageWidth/2;
			vid.width = stage.stageWidth;
			vid.height =  stage.stageHeight;
		}
		
		
	}

}