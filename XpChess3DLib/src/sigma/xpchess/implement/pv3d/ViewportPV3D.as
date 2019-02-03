package sigma.xpchess.implement.pv3d
{
	import flash.display.Sprite;
	
	import org.papervision3d.objects.DisplayObject3D;
	
	import sigma.xpchess.implement.common.IViewport;
	
	internal class ViewportPV3D implements IViewport
	{
		private var _view: BasicViewEx;
		
		public function ViewportPV3D()
		{
		}
		
		public function init(container:Sprite):void
		{
			_view = new BasicViewEx();
			_view.camera.z = -1000;
			container.addChild(_view);
		}
		
		public function addChild(obj:Object):void
		{
			var object: DisplayObject3D = obj as DisplayObject3D;
			_view.scene.addChild(object);
		}
		
		public function removeChild(obj:Object):void
		{
			_view.scene.removeChild(obj as DisplayObject3D);
		}
		
		public function render():void
		{
			_view.render();
		}
		
		public function resize(width:Number, height:Number):void
		{
			_view.viewport.viewportWidth = width;
			_view.viewport.viewportHeight = height;
		}
		
		public function set scale(value:Number):void
		{
		}
	}
}

import org.papervision3d.cameras.CameraType;
import org.papervision3d.view.BasicView;

class BasicViewEx extends BasicView
{
	public function BasicViewEx()
	{
		var interactive: Boolean = true;	// why interactive cause crash ?!
		var scaleToStage: Boolean = false;
		var cameraType: String = CameraType.TARGET;
		
		super(640, 480, scaleToStage, interactive, cameraType);
		
		super.startRendering();
	}
	
	public function render(): void
	{
		super.onRenderTick();
	}
}