package sigma.xpchess.implement.away3d.away3d4
{
	import flash.display.Sprite;
	
	import away3d.containers.ObjectContainer3D;
	
	import sigma.xpchess.implement.common.IViewport;
	
	internal class ViewportAway3D4 implements IViewport
	{
		private var _view: View3DEx;//View3DProxy;
		
		public function ViewportAway3D4()
		{
			// 1.change -app.xml settings:
			// <renderMode>direct</renderMode>			<!-- Stage3D required -->
			// <depthAndStencil>true</depthAndStencil>	<!-- correct Z-Sorting -->
			
			// 2.fix mobile dpi scale problem for coordinate system when mouse interacting
			// 3.fix BUG for Lost Context3D
			// see class View3DEx
		}
		
		public function init(container:Sprite):void
		{
			_view = new View3DEx();//View3DProxy();
			_view.camera.z = -1000;
			
			container.addChild(_view);
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
			_view.width = width;
			_view.height = height;
		}
		
		public function set scale(value:Number):void
		{
		}
	}
}

import flash.display.Sprite;
import flash.events.Event;

import mx.core.FlexGlobals;

import away3d.cameras.Camera3D;
import away3d.containers.ObjectContainer3D;
import away3d.containers.Scene3D;
import away3d.containers.View3D;
import away3d.core.managers.Stage3DProxy;
import away3d.core.render.RendererBase;
import away3d.events.Stage3DEvent;

class View3DEx extends View3D
{
	public function View3DEx(scene : Scene3D = null, camera : Camera3D = null, renderer : RendererBase = null, forceSoftware:Boolean = false)
	{
		super(scene, camera, renderer, forceSoftware);
		
		this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	// Fix BUG: Lost Context3D when FullScreen or OrientationChange
	private function onAddedToStage(e: Event): void
	{
		this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
		// when addedToStage, we will get stage3DProxy instance
		this.stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_RECREATED, onContextRecreated);
	}
	
	private static function onContextRecreated(e: Stage3DEvent): void
	{
		(e.target as Stage3DProxy).dispatchEvent(new Stage3DEvent(Stage3DEvent.CONTEXT3D_CREATED));
	}
	
	// DPI correction for MouseEvent3D
	override public function get mouseX():Number
	{
		return super.mouseX * dpiScale;
	}
	
	override public function get mouseY():Number
	{
		return super.mouseY * dpiScale;
	}
	
	// DPI correction for Viewport resize
	override public function set width(value:Number):void
	{
		super.width = value * dpiScale;
	}
	
	override public function set height(value:Number):void
	{
		super.height = value * dpiScale;
	}
	
	private static var dpiScale: Number = getDpiScale();
	
	private static function getDpiScale(): Number
	{
		try
		{
			return FlexGlobals.topLevelApplication.runtimeDPI / FlexGlobals.topLevelApplication.applicationDPI;
		}
		catch (e: Error)
		{}
		return 1;
	}
}

class View3DProxy extends Sprite
{
	private var _activeView: View3D;
	
	public function View3DProxy()
	{
		_activeView = new View3DEx();
		this.addChild(_activeView);
	}
	
	public function recreate(): void
	{
		var oldView: View3D = _activeView;
		var newView: View3D = new View3DEx();
		newView.camera.z = oldView.camera.z;
		newView.width = oldView.width;
		newView.height = oldView.height;
		for (var i: int = oldView.scene.numChildren - 1; i >= 0; i--)
		{
			var child: ObjectContainer3D = oldView.scene.getChildAt(i);
			oldView.scene.removeChild(child);
			newView.scene.addChild(child);
		}
		
		this.removeChild(oldView);
		oldView.dispose();
		trace(oldView, "disposed");
		
		this.addChild(newView);
		_activeView = newView;
		trace(newView, "created");
	}
	
	// proxy functions
	public function get camera(): Camera3D
	{
		return _activeView.camera;
	}
	
	public function get scene(): Scene3D
	{
		return _activeView.scene;
	}
	
	public function render(): void
	{
		_activeView.render();
	}
	
	override public function set width(value: Number): void
	{
		_activeView.width = value;
	}
	
	override public function set height(value: Number): void
	{
		_activeView.height = value;
	}
}