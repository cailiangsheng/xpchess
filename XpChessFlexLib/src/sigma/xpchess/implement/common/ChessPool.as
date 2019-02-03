package sigma.xpchess.implement.common
{
	import flash.utils.Dictionary;

	public class ChessPool
	{
		private static var _chessBoardPools: Dictionary;
		private static var _chessManPools: Dictionary;
		
		private static function getChessBoardPool(ChessBoard: Class): ChessBoardPool
		{
			if (_chessBoardPools == null)
				_chessBoardPools = new Dictionary();
			
			if (_chessBoardPools[ChessBoard] == null)
			{
				_chessBoardPools[ChessBoard] = new ChessBoardPool(ChessBoard);
			}
			return _chessBoardPools[ChessBoard];
		}
		
		private static function getChessManPool(ChessMan: Class): ChessManPool
		{
			if (_chessManPools == null)
				_chessManPools = new Dictionary();
			
			if (_chessManPools[ChessMan] == null)
			{
				_chessManPools[ChessMan] = new ChessManPool(ChessMan);
			}
			return _chessManPools[ChessMan];
		}
		
		public static function freeChessBoard(board: IChessBoard): void
		{
			getChessBoardPool(Object(board).constructor).freeChessBoard(board);
		}
		
		public static function freeChessMan(man: IChessMan): void
		{
			getChessManPool(Object(man).constructor).freeChessMan(man);
		}
		
		//---------------------------------------------------------------------
		private var _chessBoardPool: ChessBoardPool;
		private var _chessManPool: ChessManPool;
		
		public function ChessPool(ChessBoard: Class, ChessMan: Class)
		{
			_chessBoardPool = getChessBoardPool(ChessBoard);
			_chessManPool = getChessManPool(ChessMan);
		}
		
		public function getChessBoard(type: int): IChessBoard
		{
			return _chessBoardPool.getChessBoard(type);
		}
		
		public function freeChessBoard(board: IChessBoard): void
		{
			_chessBoardPool.freeChessBoard(board);
		}
		
		public function getChessMan(label: String, color: uint): IChessMan
		{
			return _chessManPool.getChessMan(label, color);
		}
		
		public function freeChessMan(man: IChessMan): void
		{
			_chessManPool.freeChessMan(man);
		}
	}
}

import flash.utils.Dictionary;

import sigma.xpchess.implement.common.IChessBoard;
import sigma.xpchess.implement.common.IChessMan;

class ChessBoardPool
{
	private var _pools: Dictionary;
	private var _ChessBoard: Class;
	
	public function ChessBoardPool(ChessBoard: Class)
	{
		_ChessBoard = ChessBoard;
	}
	
	private function getPool(key: Object): Vector.<IChessBoard>
	{
		if (_pools == null)
			_pools = new Dictionary();
		
		if (_pools[key] == null)
			_pools[key] = new Vector.<IChessBoard>();
		
		return _pools[key];
	}
	
	public function getChessBoard(type: int): IChessBoard
	{
		var key: Object = type;
		var pool: Vector.<IChessBoard> = getPool(key);
		if (pool.length > 0)
			return pool.pop();
		else
			return new _ChessBoard(type);
	}
	
	public function freeChessBoard(board: IChessBoard): void
	{
		var key: Object = board.boardType;
		getPool(key).push(board);
	}
}

class ChessManPool
{
	private var _pools: Dictionary;
	private var _ChessMan: Class;
	
	public function ChessManPool(ChessMan: Class)
	{
		_ChessMan = ChessMan;
	}
	
	private function getPool(key: Object): Vector.<IChessMan>
	{
		if (_pools == null)
			_pools = new Dictionary();
		
		if (_pools[key] == null)
			_pools[key] = new Vector.<IChessMan>();
		
		return _pools[key];
	}
	
	public function getChessMan(label: String, color: uint): IChessMan
	{
		var key: String = label + color;
		var pool: Vector.<IChessMan> = getPool(key);
		if (pool.length > 0)
			return pool.pop();
		else
			return new _ChessMan(label, color);
	}
	
	public function freeChessMan(man: IChessMan): void
	{
		var key: String = man.label + man.color;
		getPool(key).push(man);
	}
}