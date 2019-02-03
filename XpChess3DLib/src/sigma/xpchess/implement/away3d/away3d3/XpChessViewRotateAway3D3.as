package sigma.xpchess.implement.away3d.away3d3
{
	import sigma.xpchess.implement.common.ChessPool;
	import sigma.xpchess.implement.common.XpChessViewRotateBase;
	import sigma.xpchess.implement.away3d.ViewTransformerAway3D;

	public class XpChessViewRotateAway3D3 extends XpChessViewRotateBase
	{
		public function XpChessViewRotateAway3D3(autoRotate: Boolean = false)
		{
			super(new ChessPool(ChessBoardAway3D3, ChessManAway3D3), new ViewportAway3D3(), new ViewTransformerAway3D(this), autoRotate);
		}
	}
}