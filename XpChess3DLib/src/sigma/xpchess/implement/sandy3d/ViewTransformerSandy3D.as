package sigma.xpchess.implement.sandy3d
{
	import flash.display.DisplayObject;
	
	import sigma.xpchess.implement.common.ViewTransformerBase;

	internal class ViewTransformerSandy3D extends ViewTransformerBase
	{
		public function ViewTransformerSandy3D(view: DisplayObject, maxZ: Number = Infinity, maxR: Number = Infinity)
		{
			super(view, maxZ, maxR);
		}
		
		override protected function get isDegree(): Boolean
		{
			return true;
		}
		
		override protected function get rotationX(): String
		{
			return "rotateX";
		}
		
		override protected function get rotationY(): String
		{
			return "rotateY";
		}
		
		override protected function get rotationZ(): String
		{
			return "rotateZ";
		}
	}
}