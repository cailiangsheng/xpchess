package sigma.xpchess.implement.common
{
	import flash.display.Sprite;

	public interface IViewport
	{
		function init(container: Sprite): void;
		function addChild(obj: Object): void;
		function removeChild(obj: Object): void;
		function render(): void;
		function resize(width: Number, height: Number): void;
		function set scale(value: Number): void;
	}
}