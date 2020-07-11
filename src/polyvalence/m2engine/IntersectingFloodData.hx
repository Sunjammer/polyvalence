package polyvalence.m2engine;

import polyvalence.data.world.geom.Point;

class IntersectingFloodData
{
	public var line_indexes:Array<Int> = [];
	public var endpoint_indexes:Array<Int> = [];
	public var polygon_indexes:Array<Int> = [];
	
	public var original_polygon_index:Int = 0;
	public var center:Point = new Point(0,0);
	
    public var minimum_separation_squared:Int = 0;
    public inline function new(){ }
}