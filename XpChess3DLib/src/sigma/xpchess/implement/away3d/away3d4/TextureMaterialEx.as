package sigma.xpchess.implement.away3d.away3d4
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.Matrix;
	
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	
	internal class TextureMaterialEx extends TextureMaterial
	{
		public function TextureMaterialEx(display: IBitmapDrawable)
		{
			var bitmapData: BitmapData = updateBitmapData(display, null);
			var texture: BitmapTexture = new BitmapTexture(bitmapData);
			
			super(texture);
//			super.alphaBlending = true;		//alphaBlending is slower will affect z-sorting
			super.alphaThreshold = 0.1;
		}
		
		public function update(display: IBitmapDrawable): Boolean
		{
			try
			{
				var bmpTexture: BitmapTexture = this.texture as BitmapTexture;
				bmpTexture.bitmapData = updateBitmapData(display, bmpTexture.bitmapData);
				return bmpTexture.bitmapData != null;
			}
			catch (e: Error)
			{}
			return false;
		}
		
		public function get bitmapData(): BitmapData
		{
			try
			{
				var bmpTexture: BitmapTexture = this.texture as BitmapTexture;
				return bmpTexture.bitmapData;
			}
			catch (e: Error)
			{}
			return null;
		}
		
		private function updateBitmapData(display: IBitmapDrawable, bitmapData: BitmapData): BitmapData
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