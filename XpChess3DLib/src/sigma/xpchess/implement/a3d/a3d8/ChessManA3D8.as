package sigma.xpchess.implement.a3d.a3d8
{
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.primitives.Plane;
	
	import sigma.xpchess.implement.a3d.CylinderFactory;
	import sigma.xpchess.implement.common.IChessMan;
	import sigma.xpchess.util.ChessMan;
	import sigma.xpchess.util.ChessManPool;

	internal class ChessManA3D8 extends Object3D implements IChessMan
	{
		private var _manBody: Mesh;
		private var _manFace: Plane;
		
		public function ChessManA3D8(label: String, color: uint)
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
			this.y = y;
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
				_manFace = new Plane(manRadius * 2, manRadius * 2, 1, 1, false);
				_manFace.rotationY = Math.PI;
				_manFace.z = -manHeight;
				
				_manFace.z -= 1;	// not too close to the chessman body, because the top face of cylinder cannot be removed
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
				manFace.setMaterialToAllSurfaces(_faceMaterial);
			}
			
			_faceMaterial.update(chessMan);
			ChessManPool.freeChessMan(chessMan);
		}
		
		//-----------------------------------------------------
		private var _bodyMaterial: FillMaterial;
		
		private function refreshManBody(): void
		{
			if (_bodyMaterial == null)
			{
				_bodyMaterial = new FillMaterial(_color);
				manBody.setMaterialToAllSurfaces(_bodyMaterial);
			}
			else
				_bodyMaterial.color = _color;
		}
		
		private function get manHeight(): Number
		{
			return manBody.boundBox.maxZ;
		}
		
		private function get manRadius(): Number
		{
			return manBody.boundBox.maxX;
		}
		
		private function get manBody(): Mesh
		{
			if (_manBody == null)
			{
				_manBody = CylinderFactory.getInstance();
				if (_manBody)
				{
					_manBody.calculateBoundBox();
					_manBody.z = -manHeight;
					this.addChild(_manBody);
				}
			}
			return _manBody;
		}
	}
}