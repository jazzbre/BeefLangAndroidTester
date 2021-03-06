using System;

namespace Dedkeni
{
	[CRepr]
	struct Bounds2
	{
		public Vector2 min;
		public Vector2 max;

		public Vector2 Center => Vector2.Lerp(min, max, 0.5f);
		public Vector2 Extents => Size * 0.5f;

		public Vector2 Size => max - min;

		public this(Vector2 _min = .Zero, Vector2 _max = .Zero)
		{
			min = _min;
			max = _max;
		}

		public void Set(Vector2 _min = .Zero, Vector2 _max = .Zero) mut
		{
			min = _min;
			max = _max;
		}

		public void Set(Vector2 p) mut
		{
			min = max = p;
		}

		public void Add(Vector2 p) mut
		{
			min = Vector2.Min(p, min);
			max = Vector2.Max(p, max);
		}

		public void Extend(Vector2 p) mut
		{
			min -= p;
			max += p;
		}

		public bool PointIn(Vector2 p)
		{
			return p.x < max.x && p.y < max.y && p.x >= min.x && p.y >= min.y;
		}

		public static Bounds2 Transform(Bounds2 bounds, Matrix4 matrix)
		{
			var absmatrix = Matrix4.Identity;
			absmatrix.r.RowX = Vector4.Abs(matrix.r.RowX);
			absmatrix.r.RowY = Vector4.Abs(matrix.r.RowY);
			absmatrix.r.RowZ = Vector4.Abs(matrix.r.RowZ);
			let center_ = Vector3.Transform(bounds.Center.xy0, matrix);
			let extents_ = Vector3.TransformNormal(bounds.Extents.xy0, absmatrix);
			return .((center_ - extents_).xy, (center_ + extents_).xy);
		}

		public static bool Intersect(Bounds2 a, Bounds2 b)
		{
			return a.min.x < b.max.x && a.min.y < b.max.y && a.max.x >= b.min.x && a.max.y >= b.min.y;
		}
	}
}
