package polyvalence.data.world.meta;

import haxe.io.BytesInput;
import haxe.io.Bytes;

abstract MapIndex(Int) from Int to Int{
    public inline function new(val:Int){
        this = val;
    }

    public static function arrayFromBytes(bytes:Bytes):Array<MapIndex>{
        var out = [];
        //Map indexes are just shorts..?
        var strm = new BytesInput(bytes);
        strm.bigEndian = true;
        while(strm.position < strm.length){
            out.push(strm.readInt16());
        }
        return out;
    }

    public static function fromBytes(bytes:Bytes):MapIndex{
        return 0;
    }
}