package polyvalence.data.world.meta;
using polyvalence.io.MacCompat;
using StringTools;

import haxe.io.BytesInput;
import haxe.io.Bytes;

class MapInfo{
    var envCode:UInt;
    var physicsId:UInt;
    var musicId:UInt;
    var missionFlags:UInt;
    var envFlags:UInt;
    // | 8 bytes | Unused                                          |              |
    var name:String; // | u8[66]
    var entryFlags:UInt; // | u32     | Entry point flags                               | EntryFlags   |
    public function new(){

    }

    public function toString(){
        return "[MapInfo '"+name+"']";
    }

    public static function fromBytes(bytes:Bytes):MapInfo{
        var out = new MapInfo();
        var strm = new BytesInput(bytes);
        strm.bigEndian = true;
        out.envCode = strm.readUInt16();
        out.physicsId = strm.readUInt16();
        out.musicId = strm.readUInt16();
        out.missionFlags = strm.readUInt16();
        out.envFlags = strm.readUInt16();
        strm.read(8);
        out.name = strm.readMacString(66).trim();
        out.entryFlags = strm.readUint32B();

        return out;
    }
}