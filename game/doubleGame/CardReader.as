package game.doubleGame 
{
	import adobe.utils.CustomActions;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class CardReader 
	{
		
		public static function returnName(color:Number, index:Number):String
		{
			var card:String = "";
			
			if (index == 1 && color == 0)
			{
				return "JOKER";
			}
			
			if (index < 11 )
			{
				card += String(index);
			}
			else if ( index == 11)
			{
				card += "J"
			}
			else if ( index == 12)
			{
				card += "Q"
			}
			else if ( index == 13)
			{
				card += "K"
			}
			else if ( index == 14)
			{
				card += "A"
			}
			else 
			{
				Tracer._log("ERROR IN CARDREADER" + index);
			}
			
			
			switch (color) 
			{
				case 1:
					card += "C";
				break;
				case 2:
					card += "D";
				break;
				case 3:
					card += "H";
				break;
				case 4:
					card += "S";
				break;
			}
			
			
			
			return card;
		}
		
		
		
		public static function returnObj(cardName:String):Object
		{
			var index:int;
			var color:int;
			
			var arr:Array = [];
			
			if (cardName.length >= 3)
			{
				arr.push(cardName.substr(0, 2));
				arr.push(cardName.substr(cardName.length - 1 , cardName.length));
			}
			else
			{
				arr.push(cardName.substr(0, 1));
				arr.push(cardName.substr(cardName.length - 1, cardName.length));
			}
			
			
			if (int(arr[0]) <= 10 && int(arr[0] > 0))
			{
				index = int(arr[0]) - 6
			}
			else if (arr[0] == "J")
			{
				index = 5
			}
			else if (arr[0] == "Q")
			{
				index = 6
			}
			else if (arr[0] == "K")
			{
				index = 7
			}
			else if (arr[0] == "A")
			{
				index = 8
			}
			
			switch (arr[1]) 
			{
				case "C":
					color = 0;
				break;
				case "D":
					color = 1;
				break;
				case "H":
					color = 2;
				break;
				case "S":
					color = 3;
				break;
			}
			
			var obj:Object = { c:color, ind:index };
			return obj;
		}
		
		
	}

}



