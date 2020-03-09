package polyvalence.data.world.meta;
import polyvalence.data.wad.WadFile.WadfileDataVersion;
using polyvalence.io.MacCompat;
using StringTools;

import haxe.io.BytesInput;
import haxe.io.Bytes;
using StringTools;

class MapInfo{
    public var envCode:UInt;
    public var physicsId:UInt;
    public var musicId:UInt;
    public var missionFlags:UInt;
    public var envFlags:UInt;
    // | 8 bytes | Unused                                          |              |
    public var name:UnicodeString; // | u8[66]
    public var entryFlags:UInt; // | u32     | Entry point flags                               | EntryFlags   |
    public function new(){

    }

    public function toString(){
        return "[MapInfo '"+name+"']";
    }

    public function getFileFriendlyName():String{
        var str = name.split(" ").join("_");
        return str.split("")
            .filter(char -> char.charCodeAt(0) <= 122 && char.charCodeAt(0) != 25)
            .filter(char -> char != '.' && char != ',' && char != '?' && char != "!")
            .join("");
        
    }

    public static function fromBytes(bytes:Bytes, data_version:WadfileDataVersion):MapInfo{
        var out = new MapInfo();
        var strm = new BytesInput(bytes);
        strm.bigEndian = true;
        try{
            out.envCode = strm.readUInt16();
            out.physicsId = strm.readUInt16();
            out.musicId = strm.readUInt16();
            out.missionFlags = strm.readUInt16();
            out.envFlags = strm.readUInt16();
            switch(data_version){
                case Marathon:
                    strm.read(4);
                default:
                    strm.read(8);
            }
            out.name = strm.readMacString(66).trim();
            out.entryFlags = strm.readUint32B();
        }catch(e:Dynamic){
            trace(""+e);
        }

        return out;
    }
}