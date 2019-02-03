package sigma.xpchess.define
{
	import mx.core.IVisualElement;

	public interface IXpChessBox extends IXpChessContent, IVisualElement
	{
		function get autoResize(): Boolean;
		function set autoResize(value: Boolean): void;
	}
}