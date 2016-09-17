package game.doubleGame 
{
	import com.utils.StaticGUI;
	import starling.display.Image;
	/**
	 * ...
	 * @author ...
	 */
	public class CardSheetManager 
	{
		
		public function CardSheetManager()
		{
			
		}
		
		public static function getCardImage(color:Number, index:Number):Image
		{
			var cardInt:int;
			
			if (color == -1 && index == -1)
			{
				cardInt = 52;
			}
			else
			{
				cardInt = (color - 1) * 13;
				cardInt = cardInt + (14 - index);
			}
			
			var cardString:String = "CardWhole" + StaticGUI.intWithZeros(cardInt, 4);
			
			return new Image(Assets.getAtlas("cardsSheet", "cardsSheetXml").getTexture(cardString));
			
		}
		
	}

}