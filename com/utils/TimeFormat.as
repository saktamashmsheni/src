package com.utils
{

    public class TimeFormat extends Object
    {
        public static const HOURS:uint = 2;
        public static const MINUTES:uint = 1;
        public static const SECONDS:uint = 0;

        public function TimeFormat()
        {
            return;
        }// end function

        public static function formatTime(param1:Number, param2:uint = 2) : String
        {
            var _loc_3:* = Math.floor(param1);
            var _loc_4:* = Math.floor(_loc_3 / 3600);
            var _loc_5:* = (_loc_3 - _loc_4 * 3600) / 60;
            var _loc_6:* = _loc_3 - _loc_4 * 3600 - _loc_5 * 60;
            var _loc_7:* = param2 == HOURS ? ((_loc_4 < 10 ? ("0") : ("")) + _loc_4 + ":") : ("");
            var _loc_8:* = param2 >= MINUTES ? ((param2 == HOURS && _loc_5 < 10 ? ("0") : ("")) + _loc_5 + ":") : ("");
            var _loc_9:* = (_loc_6 < 10 && param2 >= MINUTES ? ("0") : ("")) + _loc_6;
            return _loc_7 + _loc_8 + _loc_9;
        }// end function

    }
}
