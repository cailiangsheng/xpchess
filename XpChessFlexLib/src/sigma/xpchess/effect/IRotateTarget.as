package sigma.xpchess.effect
{
	import flash.events.IEventDispatcher;

	public interface IRotateTarget
	{
		function set targetRotation(value: Number): void;
		function get targetRotation(): Number;
		function get eventDispatcher(): IEventDispatcher;
	}
}