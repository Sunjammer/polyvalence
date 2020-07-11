package polyvalence.util;

class M1BackCompat{
    

        
    public static final POLYGON_IS_DETACHED_BIT = 0x4000;
    public static function polygonIsDetached(p:Poly):Bool {
        return p.poly_flags & POLYGON_IS_DETACHED_BIT != 0;
    }
    public static function setPolygonDetachedState(p:Poly, v:Int) {
        v != 0 ? p.poly_flags |= POLYGON_IS_DETACHED_BIT : p.poly_flags &= ~POLYGON_IS_DETACHED_BIT;
    }

    public static function findCenterOfPolygon(polygon_index:Int, center:Point)
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
        endpoint_indexes:Array<Int>,
        polygon_indexes:Array<Int>)
    {
        var data:IntersectingFloodData;
    
        data.original_polygon_index= polygon_index;	
        data.line_indexes= line_indexes;
        data.endpoint_indexes= endpoint_indexes;
        data.polygon_indexes= polygon_indexes;
        data.minimum_separation_squared= minimum_separation*minimum_separation;

        findCenterOfPolygon(polygon_index, data.center);
    
        polygon_index = Flood.floodMap(polygon_index, LONG_MAX, intersecting_flood_proc, BreadthFirst, data);
        while (polygon_index!=null)
        {
            polygon_index= Flood.floodMap(null, LONG_MAX, intersecting_flood_proc, BreadthFirst, data);
        }
        
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
