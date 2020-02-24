package polyvalence.io;

import sys.FileSystem;
import sys.io.FileInput;
import polyvalence.data.WadFile;
import sys.io.File;
import haxe.io.Bytes;
using polyvalence.io.MacCompat;

enum WadfileVersion {
	PreEntryPoint;
	HasDirectoryEntry;
	SupportsOverlays;
	HasInfinityStuff;
}

enum WadfileDataVersion {
	Marathon;
	MarathonTwo;
}

class Reader {

	public static function readWad(path:String):WadFile {
        var file = File.read(path);
        file.bigEndian = true;
        var fileSize = FileSystem.stat(path).size;

        trace("Reading " + path);
        var fork_start = file.tryMacHeader(fileSize);
        new WadFile(file, fork_start);
        
        file.close();
        return null;
	}
}
