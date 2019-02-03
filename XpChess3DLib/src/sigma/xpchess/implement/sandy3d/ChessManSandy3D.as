package sigma.xpchess.implement.sandy3d
{
	import flash.display.BitmapData;
	
	import sandy.core.scenegraph.TransformGroup;
	import sandy.materials.Appearance;
	import sandy.materials.BitmapMaterial;
	import sandy.materials.ColorMaterial;
	import sandy.primitive.Cylinder;
	
	import sigma.xpchess.implement.common.IChessMan;
	import sigma.xpchess.util.ChessMan;
	import sigma.xpchess.util.ChessManPool;

	internal class ChessManSandy3D extends TransformGroup implements IChessMan
	{
		private var _manBody: Cylinder;
		private var _manFace: Appearance;
		
		public function ChessManSandy3D(label: String, color: uint)
		{
			init(label, color);
		}

		public function init(label: String, color: uint): void
		{
			_label = label;
			_color = color;
			refreshManFace();
			refreshManBody();
		}
		
		public function place(x: Number, y: Number): void
		{
			this.x = x;
			this.y = -y;
		}
		
		//-----------------------------------------------------
		private var _label: String;
		private var _color: uint;
		
		public function get label(): String
		{
			return _label;
		}
		
		public function set label(value: String): void
		{
			refreshManFace();
		}
		
		public function get color(): uint
		{
			return _color;
		}
		
		public function set color(value: uint): void
		{
			_color = value;
			refreshManFace();
			refreshManBody();
		}
		
		//-----------------------------------------------------
		private function get manFace(): Appearance
		{
			if (_manFace == null)
			{
				_manFace = new Appearance();
			}
			return _manFace;
		}
		
		private var _faceMaterial: BitmapMaterial;
		
		private function refreshManFace(): void
		{
			var chessMan: ChessMan = ChessManPool.getChessMan(_label, _color);
			chessMan.x = chessMan.width / 2;
			chessMan.y = chessMan.height / 2;
			
			if (_faceMaterial == null)
			{
				var bmpData: BitmapData = new BitmapData(chessMan.width, chessMan.height, true, 0);
				_faceMaterial = new BitmapMaterial(bmpData);
				manFace.frontMaterial = _faceMaterial;
			}
			
			_faceMaterial.texture.draw(chessMan, chessMan.transform.matrix);
			ChessManPool.freeChessMan(chessMan);
		}
		
		//-----------------------------------------------------
		private var _bodyAppearance: Appearance;
		
		private function get bodyAppearance(): Appearance
		{
			if (_bodyAppearance == null)
			{
				_bodyAppearance = new Appearance();
				_bodyAppearance.frontMaterial = new ColorMaterial(_color);
			}
			return _bodyAppearance;
		}
		
		private function refreshManBody(): void
		{
			var colorMatierial: ColorMaterial = bodyAppearance.frontMaterial as ColorMaterial;
			colorMatierial.color = _color;
			
			this.manBody.appearance = bodyAppearance;
			this.manBody.getBottom().appearance = manFace;
			this.manBody.getTop().appearance = bodyAppearance;
		}
		
		private function get manHeight(): Number
		{
			return 15;
		}
		
		private function get manRadius(): Number
		{
			return 20;
		}
		
		private function get manBody(): Cylinder
		{
			if (_manBody == null)
			{
				_manBody = new Cylinder(null, manRadius, manHeight, 20, 1);
				_manBody.z = -manHeight / 2;
				_manBody.rotateX = 90;
				this.addChild(_manBody);
			}
			return _manBody;
		}
	}
}