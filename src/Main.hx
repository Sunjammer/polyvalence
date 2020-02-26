package;

import polyvalence.data.world.meta.ComputerInterface;
import haxe.io.Bytes;
import polyvalence.io.Reader;

class Main{
    public static function main(){
        var args = Sys.args();

        var wads = [
            'test_data/m2/Map.sceA',
            'test_data/m2/Images.imgA',
            //'test_data/m2/Sounds.sndA',
            //'test_data/m2/Shapes.shpA'
        ];
        //Reader.readWad('test_data/m1/Map.scen');
        for(w in wads){
            var wad = Reader.readWad(w);
    
            for(e in wad.directory){
                for(c in e.chunks){
                    polyvalence.data.wad.transform.DataFromChunk.fromChunk(c);
                }
                break;
            }
        }
    }
}