package polyvalence.editor;
import electron.renderer.Remote;
import polyvalence.editor.views.MainView;

import polyvalence.io.Reader;
import polyvalence.io.OBJExporter;
import polyvalence.data.world.Level;
import haxe.io.Path;

class Shell extends hxd.App{
	public var version(get, null):String;
	function get_version():String{
		final module:Dynamic = Remote.require('electron');
		return module.app.getVersion();
	}
	public function new() {
		super();
		Remote.getCurrentWindow().title = "Polyvalence v"+version;

		/*
		//var wads = ['test_data/m1/Map.scen'];
		var wads = ['test_data/m2/Map.sceA'];
		for (w in wads) {
			var wad = Reader.readWad(w);
			var levels = [];
			for (e in wad.directory) {
				var level = Level.fromDirectoryEntry(e);
				trace("Loaded " + level);
				new OBJExporter(level).export(Path.join([Path.directory(w), '${level.info.getFileFriendlyName()}.obj']));
				levels.push(level);
			}
			trace("Loaded " + levels.length + " levels");
		}
		*/

	}
	override function init(){
		new MainView(this);
	}
}
