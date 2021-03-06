using System;
using System.Collections;
using System.Reflection;
using JSON_Beef.Types;
using JSON_Beef.Util;

namespace JSON_Beef.Serialization
{
	public class JSONSerializer
	{
		public static Result<JSONObject> Serialize<T>(Object object) where T : JSONObject
		{
			if (object == null)
			{
				return .Err;
			}

			let json = new JSONObject();
			var type = object.GetType();
			var classFullName = scope String();
			type.GetFullName(classFullName);
			json.Add<String>(JSONUtil.classNameTag, classFullName);

			while (type != null)
			{
				var fields = type.GetFields();
				for (var field in fields)
				{
					if (AttributeChecker.ShouldIgnore(field))
					{
						continue;
					}

					let res = SerializeObjectInternal(object, type, field, json);

					if (res == .Err)
					{
						return .Err;
					}
				}

				type = type.BaseType;
			}

			return .Ok(json);
		}

		public static Result<JSONObject> Serialize<T>(Variant variant) where T : JSONObject
		{
			let json = new JSONObject();
			var type = variant.VariantType;

			while (type != null)
			{
				var fields = type.GetFields();
				for (var field in fields)
				{
					if (FieldHelper.HasFlag(field, .Static))
					{
						continue;
					}
					if (AttributeChecker.ShouldIgnore(field))
					{
						continue;
					}

					let res = SerializeStructInternal(variant, type, field, json);

					if (res == .Err)
					{
						return .Err;
					}
				}

				type = type.BaseType;
			}

			return .Ok(json);
		}


		public static Result<JSONArray> Serialize<T>(Object from) where T : JSONArray
		{
			var object = from;
			if (!TypeChecker.IsTypeList(object) || (object == null))
			{
				return .Err;
			}

			let jsonArray = new JSONArray();

			let type = object.GetType() as SpecializedGenericType;
			let genericType = type.GetGenericArg(0);

			if (TypeChecker.IsTypeList(genericType))
			{
				var list = (List<Object>*)&object;

				for (var item in *list)
				{
					let res = Serialize<JSONArray>(item);

					if (res == .Err)
					{
						return .Err;
					}

					jsonArray.Add<JSONArray>(res.Value);
					delete res.Value;
				}
			}
			else
			{
				switch (genericType)
				{
				case typeof(String):
					jsonArray.AddRange<String>(object);
				case typeof(int):
					jsonArray.AddRange<int>(object);
				case typeof(int8):
					jsonArray.AddRange<int8>(object);
				case typeof(int16):
					jsonArray.AddRange<int16>(object);
				case typeof(int32):
					jsonArray.AddRange<int32>(object);
				case typeof(int64):
					jsonArray.AddRange<int64>(object);
				case typeof(uint):
					jsonArray.AddRange<uint>(object);
				case typeof(uint8):
					jsonArray.AddRange<uint8>(object);
				case typeof(uint16):
					jsonArray.AddRange<uint16>(object);
				case typeof(uint32):
					jsonArray.AddRange<uint32>(object);
				case typeof(uint64):
					jsonArray.AddRange<uint64>(object);
				case typeof(char8):
					jsonArray.AddRange<char8>(object);
				case typeof(char16):
					jsonArray.AddRange<char16>(object);
				case typeof(char32):
					jsonArray.AddRange<char32>(object);
				case typeof(float):
					jsonArray.AddRange<float>(object);
				case typeof(double):
					jsonArray.AddRange<double>(object);
				case typeof(bool):
					jsonArray.AddRange<bool>(object);
				default:
					if (genericType.IsStruct)
					{
						var list = (List<int>*)&object;
						var count = (*list).Count;
						if (count > 0)
						{
							var first = (uint8*)&((*list)[0]);
							for (int i = 0; i < count; ++i)
							{
								var variant = Variant.CreateReference(genericType, first + i * genericType.Size);
								let res = Serialize<JSONObject>(variant);

								if (res == .Err)
								{
									return .Err;
								}

								jsonArray.Add<JSONObject>(res.Value);
								delete res.Value;
							}
						}
					} else
					{
						var list = (List<Object>*)&object;

						for (var item in *list)
						{
							let res = Serialize<JSONObject>(item);

							if (res == .Err)
							{
								return .Err;
							}

							jsonArray.Add<JSONObject>(res.Value);
							delete res.Value;
						}
					}
				}
			}

			return .Ok(jsonArray);
		}

