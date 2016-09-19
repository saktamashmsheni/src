package game.machine 
{
	import com.utils.FastBlurFilter;
	import com.utils.StaticGUI;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import game.GameHolder;
	import starling.core.Starling;
	import starling.display.Canvas;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;
	import starling.utils.Color;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class Icon extends Sprite
	{
		private var iconMc:MovieClip;
		private var vectTexture:Vector.<Texture>;
		public var ID:int;
		public var transformedInWild:Boolean = false;
		public var parentLine:int;
		public var identifier:String;
		public var KJ:String;
		public var positionInReel:Number;
		public var isBonusLike:Boolean = true;
		public static var iconWidth:Number = 120;
		public static var iconHeight:Number = 120;
		public var iconAnimationMc:MovieClip;
		private var currenTWildIconIndex:int = -1;
		
		public function Icon() 
		{
			this.touchable = false;
			
			//iconMc = new MovieClip(Assets.getAtlas("allIconsImg", "allIconsXml").getTextures("icons"));
			//addChild(iconMc);
		}
		
		public function setIcon(id:int, isInScroll:Boolean = false):void 
		{
			if (this.visible == false)
				this.visible = true;
				
			if (iconMc == null)
			{
				if (vectTexture == null)
				{
					//vectTexture = Assets.getAtlas("allIconsImg", "allIconsXml").getTextures("icons");
					vectTexture = Machine.allIconsAtlas.getTextures("icons");
				}
				iconMc = new MovieClip(vectTexture);
				
				addChild(iconMc);
			}
			
			if (Machine.isWildIcon(ID))
			{
				iconMc.visible = true;
				Starling.juggler.remove(iconAnimationMc);
				StaticGUI.safeRemoveChild(iconAnimationMc, true);
				iconAnimationMc = null;
			}
			
			
			ID = id;
			if (!isInScroll)
			{
				/*if (ID == GameHolder.cont.machineHolder.wildIndex + 1)
				{
					if (currenTWildIconIndex != Root.ALL_WILD_INDEX)
					{
						currenTWildIconIndex = Root.ALL_WILD_INDEX;
						iconMc.removeFrameAt(GameHolder.cont.machineHolder.wildIndex * 2);
						iconMc.addFrameAt(GameHolder.cont.machineHolder.wildIndex * 2, Machine.wildIconsAtlas.getTexture("w" + String(StaticGUI.intWithZeros(Root.ALL_WILD_INDEX, 3)) + ".png"))
					}
					
				}*/
				iconMc.currentFrame = (ID) * 2;
			}else
			{
				iconMc.currentFrame = (ID) * 2 + 1;
			}
			
			
			alignCenter(iconMc);
			
		}
		
		private function alignCenter(ic:DisplayObject):void
		{
			if (ic.width > Icon.iconWidth)
				ic.x = int(-(ic.width - Icon.iconWidth) / 2);
			if (ic.height > Icon.iconHeight)
				ic.y = int( -(ic.height - Icon.iconHeight) / 2);
				
			if (Machine.isWildIcon(ID))
			{
				ic.x -= 1;
				ic.y -= 1;
			}
		}
		
		public function playIcon():void
		{
			if (iconAnimationMc != null)
			{
				trace("jora");
				return;
			}
			
			/*if (ID == GameHolder.cont.machineHolder.wildIndex + 1)
			{
				iconAnimationMc = new MovieClip(Assets.getAtlas("icon" + ID + "Img", "icon" + ID + "Xml").getTextures(""), 25);
				iconMc.visible = false;
				iconAnimationMc.x -= 20;
				iconAnimationMc.y -= 22;
			}
			else*/
			{
				iconAnimationMc = new MovieClip(Assets.getAtlas("iconsAnimationImg", "iconsAnimationXml").getTextures(""), 40);
				//iconAnimationMc.color = Color.YELLOW;
				alignCenter(iconAnimationMc);
				iconAnimationMc.alpha = 1;
				//iconAnimationMc.y += 2;
				//iconAnimationMc.x += 1;
			}
			
			addChild(iconAnimationMc);
			Starling.juggler.add(iconAnimationMc);
			iconAnimationMc.play();
			
			
			//if (Machine.isWildIcon(ID))
			{
				iconAnimationMc.addEventListener(Event.COMPLETE, onWildAnimationComplete);
			}
			
			
		}
		
		private function onWildAnimationComplete(e:Event):void 
		{
			if (iconAnimationMc == null)
				return;
				
			iconAnimationMc.removeEventListener(Event.COMPLETE, onWildAnimationComplete);
			iconAnimationMc.stop();
			Starling.juggler.remove(iconAnimationMc);
			//iconAnimationMc.fps = 25;
			iconAnimationMc.currentFrame = 0;
			
			//if (GameHolder.gameState == GameHolder.NORMAL_STATE)
			//{
				//iconAnimationMc.currentFrame = iconAnimationMc.numFrames - 1;
				iconAnimationMc.currentFrame = iconAnimationMc.numFrames - 1;
				Starling.juggler.remove(iconAnimationMc);
			//}
		}
		
		public function stopIcon():void
		{
			if (iconAnimationMc == null)
				return;
			
			if (Machine.isWildIcon(ID))
				return;
			
			iconAnimationMc.stop();
			Starling.juggler.remove(iconAnimationMc);
			StaticGUI.safeRemoveChild(iconAnimationMc, true);
			iconAnimationMc = null;
			//iconMc.visible = true;
		}
		
		public function resetBlur():void
		{
			iconMc.currentFrame = (ID) * 2;
		}
		
		
	}

}