namespace Dedkeni
{
	class Curve
	{
		public static Vector2 CatmullCurve(Vector2 p0, Vector2 p1, Vector2 p2, Vector2 p3, float t)
		{
			let two = 2.0f;
			let three = 3.0f;
			let four = 4.0f;
			let five = 5.0f;
			let half = 0.5f;
			let t2 = t * t;
			let t3 = t2 * t;
			return ((p1 * two) + (p2 - p0) * t + (p0 * two - p1 * five + p2 * four - p3) * t2 + (p1 * three - p2 * three + p3 - p0) * t3) * half;
		}

		public static Vector3 CatmullCurve(Vector3 p0, Vector3 p1, Vector3 p2, Vector3 p3, float t)
		{
			let two = 2.0f;
			let three = 3.0f;
			let four = 4.0f;
			let five = 5.0f;
			let half = 0.5f;
			let t2 = t * t;
			let t3 = t2 * t;
			return ((p1 * two) + (p2 - p0) * t + (p0 * two - p1 * five + p2 * four - p3) * t2 + (p1 * three - p2 * three + p3 - p0) * t3) * half;
		}

		public static Vector4 CatmullCurve(Vector4 p0, Vector4 p1, Vector4 p2, Vector4 p3, float t)
		{
			let two = 2.0f;
			let three = 3.0f;
			let four = 4.0f;
			let five = 5.0f;
			let half = 0.5f;
			let t2 = t * t;
			let t3 = t2 * t;
			return ((p1 * two) + (p2 - p0) * t + (p0 * two - p1 * five + p2 * four - p3) * t2 + (p1 * three - p2 * three + p3 - p0) * t3) * half;
		}

		public static Vector2 BezierQuadraticCurve(Vector2 p0, Vector2 p1, Vector2 p2, float b)
		{
			let two = Vector2(2.0f);
			let a = 1.0f - b;
			let a2 = a * a;
			let b2 = b * b;
			let ab_m2 = two * a * b;
			return (p0 * a2 + p1 * ab_m2 + p2 * b2);
		}

		public static Vector3 BezierQuadraticCurve(Vector3 p0, Vector3 p1, Vector3 p2, float b)
		{
			let two = Vector3(2.0f);
			let a = 1.0f - b;
			let a2 = a * a;
			let b2 = b * b;
			let ab_m2 = two * a * b;
			return (p0 * a2 + p1 * ab_m2 + p2 * b2);
		}

		public static Vector4 BezierQuadraticCurve(Vector4 p0, Vector4 p1, Vector4 p2, float b)
		{
			let two = Vector4(2.0f);
			let a = 1.0f - b;
			let a2 = a * a;
			let b2 = b * b;
			let ab_m2 = two * a * b;
			return (p0 * a2 + p1 * ab_m2 + p2 * b2);
		}

	}
}
