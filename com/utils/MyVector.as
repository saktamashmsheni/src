package com.utils 
{
	/**
	 * ...
	 * @author George Chitaladze
	 */
	//import backgammon.engine.*;

    public class MyVector extends ArrayList implements Collector
    {

        public function MyVector(param1:Object = null)
        {
            super(param1);
            return;
        }// end function

        public function existsDuplicates() : Boolean
        {
            var _loc_2:* = 0;
            var _loc_1:* = 0;
            while (_loc_1 < size())
            {
                
                _loc_2 = _loc_1 + 1;
                while (_loc_2 < size())
                {
                    
                    if (getIndex(_loc_1) == getIndex(_loc_2))
                    {
                        return true;
                    }
                    _loc_2++;
                }
                _loc_1++;
            }
            return false;
        }// end function

        public function removeLast() : void
        {
            remove((size() - 1));
            return;
        }// end function

        public function copy() : MyVector
        {
            return new MyVector(this);
        }// end function

    }

}