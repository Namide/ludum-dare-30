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
import ld30.core.NumUtils;
import ld30.entities.World;

/**
 * ...
 * @author namide.com
 */
class Build extends Screen
{
	var _world:World;
	var _parts:Array<DisplayObjectContainer> = [];
	var _partsBuild:Int = 0;
	
	var _partInitScale:Float;
	var _partDragged:Sprite;
	var _partParent:DisplayObjectContainer;
	
	var _startBtn:DisplayObject;
	var _leaveBtn:DisplayObject;
	var _instructions:DisplayObject;
	
	var _levelData:LevelDatas;
	
	public function new( num:Int = 0 ) 
	{
		super();
		
		initLevel( num );
	}
	
	private function initLevel( num:Int ):Void
	{
		_levelData = getLevelDatas()[num];
		
		var mc:MovieClip = Lib.attach( _levelData.name );
		addChild( mc );
		
		var bg:DisplayObjectContainer = cast( mc.getChildByName( _levelData.bg ), DisplayObjectContainer );
		
		var worldPos:Rectangle = new Rectangle( bg.x, bg.y, bg.scaleX, bg.scaleY );
		_world = new World( bg,
							_levelData.lines,
							_levelData.columns,
							Math.round(_levelData.width / _levelData.columns),
							Math.round(_levelData.height / _levelData.lines),
							num );
		
		_world.x = worldPos.x;
		_world.y = worldPos.y;
		_world.scaleX = worldPos.width;
		_world.scaleY = worldPos.height;
		
		addChildAt( _world, 0 );
		
		for ( s in _levelData.worlds )
		{
			var part:DisplayObjectContainer = cast( mc.getChildByName(s), DisplayObjectContainer );
			_partInitScale = part.scaleX;
			
			part.addEventListener( MouseEvent.MOUSE_DOWN, pressWorld );
			_parts.push( part );
		}
		
		_startBtn = mc.getChildByName( _levelData.start );
		_leaveBtn = mc.getChildByName( _levelData.leave );
		_instructions = mc.getChildByName( _levelData.instructions );
		_startBtn.addEventListener( MouseEvent.CLICK, startLevel );
		_leaveBtn.addEventListener( MouseEvent.CLICK, leave );
		_startBtn.visible = false;
		_leaveBtn.visible = false;
	}
	
	private function leave(e:Dynamic = null):Void
	{
		onChangeScreen( new Start() );
	}
	
	public function resumeSave( save:SaveWorld )
	{
		for ( part in _parts )
		{
			var name:String = part.name;
			_world.addWorldPart( part, save.getIbyName(name), save.getJbyName(name) );
			//_world.addWorldPart( part, save[name][0], save[name][1] );
		}
		startLevel();
	}
	
	private function startLevel(e:Dynamic = null):Void
	{
		_startBtn.removeEventListener( MouseEvent.CLICK, startLevel );
		_leaveBtn.removeEventListener( MouseEvent.CLICK, leave );
		
		for ( part in _parts )
		{
			part.removeEventListener( MouseEvent.MOUSE_DOWN, pressWorld );
		}
		onChangeScreen( new Play(_world) );
	}
	
	private function pressWorld(e:MouseEvent):Void
	{
		_partDragged = e.currentTarget;
		_partParent = _partDragged.parent;
		
		_partDragged.scaleX = _partDragged.scaleY = _partInitScale;
		addChild( _partDragged );
		_partDragged.x = mouseX - _partDragged.width * 0.5;
		_partDragged.y = mouseY - _partDragged.height * 0.5;
		
		_partDragged.startDrag( false, new Rectangle(0, 0, 1280 - _partDragged.width, 720 - _partDragged.height) );
		stage.addEventListener( MouseEvent.MOUSE_UP, releaseWorld );
	}
	
	private function releaseWorld(e:MouseEvent):Void
	{
		stage.removeEventListener( MouseEvent.MOUSE_UP, releaseWorld );
		var pos:Point = new Point(_partDragged.x, _partDragged.y);
		_partDragged.stopDrag();
		
		if (	_world.mouseX > 0 && _world.mouseX < _world.w &&
				_world.mouseY > 0 && _world.mouseY < _world.h )
		{
			var i:Int = Math.floor( (_world.mouseX / _world.w ) * (_world.columns) );
			var j:Int = Math.floor( (_world.mouseY / _world.h ) * (_world.lines) );
			i = NumUtils.minMax( i, 0, _world.columns - 1 );
			j = NumUtils.minMax( j, 0, _world.lines - 1 );
			if ( _partParent != _world ) _partsBuild++;
			_world.addWorldPart( _partDragged, i, j );
		}
		else
		{
			if ( _partParent == _world ) _partsBuild--;
			
			addChild( _partDragged );
			
			_partDragged.scaleX = _partDragged.scaleY = _partInitScale;
			_partDragged.x = mouseX - _partDragged.width * 0.5;
			_partDragged.y = mouseY - _partDragged.height * 0.5;
		}
		
		_startBtn.visible = ( _partsBuild >= _levelData.worlds.length );
		_instructions.visible = !_startBtn.visible;
		
	}
	
	static function getLevelDatas():Array<Object>
	{
		var levelsData:Array<Object> = [];
		levelsData[0] = new LevelDatas( "Level0MC", "b", ["w0", "w1", "w2", "w3"], "start", "leave", "compWorld", 2, 2, 640, 640 );
		levelsData[1] = new LevelDatas( "Level1MC", "b", ["p0", "p1", "p2"], "start", "leave", "compWorld", 3, 3, 630, 630 );
		return levelsData;
	}
	public static inline function getLevelLength():Int
	{
		return getLevelDatas().length;
	}
}


class LevelDatas
{
	public var name(default, null):String;			// name of the Class
	public var bg(default, null):String;			// name of background
	public var worlds(default, null):Array<String>;	// names of world parts
	public var start(default, null):String;			// button start
	public var leave(default, null):String;			// button leave
	public var instructions(default, null):String;	// instructions
	public var columns(default, null):Int;			// number of columns
	public var lines(default, null):Int;			// number of lines
	public var width(default, null):Int;			// world width
	public var height(default, null):Int;			// world height
	
	public function new( name:String, bg:String, worlds:Array<String>, start:String, leave:String, instructions:String, columns:Int, lines:Int, width:Int, height:Int ) 
	{
		this.name = name;
		this.bg = bg;
		this.worlds = worlds;
		this.columns = columns;
		this.lines = lines;
		this.width = width;
		this.height = height;
		this.start = start;
		this.leave = leave;
		this.instructions = instructions;
	}
}