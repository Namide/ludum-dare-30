package ld30.core;
import flash.display.DisplayObject;
import flash.geom.Point;

/**
 * ...
 * @author ...
 */
class NumUtils
{

	public function new() 
	{
		
	}
	
	public static inline function minMax ( num:Dynamic, min:Dynamic, max:Dynamic ):Dynamic
	{
		return ( num < min ) ? min : ( num > max ) ? max : num;
	}
	
	public static function moveAtoB( a:DisplayObject, b:DisplayObject, bDelta:Point = null, xActive:Bool = true, yActive:Bool = true ):Void
	{
		//trace(a.x, a.y);
		var p:Point = ( bDelta != null ) ? bDelta.clone() : new Point(0, 0);
		p = b.localToGlobal( p );
		p = a.parent.globalToLocal( p );
		
		if ( xActive ) a.x = p.x;
		if ( yActive ) a.y = p.y;
		//trace("->",a.x, a.y);
		
	}
	
	public static function globalDelta( a:DisplayObject, b:DisplayObject, aDelta:Point = null, bDelta:Point = null ):Point
	{
		if (aDelta == null) aDelta = new Point();
		if (bDelta == null) bDelta = new Point();
		return a.localToGlobal( aDelta ).subtract( b.localToGlobal( bDelta ) );
 	}
	
}