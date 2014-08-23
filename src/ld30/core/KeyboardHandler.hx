package ld30.core;

import flash.display.Stage;
import flash.errors.Error;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.utils.Function;
import flash.Vector;

/**
 * @author namide.com
 */
class KeyboardHandler
{
	private static var _CAN_INSTANTIATE:Bool = false;
	private static var _INSTANCE:KeyboardHandler;
	
	var _listKeyPressed:Array<UInt> = [];
	var _stage:Stage;
	
	public var onRelease: UInt -> Void = function( keyCode:UInt ) { };
	
	public function init( stage:Stage ):Void
	{
		_stage = stage;
		_stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDown );
		_stage.addEventListener( KeyboardEvent.KEY_UP, keyUp );
	}
	
	public inline function getKeyPressed( keyCode:UInt ):Bool
	{
		return Lambda.has( _listKeyPressed, keyCode );
	}
	
	
	inline function keyDown( e:KeyboardEvent ):Void
	{
		_listKeyPressed.push( e.keyCode );
	}
	
	function keyUp( e:KeyboardEvent ):Void
	{
		while ( Lambda.has( _listKeyPressed, e.keyCode ) )
		{
			_listKeyPressed.splice( Lambda.indexOf( _listKeyPressed, e.keyCode ), 1 );
		}
		onRelease( e.keyCode );
	}
	
	public function new() 
	{
		if (false == KeyboardHandler._CAN_INSTANTIATE)
		{
			throw "Can't instantiate a singleton, use the static method getInstance()";
		}
	}
	
	public static function getInstance():KeyboardHandler
	{
        if (_INSTANCE == null)
		{
            _CAN_INSTANTIATE = true;
            _INSTANCE = new KeyboardHandler();
            _CAN_INSTANTIATE = false;
        }
        return _INSTANCE;
    }
	
}