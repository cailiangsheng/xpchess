package sigma.xpchess.implement.common
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;

	public class ViewTransformerBase
	{
		private var _maxR: Number = Infinity;
		private var _maxZ: Number = Infinity;
		private var _view: DisplayObject;
		private var _enabled: Boolean = false;
		
		public function ViewTransformerBase(view: DisplayObject, maxZ: Number = Infinity, maxR: Number = Infinity)
		{
			_maxR = maxR;
			_maxZ = maxZ;
			_view = view;
			enabled = true;
		}
		
		public function set enabled(value: Boolean): void
		{
			if (_enabled != value)
			{
				_enabled ? unsetup() : setup();
			}
		}
		
		private function setup(): void
		{
			if (!_enabled)
			{
				if (_view.stage)
					onAddedToStage(null);
				else
					_view.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
		}
		
		private function onAddedToStage(e: Event): void
		{
			if (e)
				_view.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_view.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_view.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_view.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			_view.stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, onZoom);
			_view.stage.addEventListener(TransformGestureEvent.GESTURE_ROTATE, onRotate);
			_view.stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
			
			_enabled = true;
		}
		
		private function unsetup(): void
		{
			_view.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_view.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_enabled = false;
		}
		
		private static const UP: uint = 0x001;
		private static const DOWN: uint = 0x002;
		private static const LEFT: uint = 0x004;
		private static const RIGHT: uint = 0x008;
		private static const ROTATION1: uint = 0x0010;
		private static const ROTATION2: uint = 0x0020;
		private static const FORWARD: uint = 0x0040;
		private static const BACKWARD: uint = 0x0080;
		private static const RESET: uint = 0x0100;
		private static const flag: Object = 
			{
				"w": UP,
				"s": DOWN,
				"a": LEFT,
				"d": RIGHT,
				"f": FORWARD,
				"r": BACKWARD,
				"q": ROTATION1,
				"e": ROTATION2,
				"z": RESET
			};
		
		private var action: uint = 0;
		private var actTimes: Number = Number.NaN;
		
		private function onKeyDown(e: KeyboardEvent): void
		{
			actTimes = Number.NaN;
			var key: String = String.fromCharCode(e.charCode).toLowerCase();
			action |= flag[key];
		}
		
		private function onKeyUp(e: KeyboardEvent): void
		{
			var key: String = String.fromCharCode(e.charCode).toLowerCase();
			action &= ~flag[key];
		}
		
		private function onMouseWheel(e: MouseEvent): void
		{
			deltaZ = e.delta * DELTA * 10;
		}
		
		private function onZoom(e: TransformGestureEvent): void
		{
			actTimes = 3;
			deltaZ = (e.scaleX > 1 || e.scaleY > 1 ? -1 : 1) * DELTA * 3;
		}
		
		private function onRotate(e: TransformGestureEvent): void
		{
			actTimes = 1;
			
			if (e.rotation > 0)
				action |= ROTATION1;
			else if (e.rotation < 0)
				action |= ROTATION2;
		}
		
		private function onSwipe(e: TransformGestureEvent): void
		{
			actTimes = 10;
			
			if (e.offsetX > 0)
				action |= RIGHT;
			
			if (e.offsetX < 0)
				action |= LEFT;
			
			if (e.offsetY > 0)
				action |= UP;
			
			if (e.offsetY < 0)
				action |= DOWN;
		}
		
		private var deltaZ: Number = 0;
		
		private static const DELTA: Number = 10;
		
		private function get THETA(): Number
		{
			return isDegree ? DELTA : DELTA / 180 * Math.PI;
		}
		
		public function transform(do3d: Object): void
		{
			if (!_enabled)
				return;
			
			if (action & DOWN && do3d[rotationX] < _maxR)
				do3d[rotationX] += THETA;
			else if (action & UP && do3d[rotationX] > -_maxR)
				do3d[rotationX] -= THETA;
			else if (action & LEFT && do3d[rotationY] < _maxR)
				do3d[rotationY] += THETA;
			else if (action & RIGHT && do3d[rotationY] > -_maxR)
				do3d[rotationY] -= THETA;
			else if (action & ROTATION2 && do3d[rotationZ] < _maxR)
				do3d[rotationZ] += THETA;
			else if (action & ROTATION1 && do3d[rotationZ] > -_maxR)
				do3d[rotationZ] -= THETA;
			else if (action & BACKWARD && do3d.z < _maxZ)
				do3d.z += DELTA;
			else if (action & FORWARD && do3d.z > -_maxZ)
				do3d.z -= DELTA;
			else if (action & RESET)
				do3d[rotationX] = do3d[rotationY] = do3d[rotationZ] = do3d.z = 0;
			
			var z: Number = do3d.z + deltaZ;
			if (z < _maxZ && z > -_maxZ)
			{
				do3d.z = z;
				deltaZ = 0;
			}
			
			if (!isNaN(actTimes))
			{
				if (actTimes > 0)
				{
					actTimes--;
				}
				else
				{
					actTimes = Number.NaN;
					action = 0;
				}
			}
		}
		
		protected function get isDegree(): Boolean
		{
			return false;
		}
		
		protected function get rotationX(): String
		{
			return "rotationX";
		}
		
		protected function get rotationY(): String
		{
			return "rotationY";
		}
		
		protected function get rotationZ(): String
		{
			return "rotationZ";
		}
	}
}