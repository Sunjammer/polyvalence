package polyvalence.data.world;

import polyvalence.util.IntersectingFloodData;
import polyvalence.util.Box;
import polyvalence.data.wad.WadFile.WadfileDataVersion;
import polyvalence.data.wad.DirectoryEntry;
import polyvalence.data.world.meta.*;
import polyvalence.data.world.geom.*;
import polyvalence.data.world.entity.LevelEntity;
import polyvalence.util.Flood;

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
                    guessSideLightsourceIndices(i);
                }
            default:
        }
    }

        
    static final POLYGON_IS_DETACHED_BIT = 0x4000;
    static function polygonIsDetached(p:Poly):Bool {
        return p.poly_flags & POLYGON_IS_DETACHED_BIT != 0;
    }
    static function setPolygonDetachedState(p:Poly, v:Int) {
        v != 0 ? p.poly_flags |= POLYGON_IS_DETACHED_BIT : p.poly_flags &= ~POLYGON_IS_DETACHED_BIT;
    }

    static function findCenterOfPolygon(polygon_index:Int, center:Point)
    {
        /*
        struct polygon_data *polygon= get_polygon_data(polygon_index);
        long x= 0, y= 0;
        short i;
        
        for (i=0;i<polygon->vertex_count;++i)
        {
            world_point2d *p= &get_endpoint_data(polygon->endpoint_indexes[i])->vertex;
            
            x+= p->x, y+= p->y;
        }
        
        center->x= x/polygon->vertex_count;
        center->y= y/polygon->vertex_count;
        */
    }

    static function findIntersectingEndpointsAndLines(
        polygon_index:Int,
        minimum_separation:Int,
        line_indexes:Array<Int>,
        line_count:Box<Int>,
        endpoint_indexes:Array<Int>,
        endpoint_count:Box<Int>,
        polygon_indexes:Array<Int>,
        polygon_count:Box<Int>)
    {
        var data:IntersectingFloodData;
    
        data.original_polygon_index= polygon_index;	
        data.line_indexes= line_indexes;
        data.endpoint_indexes= endpoint_indexes;
        data.polygon_indexes= polygon_indexes;
        data.minimum_separation_squared= minimum_separation*minimum_separation;

        findCenterOfPolygon(polygon_index, data.center);
    
        polygon_index = Flood.floodMap(polygon_index, LONG_MAX, intersecting_flood_proc, _breadth_first, data);
        while (polygon_index!=NONE)
        {
            polygon_index= Flood.floodMap(NONE, LONG_MAX, intersecting_flood_proc, _breadth_first, data);
        }
        
        line_count.value = data.line_count;
        polygon_count.value = data.polygon_count;
        endpoint_count.value = data.endpoint_count;
        
        return;
    }

    static function precalculateMapIndices(geom:LevelGeom)
    {
        final MAXIMUM_INTERSECTING_INDEXES = 64;
        var polygon_index = 0;

    //	dynamic_world.map_index_count= 0;

        for(polygon in geom.polys)
        {
            if (!polygonIsDetached(polygon)) /* we�ll handle detached polygons during the second pass */
            {
                var line_indexes = [];
                var endpoint_indexes = [];
                var polygon_indexes = [];
                var line_count = 0;
                var endpoint_count = 0;
                var polygon_count = 0;
                var i = 0;
        
    //			if (polygon_index==17) dprintf("polygon #%d at %p", polygon_index, polygon);
                
                polygon.first_exclusion_zone_index= dynamic_world.map_index_count;
                polygon.line_exclusion_zone_count= polygon.point_exclusion_zone_count= 0;
                findIntersectingEndpointsAndLines(polygon_index, MINIMUM_SEPARATION_FROM_WALL,
                    line_indexes, line_count, endpoint_indexes, endpoint_count, polygon_indexes,
                    polygon_count);

                for (i in 0...line_count)	
                {
                    //add_map_index(line_indexes[i], &polygon.line_exclusion_zone_count);
                }
                
                for (i in 0...endpoint_count)
                {
                   //add_map_index(endpoint_indexes[i], &polygon.point_exclusion_zone_count);
                }
                
                polygon.first_neighbor_index= dynamic_world.map_index_count;
                polygon.neighbor_count= 0;
                findIntersectingEndpointsAndLines(polygon_index, MINIMUM_SEPARATION_FROM_PROJECTILE,
                    line_indexes, line_count, endpoint_indexes, endpoint_count, polygon_indexes,
                    polygon_count);

    //			if (polygon_index==155) dprintf("polygon index #%d has %d neighbors:;dm %x %x;", polygon_index, polygon_count, polygon_indexes, sizeof(short)*polygon_count);
                
                for (i in 0...polygon_count)
                {
                    //add_map_index(polygon_indexes[i], &polygon.neighbor_count);
                }
            }
        }

        //precalculate_polygon_sound_sources();
    }
}
