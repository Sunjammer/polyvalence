package polyvalence.io;
using StringTools;

class MacRoman {
	static function toUTF8(code:Int):Int {
        return switch (code) {
			case 0x80: "Ä".code; // A umlaut
			case 0x81: "Å".code; // A circle
			case 0x82: "Ç".code; // C cedilla
			case 0x83: "É".code; // E accent
			case 0x84: "Ñ".code; // N tilde
			case 0x85: "Ö".code; // O umlaut
			case 0x86: "Ü".code; // U umlaut
			case 0x87: "á".code; // a accent
			case 0x88: "à".code; // a grave
			case 0x89: "â".code; // a circumflex
			case 0x8A: "ä".code; // a umlaut
			case 0x8B: "ã".code; // a tilde
			case 0x8C: "å".code; // a circle
			case 0x8D: "ç".code; // c cedilla
			case 0x8E: "é".code; // e accent
			case 0x8F: "è".code; // e grave
			case 0x90: "ê".code; // e circumflex
			case 0x91: "ë".code; // e umlaut
			case 0x92: "í".code; // i accent
			case 0x93: "ì".code; // i grave
			case 0x94: "î".code; // i circumflex
			case 0x95: "ï".code; // i umlaut
			case 0x96: "ñ".code; // n tilde
			case 0x97: "ó".code; // o accent
			case 0x98: "ò".code; // o grave
			case 0x99: "ô".code; // o circumflex
			case 0x9A: "ö".code; // o umlaut
			case 0x9B: "õ".code; // o tilde
			case 0x9C: "ú".code; // u accent
			case 0x9D: "ù".code; // u grave
			case 0x9E: "û".code; // u circumflex
			case 0x9F: "ü".code; // u umlaut
			case 0xA0: "†".code; // cross
			case 0xA1: "°".code; // degree
			case 0xA2: "¢".code; // cents
			case 0xA3: "£".code; // pounds
			case 0xA4: "§".code; // section
			case 0xA5: "•".code; // bullet
			case 0xA6: "¶".code; // pilcrow
			case 0xA7: "ß".code; // german sharp S
			case 0xA8: "®".code; // registered
			case 0xA9: "©".code; // copyright
			case 0xAA: "™".code; // TM
			case 0xAB: "´".code; // back tick
			case 0xAC: "¨".code; // umlaut
			case 0xAD: "≠".code; // not equal (not in Windows 1252)
			case 0xAE: "Æ".code; // AE
			case 0xAF: "Ø".code; // O slash
			case 0xB0: "∞".code; // infinity (not in Windows 1252)
			case 0xB1: "±".code; // plus or minus
			case 0xB2: "≤".code; // less than or equal (not in Windows 1252)
			case 0xB3: "≥".code; // greater than or equal (not in Windows 1252)
			case 0xB4: "¥".code; // yen
			case 0xB5: "µ".code; // mu
			case 0xB6: "∂".code; // derivative (not in Windows 1252)
			case 0xB7: "∑".code; // large sigma (not in Windows 1252)
			case 0xB8: "∏".code; // large pi (not in Windows 1252)
			case 0xB9: "π".code; // small pi (not in Windows 1252)
			case 0xBA: "∫".code; // integral (not in Windows 1252)
			case 0xBB: "ª".code; // feminine ordinal
			case 0xBC: "º".code; // masculine ordinal
			case 0xBD: "Ω".code; // large ohm (not in Windows 1252)
			case 0xBE: "æ".code; // ae
			case 0xBF: "ø".code; // o slash
			case 0xC0: "¿".code; // inverted question mark
			case 0xC1: "¡".code; // inverted exclamation mark
			case 0xC2: "¬".code; // not
			case 0xC3: "√".code; // root (not in Windows 1252)
			case 0xC4: "ƒ".code; // function
			case 0xC5: "≈".code; // approximately equal (not in Windows 1252)
			case 0xC6: "∆".code; // large delta (not in Windows 1252)
			case 0xC7: "«".code; // open angle quotation mark
			case 0xC8: "»".code; // close angle quotation mark
			case 0xC9: "…".code; // ellipsis
			case 0xCA: " ".code; // NBSP
			case 0xCB: "À".code; // A grave
			case 0xCC: "Ã".code; // A tilde
			case 0xCD: "Õ".code; // O tilde
			case 0xCE: "Œ".code; // OE
			case 0xCF: "œ".code; // oe
			case 0xD0: "–".code; // en dash
			case 0xD1: "—".code; // em dash
			case 0xD2: "“".code; // open smart double quote
			case 0xD3: "”".code; // close smart double quote
			case 0xD4: "‘".code; // open smart single quote
			case 0xD5: "’".code; // close smart single quote
			case 0xD6: "÷".code; // divided
			case 0xD7: "◊".code; // diamond (not in Windows 1252)
			case 0xD8: "ÿ".code; // y umlaut
			case 0xD9: "Ÿ".code; // Y umlaut
			case 0xDA: "⁄".code; // big slash (not in Windows 1252)
			case 0xDB: "€".code; // euro (not in Windows 1252)
			case 0xDC: "‹".code; // open angle single quote
			case 0xDD: "›".code; // close angle single quote
			case 0xDE: "ﬁ".code; // fi ligature (not in Windows 1252)
			case 0xDF: "ﬂ".code; // fl ligature (not in Windows 1252)
			case 0xE0: "‡".code; // double dagger
			case 0xE1: "·".code; // interpunct
			case 0xE2: "‚".code; // inverted smart single quote
			case 0xE3: "„".code; // inverted smart double quote
			case 0xE4: "‰".code; // per mille
			case 0xE5: "Â".code; // A circumflex
			case 0xE6: "Ê".code; // E circumflex
			case 0xE7: "Á".code; // A accent
			case 0xE8: "Ë".code; // E umlaut
			case 0xE9: "È".code; // E grave
			case 0xEA: "Í".code; // I accent
			case 0xEB: "Î".code; // I circumflex
			case 0xEC: "Ï".code; // I umlaut
			case 0xED: "Ì".code; // I grave
			case 0xEE: "Ó".code; // O accent
			case 0xEF: "Ô".code; // O circumflex
			case 0xF0: "".code; // box (not in Windows 1252)
			case 0xF1: "Ò".code; // O grave
			case 0xF2: "Ú".code; // U accent
			case 0xF3: "Û".code; // U circumflex
			case 0xF4: "Ù".code; // U grave
			case 0xF5: "ı".code; // dotless i ligature (not in Windows 1252)
			case 0xF6: "ˆ".code; // circumflex
			case 0xF7: "˜".code; // tilde
			case 0xF8: "¯".code; // macrn
			case 0xF9: "˘".code; // breve (not in Windows 1252)
			case 0xFA: "˙".code; // raised dot (not in Windows 1252)
			case 0xFB: "˚".code; // ring
			case 0xFC: "¸".code; // cedilla
			case 0xFD: "˝".code; // double acute accent (not in Windows 1252)
			case 0xFE: "˛".code; // ogonek (not in Windows 1252)
			case 0xFF: "ˇ".code; // caron (not in Windows 1252)
			default:
				code;
        }
	}

	public static function convert(c:Int):Int {
        /*if ( c >= 0x80 ){
            c -= 0x80;
        }*/
        return toUTF8(c); 
	}
}
