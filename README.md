# spreadSheet-haxe
OpenFl

import variables from spreadSheet, dynamically update with the option to inline them at relase.

##How to use
create  a cvs file in your machine, you can a text editor 
example:

floorHeight,200
heroSpeed,1000
heroJumpSpeed,-200

Change MyConstants.hx to use that file as input.

Upload that file to a google spreadSheet, or crate a new one using the same values.

Click share and make it so "Anyone with the link can view"


copy your spreadSheet id 
https://docs.google.com/spreadsheets/d/"spreadSheetId"/edit?usp=sharing

To update your values from the web call 

CsvImporter.load(spreadSheetID,0);


to get the values just type MyConstants.heroSpeed, the auto-complete should work. Use them directly so when you download the data from the web the values are updated.

To inline the values use <haxedef name="INLINE_VARIABLES"/> in your project, when the values are inline you can't update them.


For the moment all variables names must be haxe compatible names(no spaces,etc), and all the values are cast as floats

