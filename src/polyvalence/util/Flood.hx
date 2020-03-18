package polyvalence.util;

import polyvalence.data.world.geom.Point;
import haxe.macro.Expr.Var;
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
    //#define UNVISITED NONE
    
    
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

    static inline final NONE:Int = -1;
    static inline final UNVISITED:Int = NONE;
        
    /* ---------- code */
    
    static function allocateMemory() {
        nodes = [];
        nodes[MAXIMUM_FLOOD_NODES] = null;
        visited_polygons = [];
    }
    
    /* returns next polygon index or NONE if there are no more polygons left cheaper than maximum_cost */
    public static function floodMap(
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
    
        /* initialize ourselves if first_polygon_index!=NONE */
        if (first_polygon_index != NONE)
        {
            /* clear the visited polygon array */
            visited_polygons = [];
            
            node_count= 0;
            last_node_index_expanded= NONE;
            add_node(NONE, first_polygon_index, 0, 0, (flood_mode==FlaggedBreadthFirst) ? caller_data : null);
        }
        
        switch (flood_mode)
        {
            case BestFirst:
                /* find the unexpanded node with the lowest cost */
                lowest_cost = maximum_cost;
                lowest_cost_node_index= NONE;
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
                node_index= (last_node_index_expanded==NONE) ? 0 : (last_node_index_expanded+1);
                while(node_index < node_count){
                    node = nodes[node_index];
                    ++node_index; 
                    if (node.cost<maximum_cost) break;
                }
                if (node_index==node_count)
                {
                    lowest_cost_node_index= NONE;
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
        if (lowest_cost_node_index!=NONE)
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
                
                if (destination_polygon_index!=NONE &&
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
            polygon_index= NONE;
        }
        
        return polygon_index;
    }
    
    /* walks backwards from the last node expanded, returning polygons as it goes; returns NONE
        when there are no more polygons to return.  this is useful for pathfinding: when
        flood_map() returns the destination polygon index, calling reverse_flood_map() will return
        the polygons traversed to reach the destination) */
    static function reverse_flood_map():Int
    {
        var polygon_index= NONE;
        
        if (last_node_index_expanded!=NONE)
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
    
        return last_node_index_expanded==NONE ? 0 : nodes[last_node_index_expanded].depth;
    }
    
    /* when looking for a random path, always choose a random node.  if bias is not NULL, then try
        and choose a destination in that direction */
    static function choose_random_flood_node(bias:Point)
    {
        var origin:Point;
        
        //assert(node_count>=1);
        find_center_of_polygon(nodes[0].polygon_index, origin);
        
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
                suitable= TRUE;
                if (bias && (retries-= 1)>=0)
                {
                    struct node_data *node= nodes+last_node_index_expanded;
                    world_point2d destination;
                    
                    find_center_of_polygon(node.polygon_index, &destination);
                    if (bias.i*(destination.x-origin.x) + bias.j*(destination.y-origin.y)<0) suitable= FALSE;
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

                node= nodes+node_index;
                if (NODE_IS_EXPANDED(node)||node.cost<=cost) node= (struct node_data *) NULL;
            }
            else
            {
                node_index= node_count;
                node= nodes + node_index;
            }
            
            if (node)
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
    
}

