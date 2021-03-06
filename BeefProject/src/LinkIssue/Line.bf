using System;

namespace Dedkeni
{
	class Line
	{
		public static double DistanceToPoint(Vector2 point, Vector2 l1, Vector2 l2)
		{
			return Math.Abs((l2.x - l1.x) * (l1.y - point.y) - (l1.x - point.x) * (l2.y - l1.y)) / Math.Sqrt(Math.Pow(l2.x - l1.x, 2) + Math.Pow(l2.y - l1.y, 2));
		}
	}
}
