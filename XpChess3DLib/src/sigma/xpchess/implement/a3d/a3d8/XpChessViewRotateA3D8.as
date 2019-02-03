package sigma.xpchess.implement.a3d.a3d8
{
	import sigma.xpchess.implement.common.ChessPool;
	import sigma.xpchess.implement.common.ViewTransformerBase;
	import sigma.xpchess.implement.common.XpChessViewRotateBase;

	public class XpChessViewRotateA3D8 extends XpChessViewRotateBase
	{
		public function XpChessViewRotateA3D8(autoRotate: Boolean = false)
		{
			super(new ChessPool(ChessBoardA3D8, ChessManA3D8), new ViewportA3D8(), new ViewTransformerBase(this), autoRotate);
		}
		
		override public function get stage3d():Boolean
		{
			return true;
		}
	}
}