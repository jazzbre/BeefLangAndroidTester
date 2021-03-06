using System;
using System.Collections;
using JSON_Beef.Util;
using JSON_Beef.Types;

namespace JSON_Beef.Serialization
{
	enum JSON_DOCUMENT_TYPE
	{
		OBJECT,
		ARRAY,
		UNKNOWN
	}

	public static class JSONParser
	{
		private static Dictionary<char8, char8> escapedChar;

		static this()
		{
			escapedChar = new Dictionary<char8, char8>();
			escapedChar.Add('\\', '\\');
			escapedChar.Add('"', '"');
			escapedChar.Add('b', '\b');
			escapedChar.Add('f', '\f');
			escapedChar.Add('n', '\n');
			escapedChar.Add('r', '\r');
			escapedChar.Add('t', '\t');
			escapedChar.Add('/', '/');
		}

		static ~this()
		{
			delete escapedChar;
		}

		public static bool IsValidJson(StringView json)
		{
			return JSONValidator.IsValidJson(json);
		}

		public static JSON_DOCUMENT_TYPE GetJsonType(StringView json)
		{
			let token = json[0];

			if (token == '{')
			{
				return JSON_DOCUMENT_TYPE.OBJECT;
			}
			else if (token == '[')
			{
				return JSON_DOCUMENT_TYPE.ARRAY;
			}
			else
			{
				return JSON_DOCUMENT_TYPE.UNKNOWN;
			}
		}

		public static Result<JSONArray, JSON_ERRORS> ParseArray(StringView json)
		{
			var array = new JSONArray();
			if (ParseArrayInternal(json, ref array) case .Err(let err))
			{
				delete array;
				return .Err(err);
			}
			return array;
		}

		public static Result<void, JSON_ERRORS> ParseArray(StringView json, ref JSONArray array)
		{
			if (ParseArrayInternal(json, ref array) case .Err(let err))
			{
				return .Err(err);
			}

			return .Ok;
		}

		public static Result<JSONObject, JSON_ERRORS> ParseObject(StringView json)
		{
			var object = new JSONObject();
			if (ParseObjectInternal(json, ref object) case .Err(let err))
			{
				delete object;
				return .Err(err);
			}
			return object;
		}

		public static Result<void, JSON_ERRORS> ParseObject(StringView json, ref JSONObject object)
		{
			if (ParseObjectInternal(json, ref object) case .Err(let err))
			{
				return .Err(err);
			}

			return .Ok;
		}

		private static Result<int, JSON_ERRORS> ParseString(StringView json, String outString)
		{
			int i;
			outString.Clear();
			var escaped = false;

			for (i = 0; i < json.Length; i++)
			{
				let c = json[i];

				if ((c == '\\') && !escaped)
				{
					escaped = true;
				}
				else if (escapedChar.ContainsKey(c) && escaped)
				{
					outString.Append(escapedChar[c]);
					escaped = false;
				}
				else if ((c == '"') && !escaped)
				{
					break;
				}
				else
				{
					if (escaped)
					{
						outString.Append('\\');
					}
					outString.Append(c);
					escaped = false;
				}
			}

			if (json[i] != '"')
			{
				return .Err(.STRING_NOT_TERMINATED);
			}

			return .Ok(i);
		}

		private static Result<int, JSON_ERRORS> ParseNumber(StringView json, String outStr)
		{
			if (!JSONValidator.IsValidNumber(json))
			{
				return .Err(.INVALID_NUMBER_REPRESENTATION);
			}

			var strNum = scope String();
			outStr.Clear();

			int i = 0;
			for (i = 0; i < json.Length; i++)
			{
				let c = json[i];

				if (c == '.')
				{
					strNum.Append(c);
				}
				else if (!c.IsDigit && (c != '-') && (c != 'e') && (c != 'E') && (c != '+'))
				{
					break;
				}
				else
				{
					strNum.Append(c);
				}
			}

			outStr.Set(strNum);

			// I always want the last parsed char to be a number
			return .Ok(i - 1);
		}

		private static Result<int, JSON_ERRORS> ParseLiteral(StringView json, String outStr)
		{
			if (!JSONValidator.IsValidLiteral(json))
			{
				return .Err(.INVALID_LITERAL_VALUE);
			}

			var str = scope String();
			outStr.Clear();

			int i = 0;
			for (i = 0; i < json.Length; i++)
			{
				let c = json[i];

				if (!c.IsLetter)
				{
					break;
				}
				else
				{
					str.Append(c);
				}
			}

			outStr.Set(str);

			// I always want the last parsed char to be a letter
			return .Ok(i - 1);
		}

