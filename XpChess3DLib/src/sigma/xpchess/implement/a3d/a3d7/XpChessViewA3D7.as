package sigma.xpchess.implement.a3d.a3d7
{
	import sigma.xpchess.implement.common.ChessPool;
	import sigma.xpchess.implement.common.ViewTransformerBase;
	import sigma.xpchess.implement.common.XpChessViewBase;
	
	internal class XpChessViewA3D7 extends XpChessViewBase
	{
		public function XpChessViewA3D7(autoRotate: Boolean = false)
		{
			super(new ChessPool(ChessBoardA3D7, ChessManA3D7), new ViewportA3D7(), new ViewTransformerBase(this), autoRotate);
		}
	}
}