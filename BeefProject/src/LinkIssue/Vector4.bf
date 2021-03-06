using System;
using System.Collections;
using System.Text;
using System.Threading.Tasks;

namespace Dedkeni
{
	[CRepr, AlwaysInclude(AssumeInstantiated = true, IncludeAllMethods = true), Reflect]
	public struct Vector4 : IHashable, IEquatable<Vector4>
	{
		[JSON_Beef.Serialized]
		public float x;
		[JSON_Beef.Serialized]
		public float y;
		[JSON_Beef.Serialized]
		public float z;
		[JSON_Beef.Serialized]
		public float w;

		public const Vector4 Zero = Vector4(0f, 0f, 0f, 0.0f);
		public const Vector4 One = Vector4(1f, 1f, 1f, 1.0f);
		public const Vector4 Half = Vector4(0.5f, 0.5f, 0.5f, 0.5f);
		public const Vector4 UnitX = Vector4(1f, 0f, 0f, 0.0f);
		public const Vector4 UnitY = Vector4(0f, 1f, 0f, 0.0f);
		public const Vector4 UnitZ = Vector4(0f, 0f, 1f, 0.0f);
		public const Vector4 UnitW = Vector4(0f, 0f, 0f, 1.0f);
		public const Vector4 Up = Vector4(0f, 1f, 0f, 0.0f);
		public const Vector4 Down = Vector4(0f, -1f, 0f, 0.0f);
		public const Vector4 Right = Vector4(1f, 0f, 0f, 0.0f);
		public const Vector4 Left = Vector4(-1f, 0f, 0f, 0.0f);
		public const Vector4 Forward = Vector4(0f, 0f, -1f, 0.0f);
		public const Vector4 Backward = Vector4(0f, 0f, 1f, 0.0f);

		public float Length
		{
			get
			{
				return (float)Math.Sqrt(x * x + y * y + z * z + w * w);
			}
		}

