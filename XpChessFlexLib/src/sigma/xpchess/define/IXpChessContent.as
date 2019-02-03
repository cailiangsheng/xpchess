package sigma.xpchess.define
{
	public interface IXpChessContent
	{
		function get stage3d(): Boolean;
		function get view3d(): Boolean;
		function set view3d(value: Boolean): void;
		function get autoRotate(): Boolean;
		function set autoRotate(value: Boolean): void;
		function get boardRotation(): Number;
		function set boardRotation(value: Number): void;
		function get gameType(): int;
		function set gameType(value: int): void;
	}
}