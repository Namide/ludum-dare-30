package ld30;

import flash.display.DisplayObject;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import ld30.core.KeyboardHandler;
import ld30.entities.Player;
import ld30.entities.World;
import ld30.screens.Build;
import ld30.screens.Screen;
import ld30.screens.Start;

/**
 * ...
 * @author namide.com
 */
class Main 
{
	
	public static var LEVEL_NUM:Int = 0;
	static var _screen:Screen;
	
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		KeyboardHandler.getInstance().init( Lib.current.stage );
		//KeyboardHandler.getInstance().onRelease = function( key:UInt ):Void { trace(key); };
		
		/*var build:Build = new Build( LEVEL_NUM );
		changeScreen( build );*/
		//build.getSolution();
		changeScreen( new Start() );
		
		Lib.current.stage.addEventListener( Event.RESIZE, onResize );
		onResize();
	}
	
	public static function changeScreen(screen:Screen):Void
	{
		if ( _screen != null )
		{
			_screen.dispose();
			_screen.parent.removeChild( _screen );
		}
		
		Lib.current.addChild( screen );
		_screen = screen;
		_screen.onChangeScreen = changeScreen;
	}
	
	private static function onResize(e:Dynamic = null):Void
	{
		trace(1);
		
		var stage:Stage = Lib.current.stage;
		var current:DisplayObject = Lib.current;
		//var newWidth:Int = 1024;
		var prop:Float = 1280 / 720;
		var sProp:Float = stage.stageWidth / stage.stageHeight;
		
		var s:Float;
		if ( prop > sProp )
		{
			s = stage.stageWidth / 1280;
		}
		else
		{
			s = stage.stageHeight / 720;
		}
		s = Math.fround( s * 128 ) / 128;
		
		current.scaleX = current.scaleY = s;
		current.x = Math.round( ( stage.stageWidth - 1280 * s ) * 0.5 );
		current.y = Math.round( ( stage.stageHeight - 720 * s ) * 0.5 );
		
	}
	
}