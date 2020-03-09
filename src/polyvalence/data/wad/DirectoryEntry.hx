package polyvalence.data.wad;
import polyvalence.data.wad.WadFile.WadfileDataVersion;
import sys.io.FileInput;
import haxe.io.Bytes;
import polyvalence.data.wad.RFTag;
using polyvalence.io.MacCompat;

class Chunk{
    public var tag:RFTag;
    public var bytes:Bytes;
    public var length:Int;
    
    public inline function new(tag:RFTag, bytes:Bytes){
        this.bytes = bytes;
        this.length = bytes.length;
        this.tag = tag;
    }
    public function toString(){
        var b = Bytes.alloc(4);
        b.setInt32(0, tag);
        var split = b.toString().split('');
        split.reverse();
        return split.join('');
    }
}

class DirectoryEntry {
    final BASE_SIZE = 10;
    final HEADER_SIZE = 16;

    public var chunks:Map<UInt, Chunk> = new Map ();
    public var app_specific_data:Bytes;

    public var data_version:WadfileDataVersion;
    
    public var offset:Int = 0;
    public var index:Int = 0;
    public var size(get,null):Int;
    function get_size() {
        var total = 0;
        for (chunk in chunks) {
            total += chunk.length + HEADER_SIZE;
        }
        return total;
    }

    var entry_size:Int;

    public function new(){

    }

    public function toString(){
        return '[DirectoryEntry offset=$offset index=$index]';
    }

    public static function load(reader:FileInput, data_version:WadfileDataVersion, app_specific_data_size:Int, wad_index:Int) {
        var out = new DirectoryEntry();
        out.offset = reader.readInt32();
        out.entry_size = reader.readInt32(); // size
        out.data_version = data_version;
        switch(data_version){
            case Marathon:
                out.index = wad_index;
            default:
                out.index = reader.readInt16();
        }
        out.app_specific_data = reader.read(app_specific_data_size);
        return out;
    }
    
    public function loadChunks(reader:FileInput) {
        reader.bigEndian = true;
        var position = reader.tell();
        var nextOffset;
        do {
            var tag:RFTag = reader.readUint32B(); 
            nextOffset = reader.readInt32();
            var length = reader.readInt32();
            reader.readInt32();
            
            chunks[tag] = new Chunk(tag, reader.read(length));
            
            if (nextOffset > 0){
                reader.seek(position + nextOffset, SeekBegin);
            }
        } while (nextOffset > 0);
    }

    /*function SaveEntry(BinaryWriterBE writer) {
        writer.Write(Offset);
        writer.Write((int) Size);
        writer.Write(Index);
    }	

    function Savechunks(BinaryWriterBE writer, uint[] tagOrder) {
        // build a list of tags to write in order
        HashSet<uint> Used = new HashSet<uint>();
        List<uint> Tags = new List<uint>();

        foreach (uint tag in tagOrder) {
            if (chunks.ContainsKey(tag)) {
                Tags.Add(tag);
                Used.Add(tag);
            }
        }

        foreach (var kvp in chunks) {
            if (!Used.Contains(kvp.Key)) {
                Tags.Add(kvp.Key);
                Used.Add(kvp.Key);
            }
        }

        int offset = 0;

        foreach (uint tag in Tags) {
            writer.Write(tag);
            if (tag == Tags[Tags.Count - 1]) {
                writer.Write((uint) 0);
            } else {
                writer.Write((int) offset + HEADER_SIZE + chunks[tag].Length);
            }
            writer.Write((int) chunks[tag].Length);
            writer.Write((int) 0);
            writer.Write(chunks[tag]);
            offset += chunks[tag].Length + HEADER_SIZE;
        }
    }*/

    /*public function Clone():DirectoryEntry {
        var clone = MemberwiseClone();
        clone.chunks = new Dictionary<uint, byte[]>();
        foreach (var kvp in chunks) {
            clone.chunks[kvp.Key] = (byte[]) kvp.Value.Clone();
        }
        return clone;
    }*/
}