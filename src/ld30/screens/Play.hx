package ld30.screens;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.Lib;
import ld30.core.NumUtils;
import ld30.entities.Player;
import ld30.entities.World;

/**
 * ...
 * @author ...
 */
class Play extends Screen
{

	public static inline var FRAME_TIME:Int = 20; // 1000 / 25
	public static inline var GRAVITY:Float = 2;
	
	var _world:World;
	var _player:Player;
	
	
	public function new( world:World ) 
	{
		super();
		_world = world;
		addChild( _world );
		_world.x = Math.ceil( (1280 - 640) * 0.25 );
		_world.y = Math.ceil( (720 - 640) * 0.5 );
		_world.scaleX = _world.scaleY = 1;
		
		_world.build();
		_player = new Player();
		
		_world.addChild( _player );
		_world.onDead = dead;
		_world.onWin = win;
		_world.onExit = menuExit;
		_world.onRedraw = menuRedraw;
		NumUtils.moveAtoB( _player, _world.spawnPoint );
		
		addEventListener( Event.ENTER_FRAME, refresh );
	}
	
	function endScreen( nextLevel:Bool ):Void
	{
		var mc:MovieClip = Lib.attach( "PlayScreenMC" );
		
		var retryBtn:DisplayObject = mc.getChildByName("retry");
		var redrawBtn:DisplayObject = mc.getChildByName("redraw");
		var nextBtn:DisplayObject = mc.getChildByName("next");
		var exitBtn:DisplayObject = mc.getChildByName("exit");
		
		if ( nextLevel )
		{
			retryBtn.visible = false;
			redrawBtn.visible = false;
			nextBtn.addEventListener( MouseEvent.CLICK, menuNextLevel );
			exitBtn.addEventListener( MouseEvent.CLICK, menuExit );
		}
		else
		{
			nextBtn.visible = false;
			retryBtn.addEventListener( MouseEvent.CLICK, menuRetry );
			redrawBtn.addEventListener( MouseEvent.CLICK, menuRedraw );
			exitBtn.addEventListener( MouseEvent.CLICK, menuExit );
		}
		
		addChild( mc );
	}
	
	function menuRetry(e:Dynamic = null):Void
	{
		_world.restart();
	}
	function menuRedraw(e:Dynamic = null):Void
	{
		onChangeScreen( new Build( _world.levelNum ) );
	}
	function menuNextLevel(e:Dynamic = null):Void
	{
		var nextLevel:Int = _world.levelNum + 1;
		if ( nextLevel >= Build.getLevelLength() )
		{
			onChangeScreen( new Start() );
		}
		else
		{
			onChangeScreen( new Build( nextLevel ) );
		}
		
	}
	function menuExit(e:Dynamic = null):Void
	{
		onChangeScreen( new Start() );
	}
	
	function refresh( e:Event = null ):Void
	{
		_player.clear();
		_player.vY += GRAVITY;
		_player.x += _player.vX;
		_player.y += _player.vY;
		_world.hitTest( _player );
		_player.refresh();
	}
	
	function win():Void
	{
		removeEventListener( Event.ENTER_FRAME, refresh );
		_player.visible = false;
		endScreen( true );
	}
	
	function dead():Void
	{
		removeEventListener( Event.ENTER_FRAME, refresh );
		_player.dead = true;
		endScreen( false );
	}
}