using System;
using System.Diagnostics;
using System.Collections;
using System.Text;
using System.Threading.Tasks;

namespace Dedkeni
{
	[CRepr, Union]
	public struct Matrix4
	{
		[CRepr]
		public struct Values
		{
			public float m00;
			public float m01;
			public float m02;
			public float m03;
			public float m10;
			public float m11;
			public float m12;
			public float m13;
			public float m20;
			public float m21;
			public float m22;
			public float m23;
			public float m30;
			public float m31;
			public float m32;
			public float m33;
		}
		[CRepr]
		public struct Rows
		{
			public Vector4 RowX;
			public Vector4 RowY;
			public Vector4 RowZ;
			public Vector4 RowW;
		}
		public Values v;
		public Rows r;
		public float[4][4] f;
		public float[16] d;

		public static readonly Matrix4 Identity = Matrix4(1f, 0f, 0f, 0f,
			0f, 1f, 0f, 0f,
			0f, 0f, 1f, 0f,
			0f, 0f, 0f, 1f);

		public this()
		{
			this = Identity;
		}

		public this(
			float m00, float m01, float m02, float m03,
			float m10, float m11, float m12, float m13,
			float m20, float m21, float m22, float m23,
			float m30, float m31, float m32, float m33)
		{
			this = Identity;
			this.v.m00 = m00;
			this.v.m01 = m01;
			this.v.m02 = m02;
			this.v.m03 = m03;
			this.v.m10 = m10;
			this.v.m11 = m11;
			this.v.m12 = m12;
			this.v.m13 = m13;
			this.v.m20 = m20;
			this.v.m21 = m21;
			this.v.m22 = m22;
			this.v.m23 = m23;
			this.v.m30 = m30;
			this.v.m31 = m31;
			this.v.m32 = m32;
			this.v.m33 = m33;
		}

		public void* Ptr() mut { return &v.m00; }

		public Vector3 Right
		{
			get
			{
				return Vector3(v.m00, v.m01, v.m02);
			}
			set mut
			{
				v.m00 = value.x;
				v.m01 = value.y;
				v.m02 = value.z;
			}
		}

		public Vector3 Up
		{
			get
			{
				return Vector3(v.m10, v.m11, v.m12);
			}
			set mut
			{
				v.m10 = value.x;
				v.m11 = value.y;
				v.m12 = value.z;
			}
		}

		public Vector3 Forward
		{
			get
			{
				return Vector3(v.m20, v.m21, v.m22);
			}
			set mut
			{
				v.m20 = value.x;
				v.m21 = value.y;
				v.m22 = value.z;
			}
		}

		public Vector3 Translation
		{
			get
			{
				return Vector3(v.m30, v.m31, v.m32);
			}
			set mut
			{
				v.m30 = value.x;
				v.m31 = value.y;
				v.m32 = value.z;
			}
		}

		public Vector4 GetColumn4(int index)
		{
			return Vector4(f[0][index], f[1][index], f[2][index], f[3][index]);
		}

		public Vector3 GetColumn3(int index)
		{
			return Vector3(f[0][index], f[1][index], f[2][index]);
		}


		public Vector4 GetRow4(int index)
		{
			return Vector4(f[index][0], f[index][1], f[index][2], f[index][3]);
		}

		public Vector3 GetRow3(int index)
		{
			return Vector3(f[index][0], f[index][1], f[index][2]);
		}

		public static Matrix4 CreatePerspective(float width, float height, float nearPlaneDistance, float farPlaneDistance)
		{
			var matrix = Matrix4.Identity;
			if (nearPlaneDistance <= 0f)
			{
				Runtime.FatalError("nearPlaneDistance <= 0");
			}
			if (farPlaneDistance <= 0f)
			{
				Runtime.FatalError("farPlaneDistance <= 0");
			}
			if (nearPlaneDistance >= farPlaneDistance)
			{
				Runtime.FatalError("nearPlaneDistance >= farPlaneDistance");
			}
			matrix.v.m00 = (2f * nearPlaneDistance) / width;
			matrix.v.m10 = matrix.v.m20 = matrix.v.m30 = 0f;
			matrix.v.m11 = (2f * nearPlaneDistance) / height;
			matrix.v.m01 = matrix.v.m21 = matrix.v.m31 = 0f;
			matrix.v.m22 = farPlaneDistance / (nearPlaneDistance - farPlaneDistance);
			matrix.v.m02 = matrix.v.m12 = 0f;
			matrix.v.m32 = -1f;
			matrix.v.m03 = matrix.v.m13 = matrix.v.m33 = 0f;
			matrix.v.m23 = (nearPlaneDistance * farPlaneDistance) / (nearPlaneDistance - farPlaneDistance);

			return matrix;
		}

