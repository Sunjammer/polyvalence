package polyvalence.data.world;

import polyvalence.data.wad.DirectoryEntry;
import polyvalence.data.world.meta.MapInfo;
import polyvalence.data.world.geom.LevelGeom;
import polyvalence.data.world.entity.LevelEntity;

class Level {
	public var info:MapInfo;
	public var geom:LevelGeom;
	public var entities:Array<LevelEntity>;

    function new() {}
    
    public static function load(info, geom, entities):Level{
        var level = new Level();
        level.info = info;
        level.geom = geom;
        level.entities = entities;
        return level;
    }

    public function toString():String{
        return info.toString();
    }

	public static function fromDirectoryEntry(de:DirectoryEntry):Level {
        var static_info:MapInfo = null;
        var geom = new LevelGeom();
        var entities = [];
		for (c in de.chunks) {
			switch (polyvalence.data.wad.transform.DataFromChunk.fromChunk(c)) {
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
				default:
			}
        }
        if(static_info==null){
            throw "Levels must have MapInfo";
        }
		return Level.load(static_info, geom, entities);
	}
}
