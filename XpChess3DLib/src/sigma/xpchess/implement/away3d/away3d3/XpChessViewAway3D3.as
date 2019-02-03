package sigma.xpchess.implement.away3d.away3d3
{
	import sigma.xpchess.implement.common.ChessPool;
	import sigma.xpchess.implement.common.XpChessViewBase;
	import sigma.xpchess.implement.away3d.ViewTransformerAway3D;

	internal class XpChessViewAway3D3 extends XpChessViewBase
	{
		public function XpChessViewAway3D3(autoRotate: Boolean = false)
		{
			super(new ChessPool(ChessBoardAway3D3, ChessManAway3D3), new ViewportAway3D3(), new ViewTransformerAway3D(this), autoRotate);
		}
	}
}