		public static Matrix4 CreatePerspectiveFieldOfView(float fieldOfView, float aspectRatio, float nearPlaneDistance, float farPlaneDistance)
		{
			var result = Matrix4.Identity;
			CreatePerspectiveFieldOfView(fieldOfView, aspectRatio, nearPlaneDistance, farPlaneDistance, out result);
			return result;
		}

		public static void CreatePerspectiveFieldOfView(float fieldOfView, float aspectRatio, float nearPlaneDistance, float farPlaneDistance, out Matrix4 result)
		{
			if ((fieldOfView <= 0f) || (fieldOfView >= 3.141593f))
			{
				Runtime.FatalError("fieldOfView <= 0 or >= PI");
			}
			if (nearPlaneDistance <= 0f)
			{
				Runtime.FatalError("nearPlaneDistance <= 0");
			}
			if (farPlaneDistance <= 0f)
			{
				Runtime.FatalError("farPlaneDistance <= 0");
			}
			if (nearPlaneDistance >= farPlaneDistance)
			{
				Runtime.FatalError("nearPlaneDistance >= farPlaneDistance");
			}
			float num = 1f / ((float)Math.Tan((double)(fieldOfView * 0.5f)));
			float num9 = num / aspectRatio;
			result = Matrix4.Identity;
			result.v.m00 = num9;
			result.v.m10 = result.v.m20 = result.v.m30 = 0;
			result.v.m11 = num;
			result.v.m01 = result.v.m21 = result.v.m31 = 0;
			result.v.m02 = result.v.m12 = 0f;
			result.v.m22 = farPlaneDistance / (nearPlaneDistance - farPlaneDistance);
			result.v.m32 = -1;
			result.v.m03 = result.v.m13 = result.v.m33 = 0;
			result.v.m23 = (nearPlaneDistance * farPlaneDistance) / (nearPlaneDistance - farPlaneDistance);
		}


		public static Matrix4 CreatePerspectiveOffCenter(float left, float right, float bottom, float top, float nearPlaneDistance, float farPlaneDistance)
		{
			var result = Matrix4.Identity;
			CreatePerspectiveOffCenter(left, right, bottom, top, nearPlaneDistance, farPlaneDistance, out result);
			return result;
		}


		public static void CreatePerspectiveOffCenter(float left, float right, float bottom, float top, float nearPlaneDistance, float farPlaneDistance, out Matrix4 result)
		{
			if (nearPlaneDistance <= 0f)
			{
				Runtime.FatalError("nearPlaneDistance <= 0");
			}
			if (farPlaneDistance <= 0f)
			{
				Runtime.FatalError("farPlaneDistance <= 0");
			}
			if (nearPlaneDistance >= farPlaneDistance)
			{
				Runtime.FatalError("nearPlaneDistance >= farPlaneDistance");
			}
			//result = Matrix4.Identity;
			result.v.m00 = (2f * nearPlaneDistance) / (right - left);
			result.v.m10 = result.v.m20 = result.v.m30 = 0;
			result.v.m11 = (2f * nearPlaneDistance) / (top - bottom);
			result.v.m01 = result.v.m21 = result.v.m31 = 0;
			result.v.m02 = (left + right) / (right - left);
			result.v.m12 = (top + bottom) / (top - bottom);
			result.v.m22 = farPlaneDistance / (nearPlaneDistance - farPlaneDistance);
			result.v.m32 = -1;
			result.v.m23 = (nearPlaneDistance * farPlaneDistance) / (nearPlaneDistance - farPlaneDistance);
			result.v.m03 = result.v.m13 = result.v.m33 = 0;
		}

