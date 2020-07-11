package polyvalence.editor.views;

import js.Node.process;
import h2d.Text;

class VersionsView extends h2d.Flow implements h2d.domkit.Object {

    static var SRC =
        <versions-view layout="vertical">
            <text text={"system-version   " + process.platform + " " + process.arch} />
            <text text={"node-version     " + process.version}/>
            <text text={"electron-version " + process.versions['electron']}/>
        </versions-view>

    public function new(appversion:String, ?parent) {
        super(parent);
        initComponent();
    }
}

class MainView extends ViewBase {
	public function new(app:Shell) {
        super(app);

        var view = new VersionsView(app.version, app.s2d);
	}
}
