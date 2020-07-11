package polyvalence.data.world;

import polyvalence.util.Box;
import polyvalence.data.wad.WadFile.WadfileDataVersion;
import polyvalence.data.wad.DirectoryEntry;
import polyvalence.data.world.meta.*;
import polyvalence.data.world.geom.*;
import polyvalence.data.world.entity.LevelEntity;

class Level {
	public var info:MapInfo;
    public var geom:LevelGeom;
    public var annotations:Array<Annotation>;
    public var entities:Array<LevelEntity>;

    function new() {}
    
    public static function load(info, geom, entities, annotations):Level{
        var level = new Level();
        level.info = info;
        level.geom = geom;
        level.entities = entities;
        level.annotations = annotations;
        return level;
    }

    public function toString():String{
        return '[Level Info:${info} Geom:${geom}]';
    }

	public static function fromDirectoryEntry(de:DirectoryEntry):Level {
        var static_info:MapInfo = null;
        var geom = new LevelGeom();
        var entities = [];
        var annotations = [];
		for (c in de.chunks) {
			switch (polyvalence.data.wad.transform.DataFromChunk.fromChunk(c, de.data_version)) {
				case StaticInfo(info):
					static_info = info;
				case Polygons(a):
					geom.polys = a;
				case Lines(a):
					geom.lines = a;
				case Endpoints(a):
					geom.endpoints = a;
				case Points(a):
                    geom.points = a;
                case Sides(a):
                    geom.sides = a;
                case Annotations(a):
                    annotations = a;
				default:
			}
        }
        if(static_info==null){
            throw "Levels must have MapInfo";
        }
        normalizeGeom(geom, de.data_version);
		return Level.load(static_info, geom, entities, annotations);
    }
    
    static function guessSideLightsourceIndices(side_index:Int)
    {
        /*struct side_data *side= get_side_data(side_index);
        struct line_data *line= get_line_data(side.line_index);
        struct polygon_data *polygon= get_polygon_data(side.polygon_index);
        
        switch (side.type)
        {
            case _full_side:
                side.primary_lightsource_index= polygon.ceiling_lightsource_index;
                break;
            case _split_side:
                side.secondary_lightsource_index= (line.lowest_adjacent_ceiling-line.highest_adjacent_floor>CONTINUOUS_SPLIT_SIDE_HEIGHT) ?
                    polygon.floor_lightsource_index : polygon.ceiling_lightsource_index;
                // fall through to high side
            case _high_side:
                side.primary_lightsource_index= polygon.ceiling_lightsource_index;
                break;
            case _low_side:
                side.primary_lightsource_index= polygon.floor_lightsource_index;
                break;
            
            default:
                halt();
        }
        
        side.transparent_lightsource_index= polygon.ceiling_lightsource_index;*/
    }

    static function normalizeGeom(geom:LevelGeom, data_version:WadfileDataVersion){
        switch(data_version){
            case Marathon:
                /* Gotta do this after recalculate redundant.. */
                for(i in 0...geom.polys.length){
                    //guessSideLightsourceIndices(i);
                }
            default:
        }
    }
}
