package polyvalence.io;
import haxe.io.Output;
import sys.io.File;
import polyvalence.data.world.World;
import polyvalence.data.world.geom.Side;
import polyvalence.data.world.geom.Line;
import polyvalence.data.world.Level;
import polyvalence.data.world.geom.Poly;
import haxe.io.BytesOutput;

class Vertex {
    public var X:WorldUnit;
    public var Y:WorldUnit;
    public var Z:WorldUnit;

    public function new(){

    }
    
    public function write(textWriter:Output) {
        var x = X.toDouble() * OBJExporter.SCALE;
        var y = Y.toDouble() * OBJExporter.SCALE;
        var z = Z.toDouble() * OBJExporter.SCALE;
        textWriter.writeString('v $x $y $z\n');
    }
}

class OBJExporter {
	public static final SCALE = 32.0;

	var level:Level;
	var vertices:Array<Vertex> = [];
	var endpointVertices:Array<Map<Int, Int>> = [];
    var faces:Array<Array<Int>> = [];
    
	public function new(level:Level) {
	    this.level = level;
	}

	public function export(path:String) {
	    faces = [];
	    vertices = [];
        endpointVertices = [];
	    for (i in 0...level.geom.endpoints.length) {
		    endpointVertices.push(new Map<Int,Int>());
	    }

	    for (p in level.geom.polys) {
            if (p.ceiling_height > p.floor_height) {
                if (p.floor_transfer_mode != 9) {
                    faces.push(floorFace(p));
                }
                if (p.ceiling_transfer_mode != 9) {
                    faces.push(ceilingFace(p));
                }
                for (i in 0...p.vertex_count) {
                    insertLineFaces(level.geom.lines[p.line_indices[i]], p);
                }
            }
	    }

        var writer = File.write(path, true);
        for (v in vertices) {
            v.write(writer);
        }
        
        for (f in faces) {
            writeFace(writer, f);
        }

        writer.close();

	}

	function getVertexIndex(endpointIndex:Int, height:Int) {
	    if (!endpointVertices[endpointIndex].exists(height)) {
            var p = level.geom.endpoints[endpointIndex];
            var v = new Vertex();
            v.X = cast p.position.x;
            v.Y = cast p.position.y;
            v.Z = height;
            endpointVertices[endpointIndex][height] = vertices.length;
            vertices.push(v);
	    }
	    return endpointVertices[endpointIndex][height];
	}

	function floorFace(p:Poly) {
	    var result:Array<Int> = [];
	    for (i in 0...p.vertex_count) {
		    result[i] = getVertexIndex(p.endpoint_indices[i], p.floor_height);
	    }
	    return result;
	}

	function ceilingFace(p:Poly) {
	    var result = [];
	    for (i in 0...p.vertex_count) {
		    result[i] = getVertexIndex(p.endpoint_indices[i], p.ceiling_height);
	    }

	    return result;
	}

	function buildFace(left:Int, right:Int, ceiling:Int, floor:Int) {
	    var result:Array<Int> = [];
	    result[0] = getVertexIndex(left, floor);
	    result[1] = getVertexIndex(right, floor);
	    result[2] = getVertexIndex(right, ceiling);
	    result[3] = getVertexIndex(left, ceiling);

	    return result;
	}

	static function writeFace(w:Output, face:Array<Int>) {
	    w.writeString("f");
	    for (i in 0...face.length) {
		    w.writeString(" " + (face[i] + 1));
	    }
	    w.writeString('\n');
	}
	
	function insertLineFaces(line:Line, p:Poly) {
	    var left;
	    var right;
	    var opposite:Poly = null;
	    var side:Side = null;
	    if (line.poly_owner_front != -1 && level.geom.polys[line.poly_owner_front] == p) {
            left = line.ep_start;
            right = line.ep_end;
            if (line.poly_owner_back != -1) {
                opposite = level.geom.polys[line.poly_owner_back];
            }
            if (line.poly_side_front != -1) {
                side = level.geom.sides[line.poly_side_front];
            }
	    } else {
            left = line.ep_end;
            right = line.ep_start;
            if (line.poly_owner_front != -1) {
                opposite = level.geom.polys[line.poly_owner_front];
            }
            if (line.poly_side_back != -1) {
                side = level.geom.sides[line.poly_side_back];
            }
	    }

	    var landscapeTop = false;
	    var landscapeBottom = false;
	    if (side != null) {
            if (side.type == SideType.Low) {
                if (side.primary_transfer_mode == 9) {
                    landscapeBottom = true;
                }
            } else {
                if (side.primary_transfer_mode == 9) {
                    landscapeTop = true;
                }
                if (side.secondary_transfer_mode == 9) {
                    landscapeBottom = true;
                }
            }
	    }

	    if (opposite == null || (opposite.floor_height > p.ceiling_height || opposite.ceiling_height < p.floor_height)) {
            if (!landscapeTop) {
                faces.push(buildFace(left, right, p.floor_height, p.ceiling_height));
            }
	    } else {
            if (opposite.floor_height > p.floor_height) {
                if (!landscapeBottom) {
                    faces.push(buildFace(left, right, p.floor_height, opposite.floor_height));
                }
            }
            if (opposite.ceiling_height < p.ceiling_height) {
                if (!landscapeTop) {
                    faces.push(buildFace(left, right, opposite.ceiling_height, p.ceiling_height));
                }
            }
	    }
	}
}