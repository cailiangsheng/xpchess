package sigma.xpchess.event
{
	import flash.events.Event;
	
	import sigma.xpchess.util.ChessManPos;
	
	public class XpChessMoveEvent extends Event
	{
		public static const MOVING: String = "moving";
		public static const CANCEL: String = "cancel";
		public static const MOVE: String = "move";
		public static const FAIL: String = "fail";
		
		public var from: ChessManPos;
		public var to: ChessManPos;
		
		public function XpChessMoveEvent(type: String, from: ChessManPos, to: ChessManPos, bubbles:Boolean = false, cancelable: Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.from = from;
			this.to = to;
		}
	}
}