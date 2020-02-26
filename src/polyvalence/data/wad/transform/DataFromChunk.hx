package polyvalence.data.wad.transform;

import polyvalence.data.world.geom.*;
import polyvalence.data.world.meta.*;
import polyvalence.data.wad.DirectoryEntry.Chunk;

class DataFromChunk {
	public static function fromChunk(chunk:Chunk) {
		switch (chunk.tag) {
			case POLYGON_TAG:
                var polys = Poly.arrayFromBytes(chunk.bytes);
                trace("Read "+polys.length+" polygons");
			case MAP_INDEXES_TAG:
			case MAP_INFO_TAG:
                var minf = MapInfo.fromBytes(chunk.bytes);
                trace("Read minfo: "+minf);
			case LINE_TAG:
				var lins = Line.arrayFromBytes(chunk.bytes);
				trace("Read " + lins.length + " lines");
			case SIDE_TAG:
			case ENDPOINT_DATA_TAG:
				var epts = Endpoint.arrayFromBytes(chunk.bytes);
				trace("Read " + epts.length + " endpoints");
			case TERMINAL_DATA_TAG:
				var terminals = ComputerInterface.fromBytes(chunk.bytes);
				trace("Read " + terminals + " terminals");
			default:
		}
	}
}
