package game.header.musicPlayer {
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	import game.GameHolder;
	import game.header.volumeController.VolumeController;
	import starling.display.Sprite;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;

	public class MusicManager extends Sprite {
		
		private var $snd:Sound = new Sound();
		private var $channel:SoundChannel ;
		private var $transform:SoundTransform ;
		private var $soundLastPosition:Number = 0;
		
		private var $soundIsReady:Boolean;
		private var $sndPlaying:Boolean;
		
		private static var $musicEnabled:Boolean = true;
		private static var $musicCurrentState:uint;
		
		private const MUSIC_OUT_DELAY:uint = 7;
		private const MUSIC_MAX_VALUME:Number = 0.7;
		private const MUSIC_MIN_VALUME:Number = 0;
		
		
		public static var _cont:MusicManager;
		public static var MUSIC_MUTE:uint = 1;
		public static var MUSIC_MUTE_ONDELAY:uint = 2;
		public static var MUSIC_DONT_MUTE:uint = 3;
		
		
		public function MusicManager() {
			super();
			
			_cont = this;
			$snd.load(new URLRequest(GameSettings.PATH + "soundtracks/NupogodiSoundtrack-Popcorn.mp3"));
			//$snd.addEventListener(flash.events.Event.COMPLETE, musicComplete);
			musicComplete(null);
		}
		
		private function musicComplete(evt:flash.events.Event):void {
			$channel = new SoundChannel();
			$transform = new SoundTransform();
			
			$channel = $snd.play($soundLastPosition, 999999999);
			$transform.volume = MUSIC_MAX_VALUME;
			$channel.soundTransform = $transform;
			$soundIsReady = true;
			$channel.stop();
			//IniClass.cont.stage.addEventListener(MouseEvent.CLICK, onStageMouseClickHandler);
			//TweenLite.delayedCall(SOUND_OUT_DELAY, removeSound);
		}
		
		public static function get _musicEnabled():Boolean {
			return $musicEnabled;
		}
		
		public static function set _musicEnabled(value:Boolean):void {
			
			if (value){
				if ($musicCurrentState == MusicManager.MUSIC_DONT_MUTE || $musicCurrentState == MusicManager.MUSIC_MUTE_ONDELAY){
					MusicManager._cont._onStageMouseClickHandler(null);
				}
				
			}else {
				$musicEnabled = value;	
				MusicManager._cont._removeSound();
			}
			
			$musicEnabled = value;
		}
		
		public function _addOrRemoveMusicMuter(musicStates:uint):void{
			if (!$soundIsReady || !$musicEnabled) return;
			switch(musicStates){
				
				case MusicManager.MUSIC_DONT_MUTE:
					_onStageMouseClickHandler(null);
					TweenLite.killDelayedCallsTo(_removeSound);
					break;
					
				case MusicManager.MUSIC_MUTE:
					if (!SoundManager.SoundEnabled) return;
					TweenLite.killDelayedCallsTo(_removeSound);
					_removeSound();
					break;
					
				case MusicManager.MUSIC_MUTE_ONDELAY:
					_onStageMouseClickHandler(null);
					break;
			}
			
			$musicCurrentState = musicStates;
				
		}
		
		public function _removeSound():void {
			
			/*if (GameHolder.cont.machineHolder.isScrolling && MusicManager._musicEnabled == true)
			{
				_onStageMouseClickHandler(null);
				return;
			}*/
			TweenLite.to($transform, .5,{volume:MUSIC_MIN_VALUME, onUpdate: soundValumeOnUpdate, onComplete: soundValumeOnComplete});
		}
		
		private function soundValumeOnComplete():void {
			
			$soundLastPosition = $channel.position;
			$channel.stop();
			$sndPlaying = false;
		}
		
		private function soundValumeOnUpdate():void {
			$channel.soundTransform = $transform;
		}
		
		public function _onStageMouseClickHandler(e:MouseEvent):void {
			if (!$soundIsReady) return;
		
			TweenLite.killDelayedCallsTo(_removeSound);
			TweenLite.delayedCall(MUSIC_OUT_DELAY, _removeSound);
			//Tracer._log('MUSIC:  '+$soundLastPosition, $channel.position, $snd.length)
			if (!$sndPlaying){
				//if ($channel && $soundLastPosition >= $snd.length - 2)$soundLastPosition = 0;
				
				$channel = $snd.play($soundLastPosition);
				$channel.addEventListener(flash.events.Event.SOUND_COMPLETE, musicTrackPlayingComplete)
				TweenLite.to($transform, .5, {volume:modifyFromControllerVol(), onUpdate: soundValumeOnUpdate});
				$sndPlaying = true;
			}else{
				
			}
		}
		
		private function musicTrackPlayingComplete(e:flash.events.Event):void{
			//Tracer._log('MUSIC COMPLETED AND NEW STARTED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
			$channel.removeEventListener(flash.events.Event.SOUND_COMPLETE, musicTrackPlayingComplete)
			$soundLastPosition = 0;
			$channel = $snd.play($soundLastPosition);
			$channel.addEventListener(flash.events.Event.SOUND_COMPLETE, musicTrackPlayingComplete);
			$channel.soundTransform = $transform;
		}
		
		
		
		public function changeVolumeFromController():void
		{
			if ($transform != null)
			{
				$transform.volume = modifyFromControllerVol();
				soundValumeOnUpdate();
			}
			
		}
		
		
		public function modifyFromControllerVol():Number
		{
			return VolumeController.controllerVol * MUSIC_MAX_VALUME / 1;
		}
	}
}