package sigma.xpchess.util
{
    import flash.display.Sprite;
    import flash.text.engine.ElementFormat;
    import flash.text.engine.FontDescription;
    import flash.text.engine.TextBaseline;
    import flash.text.engine.TextBlock;
    import flash.text.engine.TextElement;
    import flash.text.engine.TextLine;
    
    import sigma.xpchess.implement.common.IChessMan;

	public class ChessMan extends Sprite implements IChessMan
	{
		public static const DEFAULT_SIZE: Number = 19.5;
		
		private static var _textBlock: TextBlock = new TextBlock();
		private var _elementFormat: ElementFormat = new ElementFormat();
		private var _fontDescription: FontDescription = new FontDescription();
		private var _textLine: TextLine = null;
		
		private var _label: String;
		private var _color: uint;
		
		public function ChessMan(label: String, color:uint, fontName: String="宋体", size: Number = DEFAULT_SIZE)
		{
			_fontDescription.fontName = fontName;
			_elementFormat.fontDescription = _fontDescription;
			_elementFormat.fontSize = size;
			_elementFormat.color = 0xffffff;
			
			init(label, color);
		}
		
		public function init(label: String, color: uint):void
		{
			this.label = label;
			this.color = color;
		}
		
		private function refreshText(): void
		{
			_textBlock.baselineZero = TextBaseline.IDEOGRAPHIC_CENTER;
			_textBlock.content = new TextElement(_label, _elementFormat);
			if (_textLine)
			{
				this.removeChild(_textLine);
			}
			_textLine = _textBlock.createTextLine(null);
			if (_textLine)
			{
				_textLine.x = -_textLine.width / 2;
				this.addChild(_textLine);
			}
		}
		
		private function refreshBackGround(): void
		{
			if (_textLine)
			{
				var size:Number = Math.sqrt(_textLine.width * _textLine.width + 
											_textLine.height * _textLine.height) / 2;
			}
			else
			{
				size = _elementFormat.fontSize / 2 * Math.SQRT2;
			}
			
			this.graphics.clear();
			this.graphics.lineStyle(2, _color);
			this.graphics.beginFill(0xffffff);
			this.graphics.drawCircle(0, 0, size + 5);
			this.graphics.endFill();
			
			this.graphics.lineStyle(1, _color);
			this.graphics.beginFill(_color);
			this.graphics.drawCircle(0, 0, size + 2);
			this.graphics.endFill();
		}
		
		public function get label(): String
		{
			return _label;
		}
		public function set label(value: String): void
		{
			_label = value;
			refreshText();
		}
		
		public function get color(): uint
		{
			return _color;
		}
		
		public function set color(value: uint):void
		{
			_color = value;
			refreshBackGround();
		}
		
		public function place(x: Number, y: Number): void
		{
			this.x = x;
			this.y = y;
		}
	}
}