package sigma.xpchess.implement.pv3d
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.Matrix;
	
	import org.papervision3d.materials.BitmapMaterial;
	
	internal class BitmapMaterialEx extends BitmapMaterial
	{
		public function BitmapMaterialEx(display: IBitmapDrawable)
		{
			var bitmapData: BitmapData = updateBitmapData(display, null);
			super(bitmapData);
//			super.alphaBlending = true;		//alphaBlending is slower will affect z-sorting
//			super.alphaThreshold = 0.1;
		}
		
		public function update(display: IBitmapDrawable): Boolean
		{
			try
			{
				super.bitmap = updateBitmapData(display, super.bitmap);
				return super.bitmap != null;
			}
			catch (e: Error)
			{}
			return false;
		}
		
		public function get bitmapData(): BitmapData
		{
			return super.bitmap;
		}
		
		private static function updateBitmapData(display: IBitmapDrawable, bitmapData: BitmapData): BitmapData
		{
			try
			{
				var object: Object = display;
				var fixWidth: int = object.width;
				var fixHeight: int = object.height;
				
				var matrix: Matrix = new Matrix();
				var displayObejct: DisplayObject = object as DisplayObject;
				if (displayObejct)
				{
					matrix.translate(displayObejct.x, displayObejct.y);
				}
				matrix.scale(fixWidth / object.width, fixHeight / object.height);
				
				if (bitmapData == null || bitmapData.width != fixWidth || bitmapData.height != fixHeight)
				{
					bitmapData = new BitmapData(fixWidth, fixHeight, true, 0);
				}
				bitmapData.draw(display, matrix);
				return bitmapData;
			}
			catch (e: Error)
			{}
			
			return null;
		}
	}
}