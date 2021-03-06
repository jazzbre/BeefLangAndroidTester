using System;

namespace Dedkeni
{
	[CRepr, AlwaysInclude(AssumeInstantiated = true, IncludeAllMethods = true), Reflect]
	public struct Quaternion : IHashable, IEquatable<Quaternion>
	{
		[JSON_Beef.Serialized]
		public float x;
		[JSON_Beef.Serialized]
		public float y;
		[JSON_Beef.Serialized]
		public float z;
		[JSON_Beef.Serialized]
		public float w;

		public const Quaternion Identity = Quaternion(0, 0, 0, 1);

		public this()
		{
			this = default;
		}

		public this(float _x, float _y, float _z, float _w)
		{
			x = _x;
			y = _y;
			z = _z;
			w = _w;
		}

		public this(Vector3 vectorPart, float scalarPart)
		{
			x = vectorPart.x;
			y = vectorPart.y;
			z = vectorPart.z;
			w = scalarPart;
		}

		public static Quaternion Add(Quaternion quaternion1, Quaternion quaternion2)
		{
			Quaternion quaternion;
			quaternion.x = quaternion1.x + quaternion2.x;
			quaternion.y = quaternion1.y + quaternion2.y;
			quaternion.z = quaternion1.z + quaternion2.z;
			quaternion.w = quaternion1.w + quaternion2.w;
			return quaternion;
		}


		public static void Add(ref Quaternion quaternion1, ref Quaternion quaternion2, out Quaternion result)
		{
			result.x = quaternion1.x + quaternion2.x;
			result.y = quaternion1.y + quaternion2.y;
			result.z = quaternion1.z + quaternion2.z;
			result.w = quaternion1.w + quaternion2.w;
		}

		public static Quaternion Concatenate(Quaternion value1, Quaternion value2)
		{
			Quaternion quaternion;
			float x = value2.x;
			float y = value2.y;
			float z = value2.z;
			float w = value2.w;
			float num4 = value1.x;
			float num3 = value1.y;
			float num2 = value1.z;
			float num = value1.w;
			float num12 = (y * num2) - (z * num3);
			float num11 = (z * num4) - (x * num2);
			float num10 = (x * num3) - (y * num4);
			float num9 = ((x * num4) + (y * num3)) + (z * num2);
			quaternion.x = ((x * num) + (num4 * w)) + num12;
			quaternion.y = ((y * num) + (num3 * w)) + num11;
			quaternion.z = ((z * num) + (num2 * w)) + num10;
			quaternion.w = (w * num) - num9;
			return quaternion;
		}

		public static void Concatenate(ref Quaternion value1, ref Quaternion value2, out Quaternion result)
		{
			float x = value2.x;
			float y = value2.y;
			float z = value2.z;
			float w = value2.w;
			float num4 = value1.x;
			float num3 = value1.y;
			float num2 = value1.z;
			float num = value1.w;
			float num12 = (y * num2) - (z * num3);
			float num11 = (z * num4) - (x * num2);
			float num10 = (x * num3) - (y * num4);
			float num9 = ((x * num4) + (y * num3)) + (z * num2);
			result.x = ((x * num) + (num4 * w)) + num12;
			result.y = ((y * num) + (num3 * w)) + num11;
			result.z = ((z * num) + (num2 * w)) + num10;
			result.w = (w * num) - num9;
		}

		public void Conjugate() mut
		{
			x = -x;
			y = -y;
			z = -z;
		}

		public static Quaternion Conjugate(Quaternion value)
		{
			Quaternion quaternion;
			quaternion.x = -value.x;
			quaternion.y = -value.y;
			quaternion.z = -value.z;
			quaternion.w = value.w;
			return quaternion;
		}

		public static void Conjugate(ref Quaternion value, out Quaternion result)
		{
			result.x = -value.x;
			result.y = -value.y;
			result.z = -value.z;
			result.w = value.w;
		}

