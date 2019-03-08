//Define a temporary string. This is the data Scribble will parse to make a JSON
var _string = "[ev|sound|sndCrank][rainbow]abcdef[] ABCDEF##[wave][c_orange]0123456789[] .,<>\"'&[sCoin][ev|sound|sndSwitch][sCoin|1][ev|sound|sndSwitch][sCoin|2][ev|sound|sndSwitch][sCoin|3][ev|sound|sndSwitch][shake][rainbow]!?[]\n\nthe quick brown fox [wave]jumps[] over the lazy dog\n\n[fa_right]THE [$FF4499][shake]QUICK [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER []THE LAZY DOG.";

//Build a JSON that describdes how the text should be laid out
//This script also (by default) builds vertex buffers to draw the text
json = scribble_create( _string, 200, 0.2, "sSpriteFont", fa_center, make_colour_hsv( 35, 140, 210 ) );

//Set how the text should be aligned relative to the draw coordinate
//Here, we're setting the alignment so that the middle/centre of the box is at the draw coordinate
scribble_set_box_alignment( json, fa_center, fa_middle );