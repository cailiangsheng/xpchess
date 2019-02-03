package sigma.xpchess.implement.a3d.a3d7
{
	import alternativa.engine3d.core.Face;
	import alternativa.engine3d.objects.Mesh;

	internal function removeCylinderFaces(cylinder: Mesh, top: Boolean, bottom: Boolean, side: Boolean = false): void
	{
		if (cylinder)
		{
			var removingFaces: Array = [];
			var len: uint = cylinder.faces.length;
			var topCount: uint = 18;
			var bottomCount: uint = len - topCount;
			for (var i: int = 0; i < len; i++)
			{
				if (top && i < topCount || 
					bottom && i >= bottomCount || 
					side && i >= topCount && i < bottomCount)
					removingFaces.push(cylinder.faces[i]);
			}
			
			for each (var face: Face in removingFaces)
				cylinder.removeFace(face);
		}
	}
}