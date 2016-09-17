package game 
{
	import com.utils.MouseEvent;
	import com.utils.MyButton;
	import com.utils.StaticGUI;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author ...
	 */
	public class PlusMinusButs extends Sprite
	{
		private var plusTextures:Vector.<Texture>;
		private var minusTextures:Vector.<Texture>;
		public var plusBtn:MyButton;
		public var minusBtn:MyButton;
		private var _mouseEnabled:Boolean = true;
		private var maxButtonTextures:Vector.<Texture>;
		public var max_btn:MyButton;
		
		public function PlusMinusButs(plusTextures:Vector.<Texture>, minusTextures:Vector.<Texture>, maxButtonTextures:Vector.<Texture> = null) 
		{
			this.maxButtonTextures = maxButtonTextures;
			this.minusTextures = minusTextures;
			this.plusTextures = plusTextures;
			initPlusMinus();
		}
		
		private function initPlusMinus():void 
		{
			var quad:Quad = new Quad(35, 35, 0xff0000);
			plusBtn = new MyButton(plusTextures, "TL");
			plusBtn.setHover(quad);
			plusBtn.name = "plus";
			plusBtn.x = 128;
			addChild(plusBtn);
			var quad2:Quad = new Quad(35, 35, 0xff0000);
			minusBtn = new MyButton(minusTextures, "TL");
			
			minusBtn.name = "minus";
			addChild(minusBtn);
			minusBtn.setHover(quad2);
			
			if (maxButtonTextures != null)
			{
				max_btn = new MyButton(maxButtonTextures, "CC");
				addChild(max_btn);
				max_btn.x = 145;
				max_btn.y = -4;
			}
			
			
		}
		
		
		public function get mouseEnabled():Boolean 
		{
			return _mouseEnabled;
		}
		
		public function set mouseEnabled(value:Boolean):void 
		{
			plusBtn.mouseEnabled = value;
			minusBtn.mouseEnabled = value;
			_mouseEnabled = value;
		}
		
	}

}