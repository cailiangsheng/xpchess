package sigma.xpchess.event
{
	import flash.events.Event;
	
	public class XpChessErrorEvent extends Event
	{
		public static const ERROR: String = "error";
		
		public var message: String;
		
		public function XpChessErrorEvent(type: String, message: String, bubbles: Boolean = false, cancelable: Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.message = message;
		}
	}
}