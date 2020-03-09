package polyvalence.data.world;

import polyvalence.data.wad.DirectoryEntry;
import polyvalence.data.world.meta.*;
import polyvalence.data.world.geom.LevelGeom;
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
		return Level.load(static_info, geom, entities, annotations);
	}
}