		public static Quaternion CreateFromAxisAngle(Vector3 axis, float angle)
		{
			Quaternion quaternion;
			float num2 = angle * 0.5f;
			float num = (float)Math.Sin((double)num2);
			float num3 = (float)Math.Cos((double)num2);
			quaternion.x = axis.x * num;
			quaternion.y = axis.y * num;
			quaternion.z = axis.z * num;
			quaternion.w = num3;
			return quaternion;
		}

		public static void CreateFromAxisAngle(ref Vector3 axis, float angle, out Quaternion result)
		{
			float num2 = angle * 0.5f;
			float num = (float)Math.Sin((double)num2);
			float num3 = (float)Math.Cos((double)num2);
			result.x = axis.x * num;
			result.y = axis.y * num;
			result.z = axis.z * num;
			result.w = num3;
		}

		public static Quaternion CreateFromRotationMatrix(Matrix4 matrix)
		{
			float num8 = (matrix.v.m11 + matrix.v.m22) + matrix.v.m33;
			Quaternion quaternion = Quaternion();
			if (num8 > 0f)
			{
				float num = (float)Math.Sqrt((double)(num8 + 1f));
				quaternion.w = num * 0.5f;
				num = 0.5f / num;
				quaternion.x = (matrix.v.m23 - matrix.v.m32) * num;
				quaternion.y = (matrix.v.m31 - matrix.v.m13) * num;
				quaternion.z = (matrix.v.m12 - matrix.v.m21) * num;
				return quaternion;
			}
			if ((matrix.v.m11 >= matrix.v.m22) && (matrix.v.m11 >= matrix.v.m33))
			{
				float num7 = (float)Math.Sqrt((double)(((1f + matrix.v.m11) - matrix.v.m22) - matrix.v.m33));
				float num4 = 0.5f / num7;
				quaternion.x = 0.5f * num7;
				quaternion.y = (matrix.v.m12 + matrix.v.m21) * num4;
				quaternion.z = (matrix.v.m13 + matrix.v.m31) * num4;
				quaternion.w = (matrix.v.m23 - matrix.v.m32) * num4;
				return quaternion;
			}
			if (matrix.v.m22 > matrix.v.m33)
			{
				float num6 = (float)Math.Sqrt((double)(((1f + matrix.v.m22) - matrix.v.m11) - matrix.v.m33));
				float num3 = 0.5f / num6;
				quaternion.x = (matrix.v.m21 + matrix.v.m12) * num3;
				quaternion.y = 0.5f * num6;
				quaternion.z = (matrix.v.m32 + matrix.v.m23) * num3;
				quaternion.w = (matrix.v.m31 - matrix.v.m13) * num3;
				return quaternion;
			}
			float num5 = (float)Math.Sqrt((double)(((1f + matrix.v.m33) - matrix.v.m11) - matrix.v.m22));
			float num2 = 0.5f / num5;
			quaternion.x = (matrix.v.m31 + matrix.v.m13) * num2;
			quaternion.y = (matrix.v.m32 + matrix.v.m23) * num2;
			quaternion.z = 0.5f * num5;
			quaternion.w = (matrix.v.m12 - matrix.v.m21) * num2;

			return quaternion;
		}

