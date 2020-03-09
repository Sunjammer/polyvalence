package polyvalence.data.world.geom;
import haxe.io.BytesInput;
import haxe.io.Bytes;

class Poly{

    public var poly_type:UInt; // u16
    public var poly_flags:UInt; // u16
    public var permutation:Int; // i16, polygon types
    public var vertex_count:UInt;
    public var endpoint_indices:Array<UInt>; //u16[8]
    public var line_indices:Array<UInt>; //u16[8]
    public var floor_texture:UInt;
    public var ceiling_texture:UInt;
    public var floor_height:Int; //i16
    public var ceiling_height:Int;
    public var floor_lightsource_idx:UInt; //u16
    public var ceiling_lightsource_idx:UInt;
    public var area_exp_2:Int; //i32
    public var first_obj_in_poly:UInt; // u16
    public var first_exclusion_zone:UInt; // u16
    public var num_line_exclusion_zones:UInt; // u16
    public var num_pt_exclusion_zones:UInt; // u16
    public var floor_transfer_mode:UInt; // u16
    public var ceiling_transfer_mode:UInt; // u16
    public var adjacent_poly_indices:Array<UInt>; // u16[8]
    public var first_neighboring_poly:UInt;
    public var num_neighboring_polys:UInt;
    public var center_x:Int; //i16
    public var center_y:Int;
    public var side_indices:Array<UInt>; //u16[8]
    public var floor_origin_x:Int; //i16
    public var floor_origin_y:Int; //i16
    public var ceiling_origin_x:Int; //i16
    public var ceiling_origin_y:Int; //i16
    public var media_index:UInt; //u16
    public var media_lightsource_index:UInt; //u16
    public var sound:UInt; //u16
    public var ambient_sound:UInt; //u16
    public var random_sound:UInt; //u16
    
    public function new(){

    }

    public static function fromBytes(bytes:Bytes):Poly{
        var out = new Poly();
        var str = new BytesInput(bytes);
        str.bigEndian = true;

        out.poly_type = str.readUInt16(); 
        out.poly_flags = str.readUInt16();
        out.permutation = str.readInt16();

        out.vertex_count = str.readUInt16();
        out.endpoint_indices = [for(i in 0...8) str.readUInt16()];
        out.line_indices = [for(i in 0...8) str.readUInt16()];

        out.floor_texture = str.readUInt16();
        out.ceiling_texture = str.readUInt16();

        out.floor_height = str.readInt16(); 
        out.ceiling_height = str.readUInt16();

        out.floor_lightsource_idx = str.readUInt16(); 
        out.ceiling_lightsource_idx = str.readUInt16();
        out.area_exp_2 = str.readInt32(); 
        out.first_obj_in_poly = str.readUInt16();
        out.first_exclusion_zone = str.readUInt16();
        out.num_line_exclusion_zones = str.readUInt16();
        out.num_pt_exclusion_zones = str.readUInt16();
        out.floor_transfer_mode = str.readUInt16();
        out.ceiling_transfer_mode = str.readUInt16();
        
        out.adjacent_poly_indices = [for(i in 0...8) str.readUInt16()];
        out.first_neighboring_poly = str.readUInt16();
        out.num_neighboring_polys = str.readUInt16();
        out.center_x = str.readInt16();
        out.center_y = str.readInt16();
        out.side_indices = [for(i in 0...8) str.readUInt16()]; 
        out.floor_origin_x = str.readInt16();
        out.floor_origin_y = str.readInt16();
        out.ceiling_origin_x = str.readInt16();
        out.ceiling_origin_y = str.readInt16();
        out.media_index = str.readUInt16();
        out.media_lightsource_index = str.readUInt16();
        out.sound = str.readUInt16();
        out.ambient_sound = str.readUInt16();
        out.random_sound = str.readUInt16();
        return out;
    }

    public static function arrayFromBytes(bytes:Bytes):Array<Poly>{
        var out = [];
        var strm = new BytesInput(bytes);
        while(strm.position<bytes.length){
            out.push(fromBytes(strm.read(128)));
        }
        return out;
    }
}