package game.machine 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.utils.StaticGUI;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author ...
	 */
	public class MultipleWins extends Sprite
	{
		private var xNum:int;
		private var _atlas:TextureAtlas;
		private var multSp:Image;
		
		private var posAr:Array = [[-300, -160], [-230, -160], [-145, -160]];
		
		public function MultipleWins(xNum:int) 
		{
			this.xNum = xNum;
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			_atlas = Assets.getAtlas("xWinsSheet", "xWinsSheetXml");
			multSp = new Image(_atlas.getTexture("x" + xNum + ".png"));
			
			multSp.x = posAr[xNum - 3][0];
			multSp.y = posAr[xNum - 3][1];
			
			addChild(multSp);
			
			multSp.alpha = 1;
			TweenMax.to(multSp, 0.2, {delay:1.5, alpha:0, onComplete:resetImg});
			
		}
		
		public function destroyALL():void 
		{
			TweenMax.killTweensOf(multSp);
			StaticGUI.safeRemoveChild(multSp, true);
			multSp = null;
			_atlas = null;
		}
		
		private function resetImg():void 
		{
			multSp.alpha = 1;
			TweenMax.to(multSp, 0.2, {delay:1.5, alpha:0, onComplete:resetImg});
		}
		
	}

}