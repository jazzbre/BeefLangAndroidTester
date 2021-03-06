namespace Dedkeni
{
	enum PolygonSide
	{
		Left,
		Right,
		None
	}

	class Polygon
	{
		public static PolygonSide GetSide(Vector2 a, Vector2 b)
		{
			let x = Vector2.ScalarCross(a, b);
			if (x < 0)
			{
				return .Left;
			} else if (x > 0)
			{
				return .Right;
			} else
			{
				return .None;
			}
		}

		public static bool PointInPolygon(Vector2 point, Vector2[] vertices)
		{
			PolygonSide previousSide = .None;
			let count = vertices.Count;
			for (int n = 0; n < vertices.Count; ++n)
			{
				let pointA = vertices[n];
				let pointB = vertices[(n + 1) % count];
				let affineSegment = pointB - pointA;
				let affinePoint = point - pointA;
				let currentSide = GetSide(affineSegment, affinePoint);
				if (currentSide == .None)
				{
					return false;
				}
				else if (previousSide == .None)
				{
					previousSide = currentSide;
				}
				else if (previousSide != currentSide)
				{
					return false;
				}
			}
			return true;
		}
	}
}
