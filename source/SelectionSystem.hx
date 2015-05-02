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
import flixel.input.touch.FlxTouch;
import flixel.util.FlxColor;

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
		
		this.offset.x = this.width / 2;
		this.offset.y = this.height / 2;
		
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
	
	public function moveCommand( destination: FlxPoint ) : Bool {
		trace( '$name moving to $destination' );
		return false;
	}
	
	public function attackCommand( target: SelectableEntity ) {
		trace( '$name attempting to attack ${target.name}' );
	}
}

class SelectionSystem extends FlxGroup {
	
	private var selectedEntities : Array<SelectableEntity> = [];
	
	private var touchDownPoint = new FlxPoint(0, 0);
	private var touchDownSpace = new FlxPoint(0, 0);
	private var selectedText: FlxText;

	public function new() {
		super();
		
		var black = new FlxSprite(0, FlxG.height-17);
		black.makeGraphic( 320, 18, FlxColor.BLACK );
		black.alpha = 0.7;
		black.scrollFactor.set(0, 0);
		add( black );
		
		selectedText = new FlxText( 0, 0, 0, "Nothing selected." );
		selectedText.setFormat("assets/fonts/RiskofRainFont.ttf", 8, 0xFFFFFF, "center");
		selectedText.setPosition( FlxG.width - selectedText.textField.textWidth - 10, FlxG.height - 16 );
		selectedText.scrollFactor.set(0, 0);
		add(selectedText);
	}
	
	override public function update() {
		super.update();
		
		doSelection();
		
		if ( selectedEntities.length > 0 ) {
			selectedText.text = selectedEntities[0].name;
		} else {
			selectedText.text = "Nothing selected.";
		}
		
		selectedText.setPosition( FlxG.width - selectedText.textField.textWidth - 10, FlxG.height - 16 );
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
		
		#if mobile
		
		var touchesReleased: Array<FlxTouch> = null;
		touchesReleased = FlxG.touches.justReleased();
		
		if ( touchesReleased != null) {
			if(  touchesReleased.length > 0 && FlxMath.getDistance(touchDownPoint, touchesReleased[0].getScreenPosition() ) < 8 ) {
				tapselect();
			}
		}
		
		var touchesStarted: Array<FlxTouch> = null;
		touchesStarted = FlxG.touches.justStarted();
		
		if( touchesStarted != null ) {
			if ( touchesStarted.length > 0 ) {
				touchDownPoint = touchesStarted[0].getScreenPosition();
				touchDownSpace = touchesStarted[0].getWorldPosition();
			}
		}
		
		#else
		
		if ( FlxG.mouse.justReleased && FlxMath.getDistance(touchDownPoint, FlxG.mouse.getScreenPosition() ) < 8 ) {
			tapselect();
		}
		
		if ( FlxG.mouse.justPressed ) {
			touchDownPoint = FlxG.mouse.getScreenPosition();
		}
		
		#end
	}
	
	function tapselect():Void {
		
		#if mobile
		var touchPosition = touchDownSpace;
		#else
		var touchPosition = FlxG.mouse.getWorldPosition();
		#end
		
		var count = 0;
		PlayState.levelManager.forEachOfType( SelectableEntity, function(ent) {
			var pos = touchPosition;
				
			if ( FlxMath.getDistance(new FlxPoint(ent.x-ent.offset.x/2, ent.y-ent.offset.y/2), pos ) < ent.hitbox ) {
				if( !ent.attackable ) {
					singleselect( ent );
					++count;
				}
			}
		} );
		
		if ( count < 1 ) {
			var success = false;
			for ( ent in selectedEntities ) {
				var target : SelectableEntity = null;
				PlayState.levelManager.forEachOfType( SelectableEntity, function(ent) {
					var pos = touchPosition;
						
					if ( FlxMath.distanceToPoint(ent, pos ) < ent.hitbox ) {
						target = ent;
					}
				} );

				success = success || ent.moveCommand( touchPosition );
				 
				if ( target != null )
					ent.attackCommand( target );
			}
			
			// Uncomment below lines to enable deselection after a move
			//if( success )
				//wipeselection();
		}
	}
	
}