package sigma.xpchess.implement.away3d.away3d3
{
	import flash.display.Sprite;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.render.Renderer;
	
	import sigma.xpchess.implement.common.IViewport;
	
	internal class ViewportAway3D3 implements IViewport
	{
		private var _view: View3D;
		
		public function ViewportAway3D3()
		{
		}
		
		public function init(container:Sprite):void
		{
			_view = new View3D();
			container.addChild(_view);
			
			_view.renderer = Renderer.CORRECT_Z_ORDER;
		}
		
		public function addChild(obj:Object):void
		{
			_view.scene.addChild(obj as ObjectContainer3D);
		}
		
		public function removeChild(obj:Object):void
		{
			_view.scene.removeChild(obj as ObjectContainer3D);
		}
		
		public function render():void
		{
			_view.render();
		}
		
		public function resize(width:Number, height:Number):void
		{
			_view.x = width / 2;
			_view.y = height / 2;
		}
		
		public function set scale(value:Number):void
		{
		}
	}
}