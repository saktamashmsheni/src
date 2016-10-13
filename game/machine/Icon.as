package game.machine 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
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
	import starling.display.Quad;
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
		public var isBonusLike:Boolean = false;
		public static var iconWidth:Number = GameSettings.ICONS_SIZE[GameSettings.SYS_NUM][0];
		public static var iconHeight:Number = GameSettings.ICONS_SIZE[GameSettings.SYS_NUM][1];
		public var iconAnimationMc:MovieClip;
		public var hoverAnimation:MovieClip;
		public var staticAnimation:MovieClip;
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
			
			/*var q:Quad = new Quad(130, 130, 0xffffff);
				
			q.alpha = .5;
			
			addChild(q);
			
			var q2:Quad = new Quad(5, 5, 0x00ff00);
			
			addChild(q2)
			
			if(q)q.x = int(iconMc.x+iconMc.width / 2 - q.width / 2);
			if(q)q.y = int(iconMc.y+iconMc.height / 2 - q.height / 2);
			
			if(q2)q2.x = int(q.x+q.width / 2 - q2.width / 2);
			if(q2)q2.y = int(q.y+q.height / 2 - q2.height / 2);*/
			
		}
		
		private function alignCenter(ic:DisplayObject):void
		{
			ic.width = Icon.iconWidth;
			ic.height = Icon.iconHeight;
			//ic.pivotX = int(ic.width / 2);
			//ic.pivotY = int(ic.height / 2);
			
			
			//if (ic.width > Icon.iconWidth)
				ic.x = int(-(ic.width - Icon.iconWidth) / 2);
			//if (ic.height > Icon.iconHeight)
				ic.y = int( -(ic.height - Icon.iconHeight) / 2);
				
			/*if (Machine.isWildIcon(ID))
			{
				ic.x -= 1;
				ic.y -= 1;
			}*/
		}
		
		public function playIcon():void
		{
			if (iconAnimationMc != null)
			{
				trace("jora");
				return;
			}
			
			
			if (!Machine.isWildIcon(ID) && GameSettings.ICON_ANIM_ENABLED && iconAnimationMc == null)
			{
				iconAnimationMc = new MovieClip(Assets.getAtlas("icon" + 1 + "Img", "icon" + 1 + "Xml").getTextures(""), 40);
				iconMc.visible = false;
				iconAnimationMc.x -= 20;
				iconAnimationMc.y -= 22;
				if (!GameSettings.ICON_ANIM_LOOP)
				{
					iconAnimationMc.loop = false;
					iconAnimationMc.addEventListener(Event.COMPLETE, onIconAnimationComplete);
				}
				
				addChild(iconAnimationMc);
				TweenLite.delayedCall(GameSettings.ICON_ANIM_DELAY, Starling.juggler.add, [iconAnimationMc]);
				TweenLite.delayedCall(GameSettings.ICON_ANIM_DELAY, iconAnimationMc.play);
			}
			
			if (!Machine.isWildIcon(ID) && GameSettings.HOVER_ANIM_ENABLED && hoverAnimation == null)
			{
				hoverAnimation = new MovieClip(Assets.getAtlas("iconsAnimationImg", "iconsAnimationXml").getTextures(""), 40);
				//hoverAnimation.color = Color.YELLOW;
				alignCenter(hoverAnimation);
				hoverAnimation.alpha = 1;
				
				if (!GameSettings.HOVER_ANIM_LOOP)
				{
					hoverAnimation.loop = false;
					hoverAnimation.addEventListener(Event.COMPLETE, onHoverAnimationComplete);
				}
				
				addChild(hoverAnimation);
				Starling.juggler.add(hoverAnimation);
				hoverAnimation.play();
			}
			
			if (GameSettings.STATIC_ANIM_ENABLED && staticAnimation == null)
			{
				staticAnimation = new MovieClip(Assets.getAtlas("staticAnim", "staticAnimXml").getTextures(""), 30);
				staticAnimation.scaleX = staticAnimation.scaleY = 1.2;
				alignCenter(staticAnimation);
				staticAnimation.alpha = 1;
				
				if (!GameSettings.STATIC_ANIM_LOOP)
				{
					staticAnimation.loop = false;
					staticAnimation.addEventListener(Event.COMPLETE, onStaticAnimationComplete);
				}
				
				addChildAt(staticAnimation,0);
				Starling.juggler.add(staticAnimation);
				staticAnimation.play();
				
			}
			
		}
		
		private function onHoverAnimationComplete(e:Event):void 
		{
			if (hoverAnimation == null)
				return;
				
				
			hoverAnimation.stop();
			Starling.juggler.remove(hoverAnimation);
			//if (GameHolder.gameState == GameHolder.NORMAL_STATE)
			//{
			//}
			
			hoverAnimation.removeEventListener(Event.COMPLETE, onHoverAnimationComplete);
		}
		
		private function onStaticAnimationComplete(e:Event):void 
		{
			if (staticAnimation == null)
				return;
				
				
			staticAnimation.stop();
			Starling.juggler.remove(staticAnimation);
			
			staticAnimation.removeEventListener(Event.COMPLETE, onHoverAnimationComplete);
		}
		
		private function onIconAnimationComplete(e:Event):void 
		{
			if (iconAnimationMc == null)
				return;
				
				
			iconAnimationMc.stop();
			iconAnimationMc.currentFrame = iconAnimationMc.numFrames -1;
			Starling.juggler.remove(iconAnimationMc);
			
			iconAnimationMc.removeEventListener(Event.COMPLETE, onIconAnimationComplete);
		}
		
		
		
		
		
		
		
		
		public function modifiedWildsAnimation():void
		{
			TweenMax.to(this, 0.2, {scale:1.2, x:this.x - this.width*0.1, y:this.y - this.height*0.1, yoyo:true, repeat:1});
		}
		
		
		
		
		public function stopIcon():void
		{
			if (iconAnimationMc != null)
			{
				/*if (Machine.isWildIcon(ID))
					return;*/
				iconAnimationMc.stop();
				Starling.juggler.remove(iconAnimationMc);
				StaticGUI.safeRemoveChild(iconAnimationMc, true);
				iconAnimationMc = null;
				
			}
			if (hoverAnimation != null)
			{
				hoverAnimation.stop();
				Starling.juggler.remove(hoverAnimation);
				StaticGUI.safeRemoveChild(hoverAnimation, true);
				hoverAnimation = null;
			}
			
			if (staticAnimation != null)
			{
				staticAnimation.stop();
				Starling.juggler.remove(staticAnimation);
				StaticGUI.safeRemoveChild(staticAnimation, true);
				staticAnimation = null;
			}
			
			iconMc.visible = true;
		}
		
		public function resetBlur():void
		{
			iconMc.currentFrame = (ID) * 2;
		}
		
		
	}

}