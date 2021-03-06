using System;
using System.Collections;
using Dedkeni;

namespace AndroidTesting
{
	class LinkIssue
	{
		[AlwaysInclude(AssumeInstantiated = true, IncludeAllMethods = true), Reflect]
		class ModelAnimationPoint
		{
			[JSON_Beef.Serialized]
			public var position = Vector3.Zero;
			[JSON_Beef.Serialized]
			public var rotation = Vector3.Zero;
			[JSON_Beef.Serialized]
			public var time = 0.0f;
			[JSON_Beef.Serialized]
			public var smoothBlend = 0.0f;
			[JSON_Beef.Serialized]
			public Vector2 cameraPosition = .Zero;
			[JSON_Beef.Serialized]
			public bool loopStart = false;
			[JSON_Beef.Serialized]
			public bool loopEnd = false;
			[JSON_Beef.Serialized]
			public int loopCount = 0;
			[JSON_Beef.Serialized]
			public var animatedCamera = false;
			[JSON_Beef.Serialized]
			public var audioClipVolume = 1.0f;
			[JSON_Beef.Serialized]
			public var audioClipSpeed = 1.0f;
		}

		[AlwaysInclude(AssumeInstantiated = true, IncludeAllMethods = true), Reflect]
		class ModelEntity
		{
			[JSON_Beef.Serialized]
			public var animationPoints = new List<ModelAnimationPoint>() ~ DeleteContainerAndItems!(_);
		}

		public static int Main()
		{
			Matrix4 m;
			Matrix4.CreatePerspectiveOffCenter(0, 0, 0, 0, 0, 0, out m);

			var e = new ModelEntity();
			// Convert to json and save
			String json;
			switch (JSON_Beef.Serialization.JSONSerializer.Serialize<String>(e)) {
			case .Ok(let val):
				json = val;
			case .Err(let err):
				return 1;
			}

			var e2 = new ModelEntity();
			switch (JSON_Beef.Serialization.JSONDeserializer.Deserialize<ModelEntity>(json, e2)) {
			case .Ok:
			case .Err(let err):
				return 1;
			}

			delete json;
			delete e;
			delete e2;

			return m.v.m00 > 0 ? 1 : 0 + e.animationPoints.Count;
		}
	}
}
