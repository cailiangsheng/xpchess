package sigma.xpchess.util
{
	public class ChessManData
	{
		public var belong: int;
		public var type: int;
		public var pos: ChessManPos;
		
		public static function parse(obj: Object): ChessManData
		{
			var data: ChessManData = new ChessManData();
			data.belong = obj.color;
			data.type = obj.val;
			data.pos = ChessManPos.parse(obj.pos);
			return data;
		}
		
		public static function parseArray(array: Array): Vector.<ChessManData>
		{
			var datas: Vector.<ChessManData> = new Vector.<ChessManData>();
			for each (var obj: Object in array)
			{
				datas.push(parse(obj));
			}
			return datas;
		}
	}
}