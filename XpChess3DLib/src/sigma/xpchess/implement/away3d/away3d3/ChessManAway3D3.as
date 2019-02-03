package sigma.xpchess.implement.away3d.away3d3
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Cylinder;
	import away3d.primitives.Plane;
	
	import sigma.xpchess.implement.common.IChessMan;
	import sigma.xpchess.util.ChessMan;
	import sigma.xpchess.util.ChessManPool;
	
	internal class ChessManAway3D3 extends ObjectContainer3D implements IChessMan
	{
		private var _manBody: Cylinder;
		private var _manFace: Plane;
		
		public function ChessManAway3D3(label: String, color: uint)
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
		private function get manFace(): Mesh
		{
			if (_manFace == null)
			{
				_manFace = new Plane();
				_manFace.width = manRadius * 2;
				_manFace.height = manRadius * 2;
				_manFace.y = manHeight;
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
				_bodyMaterial.color = _color;
		}
		
		private function get manHeight(): Number
		{
			return 15;
		}
		
		private function get manRadius(): Number
		{
			return 20;
		}
		
		private function get manBody(): Mesh
		{
			if (_manBody == null)
			{
				_manBody = new Cylinder();
				_manBody.radius = manRadius;
				_manBody.height = manHeight;
				_manBody.segmentsW = 16;
				_manBody.segmentsH = 1;
				_manBody.y = manHeight / 2;
				_manBody.openEnded = true;
				_manBody.ownCanvas = false;
				this.addChild(_manBody);
			}
			return _manBody;
		}
	}
}