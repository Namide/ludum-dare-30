package ld30.entities;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.Lib;
import flash.ui.Keyboard;
import ld30.core.KeyboardHandler;

/**
 * ...
 * @author namide.com
 */
class Player extends Sprite
{
	
	public static inline var STATE_STAND:String = "stand";
	public static inline var STATE_RUN:String = "run";
	public static inline var STATE_JUMP:String = "jump";
	
	public var velOnGround(default, default):Float = 4;
	public var velOnAir(default, default):Float = 2;
	public var velJump(default, default):Float = 15;
	
	var mc:MovieClip = Lib.attach("BunnyMC");
	
	public var vX(default, default):Float = 0;
	public var vY(default, default):Float = 0;
	
	public var state(default, null):String = "none";
	public var toRight(default, null):Bool = true;
	public var onGround(default, default):Bool = false;
	
	var _lastState:String;
	var _lastToRight:Bool;
	
	public var boundingBox:DisplayObject;
	
	public function new() 
	{
		super();
		addChild( mc );
		boundingBox = mc.getChildByName("hit");
	}
	
	public function clear():Void
	{
		_lastState = state;
		_lastToRight = toRight;
		onGround = false;
	}
	public function refresh():Void
	{
		var nextState:String;
		if ( onGround )
		{
			if ( Math.abs(vX) > 0 ) nextState = STATE_RUN;
			else nextState = STATE_STAND;
		}
		else
		{
			nextState = STATE_JUMP;
		}
		if ( nextState != state )
		{
			state = nextState;
			mc.gotoAndPlay( nextState );
		}
		
		var nextToRight:Bool;
		if ( Math.abs(vX) > 0 )
		{
			nextToRight = vX > 0;
			if ( nextToRight != toRight )
			{
				toRight = nextToRight;
				mc.scaleX = (toRight) ? 1 : -1;
			}
		}
		
		var kh:KeyboardHandler = KeyboardHandler.getInstance();
		if ( onGround )
		{
			if ( kh.getKeyPressed( Keyboard.LEFT ) ) 		vX = -velOnGround;
			else if ( kh.getKeyPressed( Keyboard.RIGHT ) ) 	vX = velOnGround;
			if ( kh.getKeyPressed( Keyboard.UP ) )			vY = -velJump;
		}
		else
		{
			if ( kh.getKeyPressed( Keyboard.LEFT ) ) 		vX = -velOnAir;
			else if ( kh.getKeyPressed( Keyboard.RIGHT ) ) 	vX = velOnAir;
		}
	}
}