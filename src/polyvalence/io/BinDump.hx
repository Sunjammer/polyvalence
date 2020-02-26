package polyvalence.io;

import sys.FileSystem;
import polyvalence.data.wad.DirectoryEntry;
import polyvalence.data.wad.DirectoryEntry.Chunk;
import sys.io.File;
import haxe.io.Bytes;

class BinDump{
    public static function dumpChunk(chunk:Chunk){
        sys.io.File.saveBytes(chunk.toString()+".dmp", chunk.bytes);
    }

    public static function dumpDirectoryEntry(entry:DirectoryEntry){
        var dirName = "test_data/dumps/D"+entry.index+"_"+entry.offset;
        FileSystem.createDirectory(dirName);
        for(c in entry.chunks){
            var cName = c.toString()+".chnk";
            File.saveBytes(dirName + '/' + cName, c.bytes);
        }
    }
}