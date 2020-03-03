package polyvalence.data.world.geom;

class LevelGeom{
    public var polys:Array<Poly>;
    public var endpoints:Array<Endpoint>;
    public var lines:Array<Line>;
    public var points:Array<Point>;
    public var sides:Array<Side>;
    public function new(){
        polys = [];
        endpoints = [];
        lines = [];
        points = [];
        sides = [];
    }

    public function toString():String{
        return '[LevelGeom Polys:${polys.length} EPoints:${endpoints.length} Lines:${lines.length} Points:${points.length} Sides:${sides.length} ]';
    }
}