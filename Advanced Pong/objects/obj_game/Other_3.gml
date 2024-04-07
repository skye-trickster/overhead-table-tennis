/// @description Delete the loaded sprite

if (global.font) {
	font_delete(global.font);
	global.font = noone;	
}