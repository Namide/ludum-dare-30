package ld30.screens;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;

/**
 * ...
 * @author namide.com
 */
class Start extends Screen
{

	var startBtn:DisplayObject;
	
	public function new() 
	{
		super();
		
		var mc:MovieClip = Lib.attach( "StartScreenMC" );
		addChild( mc );
		
		startBtn = mc.getChildByName( "start" );
		startBtn.addEventListener( MouseEvent.CLICK, startGame );
	}
	
	private function startGame(e:Event):Void
	{
		startBtn.removeEventListener( MouseEvent.CLICK, startGame );
		startBtn = null;
		onChangeScreen( new Build( Main.LEVEL_NUM ) );
	}
	
	
	
}