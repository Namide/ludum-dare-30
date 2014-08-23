package ld30.screens;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import flash.utils.Object;
import ld30.entities.World;

/**
 * ...
 * @author namide.com
 */
class Build extends Screen
{
	var world:World;
	var parts:Array<DisplayObjectContainer> = [];
	
	public function new( num:Int = 0 ) 
	{
		super();
		
		initLevel( num );
	}
	
	private function initLevel( num:Int ):Void
	{
		var levelData:LevelDatas = getLevelData( num );
		
		var mc:MovieClip = Lib.attach( levelData.name );
		addChild( mc );
		
		var bg:DisplayObjectContainer = cast( mc.getChildByName( levelData.bg ), DisplayObjectContainer );
		
		var worldPos:Rectangle = new Rectangle( bg.x, bg.y, bg.scaleX, bg.scaleY );
		world = new World( 	bg,
							levelData.lines,
							levelData.columns,
							Math.round(levelData.width / levelData.columns),
							Math.round(levelData.height / levelData.lines) );
		
		world.x = worldPos.x;
		world.y = worldPos.y;
		world.scaleX = worldPos.width;
		world.scaleY = worldPos.height;
		
		addChildAt( world, 0 );
		
		for ( s in levelData.worlds )
		{
			var part:DisplayObjectContainer = cast( mc.getChildByName(s), DisplayObjectContainer );
			part.addEventListener( MouseEvent.MOUSE_DOWN, pressWorld );
			parts.push( part );
		}
	}
	
	private function pressWorld(e:MouseEvent):Void
	{
		var world:Sprite = e.currentTarget;
		world.startDrag( false );
	}
	
	private function getLevelData(num:Int):Object
	{
		var levelsData:Array<Object> = [];
		levelsData[0] = new LevelDatas( "Level0MC", "b", ["w0", "w1", "w2", "w3"], 2, 2, 640, 640 );				
		
		return levelsData[num];
	}
}


class LevelDatas
{
	public var name(default, null):String;			// name of the Class
	public var bg(default, null):String;			// name of background
	public var worlds(default, null):Array<String>;	// names of world parts
	public var columns(default, null):Int;			// number of columns
	public var lines(default, null):Int;			// number of lines
	public var width(default, null):Int;			// world width
	public var height(default, null):Int;			// world height
	
	public function new( name:String, bg:String, worlds:Array<String>, columns:Int, lines:Int, width:Int, height:Int ) 
	{
		this.name = name;
		this.bg = bg;
		this.worlds = worlds;
		this.columns = columns;
		this.lines = lines;
		this.width = width;
		this.height = height;
	}
}