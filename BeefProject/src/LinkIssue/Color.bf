using System;

namespace Dedkeni
{
	[CRepr, AlwaysInclude(AssumeInstantiated = true, IncludeAllMethods = true), Reflect]
	public struct Color : IHashable, IEquatable<Color>
	{
		[JSON_Beef.Serialized]
		public float r;
		[JSON_Beef.Serialized]
		public float g;
		[JSON_Beef.Serialized]
		public float b;
		[JSON_Beef.Serialized]
		public float a;

		public const Color White = .(1, 1, 1, 1);
		public const Color Black = .(0, 0, 0, 1);
		public const Color Opaque = .(0, 0, 0, 0);
		public const Color Red = .(1, 0, 0, 1);
		public const Color Green = .(0, 1, 0, 1);
		public const Color Blue = .(0, 0, 1, 1);

		public this()
		{
			this = default;
		}

		public this(float _r, float _g, float _b, float _a = 1.0f)
		{
			r = _r;
			g = _g;
			b = _b;
			a = _a;
		}

		public this(Vector4 v)
		{
			r = v.x;
			g = v.y;
			b = v.z;
			a = v.w;
		}

		public Vector4 xyzw
		{
			get
			{
				return .(r, g, b, a);
			}
			set mut
			{
				r = value.x;
				g = value.y;
				b = value.z;
				a = value.w;
			}
		}

		public bool Equals(Color other)
		{
			return this == other;
		}

		public int GetHashCode()
		{
			return (int)(this.r + this.g + this.b + this.a);
		}

		public uint32 ToRGBA()
		{
			return ((uint32)(a * 255) << 24) | ((uint32)(b * 255) << 16) | ((uint32)(g * 255) << 8) | ((uint32)(r * 255));
		}

		public static Color Lerp(Color a, Color b, float delta)
		{
			return a + (b - a) * delta;
		}

		public static Color Lerp(Color a, Color b, Color delta)
		{
			return a + (b - a) * delta;
		}

		public static bool operator==(Color value1, Color value2)
		{
			return (value1.r == value2.r) &&
				(value1.g == value2.g) &&
				(value1.b == value2.b) &&
				(value1.a == value2.a);
		}

		public static bool operator!=(Color value1, Color value2)
		{
			return !(value1 == value2);
		}

		public static Color operator-(Color vec1)
		{
			return .(-vec1.r, -vec1.g, -vec1.b, -vec1.a);
		}

		public static Color operator+(Color vec1, Color vec2)
		{
			return .(vec1.r + vec2.r, vec1.g + vec2.g, vec1.b + vec2.b, vec1.a + vec2.a);
		}

		public static Color operator-(Color vec1, Color vec2)
		{
			return .(vec1.r - vec2.r, vec1.g - vec2.g, vec1.b - vec2.b, vec1.a - vec2.a);
		}

		public static Color operator*(Color vec1, Color vec2)
		{
			return .(vec1.r * vec2.r, vec1.g * vec2.g, vec1.b * vec2.b, vec1.a * vec2.a);
		}

		public static Color operator/(Color vec1, Color vec2)
		{
			return .(vec1.r / vec2.r, vec1.g / vec2.g, vec1.b / vec2.b, vec1.a / vec2.a);
		}

		[Commutable]
		public static Color operator*(Color vec, float scale)
		{
			return .(vec.r * scale, vec.g * scale, vec.b * scale, vec.a * scale);
		}

		public static Color operator/(Color vec, float scale)
		{
			return .(vec.r / scale, vec.g / scale, vec.b / scale, vec.a / scale);
		}

		public override void ToString(String str)
		{
			str.AppendF("{0:0.0#}, {1:0.0#}, {2:0.0#}, {3:0.0#}", r, g, b, a);
		}

	}
}
