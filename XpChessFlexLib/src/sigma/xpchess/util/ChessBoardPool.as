package sigma.xpchess.util
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	public class ChessBoardPool
	{
		private static var _pools: Dictionary;
		
		public static function getPool(key: Object): Vector.<DisplayObjectContainer>
		{
			if (_pools == null)
				_pools = new Dictionary();
			
			if (_pools[key] == null)
				_pools[key] = new Vector.<DisplayObjectContainer>();
			
			return _pools[key];
		}
		
		public static function getChessBoard(type: int): DisplayObjectContainer
		{
			var pool: Vector.<DisplayObjectContainer> = getPool(type);
			if (pool.length > 0)
				return pool.pop();
			else
				return ChessBoardUtil.getInstance(type);
		}
		
		public static function freeChessBoard(board: DisplayObjectContainer): void
		{
			var key: int = ChessBoardUtil.getType(board);
			getPool(key).push(board);
		}
	}
}