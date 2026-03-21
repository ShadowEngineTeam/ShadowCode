package;

import haxe.io.Path;
import utils.Util;
import monaco.MonacoLoader;
import sys.thread.Thread;

@:cppInclude("signal.h")
@:cppInclude("monaco/MonacoLoader.h")
#if windows
@:cppInclude("windows.h")
#end
class Main
{
	public static function main()
	{
		Util.initCustomTrace();

        // If you ctrl+c on console while the thing is running
        // Then the thing will die cuz server + language server process didn't close
        // These make sure they always close. Both are supposed to be DIFFERENT solutions the SAME THING 
        // But for some reason they only do their job when BOTH are implemented
        // So do NOT ever think of getting rid of one.
		Main.registerSignalHandlers();
        Main.startSafeExitThread();

		Main.loadMonaco();
	}

	private static function loadMonaco():Void
	{
		var appCwd = Sys.getCwd();
		var cwd:String = Path.join([appCwd, 'template']);
		var hxml:String = Path.join([appCwd, 'template', 'build.hxml']);
		var name:String = 'test';
		MonacoLoader.load(true, cwd, hxml, name);
	}

    private static function startSafeExitThread():Void
    {
        Thread.create(() ->
		{
			try
			{
				while (true)
					Sys.stdin().readByte();
			}
			catch (e)
			{
				MonacoLoader.cleanup();
				Sys.exit(0);
			}
		});
    }

	private static function registerSignalHandlers():Void
	{
		untyped __cpp__('
            struct SH {
                static void handle(int) {
                    monaco::MonacoLoader_obj::cleanup();
                    ::exit(0);
                }
                #ifdef _WIN32
                static BOOL WINAPI console(DWORD) {
                    monaco::MonacoLoader_obj::cleanup();
                    ::exit(0);
                    return TRUE;
                }
                #endif
            };
            ::signal(SIGINT, SH::handle);
            ::signal(SIGTERM, SH::handle);
            #ifdef _WIN32
            ::signal(SIGBREAK, SH::handle);
            ::SetConsoleCtrlHandler(SH::console, TRUE);
            #endif
        ');
	}
}
