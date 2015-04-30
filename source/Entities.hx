package;

import flixel.tweens.FlxTween;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;
import SelectionSystem;

class MoveableEntity extends SelectableEntity {
	var pathPoints: Array<FlxPoint> = [];
	var tweener: FlxTween;
	public var currentDirection:Int = 0;
	public var moving: Bool = false;
	
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
				
				// Distance changes tween time between diagonals
				var dist:Float = 0.6* FlxMath.getDistance( new FlxPoint(x, y), point ) / 16;
				if ( dist == 0 ) dist = 0.1;
				
				tweener = FlxTween.tween(this, { x: point.x, y:point.y }, dist);
				var tempDirection = 180 * Math.atan2( point.y - y, point.x - x ) / Math.PI;
				moving = true;
				
				// Clamp values to sensible ones in 2D
				var current = -22.5-180, inc = 45, result=-1;
				while ( current < 180 ) {
					if ( current - 45 <= tempDirection && tempDirection < current ) break;
					current += inc;
					++result;
				}
				
				// Ignore the last path point because it's always zero
				if( pathPoints.length > 1 ) {
					currentDirection = 180 - result * 45;
					if ( currentDirection == -180 ) currentDirection = 180;
				} else {
					// Convert resting position to 90 degree ordinates
					currentDirection = Std.int(currentDirection / 90) ;
					currentDirection *= 90;
				}
				
				trace( currentDirection );
			} else {
				moving = false;
			}
			
		}
	}
}

class Orb extends MoveableEntity {
	public function new( x: Float, y: Float ) {
		super(x, y, "assets/images/DroneDefault.png", "Orb", new FlxPoint( -8, 0), 12);
		loadGraphic("assets/images/DroneSheet.png", true, 16, 16);
		
		animation.add("d", [0, 1, 2]);
		animation.add("l", [3, 4, 5]);
		animation.add("r", [6, 7, 8]);
		animation.add("u", [9, 10, 11]);
	}
	
	override public function update() {
		super.update();
		
		if ( moving ) {
			this.set_angle(0);
			switch(currentDirection) {
				case 0: animation.play("r");
				case 45: animation.play("r"); set_angle(-45);
				case 90: animation.play("u");
				case 135: animation.play("l"); set_angle(45);
				case 180: animation.play("l");
				case -135: animation.play("l"); set_angle(-45);
				case -90: animation.play("d");
				case -45: animation.play("r"); set_angle(45);
			}
		} else {
			animation.pause();
		}
	}
}

class Cactus extends SelectableEntity {
	
	public function new( x: Float, y: Float ) {
		super(x, y, "assets/images/cactus.png", "Cactus", new FlxPoint(-8, 0), 8);
	}
	
	override public function update() {
		super.update();
	}
}

class PalmTree extends SelectableEntity {
	public function new( x: Float, y: Float ) {
		super(x, y, "assets/images/palmtree.png", "Palm Tree", new FlxPoint(-11, 10), 10);
		//attackable = true;
	}
}