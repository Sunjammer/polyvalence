package polyvalence.data.world.meta;

import haxe.io.BytesInput;
import haxe.io.Bytes;
import polyvalence.data.world.geom.Point;
using polyvalence.io.MacCompat;

class Annotation{
    static final MAXIMUM_ANNOTATIONS_PER_MAP = 20;
    public var pos:Point;
    public var type:Int;
    public var poly_index:Int;
    public var text:String;
    public function new(){

    }

    public function toString():String{
        return '[Annotation pos:$pos "$text" ]';
    }

    public static function fromBytes(bytes:Bytes):Annotation{
        var out = new Annotation();
        var bi = new BytesInput(bytes);
        bi.bigEndian = true;

        out.type = bi.readInt16();
        out.pos = Point.fromBytes(bi.read(4));
        out.poly_index = bi.readInt16();
        out.text = bi.readMacString(64);
        trace("Loaded :"+out);
        return out;
    }

    public static function arrayFromBytes(bytes:Bytes):Array<Annotation>{
        var out = [];
        var bi = new BytesInput(bytes);
        while(bi.position < bi.length && out.length < MAXIMUM_ANNOTATIONS_PER_MAP){
            out.push(fromBytes(bi.read(72)));
        }
        return out;
    }
}