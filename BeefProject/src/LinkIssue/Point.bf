using System;
using System.Collections;
using System.Text;

namespace Dedkeni
{
	[CRepr, AlwaysInclude(AssumeInstantiated = true, IncludeAllMethods = true), Reflect]
	public struct Point
	{
		[JSON_Beef.Serialized]
		public float x;
		[JSON_Beef.Serialized]
		public float y;

		public this(float _x, float _y)
		{
			x = _x;
			y = _y;
		}
	}
}