		public static void CreateFromRotationMatrix(ref Matrix4 matrix, out Quaternion result)
		{
			float num8 = (matrix.v.m11 + matrix.v.m22) + matrix.v.m33;
			if (num8 > 0f)
			{
				float num = (float)Math.Sqrt((double)(num8 + 1f));
				result.w = num * 0.5f;
				num = 0.5f / num;
				result.x = (matrix.v.m23 - matrix.v.m32) * num;
				result.y = (matrix.v.m31 - matrix.v.m13) * num;
				result.z = (matrix.v.m12 - matrix.v.m21) * num;
			}
			else if ((matrix.v.m11 >= matrix.v.m22) && (matrix.v.m11 >= matrix.v.m33))
			{
				float num7 = (float)Math.Sqrt((double)(((1f + matrix.v.m11) - matrix.v.m22) - matrix.v.m33));
				float num4 = 0.5f / num7;
				result.x = 0.5f * num7;
				result.y = (matrix.v.m12 + matrix.v.m21) * num4;
				result.z = (matrix.v.m13 + matrix.v.m31) * num4;
				result.w = (matrix.v.m23 - matrix.v.m32) * num4;
			}
			else if (matrix.v.m22 > matrix.v.m33)
			{
				float num6 = (float)Math.Sqrt((double)(((1f + matrix.v.m22) - matrix.v.m11) - matrix.v.m33));
				float num3 = 0.5f / num6;
				result.x = (matrix.v.m21 + matrix.v.m12) * num3;
				result.y = 0.5f * num6;
				result.z = (matrix.v.m32 + matrix.v.m23) * num3;
				result.w = (matrix.v.m31 - matrix.v.m13) * num3;
			}
			else
			{
				float num5 = (float)Math.Sqrt((double)(((1f + matrix.v.m33) - matrix.v.m11) - matrix.v.m22));
				float num2 = 0.5f / num5;
				result.x = (matrix.v.m31 + matrix.v.m13) * num2;
				result.y = (matrix.v.m32 + matrix.v.m23) * num2;
				result.z = 0.5f * num5;
				result.w = (matrix.v.m12 - matrix.v.m21) * num2;
			}
		}

		public static Quaternion CreateFromYawPitchRoll(float yaw, float pitch, float roll)
		{
			let cy = (float)Math.Cos(yaw * 0.5);
			let sy = (float)Math.Sin(yaw * 0.5);
			let cp = (float)Math.Cos(pitch * 0.5);
			let sp = (float)Math.Sin(pitch * 0.5);
			let cr = (float)Math.Cos(roll * 0.5);
			let sr = (float)Math.Sin(roll * 0.5);
			return .(cy * cp * sr - sy * sp * cr, sy * cp * sr + cy * sp * cr, sy * cp * cr - cy * sp * sr, cy * cp * cr + sy * sp * sr);
		}

		public static Quaternion Divide(Quaternion quaternion1, Quaternion quaternion2)
		{
			Quaternion quaternion;
			float x = quaternion1.x;
			float y = quaternion1.y;
			float z = quaternion1.z;
			float w = quaternion1.w;
			float num14 = (((quaternion2.x * quaternion2.x) + (quaternion2.y * quaternion2.y)) + (quaternion2.z * quaternion2.z)) + (quaternion2.w * quaternion2.w);
			float num5 = 1f / num14;
			float num4 = -quaternion2.x * num5;
			float num3 = -quaternion2.y * num5;
			float num2 = -quaternion2.z * num5;
			float num = quaternion2.w * num5;
			float num13 = (y * num2) - (z * num3);
			float num12 = (z * num4) - (x * num2);
			float num11 = (x * num3) - (y * num4);
			float num10 = ((x * num4) + (y * num3)) + (z * num2);
			quaternion.x = ((x * num) + (num4 * w)) + num13;
			quaternion.y = ((y * num) + (num3 * w)) + num12;
			quaternion.z = ((z * num) + (num2 * w)) + num11;
			quaternion.w = (w * num) - num10;
			return quaternion;
		}

		public static void Divide(ref Quaternion quaternion1, ref Quaternion quaternion2, out Quaternion result)
		{
			float x = quaternion1.x;
			float y = quaternion1.y;
			float z = quaternion1.z;
			float w = quaternion1.w;
			float num14 = (((quaternion2.x * quaternion2.x) + (quaternion2.y * quaternion2.y)) + (quaternion2.z * quaternion2.z)) + (quaternion2.w * quaternion2.w);
			float num5 = 1f / num14;
			float num4 = -quaternion2.x * num5;
			float num3 = -quaternion2.y * num5;
			float num2 = -quaternion2.z * num5;
			float num = quaternion2.w * num5;
			float num13 = (y * num2) - (z * num3);
			float num12 = (z * num4) - (x * num2);
			float num11 = (x * num3) - (y * num4);
			float num10 = ((x * num4) + (y * num3)) + (z * num2);
			result.x = ((x * num) + (num4 * w)) + num13;
			result.y = ((y * num) + (num3 * w)) + num12;
			result.z = ((z * num) + (num2 * w)) + num11;
			result.w = (w * num) - num10;
		}

