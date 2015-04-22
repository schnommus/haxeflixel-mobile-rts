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
	public var text: FlxText;
	var delta = 0.0;
	var map: FlxOgmoLoader;
	var terrain: FlxTilemap;
	private var last:FlxPoint = new FlxPoint();
	
	var animatedTiles : Array<Array<Int>>;
	
	// Called when the state is created
	override public function create():Void {
		super.create();
		
		map = new FlxOgmoLoader( "assets/data/awesomelevel.oel" );
		terrain = map.loadTilemap( "assets/images/terrain.png", 16, 16, "landscape" );
		add(terrain);
		map.loadEntities( entityPlacer, "entities" );
		
		animatedTiles = Json.parse( File.getContent("assets/data/terraindata.json") ).animatedframes;
		
	}
	
	public function entityPlacer( name: String, data: Xml ) {
		var image:String = null;
		
		switch( name ) {
			case "cactus": image = "assets/images/cactus.png";
			case "succulent": image = "assets/images/succulent.png";
			case "palmtree": image = "assets/images/palmtree.png";
		}
		
		if( image != null ) {
			var spr = new FlxSprite( Std.parseFloat(data.get("x")), Std.parseFloat(data.get("y")), image );
			add(spr);
		}
	}
	
	// Called when the state is destroyed.
	// Good to set things to null here; helps GC
	override public function destroy():Void {
		super.destroy();
	}

	// Called every frame
	override public function update():Void {
		super.update();

		delta += FlxG.elapsed;
		if ( delta > 0.3 ) {
			delta -= 0.3;
			nextTileFrame();
		}
		
		scrollCamera();	
	}
	
	// Animates tiles
	function nextTileFrame():Void {
		for ( tileSubset in animatedTiles ) {
			for( tileType in tileSubset ) {
				if ( terrain.getTileInstances(tileType) != null ) {
					for ( tile in terrain.getTileInstances(tileType) ) {
						var newTile = tileType+1;
						if ( newTile > tileSubset[tileSubset.length - 1] ) {
							newTile = tileSubset[0];
						}
						terrain.setTileByIndex( tile, newTile );
					}
					break;
				}
			}
		}
	}
	
	function scrollCamera():Void {
		#if mobile
		
		if ( FlxG.touches.justStarted().length != 0 ) {
			last.x = FlxG.touches.getFirst().getScreenPosition().x;
			last.y = FlxG.touches.getFirst().getScreenPosition().y;
		}
	 
		if ( FlxG.touches.getFirst() != null ) {
			FlxG.camera.scroll.x -= FlxG.touches.getFirst().getScreenPosition().x - last.x;
			FlxG.camera.scroll.y -= FlxG.touches.getFirst().getScreenPosition().y - last.y;
			last.x = FlxG.touches.getFirst().getScreenPosition().x;
			last.y = FlxG.touches.getFirst().getScreenPosition().y;
		}
		
		#else 
		
		if (FlxG.mouse.justPressed ) {
			last.x = FlxG.mouse.screenX;
			last.y = FlxG.mouse.screenY;
		}
	 
		if (FlxG.mouse.pressed ) {
			FlxG.camera.scroll.x -= FlxG.mouse.screenX - last.x;
			FlxG.camera.scroll.y -= FlxG.mouse.screenY - last.y;
			last.x = FlxG.mouse.screenX;
			last.y = FlxG.mouse.screenY;
		}
		
		#end
	
	}
}