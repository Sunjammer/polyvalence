package polyvalence.data;
import sys.io.FileInput;
import haxe.io.Bytes;
using polyvalence.io.MacCompat;

class Chunk{
    public inline function new(tag:Int, bytes:Bytes){
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
    public var tag:Int;
    public var bytes:Bytes;
    public var length:Int;
}

class DirectoryEntry {
    final BaseSize = 10;
    final HeaderSize = 16;

    public var Chunks:Map<UInt, Chunk> = new Map ();
    
    public var Offset:Int;
    public var Index:Int;
    public var Size(get,null):Int;
    function get_Size() {
        var total = 0;
        for (chunk in Chunks) {
            total += chunk.length + HeaderSize;
        }
        return total;
    }

    public function new(){}

    public function LoadEntry(reader:FileInput) {
        Offset = reader.readInt32();
        reader.readInt32(); // size
        Index = reader.readInt16();
        trace("Loaded directory entry: "+Index+" at "+Offset);
    }
    
    public function LoadChunks(reader:FileInput) {
        var position = reader.tell();
        var nextOffset;
        do {
            var tag = reader.readUint32B(); // Offset 
            nextOffset = reader.readInt32();
            var length = reader.readInt32();
            reader.readInt32(); // offset;
                    
            Chunks[tag] = new Chunk(tag, reader.read(length));
                    
            if (nextOffset > 0) 
                reader.seek(position + nextOffset, SeekBegin);
        } while (nextOffset > 0);
    }

    /*function SaveEntry(BinaryWriterBE writer) {
        writer.Write(Offset);
        writer.Write((int) Size);
        writer.Write(Index);
    }	

    function SaveChunks(BinaryWriterBE writer, uint[] tagOrder) {
        // build a list of tags to write in order
        HashSet<uint> Used = new HashSet<uint>();
        List<uint> Tags = new List<uint>();

        foreach (uint tag in tagOrder) {
            if (Chunks.ContainsKey(tag)) {
                Tags.Add(tag);
                Used.Add(tag);
            }
        }

        foreach (var kvp in Chunks) {
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
                writer.Write((int) offset + HeaderSize + Chunks[tag].Length);
            }
            writer.Write((int) Chunks[tag].Length);
            writer.Write((int) 0);
            writer.Write(Chunks[tag]);
            offset += Chunks[tag].Length + HeaderSize;
        }
    }*/

    /*public function Clone():DirectoryEntry {
        var clone = MemberwiseClone();
        clone.Chunks = new Dictionary<uint, byte[]>();
        foreach (var kvp in Chunks) {
            clone.Chunks[kvp.Key] = (byte[]) kvp.Value.Clone();
        }
        return clone;
    }*/
}