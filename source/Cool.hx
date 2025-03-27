import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class Cool extends FlxState
{
	var unitCircle:FlxSprite;
	var angleText:FlxText;
	var coordText:FlxText;
	var answerText:FlxText;
	var inputAngle:Float;
	var radius:Int = 150;
	var centerX:Int;
	var centerY:Int;

	var positions:Array<FlxPoint> = [
		new FlxPoint(0, 1),
		new FlxPoint(1 / 2, Math.sqrt(3) / 2),
		new FlxPoint(Math.sqrt(2) / 2, Math.sqrt(2) / 2),
		new FlxPoint(Math.sqrt(3) / 2, 1 / 2),
		new FlxPoint(1, 0),
		new FlxPoint(Math.sqrt(3) / 2, -1 / 2),
		new FlxPoint(Math.sqrt(2) / 2, -Math.sqrt(2) / 2),
		new FlxPoint(1 / 2, -Math.sqrt(3) / 2),
		new FlxPoint(0, -1),
		new FlxPoint(-1 / 2, -Math.sqrt(3) / 2),
		new FlxPoint(-Math.sqrt(2) / 2, -Math.sqrt(2) / 2),
		new FlxPoint(-Math.sqrt(3) / 2, -1 / 2),
		new FlxPoint(-1, 0),
		new FlxPoint(-Math.sqrt(3) / 2, 1 / 2),
		new FlxPoint(-Math.sqrt(2) / 2, Math.sqrt(2) / 2),
		new FlxPoint(-1 / 2, Math.sqrt(3) / 2),
	];

	override public function create():Void
	{
		super.create();

		// FlxG.bgColor = FlxColor.WHITE;

		unitCircle = new FlxSprite(0, 0);
		unitCircle.makeGraphic(2 * radius, 2 * radius, FlxColor.TRANSPARENT);
		centerX = Std.int((FlxG.width - unitCircle.width) / 2 + radius);
		centerY = Std.int((FlxG.height - unitCircle.height) / 2 + radius);
		unitCircle.x = centerX - radius;
		unitCircle.y = centerY - radius;
		drawCircle(unitCircle);
		add(unitCircle);

		angleText = new FlxText(20, 20, 0, "Click a point on the unit circle", 16);
		angleText.color = FlxColor.BLACK;
		add(angleText);

		coordText = new FlxText(20, 40, 0, "", 16);
		coordText.color = FlxColor.BLACK;
		add(coordText);

		answerText = new FlxText(20, FlxG.height - 40, 0, "", 18);
		answerText.color = FlxColor.BLUE;
		add(answerText);
	}

	function drawCircle(circle:FlxSprite):Void
	{
		var cx = radius;
		var cy = radius;
		circle.pixels.fillRect(circle.pixels.rect, 0x00000000);

		for (theta in 0...360)
		{
			var rad = Math.PI * theta / 180;
			var x = cx + Math.cos(rad) * radius;
			var y = cy + Math.sin(rad) * radius;
			circle.pixels.setPixel32(Math.round(x), Math.round(y), FlxColor.BLACK);
		}

		for (p in positions)
		{
			var dotX = cx + p.x * radius;
			var dotY = cy - p.y * radius; // Y axis is flipped in screen coords
			for (dx in -2...3)
			{
				for (dy in -2...3)
				{
					var px = Math.round(dotX + dx);
					var py = Math.round(dotY + dy);
					if (px >= 0 && px < circle.frameWidth && py >= 0 && py < circle.frameHeight)
						circle.pixels.setPixel32(px, py, FlxColor.RED);
				}
			}
		}

		circle.dirty = true;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.mouse.justPressed)
		{
			var mx = FlxG.mouse.screenX - centerX;
			var my = FlxG.mouse.screenY - centerY;
			var distance = Math.sqrt(mx * mx + my * my);
			if (distance <= radius)
			{
				var normX = mx / radius;
				var normY = -my / radius;
				var closest:FlxPoint = null;
				var minDist = 999.0;

				for (p in positions)
				{
					var d = p.dist(new FlxPoint(normX, normY));
					if (d < minDist)
					{
						minDist = d;
						closest = p;
					}
				}

				if (closest != null)
				{
					coordText.text = 'Closest Point: (' + FlxMath.roundDecimal(closest.x, 2) + ', ' + FlxMath.roundDecimal(closest.y, 2) + ')';

					var angleRad = Math.atan2(closest.y, closest.x);
					var angleDeg = angleRad * 180 / Math.PI;
					if (angleDeg < 0)
						angleDeg += 360;

					inputAngle = Math.round(angleDeg);
					answerText.text = 'Angle: ${inputAngle}°, cos: ' + FlxMath.roundDecimal(closest.x, 2) + ', sin: ' + FlxMath.roundDecimal(closest.y, 2);
				}
			}
		}
	}
}