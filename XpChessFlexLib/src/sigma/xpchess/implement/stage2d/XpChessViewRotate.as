package sigma.xpchess.implement.stage2d
{
	import sigma.xpchess.implement.common.ChessPool;
	import sigma.xpchess.implement.common.XpChessViewRotateBase;
	import sigma.xpchess.util.ChessMan;

	public class XpChessViewRotate extends XpChessViewRotateBase
	{
		public function XpChessViewRotate(autoRotate: Boolean = false, originCenter: Boolean = false)
		{
			super(new ChessPool(ChessBoard, ChessMan), new ViewportStage2D(), new ViewTransformer(this), autoRotate);
		}
	}
}