		public static float Dot(Quaternion quaternion1, Quaternion quaternion2)
		{
			return ((((quaternion1.x * quaternion2.x) + (quaternion1.y * quaternion2.y)) + (quaternion1.z * quaternion2.z)) + (quaternion1.w * quaternion2.w));
		}

		public static void Dot(ref Quaternion quaternion1, ref Quaternion quaternion2, out float result)
		{
			result = (((quaternion1.x * quaternion2.x) + (quaternion1.y * quaternion2.y)) + (quaternion1.z * quaternion2.z)) + (quaternion1.w * quaternion2.w);
		}

		public bool Equals(Quaternion other)
		{
			return (x == other.x) && (y == other.y) && (z == other.z) && (w == other.w);
		}

		public int GetHashCode()
		{
			ThrowUnimplemented();
		}

		public static Quaternion Inverse(Quaternion quaternion)
		{
			Quaternion quaternion2;
			float num2 = (((quaternion.x * quaternion.x) + (quaternion.y * quaternion.y)) + (quaternion.z * quaternion.z)) + (quaternion.w * quaternion.w);
			float num = 1f / num2;
			quaternion2.x = -quaternion.x * num;
			quaternion2.y = -quaternion.y * num;
			quaternion2.z = -quaternion.z * num;
			quaternion2.w = quaternion.w * num;
			return quaternion2;
		}

		public static void Inverse(ref Quaternion quaternion, out Quaternion result)
		{
			float num2 = (((quaternion.x * quaternion.x) + (quaternion.y * quaternion.y)) + (quaternion.z * quaternion.z)) + (quaternion.w * quaternion.w);
			float num = 1f / num2;
			result.x = -quaternion.x * num;
			result.y = -quaternion.y * num;
			result.z = -quaternion.z * num;
			result.w = quaternion.w * num;
		}

		public float Length()
		{
			float num = (((x * x) + (y * y)) + (z * z)) + (w * w);
			return (float)Math.Sqrt((double)num);
		}

		public float LengthSquared()
		{
			return ((((x * x) + (y * y)) + (z * z)) + (w * w));
		}

		public static Quaternion Lerp(Quaternion quaternion1, Quaternion quaternion2, float amount)
		{
			float num = amount;
			float num2 = 1f - num;
			Quaternion quaternion = Quaternion();
			float num5 = (((quaternion1.x * quaternion2.x) + (quaternion1.y * quaternion2.y)) + (quaternion1.z * quaternion2.z)) + (quaternion1.w * quaternion2.w);
			if (num5 >= 0f)
			{
				quaternion.x = (num2 * quaternion1.x) + (num * quaternion2.x);
				quaternion.y = (num2 * quaternion1.y) + (num * quaternion2.y);
				quaternion.z = (num2 * quaternion1.z) + (num * quaternion2.z);
				quaternion.w = (num2 * quaternion1.w) + (num * quaternion2.w);
			}
			else
			{
				quaternion.x = (num2 * quaternion1.x) - (num * quaternion2.x);
				quaternion.y = (num2 * quaternion1.y) - (num * quaternion2.y);
				quaternion.z = (num2 * quaternion1.z) - (num * quaternion2.z);
				quaternion.w = (num2 * quaternion1.w) - (num * quaternion2.w);
			}
			float num4 = (((quaternion.x * quaternion.x) + (quaternion.y * quaternion.y)) + (quaternion.z * quaternion.z)) + (quaternion.w * quaternion.w);
			float num3 = 1f / ((float)Math.Sqrt((double)num4));
			quaternion.x *= num3;
			quaternion.y *= num3;
			quaternion.z *= num3;
			quaternion.w *= num3;
			return quaternion;
		}

