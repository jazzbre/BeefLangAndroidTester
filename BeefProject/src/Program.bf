using System;
using System.Collections;

namespace BeefProject
{
	class Program
	{
		[CLink] extern static int32 __android_log_write(int32 prio, char8* tag, char8* text);

		static void Log(StringView log)
		{
#if BF_PLATFORM_ANDROID
			__android_log_write(5, "BEEFLANG", log.Ptr);
#else
			Console.WriteLine(log);
#endif
		}

		class Test
		{
			public int TestFunc()
			{
				Log("Hello from func!");
				return 1234;
			}
		}

		[CRepr]
		struct Bounds
		{
			public double l, b, r, t;

			public this(double _l, double _b, double _r, double _t)
			{
				l = _l;
				b = _b;
				r = _r;
				t = _t;
			}
		}

		[CLink] extern static void* cpBoxShapeNew2(void* handle, Bounds bounds, double radius);

		public static void* AddBoxShape(void* handle, Bounds bounds, double radius)
		{
			Log(scope $"Calling cpBoxShapeNew2({handle}, ({bounds.l}, {bounds.b}, {bounds.r}, {bounds.t}), {radius}");
#if BF_PLATFORM_ANDROID
			return cpBoxShapeNew2(handle, bounds, radius);
#else
			return null;
#endif
		}

		[CRepr]
		struct Vec2
		{
			public float x, y;

			public this(float _x, float _y)
			{
				x = _x;
				y = _y;
			}
		}

		enum Cond : uint32
		{
			SomeShit = 7
		}

		[CLink] private static extern void* imguiSetNextWindowPos(Vec2 pos, Cond cond, Vec2 pivot);

		public static void* SetNextWindowPos(Vec2 pos, Cond cond, Vec2 pivot)
		{
			Log(scope $"Calling imguiSetNextWindowPos(({pos.x}, {pos.y}), {cond}, ({pivot.x}, {pivot.y})");
#if BF_PLATFORM_ANDROID
			return imguiSetNextWindowPos(pos, cond, pivot);
#else
			return null;
#endif
		}

		public static int32 Main(String[] arguments)
		{
			var test = new Test();
			var list = new List<int>();
			list.Add(1);
			Log(scope $"Beef main {test.TestFunc()} {list.Count} {AddBoxShape((void*)0x1337, .(1,2,3,4), 5)} {SetNextWindowPos(.(1,2), .SomeShit, .(3,4))} {AndroidTesting.LinkIssue.Main()}");
			return 0;
		}
	}
}
