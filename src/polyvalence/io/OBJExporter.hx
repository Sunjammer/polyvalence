package polyvalence.io;

import polyvalence.data.world.geom.Point;
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

	public function new() {}

	public function write(textWriter:Output) {
		var x = X.toDouble() * OBJExporter.SCALE * -1;
		var y = Y.toDouble() * OBJExporter.SCALE;
		var z = Z.toDouble() * OBJExporter.SCALE;
		textWriter.writeString('v $x $y $z\n');
	}
}

abstract RGB(Array<Float>) from Array<Float> to Array<Float> {
	public inline function new(r:Float = 0.2, g:Float = 0.2, b:Float = 0.2) {
		this = [r, g, b];
	}

	public inline function R():Float {
		return this[0];
	}

	public inline function G():Float {
		return this[1];
	}

	public inline function B():Float {
		return this[2];
	}

	public inline function toString():String {
		return this[0] + ' ' + this[1] + ' ' + this[2];
	}
}

class Material {
	public var name:String;
	public var Ka:RGB;
	public var Kd:RGB;
	public var Ks:RGB;
	public var illum:Int;
	public var Ns:Float;

	public function new(name, Ka, Kd, Ks, illum, Ns) {
		this.name = name;
		this.Ka = Ka;
		this.Kd = Kd;
		this.Ks = Ks;
		this.illum = illum;
		this.Ns = Ns;
	}

	public static function createRandom(name:String) {
		return new Material(name, [0, 0, 0], [Math.random(), Math.random(), Math.random()], [1, 1, 1], 1, 0.0);
	}

	public function write(textWriter:Output) {
		textWriter.writeString('newmtl $name\n');
		textWriter.writeString('Ka $Ka\n');
		textWriter.writeString('Kd $Kd\n');
		textWriter.writeString('Ks $Ks\n');
		textWriter.writeString('illum $illum\n');
		textWriter.writeString('Ns $Ns\n');
	}
}

class OBJFace {
	public var indices:Array<Int>;
	public var material:Material;

	public function new() {
		indices = [];
	}
}

class OBJExporter {
	public static final SCALE = 32.0;
	static final INVERTED = true;
	static final KEEP_LANDSCAPE_FACES = false;

	var level:Level;
	var vertices:Array<Vertex> = [];
	var endpointVertices:Array<Map<Int, Int>> = [];
	var faces:Array<OBJFace> = [];
	var materials:Map<Int, Material> = new Map();
	var currentMaterial:Material;

	public function new(level:Level) {
		this.level = level;
	}

	public function export(path:String) {
		faces = [];
		vertices = [];
		endpointVertices = [];
		materials = new Map();
		//trace(level.geom.endpoints);
		for (i in 0...level.geom.endpoints.length) {
			endpointVertices.push(new Map());
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

		for (m in materials) {
			m.write(writer);
		}

		for (v in vertices) {
			v.write(writer);
		}

		for (f in faces) {
			writeFace(writer, f);
		}

		writer.close();
	}

	function getVertexIndex(endpointIndex:Int, height:Int) {
		try{
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
		}catch(e:Dynamic){
			throw "Couldn't fetch vertex with index "+endpointIndex;
		}
	}

	function floorFace(p:Poly) {
		var ft = p.floor_texture;
		if (!materials.exists(ft)) {
			materials[ft] = Material.createRandom("tx" + ft);
		}
		var out = new OBJFace();
		var result:Array<Int> = [];
		for (i in 0...p.vertex_count) {
			result[i] = getVertexIndex(p.endpoint_indices[i], p.floor_height);
		}
		out.indices = result;
		out.material = materials[ft];
		return out;
	}

	function ceilingFace(p:Poly) {
		var ct = p.ceiling_texture;
		if (!materials.exists(ct)) {
			materials[ct] = Material.createRandom("tx" + ct);
		}

		var out = new OBJFace();
		var result = [];
		for (i in 0...p.vertex_count) {
			result[i] = getVertexIndex(p.endpoint_indices[i], p.ceiling_height);
		}
		out.indices = result;
		out.material = materials[ct];
		return out;
	}

	function buildFace(left:Int, right:Int, ceiling:Int, floor:Int, material:Material) {
		var out = new OBJFace();
		var result:Array<Int> = [];
		result[0] = getVertexIndex(left, floor);
		result[1] = getVertexIndex(right, floor);
		result[2] = getVertexIndex(right, ceiling);
		result[3] = getVertexIndex(left, ceiling);
		out.material = material;
		out.indices = result;
		return out;
	}

	function writeFace(w:Output, face:OBJFace) {
		if (face.material != currentMaterial) {
			currentMaterial = face.material;
			if (currentMaterial != null) {
				w.writeString("usemtl " + currentMaterial.name + "\n");
			}
		}
		w.writeString("f");
		for (i in 0...face.indices.length) {
			w.writeString(" " + (face.indices[i] + 1));
		}
		w.writeString('\n');
	}

	function insertLineFaces(line:Line, p:Poly) {
		var left;
		var right;
		var opposite:Poly = null;
		var side:Side = null;
		var pof = INVERTED ? line.poly_owner_back : line.poly_owner_front;
		var pob = INVERTED ? line.poly_owner_front : line.poly_owner_back;
		var psf = INVERTED ? line.poly_side_back : line.poly_side_front;
		var psb = INVERTED ? line.poly_side_front : line.poly_side_back;

		if (pof != -1 && level.geom.polys[pof] == p) {
			left = line.ep_start;
			right = line.ep_end;
			if (pob != -1) {
				opposite = level.geom.polys[pob];
			}
			if (psf != -1) {
				side = level.geom.sides[psf];
			}
		} else {
			left = line.ep_end;
			right = line.ep_start;
			if (pof != -1) {
				opposite = level.geom.polys[pof];
			}
			if (psb != -1) {
				side = level.geom.sides[psb];
			}
		}

		var landscapeTop = false;
		var landscapeBottom = false;
		var tx = -1;
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

			if (side.primary_texture != null) {
				tx = side.primary_texture.texture;
			} else if (side.secondary_texture != null) {
				tx = side.secondary_texture.texture;
			}
			if (tx != -1 && !materials.exists(tx)) {
				materials[tx] = Material.createRandom("tx" + tx);
			}
		}

		if (opposite == null || (opposite.floor_height > p.ceiling_height || opposite.ceiling_height < p.floor_height)) {
			if (!landscapeTop) {
				faces.push(buildFace(left, right, p.floor_height, p.ceiling_height, materials[tx]));
			}
		} else {
			if (opposite.floor_height > p.floor_height) {
				if (!landscapeBottom) {
					faces.push(buildFace(left, right, p.floor_height, opposite.floor_height, materials[tx]));
				}
			}
			if (opposite.ceiling_height < p.ceiling_height) {
				if (!landscapeTop) {
					faces.push(buildFace(left, right, opposite.ceiling_height, p.ceiling_height, materials[tx]));
				}
			}
		}
	}
}
