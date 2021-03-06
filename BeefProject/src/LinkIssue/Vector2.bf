using System;
using System.Collections;
using System.Text;

namespace Dedkeni
{
	[CRepr, AlwaysInclude(AssumeInstantiated = true, IncludeAllMethods = true), Reflect]
	public struct Vector2
	{
		[JSON_Beef.Serialized]
		public float x;
		[JSON_Beef.Serialized]
		public float y;

		public const Vector2 Zero = Vector2(0f, 0f);
		public const Vector2 One = Vector2(1f, 1f);
		public const Vector2 Half = Vector2(0.5f, 0.5f);
		public const Vector2 UnitX = Vector2(1f, 0f);
		public const Vector2 UnitY = Vector2(0f, 1f);
		public const Vector2 Up = Vector2(0f, 1f);
		public const Vector2 Down = Vector2(0f, -1f);
		public const Vector2 Right = Vector2(1f, 0f);
		public const Vector2 Left = Vector2(-1f, 0f);

		public float Length
		{
			get
			{
				return (float)Math.Sqrt(x * x + y * y);
			}
		}

		public float LengthSquared
		{
			get
			{
				return x * x + y * y;
			}
		}

		public float Angle
		{
			get
			{
				return Math.Atan2(y, x);
			}
		}

		public Vector2 xy
		{
			get
			{
				return Vector2(x, y);
			}
			set mut
			{
				x = value.x;
				y = value.y;
			}
		}

		public Vector3 xy0
		{
			get
			{
				return Vector3(x, y, 0);
			}
			set mut
			{
				x = value.x;
				y = value.y;
			}
		}

		public Vector4 xy00
		{
			get
			{
				return Vector4(x, y, 0, 0);
			}
			set mut
			{
				x = value.x;
				y = value.y;
			}
		}

		public Vector4 xy01
		{
			get
			{
				return Vector4(x, y, 0, 1);
			}
			set mut
			{
				x = value.x;
				y = value.y;
			}
		}

		public this()
		{
			this = default;
		}

		public this(float v)
		{
			x = y = v;
		}

		public this(float _x, float _y)
		{
			x = _x;
			y = _y;
		}

		public static Vector2 Round(Vector2 vector)
		{
			return .(Math.Round(vector.x), Math.Round(vector.y));
		}

		public static Vector2 Floor(Vector2 vector)
		{
			return .(Math.Floor(vector.x), Math.Floor(vector.y));
		}

		public static Vector2 Ceiling(Vector2 vector)
		{
			return .(Math.Ceiling(vector.x), Math.Ceiling(vector.y));
		}

		public static Vector2 Min(Vector2 vec1, Vector2 vec2)
		{
			return .(Math.Min(vec1.x, vec2.x), Math.Min(vec1.y, vec2.y));
		}

		public static Vector2 Max(Vector2 vec1, Vector2 vec2)
		{
			return .(Math.Max(vec1.x, vec2.x), Math.Max(vec1.y, vec2.y));
		}

		public static Vector2 Abs(Vector2 vec1)
		{
			return .(Math.Abs(vec1.x), Math.Abs(vec1.y));
		}

		public static Vector2 Normalize(Vector2 vector)
		{
			Vector2 newVec;
			Normalize(vector, out newVec);
			return newVec;
		}

		public static void Normalize(Vector2 value, out Vector2 result)
		{
			float factor = value.Length;
			factor = 1f / factor;
			result.x = value.x * factor;
			result.y = value.y * factor;
		}

		public static Vector2 Lerp(Vector2 a, Vector2 b, float delta)
		{
			return a + (b - a) * delta;
		}

		public static Vector2 Lerp(Vector2 a, Vector2 b, Vector2 delta)
		{
			return a + (b - a) * delta;
		}

		public static Vector2 Reflect(Vector2 v, Vector2 n)
		{
			return v - 2 * Dot(v, n) * n;
		}

		public static float DistanceSquared(Vector2 value1, Vector2 value2)
		{
			return (value1.x - value2.x) * (value1.x - value2.x) + (value1.y - value2.y) * (value1.y - value2.y);
		}

		public static float Distance(Vector2 vector1, Vector2 vector2)
		{
			float result = DistanceSquared(vector1, vector2);
			return (float)Math.Sqrt(result);
		}

		public static float Dot(Vector2 vec1, Vector2 vec2)
		{
			return vec1.x * vec2.x + vec1.y * vec2.y;
		}

		public static float ScalarCross(Vector2 vector1, Vector2 vector2)
		{
			return vector1.x * vector2.y - vector1.y * vector2.x;
		}

		public static Vector2 FromAngle(float angle, float length = 1.0f)
		{
			return .((float)Math.Cos(angle) * length, (float)Math.Sin(angle) * length);
		}

		public static Vector2 operator-(Vector2 vec1)
		{
			return .(-vec1.x, -vec1.y);
		}

		public static Vector2 operator+(Vector2 vec1, Vector2 vec2)
		{
			return .(vec1.x + vec2.x, vec1.y + vec2.y);
		}

		public static Vector2 operator-(Vector2 vec1, Vector2 vec2)
		{
			return .(vec1.x - vec2.x, vec1.y - vec2.y);
		}

		public static Vector2 operator*(Vector2 vec1, Vector2 vec2)
		{
			return .(vec1.x * vec2.x, vec1.y * vec2.y);
		}

		public static Vector2 operator/(Vector2 vec1, Vector2 vec2)
		{
			return .(vec1.x / vec2.x, vec1.y / vec2.y);
		}

		[Commutable]
		public static Vector2 operator*(Vector2 vec, float scale)
		{
			return .(vec.x * scale, vec.y * scale);
		}

		public static Vector2 operator/(Vector2 vec, float scale)
		{
			return .(vec.x / scale, vec.y / scale);
		}

		public override void ToString(String str)
		{
			str.AppendF("{0:0.0#}, {1:0.0#}", x, y);
		}
	}
}
