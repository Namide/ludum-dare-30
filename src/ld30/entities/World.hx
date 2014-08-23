package ld30.entities;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;

/**
 * ...
 * @author namide.com
 */
class World extends Sprite
{
	public var builded(default, default):Bool = false;
	
	var _entitiesGround:Array<DisplayObject> = [];
	var _entitiesItem:Array<DisplayObject> = [];
	var _spawnPoint:DisplayObject;
	
	public var active(default, default):Player;
	
	var _container:Sprite = new Sprite();
	
	private var _cellX:Int;
	private var _cellY:Int;
	private var _cellW:Int;
	private var _cellH:Int;
	
	public function new( bg:DisplayObjectContainer, cellX:Int = 2, cellY:Int = 2, cellW:Int = 320, cellH:Int = 320 ) 
	{
		super();
		_cellX = cellX;
		_cellY = cellY;
		_cellW = cellW;
		_cellH = cellH;
		addWorldPart( bg );
	}	
	
	public function addWorldPart( worldPart:MovieClip, i:Int = 0, j:Int = 0 ):Void
	{
		if ( builded ) throw "can't add world part after building world";
		worldPart.x = i * _cellW;
		worldPart.y = j * _cellH;
		_container.addChild( worldPart );
	}
	
	public function removeWorldPart( worldPart:MovieClip ):MovieClip
	{
		if ( builded ) throw "can't remove world part after building world";
		while ( worldPart.parent == _container )
		{
			worldPart.x = 0;
			worldPart.y = 0;
			_container.removeChild( worldPart );
		}
		return worldPart;
	}
	
	public function build():Void
	{
		if ( builded ) throw "can't rebuild world";
		var actives
		for ( w in _worlds )
		{
			addEntities( w );
		}
		builded = true;
	}
	
	public function refresh():Void
	{
		if ( !builded ) throw "can't refresh before building world";
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