package macros;

#if macro
import haxe.macro.Context;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;

class AssetsMacro
{
    public static final MONACO_ASSETS_FOLDER:String = 'monaco';

    public static function build()
    {
        embedAssets(MONACO_ASSETS_FOLDER);
    }

    public static function embedAssets(source:String, ?name:String)
    {
        if (name == null) name = source;

        if (FileSystem.isDirectory(source))
        {
            for (file in FileSystem.readDirectory(source))
            {
                embedAssets(Path.join([source, file]), Path.join([name, file]));
            }
        }
        else
        {
            // trace('src:$source');
            // trace('name:$name');
            Context.addResource(name, File.getBytes(source));
        }
    }
}
#end