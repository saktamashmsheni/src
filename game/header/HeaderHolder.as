package game.header {
	import com.greensock.TweenMax;
	import com.utils.GAnalyticsEvents;
	import com.utils.GoogleAnalytics;
	import flash.events.MouseEvent;
	import com.utils.MyButton;
	import com.utils.StaticGUI;
	import feathers.controls.Button;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import game.GameHolder;
	import game.header.musicPlayer.MusicManager;
	import game.header.volumeController.VolumeController;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.textures.TextureAtlas;
	import starling.utils.Align;
	import starling.utils.Align;
	
	public class HeaderHolder extends Sprite {
		
		private var rules_btn:Button;
		private var cashier_btn:Button;
		private var home_btn:Button;
		
		private var fullBtn:Button;
		private var soundBtn:Button;
		private var musicBtn:Button;
		private var xBtn:Button;
		public var $textureAtlas:TextureAtlas;
		private var volumeController:VolumeController;
		
		public var logoMc:MovieClip;
		
		public static var cont:HeaderHolder
		
		public function HeaderHolder() {
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			cont = this;
			initHeader();
		}
		
		private function initHeader():void {
			
			$textureAtlas = Assets.getAtlas("headerSheet", "headerSheetXml");
			
			logoMc =  new MovieClip(Assets.getAtlas("logo", "logoXml").getTextures(""));
			logoMc.name = "logoMc";
			StaticGUI.setAlignPivot(logoMc);
			logoMc.x = 0;
			logoMc.y = 14;
			logoMc.touchable = false;
			addChild(logoMc);
			logoMc.touchable = false;
			
			
			var $tf:TextFormat = new TextFormat;
			$tf.font = Assets.getFont("bebas").name;
			$tf.size =  30;
			$tf.color = 0xFFFFFF;
			$tf.bold = true;
			
			var freeSpins_txt:TextField = new TextField(300, 40, "0/5", $tf);
			freeSpins_txt.name = "freeSpins_txt";
			freeSpins_txt.alignPivot(Align.CENTER, Align.CENTER);
			freeSpins_txt.y = 68;
			addChild(freeSpins_txt);
			freeSpins_txt.visible = false;
			
			var $musicManager:MusicManager = new MusicManager;
			
			
			
			home_btn = StaticGUI._initButton(this, 
												-358, 
												46, 
					$textureAtlas.getTexture("home_btn_1.png"), 
					$textureAtlas.getTexture("home_btn_1.png"));
			
			
			cashier_btn = StaticGUI._initButton(this, 
												 home_btn.x + 41,
												home_btn.y - 2, 
					$textureAtlas.getTexture("cashier_btn_1.png"), 
					$textureAtlas.getTexture("cashier_btn_2.png"));
					
			rules_btn = StaticGUI._initButton(this, 
											  cashier_btn.x + 38, 
											  cashier_btn.y + 2, 
					$textureAtlas.getTexture("rules_btn_1.png"), 
					$textureAtlas.getTexture("rules_btn_2.png"));
					
					
			
					
			
					
					
					
			fullBtn = StaticGUI._initButton(this, 
			                                 267, 
											  46, 
					$textureAtlas.getTexture("full_screen_btn_1.png"), 
					$textureAtlas.getTexture("full_screen_btn_2.png"), 
					$textureAtlas.getTexture("full_screen_btn_3.png"));
			fullBtn.name = 'fullScreenbtn';
			//fullBtn.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			fullBtn.addEventListener(TouchEvent.TOUCH, onTouch);
			
			
			soundBtn = StaticGUI._initButton(this, 
										fullBtn.x + fullBtn.width + 21, 
					                    fullBtn.y-1, 
					$textureAtlas.getTexture("sound_btn_1.png"), 
					$textureAtlas.getTexture("sound_btn_2.png"), 
					$textureAtlas.getTexture("sound_btn_3.png"));
					
			soundBtn.name = 'soundOnBtn';
			soundBtn.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			soundBtn.addEventListener(TouchEvent.TOUCH, onSoundBtnTouch);
			
			
			xBtn = StaticGUI._initButton(this, 
			  soundBtn.x + soundBtn.width + 22, 
			                       soundBtn.y, 
					$textureAtlas.getTexture("close_btn_1.png"), 
					$textureAtlas.getTexture("close_btn_2.png"), 
					$textureAtlas.getTexture("close_btn_3.png"));
					
			xBtn.name = 'closeBtn';
			xBtn.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			
			
			
			/*musicBtn = StaticGUI._initButton(this, 
			      soundBtn.x + soundBtn.width + 12, 
				                       soundBtn.y, 
					$textureAtlas.getTexture("music_btn_1.png"), 
					$textureAtlas.getTexture("music_btn_2.png"), 
					$textureAtlas.getTexture("music_btn_3.png"));
			
			musicBtn.name = 'musicOnBtn';
			musicBtn.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			
			*/
		
		/*
		   fullBtn.addEventListener(MouseEvent.CLICK, onFull);
		   soundBtn.addEventListener(MouseEvent.CLICK, onSoundCl);
		   xBtn.addEventListener(MouseEvent.CLICK, onXClick);
		   rules_btn.addEventListener(MouseEvent.CLICK, onRulesClick);*/
		   
		   
		   cashier_btn.addEventListener(Event.TRIGGERED, onCashierClick);
		   rules_btn.addEventListener(Event.TRIGGERED, onRulesClick);
		   
		   
		   volumeController = new VolumeController();
		   volumeController.x = 313;
		   volumeController.y = 90;
		   addChild(volumeController);
		   volumeController.visible = false;
		   
		   volumeController.addEventListener(GameEvents.SOUND_CHANGED, soundChanged);
		
		}
		
		private function onSoundBtnTouch(e:TouchEvent):void 
		{
			//var location:Point;
			
			var endTouch:Touch = e.getTouch(this, TouchPhase.ENDED);
			var overTouch:Touch = e.getTouch(this, TouchPhase.HOVER);
			var downTouch:Touch = e.getTouch(this, TouchPhase.BEGAN);
			
			 if (overTouch != null) 
			{
				soundBtn.removeEventListener(TouchEvent.TOUCH, onSoundBtnTouch);
				volumeController.visible = true;
				volumeController.addEventListener(TouchEvent.TOUCH, onVolumeControllerTouch);
			} 
			
			endTouch = null;
			overTouch = null;
			downTouch = null;
		}
		
		private function onVolumeControllerTouch(e:TouchEvent):void 
		{
			var overTouch:Touch = e.getTouch(volumeController, TouchPhase.HOVER);
			var downTouch:Touch = e.getTouch(volumeController, TouchPhase.BEGAN);
			var movedTouch:Touch = e.getTouch(volumeController, TouchPhase.MOVED);
			var end:Touch = e.getTouch(volumeController, TouchPhase.ENDED);
			
			
			if (overTouch == null && downTouch == null && movedTouch == null)
			{
				volumeController.visible = false;
				volumeController.removeEventListener(TouchEvent.TOUCH, onVolumeControllerTouch);
				soundBtn.addEventListener(TouchEvent.TOUCH, onSoundBtnTouch);
			}
			if (end)
			{
				TweenMax.delayedCall(2, hideController);
			}
			if (overTouch != null || downTouch != null || movedTouch != null)
			{
				TweenMax.killDelayedCallsTo(hideController);
			}
			
			overTouch = null;
			downTouch = null;
			movedTouch = null;
		}
		
		
		private function hideController():void 
		{
			if (volumeController.visible == false)
			{
				return;
			}
			volumeController.visible = false;
			volumeController.removeEventListener(TouchEvent.TOUCH, onVolumeControllerTouch);
			soundBtn.addEventListener(TouchEvent.TOUCH, onSoundBtnTouch);
		}
		
		
		
		
		
		private function soundChanged(e:GameEvents):void 
		{
			if (e.params.muted)
			{
				SoundManager.SoundEnabled = false;
					Root.soundManager.stopSound();
					StaticGUI._updateButtonSkin(soundBtn, 
					                    'soundOffBtn', 
							$textureAtlas.getTexture("sound_mute_btn_1.png"), 
							$textureAtlas.getTexture("sound_mute_btn_2.png"), 
							$textureAtlas.getTexture("sound_mute_btn_3.png"));
							
				GoogleAnalytics._sendActionEvent(GAnalyticsEvents.HEADER_EVENTS,'sound off','sound clicked');
			}
			else
			{
				SoundManager.SoundEnabled = true;
					StaticGUI._updateButtonSkin(soundBtn, 
					                     'soundOnBtn', 
							$textureAtlas.getTexture("sound_btn_1.png"),
							$textureAtlas.getTexture("sound_btn_1.png"),
							$textureAtlas.getTexture("sound_btn_1.png"));
							
				GoogleAnalytics._sendActionEvent(GAnalyticsEvents.HEADER_EVENTS,'sound on','sound clicked');
			}
		}
		
		private function onTouch(e:TouchEvent):void {
			var touch:Touch = e.getTouch(this);
			if(!touch) return;
			if(touch.phase == TouchPhase.BEGAN){
			   Starling.current.nativeStage.addEventListener(flash.events.MouseEvent.MOUSE_UP, IniClass.cont.fullScreen);
			   Root.soundManager.PlaySound("options_click");
			}
		}
		
		private function onCashierClick(e:Event):void {
			Root.soundManager.PlaySound("options_click");
			GameHolder.cont.addCashier();
		}
		
		
		private function onRulesClick(e:Event):void {
			Root.soundManager.PlaySound("options_click");
			GameHolder.cont.loadAndAddPayTable();
		}
		
		private function button_triggeredHandler(e:Event):void {
			var $b:Button = Button(e.target);
			
			if($b.name !='soundOnBtn')Root.soundManager.PlaySound("options_click");
			switch ($b.name) {
				case 'musicOnBtn':
					
					MusicManager._musicEnabled = false;
					StaticGUI._updateButtonSkin($b, 
					                    'musicOffBtn', 
							$textureAtlas.getTexture("music_mute_btn_1.png"), 
							$textureAtlas.getTexture("music_mute_btn_2.png"), 
							$textureAtlas.getTexture("music_mute_btn_3.png"));
					
					break;
				case 'musicOffBtn':
					
					MusicManager._musicEnabled = true;
					StaticGUI._updateButtonSkin($b, 
					                     'musicOnBtn', 
							$textureAtlas.getTexture("music_btn_1.png"),
							$textureAtlas.getTexture("music_btn_2.png"),
							$textureAtlas.getTexture("music_btn_3.png"));
							
					break;
					
				case 'soundOnBtn':
					SoundManager.SoundEnabled = false;
					Root.soundManager.stopSound();
					volumeController.muteToggleFunc();
					StaticGUI._updateButtonSkin($b, 
					                    'soundOffBtn', 
							$textureAtlas.getTexture("sound_mute_btn_1.png"), 
							$textureAtlas.getTexture("sound_mute_btn_2.png"), 
							$textureAtlas.getTexture("sound_mute_btn_3.png"));
					
					
					break;
				case 'soundOffBtn':
					
					SoundManager.SoundEnabled = true;
					volumeController.muteToggleFunc();
					StaticGUI._updateButtonSkin($b, 
					                     'soundOnBtn', 
							$textureAtlas.getTexture("sound_btn_1.png"),
							$textureAtlas.getTexture("sound_btn_1.png"),
							$textureAtlas.getTexture("sound_btn_1.png"));
					break;
				case 'fullScreenbtn':
					GoogleAnalytics._sendActionEvent(GAnalyticsEvents.HEADER_EVENTS,'full screen','full screen clicked');
					break;
					
				case 'closeBtn':
					
					if (ExternalInterface.available) {
						ExternalInterface.call("window.close()");
					} else {
						var jscommand:String = "window.close()";
						var url:URLRequest = new URLRequest("javascript:" + jscommand + " void(0);");
						try {
							navigateToURL(url, "_self");
						} catch (e:Error) {
							//amis gamo chedavda ar vici rato prosta
							Tracer._log("Popup failed");
							
						}
					}
					
					GoogleAnalytics._sendActionEvent(GAnalyticsEvents.HEADER_EVENTS,'close','close clicked');
					break;
			}
		
		}
		
		
		/*public function changeSoundToOn():void
		{
			StaticGUI._updateButtonSkin(soundBtn, 
									 'soundOnBtn', 
						$textureAtlas.getTexture("sound_btn_1.png"),
						$textureAtlas.getTexture("sound_btn_1.png"),
						$textureAtlas.getTexture("sound_btn_1.png"));
		}*/
		
		public function changeSoundToOff():void
		{
			StaticGUI._updateButtonSkin(soundBtn, 
									'soundOffBtn', 
						$textureAtlas.getTexture("sound_mute_btn_1.png"), 
						$textureAtlas.getTexture("sound_mute_btn_2.png"), 
						$textureAtlas.getTexture("sound_mute_btn_3.png"));
		}
		
		/*
		private function onXClick(e:MouseEvent):void {
			if (ExternalInterface.available) {
				ExternalInterface.call("window.close()");
			} else {
				var jscommand:String = "window.close()";
				var url:URLRequest = new URLRequest("javascript:" + jscommand + " void(0);");
				try {
					navigateToURL(url, "_self");
				} catch (e:Error) {
					Tracer._log("Popup failed", e.message);
				}
			}
		}
		*/
		/*
		private function onFull(e:MouseEvent):void {
		var viewPortRectangle:Rectangle = new Rectangle();
		   if (Global.FULLSCREEN) {
		   viewPortRectangle.width = Capabilities.screenResolutionX;
		   viewPortRectangle.height = Capabilities.screenResolutionY;
		   } else {
		   viewPortRectangle.width = 1366;
		   viewPortRectangle.height = 768;
		   }
		   Starling.current.viewPort = viewPortRectangle;
		}
		*/
		/*private function onSoundCl(e:MouseEvent):void {
			if (e.params.currentTarget.opt.sound_ico.currentFrame == 0) {
				Root.soundManager.stopSound();
				e.params.currentTarget.opt.sound_ico.currentFrame = 1;
				SoundManager.SoundEnabled = true;
			} else {
				e.params.currentTarget.opt.sound_ico.currentFrame = 0;
				SoundManager.SoundEnabled = false;
			}
		}*/
	
	}

}