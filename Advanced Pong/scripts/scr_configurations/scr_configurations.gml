global.sound_volume = 1;
global.automation = true;
global.difficulty = PADDLE_AI_DIFFICULTY.LOW;
global.settings = {
	ball_initial_speed: 3,
	ball_multiplier: 0.1,
}

font_add_enable_aa(false);
global.font = font_add_sprite_ext(spr_font, "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-.", true, 2);
draw_set_font(global.font);

/// @function			audio_volume_set(volume)
/// @description		Sets the sound audio volume to a certain amount
/// @param {Real}	_v	Volume amount
function audio_volume_set(_v) {
	global.sound_volume = _v;
	audio_group_set_gain(audiogroup_default, _v, 0);
}

/// @function			check_global_variable(name)
/// @description		Gets the global variable if it exists. Returns undefined otherwise.
/// @param {String}		_name	The name of the global variable
/// @returns			The variable's value if it exists. Undefined otherwise
/// @pure
function check_global_variable(_name) {
	if (variable_global_exists(_name)) return variable_global_get(_name);
	
	return undefined;
}