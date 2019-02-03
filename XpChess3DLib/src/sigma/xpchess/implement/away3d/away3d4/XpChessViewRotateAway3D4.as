package sigma.xpchess.implement.away3d.away3d4
{
	import sigma.xpchess.implement.common.ChessPool;
	import sigma.xpchess.implement.common.XpChessViewRotateBase;
	import sigma.xpchess.implement.away3d.ViewTransformerAway3D;

	public class XpChessViewRotateAway3D4 extends XpChessViewRotateBase
	{
		public function XpChessViewRotateAway3D4(autoRotate: Boolean = false)
		{
			super(new ChessPool(ChessBoardAway3D4, ChessManAway3D4), new ViewportAway3D4(), new ViewTransformerAway3D(this), autoRotate);
		}
		
		override public function get stage3d():Boolean
		{
			return true;
		}
	}
}