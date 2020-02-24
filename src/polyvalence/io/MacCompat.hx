package polyvalence.io;

import sys.io.FileInput;
import polyvalence.util.UShort;

class MacCompat {
	static final HEADER_SIZE = 128;

	public static function readMacString(fi:FileInput, length:Int) {
		var str = fi.readString(length, RawNative);
		return str.split('0')[0];
	}

	public static function readUint32B(fp:FileInput):UInt {
		var byte1 = fp.readByte();
		var byte2 = fp.readByte();
		var byte3 = fp.readByte();
		var byte4 = fp.readByte();
		return ((byte1 << 24) | (byte2 << 16) | (byte3 << 8) | (byte4));
	}

	public static function checkAppleS(fp:FileInput, fileSize:UInt):UInt {
		var origin = fp.tell();
		fp.bigEndian = true;
		var num:UInt;

		try {
			if (readUint32B(fp) != 0x51600 || readUint32B(fp) != 0x20000)
				throw 'nope';

			fp.seek(16, SeekCur);

			num = fp.readUInt16();
			while (num-- != 0) {
				var fid = readUint32B(fp);
				var ofs = fp.readInt32();
				var len = fp.readInt32();

				if (fid == 1) {
					if (ofs + len > fileSize)
						throw 'nope';
					fp.seek(ofs, SeekBegin);
					return ofs;
				}
			}
		} catch (e:Dynamic) {}
		fp.seek(origin, SeekBegin);
		return 0;
	}

	/// Checks for a MacBin header. Returns offset to data if any.
	public static function checkMacBin(fp:FileInput, fileSize:UInt):UInt {
		var origin = fp.tell();
		var bufu = fp.read(128);
		var crc16:UShort = 0;

		try {
			if (bufu.get(0) != 0 || bufu.get(1) > 63 || bufu.get(74) != 0 || bufu.get(123) > 0x81)
				throw 'nope';

			for (i in 0...124) {
				var data:UShort = bufu.get(i) << 8;
				// var data = cast(ushort)(bufu[i] << 8);

				for (j in 0...8) {
					if (((data ^ crc16) & 0x8000) != 0)
						// crc16 = cast(ushort)(crc16 << 1) ^ 0x1021;
						crc16 = (crc16 << 1) ^ 0x1021;
					else
						crc16 <<= 1;

					data <<= 1;
				}
			}
            var crc:UShort = (bufu.get(124) << 8) | bufu.get(125);
			if (crc == crc16){
				return 128;
            }
		} catch (e:Dynamic) {}
		fp.seek(origin, SeekBegin);
		return 0;
	}

	/// Reads a MacBin or AppleSingle header if there is one
	/// and returns the offset from the start of the header to
	/// the resource fork (if one is found.)
	public static function tryMacHeader(fp:FileInput, fileSize:UInt):UInt {
        var sz = checkMacBin(fp, fileSize);
		if (sz != 0)
			return sz;
		else
			return checkAppleS(fp, fileSize);
	}
}
