package sigma.xpchess.implement.stage2d
{
	import flash.display.DisplayObject;
	
	import sigma.xpchess.implement.common.ViewTransformerBase;

	internal class ViewTransformer extends ViewTransformerBase
	{
		public function ViewTransformer(view: DisplayObject, maxZ: Number = Infinity, maxR: Number = Infinity)
		{
			super(view, maxZ, maxR);
		}
		
		override protected function get isDegree(): Boolean
		{
			return true;
		}
	}
}