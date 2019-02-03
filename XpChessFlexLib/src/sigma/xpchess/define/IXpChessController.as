package sigma.xpchess.define
{
	import sigma.xpchess.util.ChessManData;
	import sigma.xpchess.util.ChessManPos;

	public interface IXpChessController
	{
		function init(model: IXpChessModel): void;
		function onChessBoardClick(pos: ChessManPos): void;
	}
}