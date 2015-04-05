package io;
import io.MyConstants;
import openfl.Assets;
import openfl.display.Loader;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;

/**
 * ...
 * @author Joaquin
 */
class CsvImporter
{

	public static function load(tableId:String,gridId:Int):Void
	{
		var loader:URLLoader = new URLLoader();
		loader.addEventListener(Event.COMPLETE, onLoad);
		loader.addEventListener(IOErrorEvent.IO_ERROR, handleLoadRemoteError);
		//loader.addEventListener(IOErrorEvent.NETWORK_ERROR, handleLoadRemoteError);
		loader.load(new URLRequest("https://docs.google.com/spreadsheets/d/"+tableId+"/export?format=csv"));
	}
	private static function  handleLoadRemoteError(e:IOErrorEvent ) {
		trace("ERROR: loading remote data failed");
		trace(e.text);
		trace(e.type);
		trace(e.errorID);
		trace("ERROR end");
	}
	private static function onLoad(e:Event):Void 
	{
		var loader:URLLoader = cast e.target;
		loader.removeEventListener(Event.COMPLETE, onLoad);
		var regex:EReg = new EReg("[ \t]*((\r\n)|\r|\n)[ \t]*", "g");
		var table:Array<String> = regex.split(loader.data);
		trace("enter");
		trace(loader.data);
		for (couple in table) 
		{
			var parts:Array<String> = couple.split(",");
			if (parts.length > 1)
			{
				MyConstants.setValue(parts[0], Std.parseFloat(parts[1]));
			}
		}
	}
	var mSendURL:URLRequest = new URLRequest();
	var mLoadURL:URLLoader = new URLLoader();
	private function updateValue(aRow:Int,aData:Float):Void
	{
		mSendURL.url = "https://script.google.com/macros/s/AKfycbzWWzuxMdZ8TavMf8HUlv7du-3o2xXF544roJoC32sS/dev?position=A" + aRow + "&data=" + aData;
		mLoadURL.load(mSendURL);
	}
	
}