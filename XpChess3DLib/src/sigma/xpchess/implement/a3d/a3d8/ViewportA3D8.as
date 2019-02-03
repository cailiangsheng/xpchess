package sigma.xpchess.implement.a3d.a3d8
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.events.Event;
	
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.View;
	
	import sigma.xpchess.implement.common.IViewport;
	
	internal class ViewportA3D8 implements IViewport
	{
		private var _view: View;
		private var _scene: Object3D;
		private var _camera: Camera3D;
		
		private var _stage3D: Stage3D;
		
		public function init(container: Sprite): void
		{
			_scene = new Object3D();
			
			_camera = new Camera3D(0.1, 10000);
			_camera.z = -1000;
			_scene.addChild(_camera);
			
			_view = new View(300, 400);
			_view.hideLogo();
			_camera.view = _view;
			container.addChild(_view);
			
			if (container.stage)
			{
				initStage3D(container.stage);
			}
			else
			{
				container.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
		}
		
		//---------------------------------------------------------------------
		private function onAddedToStage(e: Event): void
		{
			var container: DisplayObject = e.target as DisplayObject;
			container.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			initStage3D(container.stage);
		}
		
		private function initStage3D(stage: Stage): void
		{
			_stage3D = stage.stage3Ds[0];
			_stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			_stage3D.requestContext3D();
		}
		
		private function onContextCreate(e: Event): void
		{
			for each (var resource: Resource in _scene.getResources(true))
			{
				resource.upload(_stage3D.context3D);
			}
		}
		
		//---------------------------------------------------------------------
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
			if (_stage3D)
				_camera.render(_stage3D);
		}
		
		public function resize(width: Number, height: Number): void
		{
			_view.width = width;
			_view.height = height;
		}
		
		public function set scale(value: Number): void
		{
		}
	}
}