package sigma.xpchess.event
{
	import flash.events.Event;

	public class XpChessGameEvent extends Event
	{
		public static const START: String = "start";
		public static const END: String = "end";
		
		public var gameType: int;
		
		public var winner: int;
		
		public function XpChessGameEvent(type: String, gameType: int, winner: int = -1, bubbles: Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.gameType = gameType;
			this.winner = winner;
		}
	}
}