package;

import haxe.io.Bytes;
import polyvalence.io.Reader;

class Main{
    public static function main(){
        var args = Sys.args();
        //Reader.readWad('test_data/m1/Map.scen');
        Reader.readWad('test_data/m2/Map.sceA');
    }
}