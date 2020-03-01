package;

import polyvalence.editor.Shell;
import polyvalence.data.world.meta.ComputerInterface;
import haxe.io.Bytes;
import polyvalence.io.Reader;

class Main{
    public static function main(){
        var args = Sys.args();

        new Shell();
    }
}