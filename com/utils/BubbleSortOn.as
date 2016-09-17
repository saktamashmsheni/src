package com.utils 
{
	/**
	 * ...
	 * @author ...
	 */
	public class BubbleSortOn
	{
		
		public function BubbleSortOn()
		{
			
		}
		
		public static function prop(arr:Array, prop:String):Array
		{
			var bAnySwapped:Boolean;
			
			do 
			{
				bAnySwapped = false;
				for (var i:Number = 1 ; i < arr.length ; i++)
				{
					if (arr[i - 1][prop] > arr[i][prop])
					{
						// Wrong order.  Swap them.
						var temp = arr[i-1];
						arr[i-1] = arr[i];
						arr[i] = temp;
						bAnySwapped = true;
				   }
				}
			} while (bAnySwapped);
			
			return arr;
		}
		
	}

}