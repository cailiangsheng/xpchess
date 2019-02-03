package sigma.xpchess.define
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sigma.xpchess.util.ChessManData;
	import sigma.xpchess.util.ChessManPos;

	public interface IXpChessModel extends IEventDispatcher
	{
		function get curPlayer(): int;
		function startGame(type: int): void;
		function moveChessMan(from: ChessManPos, to: ChessManPos): void;
		function getChessManData(pos: ChessManPos): ChessManData;
		function get chessMans(): Vector.<ChessManData>;
		function get from(): ChessManPos;
		function moveFrom(pos: ChessManPos): void;
		function moveTo(pos: ChessManPos): void;
	}
}