		private static Result<void> SerializeFieldInternal(Variant fieldVariant, String fieldName, Type _fieldType, JSONObject json)
		{
			var fieldType = _fieldType;
			if (fieldType.IsEnum)
			{
				fieldType = fieldType.UnderlyingType;
			}
			if (fieldType.IsPrimitive)
			{
				switch (fieldType)
				{
				case typeof(int):
					json.Add<int>(fieldName, fieldVariant.Get<int>());
				case typeof(int8):
					json.Add<int8>(fieldName, fieldVariant.Get<int8>());
				case typeof(int16):
					json.Add<int16>(fieldName, fieldVariant.Get<int16>());
				case typeof(int32):
					json.Add<int32>(fieldName, fieldVariant.Get<int32>());
				case typeof(int64):
					json.Add<int64>(fieldName, fieldVariant.Get<int64>());
				case typeof(uint):
					json.Add<uint>(fieldName, fieldVariant.Get<uint>());
				case typeof(uint8):
					json.Add<uint8>(fieldName, fieldVariant.Get<uint8>());
				case typeof(uint16):
					json.Add<uint16>(fieldName, fieldVariant.Get<uint16>());
				case typeof(uint32):
					json.Add<uint32>(fieldName, fieldVariant.Get<uint32>());
				case typeof(uint64):
					json.Add<uint64>(fieldName, fieldVariant.Get<uint64>());
				case typeof(char8):
					json.Add<char8>(fieldName, fieldVariant.Get<char8>());
				case typeof(char16):
					json.Add<char16>(fieldName, fieldVariant.Get<char16>());
				case typeof(char32):
					json.Add<char32>(fieldName, fieldVariant.Get<char32>());
				case typeof(float):
					json.Add<float>(fieldName, fieldVariant.Get<float>());
				case typeof(double):
					json.Add<double>(fieldName, fieldVariant.Get<double>());
				case typeof(bool):
					json.Add<bool>(fieldName, fieldVariant.Get<bool>());
				default:
					return .Err;
				}
			}
			else if (fieldType.IsStruct)
			{
				let res = Serialize<JSONObject>(fieldVariant);

				if (res == .Err)
				{
					delete json;
					return .Err;
				}

				json.Add<JSONObject>(fieldName, res.Value);
				delete res.Value;
			}
			else if (fieldType.IsObject)
			{
				if (!fieldVariant.HasValue)
				{
					json.Add<Object>(fieldName, null);
					return .Ok;
				}

				var fieldValue = fieldVariant.Get<Object>();

				if (fieldValue == null)
				{
					json.Add<Object>(fieldName, null);
					return .Ok;
				}

				if (TypeChecker.IsTypeList(fieldValue))
				{
					let res = Serialize<JSONArray>(fieldValue);

					if (res == .Err)
					{
						return .Err;
					}

					json.Add<JSONArray>(fieldName, res.Value);
					delete res.Value;
				}
				else
				{
					switch (fieldType)
					{
					case typeof(String):
						json.Add<String>(fieldName, (String)fieldValue);
					default:
						let res = Serialize<JSONObject>(fieldValue);

						if (res == .Err)
						{
							delete json;
							return .Err;
						}

						json.Add<JSONObject>(fieldName, res.Value);
						delete res.Value;
					}
				}
			}

			return .Ok;
		}

		public static Result<String> Serialize<T>(Object from) where T : String
		{
			var object = from;
			let str = new String();

			if (TypeChecker.IsTypeList(object))
			{
				var obj = object;
				let res = Serialize<JSONArray>(obj);

				if (res == .Err)
				{
					delete str;
					return .Err;
				}

				res.Value.ToString(str);
				delete res.Value;
			}
			else
			{
				let res = Serialize<JSONObject>(object);

				if (res == .Err)
				{
					delete str;
					return .Err;
				}

				res.Value.ToString(str);
				delete res.Value;
			}
			return .Ok(str);
		}

		private static Result<void> SerializeObjectInternal(Object object, Type type, FieldInfo field, JSONObject json)
		{
			let fieldName = scope String(field.Name);
			let fieldType = field.FieldType;
			Variant fieldVariant;

			if (FieldHelper.HasFlag(field, .Static))
			{
				fieldVariant = field.GetValue(null).Get();
			}
			else
			{
				fieldVariant = field.GetValue(object).Get();
			}

			var result = SerializeFieldInternal(fieldVariant, fieldName, fieldType, json);
			fieldVariant.Dispose();
			return result;
		}

		private static Result<void> SerializeStructInternal(Variant variant, Type type, FieldInfo field, JSONObject json)
		{
			let fieldName = scope String(field.Name);
			let fieldType = field.FieldType;
			Variant fieldVariant;

			fieldVariant = field.GetValue(variant).Get();

			return SerializeFieldInternal(fieldVariant, fieldName, fieldType, json);
		}

		private static Result<void> SerializeArrayInternal(Object object, FieldInfo field, JSONArray json)
		{
			let fieldVariant = field.GetValue(object).Get();
			let fieldVariantType = fieldVariant.VariantType;
			var fieldValue = fieldVariant.Get<Object>();

			if (fieldValue == null)
			{
				json.Add<Object>(null);
			}
			else if (TypeChecker.IsTypeList(fieldValue))
			{
				let res = Serialize<JSONArray>(fieldValue);

				if (res == .Err)
				{
					return .Err;
				}

				json.Add<JSONArray>(res.Value);
				delete res.Value;
			}
			else
			{
				switch (fieldVariantType)
				{
				case typeof(String):
					json.Add<String>((String)fieldValue);
				case typeof(int):
					json.Add<int>((int)fieldValue);
				case typeof(int8):
					json.Add<int8>((int8)fieldValue);
				case typeof(int16):
					json.Add<int16>((int16)fieldValue);
				case typeof(int32):
					json.Add<int32>((int32)fieldValue);
				case typeof(int64):
					json.Add<int64>((int64)fieldValue);
				case typeof(uint):
					json.Add<uint>((uint)fieldValue);
				case typeof(uint8):
					json.Add<uint8>((uint8)fieldValue);
				case typeof(uint16):
					json.Add<uint16>((uint16)fieldValue);
				case typeof(uint32):
					json.Add<uint32>((uint32)fieldValue);
				case typeof(char8):
					json.Add<char8>((char8)fieldValue);
				case typeof(char16):
					json.Add<char16>((char16)fieldValue);
				case typeof(char32):
					json.Add<char32>((char32)fieldValue);
				case typeof(uint64):
					json.Add<uint64>((uint64)fieldValue);
				case typeof(float):
					json.Add<float>((float)fieldValue);
				case typeof(double):
					json.Add<double>((double)fieldValue);
				case typeof(bool):
					json.Add<bool>((bool)fieldValue);
				default:
					let res = Serialize<JSONObject>(fieldValue);

					if (res == .Err)
					{
						delete json;
						return .Err;
					}

					json.Add<JSONObject>(res.Value);
					delete res.Value;
				}
			}
			return .Ok;
		}
	}
}
