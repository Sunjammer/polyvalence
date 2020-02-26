package;

import polyvalence.data.world.meta.ComputerInterface;
import haxe.io.Bytes;
import polyvalence.io.Reader;

class Main{
    public static function main(){
        var args = Sys.args();

        //Reader.readWad('test_data/m1/Map.scen');
        var wad = Reader.readWad('test_data/m2/Map.sceA');

        for(e in wad.directory){
            for(c in e.chunks){
                polyvalence.data.wad.transform.DataFromChunk.fromChunk(c);
            }
            break;
        }
    }
}