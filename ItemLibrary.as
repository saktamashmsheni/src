package  {

	import flash.display.*;
	import flash.events.*;

  public class ItemLibrary{


	  // init static class
	private static var _instance:ItemLibrary;
	private static var _canInit:Boolean = false;
	
	//
	
	 private static var _bg:Class;
	 
	 //cards:
	 
	 private static var _newCards:Class;
	 
	 //table
	 
	 
	 
	 
	 //alerts
	 private static var _alertContOrHome_Source:Class;
	 private static var _alertRaiseCost_Source:Class;
	 private static var _alertLoose_Source:Class;
	 private static var _alertJoin_Source:Class;
	 private static var _alertJoinWaiting_Source:Class;
	 private static var _alertWin_Source:Class;
	 private static var _alertGameOverWin_Source:Class;
	 private static var _alertGameOverLoose_Source:Class;
	 private static var _alertError_Source:Class;
	 private static var _alertBuraWin_Source:Class;
	 private static var _alertBuraLoose_Source:Class;
	 private static var _alertTie_Source:Class;

	 private static var _alertCreatRoom_Source:Class;
	 private static var _alertTransferError_Source:Class;
	 private static var _alertReplayGame_Source:Class;
	 
	 private static var _cardColorChoose_Source:Class;
	 private static var _cardHighColor_Source:Class;
	 
	 private static var _dropDownItem_Source:Class;
	 
	
	 private static var _lobbyScroller:Class;
	 private static var _lobbyRoomItem:Class;
	 private static var _tablePlayGame:Class;
	 
	 public static var _effectSpark:Class;
	 public static var _lobbyScene:Class;
	 public static var _creatRoom:Class;
	 public static var _lobbyStatistics_Source:Class;
	 public static var _lobbyStatisticsItem_Source:Class;
	 public static var _gameLogo:Class;
	 public static var _alertBugReport_Source:Class;
	 
	 private static var _chat_Source:Class;
	 private static var _chatItem:Class;
	 
	 public static var _historyBg_Source:Class;
	 public static var _historyListItem_Source:Class;
	 public static var _historyController_Source:Class;
	 
	 
    public function ItemLibrary() {
      super();

      if (_canInit == false) {
        throw new Error('ItemLibrary is an singleton and cannot be instantiated.');
      }
    }
	
	public static function  get getItem():ItemLibrary {
      if (_instance == null) {
        _canInit = true;
        _instance = new ItemLibrary();
        _canInit = false;
      }
      return _instance;
    }		
	
	public  function get CardHighColor_Source():Class {
			return _cardHighColor_Source;
	}
	public  function set CardHighColor_Source(value:Class) {
			_cardHighColor_Source = value;
	}	
	public  function get CardColorChoose_Source():Class {
			return _cardColorChoose_Source;
	}
	public  function set CardColorChoose_Source(value:Class) {
			_cardColorChoose_Source = value;
	}
	
	public  function get TablePlayGame_Source():Class {
			return _tablePlayGame;
	}
	public  function set TablePlayGame_Source(value:Class) {
			_tablePlayGame = value;
	}
	
	public  function get LobbyRoomItem():Class {
			return _lobbyRoomItem;
	}
	public  function set LobbyRoomItem(value:Class) {
			_lobbyRoomItem = value;
	}
		
	public  function get LobbyScroller():Class {
			return _lobbyScroller;
	}
	public  function set LobbyScroller(value:Class) {
			_lobbyScroller = value;
	}
	
	public  function get DropDownItem_Source():Class {
			return _dropDownItem_Source;
	}
	public  function set DropDownItem_Source(value:Class) {
			_dropDownItem_Source = value;
	}
	
	public  function get ChatItem():Class {
			return _chatItem;
	}
	public  function set ChatItem(value:Class) {
			_chatItem = value;
	}
	
	public  function get Chat_Source():Class {
			return _chat_Source;
	}
	public  function set Chat_Source(value:Class) {
			_chat_Source = value;
	}
	
	
	//alerts
	
	public  function get AlertReplayGame_Source():Class {
			return _alertReplayGame_Source;
	}
	public  function set AlertReplayGame_Source(value:Class) {
			_alertReplayGame_Source = value;
	}	
	
	public  function get AlertTie_Source():Class {
			return _alertTie_Source;
	}
	public  function set AlertTie_Source(value:Class) {
			_alertTie_Source = value;
	}
	
	public  function get AlertBuraLoose_Source():Class {
			return _alertBuraLoose_Source;
	}
	public  function set AlertBuraLoose_Source(value:Class) {
			_alertBuraLoose_Source = value;
	}
	
	public  function get AlertBuraWin_Source():Class {
			return _alertBuraWin_Source;
	}
	public  function set AlertBuraWin_Source(value:Class) {
			_alertBuraWin_Source = value;
	}
	
	
	
	public  function get AlertError_Source():Class {
			return _alertError_Source;
	}
	public  function set AlertError_Source(value:Class) {
			_alertError_Source = value;
	}	
	public  function get AlertGameOverLoose_Source():Class {
			return _alertGameOverLoose_Source;
	}
	public  function set AlertGameOverLoose_Source(value:Class) {
			_alertGameOverLoose_Source = value;
	}
	
	public  function get AlertGameOverWin_Source():Class {
			return _alertGameOverWin_Source;
	}
	public  function set AlertGameOverWin_Source(value:Class) {
			_alertGameOverWin_Source = value;
	}	
	public  function get AlertWin_Source():Class {
			return _alertWin_Source;
	}
	public  function set AlertWin_Source(value:Class) {
			_alertWin_Source = value;
	}
	
	public  function get AlertJoinWaiting_Source():Class {
			return _alertJoinWaiting_Source;
	}
	public  function set AlertJoinWaiting_Source(value:Class) {
			_alertJoinWaiting_Source = value;
	}	
	public  function get AlertJoin_Source():Class {
			return _alertJoin_Source;
	}
	public  function set AlertJoin_Source(value:Class) {
			_alertJoin_Source = value;
	}	
	public  function get AlertLoose_Source():Class {
			return _alertLoose_Source;
	}
	public  function set AlertLoose_Source(value:Class) {
			_alertLoose_Source = value;
	}	
	public  function get AlertRaiseCost_Source():Class {
			return _alertRaiseCost_Source;
	}
	public  function set AlertRaiseCost_Source(value:Class) {
			_alertRaiseCost_Source = value;
	}	
	public  function get AlertContOrHome_Source():Class {
			return _alertContOrHome_Source;
	}
	public  function set AlertContOrHome_Source(value:Class) {
			_alertContOrHome_Source = value;
	}		
	
	public  function get bg():Class {
			return _bg;
	}
	public  function set bg(value:Class) {
			_bg = value;
	}
	
		
	//cards
	
	public  function get NewCards():Class {
			return _newCards;
	}
	public  function set NewCards(value:Class) {
			_newCards = value;
	}			
  }
}