		public float LengthSquared
		{
			get
			{
				return x * x + y * y + z * z + w * w;
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

		public Vector3 xyz
		{
			get
			{
				return Vector3(x, y, z);
			}
			set mut
			{
				x = value.x;
				y = value.y;
				z = value.z;
			}
		}

		public Vector2 zw
		{
			get
			{
				return Vector2(z, w);
			}
			set mut
			{
				z = value.x;
				w = value.y;
			}
		}

		public this()
		{
			this = default;
		}

		public this(float v)
		{
			x = y = z = w = v;
		}

		public this(float _x, float _y, float _z, float _w)
		{
			x = _x;
			y = _y;
			z = _z;
			w = _w;
		}

		public this(Vector3 v, float _w = 0.0f)
		{
			x = v.x;
			y = v.y;
			z = v.z;
			w = _w;
		}

		public this(Vector2 v, float _z = 0.0f, float _w = 0.0f)
		{
			x = v.x;
			y = v.y;
			z = _z;
			w = _w;
		}

		public this(Vector2 v1, Vector2 v2)
		{
			x = v1.x;
			y = v1.y;
			z = v2.x;
			w = v2.y;
		}

		public bool Equals(Vector4 other)
		{
			return this == other;
		}

		public int GetHashCode()
		{
			return (int)(this.x + this.y + this.z + this.w);
		}

		public uint32 ToRGBA()
		{
			return ((uint32)(w * 255) << 24) | ((uint32)(z * 255) << 16) | ((uint32)(y * 255) << 8) | ((uint32)(x * 255));
		}

		public static Vector4 Round(Vector4 vector)
		{
			return .(Math.Round(vector.x), Math.Round(vector.y), Math.Round(vector.z), Math.Round(vector.w));
		}

		public static Vector4 Floor(Vector4 vector)
		{
			return .(Math.Floor(vector.x), Math.Floor(vector.y), Math.Floor(vector.z), Math.Floor(vector.w));
		}

		public static Vector4 Ceiling(Vector4 vector)
		{
			return .(Math.Ceiling(vector.x), Math.Ceiling(vector.y), Math.Ceiling(vector.z), Math.Ceiling(vector.w));
		}

		public static Vector4 Min(Vector4 vec1, Vector4 vec2)
		{
			return .(Math.Min(vec1.x, vec2.x), Math.Min(vec1.y, vec2.y), Math.Min(vec1.z, vec2.z), Math.Min(vec1.w, vec2.w));
		}

		public static Vector4 Max(Vector4 vec1, Vector4 vec2)
		{
			return .(Math.Max(vec1.x, vec2.x), Math.Max(vec1.y, vec2.y), Math.Max(vec1.z, vec2.z), Math.Max(vec1.w, vec2.w));
		}

		public static Vector4 Abs(Vector4 vec1)
		{
			return .(Math.Abs(vec1.x), Math.Abs(vec1.y), Math.Abs(vec1.z), Math.Abs(vec1.w));
		}

		public static Vector4 Normalize(Vector4 vector)
		{
			Vector4 newVec;
			Normalize(vector, out newVec);
			return newVec;
		}

		public static void Normalize(Vector4 value, out Vector4 result)
		{
			float factor = value.Length;
			factor = 1f / factor;
			result.x = value.x * factor;
			result.y = value.y * factor;
			result.z = value.z * factor;
			result.w = value.w * factor;
		}

		public static Vector4 Lerp(Vector4 a, Vector4 b, float delta)
		{
			return a + (b - a) * delta;
		}

		public static Vector4 Lerp(Vector4 a, Vector4 b, Vector4 delta)
		{
			return a + (b - a) * delta;
		}

		public static Vector4 Reflect(Vector4 v, Vector4 n)
		{
			return v - 2 * Dot(v, n) * n;
		}

		public static float Dot(Vector4 vec1, Vector4 vec2)
		{
			return vec1.x * vec2.x + vec1.y * vec2.y + vec1.z * vec2.z + vec1.w * vec2.w;
		}

		public static float DistanceSquared(Vector4 value1, Vector4 value2)
		{
			return (value1.x - value2.x) * (value1.x - value2.x) +
				(value1.y - value2.y) * (value1.y - value2.y) +
				(value1.z - value2.z) * (value1.z - value2.z) +
				(value1.w - value2.w) * (value1.w - value2.w);
		}

		public static float Distance(Vector4 vector1, Vector4 vector2)
		{
			float result = DistanceSquared(vector1, vector2);
			return (float)Math.Sqrt(result);
		}

		public static Vector4 Transform(Vector4 vec, Matrix4 matrix)
		{
			return .(Vector4.Dot(vec, matrix.GetColumn4(0)), Vector4.Dot(vec, matrix.GetColumn4(1)), Vector4.Dot(vec, matrix.GetColumn4(2)), Vector4.Dot(vec, matrix.GetColumn4(3)));
		}

		public static Vector4 Transform(Vector4 vec, Quaternion quat)
		{
			Matrix4 matrix = quat.ToMatrix();
			return Transform(vec, matrix);
		}

		public static Vector4 TransformNormal(Vector4 vec, Matrix4 matrix)
		{
			return .(Vector4.Dot(vec, matrix.GetColumn4(0)), Vector4.Dot(vec, matrix.GetColumn4(1)), Vector4.Dot(vec, matrix.GetColumn4(2)), 1);
		}

		public static bool operator==(Vector4 value1, Vector4 value2)
		{
			return (value1.x == value2.x) &&
				(value1.y == value2.y) &&
				(value1.z == value2.z) &&
				(value1.w == value2.w);
		}

		public static bool operator!=(Vector4 value1, Vector4 value2)
		{
			return !(value1 == value2);
		}

		public static Vector4 operator-(Vector4 vec1)
		{
			return .(-vec1.x, -vec1.y, -vec1.z, -vec1.w);
		}

		public static Vector4 operator+(Vector4 vec1, Vector4 vec2)
		{
			return .(vec1.x + vec2.x, vec1.y + vec2.y, vec1.z + vec2.z, vec1.w + vec2.w);
		}

		public static Vector4 operator-(Vector4 vec1, Vector4 vec2)
		{
			return .(vec1.x - vec2.x, vec1.y - vec2.y, vec1.z - vec2.z, vec1.w - vec2.w);
		}

		public static Vector4 operator*(Vector4 vec1, Vector4 vec2)
		{
			return .(vec1.x * vec2.x, vec1.y * vec2.y, vec1.z * vec2.z, vec1.w * vec2.w);
		}

		public static Vector4 operator/(Vector4 vec1, Vector4 vec2)
		{
			return .(vec1.x / vec2.x, vec1.y / vec2.y, vec1.z / vec2.z, vec1.w / vec2.w);
		}

		[Commutable]
		public static Vector4 operator*(Vector4 vec, float scale)
		{
			return .(vec.x * scale, vec.y * scale, vec.z * scale, vec.w * scale);
		}

		public static Vector4 operator/(Vector4 vec, float scale)
		{
			return .(vec.x / scale, vec.y / scale, vec.z / scale, vec.w / scale);
		}

		public override void ToString(String str)
		{
			str.AppendF("{0:0.0#}, {1:0.0#}, {2:0.0#}, {3:0.0#}", x, y, z, w);
		}
	}
}
