package ld30.sound;

/**
 * @author namide.com
 */
class SoundManager
{
	private static var _CAN_INSTANTIATE:Bool = false;
	private static var _INSTANCE:SoundManager;
	
	public var sampleMutted(get, set):Bool;
	var _sampleMutted:Bool = false;
	public var musicMutted(get, set):Bool;
	var _musicMutted:Bool = false;
	
	private var _musicListNames:Array<String>;
	private var _musicListSimpleSound:Array<SimpleSound>;
	
	private var _sampleListNames:Array<String>;
	private var _sampleListSimpleSound:Array<SimpleSound>;
	
	public function new() 
	{
		if (_CAN_INSTANTIATE = false) throw "You can't instancies a singleton, you must use the static method getInstance()";
		
		_sampleListNames = [];
		_sampleListSimpleSound = [];
		
		_musicListNames = [];
		_musicListSimpleSound = [];
	}
	
	public function addSound( name:String, src:String, sample:Bool = true ):Void
	{
		if ( sample )
		{
			_sampleListNames.push( name );
			_sampleListSimpleSound.push( new SimpleSound( src ) );
		}
		else
		{
			_musicListNames.push( name );
			_musicListSimpleSound.push( new SimpleSound( src ) );
			_musicListSimpleSound[_musicListSimpleSound.length-1].volume = 0.3;
		}
	}
	
	public function play( name:String ):Void
	{
		var i:Int = Lambda.indexOf( _sampleListNames, name );
		if ( i > -1 )
		{
			if ( !_sampleMutted ) 
			{
				_sampleListSimpleSound[i].play();
			}
		}
		else if ( !_musicMutted && i < 0 ) 
		{
			i = Lambda.indexOf( _musicListNames, name );
			_musicListSimpleSound[i].play();
		}
	}
	
	public static function getInstance():SoundManager
	{
        if (_INSTANCE == null)
		{
            _CAN_INSTANTIATE = true;
            _INSTANCE = new SoundManager();
            _CAN_INSTANTIATE = false;
        }
        return _INSTANCE;
    }
	
	function get_sampleMutted():Bool 
	{
		return _sampleMutted;
	}
	
	function set_sampleMutted(val:Bool):Bool 
	{
		_sampleMutted = val;
		return _sampleMutted;
	}
	
	function get_musicMutted():Bool 
	{
		return _musicMutted;
	}
	
	function set_musicMutted(val:Bool):Bool 
	{
		_musicMutted = val;
		if ( _musicMutted )
		{
			for ( ss in _musicListSimpleSound )
			{
				ss.pause();
			}
		}
		else
		{
			for ( ss in _musicListSimpleSound )
			{
				ss.play();
			}
		}
		return _musicMutted;
	}
}