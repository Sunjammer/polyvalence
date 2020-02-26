package polyvalence.io;

import polyvalence.data.wad.WadFile;
import sys.FileSystem;
import sys.io.FileInput;
import sys.io.File;
import haxe.io.Bytes;

using polyvalence.io.MacCompat;

class Reader {
	public static function readWad(path:String):WadFile {
		var file = File.read(path);
		file.bigEndian = true;
		var fileSize = FileSystem.stat(path).size;

		trace("Reading " + path);
		var fork_start = file.tryMacHeader(fileSize);
		var wad = new WadFile(file, fork_start);

		file.close();
		return wad;
	}
}
