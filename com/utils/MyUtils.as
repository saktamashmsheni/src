package com.utils
{
    import flash.display.*;

    public class MyUtils extends Object
    {
        private static var chars:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

        public function MyUtils()
        {
            return;
        }// end function

        public static function addQeryParam(param1:String, param2:String, param3:String) : String
        {
            var _loc_4:* = null;
            if (param1.indexOf("?") == -1)
            {
                _loc_4 = param1.concat("?", param2, "=", param3);
            }
            else
            {
                _loc_4 = param1.concat("&", param2, "=", param3);
            }
            return _loc_4;
        }// end function

        public static function convertURL(param1:String, param2:Boolean) : String
        {
            var _loc_3:* = param2 ? ("https://") : ("http://");
            if (param1.substr(0, 7) == "http://")
            {
                return param1.replace("http://", _loc_3);
            }
            if (param1.substr(0, 8) == "https://")
            {
                return param1.replace("https://", _loc_3);
            }
            return param1;
        }// end function

        public static function drawPie(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:int) : void
        {
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_12:* = NaN;
            var _loc_10:* = param6 / param7;
            param1.moveTo(param2, param3);
            var _loc_11:* = 0;
            while (_loc_11 <= param7)
            {
                
                _loc_12 = param5 + _loc_11 * _loc_10;
                _loc_8 = param2 + param4 * Math.cos(_loc_12 / 180 * Math.PI);
                _loc_9 = param3 + param4 * Math.sin(_loc_12 / 180 * Math.PI);
                param1.lineTo(_loc_8, _loc_9);
                _loc_11++;
            }
            return;
        }// end function

        public static function getCloserValueAndLabel(param1:Number, param2:Array) : Object
        {
            var _loc_3:* = param2.length;
            var _loc_4:* = _loc_3 - 1;
            while (_loc_4 >= 0)
            {
                
                if (param1 >= param2[_loc_4][0])
                {
                    return {value:param2[_loc_4][0], label:param2[_loc_4][1]};
                }
                _loc_4 = _loc_4 - 1;
            }
            return {value:param2[0][0], label:param2[0][1]};
        }// end function

        public static function getCloserValue(param1:Number, param2:Array) : Number
        {
            var _loc_3:* = param2.length;
            var _loc_4:* = _loc_3 - 1;
            while (_loc_4 >= 0)
            {
                
                if (param1 >= param2[_loc_4])
                {
                    return param2[_loc_4];
                }
                _loc_4 = _loc_4 - 1;
            }
            return param2[0];
        }// end function

        public static function sumIntArray(param1:Array) : int
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            while (_loc_3 < param1.length)
            {
                
                _loc_2 = _loc_2 + param1[_loc_3];
                _loc_3++;
            }
            return _loc_2;
        }// end function

        public static function arrayPickRandomValue(param1:Array)
        {
            if (param1 == null)
            {
                return null;
            }
            var _loc_2:* = param1.length;
            var _loc_3:* = random(0, _loc_2);
            return param1[_loc_3];
        }// end function

        public static function random(param1:int, param2:int) : int
        {
            var _loc_3:* = param2 - param1;
            return Math.floor(_loc_3 * Math.random()) + param1;
        }// end function

        public static function clip(param1:int, param2:int, param3:int) : int
        {
            param1 = Math.max(param2, param1);
            param1 = Math.min(param1, param3);
            return param1;
        }// end function

        public static function generateRandomString(param1:Number) : String
        {
            var _loc_5:* = null;
            var _loc_2:* = chars.length - 1;
            var _loc_3:* = "";
            var _loc_4:* = 0;
            while (_loc_4 < param1)
            {
                
                _loc_5 = chars.charAt(Math.floor(Math.random() * _loc_2));
                _loc_3 = _loc_3.concat(_loc_5);
                _loc_4 = _loc_4 + 1;
            }
            return _loc_3;
        }// end function

    }
}
