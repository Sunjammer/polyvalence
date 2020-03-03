package polyvalence.data.world.geom;

import polyvalence.data.shapes.ShapeDescriptor;
import haxe.io.BytesInput;
import haxe.io.Bytes;


enum abstract SideType(Int) from Int to Int{
	var Full;
	var High;
	var Low;
	var Composite; // never
	var Split;
}

enum abstract SideFlags(Int)  from Int to Int{
    var None = 0x0;
    var ControlPanelStatus = 0x01;
    var IsControlPanel = 0x02;
    var IsRepairSwitch = 0x04;
    var IsDestructiveSwitch = 0x08;
    var IsLightedSwitch = 0x10;
    var SwitchCanBeDestroyed = 0x20;
    var SwitchCanOnlyBeHitByProjectiles = 0x40;
    var Dirty = 0x4000;
}

enum abstract ControlPanelClass(Int) from Int to Int {
    var Oxygen;
    var Shield;
    var DoubleShield;
    var TripleShield;
    var LightSwitch;
    var PlatformSwitch;
    var TagSwitch;
    var PatternBuffer;
    var Terminal;
}

class TextureDef{
    // uv offsets
    public var x:Int;
    public var y:Int;
    public var texture:Int;

    public function new(){

    }

    public static function fromBytes(b:Bytes):TextureDef{
        var out = new TextureDef();
        var bi = new BytesInput(b);
        bi.bigEndian = true;
        out.x = bi.readInt16();
        out.y = bi.readInt16();
        out.texture = bi.readInt16();
        return out;
    }
}

class ExclusionZone{
    
}

class Side{
    static final SIDE_SIZE = 64;

	public var type:SideType; //short
	public var flags:SideFlags; //word
	
	public var primary_texture:TextureDef;
	public var secondary_texture:TextureDef;
	public var transparent_texture:TextureDef; /* not drawn if .texture==NONE */

	/* all sides have the potential of being impassable; the exclusion zone is the area near
		the side which cannot be walked through */
	public var exclusion_zone:ExclusionZone;

    //shorts
	public var control_panel_type:Int; /* Only valid if side->flags & _side_is_control_panel */
	public var control_panel_permutation:Int; /* platform index, light source index, etc... */
	
	public var primary_transfer_mode:Int; /* These should be in the side_texture_definition.. */
	public var secondary_transfer_mode:Int;
	public var transparent_transfer_mode:Int;

    public var polygon_index:Int; 
    public var line_index:Int;

	public var primary_lightsource_index:Int;
	public var secondary_lightsource_index:Int;
	public var transparent_lightsource_index:Int; 

	public var ambient_delta:Int; //fixed

	// short unused[1];

    public function new(){

    }

    public static function fromBytes(b:Bytes):Side{
        var out = new Side();
        var bi = new BytesInput(b);
        bi.bigEndian = true;

        
        out.type = bi.readInt16(); //short
        out.flags = bi.readUInt16(); //word
        
        out.primary_texture = TextureDef.fromBytes(bi.read(6));
        out.secondary_texture = TextureDef.fromBytes(bi.read(6));
        out.transparent_texture = TextureDef.fromBytes(bi.read(6)); /* not drawn if .texture==NONE */

        /* all sides have the potential of being impassable; the exclusion zone is the area near
            the side which cannot be walked through */
        //out.exclusion_zone = ; //just seek past this one ref Weylan
        bi.read(16);

        //shorts
        out.control_panel_type = bi.readInt16(); /* Only valid if side->flags & _side_is_control_panel */
        out.control_panel_permutation = bi.readInt16(); /* platform index, light source index, etc... */
        
        out.primary_transfer_mode = bi.readInt16(); /* These should be in the side_texture_definition.. */
        out.secondary_transfer_mode = bi.readInt16();
        out.transparent_transfer_mode = bi.readInt16();

        out.polygon_index = bi.readInt16(); 
        out.line_index = bi.readInt16();

        out.primary_lightsource_index = bi.readInt16();
        out.secondary_lightsource_index = bi.readInt16();
        out.transparent_lightsource_index = bi.readInt16(); 

        out.ambient_delta = bi.readInt32(); //fixed

        return out;
    }

    public static function arrayFromBytes(b:Bytes):Array<Side>{
        var out = [];
        var bi = new BytesInput(b);
        while(bi.position < bi.length){
            out.push(fromBytes(bi.read(64)));
        }
        return out;
    }
}