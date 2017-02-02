package game.adjara 
{
	import connection.SocketAnaliser;
	import game.GameHolder;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class AdjaraSpins extends EventDispatcher
	{
		
		public static var totalSpins:int;
		public static var curSpin:int;
		public static var Bet:int;
		public static var Line:int;
		private static var _canActivate:Boolean = false;
		
		private static var freeSpinMode:Boolean = false;
		
		public function AdjaraSpins() 
		{
			
		}
		
		static public function setSpins(obj:Object):void 
		{
			totalSpins = obj.FreeSpins;
			curSpin = 0;
			Bet = obj.Bet;
			Line = obj.Line;
			FreeSpinMode = obj.FreeSpinMode;
			
			if (FreeSpinMode == true)
			{
				GameHolder.cont.footerHolder._lineStepper._stepperValue = Root.linesArray.indexOf(obj.Line);
				GameHolder.cont.footerHolder._betStepper._stepperValue = Root.betsArray.indexOf(uint((obj.Bet)));
			}
		}
		
		static public function activateAdjaraSpins():void 
		{
			if (FreeSpinMode == false)
			{
				Root.connectionManager.sendData({MT:SocketAnaliser.adjaraSpins});
			}
		}
		
		
		static public function updateCount(left:int = -1):void 
		{
			if (FreeSpinMode == false) return;
			
			if (left == -1)
			{
				curSpin ++;
			}
			else
			{
				curSpin = totalSpins - left;
				if (left == 0)
				{
					FreeSpinMode = false;
					curSpin = 0;
					totalSpins = 0;
					GameHolder.cont.removeAdjaraSpinsCont();
				}
			}
			
			if (AdjaraSpinsGraphics.cont != null && left != 0)
				AdjaraSpinsGraphics.cont.onChange(curSpin, totalSpins);
		}
		
		
		
		
		static public function get FreeSpinMode():Boolean 
		{
			return freeSpinMode;
		}
		
		static public function set FreeSpinMode(value:Boolean):void 
		{
			freeSpinMode = value;
			if (value == true)
			{
				GameHolder.cont.footerHolder._lineStepper.touchable = false;
				GameHolder.cont._lineButsHolder.touchable = false;
				GameHolder.cont.footerHolder._betStepper.touchable = false;
				GameHolder.cont.footerHolder.$creditSwitcher.touchable = false;
				GameHolder.cont.footerHolder.$creditSwitcher.updateToFirst();
			}
			else
			{
				GameHolder.cont.footerHolder._lineStepper.touchable = true;
				GameHolder.cont._lineButsHolder.touchable = true;
				GameHolder.cont.footerHolder._betStepper.touchable = true;
				GameHolder.cont.footerHolder.$creditSwitcher.touchable = true;
			}
		}
		
		
		static public function get canActivate():Boolean 
		{
			return _canActivate;
		}
		
		static public function set canActivate(value:Boolean):void 
		{
			_canActivate = value;
			if (value == true)
			{
				if (AdjaraSpinsGraphics.cont != null && AdjaraSpinsGraphics.cont.stageState == 1)
				{
					AdjaraSpinsGraphics.cont.canActivate(true);
				}
			}
			else
			{
				if (AdjaraSpinsGraphics.cont != null && AdjaraSpinsGraphics.cont.stageState == 1)
				{
					AdjaraSpinsGraphics.cont.canActivate(false);
				}
			}
		}
		
	}

}