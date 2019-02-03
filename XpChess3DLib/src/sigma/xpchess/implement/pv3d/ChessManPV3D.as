package sigma.xpchess.implement.pv3d
{
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cylinder;
	import org.papervision3d.objects.primitives.Plane;
	
	import sigma.xpchess.implement.common.IChessMan;
	import sigma.xpchess.util.ChessMan;
	import sigma.xpchess.util.ChessManPool;
	
	internal class ChessManPV3D extends DisplayObject3D implements IChessMan
	{
		private var _manBody: Cylinder;
		private var _manFace: Plane;
		
		public function ChessManPV3D(label: String, color: uint)
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
		private function get manFace(): Plane
		{
			if (_manFace == null)
			{
				_manFace = new Plane(null, manRadius * 2, manRadius * 2, 10, 10);
				_manFace.rotationX = 270;
				_manFace.y = -manHeight / 2;
				this.addChild(_manFace);
			}
			return _manFace;
		}
		
		private var _faceMaterial: BitmapMaterialEx;
		
		private function refreshManFace(): void
		{
			var chessMan: ChessMan = ChessManPool.getChessMan(_label, _color);
			chessMan.x = chessMan.width / 2;
			chessMan.y = chessMan.height / 2;
			
			if (_faceMaterial == null)
			{
				_faceMaterial = new BitmapMaterialEx(chessMan);
				manFace.material = _faceMaterial;
			}
			
			_faceMaterial.update(chessMan);
			ChessManPool.freeChessMan(chessMan);
		}
		
		//-----------------------------------------------------
		private var _bodyMaterial: ColorMaterial;
		
		private function refreshManBody(): void
		{
			if (_bodyMaterial == null)
			{
				_bodyMaterial = new ColorMaterial(_color);
				manBody.material = _bodyMaterial;
			}
			else
				_bodyMaterial.fillColor = _color;
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
				_manBody = new Cylinder(null, manRadius, manHeight, 16, 1, -1, false, true);
				_manBody.rotationZ = 180;
				this.addChild(_manBody);
			}
			return _manBody;
		}
	}
}