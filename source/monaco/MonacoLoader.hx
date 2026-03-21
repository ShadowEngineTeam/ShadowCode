package monaco;

import languageServer.HaxeLanguageServer;
import webview.WebView;

using StringTools;

@:nullSafety
class MonacoLoader
{
	public static var webview:Null<WebView> = null;

	public static function load(debug:Bool = false, cwd:String, hxml:String, ?workspaceName:String):Void
	{
		MonacoServer.startServer('monaco');

		webview = new WebView(debug);
		webview.setTitle('Monaco Editor');
		webview.setSize(1280, 720, NONE);
		HaxeLanguageServer.init();
		FileSystemBridge.init(cwd);

		var loadArgs = '?cwd=$cwd&hxml=$hxml';
		if (workspaceName != null)
			loadArgs += '&name=$workspaceName';

		webview.navigate(MonacoServer.resolveAsset('src/index.html') + loadArgs);
		webview.run();

		HaxeLanguageServer.exit();
		MonacoServer.closeServer();

		webview.destroy();
		webview = null;
	}

	@:keep
	public static function cleanup():Void
	{
		HaxeLanguageServer.exit();
		MonacoServer.closeServer();
		if (webview != null)
		{
			webview.terminate();
			webview.destroy();
			webview = null;
		}
	}
}
