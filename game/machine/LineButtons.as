package game.machine {
	import com.utils.StaticGUI;
	import feathers.controls.ButtonState;
	import feathers.controls.Radio;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.core.ToggleGroup;
	import feathers.skins.ImageSkin;
	import flash.text.TextFormatAlign;
	import game.GameHolder;
	import game.footer.FooterHolder;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author ...
	 */
	public class LineButtons extends Sprite {
		
		private var $atlas:TextureAtlas;
		private var $lineNumsVect:Vector.<LineNums>;
		private var $groupl:ToggleGroup;
		private var $groupr:ToggleGroup;
		
		public function LineButtons() {
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			//initButtons();
		}
		
		public function initButtons():void {
			var img:Image;
			var imgSp:Sprite;
			var tt:TextField;
			
			var lineNumSp:Sprite;
			
			var yCount:int = 0;
			var xCount:int = 0;
			
			$atlas = Assets.getAtlas("lines", "linesXml");
			$lineNumsVect = new Vector.<LineNums>;
			
			$groupl = new ToggleGroup();
			$groupr = new ToggleGroup();
			
			var $radio:Radio;
			var $textArr:Vector.<String> = new Vector.<String>();
			
			for (var i:int = 0; i < GameSettings.LINES_COUNT_CONFIG.length; i++) 
			{
				$textArr.push(String(GameSettings.LINES_COUNT_CONFIG[i]));
			}
			
			
			
			if (GameSettings.LINES_FIXED) this.touchable = false;
			
			
			
			for (var $i:uint; $i < 5; $i++ ){
				
				if (GameSettings.LINES_FIXED)
				{
					lineNumSp = new LineNumsFixed($textArr[$i], $i);
					lineNumSp.y = $i *-82;
					this.addChild(lineNumSp);
					
					lineNumSp = new LineNumsFixed($textArr[$i], $i);
					lineNumSp.x = 812;
					lineNumSp.y = $i *-82;
					this.addChild(lineNumSp);
				}
				else
				{
					$radio = new LineNums($textArr[$i]);
					$radio.name = 'radio_' + $i + '_l';
					$radio.y = $i *-82;
					$radio.toggleGroup = $groupl;
					//$radio.defaultSkin = $skin;
					$radio.useHandCursor = true;
					this.addChild($radio);
					$radio.validate();
					$lineNumsVect.push($radio);
					
					
					$radio = new LineNums($textArr[$i]);
					$radio.name = 'radio_' + $i + '_r';
					$radio.x = 812;
					$radio.y = $i *-82;
					$radio.useHandCursor = true;
					$radio.toggleGroup = $groupr;
					//$radio.defaultSkin = $skin;
					
					this.addChild($radio);
					$radio.validate();
				}
				
			}
			
			$groupl.addEventListener(Event.CHANGE, groupChangeHandler);
			$groupr.addEventListener(Event.CHANGE, groupChangeHandler);
			
			/*for (var i:int = 0; i < Root.totalLines; i++) {
				imgSp = new Sprite();
				
				img = new Image(Assets.getAtlas("lineButsBgs", "lineButsBgsXml").getTexture("lineButsBgs" + StaticGUI.intWithZeros(numAr[i] - 1, 4)));
				imgSp.addChild(img);
				addChild(imgSp);
				tt = new TextField(40, 30, String(numAr[i]), Assets.getFont("IRON").name, 25, 0xFFFFFF, true);
				tt.y = 0;
				imgSp.addChild(tt);
				imgSp.name = "b" + String(numAr[i]);
				Tracer._log(imgSp.name)
				tt.alignPivot(HAlign.CENTER, VAlign.CENTER);
				img.alignPivot(HAlign.CENTER, VAlign.CENTER);
				imgSp.alignPivot(HAlign.CENTER, VAlign.CENTER);
				
				imgSp.y = yCount * (imgSp.height);
				yCount++;
				if (xCount == 1)
					imgSp.x = 679;
				
				if (yCount == 10) {
					yCount = 0;
					xCount = 1;
				}
				
				img.dispose();
			}*/
			
			img = null;
			imgSp = null;
			tt = null;
			
			
			if (GameSettings.LINES_FIXED){
				this.touchable = false;
				_selectLine($textArr.length-1);
			}
			else
			{
				_selectLine(GameSettings.LINES_COUNT_CONFIG.indexOf(GameSettings.ACT_LINES));
			}
		}
		
		
		public function _isEnabled(boo:Boolean = true):void{
			if (GameSettings.LINES_FIXED) return;
			this.touchable = boo;
		}
		
		public function _selectLine(line:int = 0):void{
			if (GameSettings.LINES_FIXED) return;
			Radio($lineNumsVect[line]).isSelected  = true;
		}
		
		
		
		private function group_R_ChangeHandler(e:Event):void {
			if (GameHolder.gameState != GameHolder.NORMAL_STATE) return;
			var $group:ToggleGroup = ToggleGroup(e.currentTarget);
			//FooterHolder.cont._lineStepper._stepperValue = $group.selectedIndex;
			
			/*var $group:ToggleGroup = ToggleGroup( e.currentTarget );
			var $radio:Radio = Radio(this.getChildByName('radio_' + $group.selectedIndex +'_l'));
			$radio.isSelected = true;*/
		}
		
		private function groupChangeHandler(e:Event):void {
			var $group:ToggleGroup = ToggleGroup( e.currentTarget );
			var $radio:Radio = Radio(this.getChildByName('radio_' + $group.selectedIndex +'_r'));
			$radio.isSelected = true;
			
			$radio = Radio(this.getChildByName('radio_' + $group.selectedIndex +'_l'));
			$radio.isSelected = true;
			
			GameHolder.cont.footerHolder.updateLines(GameSettings.LINES_COUNT_CONFIG[$group.selectedIndex]);
		}
	}
}