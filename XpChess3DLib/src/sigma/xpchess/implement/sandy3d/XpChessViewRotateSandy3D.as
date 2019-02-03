package sigma.xpchess.implement.sandy3d
{
	import sigma.xpchess.implement.common.ChessPool;
	import sigma.xpchess.implement.common.XpChessViewRotateBase;

	public class XpChessViewRotateSandy3D extends XpChessViewRotateBase
	{
		public function XpChessViewRotateSandy3D(autoRotate: Boolean = false)
		{
			super(new ChessPool(ChessBoardSandy3D, ChessManSandy3D), new ViewportSandy3D(), new ViewTransformerSandy3D(this), autoRotate);
		}
	}
}