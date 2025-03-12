package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	static var sqrt = Math.sqrt;
	var positions:Array<FlxPoint> = [
		new FlxPoint(0, 1),
		new FlxPoint(1/2, sqrt(3)/2),
		new FlxPoint(sqrt(2)/2, sqrt(2)/2),
		new FlxPoint(sqrt(3)/2, 1/2),
		new FlxPoint(1, 0),
		new FlxPoint(sqrt(3)/2, -1/2),
		new FlxPoint(sqrt(2)/2, -sqrt(2)/2),
		new FlxPoint(1/2, -sqrt(3)/2),
		new FlxPoint(0, -1),
		new FlxPoint(-1/2, -sqrt(3)/2),
		new FlxPoint(-sqrt(2)/2, -sqrt(2)/2),
		new FlxPoint(-sqrt(3)/2, -1/2),
		new FlxPoint(-1, 0),
		new FlxPoint(-sqrt(3)/2, 1/2),
		new FlxPoint(-sqrt(2)/2, sqrt(2)/2),
		new FlxPoint(-1/2, sqrt(3)/2),
	];

	override public function create()
	{
		var screenSize = 640;
		var center = new FlxPoint(screenSize / 2, screenSize / 2);
		
		var margin = 14; // Increased margin for larger points
		var maxRadius = (screenSize / 2) - margin;

		// Background Circle
		var circle = new FlxSprite().loadGraphic(AssetPaths.circle__png);
		circle.setGraphicSize(screenSize, screenSize);
		circle.screenCenter();
		add(circle);

		// Create Points
		for (point in positions) {
			var xPos = center.x + point.x * maxRadius;
			var yPos = center.y + point.y * maxRadius;

			// Create sprite at (xPos, yPos), now with 14px size
			var sprite = new FlxSprite(xPos - (margin/2), yPos - (margin/2)); // Adjusting for 14px size
			sprite.makeGraphic(14, 14, FlxColor.RED);

			add(sprite);
		}

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
