package ld30;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;
import ld30.core.KeyboardHandler;
import ld30.entities.Player;
import ld30.screens.Build;
import ld30.screens.Screen;

/**
 * ...
 * @author namide.com
 */

class Main 
{
	
	static var _screen:Screen;
	
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		KeyboardHandler.getInstance().init( Lib.current.stage );
		KeyboardHandler.getInstance().onRelease = function( key:UInt ):Void { trace(key); };
		
		/*var b:Player = new Player();
		Lib.current.addChild( b );*/
		
		changeScreen( new Build(0) );
	}
	
	static function changeScreen(screen:Screen):Void
	{
		if ( _screen != null )
		{
			_screen.dispose();
			_screen.parent.removeChild( _screen );
		}
		
		Lib.current.addChild( screen );
		_screen = screen;
	}
	
}