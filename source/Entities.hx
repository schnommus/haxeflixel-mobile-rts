package;

import flixel.tweens.FlxTween;
import flixel.util.FlxPoint;
import SelectionSystem;

class Cactus extends SelectableEntity {
	
	var pathPoints: Array<FlxPoint>;
	var tweener: FlxTween;
	
	public function new( x: Float, y: Float ) {
		super(x, y, "assets/images/cactus.png", "Cactus", new FlxPoint(-8, 0), 8);
		pathPoints = [];
	}
	
	override public function moveCommand( destination: FlxPoint ) {
		destination.x -= selectionOffset.x+8;
		destination.y -= selectionOffset.y-3;
		pathPoints = PlayState.levelManager.terrain.findPath( new FlxPoint(x, y), destination, false );
		
		if ( pathPoints != null ) {
			pathPoints.push(destination);
			pathPoints.reverse();
		} else {
			pathPoints = [];
			//pathPoints = PlayState.levelManager.terrain.findPath( new FlxPoint(x, y+8), destination, false );
		}
	}
	
	override public function update() {
		super.update();
		
		if( tweener == null || tweener.finished ) {
			var point = pathPoints.pop();
			
			if ( point != null ) {
				tweener = FlxTween.tween(this, { x: point.x, y:point.y }, 0.1);
			}
			
		}
	}
}

class PalmTree extends SelectableEntity {
	public function new( x: Float, y: Float ) {
		super(x, y, "assets/images/palmtree.png", "Palm Tree", new FlxPoint(-11, 10), 10);
		//attackable = true;
	}
}