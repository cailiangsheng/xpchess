package sigma.xpchess.event
{
	import flash.events.Event;
	
	public class XpChessBoardEvent extends Event
	{
		public static const CLICK_BOARD: String = "click_board";
		public static const CLICK_MAN: String = "click_man";
		
		public var gameType: int;
		public var localX: Number;
		public var localY: Number;
		
		public function XpChessBoardEvent(type:String, gameType: int, localX: Number, localY: Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.gameType = gameType;
			this.localX = localX;
			this.localY = localY;
		}
	}
}