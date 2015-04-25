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
	
	public static var levelManager : LevelManager;
	private var cameraController : CameraController;
	private var selectionSystem : SelectionSystem;
	
	// Called when the state is created
	override public function create():Void {
		super.create();
		
		levelManager = new LevelManager();
		cameraController = new CameraController();
		selectionSystem = new SelectionSystem();
		add(levelManager);
		add(cameraController);
		add(selectionSystem);
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