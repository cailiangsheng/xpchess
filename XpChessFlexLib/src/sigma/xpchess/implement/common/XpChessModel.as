package sigma.xpchess.implement.common
{
	import cmodule.XpChessFlexLib.CLibInit;
	
	import flash.events.EventDispatcher;
	
	import sigma.xpchess.define.IXpChessModel;
	import sigma.xpchess.event.XpChessErrorEvent;
	import sigma.xpchess.event.XpChessGameEvent;
	import sigma.xpchess.event.XpChessMoveEvent;
	import sigma.xpchess.util.ChessMan;
	import sigma.xpchess.util.ChessManData;
	import sigma.xpchess.util.ChessManPos;
	
	public class XpChessModel extends EventDispatcher implements IXpChessModel
	{
		private static var _cfun: * = null;
		private var _main: * = null;
		private var _from: ChessManPos = null;
		
		public function XpChessModel()
		{
			super();
		}
		
		public function get cfun(): Object
		{
			if (!_cfun)
			{
				var libInit: CLibInit = new CLibInit();
				_cfun = libInit.init();
			}
			return _cfun;
		}
		
		public function get main(): Object
		{
			if (!_main)
			{
				_main = cfun.create();
			}
			return _main;
		}
		
		public function get curPlayer(): int
		{
			return main.GetCurPlayer();
		}
		
		public function startGame(type: int): void
		{
			if (main.Start(type))
				dispatchEvent(new XpChessGameEvent(XpChessGameEvent.START, type));
			else
				dispatchEvent(new XpChessErrorEvent(XpChessErrorEvent.ERROR, "不支持的棋盘类型: " + type));
		}
		
		public function moveChessMan(from: ChessManPos, to: ChessManPos): void
		{
			var oldPlayer: int = this.curPlayer;
			if (main.Move(from.toObject(), to.toObject()))
			{
				dispatchEvent(new XpChessMoveEvent(XpChessMoveEvent.MOVE, from, to));
				_from = null;
				
				if (oldPlayer == this.curPlayer)
					dispatchEvent(new XpChessGameEvent(XpChessGameEvent.END, 0, this.curPlayer));
			}
			else
			{
				var fromMan: ChessManData = getChessManData(from);
				var toMan: ChessManData = getChessManData(to);
				if (fromMan != null && toMan != null && fromMan.belong == toMan.belong)
					moveFrom(to);
				else
				{
					moveFrom(null);
					dispatchEvent(new XpChessErrorEvent(XpChessErrorEvent.ERROR, "无法移动棋子"));
				}
			}
		}
		
		public function getChessManData(pos: ChessManPos): ChessManData
		{
			if (pos != null)
			{
				var mans: Vector.<ChessManData> = chessMans;
				for each (var man: ChessManData in mans)
				{
					if (man.pos.equals(pos))
						return man;
				}
			}
			return null;
		}
		
		public function get chessMans(): Vector.<ChessManData>
		{
			return ChessManData.parseArray(main.ChessMans());
		}
		
		public function get from(): ChessManPos
		{
			return _from;
		}
		
		public function moveFrom(pos: ChessManPos): void
		{
			if (pos != null)
				dispatchEvent(new XpChessMoveEvent(XpChessMoveEvent.MOVING, pos, null));
			else if (_from != null)
				dispatchEvent(new XpChessMoveEvent(XpChessMoveEvent.CANCEL, null, null));
			
			_from = pos;
		}
		
		public function moveTo(pos: ChessManPos): void
		{
			if (_from != null)
			{
				if (_from.equals(pos))
					moveFrom(null);
				else
					moveChessMan(_from, pos);
			}
		}
	}
}