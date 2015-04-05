package io;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FieldType;
import openfl.Assets;
import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author Joaquin
 */
class VariablesRetriever
{

	public function new() 
	{
		
	}
	macro public static function buildFileReferences(file:String):Array<Field>
	{ 
		var code:String;
		var exp:Array<Expr> = new Array();
		
		var file=File.read(file).readAll();
		var fileAsString:String = file.getString(0, file.length);
		var regex:EReg = new EReg("[ \t]*((\r\n)|\r|\n)[ \t]*", "g");
		var table:Array<String> = regex.split(fileAsString);
		var counter = table.length - 1;
		var fields:Array<Field> = Context.getBuildFields();
		while (counter>=0)
		{
			var parts:Array<String> = table[counter].split(",");
			if (parts.length > 1)
			{
			// create new field based on file references!
			fields.push({
				name: parts[0],
				doc: parts[0],
				#if INLINE_VARIABLES
				access: [Access.APublic, Access.AStatic, Access.AInline],
				#else
				access: [Access.APublic,Access.AStatic],
				#end
				kind: FieldType.FVar(macro:Float, macro $v{ Std.parseFloat(parts[1])}),
				pos: Context.currentPos()
			});
			#if !INLINE_VARIABLES
			exp.push(Context.parseInlineString(createIf(parts[0]), Context.currentPos()));
			#end
			}
			--counter;
		}
	
		
		//setValue function
		var c = macro : {
			public static function setValue(aName:String,aValue:Dynamic):Void{
				$b { exp }
			}
		}
	
		switch (c) {
			case TAnonymous(setFunction):
				return fields.concat(setFunction);
			default:
				throw 'unreachable';
		}
		
		return fields;
	}
	private static function createIf(aVariableName:String):String
	{
		
		return "if(aName==\"" + aVariableName+"\")  " + aVariableName+"= cast aValue";
	}
}