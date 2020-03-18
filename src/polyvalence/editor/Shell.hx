package polyvalence.editor;

import polyvalence.io.Reader;
import polyvalence.io.OBJExporter;
import polyvalence.data.world.Level;
import haxe.io.Path;

class Shell {
	public function new() {
		var wads = ['test_data/m1/Map.scen'];
		//var wads = ['test_data/m2/Map.sceA'];
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
	}
}
