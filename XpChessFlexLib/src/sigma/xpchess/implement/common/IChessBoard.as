package sigma.xpchess.implement.common
{
	import flash.events.IEventDispatcher;
	
	import sigma.xpchess.util.ChessManPos;

	public interface IChessBoard
	{
		function get eventDispatcher(): IEventDispatcher;
		function get boardType(): int;
		function set boardRotation(value: Number): void;
		function get boardRotation(): Number;
		function reset(): void;
		function clearChessMans(): void;
		function addChessMan(man: IChessMan): void;
		function clearPrint(): void;
		function printMove(pos: ChessManPos, color: uint): void;
	}
}