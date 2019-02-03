package sigma.xpchess.implement.common
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sigma.xpchess.define.IXpChessController;
	import sigma.xpchess.define.IXpChessModel;
	import sigma.xpchess.define.IXpChessView;
	import sigma.xpchess.event.XpChessBoardEvent;
	import sigma.xpchess.event.XpChessErrorEvent;
	import sigma.xpchess.util.ChessBoardUtil;
	import sigma.xpchess.util.ChessManData;
	import sigma.xpchess.util.ChessManPos;
	import sigma.xpchess.util.ChessManUtil;
	import sigma.xpchess.implement.common.XpChessViewHelper;

	public class XpChessViewBase extends Sprite implements IXpChessView
	{
		private var _view3d: Boolean = false;
		
		private var _chessPool: ChessPool;
		private var _viewport: IViewport;
		
		private var _helper: XpChessViewHelper = null;
		protected var _transformer: ViewTransformerBase;
		
		public function XpChessViewBase(chessPool: ChessPool, viewport: IViewport, transformer: ViewTransformerBase, autoRotate: Boolean = false)
		{
			super();
			
			_chessPool = chessPool;
			
			_viewport = viewport;
			setupView();
			
			_transformer = transformer;
			_helper = new XpChessViewHelper(this, autoRotate);
		}
		
		public function get stage3d(): Boolean
		{
			return false;
		}
		
		public function get view3d(): Boolean
		{
			return _view3d;
		}
		
		public function set view3d(value: Boolean): void
		{
			if (_view3d != value)
			{
				_view3d = value;
				
				_transformer.enabled = value;
			}
		}
		
		//--------------------------------------------------------------
		protected var chessBoard: IChessBoard = null;
		
		private function setupChessBoard(type: int): void
		{
			if (chessBoard)
			{
				clearChessMans();
				_viewport.removeChild(chessBoard);//_scene.removeChild(chessBoard);
				_chessPool.freeChessBoard(chessBoard);
				chessBoard = null;
			}
			
			var newChessBoard: IChessBoard = _chessPool.getChessBoard(type);
			if (newChessBoard)
			{
				_viewport.addChild(newChessBoard);
				chessBoard = newChessBoard;
				chessBoard.reset();
				updateDisplay();
				
				if (!chessBoard.eventDispatcher.hasEventListener(XpChessBoardEvent.CLICK_BOARD))
					chessBoard.eventDispatcher.addEventListener(XpChessBoardEvent.CLICK_BOARD, onXpChessBoardClick);
			}
		}
		
		private function onXpChessBoardClick(e: XpChessBoardEvent): void
		{
			_helper.onChessBoardClick(e.gameType, e.localX, e.localY);
		}
		
		private function setupView(): void
		{
			_viewport.init(this);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e: Event): void
		{
			_transformer.transform(chessBoard);
			_viewport.render();
		}
		
		protected function updateDisplay(): void
		{
			if (chessBoard)
				chessBoard.boardRotation = _boardRotation;
			
			if (this.parent)
				this.parent.dispatchEvent(new Event(Event.RESIZE, true));
		}
		
		
		//--------------------------------------------------------------
		public function init(model: IXpChessModel, controller: IXpChessController): void
		{
			_helper.init(model, controller);
		}
		
		public function clearChessMans(): void
		{
			if (chessBoard)
				chessBoard.clearChessMans();
		}
		
		public function loadChessMans(chessMans: Vector.<ChessManData>): void
		{
			clearChessMans();
			for each (var man: ChessManData in chessMans)
			{
				var manColor: uint = ChessManUtil.getColor(man.belong);
				var manLabel: String = ChessManUtil.getLabel(man.type, manColor == ChessManUtil.RED);
				var manPoint: Point = ChessBoardUtil.getPoint(gameType, man.pos.z, man.pos.y, man.pos.x);
				var chessMan: IChessMan = _chessPool.getChessMan(manLabel, manColor);
				chessMan.place(manPoint.x, manPoint.y);
				chessBoard.addChessMan(chessMan);
			}
		}
		
		private function get chessBoardSize(): Point
		{
			var size: Point = new Point();
			if (chessBoard != null)
			{
				var bound: Rectangle = ChessBoardUtil.getBound(gameType);
				size.x = bound.width;
				size.y = bound.height;
			}
			else
			{
				size.x = size.y = 0;
			}
			return size;
		}
		
		public function onContainerResize(containerWidth: Number, containerHeight: Number): void
		{
			_viewport.resize(containerWidth, containerHeight);
			
			var size: Point = this.chessBoardSize;
			var sx: Number = containerWidth / size.x;
			var sy: Number = containerHeight / size.y;
			_viewport.scale = Math.min(sx, sy, 1);
		}
		
		//--------------------------------------------------------------
		protected var _boardRotation: Number = 0;
		
		public function get autoRotate(): Boolean
		{
			return _helper.autoRotate;
		}
		
		public function set autoRotate(value: Boolean): void
		{
			_helper.autoRotate = value;
		}
		
		public function get boardRotation(): Number
		{
			return _boardRotation;
		}
		
		public function set boardRotation(value: Number): void
		{
			_boardRotation = value;
			updateDisplay();
		}
		
		public function get gameType(): int
		{
			return chessBoard ? chessBoard.boardType : -1;
		}
		
		public function set gameType(value: int): void
		{
			if (gameType != value)
			{
				if (ChessBoardUtil.isValidType(value))
					setupChessBoard(value);
				else
					_helper.model.dispatchEvent(new XpChessErrorEvent(XpChessErrorEvent.ERROR, "不支持的棋盘类型: " + value));
			}
		}
		
		public function get autoResize(): Boolean
		{
			return false;
		}
		
		public function set autoResize(value: Boolean): void
		{
		}
		
		public function printMoveFrom(pos: ChessManPos): void
		{
			chessBoard.clearPrint();
			chessBoard.printMove(pos, 0xff00ff);
		}
		
		public function printMoveTo(pos: ChessManPos): void
		{
			chessBoard.printMove(pos, 0x009900);
		}
		
		public function clearPrint(): void
		{
			chessBoard.clearPrint();
		}
	}
}