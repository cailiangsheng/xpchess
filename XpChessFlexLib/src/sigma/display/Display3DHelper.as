package sigma.display
{
	import flash.display.DisplayObject;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;

	public class Display3DHelper
	{
		private static const ptZero: Point = new Point(0, 0);
		
		public static function centerPerspectiveProjection(object: DisplayObject): void
		{
			try
			{
				var p: PerspectiveProjection = new PerspectiveProjection();
				p.fieldOfView = 90;
				p.focalLength = Math.max(object.width, object.height) / Math.tan(Math.PI / 180 * p.fieldOfView / 2);
				p.projectionCenter = ptZero;
				object.parent.transform.perspectiveProjection = p;
			}
			catch (e: Error)
			{
				trace(e.message);
				trace(e.getStackTrace());
			}
		}
		
		public static function getFocusLength(object: DisplayObject): Number
		{
			if (object && object.parent)
			{
				var p: PerspectiveProjection = object.parent.transform.perspectiveProjection;
				if (p)
					return p.focalLength;
			}
			return Infinity;
		}
	}
}