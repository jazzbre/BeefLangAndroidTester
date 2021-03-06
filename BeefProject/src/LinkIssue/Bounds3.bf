using System;

namespace Dedkeni
{
	[CRepr]
	struct Bounds3
	{
		public Vector3 min;
		public Vector3 max;

		public Vector3 Center => Vector3.Lerp(min, max, 0.5f);
		public Vector3 Extents => Size * 0.5f;

		public Vector3 Size => max - min;

		public Bounds2 xy => .(min.xy, max.xy);

		public this(Vector3 _min = .Zero, Vector3 _max = .Zero)
		{
			min = _min;
			max = _max;
		}

		public void Set(Vector3 _min, Vector3 _max) mut
		{
			min = _min;
			max = _max;
		}

		public void Set(Vector3 p) mut
		{
			min = max = p;
		}

		public void Add(Vector3 p) mut
		{
			min = Vector3.Min(p, min);
			max = Vector3.Max(p, max);
		}

		public void Extend(Vector3 p) mut
		{
			min -= p;
			max += p;
		}

		public static Bounds3 Transform(Bounds3 bounds, Matrix4 matrix)
		{
			var absmatrix = Matrix4.Identity;
			absmatrix.r.RowX = Vector4.Abs(matrix.r.RowX);
			absmatrix.r.RowY = Vector4.Abs(matrix.r.RowY);
			absmatrix.r.RowZ = Vector4.Abs(matrix.r.RowZ);
			let center_ = Vector3.Transform(bounds.Center, matrix);
			let extents_ = Vector3.TransformNormal(bounds.Extents, absmatrix);
			return .(center_ - extents_, center_ + extents_);
		}
	}
}
