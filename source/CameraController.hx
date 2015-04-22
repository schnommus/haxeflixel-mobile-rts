package;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;

class CameraController extends FlxGroup {

	private var lastScrollPoint:FlxPoint = new FlxPoint();
	
	public function new() {
		super();
	}
	
	override public function update():Void {
		super.update();

		scrollCamera();	
	}
	
	function scrollCamera():Void {
		#if mobile
		
		if ( FlxG.touches.justStarted().length != 0 ) {
			lastScrollPoint.x = FlxG.touches.getFirst().getScreenPosition().x;
			lastScrollPoint.y = FlxG.touches.getFirst().getScreenPosition().y;
		}
	 
		if ( FlxG.touches.getFirst() != null ) {
			FlxG.camera.scroll.x -= FlxG.touches.getFirst().getScreenPosition().x - lastScrollPoint.x;
			FlxG.camera.scroll.y -= FlxG.touches.getFirst().getScreenPosition().y - lastScrollPoint.y;
			lastScrollPoint.x = FlxG.touches.getFirst().getScreenPosition().x;
			lastScrollPoint.y = FlxG.touches.getFirst().getScreenPosition().y;
		}
		
		#else 
		
		if (FlxG.mouse.justPressed ) {
			lastScrollPoint.x = FlxG.mouse.screenX;
			lastScrollPoint.y = FlxG.mouse.screenY;
		}
	 
		if (FlxG.mouse.pressed ) {
			FlxG.camera.scroll.x -= FlxG.mouse.screenX - lastScrollPoint.x;
			FlxG.camera.scroll.y -= FlxG.mouse.screenY - lastScrollPoint.y;
			lastScrollPoint.x = FlxG.mouse.screenX;
			lastScrollPoint.y = FlxG.mouse.screenY;
		}
		
		#end
	
	}
}