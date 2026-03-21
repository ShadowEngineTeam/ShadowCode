package macros;

#if macro
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;

class AssetsMacro
{
    public static final MONACO_ASSETS_FOLDER:String = 'monaco';

    public static function build()
    {
        var output = Compiler.getOutput();

        var outputBin:String = Path.join([output, 'bin']);
        if (!FileSystem.exists(outputBin))
            FileSystem.createDirectory(outputBin);

        for (file in FileSystem.readDirectory('bin'))
            File.copy('bin/$file', Path.join([outputBin, file]));

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