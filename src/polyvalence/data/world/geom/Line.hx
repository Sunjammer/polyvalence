package polyvalence.data.world.geom;
import haxe.io.BytesInput;
import haxe.io.Bytes;

class Line{

    public var ep_start:UInt;
    public var ep_end:UInt;
    public var flags:UInt;
    public var length:UInt;
    public var highest_adj_floor_height:UInt;
    public var highest_adj_ceil_height:UInt;
    public var poly_side_front:UInt;
    public var poly_side_back:UInt;
    public var poly_owner_front:UInt;
    public var poly_owner_back:UInt;

    public function new(){

    }

    public static function fromBytes(bytes:Bytes):Line{
        var out = new Line();
        var strm = new BytesInput(bytes);
        strm.bigEndian = true;
        out.ep_start = strm.readUInt16();
        out.ep_end = strm.readUInt16();
        out.flags = strm.readUInt16();
        out.length = strm.readUInt16();
        out.highest_adj_floor_height = strm.readUInt16();
        out.highest_adj_ceil_height = strm.readUInt16();
        out.poly_side_front = strm.readUInt16();
        out.poly_side_back = strm.readUInt16();
        out.poly_owner_front = strm.readUInt16();
        out.poly_owner_back = strm.readUInt16();
        return out;
    }

    public static function arrayFromBytes(bytes:Bytes):Array<Line>{
        var out = [];
        var strm = new BytesInput(bytes);
        while(strm.position<bytes.length){
            out.push(fromBytes(strm.read(32)));
        }
        return out;
    }
}