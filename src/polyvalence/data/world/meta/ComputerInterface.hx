package polyvalence.data.world.meta;
import haxe.io.BytesBuffer;
import haxe.io.BytesInput;
import haxe.io.Bytes;

class ComputerInterface{
    
    public function new(){

    }

    public static function decodeText(bytes:Bytes):Bytes{
        var length = bytes.length;
        var p = 0;
        
        for(i in 0...Std.int(length/4)) {
            p += 2;
            bytes.set(p, bytes.get(p) ^ 0xfe);
            p++;
            bytes.set(p, bytes.get(p) ^ 0xed);
            p++;
        }

        for (i in 0...length%4){
            bytes.set(p, bytes.get(p) ^ 0xfe);
            p++;
        }

        return bytes;
    }

    public static function encodeText(str:String):String{
        return "";
    }

    public static function fromBytes(b:Bytes):ComputerInterface{
        var out = new ComputerInterface();
        var strm = new BytesInput(b);
        strm.bigEndian = true;
        //Header
        var total_length = strm.readUInt16();
        var flags = strm.readUInt16();
        var lines_per_page = strm.readUInt16();
        var term_group_count = strm.readUInt16();
        var text_face_count = strm.readUInt16();
        // Groups
        for(i in 0...term_group_count){
            strm.readUInt16(); //TODO
            var type = strm.readUInt16();
            var perm = strm.readUInt16();
            var text_index = strm.readUInt16();
            var text_length = strm.readUInt16();
            strm.readUInt16(); //TODO
        }
        for(i in 0...text_face_count){
            var text_start = strm.readUInt16();
            var text_end_probably = strm.readUInt16();
            var color = strm.readUInt16();
        }
        var text_data = strm.read(b.length-strm.position);
        var decoded = decodeText(text_data);
        //sys.io.File.saveBytes("term_text_dump.txt", decoded);
        return out;
    }

    public static function arrayFromBytes(b:Bytes):Array<ComputerInterface>{
        var out = [];
        return out;
    }
}