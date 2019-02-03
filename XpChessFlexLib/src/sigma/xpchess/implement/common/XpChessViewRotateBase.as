package sigma.xpchess.implement.common
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.core.IUIComponent;
	import mx.events.ResizeEvent;
	
	import sigma.xpchess.effect.IRotateTarget;
	import sigma.xpchess.effect.Rotate;

	public class XpChessViewRotateBase extends XpChessViewBase implements IRotateTarget
	{
		protected var _rotator: Rotate = new Rotate();
		
		public function XpChessViewRotateBase(chessPool: ChessPool, viewport: IViewport, transformer: ViewTransformerBase, autoRotate: Boolean = false)
		{
			super(chessPool, viewport, transformer, autoRotate);
		}
		
		public function set targetRotation(value: Number): void
		{
			super.chessBoard.boardRotation = value;
		}
		
		public function get targetRotation(): Number
		{
			return super.chessBoard.boardRotation;
		}
		
		public function get eventDispatcher(): IEventDispatcher
		{
			return this;
		}
		
		public override function set boardRotation(r: Number): void
		{
			_rotator.end();
			_rotator.angleFrom = super._boardRotation * 180 / Math.PI;
			_rotator.angleTo = r * 180 / Math.PI;
			
			super.boardRotation = r;
		}
		
		protected override function updateDisplay(): void
		{
			if (chessBoard != null)
			{
				_rotator.target = this;
				_rotator.play();
			}

			if (this.parent)
			{
				if (this.parent is IUIComponent)
					this.parent.dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE, true));
				else
					this.parent.dispatchEvent(new Event(Event.RESIZE, true));
			}
		}
	}
}