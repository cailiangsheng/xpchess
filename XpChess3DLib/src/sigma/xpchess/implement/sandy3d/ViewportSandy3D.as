package sigma.xpchess.implement.sandy3d
{
	import flash.display.Sprite;
	
	import sandy.core.Scene3D;
	import sandy.core.scenegraph.Camera3D;
	import sandy.core.scenegraph.Group;
	import sandy.core.scenegraph.Node;
	
	import sigma.xpchess.implement.common.IViewport;
	
	internal class ViewportSandy3D implements IViewport
	{
		private var _scene: Scene3D;
		private var _camera: Camera3D;
		
		public function init(container: Sprite): void
		{
			_camera = new Camera3D();
			_camera.z = -1000;
			
			_scene = new Scene3D("myScene", container, _camera, new Group("root"));
		}
		
		public function addChild(obj: Object): void
		{
			_scene.root.addChild(obj as Node);
		}
		
		public function removeChild(obj: Object): void
		{
			_scene.root.removeChildByName((obj as Node).name);
		}
		
		public function render(): void
		{
			_scene.render();
		}
		
		public function resize(width: Number, height: Number): void
		{
			_camera.viewport.width = width;
			_camera.viewport.height = height;
		}
		
		public function set scale(value: Number): void
		{
		}
	}
}