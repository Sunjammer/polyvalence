package polyvalence.data.wad.transform;

import polyvalence.data.wad.WadFile.WadfileDataVersion;
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
	Annotations(a:Array<Annotation>);
	Sides(a:Array<Side>);
	MapIndices(a:Array<MapIndex>);

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

	public static function fromChunk(chunk:Chunk, data_version:WadfileDataVersion):ChunkData {
		switch (chunk.tag) {
			case SIDE_TAG:
				return Sides(Side.arrayFromBytes(chunk.bytes, data_version));
			case ANNOTATION_TAG:
				return Annotations(Annotation.arrayFromBytes(chunk.bytes));
			case POINT_TAG:
				return Points(Point.arrayFromBytes(chunk.bytes));
			case POLYGON_TAG:
                return Polygons(Poly.arrayFromBytes(chunk.bytes, data_version));
			case MAP_INFO_TAG:
                return StaticInfo(MapInfo.fromBytes(chunk.bytes, data_version));
			case LINE_TAG:
				return Lines(Line.arrayFromBytes(chunk.bytes));
			case ENDPOINT_DATA_TAG:
				return Endpoints(Endpoint.arrayFromBytes(chunk.bytes));
			/*case TERMINAL_DATA_TAG:
				var terminals = ComputerInterface.fromBytes(chunk.bytes);
				trace("Read " + terminals + " terminals");*/
			case MAP_INDEXES_TAG:
				var indices = MapIndex.arrayFromBytes(chunk.bytes);
				return MapIndices(indices);
			default:
				#if debug
					//trace("Unhandled tag: "+uint32ToStr(chunk.tag));
				#end
		}
		return Ignored;
	}
}