		public static Matrix4 Multiply(Matrix4 m1, Matrix4 m2)
		{
			var r = Matrix4.Identity;
			r.v.m00 = m1.v.m00 * m2.v.m00 + m1.v.m01 * m2.v.m10 + m1.v.m02 * m2.v.m20 + m1.v.m03 * m2.v.m30;
			r.v.m01 = m1.v.m00 * m2.v.m01 + m1.v.m01 * m2.v.m11 + m1.v.m02 * m2.v.m21 + m1.v.m03 * m2.v.m31;
			r.v.m02 = m1.v.m00 * m2.v.m02 + m1.v.m01 * m2.v.m12 + m1.v.m02 * m2.v.m22 + m1.v.m03 * m2.v.m32;
			r.v.m03 = m1.v.m00 * m2.v.m03 + m1.v.m01 * m2.v.m13 + m1.v.m02 * m2.v.m23 + m1.v.m03 * m2.v.m33;

			r.v.m10 = m1.v.m10 * m2.v.m00 + m1.v.m11 * m2.v.m10 + m1.v.m12 * m2.v.m20 + m1.v.m13 * m2.v.m30;
			r.v.m11 = m1.v.m10 * m2.v.m01 + m1.v.m11 * m2.v.m11 + m1.v.m12 * m2.v.m21 + m1.v.m13 * m2.v.m31;
			r.v.m12 = m1.v.m10 * m2.v.m02 + m1.v.m11 * m2.v.m12 + m1.v.m12 * m2.v.m22 + m1.v.m13 * m2.v.m32;
			r.v.m13 = m1.v.m10 * m2.v.m03 + m1.v.m11 * m2.v.m13 + m1.v.m12 * m2.v.m23 + m1.v.m13 * m2.v.m33;

			r.v.m20 = m1.v.m20 * m2.v.m00 + m1.v.m21 * m2.v.m10 + m1.v.m22 * m2.v.m20 + m1.v.m23 * m2.v.m30;
			r.v.m21 = m1.v.m20 * m2.v.m01 + m1.v.m21 * m2.v.m11 + m1.v.m22 * m2.v.m21 + m1.v.m23 * m2.v.m31;
			r.v.m22 = m1.v.m20 * m2.v.m02 + m1.v.m21 * m2.v.m12 + m1.v.m22 * m2.v.m22 + m1.v.m23 * m2.v.m32;
			r.v.m23 = m1.v.m20 * m2.v.m03 + m1.v.m21 * m2.v.m13 + m1.v.m22 * m2.v.m23 + m1.v.m23 * m2.v.m33;

			r.v.m30 = m1.v.m30 * m2.v.m00 + m1.v.m31 * m2.v.m10 + m1.v.m32 * m2.v.m20 + m1.v.m33 * m2.v.m30;
			r.v.m31 = m1.v.m30 * m2.v.m01 + m1.v.m31 * m2.v.m11 + m1.v.m32 * m2.v.m21 + m1.v.m33 * m2.v.m31;
			r.v.m32 = m1.v.m30 * m2.v.m02 + m1.v.m31 * m2.v.m12 + m1.v.m32 * m2.v.m22 + m1.v.m33 * m2.v.m32;
			r.v.m33 = m1.v.m30 * m2.v.m03 + m1.v.m31 * m2.v.m13 + m1.v.m32 * m2.v.m23 + m1.v.m33 * m2.v.m33;

			return r;
		}

		public static Matrix4 Transpose(Matrix4 m)
		{
			return Matrix4(
				m.v.m00, m.v.m10, m.v.m20, m.v.m30,
				m.v.m01, m.v.m11, m.v.m21, m.v.m31,
				m.v.m02, m.v.m12, m.v.m22, m.v.m32,
				m.v.m03, m.v.m13, m.v.m23, m.v.m33);
		}

		public static Matrix4 CreateTranslation(float x, float y, float z)
		{
			return Matrix4(
				1, 0, 0, x,
				0, 1, 0, y,
				0, 0, 1, z,
				0, 0, 0, 1);
		}

