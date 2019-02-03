package sigma.xpchess.implement.sandy3d
{
	import sigma.xpchess.implement.common.ChessPool;
	import sigma.xpchess.implement.common.ViewTransformerBase;
	import sigma.xpchess.implement.common.XpChessViewBase;
	
	internal class XpChessViewSandy3D extends XpChessViewBase
	{
		public function XpChessViewSandy3D(autoRotate: Boolean = false)
		{
			super(new ChessPool(ChessBoardSandy3D, ChessManSandy3D), new ViewportSandy3D(), new ViewTransformerBase(this), autoRotate);
		}
	}
}