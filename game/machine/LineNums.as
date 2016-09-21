package game.machine {
	import com.utils.StaticGUI;
	import feathers.controls.Radio;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.skins.ImageSkin;
	import flash.text.TextFormatAlign;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.RenderTexture;
	import starling.utils.Color;
	
	
	public class LineNums extends Radio {
		
		private var radioOff:BitmapFontTextRenderer;
		private var radioOn:BitmapFontTextRenderer;
		
		private var radioStr:String;
		
		public function LineNums(lnStr:String = null) {
			super();
			radioStr = lnStr;
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removed);
			
			
			/*var quad:Quad = new Quad(45, 50, Color.AQUA);
			quad.alpha = 0.1;
			quad.x = 100;
			quad.y = 100;
			//addChild(quad)*/
			var texture:RenderTexture = new RenderTexture(45, 60);
			//texture.draw(quad);
			 
			
			radioOff = StaticGUI._creatBitmapFontTextRenderer(this, radioStr, 0, 0, 50, 80, Assets.getFont("line_off_btn_bfont").name, TextFormatAlign.CENTER, false, -3, -1);
			if (GameSettings.LINES_FIXED){
				radioOn = StaticGUI._creatBitmapFontTextRenderer(this, radioStr + '\nf', 0, -3, 50, 80, Assets.getFont("line_on_btn_bfont").name, TextFormatAlign.CENTER, false, -13, -1, -22);
				
			}else{
				radioOn = StaticGUI._creatBitmapFontTextRenderer(this, radioStr + '', 0, 6, 50, 80, Assets.getFont("line_on_btn_bfont").name, TextFormatAlign.CENTER, false, -13, -1, -22);
			}
			
			radioOn.visible = false;
			
			this.defaultSkin = new ImageSkin(texture);
			this.addEventListener(Event.CHANGE, changeHandler);
		}
		
		private function changeHandler(e:Event):void {
			
			if (isSelected){
				radioOff.visible = !isSelected;
				radioOn.visible = isSelected;
			}else{
				radioOff.visible = !isSelected;
				radioOn.visible = isSelected;
			}
		}
		
		private function removed(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removed);
		}	
	}
}