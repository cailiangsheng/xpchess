package sigma.xpchess.implement.pv3d
{
	import flash.display.DisplayObject;
	
	import sigma.xpchess.implement.common.ViewTransformerBase;

	public class ViewTransformerPV3D extends ViewTransformerBase
	{
		public function ViewTransformerPV3D(view: DisplayObject, maxZ: Number = Infinity, maxR: Number = Infinity)
		{
			super(view, maxZ, maxR);
		}
		
		override protected function get isDegree(): Boolean
		{
			return true;
		}
		
		override protected function get rotationX(): String
		{
			return "localRotationX";
		}
		
		override protected function get rotationY(): String
		{
			return "localRotationY";
		}
		
		override protected function get rotationZ(): String
		{
			return "localRotationZ";
		}
	}
}