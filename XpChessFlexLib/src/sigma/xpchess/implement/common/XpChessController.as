package sigma.xpchess.implement.common
{
	import sigma.xpchess.define.IXpChessController;
	import sigma.xpchess.define.IXpChessModel;
	import sigma.xpchess.event.XpChessMoveEvent;
	import sigma.xpchess.util.ChessManData;
	import sigma.xpchess.util.ChessManPos;
	
	public class XpChessController implements IXpChessController
	{
		private var _model: IXpChessModel = null;
		
		public function XpChessController()
		{
		}
		
		public function init(model: IXpChessModel): void
		{
			_model = model;
		}
		
		public function onChessBoardClick(pos: ChessManPos): void
		{
			if (_model.getChessManData(pos) != null)
			{
				if (_model.from == null)
				{
					_model.moveFrom(pos);
				}
				else
				{
					_model.moveTo(pos);
				}
			}
			else if (_model.from != null)
			{
				_model.moveTo(pos);
			}
		}
	}
}