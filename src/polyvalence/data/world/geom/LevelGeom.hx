package polyvalence.data.world.geom;

class LevelGeom{
    public var polys:Array<Poly>;
    public var endpoints:Array<Endpoint>;
    public var lines:Array<Line>;
    public var points:Array<Point>;
    public function new(){
        polys = [];
        endpoints = [];
        lines = [];
        points = [];
    }
}