package polyvalence.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

class TagMacros {
    #if macro
    
    static function strToUint32(str:String):Int{
        if(str.length!=4) 
            throw 'Input must be exactly 4 characters';
        var byte1 = str.charCodeAt(0);
        var byte2 = str.charCodeAt(1);
        var byte3 = str.charCodeAt(2);
        var byte4 = str.charCodeAt(3);
        return ((byte1 << 24) | (byte2 << 16) | (byte3 << 8) | byte4);
    }

	// Replace string keys with big-endian uint32s
	public static function buildTags() {
		var fields = Context.getBuildFields();
		fields = fields.map(f -> {
			switch (f.kind) {
				case FVar(_, expr):
					switch (expr.expr) {
						case EConst(CString(value, _)):
                            expr.expr = EConst(CInt(strToUint32(value) + ''));
						default:
					}
				default:
			}
			return f;
		});
		return fields;
	}
	#end
}
