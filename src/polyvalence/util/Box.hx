package polyvalence.util;

abstract Box<T>(Array<T>){
    public var value(get,set):T;
    public inline function new(v:T){
        this = [v];
    }
    public inline function get_value():T{
        return this[0];
    }
    public inline function set_value(v:T):T{
        return this[0] = v;
    }
    
    @:to public function toT():T{
        return this[0];
    }
    
    @:from static public function fromT<T>(v:T):Box<T>{
        return new Box(v);
    }

}