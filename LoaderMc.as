package 
{
	import com.utils.StaticGUI;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureSmoothing;
	import starling.utils.Align;
	import starling.utils.Color;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class LoaderMc extends Sprite
	{
		private var bgMc:Sprite;
		private var quad:Quad;
		private var loaderMC:MovieClip;
		
		public function LoaderMc() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			bgMc = new Sprite();
			addChild(bgMc);
			quad = new Quad(this.stage.stageWidth + 40, this.stage.stageHeight + 40, Color.BLACK);
			quad.alignPivot(Align.CENTER, Align.CENTER);
			bgMc.addChild(quad);
			bgMc.alpha = 0.5;
			
			
			loaderMC = new MovieClip(Assets.getAtlas("loaderSheet", "loaderSheetXml").getTextures("loader"), 40);
			addChild(loaderMC);
			Starling.juggler.add(loaderMC);
			
		}
		
		public function disposeLoader():void
		{
			StaticGUI.safeRemoveChild(bgMc, true);
			bgMc = null;
			StaticGUI.safeRemoveChild(quad, true);
			quad = null;
			
			Starling.juggler.remove(loaderMC);
			StaticGUI.safeRemoveChild(loaderMC, true);
			bgMc = null;
		}
		
	}

}