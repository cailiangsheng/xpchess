package sigma.xpchess.implement.stage2d
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import sigma.display.Display3DHelper;
	import sigma.xpchess.implement.common.IViewport;

	internal class ViewportStage2D implements IViewport
	{
		private var _container: Sprite;
		
		public function ViewportStage2D()
		{
		}
		
		public function init(container: Sprite): void
		{
			_container = container;
		}
		
		public function addChild(obj: Object): void
		{
			_container.addChild(obj as DisplayObject);
			
			Display3DHelper.centerPerspectiveProjection(obj as DisplayObject);
		}
		
		public function removeChild(obj: Object): void
		{
			_container.removeChild(obj as DisplayObject);
		}
		
		public function render(): void
		{
			// do nothing
		}
		
		public function resize(width: Number, height: Number): void
		{
			// do nothing
		}
		
		public function set scale(value: Number): void
		{
			_container.scaleX = _container.scaleY = Math.min(value, 1);
		}
	}
}