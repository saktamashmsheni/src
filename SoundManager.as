package 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import game.GameHolder;
	import game.header.volumeController.VolumeController;
	

	public class SoundManager
	{
		private var backgroundChannel:SoundChannel;
		private var backgrSound:Sound;
		private var backgroundTransform:SoundTransform = new SoundTransform();
		
		public var st:SoundTransform = new SoundTransform();
		private var myChannel:SoundChannel = new SoundChannel();
		private var sound:Sound;
		private var reqString:String;
		private var loopSoundVolume:Number = 0.9;
		private var testClass:Class;
		public var loopIsPlayng:Boolean;
		
		private static var soundEnabled:Boolean = true;
		
		public function PlaySound(str:String, play:Boolean = true):Sound
		{
			
			if (SoundEnabled == false)
			{
				return null;
			}
			
			if (Root.reconProcess == true)
			{
				return null;
			}
			
			try 
			{
				testClass = Root.soundLibrary.applicationDomain.getDefinition(str) as Class;
				sound = new testClass() as Sound;
				
				
				if (play)
				{
					st.volume = modifyFromControllerVol(1);
					myChannel.soundTransform = st;
					myChannel = sound.play(0, 1, st);
				}
				
				return sound;
			}
			catch (err:Error)
			{
				trace("ERROR - XMA VER IPOVA ...");
				return null;
			}
			
			return null;
			
			/*var sound:Sound = new Sound();
			sound.addEventListener(IOErrorEvent.IO_ERROR, onNoSound)
			
			var reqString:String = "20 slice fruit/sounds/" + str + ".mp3";
			
			sound.load(new URLRequest(reqString))
			
			
			if (play) {
				sound.play();
			}
			
			return sound;*/
		}
		
		public function stopSound():void
		{
			if (!myChannel) return;
			//myChannel.soundTransform  = new SoundTransform(0);
			myChannel.stop();
			//stopLoopSound();
		}
		
		private function onNoSound(e:IOErrorEvent):void
		{
			trace("SoundManager onNoSound: ErrorLoading");
		}
		
		public function schedule(text:String, volume:Number = 1):void
		{
			if (SoundEnabled == false)
			{
				return;
			}
			
			if (Root.reconProcess == true)
			{
				return;
			}
			
			
			try 
			{
				var schedule:SoundSchedule = new SoundSchedule(text, modifyFromControllerVol(volume));
			}
			catch (err:Error)
			{
				
			}
			
		}
		
		public function manage(soundTransform:SoundTransform):void
		{
			st = soundTransform;
		}
		
		///-----------------------------BACKGROUND SOUND------------------------------------------------------------------------
		
		public function addBackgroundListener():void
		{
			GameHolder.cont.headerHolder.removeEventListener(GameEvents.SOUND_CHANGED, whenSoundChanged);
			GameHolder.cont.headerHolder.addEventListener(GameEvents.SOUND_CHANGED, whenSoundChanged);
		}
		
		public function stopLoopSound():void
		{
			trace("+++++++++++++++++++++++++++++++++++++jorjo");
			loopIsPlayng = false;
			if (backgroundChannel == null)
			{
				return;
			}
			backgroundChannel.stop();
			backgroundChannel.removeEventListener(Event.SOUND_COMPLETE, SoundLoop);
		}
		
		public function muteLoopSound():void
		{
			backgroundTransform.volume = 0;
			backgroundChannel.soundTransform = backgroundTransform;
		}
		
		private function whenSoundChanged(e:Event):void
		{
			if (SoundEnabled == false)
			{
				muteLoopSound();
			}
			else
			{
				backgroundTransform.volume = loopSoundVolume;
				backgroundChannel.soundTransform = backgroundTransform;
			}
		}
		
		public function getLoopSoundPos():Number
		{
			if (backgroundChannel == null)
			{
				return 0;
			}
			trace("pppppp:" + backgroundChannel.position);
			return backgroundChannel.position;
		}
		
		
		public function loopdSound(str:String, loopSoundVolume:Number = 0.8):void
		{
			this.loopSoundVolume = loopSoundVolume;
			
			if (SoundEnabled == false)
			{
				stopLoopSound();
				return;
			}
			loopIsPlayng = true;
			addBackgroundListener();
			backgrSound = new Sound();
			backgroundChannel = new SoundChannel();
			
			testClass = Root.soundLibrary.applicationDomain.getDefinition(str) as Class;
			backgrSound = new testClass() as Sound;
			
			//var MovieSoundUrl:URLRequest = new URLRequest(Root.TESTING == true ? "sounds/" + str + ".mp3" : "dictators/sounds/" + str + ".mp3");
			//backgrSound.load(MovieSoundUrl);
			
			backgroundTransform.volume = modifyFromControllerVol(loopSoundVolume);
			backgroundChannel.soundTransform = backgroundTransform;
			
			backgroundChannel = backgrSound.play(0, 1, backgroundTransform);
			backgroundChannel.addEventListener(Event.SOUND_COMPLETE, SoundLoop);
		}
		
		private function SoundLoop(evt:Event):void
		{
			/*if (SoundEnabled == false)
			   {
			   stopLoopSound();
			   return;
			   }*/
			trace("loopSoundVolume" + loopSoundVolume);
			if (SoundEnabled == false)
			{
				backgroundTransform.volume = 0;
			}
			else
			{
				backgroundTransform.volume = modifyFromControllerVol(loopSoundVolume);
			}
			backgroundChannel.soundTransform = backgroundTransform;
			backgroundChannel = backgrSound.play(0, 1, backgroundTransform);
			backgroundChannel.addEventListener(Event.SOUND_COMPLETE, SoundLoop);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public function changeVolumeFromController():void
		{
			if (st != null)
			{
				st = new SoundTransform(modifyFromControllerVol(st.volume));
				myChannel.soundTransform = st;
			}
			
			if (backgroundTransform != null)
			{
				//backgroundTransform = new SoundTransform(modifyFromControllerVol(loopSoundVolume));
				//backgroundChannel.soundTransform = backgroundTransform;
			}
		}
		
		
		public function modifyFromControllerVol(curVol:Number):Number
		{
			return VolumeController.controllerVol * curVol / 1;
		}
		
		
		
		
		
		
		static public function get SoundEnabled():Boolean 
		{
			return soundEnabled;
		}
		
		static public function set SoundEnabled(value:Boolean):void 
		{
			soundEnabled = value;
			if (value == true)
			{
				//Root.soundManager.PlaySound("soundOnOff");
			}
		}
		
		
		
		
		
	
	}
}