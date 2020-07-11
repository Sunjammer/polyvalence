package polyvalence.m2engine;

import polyvalence.data.world.Level;
import polyvalence.data.world.geom.Point;
import polyvalence.data.world.geom.Poly;

enum FloodMode{
    BestFirst;
    DepthFirst;
    BreadthFirst;
    FlaggedBreadthFirst;
}

class NodeData 
{
    public var flags:Int = 0;
    
    public var parent_node_index:Int = 0; /* node index of the node we came from to get here; only used for backtracking */
    public var polygon_index:Int = 0; /* index of this polygon */
    public var cost:Int = 0; /* the cost to evaluate this entry */

    public var depth:Int = 0;

    public var user_flags:Int = 0;
    public inline function new(){ }
}

class Flood{

    public static inline final MAXIMUM_FLOOD_NODES = 255;
    public static inline final MAXIMUM_BIASED_RETRIES = 10;
    //#define UNVISITED null
    
    
    static inline function NODE_IS_EXPANDED(n:NodeData){
        return n.flags & 0x8000 != 0;
    }
    static inline function NODE_IS_UNEXPANDED(n:NodeData){
        return !NODE_IS_EXPANDED(n);
    }
    static inline function MARK_NODE_AS_EXPANDED(n:NodeData){ 
        n.flags |= 0x8000;
    }
    
    /* ---------- globals */
    
    static var node_count:Int = 0;
    static var last_node_index_expanded:Int = -1;
    static var nodes:Array<NodeData>;
    static var visited_polygons:Array<Int>;
    static inline final UNVISITED:Int = null;
        
    /* ---------- code */
    
    static function allocateMemory() {
        nodes = [];
        nodes[MAXIMUM_FLOOD_NODES] = null;
        visited_polygons = [];
    }
    
    /* returns next polygon index or null if there are no more polygons left cheaper than maximum_cost */
    public static function flood_map(
        first_polygon_index:Int,
        maximum_cost:Int,
        cost_proc:Dynamic, //Method of some sort
        flood_mode:FloodMode,
        caller_data:Dynamic)
    {
        var lowest_cost_node_index:Int;
        var node_index:Int;
        var node:NodeData;
        var polygon_index:Int;
        var lowest_cost:Int;
    
        /* initialize ourselves if first_polygon_index!=null */
        if (first_polygon_index != null)
        {
            /* clear the visited polygon array */
            visited_polygons = [];
            
            node_count= 0;
            last_node_index_expanded= null;
            add_node(null, first_polygon_index, 0, 0, (flood_mode==FlaggedBreadthFirst) ? caller_data : null);
        }
        
        switch (flood_mode)
        {
            case BestFirst:
                /* find the unexpanded node with the lowest cost */
                lowest_cost = maximum_cost;
                lowest_cost_node_index= null;
                node = nodes[node_index = 0];
                while(node_index<node_count){

                    if (NODE_IS_UNEXPANDED(node) && node.cost < lowest_cost)
                    {
                        lowest_cost_node_index= node_index;
                        lowest_cost= node.cost;
                    }

                    node = nodes[++node_index];
                }
            
            case BreadthFirst|FlaggedBreadthFirst:
                /* find the next unexpanded node in the list under maximum_cost */
                node_index= (last_node_index_expanded==null) ? 0 : (last_node_index_expanded+1);
                while(node_index < node_count){
                    node = nodes[node_index];
                    ++node_index; 
                    if (node.cost<maximum_cost) break;
                }
                if (node_index==node_count)
                {
                    lowest_cost_node_index= null;
                    lowest_cost= maximum_cost;
                }
                else
                {
                    lowest_cost_node_index= node_index;
                    lowest_cost= node.cost;
                }
            
            case DepthFirst:
                /* implementation left to the caller (c.f., zen() in fareast.c) */
                // halt();
                
            default:
                // halt();
        }
    
        /* if we found a node, mark it as expanded and add it�s adjacent non-solid polygons to the search tree */
        if (lowest_cost_node_index!=null)
        {
            var polygon:Poly;
            var i:Int;
            
            /* for flood_depth() and reverse_flood_map(), remember which node we successfully expanded last */
            last_node_index_expanded = lowest_cost_node_index;
    
            /* get pointer to lowest cost node */
            //assert(lowest_cost_node_index>=0&&lowest_cost_node_index<node_count);
            node = nodes[lowest_cost_node_index];
    
            //polygon= get_polygon_data(node.polygon_index);
            //assert(!POLYGON_IS_DETACHED(polygon));
    
            /* mark node as expanded */
            MARK_NODE_AS_EXPANDED(node);
    
            for (i in 0...polygon.vertex_count)		
            {
                var destination_polygon_index= polygon.adjacent_poly_indices[i];
                
                if (destination_polygon_index!=null &&
                    (maximum_cost!=0xFFFFFFFF || visited_polygons[destination_polygon_index]==UNVISITED))
                {
                    var new_user_flags= node.user_flags;
                    var cost:Int = cost_proc != null ? cost_proc(node.polygon_index, polygon.line_indices[i], destination_polygon_index, (flood_mode==FlaggedBreadthFirst) ? new_user_flags : caller_data) : polygon.area;
                    
                    /* polygons with zero or negative costs are not added to the node list */
                    if (cost>0) add_node(lowest_cost_node_index, destination_polygon_index, node.depth+1, lowest_cost+cost, new_user_flags);
                }
            }
            
            polygon_index= node.polygon_index;
            if (flood_mode==FlaggedBreadthFirst) 
                caller_data = node.user_flags;
        }
        else
        {
            polygon_index= null;
        }
        
        return polygon_index;
    }
    
