package sigma.xpchess.util
{
	import flash.utils.Dictionary;

	public class ChessManPool
	{
		private static var _pools: Dictionary;
		
		public static function getPool(key: Object): Vector.<ChessMan>
		{
			if (_pools == null)
				_pools = new Dictionary();
			
			if (_pools[key] == null)
				_pools[key] = new Vector.<ChessMan>();
			
			return _pools[key];
		}
		
		public static function getChessMan(label: String, color: uint): ChessMan
		{
			var key: String = label + color;
			var pool: Vector.<ChessMan> = getPool(key);
			if (pool.length > 0)
				return pool.pop();
			else
				return new ChessMan(label, color);
		}
		
		public static function freeChessMan(man: ChessMan): void
		{
			var key: String = man.label + man.color;
			getPool(key).push(man);
		}
	}
}