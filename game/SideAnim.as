package game 
{
	import com.utils.MovieclipTextureAdder;
	import com.utils.StaticGUI;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class SideAnim extends Sprite
	{
		private var sideAnimMc:MovieClip;
		
		public function SideAnim() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			initSideAnim();
		}
		
		private function initSideAnim():void 
		{
			
			sideAnimMc = MovieclipTextureAdder.createMultipleAtlasMov([Assets.getAtlas("sideAnim1", "sideAnim1Xml").getTextures(),
																					Assets.getAtlas("sideAnim2", "sideAnim2Xml").getTextures(),
																					Assets.getAtlas("sideAnim3", "sideAnim3Xml").getTextures()],
																					25);
			
			Starling.juggler.add(sideAnimMc);
			addChild(sideAnimMc);
			
			sideAnimMc.addEventListener(Event.COMPLETE, onComplet);
			
			Root.soundManager.PlaySound("sideAnim");
			
		}
		
		private function onComplet(e:Event):void 
		{
			sideAnimMc.stop();
			Starling.juggler.remove(sideAnimMc);
			StaticGUI.safeRemoveChild(sideAnimMc, true);
			sideAnimMc = null;
			
			GameHolder.cont.removeSideAnim();
		}
		
	}

}