		private static Result<int, JSON_ERRORS> ParseArrayInternal(StringView json, ref JSONArray array)
		{
			int i = 0;

			for (i = 0; i < json.Length; i++)
			{
				let c = json[i];

				if ((c == '[') && (i != 0))
				{
					let str = StringView(json, i, json.Length - i);
					var outArr = scope JSONArray();
					let res = ParseArrayInternal(str, ref outArr);

					switch (res)
					{
					case .Err(let err):
						return .Err(err);
					default:
						i += res.Get();
					}

					array.Add<JSONArray>(outArr);
				}
				else if (c == ']')
				{
					break;
				}
				else if (c == '"')
				{
					// We do not want the first char in the string to parse to be taken as a
					// closing string token.
					i++;
					let str = StringView(json, i, json.Length - i);
					var outStr = scope String();
					let res = ParseString(str, outStr);

					switch (res)
					{
					case .Err(let err):
						return .Err(err);
					case .Ok(let val):
						i += val;
					}

					array.Add<String>(outStr);
				}
				else if ((c == '-') || (c.IsNumber))
				{
					let str = StringView(json, i, json.Length - i);
					var outStr = scope String();
					let res = ParseNumber(str, outStr);

					switch (res)
					{
					case .Err(let err):
						return .Err(err);
					case .Ok(let val):
						i += val;
					}

					if (outStr.Contains('.'))
					{
						array.Add<float>(outStr);
					}
					else
					{
						array.Add<int64>(outStr);
					}
				}
				else if (c.IsLetter)
				{
					let str = StringView(json, i, json.Length - i);
					var outStr = scope String();
					let res = ParseLiteral(str, outStr);

					switch (res)
					{
					case .Err(let err):
						return .Err(err);
					case .Ok(let val):
						i += val;
					}

					if (outStr.Equals("null"))
					{
						array.Add<Object>(null);
					}
					else
					{
						array.Add<bool>(outStr);
					}
				}
				else if (c == '{')
				{
					let str = StringView(json, i, json.Length - i);
					var outObject = scope JSONObject();

					let res = ParseObjectInternal(str, ref outObject);

					switch (res)
					{
					case .Err(let err):
						return .Err(err);
					default:
						i += res.Get();
					}

					array.Add<JSONObject>(outObject);
				}
			}

			return .Ok(i);
		}

		private static Result<int, JSON_ERRORS> ParseObjectInternal(StringView json, ref JSONObject object)
		{
			int i = 0;
			var lookForKey = true;
			//var typeParsed = JSON_TYPES.LITERAL;
			var key = scope String();

			for (i = 0; i < json.Length; i++)
			{
				let c = json[i];

				if ((c == '{') && (!lookForKey))
				{
					i++;
					let str = StringView(json, i, json.Length - i);
					var outObject = scope JSONObject();

					let res = ParseObjectInternal(str, ref outObject);

					switch (res)
					{
					case .Err(let err):
						return .Err(err);
					default:
						i += res.Get();
					}

					object.Add<JSONObject>(key, outObject);
				}
				else if (c == '}')
				{
					break;
				}
				else if (c == '"')
				{
					// We do not want the first char in the string to parse to be taken as a
					// closing string token.
					i++;
					let str = StringView(json, i, json.Length - i);

					if (lookForKey)
					{
						key = scope:: String();
						let res = ParseString(str, key);

						switch (res)
						{
						case .Err(let err):
							return .Err(err);
						case .Ok(let val):
							i += val;
						}

						lookForKey = false;
					}
					else
					{
						var outStr = scope String();
						let res = ParseString(str, outStr);

						switch (res)
						{
						case .Err(let err):
							return .Err(err);
						case .Ok(let val):
							i += val;
						}

						object.Add<String>(key, outStr);
					}
				}
				else if (c.IsDigit || (c == '-') && (!lookForKey))
				{
					let str = StringView(json, i, json.Length - i);
					var outStr = scope String();
					let res = ParseNumber(str, outStr);

					switch (res)
					{
					case .Err(let err):
						return .Err(err);
					case .Ok(let val):
						i += val;
					}

					if (outStr.Contains('.'))
					{
						object.Add<float>(key, outStr);
					}
					else
					{
						object.Add<int64>(key, outStr);
					}
				}
				else if (c.IsLetter && (!lookForKey))
				{
					let str = StringView(json, i, json.Length - i);
					var outStr = scope String();

					let res = ParseLiteral(str, outStr);

					switch (res)
					{
					case .Err(let err):
						return .Err(err);
					case .Ok(let val):
						i += val;
					}

					if (outStr.Equals("null"))
					{
						object.Add<Object>(key, null);
					}
					else
					{
						object.Add<bool>(key, outStr);
					}
				}
				else if (c == '[' && (!lookForKey))
				{
					//i++;
					let str = StringView(json, i, json.Length - i);
					var outArr = scope JSONArray();

					let res = ParseArrayInternal(str, ref outArr);

					switch (res)
					{
					case .Err(let err):
						return .Err(err);
					default:
						i += res.Get();
					}

					object.Add<JSONArray>(key, outArr);
				}
				else if (c == ',')
				{
					lookForKey = true;
				}
			}

			return .Ok(i);
		}
	}
}
