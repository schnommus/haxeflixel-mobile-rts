package;

import Std;
import flixel.group.FlxGroup;
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


class LevelManager extends FlxGroup {

	private var map: FlxOgmoLoader;
	private var terrain: FlxTilemap;
	
	private var animatedTiles : Array<Array<Int>>;
	private var tileAnimationElapsed = 0.0;
	
	public function new() {
		super();
		
		map = new FlxOgmoLoader( "assets/data/awesomelevel.oel" );
		
		terrain = map.loadTilemap( "assets/images/terrain.png", 16, 16, "landscape" );
		add(terrain);
		
		map.loadEntities( entityPlacer, "entities" );
		
		animatedTiles = Json.parse( File.getContent("assets/data/terraindata.json") ).animatedframes;
	}
	
	override public function update() {
		super.update();

		animateTiles();
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
	
	function animateTiles() {
		tileAnimationElapsed += FlxG.elapsed;
		if ( tileAnimationElapsed > 0.3 ) {
			tileAnimationElapsed -= 0.3;
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
	}
	
}