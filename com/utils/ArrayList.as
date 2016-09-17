package com.utils
{

    public class ArrayList extends Object
    {
        private var arr:Array;

        public function ArrayList(param1:Object = null)
        {
            this.arr = [];
            if (param1 == null)
            {
                return;
            }
            if (param1 is Array)
            {
                this.arr = (param1 as Array).concat();
            }
            else
            {
                this.arr = (param1 as ArrayList).arr.concat();
            }
            return;
        }// end function

        public function toString() : String
        {
            return this.arr.join(", ");
        }// end function

        public function toArray() : Array
        {
            return this.arr.concat();
        }// end function

        public function add(param1:Object) : void
        {
            this.arr[this.arr.length] = param1;
            return;
        }// end function

        public function setItem(param1:int, param2:Object) : void
        {
            this.arr[param1] = param2;
            return;
        }// end function

        public function addAll(param1:ArrayList) : void
        {
            this.arr.push.apply(null, param1.arr);
            return;
        }// end function

        public function contains(param1:Object) : Boolean
        {
            return this.indexOf(param1) != -1;
        }// end function

        public function getIndex(param1:int) : Object
        {
            return this.arr[param1];
        }// end function

        public function clear() : void
        {
            this.arr = [];
            return;
        }// end function

        public function size() : int
        {
            return this.arr.length;
        }// end function

        public function isEmpty() : Boolean
        {
            return this.arr.length == 0;
        }// end function

        public function indexOf(param1:Object) : int
        {
            var _loc_3:* = null;
            var _loc_2:* = 0;
            while (_loc_2 < this.arr.length)
            {
                
                _loc_3 = this.arr[_loc_2];
                if (_loc_3 == param1)
                {
                    return _loc_2;
                }
                _loc_2++;
            }
            return -1;
        }// end function

        public function removeObject(param1:Object) : void
        {
            var _loc_2:* = this.indexOf(param1);
            if (_loc_2 >= 0)
            {
                this.remove(_loc_2);
            }
            return;
        }// end function

        public function remove(param1:int) : Object
        {
            var _loc_2:* = this.size() - 1;
            var _loc_3:* = this.arr[param1];
            var _loc_4:* = param1;
            while (_loc_4 < _loc_2)
            {
                
                this.arr[_loc_4] = this.arr[(_loc_4 + 1)];
                _loc_4++;
            }
            delete this.arr[_loc_2];
            this.arr.length = _loc_2;
            return _loc_3;
        }// end function

        public static function startsWith(param1:String, param2:String) : Boolean
        {
            return param1.substr(0, param2.length) == param2;
        }// end function

        public static function fill(param1:Array, param2:int, param3:Object) : void
        {
            var _loc_4:* = 0;
            while (_loc_4 < param2)
            {
                
                param1[_loc_4] = param3;
                _loc_4++;
            }
            return;
        }// end function

        public static function nextInt() : int
        {
            return int(Math.random() * int.MAX_VALUE);
        }// end function

       /* public static function randomPermutation(param1:int) : Array
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_2:* = new Array(param1);
            var _loc_3:* = 0;
            while (_loc_3 < param1)
            {
                
                _loc_2[_loc_3] = _loc_3;
                _loc_3++;
            }
            _loc_3 = 0;
            while (_loc_3 < (param1 - 1))
            {
                
                _loc_4 = StaticFunctions.random(_loc_3, param1);
                if (_loc_4 != _loc_3)
                {
                    _loc_5 = _loc_2[_loc_4];
                    _loc_2[_loc_4] = _loc_2[_loc_3];
                    _loc_2[_loc_3] = _loc_5;
                }
                _loc_3++;
            }
            return _loc_2;
        }// end function*/

        public static function createMultiArray(param1:Array, param2:Object = null, param3:Boolean = false) : Array
        {
            var _loc_8:* = 0;
            var _loc_4:* = param1[0];
            var _loc_5:* = new Array(_loc_4);
            if (param1.length == 1)
            {
                _loc_8 = 0;
                while (_loc_8 < _loc_4)
                {
                    
                    _loc_5[_loc_8] = param3 ? (nextInt()) : (param2);
                    _loc_8++;
                }
                return _loc_5;
            }
            var _loc_6:* = param1.slice(1);
            var _loc_7:* = 0;
            while (_loc_7 < _loc_4)
            {
                
                _loc_5[_loc_7] = createMultiArray(_loc_6, param2, param3);
                _loc_7++;
            }
            return _loc_5;
        }// end function

        public static function assert(param1:Boolean, ... args) : void
        {
            if (!param1)
            {
               // throw new Error(args.join(",\n"));
            }
            return;
        }// end function

    }
}
