package polyvalence.data.world;

/* ---------- types */
typedef Angle = Int;
typedef World_distance = Int;

class World {
	/* ---------- constants */
	public static inline var TRIG_SHIFT:Int = 10;
	public static inline var TRIG_MAGNITUDE:Int = (1 << TRIG_SHIFT);

	public static inline var ANGULAR_BITS:Int = 9;
	public static inline var NUMBER_OF_ANGLES:Int = (1 << ANGULAR_BITS);
	public static inline var FULL_CIRCLE:Int = NUMBER_OF_ANGLES;
	public static inline var QUARTER_CIRCLE:Int = Std.int(NUMBER_OF_ANGLES / 4);
	public static inline var HALF_CIRCLE:Int = Std.int(NUMBER_OF_ANGLES / 2);
	public static inline var THREE_QUARTER_CIRCLE:Int = Std.int((NUMBER_OF_ANGLES * 3) / 4);
	public static inline var EIGHTH_CIRCLE:Int = Std.int(NUMBER_OF_ANGLES / 8);
	public static inline var SIXTEENTH_CIRCLE:Int = Std.int(NUMBER_OF_ANGLES / 16);

    public static inline var FIXED_FRACTIONAL_BITS:Int = 16;
	public static inline var WORLD_FRACTIONAL_BITS:Int = 10;
	public static inline var WORLD_ONE:Int = 1 << WORLD_FRACTIONAL_BITS;
	public static inline var WORLD_ONE_HALF:Int = Std.int(WORLD_ONE / 2);
	public static inline var WORLD_ONE_FOURTH:Int = Std.int(WORLD_ONE / 4);
	public static inline var WORLD_THREE_FOURTHS:Int = Std.int((WORLD_ONE * 3) / 4);

	public static inline var DEFAULT_RANDOM_SEED = 0xfded; // word

	/* ---------- macros */
	public static inline function INTEGER_TO_WORLD(s) {
		return s << WORLD_FRACTIONAL_BITS;
	}

	public static inline function WORLD_FRACTIONAL_PART(d) {
		return d & (WORLD_ONE - 1);
	}

	public static inline function WORLD_INTEGERAL_PART(d) {
		return d >> WORLD_FRACTIONAL_BITS;
	}

	public static inline function WORLD_TO_FIXED(w) {
		return w << (FIXED_FRACTIONAL_BITS - WORLD_FRACTIONAL_BITS);
	}

	public static inline function FIXED_TO_WORLD(f) {
		return f >> (FIXED_FRACTIONAL_BITS - WORLD_FRACTIONAL_BITS);
	}

	public static inline function FACING4(a) {
		return (NORMALIZE_ANGLE((a) - EIGHTH_CIRCLE) >> (ANGULAR_BITS - 2));
	}

	public static inline function FACING5(a) {
		return ((NORMALIZE_ANGLE((a) - Std.int(FULL_CIRCLE / 10))) / ((NUMBER_OF_ANGLES / 5) + 1));
	}

	public static inline function FACING8(a) {
		return (NORMALIZE_ANGLE((a) - SIXTEENTH_CIRCLE) >> (ANGULAR_BITS - 3));
	}

	/* arguments must be positive (!) or use guess_hypotenuse() */
	public static inline function GUESS_HYPOTENUSE(x, y) {
		return ((x) > (y) ? ((x) + ((y) >> 1)) : ((y) + ((x) >> 1)));
	}

	/* -360�<t<720� (!) or use normalize_angle() */
	// public static inline NORMALIZE_ANGLE(t) ((t)<(angle)0?(t)+NUMBER_OF_ANGLES:((t)>=NUMBER_OF_ANGLES?(t)-NUMBER_OF_ANGLES:(t)))
	public static inline function NORMALIZE_ANGLE(t) {
		return t & (NUMBER_OF_ANGLES - 1);
	}
}
