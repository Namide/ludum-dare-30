package ld30;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;
import ld30.entities.Player;

/**
 * ...
 * @author namide.com
 */

class Main 
{
	
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// entry point
		
		var b:Player = new Player();
		Lib.current.addChild( b );
	}
	
}