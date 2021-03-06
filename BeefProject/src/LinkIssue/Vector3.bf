using System;
using System.Collections;
using System.Text;
using System.Threading.Tasks;

namespace Dedkeni
{
	[CRepr, AlwaysInclude(AssumeInstantiated = true, IncludeAllMethods = true), Reflect]
	public struct Vector3 : IHashable, IEquatable<Vector3>
	{
		[JSON_Beef.Serialized]
		public float x;
		[JSON_Beef.Serialized]
		public float y;
		[JSON_Beef.Serialized]
		public float z;

		public const Vector3 Zero = Vector3(0f, 0f, 0f);
		public const Vector3 One = Vector3(1f, 1f, 1f);
		public const Vector3 Half = Vector3(0.5f, 0.5f, 0.5f);
		public const Vector3 UnitX = Vector3(1f, 0f, 0f);
		public const Vector3 UnitY = Vector3(0f, 1f, 0f);
		public const Vector3 UnitZ = Vector3(0f, 0f, 1f);
		public const Vector3 Up = Vector3(0f, 1f, 0f);
		public const Vector3 Down = Vector3(0f, -1f, 0f);
		public const Vector3 Right = Vector3(1f, 0f, 0f);
		public const Vector3 Left = Vector3(-1f, 0f, 0f);
		public const Vector3 Forward = Vector3(0f, 0f, -1f);
		public const Vector3 Backward = Vector3(0f, 0f, 1f);

		public float Length
		{
			get
			{
				return (float)Math.Sqrt(x * x + y * y + z * z);
			}
		}