		public static void Lerp(ref Quaternion quaternion1, ref Quaternion quaternion2, float amount, out Quaternion result)
		{
			float num = amount;
			float num2 = 1f - num;
			float num5 = (((quaternion1.x * quaternion2.x) + (quaternion1.y * quaternion2.y)) + (quaternion1.z * quaternion2.z)) + (quaternion1.w * quaternion2.w);
			if (num5 >= 0f)
			{
				result.x = (num2 * quaternion1.x) + (num * quaternion2.x);
				result.y = (num2 * quaternion1.y) + (num * quaternion2.y);
				result.z = (num2 * quaternion1.z) + (num * quaternion2.z);
				result.w = (num2 * quaternion1.w) + (num * quaternion2.w);
			}
			else
			{
				result.x = (num2 * quaternion1.x) - (num * quaternion2.x);
				result.y = (num2 * quaternion1.y) - (num * quaternion2.y);
				result.z = (num2 * quaternion1.z) - (num * quaternion2.z);
				result.w = (num2 * quaternion1.w) - (num * quaternion2.w);
			}
			float num4 = (((result.x * result.x) + (result.y * result.y)) + (result.z * result.z)) + (result.w * result.w);
			float num3 = 1f / ((float)Math.Sqrt((double)num4));
			result.x *= num3;
			result.y *= num3;
			result.z *= num3;
			result.w *= num3;
		}

		public static Quaternion Slerp(Quaternion quaternion1, Quaternion quaternion2, float amount)
		{
			float num2;
			float num3;
			Quaternion quaternion;
			float num = amount;
			float num4 = (((quaternion1.x * quaternion2.x) + (quaternion1.y * quaternion2.y)) + (quaternion1.z * quaternion2.z)) + (quaternion1.w * quaternion2.w);
			bool flag = false;
			if (num4 < 0f)
			{
				flag = true;
				num4 = -num4;
			}
			if (num4 > 0.999999f)
			{
				num3 = 1f - num;
				num2 = flag ? -num : num;
			}
			else
			{
				float num5 = (float)Math.Acos((double)num4);
				float num6 = (float)(1.0 / Math.Sin((double)num5));
				num3 = ((float)Math.Sin((double)((1f - num) * num5))) * num6;
				num2 = flag ? (((float)(-Math.Sin((double)(num * num5))) * num6)) : (((float)Math.Sin((double)(num * num5))) * num6);
			}
			quaternion.x = (num3 * quaternion1.x) + (num2 * quaternion2.x);
			quaternion.y = (num3 * quaternion1.y) + (num2 * quaternion2.y);
			quaternion.z = (num3 * quaternion1.z) + (num2 * quaternion2.z);
			quaternion.w = (num3 * quaternion1.w) + (num2 * quaternion2.w);
			return quaternion;
		}

		public static void Slerp(ref Quaternion quaternion1, ref Quaternion quaternion2, float amount, out Quaternion result)
		{
			float num2;
			float num3;
			float num = amount;
			float num4 = (((quaternion1.x * quaternion2.x) + (quaternion1.y * quaternion2.y)) + (quaternion1.z * quaternion2.z)) + (quaternion1.w * quaternion2.w);
			bool flag = false;
			if (num4 < 0f)
			{
				flag = true;
				num4 = -num4;
			}
			if (num4 > 0.999999f)
			{
				num3 = 1f - num;
				num2 = flag ? -num : num;
			}
			else
			{
				float num5 = (float)Math.Acos((double)num4);
				float num6 = (float)(1.0 / Math.Sin((double)num5));
				num3 = ((float)Math.Sin((double)((1f - num) * num5))) * num6;
				num2 = flag ? (((float)(-Math.Sin((double)(num * num5))) * num6)) : (((float)Math.Sin((double)(num * num5))) * num6);
			}
			result.x = (num3 * quaternion1.x) + (num2 * quaternion2.x);
			result.y = (num3 * quaternion1.y) + (num2 * quaternion2.y);
			result.z = (num3 * quaternion1.z) + (num2 * quaternion2.z);
			result.w = (num3 * quaternion1.w) + (num2 * quaternion2.w);
		}


