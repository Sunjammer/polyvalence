package polyvalence.data;

enum abstract ChunkTag(UInt) from UInt to UInt{
    var PNTS; //	Array of Points
    var LINS; //	Array of Lines
    var SIDS; //	Array of Sides
    var POLY; //	Array of Polygons
    var LITE; //	Array of Lights
    var NOTE; //	Not analyzed (annotations)
    var OBJS; //	Array of Objects
    var path; //	No test data (' is $8C) (guardpaths)
    var Minf; //	Static Map Info
    var plac; //	Not analyzed (item placement)
    var door; //	No test data (extra door data)
    var plat; //	No test data (platform static data)
    var EPNT; //	Array of Endpoints
    var medi; //	Not analyzed (media)
    var ambi; //	Not analyzed (ambient sounds)
    var bonk; //	No test data (random sounds)
    var term; //	Array of Terminals
    var iidx; //	Not analyzed (map indices)    
}