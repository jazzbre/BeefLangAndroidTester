using System;
using System.Collections;
using System.Text;

namespace Dedkeni
{
	[CRepr, AlwaysInclude(AssumeInstantiated = true, IncludeAllMethods = true), Reflect]
	public struct Rect
	{
		[JSON_Beef.Serialized]
		public float x;
		[JSON_Beef.Serialized]
		public float y;
		[JSON_Beef.Serialized]
		public float width;
		[JSON_Beef.Serialized]
		public float height;

		public float Left
		{
			get
			{
				return x;
			}

			set mut
			{
				width = x + width - value;
				x = value;
			}
		}

		public float Top
		{
			get
			{
				return y;
			}

			set mut
			{
				height = y + height - value;
				y = value;
			}
		}

		public float Right
		{
			get
			{
				return x + width;
			}

			set mut
			{
				width = value - x;
			}
		}

		public float Bottom
		{
			get
			{
				return y + height;
			}

			set mut
			{
				height = value - y;
			}
		}

		public float Width
		{
			get
			{
				return width;
			}

			set mut
			{
				width = value;
			}
		}

		public float Height
		{
			get
			{
				return height;
			}

			set mut
			{
				height = value;
			}
		}

		public this(float _x = 0, float _y = 0, float _width = 0, float _height = 0)
		{
			x = _x;
			y = _y;
			width = _width;
			height = _height;
		}

		public void Set(float _x = 0, float _y = 0, float _width = 0, float _height = 0) mut
		{
			x = _x;
			y = _y;
			width = _width;
			height = _height;
		}

		public bool Intersects(Rect rect)
		{
			return !((rect.x + rect.width <= x) ||
				(rect.y + rect.height <= y) ||
				(rect.x >= x + width) ||
				(rect.y >= y + height));
		}

		public void SetIntersectionOf(Rect rect1, Rect rect2) mut
		{
			float x1 = Math.Max(rect1.x, rect2.x);
			float x2 = Math.Min(rect1.x + rect1.width, rect2.x + rect2.width);
			float y1 = Math.Max(rect1.y, rect2.y);
			float y2 = Math.Min(rect1.y + rect1.height, rect2.y + rect2.height);
			if (((x2 - x1) < 0) || ((y2 - y1) < 0))
			{
				x = 0;
				y = 0;
				width = 0;
				height = 0;
			}
			else
			{
				x = x1;
				y = y1;
				width = x2 - x1;
				height = y2 - y1;
			}
		}

		public void SetIntersectionOf(Rect rect1, float _x, float _y, float _width, float _height) mut
		{
			float x1 = Math.Max(rect1.x, _x);
			float x2 = Math.Min(rect1.x + rect1.width, _x + _width);
			float y1 = Math.Max(rect1.y, _y);
			float y2 = Math.Min(rect1.y + rect1.height, _y + _height);
			if (((x2 - x1) < 0) || ((y2 - y1) < 0))
			{
				x = 0;
				y = 0;
				width = 0;
				height = 0;
			}
			else
			{
				x = x1;
				y = y1;
				width = x2 - x1;
				height = y2 - y1;
			}
		}

		public Rect Intersection(Rect rect)
		{
			float x1 = Math.Max(x, rect.x);
			float x2 = Math.Min(x + width, rect.x + rect.width);
			float y1 = Math.Max(y, rect.y);
			float y2 = Math.Min(y + height, rect.y + rect.height);
			if (((x2 - x1) < 0) || ((y2 - y1) < 0))
				return Rect(0, 0, 0, 0);
			else
				return Rect(x1, y1, x2 - x1, y2 - y1);
		}

		public Rect Union(Rect rect)
		{
			float x1 = Math.Min(x, rect.x);
			float x2 = Math.Max(x + width, rect.x + rect.width);
			float y1 = Math.Min(y, rect.y);
			float y2 = Math.Max(y + height, rect.y + rect.height);
			return Rect(x1, y1, x2 - x1, y2 - y1);
		}

		public bool Contains(float x, float y)
		{
			return ((x >= x) && (x < x + width) &&
				(y >= y) && (y < y + height));
		}

		public bool Contains(Point pt)
		{
			return Contains(pt.x, pt.y);
		}

		public bool Contains(Rect rect)
		{
			return Contains(rect.x, rect.y) && Contains(rect.x + rect.width, rect.y + rect.height);
		}

		public void Offset(float _x, float _y) mut
		{
			x += _x;
			y += _y;
		}

		public void Inflate(float _x, float _y) mut
		{
			x -= _x;
			width += _x * 2;
			y -= _y;
			height += _y * 2;
		}

		public void Scale(float scaleX, float scaleY) mut
		{
			x *= scaleX;
			y *= scaleY;
			width *= scaleX;
			height *= scaleY;
		}

		public void ScaleFrom(float scaleX, float scaleY, float centerX, float centerY) mut
		{
			Offset(-centerX, -centerY);
			Scale(scaleX, scaleY);
			Offset(centerX, centerY);
		}
	}
}
