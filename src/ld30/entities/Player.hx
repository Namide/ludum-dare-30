package ld30.entities;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.geom.Point;
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
	public static inline var STATE_DEAD:String = "dead";
	public static inline var STATE_WIN:String = "win";
	
	public var velOnGround(default, default):Float = 14;
	public var velOnAir(default, default):Float = 8;
	public var velJump(default, default):Float = 25;
	public var velUp(default, default):Float = 0;
	
	var mc:MovieClip = Lib.attach("BunnyMC");
	
	public var vX(default, default):Float = 0;
	public var vY(default, default):Float = 0;
	
	public var state(default, null):String = "none";
	public var toRight(default, null):Bool = true;
	public var onGround(default, default):Bool = false;
	public var dead(default, set):Bool = false;
	function set_dead( val:Bool ):Bool
	{
		if ( val ) mc.gotoAndPlay( STATE_DEAD );
		return dead = val;
	}
	
	public var win(default, set):Bool = false;
	function set_win( val:Bool ):Bool
	{
		if ( val ) mc.gotoAndPlay( STATE_WIN );
		return win = val;
	}
	
	public var lastHitBoxGlobPos:Point;
	var _lastState:String;
	var _lastToRight:Bool;
	
	public var hitBox:DisplayObject;
	
	public function new() 
	{
		super();
		addChild( mc );
		hitBox = mc.getChildByName("hit");
		lastHitBoxGlobPos = hitBox.localToGlobal( new Point() );
	}
	
	public function clear():Void
	{
		lastHitBoxGlobPos.x = 0;
		lastHitBoxGlobPos.y = 0;
		lastHitBoxGlobPos = hitBox.localToGlobal( lastHitBoxGlobPos );
		
		_lastState = state;
		_lastToRight = toRight;
		onGround = false;
	}
	public function refresh():Void
	{
		if ( dead )
		{
			if ( state != STATE_DEAD ) mc.gotoAndPlay( STATE_DEAD );
			return;
		}
		if ( win )
		{
			if ( state != STATE_WIN ) mc.gotoAndPlay( STATE_WIN );
			return;
		}
		
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
			else											vX = 0;
			
			if ( kh.getKeyPressed( Keyboard.SPACE ) )		vY = -velJump;
		}
		else
		{
			if ( kh.getKeyPressed( Keyboard.LEFT ) ) 		vX = -velOnAir;
			else if ( kh.getKeyPressed( Keyboard.RIGHT ) ) 	vX = velOnAir;
			else											vX = 0;
			
			if ( kh.getKeyPressed( Keyboard.SPACE ) )		vY -= (vY<0)?velUp:0;
		}
	}
}