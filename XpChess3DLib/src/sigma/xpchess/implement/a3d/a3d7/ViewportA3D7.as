package sigma.xpchess.implement.a3d.a3d7
{
	import flash.display.Sprite;
	
	import alternativa.engine3d.containers.KDContainer;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.core.View;
	
	import sigma.xpchess.implement.common.IViewport;
	
	internal class ViewportA3D7 implements IViewport
	{
		private var _view: View;
		private var _scene: Object3DContainer;
		private var _camera: Camera3D;
		
		public function init(container: Sprite): void
		{
			_scene = new KDContainer();
			
			_camera = new Camera3D();
			_camera.z = -1000;
			_scene.addChild(_camera);
			
			_view = new View(300, 400);
			_view.hideLogo();
			_camera.view = _view;
			container.addChild(_view);
		}
		
		public function addChild(obj: Object): void
		{
			_scene.addChild(obj as Object3D);
		}
		
		public function removeChild(obj: Object): void
		{
			_scene.removeChild(obj as Object3D);
		}
		
		public function render(): void
		{
			_camera.render();
		}
		
		public function resize(width: Number, height: Number): void
		{
			_view.width = width;
			_view.height = height;
		}
		
		public function set scale(value: Number): void
		{
			var s: Number = 1 / value;
			var u: Number = -_camera.z;
			var f: Number = u / (s + 1);
			
			var viewSize: Number = NaN;
			if (value < 1)
				viewSize = Math.max(_view.width, _view.height);
			else
				viewSize = Math.min(_view.width, _view.height);
			
			var fov: Number = Math.atan(viewSize / 2 / f) * 2;
			_camera.fov = fov;
		}
	}
}