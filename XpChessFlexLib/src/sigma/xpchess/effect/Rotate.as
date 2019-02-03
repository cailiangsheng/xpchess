package sigma.xpchess.effect
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class Rotate extends EventDispatcher
	{
		protected var _least: Boolean = true;
		protected var _anti: Boolean = false;
		protected var _running: Boolean = false;
		protected var _target: IRotateTarget = null;
		protected var _from: Number;
		protected var _to: Number;
		
		public function Rotate(least: Boolean = true, anti: Boolean = false)
		{
			_least = least;
			_anti = anti;
		}
		
		private function get interval(): int
		{
			var delta: int = (_to - _from) / 16;
			if (delta == 0)
				return _to > _from ? 1 : -1;
			else
				return delta;
		}
		
		protected function onEnterFrame(e: Event): void
		{
			if (_target)
			{
				_target.targetRotation += interval;
				
				if (interval > 0 && _target.targetRotation >= _to || 
					interval < 0 && _target.targetRotation <= _to)
					end();
			}
		}
		
		public function set target(t: IRotateTarget): void
		{
			end();
			_target = t;
		}
		
		public function set angleFrom(a: Number): void
		{
			end();
			_from = a;
		}
		
		public function set angleTo(a: Number): void
		{
			end();
			_to = a;
		}
		
		protected function checkLeastAngle(): void
		{
			_from = (_from + 360) % 360;
			_to = (_to + 360) % 360;
			
			var theta: Number = _to - _from;
			if (theta > 180)
			{
				_to -= 360;
			}
			else if (theta < -180)
			{
				_from -= 360;
			}
			else if (theta == 180)
			{
				if (_anti)
					_to -= 360;
			}
			else if (theta == -180)
			{
				if (!_anti)
					_from -= 360;
			}
		}
		
		protected function checkClockwise(): void
		{
			_from = (_from + 360) % 360;
			_to = (_to + 360) % 360;
			
			if (_anti)
			{
				if (_from < _to)
					_from += 360;
			}
			else
			{
				if (_to < _from)
					_to += 360;
			}
		}
		
		public function play(): void
		{
			if (_least)
				checkLeastAngle();
			else
				checkClockwise();
			
			if (_target && _from != _to && !isNaN(_from) && !isNaN(_to))
			{
				_running = true;
				_target.targetRotation = _from;
				_target.eventDispatcher.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		public function end(): void
		{
			if (_target && _running)
			{
				_target.eventDispatcher.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_target.targetRotation = _to;
				_from = _to = NaN;
				_running = false;
				_target = null;
			}
		}
	}
}