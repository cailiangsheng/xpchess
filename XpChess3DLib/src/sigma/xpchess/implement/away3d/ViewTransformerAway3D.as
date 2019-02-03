package sigma.xpchess.implement.away3d
{
	import flash.display.DisplayObject;
	
	import sigma.xpchess.implement.common.ViewTransformerBase;

	public class ViewTransformerAway3D extends ViewTransformerBase
	{
		public function ViewTransformerAway3D(view: DisplayObject, maxZ: Number = Infinity, maxR: Number = Infinity)
		{
			super(view, maxZ, maxR);
		}
		
		override protected function get isDegree():Boolean
		{
			return true;
		}
	}
}