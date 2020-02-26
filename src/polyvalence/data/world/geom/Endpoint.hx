package polyvalence.data.world.geom;

import haxe.io.BytesInput;
import haxe.io.Bytes;

/**
    Endpoint is 16 bytes.

   | Type    | Description                                       | Name       |
   | ----    | -----------                                       | ----       |
   | u16     | Endpoint flags                                    |            |
   | i16     | Highest adjacent floor height                     |            |
   | i16     | Lowest adjacent ceiling height                    |            |
   | Point   | Position                                          |            |
   | Point   | Transformed position                              |            |
   | u16     | Supporting polygon index                          |            |
**/
class Endpoint{
    
    public var flags:UInt = 0;
    public var highest_adjacent_floor_height:Int;
    public var lowest_adjacent_ceiling_height:Int;
    public var position:Point;
    public var transformed_position:Point;
    public var poly_index:Int;
    function new(){

    }

    public static function fromBytes(bytes:Bytes){
        var out = new Endpoint();
        var strm = new BytesInput(bytes);
        strm.bigEndian = true;
        out.flags = strm.readUInt16();
        out.highest_adjacent_floor_height = strm.readInt16();
        out.lowest_adjacent_ceiling_height = strm.readInt16();
        out.position = Point.fromBytes(strm.read(4));
        out.transformed_position = Point.fromBytes(strm.read(4));
        out.poly_index = strm.readUInt16();
        return out;
    }

    public static function arrayFromBytes(bytes:Bytes):Array<Endpoint>{
        var out = [];
        var strm = new BytesInput(bytes);
        strm.bigEndian = true;
        while(strm.position < strm.length){
            var ept = fromBytes(strm.read(16));
            out.push(ept);
        }
        return out;
    }
}