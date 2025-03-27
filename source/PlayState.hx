package;

import FlxInputText;
import SimpleMathParser;
import UnitCirclePoint;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using StringTools;

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

	var pointGroup:FlxTypedGroup<UnitCirclePoint>;
	var mouseTracker:FlxSprite;
	var currentPoint:UnitCirclePoint = null;

	var coordX:FlxInputText;
	var coordY:FlxInputText;
	var rad:FlxInputText;

	var instructions:FlxText;
	var lastInput:FlxText;

	override public function create()
	{
		var screenSize = 640;
		var center = new FlxPoint(screenSize / 2, screenSize / 2);
		
		var margin = 14; // Increased margin for larger points
		var maxRadius = (screenSize / 2) - margin;

		mouseTracker = new FlxSprite(0, 0);
		mouseTracker.makeGraphic(10, 10, FlxColor.GREEN);
		add(mouseTracker);

		// Background Circle
		var circle = new FlxSprite().loadGraphic(AssetPaths.circle__png);
		circle.setGraphicSize(screenSize, screenSize);
		circle.screenCenter();
		add(circle);

		coordX = new FlxInputText(160, 280, 150, "X Coord");
		add(coordX);
		coordY = new FlxInputText(320, 280, 150, "Y Coord");
		add(coordY);
		rad = new FlxInputText(240, 400, 150, "Radians");
		add(rad);

		instructions = new FlxText(0, 430, 0, "", 12);
		instructions.alignment = CENTER;
		instructions.text = '
		Click on a point and insert the\n
		coordinate X and Y and the radians. \n
		Use "sqrt:" to square root a number.\n
		Use "pi" for pi.\n
		Press "ENTER" to submit answer.';
		instructions.screenCenter(X);
		add(instructions);

		lastInput = new FlxText(0, 350, 0, "", 14);
		lastInput.alignment = CENTER;
		lastInput.text = "no last input";
		lastInput.screenCenter(X);
		add(lastInput);

		pointGroup = new FlxTypedGroup<UnitCirclePoint>();

		// Create Points
		for (point in positions) {
			var xPos = center.x + point.x * maxRadius;
			var yPos = center.y - point.y * maxRadius;

			// Create sprite at (xPos, yPos), now with 14px size
			var sprite = new UnitCirclePoint(xPos, yPos, point);
			pointGroup.add(sprite);

			add(sprite);
		}

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (mouseTracker != null)
		{
			mouseTracker.setPosition(FlxG.mouse.x, FlxG.mouse.y);
		}

		if (FlxG.mouse.justPressed)
		{
			var spriteClicked = findClicked();

			if (spriteClicked != null)
			{
				trace(spriteClicked.point);
				if (spriteClicked.completed)
				{
					return;
				}

				currentPoint = spriteClicked;
				pointGroup.forEach(function(sprite:UnitCirclePoint)
				{
					sprite.selected = sprite == spriteClicked;
					sprite.color = sprite.selected ? FlxColor.GREEN : FlxColor.RED;
					if (sprite.completed)
					{
						sprite.color = FlxColor.YELLOW;
					}
				});
			}
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			if (currentPoint == null)
			{
				return;
			}

			// I really hope this works....
			var inputX = SimpleMathParser.parse(coordX.text);
			var inputY = SimpleMathParser.parse(coordY.text);
			var inputRad = SimpleMathParser.parse(rad.text);

			var answerX = currentPoint.point.x;
			var answerY = currentPoint.point.y;
			var answerRad = currentPoint.radian;

			var xCorrect = truncateFloat(inputX) == truncateFloat(answerX);
			var yCorrect = truncateFloat(inputY) == truncateFloat(answerY);
			// trun rad bc math sucks
			var radCorrect = truncateFloat(inputRad) == truncateFloat(answerRad);

			trace(inputRad, answerRad);
			trace(inputX, inputY, truncateFloat(inputRad));
			trace(answerX, answerY, truncateFloat(answerRad));

			currentPoint.completed = xCorrect && yCorrect && radCorrect;
			lastInput.text = "Last input: " + (currentPoint.completed ? "Correct!" : "Incorrect.");
			trace(currentPoint.completed);
		}

		super.update(elapsed);
	}
	function findClicked():Null<UnitCirclePoint>
	{
		if (pointGroup == null)
		{
			return null;
		}

		var spriteClicked:UnitCirclePoint = null;

		pointGroup.forEach(function(sprite:UnitCirclePoint)
		{
			if (FlxG.overlap(mouseTracker, sprite))
			{
				spriteClicked = sprite;
			}
		});

		return spriteClicked;
	}

	function truncateFloat(f:Float, decimals:Int = 2):Float
	{
		var factor = Math.pow(10, decimals);
		return Math.floor(f * factor) / factor;
	}	
}
