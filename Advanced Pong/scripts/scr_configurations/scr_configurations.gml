global.sound_volume = 1;
global.automation = true;
global.difficulty = PADDLE_AI_DIFFICULTY.LOW;
global.settings = {
	ball_initial_speed: 3,
	ball_multiplier: 0.1,
}
global.flip_sides = false;

function set_difficulty(_level) {
	switch(_level) {
		case 1:
			global.difficulty = PADDLE_AI_DIFFICULTY.VERY_LOW;
		break;
		case 2:
			global.difficulty = PADDLE_AI_DIFFICULTY.LOW;
		break;
		case 3:
			global.difficulty = PADDLE_AI_DIFFICULTY.MEDIUM_LOW;
		break;
		case 4:
			global.difficulty = PADDLE_AI_DIFFICULTY.MEDIUM;
		break;
		default:
			throw("Difficulty can only scale between 1 and 4");
	}
}

font_add_enable_aa(false);
global.font = font_add_sprite_ext(spr_font, "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-.:<>", true, 2);
draw_set_font(global.font);

/// @function			audio_volume_set(volume)
/// @description		Sets the sound audio volume to a certain amount
/// @param {Real}	_v	Volume amount. From 1 to 10.
function audio_volume_set(_v) {
	var _volume = _v / 10;
	global.sound_volume = _volume;
	audio_group_set_gain(audiogroup_default, _volume, 0);
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

/// @function			check_struct_variable(struct, name)
/// @description		Gets the struct's variable if it exists. Returns undefined otherwise.
/// @param {Struct}		_struct			The name of the struct
/// @param {String}		_variable_name	The name of the variable
/// @returns			The variable's value if it exists. Undefined otherwise
/// @pure
function check_struct_variable(_struct, _variable_name) {
	if(variable_struct_exists(_struct, _variable_name)) return variable_struct_get(_struct, _variable_name);

	return undefined;
}