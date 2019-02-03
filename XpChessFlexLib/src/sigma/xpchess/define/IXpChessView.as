package sigma.xpchess.define
{
	import sigma.xpchess.util.ChessManData;
	import sigma.xpchess.util.ChessManPos;

	public interface IXpChessView extends IXpChessContent
	{
		function init(model: IXpChessModel, controller: IXpChessController): void;
		function clearChessMans(): void;
		function loadChessMans(chessMans: Vector.<ChessManData>): void;
		function printMoveFrom(pos: ChessManPos): void;
		function printMoveTo(pos: ChessManPos): void;
		function clearPrint(): void;
		function onContainerResize(containerWidth: Number, containerHeight: Number): void;
	}
}