    /* walks backwards from the last node expanded, returning polygons as it goes; returns null
        when there are no more polygons to return.  this is useful for pathfinding: when
        flood_map() returns the destination polygon index, calling reverse_flood_map() will return
        the polygons traversed to reach the destination) */
    static function reverse_flood_map():Int
    {
        var polygon_index= null;
        
        if (last_node_index_expanded!=null)
        {
            var node:NodeData;
            
            //assert(last_node_index_expanded>=0&&last_node_index_expanded<node_count);
            node= nodes[last_node_index_expanded];
    
            last_node_index_expanded = node.parent_node_index;
            polygon_index= node.polygon_index;
        }
        
        return polygon_index;
    }
    
    /* returns depth (in polygons) at last_node_index_expanded */
    static function flood_depth():Int
    {
        //assert(last_node_index_expanded>=0&&last_node_index_expanded<node_count);
    
        return last_node_index_expanded==null ? 0 : nodes[last_node_index_expanded].depth;
    }
    
    /* when looking for a random path, always choose a random node.  if bias is not NULL, then try
        and choose a destination in that direction */
    static function choose_random_flood_node(bias:Point)
    {
        var origin:Point;
        
        //assert(node_count>=1);
        Level.findCenterOfPolygon(nodes[0].polygon_index, origin);
        
        if (node_count>1)
        {
            var suitable = false;
            var retries = MAXIMUM_BIASED_RETRIES;
            
            do
            {
                do
                {
                    last_node_index_expanded= RNG.random() % node_count;
                }
                while (NODE_IS_UNEXPANDED(nodes[last_node_index_expanded]));
    
                /* if we have no bias, this node is automatically suitable if it has been expanded;
                    if we have a bias, this node is only suitable if it is in the same general
                    direction (by sign of dot product) as the bias */
                suitable= true;
                if (bias != null && (retries-= 1)>=0)
                {
                    var node= nodes[last_node_index_expanded];
                    var destination:Point;
                    
                    Level.findCenterOfPolygon(node.polygon_index, destination);
                    if (bias.x*(destination.x-origin.x) + bias.y*(destination.y-origin.y)<0) suitable= false;
                }
            }
            while (!suitable);
        }
    }
    
    /* ---------- private code */
    
    /* checks to see if the given node is already in the node list */
    static function add_node(
        parent_node_index:Int,
        polygon_index:Int,
        depth:Int,
        cost:Int,
        user_flags:Int)
    {
        if (node_count<MAXIMUM_FLOOD_NODES)
        {
            var node:NodeData;
            var node_index:Int;
            
            /* see if this polygon already exists in the node list anywhere */
            //assert(polygon_index>=0&&polygon_index<dynamic_world.polygon_count);

            if ((node_index= visited_polygons[polygon_index])!=UNVISITED)
            {
                /* there is already a node referencing this polygon; if it has a higher cost
                    than the cost we are attempting to add, replace it (because we are doing
                    a best-first search, we are guarenteed never to find a better path to an
                    expanded node, and in fact if we find a path to a node we have already
                    expanded we�re backtracking and can ignore the node) */
                //assert(node_index>=0&&node_index<node_count);

                node = nodes[node_index];
                if (NODE_IS_EXPANDED(node)||node.cost<=cost) 
                    node = null;
            }
            else
            {
                node_index= node_count;
                node= nodes[node_index];
            }
            
            if (node != null)
            {
                if (node_index==node_count)
                {
                    node_count+= 1;
                }
                
                node.flags= 0;
                node.parent_node_index= parent_node_index;
                node.polygon_index= polygon_index;
                node.depth= depth;
                node.cost= cost;
                node.user_flags= user_flags;
                
                //assert(polygon_index>=0&&polygon_index<dynamic_world.polygon_count);
                visited_polygons[polygon_index]= node_index;
                
    //			dprintf("added polygon #%d to node #%d (nodes=%p,visited=%p)", polygon_index, node_index, nodes, visited_polygons);
            }
        }
    }

    static function get_polygon_data(index):Poly{
        return null;
    }

