package sigma.xpchess.implement.common
{
	public interface IChessMan
	{
		function get label(): String;
		function get color(): uint;
		function place(x: Number, y: Number): void;
	}
}