package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class UnitCirclePoint extends FlxSprite {

    public var point:FlxPoint;
	public var radian:Float;
	public var selected:Bool = false;
	public var completed:Bool = false;

	public function new(x:Float, y:Float, point:FlxPoint)
	{
		super(x, y);
		makeGraphic(14, 14, FlxColor.RED);
		this.point = point;
		this.radian = Math.atan2(point.y, point.x);
	}
}