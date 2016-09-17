package game.doubleGame {
	import com.utils.StaticGUI;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.utils.Align;
	import starling.utils.Align;
	
	
	public class Card extends Sprite {
		
		public var lastWidth:Number = 70;
		public var lastHeight:Number = 100;
		public var _value:String;
		public var _numValue:Number;
		public var _suitValue:Number;
		private var _isFaceUp:Boolean;
		private var cardIMG:Image;
		public var canDeal:Boolean = true;
		public var startingX:Number;
		public var startingY:Number;
		public var status:String;
		public var dealID:int;
		public var dealAnimating:Boolean = false;
		public var itsMyCard:Boolean;
		public var isInGame:Boolean = true;
		public var cardObject:Object;
		public static var stWidth:Number;
		
		public function Card(arr:Array = null) {
			//this.alignPivot(Align.CENTER, Align.CENTER);
			
			this.scaleX = this.scaleY = 0.8;
			
			_isFaceUp = true;
			if (arr == null) {
				_value = "Background";
				_suitValue = -1;
				_numValue = -1;
			} else {
				setValue(arr);
			}
			this.HideCard();
		}
		
		public function setValue(arr:Array):void {
			this._value = CardReader.returnName(arr[1], arr[0]);
			this._numValue = arr[0];
			this._suitValue = arr[1];
		}
		
		public function makeFaceUp():void {
			ShowCard();
		}
		
		public function makeFaceDown():void {
			HideCard();
		}
		
		public function HideCard():void {
			if (cardIMG != null) {
				StaticGUI.safeRemoveChild(cardIMG);
				cardIMG = null;
			}
			
			cardIMG = CardSheetManager.getCardImage(-1, -1);
			cardIMG.alignPivot(Align.CENTER, Align.CENTER);
			addChild(cardIMG);
			_isFaceUp = false
		}
		
		public function ShowCard():void {
			if (cardIMG != null) {
				StaticGUI.safeRemoveChild(cardIMG);
				cardIMG = null;
			}
			
			cardIMG = CardSheetManager.getCardImage(_suitValue, _numValue);
			//cardIMG.textureSmoothing = 'trilinear';
			cardIMG.textureSmoothing = 'trilinear';
			cardIMG.alignPivot(Align.CENTER, Align.CENTER);
			addChild(cardIMG);
			_isFaceUp = true;
		}
	
	}

}