package sigma.xpchess.implement.stage2d
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import sigma.xpchess.event.XpChessBoardEvent;
	import sigma.xpchess.implement.common.IChessBoard;
	import sigma.xpchess.implement.common.IChessMan;
	import sigma.xpchess.util.ChessBoardUtil;
	import sigma.xpchess.util.ChessMan;
	import sigma.xpchess.util.ChessManPool;
	import sigma.xpchess.util.ChessManPos;

	internal class ChessBoard extends Sprite implements IChessBoard
	{
		private var _boardType: int = -1;
		private var _printLayer: Shape;
		private var _mansLayer: DisplayObjectContainer;
		protected var _boardRotation: Number = 0;
		
		public function ChessBoard(boardType: int)
		{
			init(boardType);
		}
		
		public function get eventDispatcher(): IEventDispatcher
		{
			return this;
		}
		
		public function get boardType(): int
		{
			return _boardType;
		}
		
		public function reset(): void
		{
			_boardRotation = 0;
			this.transform.matrix = null;
			this.transform.matrix3D = null;
			this.printGraphics.clear();
		}
		
		//--------------------------------------------------------------
		public function clearChessMans(): void
		{
			for (var i:int = _mansLayer.numChildren - 1; i >= 0; --i)
			{
				var chessMan: ChessMan = _mansLayer.getChildAt(i) as ChessMan;
				if (chessMan != null)
				{
					_mansLayer.removeChildAt(i);
					chessMan.transform.matrix = null;
					ChessManPool.freeChessMan(chessMan);
				}
			}
			topMostPrintLayer();
		}
		
		public function addChessMan(man: IChessMan): void
		{
			var manObject: DisplayObject = man as DisplayObject;
			manObject.rotationZ = 0;
			_mansLayer.addChild(manObject);
			topMostPrintLayer();
		}
		
		//--------------------------------------------------------------
		private function init(boardType: int): void
		{
			//add chessBoard
			var boardSprite: Sprite = ChessBoardUtil.getInstance(boardType) as Sprite;
			if (boardSprite)
			{
				_boardType = boardType;
				setupBoard(boardSprite);
			}
			else
				throw new Error("Invalid ChessBoard Type value");
			
			//add chessMansLayer
			_mansLayer = new Sprite();
			_mansLayer.mouseEnabled = false;
			_mansLayer.mouseChildren = false;
			this.addChild(_mansLayer);
			
			//add printLayer
			_printLayer = new Shape();
			this.addChild(_printLayer);
			
			reset();
		}
		
		private function setupBoard(boardSprite: DisplayObjectContainer): void
		{
			this.addChild(boardSprite);
			boardSprite.mouseEnabled = true;
			boardSprite.mouseChildren = false;
			boardSprite.addEventListener(MouseEvent.CLICK, onChessBoardClick);
		}
		
		private function onChessBoardClick(e: MouseEvent): void
		{
			this.dispatchEvent(new XpChessBoardEvent(XpChessBoardEvent.CLICK_BOARD, boardType, e.localX, e.localY));
		}
		
		//--------------------------------------------------------------
		public function set boardRotation(value: Number): void
		{
			if (_boardRotation != value)
			{
				var manRotation: Number = manAngle(value);
				for (var i: int = 0, n: int = _mansLayer.numChildren; i < n; i++)
				{
					var man: ChessMan = _mansLayer.getChildAt(i) as ChessMan;
					if (man)
						man.rotationZ = manRotation;
				}

				var mat: Matrix3D = null;
				if (this.transform.matrix3D)
					mat = this.transform.matrix3D.clone();
				else
					mat = new Matrix3D();
				
				var degrees: Number = value - _boardRotation;
				mat.prependRotation(degrees, Vector3D.Z_AXIS);
				this.transform.matrix3D = mat;
				
				_boardRotation = value;
			}
		}
		
		public function get boardRotation(): Number
		{
			return _boardRotation;
		}
		
		private static function manAngle(boardAngle: Number): Number
		{
			return -boardAngle;
		}
		
		//--------------------------------------------------------------
		private function topMostPrintLayer(): void
		{
			this.setChildIndex(_printLayer, this.numChildren - 1);
		}
		
		public function get printGraphics(): Graphics
		{
			return _printLayer.graphics;
		}
		
		private static const SIZE_x_2: Number = ChessMan.DEFAULT_SIZE * 2;
		
		public function clearPrint(): void
		{
			printGraphics.clear();
		}
		
		public function printMove(pos: ChessManPos, color: uint): void
		{
			var ptGrid: Point = ChessBoardUtil.getPoint(boardType, pos.z, pos.y, pos.x);
			printGraphics.lineStyle(1, color);
//			printMoveRectSimple(ptGrid);
//			printMoveRectStraight(ptGrid);
			printMoveRectAlong(ptGrid, pos);
		}
		
		private function printMoveRectSimple(ptGrid: Point): void
		{
			printGraphics.drawRect(
				ptGrid.x - ChessMan.DEFAULT_SIZE, 
				ptGrid.y - ChessMan.DEFAULT_SIZE, 
				SIZE_x_2, SIZE_x_2);
		}
		
		private function printMoveRectStraight(ptGrid: Point): void
		{
			printMoveRectImpl(ptGrid, -_boardRotation);
		}
		
		private function printMoveRectAlong(ptGrid: Point, pos: ChessManPos): void
		{
			var theta: Number = ChessBoardUtil.getTheta(boardType, pos.z, pos.y, pos.x);
			printMoveRectImpl(ptGrid, theta);
		}
		
		private function printMoveRectImpl(ptGrid: Point, theta: Number): void
		{
			var matrix: Matrix = new Matrix();
			matrix.translate(-ptGrid.x, -ptGrid.y);
			matrix.rotate(theta);
			matrix.translate(ptGrid.x, ptGrid.y);
			var command: Vector.<int> = Vector.<int>([
				GraphicsPathCommand.MOVE_TO,
				GraphicsPathCommand.LINE_TO,
				GraphicsPathCommand.LINE_TO,
				GraphicsPathCommand.LINE_TO,
				GraphicsPathCommand.LINE_TO
			]);
			var data: Vector.<Number> = Vector.<Number>([
				ptGrid.x - ChessMan.DEFAULT_SIZE, ptGrid.y - ChessMan.DEFAULT_SIZE,
				ptGrid.x - ChessMan.DEFAULT_SIZE + SIZE_x_2, ptGrid.y - ChessMan.DEFAULT_SIZE,
				ptGrid.x - ChessMan.DEFAULT_SIZE + SIZE_x_2, ptGrid.y - ChessMan.DEFAULT_SIZE + SIZE_x_2,
				ptGrid.x - ChessMan.DEFAULT_SIZE, ptGrid.y - ChessMan.DEFAULT_SIZE + SIZE_x_2,
				ptGrid.x - ChessMan.DEFAULT_SIZE, ptGrid.y - ChessMan.DEFAULT_SIZE
			]);
			var pt: Point = new Point();
			for (var i: int = 0; i < data.length; i += 2)
			{
				pt.x = data[i];
				pt.y = data[i + 1];
				pt = matrix.transformPoint(pt);
				data[i] = pt.x;
				data[i + 1] = pt.y;
			}
			printGraphics.drawPath(command, data);
		}
	}
}