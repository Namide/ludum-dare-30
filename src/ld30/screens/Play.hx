package ld30.screens;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.geom.Point;
import ld30.core.NumUtils;
import ld30.entities.Player;
import ld30.entities.World;

/**
 * ...
 * @author ...
 */
class Play extends Screen
{

	public static inline var FRAME_TIME:Int = 40; // 1000 / 25
	static inline var _GRAVITY:Float = 1;
	
	var _world:World;
	var _player:Player;
	
	
	public function new( world:World ) 
	{
		super();
		_world = world;
		addChild( _world );
		_world.x = _world.y = 0;
		_world.scaleX = _world.scaleY = 1;
		
		_world.build();
		_player = new Player();
		
		_world.addChild( _player );
		NumUtils.moveAtoB( _player, _world.spawnPoint );
		
		addEventListener( Event.ENTER_FRAME, refresh );
	}
	
	function refresh( e:Event = null ):Void
	{
		_player.clear();
		_player.vY += _GRAVITY;
		_player.x += _player.vX;
		_player.y += _player.vY;
		_world.hitTest( _player );
		_player.refresh();
	}
	
}