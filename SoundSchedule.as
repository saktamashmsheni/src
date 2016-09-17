package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/**
	 * ...
	 * @author zazuna
	 */
	public class SoundSchedule extends EventDispatcher
	{
		private var commands:Array
		private var sound:Sound;
		private var volume:Number
		
		public static var ON_SCHEDULE_COMPLETE:String = "soundschedulecomplete";
		
		public function SoundSchedule(text:String, vol:Number):void {
			volume = vol;
			
			transformTextToCommands(text);
			executeCommand();
		}
		
		private function executeCommand(e:Event = null):void 
		{
			if (commands.length == 0) {
				dispatchEvent(new Event(SoundSchedule.ON_SCHEDULE_COMPLETE));
				return;
			}
			
			var str:String = commands.shift();
			var sc:SoundChannel = new SoundChannel();
			var st:SoundTransform = new SoundTransform(volume);
			
			sound = Root.soundManager.PlaySound(str, false);
			sc = sound.play(0, 1, st);
			if(sc) sc.addEventListener(Event.SOUND_COMPLETE, executeCommand);
			
		}
		
		private function transformTextToCommands(text:String):void 
		{
			commands = new Array();
			
			/*while (text.indexOf("&&") > -1) {
				var num:int = text.indexOf("&&");
				
				var str:String = text.substr(0, num);
				text = text.substr(num + 1);
				
				if (str != "" && str != " ") {
					commands.push(str);
				}
			}
			
			if (text != "" && text != " ") {
					commands.push(text);
			}*/
			
			commands = text.split("&&");
			
			
		}
	}
}