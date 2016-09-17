package com.utils
{
    import flash.display.*;

    public class SpriteWrapper extends Sprite
    {

        public function SpriteWrapper(param1:DisplayObject)
        {
            var _loc_3:* = 0;
            var _loc_2:* = param1.parent;
            this.x = param1.x;
            this.y = param1.y;
            var _loc_4:* = 0;
            param1.y = 0;
            param1.x = _loc_4;
            if (_loc_2 != null)
            {
                _loc_3 = _loc_2.getChildIndex(param1);
                this.addChild(param1);
                _loc_2.addChildAt(this, _loc_3);
            }
            else
            {
                addChild(param1);
            }
            return;
        }// end function

    }
}
