package com.utils 
{
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class Timecodes
    {
        public function Timecodes()
        {
        }

        public static function timecodeToSeconds(tcStr:String):Number
        {
            var t:Array = tcStr.split(":");
            return (t[0] * 3600 + t[1] * 60 + t[2] * 1);
        }

        public static function secondsToTimecode(seconds:Number):String
        {
			var days:int = Math.floor(seconds / 60 / 60 / 24);
			seconds = seconds - days * 60 * 60 * 24;
            var minutes:Number          = Math.floor(seconds/60);
            var remainingSec:Number     = seconds % 60;
            var remainingMinutes:Number = minutes % 60;
            var hours:Number            = Math.floor(minutes/60);
            var floatSeconds:Number     = Math.floor((remainingSec - Math.floor(remainingSec))*100);
            remainingSec                = Math.floor(remainingSec);

            return String(StaticGUI.intWithZeros(days,2)) + "DAYS - " + getTwoDigits(hours) + ":" + getTwoDigits(remainingMinutes) + ":" + getTwoDigits(remainingSec);
        }

        private static function getTwoDigits(number:Number):String
        {
            if (number < 10)
            {
                return "0" + number;
            }
            else
            {
                return number + "";
            }
        }
    }

}