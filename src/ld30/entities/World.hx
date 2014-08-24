package ld30.entities;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.geom.Point;
import ld30.core.NumUtils;
import ld30.screens.Play;

/**
 * ...
 * @author namide.com
 */
class World extends Sprite
{
	private static inline var _ITEM_MI_SIZE:Float = 12;
	
	public var builded(default, null):Bool = false;
	
	public var entitiesGround(default, null):Array<DisplayObject> = [];
	public var entitiesItem(default, null):Array<DisplayObject> = [];
	public var spawnPoint(default, null):DisplayObject;
	
	public var columns(default, null):Int;
	public var lines(default, null):Int;
	
	var _cellW:Int;
	var _cellH:Int;
	
	public var w(default, default):Int;
	public var h(default, default):Int;
	
	public dynamic function onDead():Void { };
	public dynamic function onEnd():Void { };
	
	public function new( bg:DisplayObjectContainer, cellX:Int = 2, cellY:Int = 2, cellW:Int = 320, cellH:Int = 320 ) 
	{
		super();
		columns = cellX;
		lines = cellY;
		_cellW = cellW;
		_cellH = cellH;
		w = cellX * cellW;
		h = cellY * cellH;
		addWorldPart( bg );
	}	
	
	public function hitTest( player:Player ):Void
	{
		//var l:Array<DisplayObject> = [];
		var ha:DisplayObject = player.hitBox;
		
		var fromTop:Float = 0;
		var fromBottom:Float = 0;
		var fromLeft:Float = 0;
		var fromRight:Float = 0;
		
		/*var aDelta:Point = new Point();
		var bDelta:Point = new Point();*/
		var min:Float;
		var p:Point = new Point();
		for ( e in entitiesGround )
		{
			if ( ha.hitTestObject( e ) )
			{
				p.x = -_ITEM_MI_SIZE;
				p.y = -_ITEM_MI_SIZE;
				p = e.localToGlobal( p ).subtract( player.lastHitBoxGlobPos );
				fromTop = p.y;
				fromLeft = p.x;
				
				p.x = _ITEM_MI_SIZE;
				p.y = _ITEM_MI_SIZE;
				p = player.lastHitBoxGlobPos.subtract( e.localToGlobal( p ) );
				fromBottom = p.y;
				fromRight = p.x;
				
				min = Math.POSITIVE_INFINITY;
				if ( fromLeft >= 0 && fromLeft < min ) min = fromLeft;
				if ( fromBottom >= 0 && fromBottom < min ) min = fromBottom;
				if ( fromRight >= 0 && fromRight < min ) min = fromRight;
				if ( fromTop >= 0 && fromTop < min ) min = fromTop;
				
				if (min == fromTop)
				{
					NumUtils.moveAtoB( player, e, new Point(0, -_ITEM_MI_SIZE), false, true );
					player.onGround = true;
					player.vY = 0;
				}
				else if (min == fromBottom)
				{
					NumUtils.moveAtoB( player, e, new Point(0, _ITEM_MI_SIZE), false, true );
					//player.y += _ITEM_MI_SIZE + Play.GRAVITY;
					player.vY = Play.GRAVITY;
				}
				else if (min == fromRight)
				{
					NumUtils.moveAtoB( player, e, new Point( _ITEM_MI_SIZE, 0 ), true, false );
					player.x += _ITEM_MI_SIZE;
					player.vX = 0;
				}
				else if (min == fromLeft)
				{
					NumUtils.moveAtoB( player, e, new Point( -_ITEM_MI_SIZE, 0 ), true, false );
					player.x -= _ITEM_MI_SIZE;
					player.vX = 0;
				}
				
			}
		}
		for ( e in entitiesItem )
		{
			if ( ha.hitTestObject( e ) )
			{
				var s:String = e.name.charAt(1);
				if ( s == "e" )
				{
					onEnd();
				}
				else if ( s == "b" )
				{
					onDead();
				}
			}
		}
		//return l;
	}
	
	public function addWorldPart( worldPart:DisplayObjectContainer, i:Int = 0, j:Int = 0 ):Void
	{
		if ( builded ) throw "can't add world part after building world";
		worldPart.x = i * _cellW;
		worldPart.y = j * _cellH;
		worldPart.scaleX = worldPart.scaleY = 1;
		addChild( worldPart );
	}
	
	public function build():Void
	{
		if ( builded ) throw "can't rebuild world";
		addEntities( this );
		
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
				case "p" : entitiesGround.push( target );	// platform
				case "w" : entitiesGround.push( target );	// wall
				case "s" : spawnPoint = target;				// spawn point
				case "e" : entitiesItem.push( target );		// end point
				case "b" : entitiesItem.push( target );		// "bad"
			}
		}
		if ( target.name.charAt(0) == "s" )
		{
			switch ( target.name.charAt(1) )
			{
				case "n" : target.visible = false;
			}
		}
		
	}
	
	
}