		public float LengthSquared
		{
			get
			{
				return x * x + y * y + z * z;
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

		public Vector4 xyz0
		{
			get
			{
				return Vector4(x, y, z, 0);
			}
			set mut
			{
				x = value.x;
				y = value.y;
			}
		}

		public Vector4 xyz1
		{
			get
			{
				return Vector4(x, y, z, 1);
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
			x = y = z = v;
		}

		public this(float _x, float _y, float _z)
		{
			x = _x;
			y = _y;
			z = _z;
		}

		public this(Vector2 v, float _z = 0.0f)
		{
			x = v.x;
			y = v.y;
			z = _z;
		}

		public bool Equals(Vector3 other)
		{
			return this == other;
		}

		public int GetHashCode()
		{
			return (int)(this.x + this.y + this.z);
		}


		public static Vector3 Round(Vector3 vector)
		{
			return .(Math.Round(vector.x), Math.Round(vector.y), Math.Round(vector.z));
		}

		public static Vector3 Floor(Vector3 vector)
		{
			return .(Math.Floor(vector.x), Math.Floor(vector.y), Math.Floor(vector.z));
		}

		public static Vector3 Ceiling(Vector3 vector)
		{
			return .(Math.Ceiling(vector.x), Math.Ceiling(vector.y), Math.Ceiling(vector.z));
		}

		public static Vector3 Min(Vector3 vec1, Vector3 vec2)
		{
			return .(Math.Min(vec1.x, vec2.x), Math.Min(vec1.y, vec2.y), Math.Min(vec1.z, vec2.z));
		}

		public static Vector3 Max(Vector3 vec1, Vector3 vec2)
		{
			return .(Math.Max(vec1.x, vec2.x), Math.Max(vec1.y, vec2.y), Math.Max(vec1.z, vec2.z));
		}

		public static Vector3 Abs(Vector3 vec1)
		{
			return .(Math.Abs(vec1.x), Math.Abs(vec1.y), Math.Abs(vec1.z));
		}

		public static Vector3 Normalize(Vector3 vector)
		{
			Vector3 newVec;
			Normalize(vector, out newVec);
			return newVec;
		}

		public static void Normalize(Vector3 value, out Vector3 result)
		{
			float factor = value.Length;
			factor = 1f / factor;
			result.x = value.x * factor;
			result.y = value.y * factor;
			result.z = value.z * factor;
		}

		public static Vector3 Lerp(Vector3 a, Vector3 b, float delta)
		{
			return a + (b - a) * delta;
		}

		public static Vector3 Lerp(Vector3 a, Vector3 b, Vector3 delta)
		{
			return a + (b - a) * delta;
		}

		public static Vector3 Reflect(Vector3 v, Vector3 n)
		{
			return v - 2 * Dot(v, n) * n;
		}

		public static float Dot(Vector3 vec1, Vector3 vec2)
		{
			return vec1.x * vec2.x + vec1.y * vec2.y + vec1.z * vec2.z;
		}

		public static Vector3 Cross(Vector3 vector1, Vector3 vector2)
		{
			return .(vector1.y * vector2.z - vector2.y * vector1.z,
				-(vector1.x * vector2.z - vector2.x * vector1.z),
				vector1.x * vector2.y - vector2.x * vector1.y);
		}

		public static float DistanceSquared(Vector3 value1, Vector3 value2)
		{
			return (value1.x - value2.x) * (value1.x - value2.x) +
				(value1.y - value2.y) * (value1.y - value2.y) +
				(value1.z - value2.z) * (value1.z - value2.z);
		}

		public static float Distance(Vector3 vector1, Vector3 vector2)
		{
			float result = DistanceSquared(vector1, vector2);
			return (float)Math.Sqrt(result);
		}

		public static Vector3 Transform(Vector3 vec, Matrix4 matrix)
		{
			return Vector4.Transform(vec.xyz1, matrix).xyz;
		}

		public static Vector3 Transform(Vector3 vec, Quaternion quat)
		{
			Matrix4 matrix = quat.ToMatrix();
			return Transform(vec, matrix);
		}

		public static Vector3 TransformNormal(Vector3 normal, Matrix4 matrix)
		{
			return Vector4.TransformNormal(normal.xyz0, matrix).xyz;
		}

		public static Vector3 TransformNormal(Vector3 normal, Quaternion quaternion)
		{
			let unitVector = quaternion.xyz;
			float unitLength = quaternion.w;
			return 2.0f * Vector3.Dot(unitVector, normal) * unitVector + (unitLength * unitLength - Vector3.Dot(unitVector, unitVector)) * normal + 2.0f * unitLength * Vector3.Cross(unitVector, normal);
		}

		public static bool operator==(Vector3 value1, Vector3 value2)
		{
			return (value1.x == value2.x) &&
				(value1.y == value2.y) &&
				(value1.z == value2.z);
		}

		public static bool operator!=(Vector3 value1, Vector3 value2)
		{
			return !(value1 == value2);
		}

		public static Vector3 operator-(Vector3 vec1)
		{
			return .(-vec1.x, -vec1.y, -vec1.z);
		}

		public static Vector3 operator+(Vector3 vec1, Vector3 vec2)
		{
			return .(vec1.x + vec2.x, vec1.y + vec2.y, vec1.z + vec2.z);
		}

		public static Vector3 operator-(Vector3 vec1, Vector3 vec2)
		{
			return .(vec1.x - vec2.x, vec1.y - vec2.y, vec1.z - vec2.z);
		}

		public static Vector3 operator*(Vector3 vec1, Vector3 vec2)
		{
			return .(vec1.x * vec2.x, vec1.y * vec2.y, vec1.z * vec2.z);
		}

		public static Vector3 operator/(Vector3 vec1, Vector3 vec2)
		{
			return .(vec1.x / vec2.x, vec1.y / vec2.y, vec1.z / vec2.z);
		}

		[Commutable]
		public static Vector3 operator*(Vector3 vec, float scale)
		{
			return .(vec.x * scale, vec.y * scale, vec.z * scale);
		}

		public static Vector3 operator/(Vector3 vec, float scale)
		{
			return .(vec.x / scale, vec.y / scale, vec.z / scale);
		}

		public override void ToString(String str)
		{
			str.AppendF("{0:0.0#}, {1:0.0#}, {2:0.0#}", x, y, z);
		}
	}
}
