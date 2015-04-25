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

class SelectableEntity extends FlxSprite {

	public var hitbox: Int;
	public var name: String;
	public var selected: Bool;
	public var selectionCircle: FlxSprite;
	public var selectionOffset: FlxPoint;
	public var attackable: Bool;
	
	public function new( x: Float, y: Float, image: String, name: String, selectionOffset: FlxPoint, hitbox: Int ) {
		super(x, y, image);
		this.hitbox = hitbox;
		this.name = name;
		this.selected = false;
		this.selectionOffset = selectionOffset;
		this.attackable = false;
		
		selectionCircle = new FlxSprite(0, 0, "assets/images/SelectionCircle.png");
	}
	
	override public function update() {
		super.update();
	}
	
	override public function draw() {
		if( selected ) {
			selectionCircle.x = this.x + selectionOffset.x;
			selectionCircle.y = this.y + selectionOffset.y;
			selectionCircle.draw();
		}
		super.draw();
	}
	
	public function moveCommand( destination: FlxPoint ) {
		trace( '$name moving to $destination' );
	}
	
	public function attackCommand( target: SelectableEntity ) {
		trace( '$name attempting to attack ${target.name}' );
	}
}

class SelectionSystem extends FlxGroup {
	
	private var selectedEntities : Array<SelectableEntity> = [];
	
	private var touchDownPoint = new FlxPoint(0,0);

	public function new() {
		super();
	}
	
	override public function update() {
		super.update();
		
		doSelection();
	}
	
	public function singleselect( entity: SelectableEntity ) {
		
		wipeselection();
		addtoselection(entity);
		
	}
	
	public function addtoselection( entity: SelectableEntity ) {
		
		selectedEntities.push(entity);
		
		trace( 'Selected: ${entity.name}' );
		
		PlayState.levelManager.forEachOfType( SelectableEntity, function(ent) {
			if ( ent == entity ) {
				ent.selected = true;
			}
		} );
		
	}
	
	public function wipeselection() {
		
		selectedEntities = [];
		
		PlayState.levelManager.forEachOfType( SelectableEntity, function(ent) {
				ent.selected = false;
		} );
		
	}
	
	function doSelection():Void {
		if ( FlxG.mouse.justReleased && FlxMath.getDistance(touchDownPoint, FlxG.mouse.getScreenPosition() ) < 8 ) {
			tapselect();
		}
		
		if ( FlxG.mouse.justPressed ) {
			touchDownPoint = FlxG.mouse.getScreenPosition();
		}
	}
	
	function tapselect():Void {
		var count = 0;
		PlayState.levelManager.forEachOfType( SelectableEntity, function(ent) {
			var pos = FlxG.mouse.getWorldPosition();
				
			if ( FlxMath.distanceToPoint(ent, pos ) < ent.hitbox ) {
				if( !ent.attackable ) {
					singleselect( ent );
					++count;
				}
			}
		} );
		
		if ( count < 1 ) {
			for ( ent in selectedEntities ) {
				var target : SelectableEntity = null;
				PlayState.levelManager.forEachOfType( SelectableEntity, function(ent) {
					var pos = FlxG.mouse.getWorldPosition();
						
					if ( FlxMath.distanceToPoint(ent, pos ) < ent.hitbox ) {
						target = ent;
					}
				} );

				ent.moveCommand( FlxG.mouse.getWorldPosition()  );
				
				if ( target != null )
					ent.attackCommand( target );
			}
			wipeselection();
		}
	}
	
}