		public static Matrix4 CreateTransform(Vector3 position, Vector3 scale, Quaternion orientation)
		{

			// // Ordering: 1. Scale 2. Rotate 3. Translate

			Matrix4 rot = orientation.ToMatrix();
			return Matrix4(
				scale.x * rot.v.m00, scale.y * rot.v.m01, scale.z * rot.v.m02, position.x,
				scale.x * rot.v.m10, scale.y * rot.v.m11, scale.z * rot.v.m12, position.y,
				scale.x * rot.v.m20, scale.y * rot.v.m21, scale.z * rot.v.m22, position.z,
				0, 0, 0, 1);
		}

		public static Matrix4 CreateRotationX(float radians)
		{
			Matrix4 result = Matrix4.Identity;

			var val1 = (float)Math.Cos(radians);
			var val2 = (float)Math.Sin(radians);

			result.v.m11 = val1;
			result.v.m21 = val2;
			result.v.m12 = -val2;
			result.v.m22 = val1;

			return result;
		}

		public static Matrix4 CreateRotationY(float radians)
		{
			Matrix4 returnMatrix = Matrix4.Identity;

			var val1 = (float)Math.Cos(radians);
			var val2 = (float)Math.Sin(radians);

			returnMatrix.v.m00 = val1;
			returnMatrix.v.m20 = -val2;
			returnMatrix.v.m02 = val2;
			returnMatrix.v.m22 = val1;

			return returnMatrix;
		}

		public static Matrix4 CreateRotationZ(float radians)
		{
			Matrix4 returnMatrix = Matrix4.Identity;

			var val1 = (float)Math.Cos(radians);
			var val2 = (float)Math.Sin(radians);

			returnMatrix.v.m00 = val1;
			returnMatrix.v.m10 = val2;
			returnMatrix.v.m01 = -val2;
			returnMatrix.v.m11 = val1;

			return returnMatrix;
		}

		public static Matrix4 CreateScale(float scale)
		{
			var result = Matrix4.Identity;
			result.v.m00 = scale;
			result.v.m10 = 0;
			result.v.m20 = 0;
			result.v.m30 = 0;
			result.v.m01 = 0;
			result.v.m11 = scale;
			result.v.m21 = 0;
			result.v.m31 = 0;
			result.v.m02 = 0;
			result.v.m12 = 0;
			result.v.m22 = scale;
			result.v.m32 = 0;
			result.v.m03 = 0;
			result.v.m13 = 0;
			result.v.m23 = 0;
			result.v.m33 = 1;
			return result;
		}

		public static Matrix4 CreateScale(float xScale, float yScale, float zScale)
		{
			var result = Matrix4.Identity;
			result.v.m00 = xScale;
			result.v.m10 = 0;
			result.v.m20 = 0;
			result.v.m30 = 0;
			result.v.m01 = 0;
			result.v.m11 = yScale;
			result.v.m21 = 0;
			result.v.m31 = 0;
			result.v.m02 = 0;
			result.v.m12 = 0;
			result.v.m22 = zScale;
			result.v.m32 = 0;
			result.v.m03 = 0;
			result.v.m13 = 0;
			result.v.m23 = 0;
			result.v.m33 = 1;
			return result;
		}

		public static Matrix4 CreateScale(Vector3 scales)
		{
			var result = Matrix4.Identity;
			result.v.m00 = scales.x;
			result.v.m10 = 0;
			result.v.m20 = 0;
			result.v.m30 = 0;
			result.v.m01 = 0;
			result.v.m11 = scales.y;
			result.v.m21 = 0;
			result.v.m31 = 0;
			result.v.m02 = 0;
			result.v.m12 = 0;
			result.v.m22 = scales.z;
			result.v.m32 = 0;
			result.v.m03 = 0;
			result.v.m13 = 0;
			result.v.m23 = 0;
			result.v.m33 = 1;
			return result;
		}

