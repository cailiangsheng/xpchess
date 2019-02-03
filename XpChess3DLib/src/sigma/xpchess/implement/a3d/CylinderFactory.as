package sigma.xpchess.implement.a3d
{
	import flash.utils.ByteArray;
	
	import alternativa.engine3d.loaders.Parser3DS;
	import alternativa.engine3d.objects.Mesh;

	public class CylinderFactory
	{
		[Embed(source="cylinder.3DS", mimeType="application/octet-stream")]
		private static const CylinderClass: Class;
		private static const CylinderName: String = "Cylinder01";
		private static var _cylinder: Mesh;
		
		private static function parseCylinder(data: ByteArray): void
		{
			trace(data.length);
			var parser: Parser3DS = new Parser3DS();
			parser.parse(data);
			trace(parser.objects);
			_cylinder = parser.getObjectByName(CylinderName) as Mesh;
		}
		
		private static function get cylinder(): Mesh
		{
			if (_cylinder == null)
			{
				parseCylinder(new CylinderClass());
			}
			return _cylinder;
		}
		
		public static function getInstance(): Mesh
		{
			return  cylinder.clone() as Mesh;
		}
	}
}