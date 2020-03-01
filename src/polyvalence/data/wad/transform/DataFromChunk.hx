package polyvalence.data.wad.transform;

import polyvalence.data.world.geom.*;
import polyvalence.data.world.meta.*;
import polyvalence.data.wad.DirectoryEntry.Chunk;
import haxe.io.Bytes;

enum ChunkData{
	Polygons(a:Array<Poly>);
	StaticInfo(info:MapInfo);
	Lines(a:Array<Line>);
	Endpoints(a:Array<Endpoint>);
	Points(a:Array<Point>);
	//TODO: Coverage
	Ignored;
}

class DataFromChunk {

    static function uint32ToStr(num:UInt):String{
        var bytes = Bytes.alloc(4);
        bytes.set(0, num >> 24);
        bytes.set(1, num >> 16);
        bytes.set(2, num >> 8);
		bytes.set(3, num);
		return bytes.toString();
    }

	public static function fromChunk(chunk:Chunk):ChunkData {
		#if debug
			trace("Reading chunk: "+uint32ToStr(chunk.tag));
		#end
		switch (chunk.tag) {
			/*case POINT_TAG:
				return Points(Point.arrayFromBytes(chunk.bytes));*/
			case POLYGON_TAG:
                return Polygons(Poly.arrayFromBytes(chunk.bytes));
			case MAP_INFO_TAG:
                return StaticInfo(MapInfo.fromBytes(chunk.bytes));
			case LINE_TAG:
				return Lines(Line.arrayFromBytes(chunk.bytes));
			case ENDPOINT_DATA_TAG:
				return Endpoints(Endpoint.arrayFromBytes(chunk.bytes));
			/*case TERMINAL_DATA_TAG:
				var terminals = ComputerInterface.fromBytes(chunk.bytes);
				trace("Read " + terminals + " terminals");*/
			/*case MAP_INDEXES_TAG:
				var indices = MapIndex.arrayFromBytes(chunk.bytes);
				trace("Read "+indices.length+" map indices");*/
			default:
				#if debug
					trace("Unhandled tag: "+uint32ToStr(chunk.tag));
				#end
		}
		return Ignored;
	}
}
