package;

import Std;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import sys.io.File;
import haxe.Json;

// FlxState for the actual gameplay
class PlayState extends FlxState {
	
	private var levelManager : LevelManager;
	private var cameraController : CameraController;
	
	// Called when the state is created
	override public function create():Void {
		super.create();
		
		levelManager = new LevelManager();
		add(levelManager);
		
		cameraController = new CameraController();
		add(cameraController);
	}
	
	// Called when the state is destroyed.
	// Good to set things to null here; helps GC
	override public function destroy():Void {
		super.destroy();
	}

	// Called every frame
	override public function update():Void {
		super.update();
	}
	
	
}