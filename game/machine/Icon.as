package game.machine 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
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
	import starling.utils.deg2rad;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class Icon extends Sprite
	{
		private var iconMc:MovieClip;
		private var vectTexture:Vector.<Texture>;
		public var ID:int = -1;
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
				
			
			//if (ID != id || (vectTexture == null || iconMc == null))
			{
				/*if (iconMc != null)
				{
					StaticGUI.safeRemoveChild(iconMc, true);
					iconMc.base.dispose();
					iconMc = null;
				}*/
				if (vectTexture != null)
				{
					vectTexture = null;
				}
				
					
				//if (iconMc == null)
				//{
					//if (vectTexture == null)
					//{
						vectTexture = new Vector.<Texture>();
						//vectTexture = Assets.getAtlas("allIconsImg", "allIconsXml").getTextures("icons");
						//vectTexture = Machine.allIconsAtlas.getTextures("icons" + StaticGUI.intWithZeros(id * 2, 4));
						
						if (!isInScroll)
						{
							vectTexture.push(Machine.allIconsAtlas.getTexture("icons" + StaticGUI.intWithZeros(id * 2, 4)));
						}else
						{
							vectTexture.push(Machine.allIconsAtlas.getTexture("icons" + StaticGUI.intWithZeros(id * 2 + 1, 4)));
						}
						
						
					//}
					if (iconMc == null)
					{
						iconMc = new MovieClip(vectTexture);
						iconMc.touchable = false;
						addChild(iconMc);
					}
					else
					{
						swapFrames(iconMc, vectTexture);
					}
				//}
				
			}
			
			
			if (Machine.isWildIcon(ID))
			{
				iconMc.visible = true;
				Starling.juggler.remove(iconAnimationMc);
				StaticGUI.safeRemoveChild(iconAnimationMc, true);
				iconAnimationMc = null;
			}
			
			
			ID = id;
			/*if (!isInScroll)
			{
				//iconMc.currentFrame = (ID) * 2;
				iconMc.currentFrame = 0;
			}else
			{
				//iconMc.currentFrame = (ID) * 2 + 1;
				iconMc.currentFrame = 1;
			}*/
			
			
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
			
			//playIcon();
			
		}
		
		private function alignCenter(ic:DisplayObject):void
		{
			
			ic.scaleX = GameSettings.SCALE_ICONS;
			ic.scaleY = GameSettings.SCALE_ICONS;
			//ic.pivotX = int(ic.width / 2);
			//ic.pivotY = int(ic.height / 2);
			
			
			//if (ic.width > Icon.iconWidth)
				ic.x = int(-(ic.width - Icon.iconWidth) / 2);
			//if (ic.height > Icon.iconHeight)
				ic.y = int( -(ic.height - Icon.iconHeight) / 2);
				
			
			ic.y += GameSettings.ICONS_OFF_Y;
			ic.x += GameSettings.ICONS_OFF_X;
				
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
			
			
			if (((Machine.isWildIcon(ID) && GameSettings.WILD_ANIM_ENABLED) || (!Machine.isWildIcon(ID)&& GameSettings.ICON_ANIM_ENABLED))  && iconAnimationMc == null)
			{
				iconAnimationMc = new MovieClip(Assets.getAtlas("icon" + ID + "Img", "icon" + ID + "Xml").getTextures(""), GameSettings.ICON_ANIM_FPS);
				//iconAnimationMc = new MovieClip(Assets.getAtlas("icon" + 3 + "Img", "icon" + 3 + "Xml").getTextures(""), 30);
				iconMc.visible = !GameSettings.HIDE_ICON;
				iconAnimationMc.x -= 20;
				iconAnimationMc.y -= 22;
				
				if (!GameSettings.ICON_ANIM_LOOP)
				{
					iconAnimationMc.loop = false;
					iconAnimationMc.addEventListener(Event.COMPLETE, onIconAnimationComplete);
				}
				if (Machine.isWildIcon(ID))
				{
					//iconAnimationMc.loop = true;
					iconAnimationMc.loop = GameSettings.WILD_ANIM_LOOP;
					iconAnimationMc.addEventListener(Event.COMPLETE, onIconAnimationComplete);
				}
				//iconAnimationMc.addEventListener(Event.COMPLETE, onIconAnimationComplete);
				addChild(iconAnimationMc);
				iconAnimationMc.scaleX = iconAnimationMc.scaleY = 1
				alignCenter(iconAnimationMc);
				TweenLite.delayedCall(GameSettings.ICON_ANIM_DELAY, Starling.juggler.add, [iconAnimationMc]);
				TweenLite.delayedCall(GameSettings.ICON_ANIM_DELAY, iconAnimationMc.play);
				//Starling.juggler.add(iconAnimationMc)
				//iconAnimationMc.play();
			}
			
			if (!Machine.isWildIcon(ID) && GameSettings.HOVER_ANIM_ENABLED && hoverAnimation == null)
			{
				//hoverAnimation = new MovieClip(Assets.getAtlas("iconsAnimationImg", "iconsAnimationXml").getTextures(""), 35);
				hoverAnimation = new MovieClip(Assets.getAtlas("iconsAnimationImg", "iconsAnimationXml").getTextures(""), 25);
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
			
			if (!Machine.isWildIcon(ID) && GameSettings.STATIC_ANIM_ENABLED && staticAnimation == null)
			{
				staticAnimation = new MovieClip(Assets.getAtlas("staticAnim", "staticAnimXml").getTextures(""), 25);
				//staticAnimation.color = Color.YELLOW;
				//staticAnimation.scaleX = staticAnimation.scaleY = 0.8;
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
			
			iconAnimationMc.x += GameSettings.ALL_ICONS_OFFSET_X;
			iconAnimationMc.y += GameSettings.ALL_ICONS_OFFSET_Y;
			//iconAnimationMc.alpha = 0.4;
			//iconMc.visible = true;
			
			if (GameSettings.PREFERENCES.machine.iconAnimationOffsets != null)
			{
				iconAnimationMc.x += GameSettings.PREFERENCES.machine.iconAnimationOffsets["icon" + ID + "_X"];
				iconAnimationMc.y += GameSettings.PREFERENCES.machine.iconAnimationOffsets["icon" + ID + "_Y"];
			}
			
		}
		
		private function onHoverAnimationComplete(e:Event):void 
		{
			if (GameSettings.HOVER_FAST_REMOVE == true)
			{
				removeHoverAnimation();
			}
		}
		
		private function removeHoverAnimation():void 
		{
			if (hoverAnimation == null)
				return;
				
				
			hoverAnimation.stop();
			Starling.juggler.remove(hoverAnimation);
			hoverAnimation.removeEventListener(Event.COMPLETE, onHoverAnimationComplete);
		}
		
		private function onStaticAnimationComplete(e:Event):void 
		{
			if (GameSettings.STATIC_FAST_REMOVE == true)
			{
				removeStaticAnim();
			}
		}
		
		private function removeStaticAnim():void 
		{
			if (staticAnimation == null)
				return;
				
				
			staticAnimation.stop();
			Starling.juggler.remove(staticAnimation);
			
			staticAnimation.removeEventListener(Event.COMPLETE, onHoverAnimationComplete);
		
		}
		
		private function onIconAnimationComplete(e:Event):void 
		{
			if (GameSettings.ICON_ANIM_FAST_REMOVE == true && !Machine.isWildIcon(ID))
			{
				removeIconAnimation();
			}
			/*else
			{
				iconAnimationMc.stop();
			}
			
			TweenMax.delayedCall(0.6, iconAnimationMc.play);*/
		}
		
		private function removeIconAnimation():void 
		{
			if (iconAnimationMc == null)
				return;
				
			iconAnimationMc.stop();
			iconAnimationMc.currentFrame = 0;
			Starling.juggler.remove(iconAnimationMc);
			
			
			iconAnimationMc.removeEventListener(Event.COMPLETE, onIconAnimationComplete);
		}
		
		
		
		
		
		
		
		public function modifiedWildsAnimation(animType:int = -1):void
		{
			if (animType == 3)
			{
				this.scaleX = this.scaleY = 0;
				this.rotation = deg2rad(1680);
				TweenMax.to(this, 1, {scale:1, rotation:deg2rad(0), x:this.x - this.width*0.1, y:this.y - this.height*0.1, ease:Back.easeOut});
			}
			else
			{
				TweenMax.to(this, 0.2, {scale:1.2, x:this.x - this.width*0.1, y:this.y - this.height*0.1, yoyo:true, repeat:1});
			}
			
		}
		
		
		
		
		public function stopIcon():void
		{
			removeStaticAnim();
			removeHoverAnimation();
			removeIconAnimation();
			
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
			//iconMc.currentFrame = 0;
			//iconMc.currentFrame = (ID) * 2;
		}
		
		
		
		public function swapFrames(clip:MovieClip, textures:Vector.<Texture>):void {
 
			// remove all frame but one, since a MovieClip is not allowed to have 0 frames
			while(clip.numFrames > 1){
				clip.removeFrameAt(0);
			}
 
			//add new frames
			for (var i:int=0, l:int=textures.length; i<l; ++i)
			{
				clip.addFrame(textures[i]);
			}
 
			// remove that last previous frame
			clip.removeFrameAt(0);
 
			// set to frame 1
			clip.currentFrame = 0;
 
			//Reajust the clip size
			clip.readjustSize();
 
		}
		
		
	}

}