package;
import js.Node;
import js.Node.__dirname;
import electron.main.App;
import electron.main.BrowserWindow;

class Main {
	public static function main() {
		electron.main.App.on(ready, function(e) {
			var win = new BrowserWindow({
				width: 720,
				height: 480,
				title: 'Polyvalence',
				webPreferences: {
					nodeIntegration: true
				}
			});
			win.on(closed, function() {
				win = null;
			});
			win.loadFile('app.html');

			#if debug
			win.webContents.openDevTools();
			#end

			var tray = new electron.main.Tray('${__dirname}/Marathon_logo.svg.png');
			tray.setTitle('Polyvalence');
		});

		electron.main.App.on(window_all_closed, function(e) {
			if (Node.process.platform != 'darwin')
				electron.main.App.quit();
		});
	}
}
