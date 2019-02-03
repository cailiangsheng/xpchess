package sigma.xpchess.implement.pv3d
{
	import sigma.xpchess.implement.common.ChessPool;
	import sigma.xpchess.implement.common.XpChessViewRotateBase;

	public class XpChessViewRotatePV3D extends XpChessViewRotateBase
	{
		public function XpChessViewRotatePV3D(autoRotate: Boolean = false)
		{
			super(new ChessPool(ChessBoardPV3D, ChessManPV3D), new ViewportPV3D(), new ViewTransformerPV3D(this), autoRotate);
		}
	}
}