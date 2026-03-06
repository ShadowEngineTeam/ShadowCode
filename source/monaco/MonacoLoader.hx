package monaco;

import webview.WebView;

@:nullSafety
class MonacoLoader
{
	public static var webview:Null<WebView> = null;

	public static function load(debug:Bool = false):Void
	{
		MonacoServer.startServer('monaco');

		webview	= new WebView(debug);
		webview.setTitle('Monaco Editor');
		webview.setSize(1280, 720, NONE);
		webview.navigate(MonacoServer.resolveAsset('index.html'));
		webview.run();
		webview.destroy();
		webview = null;
		MonacoServer.closeServer();
	}
}