package sigma.xpchess.implement.stage2d
{
	import sigma.xpchess.implement.common.ChessPool;
	import sigma.xpchess.implement.common.XpChessViewBase;
	import sigma.xpchess.util.ChessMan;

	public class XpChessView extends XpChessViewBase
	{
		public function XpChessView(autoRotate: Boolean = false)
		{
			super(new ChessPool(ChessBoard, ChessMan), new ViewportStage2D(), new ViewTransformer(this), autoRotate);
		}
	}
}