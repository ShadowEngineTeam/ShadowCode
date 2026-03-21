package utils;

import haxe.Log.formatOutput;

class Util
{
	public static function initCustomTrace():Void
	{
        #if (desktop && sys)
		haxe.Log.trace = function(v:Dynamic, ?infos:PosInfos):Void
		{
			var str = formatOutput(v, infos);
            Sys.stdout().writeString(str);
            Sys.stdout().flush();
		};
        #end
	}
}
