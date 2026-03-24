package utils;

import haxe.macro.Expr.ExprOf;

using StringTools;

@:nullSafety
class Util
{
	public static function initCustomTrace():Void
	{
		#if (desktop && sys)
		haxe.Log.trace = function(v:Dynamic, ?infos:haxe.PosInfos):Void
		{
			if (infos == null) return;
			var str = haxe.Log.formatOutput(v, infos);
			Sys.stdout().writeString(str + '\n');
			Sys.stdout().flush();
		};
		#end
	}

	public static function applyBackslashes(path:String, force:Bool = false):String
	{
		if (#if windows true #else force #end)
			path = path.replace('/', '\\');

		return path;
	}

	public static macro function getDefine(name:String):ExprOf<Null<String>>
	{
		return macro $v{haxe.macro.Context.definedValue(name)};
	}
}
