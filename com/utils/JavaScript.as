package com.utils
{
    import flash.external.*;

    public class JavaScript extends Object
    {

        public function JavaScript()
        {
            return;
        }// end function

        public static function call(param1:String, ... args) : Object
        {
            args = new activation;
            var functionName:* = param1;
            var params:* = args;
            var res:Object;
            if (ExternalInterface.available)
            {
                try
                {
                    res = ExternalInterface.call.apply(null, [].concat());
                }
                catch (e:Error)
                {
                }
            }
            return ;
        }// end function

        public static function get available() : Boolean
        {
            return ExternalInterface.available;
        }// end function

        public static function addCallback(param1:String, param2:Function) : void
        {
            if (ExternalInterface.available)
            {
                ExternalInterface.addCallback(param1, param2);
            }
            return;
        }// end function

        public static function removeCallback(param1:String) : void
        {
            if (ExternalInterface.available)
            {
                ExternalInterface.addCallback(param1, null);
            }
            return;
        }// end function

    }
}
