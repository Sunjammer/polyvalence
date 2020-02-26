package polyvalence.io;

import sys.FileSystem;
import polyvalence.data.wad.DirectoryEntry;
import sys.io.File;
import haxe.io.Bytes;

class BinDump{
    public static function dumpDirectoryEntry(entry:DirectoryEntry, prefix:String){
        var dirName = "test_data/dumps/"+prefix+"/D"+entry.index+"_"+entry.offset;
        trace("Creating dir: "+dirName);
        FileSystem.createDirectory(dirName);
        for(c in entry.chunks){
            var cName = c.toString()+".chnk";
            File.saveBytes(dirName + '/' + cName, c.bytes);
        }
    }
}