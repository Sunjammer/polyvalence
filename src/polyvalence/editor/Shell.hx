package polyvalence.editor;

import polyvalence.io.Reader;
import polyvalence.data.world.Level;

class Shell{
    public function new(){
        var wads = [
            'test_data/m2/Map.sceA'
        ];
        for(w in wads){
            var wad = Reader.readWad(w);
            var levels = [];
            for(e in wad.directory){
                var level = Level.fromDirectoryEntry(e);
                trace("Loaded "+level);
                levels.push(level);
            }
            trace("Loaded "+levels.length+" levels");
        }
    }
}