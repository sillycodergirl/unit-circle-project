package;

import flixel.FlxGame;
import openfl.display.Sprite;
#if sys
import lime.app.Application;
#end

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, PlayState));

		#if sys
		Application.current.window.borderless = true;
		#end
	}
}
