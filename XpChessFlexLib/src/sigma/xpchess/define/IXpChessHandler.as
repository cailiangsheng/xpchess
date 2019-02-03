package sigma.xpchess.define
{
	import sigma.xpchess.event.XpChessErrorEvent;
	import sigma.xpchess.event.XpChessGameEvent;
	import sigma.xpchess.event.XpChessMoveEvent;
	
	public interface IXpChessHandler
	{
		function onStartGame(e: XpChessGameEvent): void;
		function onEndGame(e: XpChessGameEvent): void;
		function onMoveChessMan(e: XpChessMoveEvent): void;
		function onError(e: XpChessErrorEvent): void;
	}
}