		public static Matrix4 CreateTranslation(Vector3 position)
		{
			var result = Matrix4.Identity;
			result.v.m00 = 1;
			result.v.m10 = 0;
			result.v.m20 = 0;
			result.v.m30 = 0;
			result.v.m01 = 0;
			result.v.m11 = 1;
			result.v.m21 = 0;
			result.v.m31 = 0;
			result.v.m02 = 0;
			result.v.m12 = 0;
			result.v.m22 = 1;
			result.v.m32 = 0;
			result.v.m03 = position.x;
			result.v.m13 = position.y;
			result.v.m23 = position.z;
			result.v.m33 = 1;
			return result;
		}

		public static Matrix4 CreatePerspectiveOrtho(float _left, float _right, float _bottom, float _top, float _near, float _far, float _offset, bool _homogeneousNdc, bool _handnessRight = false)
		{
			let aa = 2.0f / (_right - _left);
			let bb = 2.0f / (_top - _bottom);
			let cc = (_homogeneousNdc ? 2.0f : 1.0f) / (_far - _near);
			let dd = (_left + _right) / (_left - _right);
			let ee = (_top + _bottom) / (_bottom - _top);
			let ff = _homogeneousNdc ? (_near + _far) / (_near - _far) : _near / (_near - _far);
			var m = Identity;
			m.v.m00 = aa;
			m.v.m11 = bb;
			m.v.m22 = _handnessRight ? -cc : cc;
			m.v.m30 = dd + _offset;
			m.v.m31 = ee;
			m.v.m32 = ff;
			m.v.m33 = 1.0f;
			return m;
		}

		public static void CreatePerspective(float _x, float _y, float _width, float _height, float _near, float _far, bool _homogeneousNdc, bool _handnessRight = false)
		{
			let diff = _far - _near;
			let aa = _homogeneousNdc ? (_far + _near) / diff : _far / diff;
			let bb = _homogeneousNdc ? (2.0f * _far * _near) / diff : _near * aa;

			var m = Identity;
			m.d[0] = _width;
			m.d[5] = _height;
			m.d[8] = _handnessRight ? _x : -_x;
			m.d[9] = _handnessRight ? _y : -_y;
			m.d[10] = _handnessRight ? -aa : aa;
			m.d[11] = _handnessRight ? -1.0f : 1.0f;
			m.d[14] = -bb;
		}

		bool IsAffine()
		{
			return v.m30 == 0 && v.m31 == 0 && v.m32 == 0 && v.m33 == 1;
		}

		public static Matrix4 InverseAffine(Matrix4 mtx)
		{
			Debug.Assert(mtx.IsAffine());

			float m10 = mtx.v.m10, m11 = mtx.v.m11, m12 = mtx.v.m12;
			float m20 = mtx.v.m20, m21 = mtx.v.m21, m22 = mtx.v.m22;

			float t00 = m22 * m11 - m21 * m12;
			float t10 = m20 * m12 - m22 * m10;
			float t20 = m21 * m10 - m20 * m11;

			float m00 = mtx.v.m00, m01 = mtx.v.m01, m02 = mtx.v.m02;

			float invDet = 1 / (m00 * t00 + m01 * t10 + m02 * t20);

			t00 *= invDet; t10 *= invDet; t20 *= invDet;

			m00 *= invDet; m01 *= invDet; m02 *= invDet;

			float r00 = t00;
			float r01 = m02 * m21 - m01 * m22;
			float r02 = m01 * m12 - m02 * m11;

			float r10 = t10;
			float r11 = m00 * m22 - m02 * m20;
			float r12 = m02 * m10 - m00 * m12;

			float r20 = t20;
			float r21 = m01 * m20 - m00 * m21;
			float r22 = m00 * m11 - m01 * m10;

			float m03 = mtx.v.m03, m13 = mtx.v.m13, m23 = mtx.v.m23;

			float r03 = -(r00 * m03 + r01 * m13 + r02 * m23);
			float r13 = -(r10 * m03 + r11 * m13 + r12 * m23);
			float r23 = -(r20 * m03 + r21 * m13 + r22 * m23);

			return Matrix4(
				r00, r01, r02, r03,
				r10, r11, r12, r13,
				r20, r21, r22, r23,
				0, 0, 0, 1);
		}

		public static Matrix4 operator*(Matrix4 mat1, Matrix4 mat2)
		{
			return Multiply(mat1, mat2);
		}
	}
}