		public static Quaternion Subtract(Quaternion quaternion1, Quaternion quaternion2)
		{
			Quaternion quaternion;
			quaternion.x = quaternion1.x - quaternion2.x;
			quaternion.y = quaternion1.y - quaternion2.y;
			quaternion.z = quaternion1.z - quaternion2.z;
			quaternion.w = quaternion1.w - quaternion2.w;
			return quaternion;
		}

		public static void Subtract(ref Quaternion quaternion1, ref Quaternion quaternion2, out Quaternion result)
		{
			result.x = quaternion1.x - quaternion2.x;
			result.y = quaternion1.y - quaternion2.y;
			result.z = quaternion1.z - quaternion2.z;
			result.w = quaternion1.w - quaternion2.w;
		}

		public static Quaternion Multiply(Quaternion quaternion1, Quaternion quaternion2)
		{
			Quaternion quaternion;
			float x = quaternion1.x;
			float y = quaternion1.y;
			float z = quaternion1.z;
			float w = quaternion1.w;
			float num4 = quaternion2.x;
			float num3 = quaternion2.y;
			float num2 = quaternion2.z;
			float num = quaternion2.w;
			float num12 = (y * num2) - (z * num3);
			float num11 = (z * num4) - (x * num2);
			float num10 = (x * num3) - (y * num4);
			float num9 = ((x * num4) + (y * num3)) + (z * num2);
			quaternion.x = ((x * num) + (num4 * w)) + num12;
			quaternion.y = ((y * num) + (num3 * w)) + num11;
			quaternion.z = ((z * num) + (num2 * w)) + num10;
			quaternion.w = (w * num) - num9;
			return quaternion;
		}

		public static Quaternion Multiply(Quaternion quaternion1, float scaleFactor)
		{
			Quaternion quaternion;
			quaternion.x = quaternion1.x * scaleFactor;
			quaternion.y = quaternion1.y * scaleFactor;
			quaternion.z = quaternion1.z * scaleFactor;
			quaternion.w = quaternion1.w * scaleFactor;
			return quaternion;
		}

		public static void Multiply(ref Quaternion quaternion1, float scaleFactor, out Quaternion result)
		{
			result.x = quaternion1.x * scaleFactor;
			result.y = quaternion1.y * scaleFactor;
			result.z = quaternion1.z * scaleFactor;
			result.w = quaternion1.w * scaleFactor;
		}

		public static void Multiply(ref Quaternion quaternion1, ref Quaternion quaternion2, out Quaternion result)
		{
			float x = quaternion1.x;
			float y = quaternion1.y;
			float z = quaternion1.z;
			float w = quaternion1.w;
			float num4 = quaternion2.x;
			float num3 = quaternion2.y;
			float num2 = quaternion2.z;
			float num = quaternion2.w;
			float num12 = (y * num2) - (z * num3);
			float num11 = (z * num4) - (x * num2);
			float num10 = (x * num3) - (y * num4);
			float num9 = ((x * num4) + (y * num3)) + (z * num2);
			result.x = ((x * num) + (num4 * w)) + num12;
			result.y = ((y * num) + (num3 * w)) + num11;
			result.z = ((z * num) + (num2 * w)) + num10;
			result.w = (w * num) - num9;
		}

		public static Quaternion Negate(Quaternion quaternion)
		{
			Quaternion quaternion2;
			quaternion2.x = -quaternion.x;
			quaternion2.y = -quaternion.y;
			quaternion2.z = -quaternion.z;
			quaternion2.w = -quaternion.w;
			return quaternion2;
		}

		public static void Negate(ref Quaternion quaternion, out Quaternion result)
		{
			result.x = -quaternion.x;
			result.y = -quaternion.y;
			result.z = -quaternion.z;
			result.w = -quaternion.w;
		}

		public void Normalize() mut
		{
			float num2 = (((x * x) + (y * y)) + (z * z)) + (w * w);
			float num = 1f / ((float)Math.Sqrt((double)num2));
			x *= num;
			y *= num;
			z *= num;
			w *= num;
		}

