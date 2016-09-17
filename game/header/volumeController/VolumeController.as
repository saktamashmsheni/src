package game.header.volumeController 
{
	import com.utils.MouseEvent;
	import com.utils.MyButton;
	import com.utils.StaticGUI;
	import feathers.controls.Button;
	import feathers.controls.Slider;
	import game.header.HeaderHolder;
	import game.header.musicPlayer.MusicManager;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class VolumeController extends Sprite
	{
		private var volume_controller_bg:Image;
		
		private var totalHeight:Number;
		private var slider:SliderVolume;
		private var muteBtn:Button;
		private var $textureAtlas:TextureAtlas;
		public static var isMuted:Boolean = false;
		public static var cont:VolumeController;
		public static var controllerVol:Number = 1;
		
		public function VolumeController() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			cont = this;
			
			initVolumeController();
		}
		
		private function initVolumeController():void 
		{
			volume_controller_bg = new Image(Assets.getAtlas("headerSheet", "headerSheetXml").getTexture("volume_controller_bg.png"));
			StaticGUI.setAlignPivot(volume_controller_bg, "TC");
			volume_controller_bg.y = -25;
			volume_controller_bg.x = 0;
			addChild(volume_controller_bg);
			
			
			//----------slider------------------------------------------------------------------
			slider = new SliderVolume();
			slider.direction = Slider.DIRECTION_VERTICAL;
			slider.y = 38;
			slider.addEventListener(Event.CHANGE, slider_changeHandler);
			addChild(slider);
			
			
			$textureAtlas = HeaderHolder.cont.$textureAtlas;
			
			
			muteBtn = StaticGUI._initButton(this, 
												-5, 
												80, 
					$textureAtlas.getTexture("sound_mute_btn_1.png"), 
					$textureAtlas.getTexture("sound_mute_btn_2.png"), 
					$textureAtlas.getTexture("sound_mute_btn_3.png"));
					
			muteBtn.name = 'soundOnBtn';
			muteBtn.addEventListener(Event.TRIGGERED, muteSoundClicked);
			muteBtn.scaleX = muteBtn.scaleY = 0.9;
			
		}
		
		
		private function slider_changeHandler(e:Event):void 
		{
			var _slider:Slider = Slider( e.currentTarget );
			Tracer._log( "slider.value changed:");
			
			
			controllerVol = _slider.value / 100;
			Root.soundManager.changeVolumeFromController();
			MusicManager._cont.changeVolumeFromController();
			
			if (_slider.value == 0)
			{
				isMuted = true;
				
			}
			else
			{
				isMuted = false;
				dispatchEvent(new GameEvents(GameEvents.SOUND_CHANGED, {muted:isMuted}));
			}
			
			_slider = null;
		}
		
		
		
		
		private function muteSoundClicked(e:Event):void 
		{
			muteToggleFunc();
		}
		
		public function muteToggleFunc():void 
		{
			if (isMuted == false)
			{
				isMuted = true;
				slider.value = 0;
				controllerVol = 0;
				Root.soundManager.changeVolumeFromController();
				MusicManager._cont.changeVolumeFromController();
			}
			else
			{
				isMuted = false;
				slider.value = 100;
				controllerVol = 1;
				Root.soundManager.changeVolumeFromController();
				MusicManager._cont.changeVolumeFromController();
			}
			
			dispatchEvent(new GameEvents(GameEvents.SOUND_CHANGED, {muted:isMuted}));
		}
		
		
	}

}