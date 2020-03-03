package polyvalence.data.world.geom;

import haxe.io.BytesInput;
import haxe.io.Bytes;

class Point{
    public var x:Float;
    public var y:Float;
    public function new(x:Float, y:Float){
        this.x = x;
        this.y = y;
    }

    public function toString():String{
        return '[Point x:$x y:$y]';
    }

    public static function fromBytes(bytes:Bytes):Point{
        var strm = new BytesInput(bytes);
        strm.bigEndian = true;
        return new Point(strm.readInt16(), strm.readInt16());
    }

    public static function arrayFromBytes(bytes:Bytes):Array<Point>{
        var out = [];
        var strm = new BytesInput(bytes);
        while(strm.position<strm.length){
            out.push(Point.fromBytes(strm.read(4)));
        }
        return out;
    }
}