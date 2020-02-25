package polyvalence.data.wad;

// Resource fork tags
@:build(polyvalence.macro.TagMacros.buildTags())
enum abstract RFTag(UInt) from UInt to UInt{
    /* OSTypes.. */
    var APPLICATION_CREATOR = '52.4';
    var SCENARIO_FILE_TYPE = 'sce2';
    var SAVE_GAME_TYPE = 'sga2';
    var FILM_FILE_TYPE = 'fil2';
    var PHYSICS_FILE_TYPE = 'phy2';
    var SHAPES_FILE_TYPE = 'shp2';
    var SOUNDS_FILE_TYPE = 'snd2';
    var PATCH_FILE_TYPE = 'pat2';
    
    /* Other tags-  */
    var POINT_TAG = 'PNTS';
    var LINE_TAG = 'LINS';
    var SIDE_TAG = 'SIDS';
    var POLYGON_TAG = 'POLY';
    var LIGHTSOURCE_TAG = 'LITE';
    var ANNOTATION_TAG = 'NOTE';
    var OBJECT_TAG = 'OBJS';
    var GUARDPATH_TAG = "p'th";
    var MAP_INFO_TAG = 'Minf';
    var ITEM_PLACEMENT_STRUCTURE_TAG = 'plac';
    var DOOR_EXTRA_DATA_TAG = 'door';
    var PLATFORM_STATIC_DATA_TAG = 'plat';
    var ENDPOINT_DATA_TAG = 'EPNT';
    var MEDIA_TAG = 'medi';
    var AMBIENT_SOUND_TAG = 'ambi';
    var RANDOM_SOUND_TAG = 'bonk';
    var TERMINAL_DATA_TAG = 'term';
    
    /* Save/Load game tags. */
    var PLAYER_STRUCTURE_TAG = 'plyr';
    var DYNAMIC_STRUCTURE_TAG = 'dwol';
    var OBJECT_STRUCTURE_TAG = 'mobj';
    var DOOR_STRUCTURE_TAG = 'door';
    var MAP_INDEXES_TAG = 'iidx';
    var AUTOMAP_LINES = 'alin';
    var AUTOMAP_POLYGONS = 'apol';
    var MONSTERS_STRUCTURE_TAG = 'mOns';
    var EFFECTS_STRUCTURE_TAG = 'fx  ';
    var PROJECTILES_STRUCTURE_TAG = 'bang';
    var PLATFORM_STRUCTURE_TAG = 'PLAT';
    var WEAPON_STATE_TAG = 'weap';
    var TERMINAL_STATE_TAG = 'cint';
    
    /* Physix model tags */
    var MONSTER_PHYSICS_TAG = 'MNpx';
    var EFFECTS_PHYSICS_TAG = 'FXpx';
    var PROJECTILE_PHYSICS_TAG = 'PRpx';
    var PHYSICS_PHYSICS_TAG = 'PXpx';
    var WEAPONS_PHYSICS_TAG = 'WPpx';
    
    /* Preferences Tags.. */
    var prefGRAPHICS_TAG = 'graf';
    var prefSERIAL_TAG = 'serl';
    var prefNETWORK_TAG = 'netw';
    var prefPLAYER_TAG = 'plyr';
    var prefINPUT_TAG = 'inpu';
    var prefSOUND_TAG = 'snd ';
    var prefENVIRONMENT_TAG = 'envr';
}