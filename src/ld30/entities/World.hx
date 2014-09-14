package ld30.entities;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import ld30.core.NumUtils;
import ld30.screens.Build;
import ld30.screens.Play;

class SaveWorld
{
	public var level:Int;
	public var partNames:Array<String>;
	public var partI:Array<Int>;
	public var partJ:Array<Int>;
	
	public function new( level:Int ) 
	{
		this.level = level;
		partNames = [];
		partI = [];
		partJ = [];		
	}
	
	public function addPart( name:String, i:Int, j:Int ):Void
	{
		var k:Int = partNames.indexOf( name );
		if ( k < 0 ) k = partNames.length;
		partNames[k] = name;
		partI[k] = i;
		partJ[k] = j;
	}
	
	public inline function getIbyName( name ):Int
	{
		return partI[ partNames.indexOf( name ) ];
	}
	
	public inline function getJbyName( name ):Int
	{
		return partJ[ partNames.indexOf( name ) ];
	}
	
}

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
	
	public var levelNum(default, null):Int;
	var _cellW:Int;
	var _cellH:Int;
	var _save:SaveWorld;
	
	public var w(default, default):Int;
	public var h(default, default):Int;
	
	public dynamic function onDead():Void { };
	public dynamic function onWin():Void { };
	public dynamic function onRedraw(e:Dynamic):Void { };
	public dynamic function onExit(e:Dynamic):Void { };
	
	public function new( bg:DisplayObjectContainer, cellX:Int = 2, cellY:Int = 2, cellW:Int = 320, cellH:Int = 320, levelNum:Int ) 
	{
		super();
		this.levelNum = levelNum;
		columns = cellX;
		lines = cellY;
		_cellW = cellW;
		_cellH = cellH;
		w = cellX * cellW;
		h = cellY * cellH;
		this.levelNum = levelNum;
		_save = new SaveWorld( levelNum );
		addWorldPart( bg );
		
		bg.getChildByName("redrawB").addEventListener( MouseEvent.CLICK, function(e:Dynamic):Void { onRedraw(e); } );
		bg.getChildByName("exitB").addEventListener( MouseEvent.CLICK, function(e:Dynamic):Void { onExit(e); } );
	}	
	
	public function restart():Void
	{
		var build:Build = new Build( levelNum );
		Main.changeScreen( build );
		build.resumeSave( _save );
	}
	
	private var _corner:Int = 0;
	private var _cornerLast:DisplayObject = null;
	public function hitTest( player:Player ):Void
	{
		var ha:DisplayObject = player.hitBox;
		
		var fromTop:Float = 0;
		var fromBottom:Float = 0;
		var fromLeft:Float = 0;
		var fromRight:Float = 0;
		
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
				
				// hack for corner bug
				if ( _corner > 1 ) min = fromTop;
				
				if (min == fromTop)
				{
					NumUtils.moveAtoB( player, e, new Point(0, -_ITEM_MI_SIZE), false, true );
					player.onGround = true;
					player.vY = 0;
					
					if ( _corner % 2 == 1 && _cornerLast == e ) _corner++;
					else  _corner = 0; 
				}
				else if (min == fromBottom)
				{
					NumUtils.moveAtoB( player, e, new Point(0, _ITEM_MI_SIZE), false, true );
					player.vY = Play.GRAVITY;
					
					_corner = 0; 
				}
				else if (min == fromRight)
				{
					NumUtils.moveAtoB( player, e, new Point( _ITEM_MI_SIZE, 0 ), true, false );
					player.x += _ITEM_MI_SIZE;
					player.vX = 0;
					if ( _corner % 2 == 0 && _cornerLast == e ) _corner++;
					else  _corner = 0; 
				}
				else if (min == fromLeft)
				{
					NumUtils.moveAtoB( player, e, new Point( -_ITEM_MI_SIZE, 0 ), true, false );
					player.x -= _ITEM_MI_SIZE;
					player.vX = 0;
					if ( _corner % 2 == 0 && _cornerLast == e ) _corner++;
					else  _corner = 0; 
				}
				_cornerLast = e;
			}
		}
		for ( e in entitiesItem )
		{
			if ( ha.hitTestObject( e ) )
			{
				var s:String = e.name.charAt(1);
				if ( s == "e" )
				{
					onWin();
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
		
		//_save[worldPart.name] = [i, j];
		_save.addPart( worldPart.name, i, j );
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