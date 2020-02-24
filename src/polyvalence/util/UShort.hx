package polyvalence.util;
import haxe.io.Bytes;

abstract UShort(Bytes){
    public inline function new(initValue:UInt = 0){
        this = Bytes.alloc(4);
        this.setUInt16(0, initValue);
    }
    public inline function set(v:UInt):UInt{
        this.setUInt16(0, v);
        return get();
    }
    public inline function get():UInt{
        return this.getUInt16(0);
    }
    
    @:to public function toUInt(){
        return get();
    }
    
    @:from static public function fromInt(int:Int):UShort{
        return new UShort(int);
    }

	@:op(A == B) private static inline function equalsUShort(a:UShort, b:UShort):Bool {
		return a.toUInt() == b.toUInt();
	}

    @:op(A & B) private static inline function and(a:UShort, b:UShort):UShort {
		return a.get() & b.get();
	}

	@:op(A | B) private static inline function or(a:UShort, b:UShort):UShort {
		return a.get() | b.get();
	}

	@:op(A ^ B) private static inline function xor(a:UShort, b:UShort):UShort {
		return a.get() ^ b.get();
	}

	@:op(A << B) private static inline function shl(a:UShort, b:Int):UShort {
		return a.get() << b;
	}

	@:op(A >> B) private static inline function shr(a:UShort, b:Int):UShort {
		return a.get() >>> b;
	}

	@:op(A >>> B) private static inline function ushr(a:UShort, b:Int):UShort {
		return a.get() >>> b;
    }
    
    public inline function toString(){
        return get()+'';
    }

}