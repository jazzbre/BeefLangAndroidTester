using System.Reflection;

namespace JSON_Beef.Util
{
	public static class AttributeChecker
	{
		public static bool ShouldIgnore(FieldInfo field)
		{
			let shouldUse = field.GetCustomAttribute<Serialized>();

			return (!(shouldUse == .Ok) || FieldHelper.HasFlag(field, .PrivateScope) || FieldHelper.HasFlag(field, .Private) || FieldHelper.HasFlag(field, .Static));
		}
	}
}
