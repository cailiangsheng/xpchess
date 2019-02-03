package sigma.xpchess.implement.away3d.away3d4
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CylinderGeometry;
	import away3d.primitives.PlaneGeometry;
	
	import sigma.xpchess.implement.common.IChessMan;
	import sigma.xpchess.util.ChessMan;
	import sigma.xpchess.util.ChessManPool;
	
	internal class ChessManAway3D4 extends ObjectContainer3D implements IChessMan
	{
		private var _manBody: Mesh;
		private var _manFace: Mesh;
		
		public function ChessManAway3D4(label: String, color: uint)
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
				_manFace = new Mesh(new PlaneGeometry(manRadius * 2, manRadius * 2, 1, 1, false));
				_manFace.z = -manHeight;
				this.addChild(_manFace);
			}
			return _manFace;
		}
		
		private var _faceMaterial: TextureMaterialEx;
		
		private function refreshManFace(): void
		{
			var chessMan: ChessMan = ChessManPool.getChessMan(_label, _color);
			chessMan.x = chessMan.width / 2;
			chessMan.y = chessMan.height / 2;
			
			if (_faceMaterial == null)
			{
				_faceMaterial = new TextureMaterialEx(chessMan);
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
				_manBody = new Mesh(new CylinderGeometry(manRadius, manRadius, manHeight, 16, 1, false, true, true, false));
				_manBody.z = -manHeight / 2;
				this.addChild(_manBody);
			}
			return _manBody;
		}
	}
}