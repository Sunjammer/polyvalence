package polyvalence.io;

class MacRoman{
    static final codes = [
        /* case 0x80: return */ "\xC3\x84", // A umlaut
        /* case 0x81: return */ "\xC3\x85", // A circle
        /* case 0x82: return */ "\xC3\x87", // C cedilla
        /* case 0x83: return */ "\xC3\x89", // E accent
        /* case 0x84: return */ "\xC3\x91", // N tilde
        /* case 0x85: return */ "\xC3\x96", // O umlaut
        /* case 0x86: return */ "\xC3\x9C", // U umlaut
        /* case 0x87: return */ "\xC3\xA1", // a accent
        /* case 0x88: return */ "\xC3\xA0", // a grave
        /* case 0x89: return */ "\xC3\xA2", // a circumflex
        /* case 0x8A: return */ "\xC3\xA4", // a umlaut
        /* case 0x8B: return */ "\xC3\xA3", // a tilde
        /* case 0x8C: return */ "\xC3\xA5", // a circle
        /* case 0x8D: return */ "\xC3\xA7", // c cedilla
        /* case 0x8E: return */ "\xC3\xA9", // e accent
        /* case 0x8F: return */ "\xC3\xA8", // e grave

        /* case 0x90: return */ "\xC3\xAA", // e circumflex
        /* case 0x91: return */ "\xC3\xAB", // e umlaut
        /* case 0x92: return */ "\xC3\xAD", // i accent
        /* case 0x93: return */ "\xC3\xAC", // i grave
        /* case 0x94: return */ "\xC3\xAE", // i circumflex
        /* case 0x95: return */ "\xC3\xAF", // i umlaut
        /* case 0x96: return */ "\xC3\xB1", // n tilde
        /* case 0x97: return */ "\xC3\xB3", // o accent
        /* case 0x98: return */ "\xC3\xB2", // o grave
        /* case 0x99: return */ "\xC3\xB4", // o circumflex
        /* case 0x9A: return */ "\xC3\xB6", // o umlaut
        /* case 0x9B: return */ "\xC3\xB5", // o tilde
        /* case 0x9C: return */ "\xC3\xBA", // u accent
        /* case 0x9D: return */ "\xC3\xB9", // u grave
        /* case 0x9E: return */ "\xC3\xBB", // u circumflex
        /* case 0x9F: return */ "\xC3\xBC", // u tilde

        /* case 0xA0: return */ "\xE2\x80\xA0", // cross
        /* case 0xA1: return */ "\xC2\xB0", // degree
        /* case 0xA2: return */ "\xC2\xA2", // cents
        /* case 0xA3: return */ "\xC2\xA3", // pounds
        /* case 0xA4: return */ "\xC2\xA7", // section
        /* case 0xA5: return */ "\xE2\x80\xA2", // bullet
        /* case 0xA6: return */ "\xC2\xB6", // pilcrow
        /* case 0xA7: return */ "\xC3\x9F", // german sharp S
        /* case 0xA8: return */ "\xC2\xAE", // registered
        /* case 0xA9: return */ "\xC2\xA9", // copyright
        /* case 0xAA: return */ "\xE2\x84\xA2", // TM
        /* case 0xAB: return */ "\xC2\xB4", // back tick
        /* case 0xAC: return */ "\xC2\xA8", // umlaut
        /* case 0xAD: return */ "\xE2\x89\xA0", // not equal (not in Windows 1252)
        /* case 0xAE: return */ "\xC3\x86", // AE
        /* case 0xAF: return */ "\xC3\x98", // O slash

        /* case 0xB0: return */ "\xE2\x88\x9E", // infinity (not in Windows 1252)
        /* case 0xB1: return */ "\xC2\xB1", // plus or minus
        /* case 0xB2: return */ "\xE2\x89\xA4", // less than or equal (not in Windows 1252)
        /* case 0xB3: return */ "\xE2\x89\xA5", // greater than or equal (not in Windows 1252)
        /* case 0xB4: return */ "\xC2\xA5", // yen
        /* case 0xB5: return */ "\xC2\xB5", // mu
        /* case 0xB6: return */ "\xE2\x88\x82", // derivative (not in Windows 1252)
        /* case 0xB7: return */ "\xE2\x88\x91", // large sigma (not in Windows 1252)
        /* case 0xB8: return */ "\xE2\x88\x8F", // large pi (not in Windows 1252)
        /* case 0xB9: return */ "\xCF\x80", // small pi (not in Windows 1252)
        /* case 0xBA: return */ "\xE2\x88\xAB", // integral (not in Windows 1252)
        /* case 0xBB: return */ "\xC2\xAA", // feminine ordinal
        /* case 0xBC: return */ "\xC2\xBA", // masculine ordinal
        /* case 0xBD: return */ "\xCE\xA9", // large ohm (not in Windows 1252)
        /* case 0xBE: return */ "\xC3\xA6", // ae
        /* case 0xBF: return */ "\xC3\xB8", // o slash

        /* case 0xC0: return */ "\xC2\xBF", // inverted question mark
        /* case 0xC1: return */ "\xC2\xA1", // inverted exclamation mark
        /* case 0xC2: return */ "\xC2\xAC", // not
        /* case 0xC3: return */ "\xE2\x88\x9A", // root (not in Windows 1252)
        /* case 0xC4: return */ "\xC6\x92", // function
        /* case 0xC5: return */ "\xE2\x89\x88", // approximately equal (not in Windows 1252)
        /* case 0xC6: return */ "\xE2\x88\x86", // large delta (not in Windows 1252)
        /* case 0xC7: return */ "\xC2\xAB", // open angle quotation mark
        /* case 0xC8: return */ "\xC2\xBB", // close angle quotation mark
        /* case 0xC9: return */ "\xE2\x80\xA6", // ellipsis
        /* case 0xCA: return */ "\xC2\xA0", // NBSP
        /* case 0xCB: return */ "\xC3\x80", // A grave
        /* case 0xCC: return */ "\xC3\x83", // A tilde
        /* case 0xCD: return */ "\xC3\x95", // O tilde
        /* case 0xCE: return */ "\xC5\x92", // OE
        /* case 0xCF: return */ "\xC5\x93", // oe

        /* case 0xD0: return */ "\xE2\x80\x93", // en dash
        /* case 0xD1: return */ "\xE2\x80\x94", // em dash
        /* case 0xD2: return */ "\xE2\x80\x9C", // open smart double quote
        /* case 0xD3: return */ "\xE2\x80\x9D", // close smart double quote
        /* case 0xD4: return */ "\xE2\x80\x98", // open smart single quote
        /* case 0xD5: return */ "\xE2\x80\x99", // close smart single quote
        /* case 0xD6: return */ "\xC3\xB7", // divided
        /* case 0xD7: return */ "\xE2\x97\x8A", // diamond (not in Windows 1252)
        /* case 0xD8: return */ "\xC3\xBF", // y umlaut
        /* case 0xD9: return */ "\xC5\xB8", // Y umlaut
        /* case 0xDA: return */ "\xE2\x81\x84", // big slash (not in Windows 1252)
        /* case 0xDB: return */ "\xE2\x82\xAC", // euro (not in Windows 1252)
        /* case 0xDC: return */ "\xE2\x80\xB9", // open angle single quote
        /* case 0xDD: return */ "\xE2\x80\xBA", // close angle single quote
        /* case 0xDE: return */ "\xEF\xAC\x81", // fi ligature (not in Windows 1252)
        /* case 0xDF: return */ "\xEF\xAC\x82", // fl ligature (not in Windows 1252)

        /* case 0xE0: return */ "\xE2\x80\xA1", // double dagger
        /* case 0xE1: return */ "\xC2\xB7", // interpunct
        /* case 0xE2: return */ "\xE2\x80\x9A", // inverted smart single quote
        /* case 0xE3: return */ "\xE2\x80\x9E", // inverted smart double quote
        /* case 0xE4: return */ "\xE2\x80\xB0", // per mille
        /* case 0xE5: return */ "\xC3\x82", // A circumflex
        /* case 0xE6: return */ "\xC3\x8A", // E circumflex
        /* case 0xE7: return */ "\xC3\x81", // A accent
        /* case 0xE8: return */ "\xC3\x8B", // E umlaut
        /* case 0xE9: return */ "\xC3\x88", // E grave
        /* case 0xEA: return */ "\xC3\x8D", // I accent
        /* case 0xEB: return */ "\xC3\x8E", // I circumflex
        /* case 0xEC: return */ "\xC3\x8F", // I umlaut
        /* case 0xED: return */ "\xC3\x8C", // I grave
        /* case 0xEE: return */ "\xC3\x93", // O accent
        /* case 0xEF: return */ "\xC3\x94", // O circumflex

        /* case 0xF0: return */ "\xEF\xA3\xBF", // box (not in Windows 1252)
        /* case 0xF1: return */ "\xC3\x92", // O grave
        /* case 0xF2: return */ "\xC3\x9A", // U accent
        /* case 0xF3: return */ "\xC3\x9B", // U circumflex
        /* case 0xF4: return */ "\xC3\x99", // U grave
        /* case 0xF5: return */ "\xC4\xB1", // dotless i ligature (not in Windows 1252)
        /* case 0xF6: return */ "\xCB\x86", // circumflex
        /* case 0xF7: return */ "\xCB\x9C", // tilde
        /* case 0xF8: return */ "\xC2\xAF", // macron
        /* case 0xF9: return */ "\xCB\x98", // breve (not in Windows 1252)
        /* case 0xFA: return */ "\xCB\x99", // raised dot (not in Windows 1252)
        /* case 0xFB: return */ "\xCB\x9A", // ring
        /* case 0xFC: return */ "\xC2\xB8", // cedilla
        /* case 0xFD: return */ "\xCB\x9D", // double acute accent (not in Windows 1252)
        /* case 0xFE: return */ "\xCB\x9B", // ogonek (not in Windows 1252)
        /* case 0xFF: return */ "\xCB\x87", // caron (not in Windows 1252)
    ]; 

    public static function convertMacRomanCharacterToUtf8( c:UInt ):UInt {
        return c;
        /*
        if ( c >= 0x80 ){
            return strings[ c - 0x80 ];
        }
        return c;*/
    }
    
}