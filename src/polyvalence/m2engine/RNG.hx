package polyvalence.m2engine;

class RNG {
	static inline final DEFAULT_RANDOM_SEED = 0xfded;
	static var random_seed:Int = 0x1;
	static var local_random_seed:Int = 0x1;

	public static function set_random_seed(seed:Int) {
		random_seed = seed != 0 ? seed : DEFAULT_RANDOM_SEED;

		return;
	}

	public static function get_random_seed():Int {
		return random_seed;
	}

	public static function random():Int {
		var seed = random_seed;

		if (seed & 1 != 0) {
			seed = (seed >> 1) ^ 0xb400;
		} else {
			seed >>= 1;
		}

		return (random_seed = seed);
	}

	public static function local_random():Int {
		var seed = local_random_seed;

		if (seed & 1 != 0) {
			seed = (seed >> 1) ^ 0xb400;
		} else {
			seed >>= 1;
		}

		return (local_random_seed = seed);
	}
}
