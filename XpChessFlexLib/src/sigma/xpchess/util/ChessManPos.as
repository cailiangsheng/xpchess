package sigma.xpchess.util
{
	public class ChessManPos
	{
		public var x: int;
		public var y: int;
		public var z: int;
		
		public function ChessManPos(x: int, y: int, z: int)
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		public function equals(pos: ChessManPos): Boolean
		{
			return pos != null && this.x == pos.x && this.y == pos.y && this.z == pos.z;
		}
		
		public static function parse(obj: Object): ChessManPos
		{
			return new ChessManPos(obj.x, obj.y, obj.color);
		}
		
		public function toObject(): Object
		{
			return {x: x, y: y, color: z};
		}
	}
}