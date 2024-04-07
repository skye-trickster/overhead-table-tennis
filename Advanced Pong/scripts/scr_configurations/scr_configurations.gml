global.sound_volume = 1;
global.font = font_add_sprite_ext(spr_font, "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-", true, 2);
draw_set_font(global.font);

/// @function			audio_volume_set(volume)
/// @description		Sets the sound audio volume to a certain amount
/// @param {Real}	_v	Volume amount
function audio_volume_set(_v) {
	global.sound_volume = _v;
	audio_group_set_gain(audiogroup_default, _v, 0);
}