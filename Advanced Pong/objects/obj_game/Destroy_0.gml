/// @description Remove itself as a game object if destroyed

if (global.game_object == id) {
	global.game_object = noone;	
}