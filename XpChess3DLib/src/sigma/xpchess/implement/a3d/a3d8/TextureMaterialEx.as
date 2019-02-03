package sigma.xpchess.implement.a3d.a3d8
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.Matrix;
	
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.resources.BitmapTextureResource;
	
	internal class TextureMaterialEx extends TextureMaterial
	{
		private var _resource: BitmapTextureResource;
		
		public function TextureMaterialEx(display: IBitmapDrawable)
		{
			var bitmapData: BitmapData = updateBitmapData(display, null);
			_resource = new BitmapTextureResource(bitmapData);
			
			super(_resource);
			super.alphaThreshold = 0.1;
		}
		
		public function update(display: IBitmapDrawable): Boolean
		{
			try
			{
				_resource.data = updateBitmapData(display, _resource.data);
				return _resource.data != null;
			}
			catch (e: Error)
			{}
			return false;
		}
		
		public function get bitmapData(): BitmapData
		{
			try
			{
				return _resource.data;
			}
			catch (e: Error)
			{}
			return null;
		}
		
		private static function updateBitmapData(display: IBitmapDrawable, bitmapData: BitmapData): BitmapData
		{
			try
			{
				var object: Object = display;
				var fixWidth: int = Math.pow(2, Math.ceil(Math.log(object.width) * Math.LOG2E));
				var fixHeight: int = Math.pow(2, Math.ceil(Math.log(object.height) * Math.LOG2E));
				
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