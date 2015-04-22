package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

// FlxState for the game menu
class MenuState extends FlxState {
	
	// Called when the state is created
	override public function create():Void {
		super.create();
		
		// Game title
		var title = new FlxText( 0, 0, 0, "TEMPLATE\nAPP" );
		title.setFormat("assets/fonts/BebasNeue.otf", 70, 0xFFFFFF, "center");
		title.setPosition( FlxG.width / 2 - title.textField.textWidth / 2, FlxG.height / 2-180 );
		add(title);
		
		// Copyright notice
		var copyright = new FlxText( 0, 0, 0, "(C) Sebastian Holzapfel, 2015" );
		copyright.setFormat("assets/fonts/BebasNeue.otf", 15, 0xFFFFFF, "center");
		copyright.setPosition( FlxG.width / 2 - copyright.textField.textWidth / 2, FlxG.height - 20 );
		add(copyright);
		
		// 'Begin' button
		function beginClicked() { FlxG.switchState(new PlayState()); }
		var begin = new FlxButton(FlxG.width/2-75, FlxG.height/2+10, "BEGIN", beginClicked);
		begin.loadGraphic("assets/images/button.png");
		begin.label.setFormat("assets/fonts/BebasNeue.otf", 30, 0xFFFFFF);
		begin.label.offset.x -= (150-begin.label.textField.textWidth)/2-3;
		begin.label.offset.y -= 10;
		add(begin);
		
		#if (!flash && !html5)
			// 'Exit' button
			function exitClicked() { Sys.exit(0); }
			var exit = new FlxButton(FlxG.width/2-75, FlxG.height/2+110, "EXIT", exitClicked);
			exit.loadGraphic("assets/images/button.png");
			exit.label.setFormat("assets/fonts/BebasNeue.otf", 30, 0xFFFFFF);
			exit.label.offset.x -= (150-exit.label.textField.textWidth)/2-3;
			exit.label.offset.y -= 10;
			add(exit);
		#end
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