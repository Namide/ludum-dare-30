package ld30;

import flash.display.DisplayObject;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import flash.ui.Keyboard;
import haxe.Timer;
import ld30.core.KeyboardHandler;
import ld30.entities.Player;
import ld30.entities.World;
import ld30.screens.Build;
import ld30.screens.Screen;
import ld30.screens.Start;
import ld30.sound.SoundManager;

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
		
		initSounds();
		
		KeyboardHandler.getInstance().init( Lib.current.stage );
		changeScreen( new Start() );
		
		Lib.current.stage.addEventListener( Event.RESIZE, onResize );
		onResize();
		
		KeyboardHandler.getInstance().onRelease = onKeyboard;
	}
	
	public static function onKeyboard(keyCode:UInt):Void
	{
		if ( keyCode == Keyboard.M ) SoundManager.getInstance().musicMutted = !SoundManager.getInstance().musicMutted;
		if ( keyCode == Keyboard.S ) SoundManager.getInstance().sampleMutted = !SoundManager.getInstance().sampleMutted;
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
	
	private static function initSounds():Void
	{
		var sm:SoundManager = SoundManager.getInstance();
		sm.addSound( "dead", "snd/dead.mp3", true );
		sm.addSound( "jump", "snd/jump.mp3", true );
		sm.addSound( "run", "snd/run3.mp3", true );
		sm.addSound( "over", "snd/run2.mp3", true );
		sm.addSound( "win", "snd/win.mp3", true );
		sm.addSound( "music", "snd/music.mp3", false );
		
		
		Timer.delay( function() { sm.play( "music" ); }, 1000 );
	}
	
	private static function onResize(e:Dynamic = null):Void
	{
		var stage:Stage = Lib.current.stage;
		var current:DisplayObject = Lib.current;
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