    static function intersecting_flood_proc(
        source_polygon_index:Int,
        line_index:Int,
        destination_polygon_index:Int,
        data:IntersectingFloodData)
    {
        var polygon= get_polygon_data(source_polygon_index);
        var original_polygon= get_polygon_data(data.original_polygon_index);
        var keep_searching= false; /* don�t flood any deeper unless we find something close enough */
        var i:Int;
        var j:Int;
    
    
        /* we only care about this polygon if it intersects us in z */
        if (polygon.floor_height<=original_polygon.ceiling_height&&polygon.ceiling_height>=original_polygon.floor_height)
        {
            /* update our running line and endpoint lists */	
            for (i in 0...polygon.vertex_count)
            {
                /* add this line if it isn�t already in the intersecting line list */
                for (j in 0...data.line_count)
                {
                    if (data.line_indexes[j]==polygon.line_indexes[i] ||
                        -data.line_indexes[j]-1==polygon.line_indexes[i])
                    {
                        keep_searching= TRUE;
                        break; /* found duplicate, stop */
                    }
                }
                if (j==data.line_count && data.endpoint_count<MAXIMUM_INTERSECTING_INDEXES)
                {
                    short line_index= polygon.line_indexes[i];
                    struct line_data *line= get_line_data(line_index);
                    
    //				if (data.original_polygon_index==23&&line_index==104) dprintf("line#%d @ %p", line_index, line);
                    
                    if (LINE_IS_SOLID(line) ||
                        line_has_variable_height(line_index) ||
                        line.lowest_adjacent_ceiling<original_polygon.ceiling_height ||
                        line.highest_adjacent_floor>original_polygon.floor_height)
                    {
                        world_point2d *a= &get_endpoint_data(line.endpoint_indexes[0]).vertex;
                        world_point2d *b= &get_endpoint_data(line.endpoint_indexes[1]).vertex;
            
                        /* check and see if this line is close enough to any point in our original polygon
                            to care about; if it is, add it to our list */
                        for (j in 0...original_polygon.vertex_count)
                        {
                            world_point2d *p= &get_endpoint_data(original_polygon.endpoint_indexes[j]).vertex;
                
                            if (point_to_line_segment_distance_squared(p, a, b)<data.minimum_separation_squared)
                            {
                                boolean clockwise= ((b.x-a.x)*(data.center.y-b.y) - (b.y-a.y)*(data.center.x-b.x)>0) ? TRUE : false;
                                
                                data.line_indexes[data.line_count++]= clockwise ? polygon.line_indexes[i] : (-polygon.line_indexes[i]-1);
    //							if (data.original_polygon_index==23) dprintf("found line %d (%s)", polygon.line_indexes[i], clockwise ? "clockwise" : "counterclockwise");
                                keep_searching= TRUE;
                                break;
                            }
                        }
                    }
                }
                
                /* add this endpoint if it isn�t already in the intersecting endpoint list */
                for (j=0;j<data.endpoint_count;++j)
                {
                    if (data.endpoint_indexes[j]==polygon.endpoint_indexes[i])
                    {
                        keep_searching= TRUE;
                        break; /* found duplicate, ignore (but keep looking for others) */
                    }
                }
                if (j==data.endpoint_count && data.endpoint_count<MAXIMUM_INTERSECTING_INDEXES)
                {
                    world_point2d *p= &get_endpoint_data(polygon.endpoint_indexes[i]).vertex;
                    
                    /* check and see if this endpoint is close enough to any line in our original polygon
                        to care about; if it is, add it to our list */
                    for (j=0;j<original_polygon.vertex_count;++j)
                    {
                        struct line_data *line= get_line_data(original_polygon.line_indexes[j]);
                        world_point2d *a= &get_endpoint_data(line.endpoint_indexes[0]).vertex;
                        world_point2d *b= &get_endpoint_data(line.endpoint_indexes[1]).vertex;
            
                        if (point_to_line_segment_distance_squared(p, a, b)<data.minimum_separation_squared)
                        {
                            data.endpoint_indexes[data.endpoint_count++]= polygon.endpoint_indexes[i];
                            break;
                        }
                    }
                }
            }
        }
    
        /* if any part of this polygon is close enough to our original polygon, remember it�s index */
        if (keep_searching)
        {
            for (j=0;j<data.polygon_count;++j)
            {
                if (data.polygon_indexes[j]==source_polygon_index)
                {
                    break; /* found duplicate, ignore */
                }
            }
            if (j==data.polygon_count && data.polygon_count<MAXIMUM_INTERSECTING_INDEXES)
            {
                short detached_twin_index= null; //find_undetached_polygons_twin(source_polygon_index);
                
                data.polygon_indexes[data.polygon_count++]= source_polygon_index;
                
                /* if this polygon has a detached twin, add it too */
                if (detached_twin_index!=null && data.polygon_count<MAXIMUM_INTERSECTING_INDEXES)
                {
                    data.polygon_indexes[data.polygon_count++]= detached_twin_index;
                }
            }
        }
    
        /* return area of source polygon as cost */
        return keep_searching ? 1 : -1;
    }
    
}

