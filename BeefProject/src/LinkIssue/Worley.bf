using System;
using System.Collections;

namespace Dedkeni
{
	class Worley
	{
		private const int MaxVoronoiVertexCount = 20;

		private int seed;
		private float cellSize;
		private int width, height;
		private Vector2 minBounds, maxBounds;
		private Vector2 focusPosition;

		typealias NewShapeCallbackDelegate = delegate void(Vector2[] vertices, int count);
		public NewShapeCallbackDelegate NewShapeCallback { get; set; }

		private Vector2 Hash(int x, int y)
		{
			let border = 0.05f;
			let hash = (x * 1640531513 ^ y * 2654435789) + seed;
			return .(Math.Lerp(border, 1.0f - border, (float)(hash & 0xFFFF) / (float)0xFFFF), Math.Lerp(border, 1.0f - border, (float)((hash >> 16) & 0xFFFF) / (float)0xFFFF));
		}

		private Vector2 Point(int i, int j)
		{
			let randomPoint = Hash(i, j);
			return Vector2.Floor(Vector2(Math.Lerp(minBounds.x, maxBounds.x, 0.5f) + cellSize * (i + randomPoint.x - width * 0.5f), Math.Lerp(minBounds.y, maxBounds.y, 0.5f) + cellSize * (j + randomPoint.y - height * 0.5f)));
		}

		private int ClipCell(Vector2[] shapeVertices, Vector2 center, int x, int y, Vector2[] verts, Vector2[] clipped, int count)
		{
			var other = Point(x, y);
			if (!Polygon.PointInPolygon(other, shapeVertices))
			{
				verts.CopyTo(clipped, 0, 0, count);
				return count;
			}
			let normal = other - center;
			let distance = Vector2.Dot(normal, Vector2.Lerp(center, other, 0.5f));
			var clippedCount = 0;
			for (var j = 0,var i = count - 1; j < count; i = j,j++)
			{
				let pointA = verts[i];
				let pointADistance = Vector2.Dot(pointA, normal) - distance;
				if (pointADistance <= 0.0)
				{
					clipped[clippedCount++] = pointA;
				}

				let pointB = verts[j];
				let pointBDistance = Vector2.Dot(pointB, normal) - distance;
				if (pointADistance * pointBDistance < 0.0f)
				{
					let t = Math.Abs(pointADistance) / (Math.Abs(pointADistance) + Math.Abs(pointBDistance));
					clipped[clippedCount++] = Vector2.Lerp(pointA, pointB, t);
				}
			}

			return clippedCount;
		}

		private void SplitCell(Vector2[] shapeVertices, Vector2 cell, int cell_i, int cell_j)
		{
			let pingVertices = scope Vector2[MaxVoronoiVertexCount];
			let pongVertices = scope Vector2[MaxVoronoiVertexCount];
			var count = shapeVertices.Count > MaxVoronoiVertexCount ? MaxVoronoiVertexCount : shapeVertices.Count;
			shapeVertices.CopyTo(pingVertices, 0, 0, shapeVertices.Count);
			for (var i = 0; i < width; i++)
			{
				for (var j = 0; j < height; j++)
				{
					if (!(i == cell_i && j == cell_j) && Polygon.PointInPolygon(cell, shapeVertices))
					{
						count = ClipCell(shapeVertices, cell, i, j, pingVertices, pongVertices, count);
						pongVertices.CopyTo(pingVertices, 0, 0, count);
					}
				}
			}
			NewShapeCallback(pingVertices, count);
		}

		public void Split(Vector2[] shapeVertices, float _cellSize, Vector2 _focusPosition, int _seed, Vector2 _minBounds, Vector2 _maxBounds)
		{
			// Setup
			cellSize = _cellSize;
			focusPosition = _focusPosition;
			seed = _seed;
			minBounds = _minBounds;
			maxBounds = _maxBounds;
			width = (int)((maxBounds.x - minBounds.x) / cellSize) + 1;
			height = (int)((maxBounds.y - minBounds.y) / cellSize) + 1;
			// Split!
			for (var i = 0; i < width; i++)
			{
				for (var j = 0; j < height; j++)
				{
					let cell = Point(i, j);
					if (Polygon.PointInPolygon(cell, shapeVertices))
					{
						SplitCell(shapeVertices, cell, i, j);
					}
				}
			}
		}
	}
}