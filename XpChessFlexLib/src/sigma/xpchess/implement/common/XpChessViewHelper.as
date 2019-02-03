package sigma.xpchess.implement.common
{
	import flash.geom.Point;
	
	import sigma.xpchess.define.IXpChessController;
	import sigma.xpchess.define.IXpChessHandler;
	import sigma.xpchess.define.IXpChessModel;
	import sigma.xpchess.define.IXpChessView;
	import sigma.xpchess.event.XpChessErrorEvent;
	import sigma.xpchess.event.XpChessGameEvent;
	import sigma.xpchess.event.XpChessMoveEvent;
	import sigma.xpchess.util.ChessBoardUtil;
	import sigma.xpchess.util.ChessMan;
	import sigma.xpchess.util.ChessManPos;

	public class XpChessViewHelper implements IXpChessHandler
	{
		private var _view: IXpChessView;
		private var _model: IXpChessModel;
		private var _controller: IXpChessController;
		
		private var _autoRotate: Boolean;
		
		public function XpChessViewHelper(view: IXpChessView, autoRotate: Boolean = false)
		{
			_view = view;
			_autoRotate = autoRotate;
		}
		
		public function init(model: IXpChessModel, controller: IXpChessController): void
		{
			_model = model;
			_model.addEventListener(XpChessGameEvent.START, onStartGame);
			_model.addEventListener(XpChessGameEvent.END, onEndGame);
			_model.addEventListener(XpChessMoveEvent.MOVE, onMoveChessMan);
			_model.addEventListener(XpChessMoveEvent.MOVING, onMoveChessMan);
			_model.addEventListener(XpChessMoveEvent.CANCEL, onMoveChessMan);
			_model.addEventListener(XpChessErrorEvent.ERROR, onError);
			_controller = controller;
			_controller.init(model);
		}
		
		public function get model(): IXpChessModel
		{
			return _model;
		}
		
		public function get controller(): IXpChessController
		{
			return _controller;
		}
		
		//-----------------------------------------------------------
		public function get autoRotate(): Boolean
		{
			return _autoRotate;
		}
		
		public function set autoRotate(value: Boolean): void
		{
			if (_autoRotate != value)
			{
				_autoRotate = value;
			}
			rotate4CurPlayer();
		}
		
		public function rotate4CurPlayer(): void
		{
			if (_autoRotate && _view.gameType)
			{
				var turnDegree: Number = Math.PI * 2 / _view.gameType;
				_view.boardRotation = turnDegree * (_model.curPlayer - 1);
			}
		}
		
		//-----------------------------------------------------------
		public function onStartGame(e: XpChessGameEvent): void
		{
			_view.gameType = e.gameType;
			_view.loadChessMans(_model.chessMans);
			rotate4CurPlayer();
		}
		
		public function onEndGame(e: XpChessGameEvent): void
		{
			alert(e.winner.toString() + "号选手获胜!");
		}
		
		public function onMoveChessMan(e: XpChessMoveEvent): void
		{
			switch (e.type)
			{
				case XpChessMoveEvent.MOVE:
					_view.printMoveFrom(e.from);
					_view.printMoveTo(e.to);
					_view.loadChessMans(_model.chessMans);
					break;
				case XpChessMoveEvent.MOVING:
					_view.printMoveFrom(e.from);
					break;
				case XpChessMoveEvent.CANCEL:
					_view.clearPrint();
					break;
			}
			rotate4CurPlayer();
		}
		
		public function onError(e: XpChessErrorEvent): void
		{
			alert(e.message);
		}
		
		private static const SIZE_x_SIZE: Number = ChessMan.DEFAULT_SIZE * ChessMan.DEFAULT_SIZE;
		
		public function onChessBoardClick(gameType: int, localX: Number, localY: Number): void
		{
			for (var z: int = 0; z < gameType; ++z)
			{
				for (var y: int = 0; y < ChessBoardUtil.VERT_SIZE; ++y)
				{
					for (var x: int = 0; x < ChessBoardUtil.HORI_SIZE; ++x)
					{
						var ptGrid: Point = ChessBoardUtil.getPoint(gameType, z, y, x);
						var dx:Number = localX - ptGrid.x;
						var dy:Number = localY - ptGrid.y;
						if (dx * dx + dy * dy <= SIZE_x_SIZE)
						{
							var pos: ChessManPos = new ChessManPos(x, y, z);
							_controller.onChessBoardClick(pos);
						}
					}
				}
			}
		}
	}
}

import mx.controls.Alert;

function alert(message: String): void
{
	try
	{
		Alert.show(message);
	}
	catch (e: Error)
	{
		trace(message);
	}
}