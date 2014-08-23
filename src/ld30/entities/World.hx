package ld30.entities;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;

/**
 * ...
 * @author namide.com
 */
class World
{
	var _worlds:Array<DisplayObjectContainer> = [];
	
	var _entitiesGround:Array<DisplayObject> = [];
	var _entitiesItem:Array<DisplayObject> = [];
	var _spawnPoint:DisplayObject;
	
	public var active(default, default):Player;
	
	var _finalWorld:Sprite = new Sprite();
	
	private var _cellX:Int;
	private var _cellY:Int;
	private var _cellW:Int;
	private var _cellH:Int;
	
	public function new( cellX:Int = 2, cellY:Int = 2, cellW:Int = 512, cellH:Int = 512 ) 
	{
		_cellX = cellX;
		_cellY = cellY;
		_cellW = cellW;
		_cellH = cellH;
	}	
	
	public function addWorld( world:MovieClip, x:Int, y:Int ):Void
	{
		_worlds.push( world );
	}
	
	public function removeWorld( world:MovieClip ):Void
	{
		while ( _worlds.indexOf( world ) > -1 ) _worlds.remove( world );
	}
	
	public function build():Void
	{
		var actives
		for ( w in _worlds )
		{
			addEntities( w );
		}
	}
	
	public function refresh():Void
	{
		
	}
	
	public function dispose():Void
	{
		
	}
	
	function addEntities( target:DisplayObject ):Void
	{
		if ( Std.is( target, DisplayObjectContainer ) )
		{
			var ctn:DisplayObjectContainer = cast( target, DisplayObjectContainer );
			for ( i in 0...ctn.numChildren )
			{
				var child:DisplayObject = ctn.getChildAt( i );
				addEntities( child );
			}
		}
		
		if ( target.name.charAt(0) == "p" )
		{
			switch ( target.name.charAt(1) )
			{
				case "p" : _entitiesGround.push( target );	// platform
				case "w" : _entitiesGround.push( target );	// wall
				case "s" : _spawnPoint = target;			// spawn point
				case "e" : _entitiesItem.push( target );	// end point
				case "b" : _entitiesItem.push( target );	// "bad"
			}
		}
	}
	
	
}