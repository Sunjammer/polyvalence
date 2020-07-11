package;

import polyvalence.editor.Shell;
import js.Browser.console;
import js.Browser.document;
import js.Browser.window;

class App{
    public static function main(){
        window.onload = function() {
            new Shell();
        }
    }
}