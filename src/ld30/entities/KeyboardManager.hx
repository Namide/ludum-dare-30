package ld30.entities;

/**
 * ...
 * @author namide.com
 */
class KeyboardManager 
{
	private static var _CAN_INSTANTIATE:Bool = false;
	private static var _INSTANCE:KeyboardManager;

	public function new()
	{
		if (false == GameSettings._CAN_INSTANTIATE)
		{
			throw "Can't instantiate a singleton, use the static method getInstance()";
		}
		
		
	}
	
	public static inline function getInstance():KeyboardManager
	{
        if (_INSTANCE == null)
		{
            _CAN_INSTANTIATE = true;
            _INSTANCE = new KeyboardManager();
            _CAN_INSTANTIATE = false;
        }
        return _INSTANCE;
    }
	
}