		public static Quaternion Normalize(Quaternion quaternion)
		{
			Quaternion quaternion2;
			float num2 = (((quaternion.x * quaternion.x) + (quaternion.y * quaternion.y)) + (quaternion.z * quaternion.z)) + (quaternion.w * quaternion.w);
			float num = 1f / ((float)Math.Sqrt((double)num2));
			quaternion2.x = quaternion.x * num;
			quaternion2.y = quaternion.y * num;
			quaternion2.z = quaternion.z * num;
			quaternion2.w = quaternion.w * num;
			return quaternion2;
		}

		public static void Normalize(ref Quaternion quaternion, out Quaternion result)
		{
			float num2 = (((quaternion.x * quaternion.x) + (quaternion.y * quaternion.y)) + (quaternion.z * quaternion.z)) + (quaternion.w * quaternion.w);
			float num = 1f / ((float)Math.Sqrt((double)num2));
			result.x = quaternion.x * num;
			result.y = quaternion.y * num;
			result.z = quaternion.z * num;
			result.w = quaternion.w * num;
		}

		public static Quaternion operator+(Quaternion quaternion1, Quaternion quaternion2)
		{
			Quaternion quaternion;
			quaternion.x = quaternion1.x + quaternion2.x;
			quaternion.y = quaternion1.y + quaternion2.y;
			quaternion.z = quaternion1.z + quaternion2.z;
			quaternion.w = quaternion1.w + quaternion2.w;
			return quaternion;
		}

		public static Quaternion operator/(Quaternion quaternion1, Quaternion quaternion2)
		{
			Quaternion quaternion;
			float x = quaternion1.x;
			float y = quaternion1.y;
			float z = quaternion1.z;
			float w = quaternion1.w;
			float num14 = (((quaternion2.x * quaternion2.x) + (quaternion2.y * quaternion2.y)) + (quaternion2.z * quaternion2.z)) + (quaternion2.w * quaternion2.w);
			float num5 = 1f / num14;
			float num4 = -quaternion2.x * num5;
			float num3 = -quaternion2.y * num5;
			float num2 = -quaternion2.z * num5;
			float num = quaternion2.w * num5;
			float num13 = (y * num2) - (z * num3);
			float num12 = (z * num4) - (x * num2);
			float num11 = (x * num3) - (y * num4);
			float num10 = ((x * num4) + (y * num3)) + (z * num2);
			quaternion.x = ((x * num) + (num4 * w)) + num13;
			quaternion.y = ((y * num) + (num3 * w)) + num12;
			quaternion.z = ((z * num) + (num2 * w)) + num11;
			quaternion.w = (w * num) - num10;
			return quaternion;
		}

		public static bool operator==(Quaternion quaternion1, Quaternion quaternion2)
		{
			return ((((quaternion1.x == quaternion2.x) && (quaternion1.y == quaternion2.y)) && (quaternion1.z == quaternion2.z)) && (quaternion1.w == quaternion2.w));
		}

		public static bool operator!=(Quaternion quaternion1, Quaternion quaternion2)
		{
			if (((quaternion1.x == quaternion2.x) && (quaternion1.y == quaternion2.y)) && (quaternion1.z == quaternion2.z))
				return (quaternion1.w != quaternion2.w);
			return true;
		}

		public static Quaternion operator*(Quaternion quaternion1, Quaternion quaternion2)
		{
			Quaternion quaternion;
			float x = quaternion1.x;
			float y = quaternion1.y;
			float z = quaternion1.z;
			float w = quaternion1.w;
			float num4 = quaternion2.x;
			float num3 = quaternion2.y;
			float num2 = quaternion2.z;
			float num = quaternion2.w;
			float num12 = (y * num2) - (z * num3);
			float num11 = (z * num4) - (x * num2);
			float num10 = (x * num3) - (y * num4);
			float num9 = ((x * num4) + (y * num3)) + (z * num2);
			quaternion.x = ((x * num) + (num4 * w)) + num12;
			quaternion.y = ((y * num) + (num3 * w)) + num11;
			quaternion.z = ((z * num) + (num2 * w)) + num10;
			quaternion.w = (w * num) - num9;
			return quaternion;
		}

