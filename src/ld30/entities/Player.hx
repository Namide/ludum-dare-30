package ld30.entities;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.Lib;

/**
 * ...
 * @author namide.com
 */
class Player extends Sprite
{
	
	public static inline var STATE_STAND:String = "stand";
	public static inline var STATE_RUN:String = "run";
	public static inline var STATE_JUMP:String = "jump";
	
	var mc:MovieClip = Lib.attach("BunnyMC");
	
	public var vX(default, default):Float = 0;
	public var vY(default, default):Float = 0;
	
	public var state(default, default):String = STATE_STAND;
	
	public var toRight(default, set_toRight):Bool = true;
	function set_toRight(value:Bool):Bool 
	{
		if ( toRight != value ) mc.scaleX = ( value ) ? 1 : -1;
		return toRight = value;
	}
	
	public function new() 
	{
		super();
		addChild( mc );
	}
	
	public function refresh():Void
	{
		x += vX;
		y += vY;
	}
	
}