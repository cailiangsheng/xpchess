package sigma.xpchess.util
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class ChessBoardUtil
	{
		public static const HORI_SIZE: int = 9;
		public static const VERT_SIZE: int = 5;
		
		public static function isValidType(boardType: int): Boolean
		{
			return boardType >= 2 && boardType <= 4;
		}
		
		public static function getInstance(boardType: int): DisplayObjectContainer
		{
			switch (boardType)
			{
				case 2:
					return new ChessBoard2();
				case 3:
					return new ChessBoard3();
				case 4:
					return new ChessBoard4();
			}
			return null;
		}
		
		public static function getType(board: DisplayObjectContainer): int
		{
			if (board != null)
			{
				if (board is ChessBoard2)
					return 2;
				else if (board is ChessBoard3)
					return 3;
				else if (board is ChessBoard4)
					return 4;
			}
			return -1;
		}
		
		//-----------------------------------------------------------
		private static function getGrid(type: int): Array
		{
			switch (type)
			{
				case 2:
					return ChessBoard2.grid;
				case 3:
					return ChessBoard3.grid;
				case 4:
					return ChessBoard4.grid;
			}
			return null;
		}
		
		public static function getPoint(type: int, z: int, y: int, x: int): Point
		{
			var gridPos: Object = getGrid(type)[z][y][x];
			return new Point(gridPos.x, gridPos.y);
		}
		
		public static function getTheta(type: int, z: int, y: int, x: int): Number
		{
			var yAbove: int = y < VERT_SIZE - 1 ? y + 1 : y;
			var yBelow: int = y > 0 ? y - 1: 0;
			var ptAbove: Point = getPoint(type, 1, yAbove, x);
			var ptBelow: Point = getPoint(type, 1, yBelow, x);
			var dx: Number = ptAbove.x - ptBelow.x;
			var dy: Number = ptAbove.y - ptBelow.y;
			var len: Number = Math.sqrt(dx * dx + dy * dy);
			var thetaLocal: Number = Math.asin(dx / len);
			var thetaGlobal: Number = (z - 1) * (Math.PI * 2 / type);
			return thetaLocal - thetaGlobal;
		}
		
		//-----------------------------------------------------------
		public static function getCorner(type: int): Array
		{
			switch (type)
			{
				case 2:
					return ChessBoard2.corner;
				case 3:
					return ChessBoard3.corner;
				case 4:
					return ChessBoard4.corner;
			}
			return null;
		}
		
		public static function getBound(type: int, matrix: Matrix = null): Rectangle
		{
			var topLeft: Point = new Point(Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY);
			var bottomRight: Point = new Point(Number.NEGATIVE_INFINITY, Number.NEGATIVE_INFINITY);
			var corner: Array = getCorner(type);
			var ptOld: Point = new Point();
			for each (var pos: Object in corner)
			{
				ptOld.x = pos.x;
				ptOld.y = pos.y;
				var ptNew: Point = matrix ? matrix.transformPoint(ptOld) : ptOld;
				topLeft.x = Math.min(topLeft.x, ptNew.x);
				topLeft.y = Math.min(topLeft.y, ptNew.y);
				bottomRight.x = Math.max(bottomRight.x, ptNew.x);
				bottomRight.y = Math.max(bottomRight.y, ptNew.y);
			}
			var bound: Rectangle = new Rectangle();
			bound.topLeft = topLeft;
			bound.bottomRight = bottomRight;
			return bound;
		}
	}
}