		public static Quaternion operator*(Quaternion quaternion1, float scaleFactor)
		{
			Quaternion quaternion;
			quaternion.x = quaternion1.x * scaleFactor;
			quaternion.y = quaternion1.y * scaleFactor;
			quaternion.z = quaternion1.z * scaleFactor;
			quaternion.w = quaternion1.w * scaleFactor;
			return quaternion;
		}

		public static Quaternion operator-(Quaternion quaternion1, Quaternion quaternion2)
		{
			Quaternion quaternion;
			quaternion.x = quaternion1.x - quaternion2.x;
			quaternion.y = quaternion1.y - quaternion2.y;
			quaternion.z = quaternion1.z - quaternion2.z;
			quaternion.w = quaternion1.w - quaternion2.w;
			return quaternion;
		}

		public static Quaternion operator-(Quaternion quaternion)
		{
			Quaternion quaternion2;
			quaternion2.x = -quaternion.x;
			quaternion2.y = -quaternion.y;
			quaternion2.z = -quaternion.z;
			quaternion2.w = -quaternion.w;
			return quaternion2;
		}

		public override void ToString(String outStr)
		{
			ThrowUnimplemented();
		}

		public Matrix4 ToMatrix()
		{
			Matrix4 matrix = Matrix4.Identity;
			ToMatrix(out matrix);
			return matrix;
		}

		/*internal void ToMatrix(out Matrix4 matrix)
		{
			Quaternion.ToMatrix(this, out matrix);
		}*/

		public void ToMatrix(out Matrix4 matrix)
		{
			float fTx = x + x;
			float fTy = y + y;
			float fTz = z + z;
			float fTwx = fTx * w;
			float fTwy = fTy * w;
			float fTwz = fTz * w;
			float fTxx = fTx * x;
			float fTxy = fTy * x;
			float fTxz = fTz * x;
			float fTyy = fTy * y;
			float fTyz = fTz * y;
			float fTzz = fTz * z;

			matrix = Matrix4();
			matrix.v.m00 = 1.0f - (fTyy + fTzz);
			matrix.v.m01 = fTxy - fTwz;
			matrix.v.m02 = fTxz + fTwy;
			matrix.v.m03 = 0;

			matrix.v.m10 = fTxy + fTwz;
			matrix.v.m11 = 1.0f - (fTxx + fTzz);
			matrix.v.m12 = fTyz - fTwx;
			matrix.v.m13 = 0;

			matrix.v.m20 = fTxz - fTwy;
			matrix.v.m21 = fTyz + fTwx;
			matrix.v.m22 = 1.0f - (fTxx + fTyy);
			matrix.v.m23 = 0;

			matrix.v.m30 = 0;
			matrix.v.m31 = 0;
			matrix.v.m32 = 0;
			matrix.v.m33 = 1.0f;
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

		public Vector3 ToEulerAngles()
		{
			Vector3 angles;
			let q = this;

			// roll (x-axis rotation)
			let sinr_cosp = 2 * (q.w * q.x + q.y * q.z);
			let cosr_cosp = 1 - 2 * (q.x * q.x + q.y * q.y);
			angles.x = Math.Atan2(sinr_cosp, cosr_cosp);

			// pitch (y-axis rotation)
			let sinp = 2 * (q.w * q.y - q.z * q.x);
			if (Math.Abs(sinp) >= 1)
			{
				if (sinp < 0)
				{
					angles.y = -Math.PI_f / 2;// use 90 degrees if out of range
				} else
				{
					angles.y = Math.PI_f / 2;// use 90 degrees if out of range
				}
			}
			else
			{
				angles.y = Math.Asin(sinp);
			}

			// yaw (z-axis rotation)
			let siny_cosp = 2 * (q.w * q.z + q.x * q.y);
			let cosy_cosp = 1 - 2 * (q.y * q.y + q.z * q.z);
			angles.z = Math.Atan2(siny_cosp, cosy_cosp);

			return angles;
		}
	}
}