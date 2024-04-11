enum MENU_TYPE {
	MENU_NODE,
	TOGGLE,
	SCALE
}

#macro MENU_UNSELECTED_COLOR c_white
#macro MENU_SELECTED_COLOR c_lime

#macro TITLE_HEIGHT display_get_gui_height() / 6
#macro MENU_CENTER display_get_gui_width() / 2
#macro MENU_MIDDLE display_get_gui_height() / 2

/// @function					MenuNode(text, value, [type], [options])
/// @param {String}				_text		The the menu node's text information
/// @param {Real.MENU_TYPE}		_type		The menu type that's used
/// @param {Struct}				_options	The list of options for that menu type
function MenuNode(_text, _type, _options) constructor {
	text = string_upper(_text);
	type = _type;
	options = {};

	function set_scale_value(_value) {
		options.current_value = _value;
		script_execute(options.change_function, _value);
	}

	// TODO: throw a custom error if the options doesn't have the desired features.
	// set options depending on the menu type
	switch(type) {
		case MENU_TYPE.MENU_NODE:
			options = {
				return_value: check_struct_variable(_options, "return_value") ?? "",	
			}
		break;
		
		case MENU_TYPE.TOGGLE:
			options = {
				enabled_text: string_upper(check_struct_variable(_options, "enabled_text") ?? ""),
				disabled_text: string_upper(check_struct_variable(_options, "disabled_text") ?? ""),
				global_variable: check_struct_variable(_options, "global_variable") ?? "",
			};
		break;

		case MENU_TYPE.SCALE:
			options = {
				minimum: _options.minimum,
				maximum: _options.maximum,
				default_value: _options.default_value,
				current_value: _options.default_value,
				change_function: _options.change_function,
				loop: check_struct_variable(_options, "loop") ?? false,
			}
			set_scale_value(options.current_value);
		break;
	};

	///	@function					render(x, y, text_scale, color, padding)
	///	@description				Render the text for the menu node.
	/// @self						Struct.MenuNode
	function render(_x, _y, _text_scale, _color, _padding, _selected = false) {
		var _text = ""
		switch(type) {
			case MENU_TYPE.MENU_NODE:
				draw_set_halign(fa_center);
				draw_text_transformed_color(_x, _y, text, _text_scale, _text_scale, 0, _color, _color, _color, _color, 1);
			break;
			
			case MENU_TYPE.TOGGLE:
				draw_set_halign(fa_right);
				draw_text_transformed_color(_x, _y, string(text) + ": ", _text_scale, _text_scale, 0, MENU_UNSELECTED_COLOR, MENU_UNSELECTED_COLOR, MENU_UNSELECTED_COLOR, MENU_UNSELECTED_COLOR, 1);

				draw_set_halign(fa_left);
				_text = check_global_variable(options.global_variable) == true ? options.enabled_text : options.disabled_text;
				draw_text_transformed_color(_x, _y, _text, _text_scale, _text_scale, 0, _color, _color, _color, _color, 1);
			break;
			
			case MENU_TYPE.SCALE:
				draw_set_halign(fa_right);
				draw_text_transformed_color(_x, _y, string(text) + ": ", _text_scale, _text_scale, 0, MENU_UNSELECTED_COLOR, MENU_UNSELECTED_COLOR, MENU_UNSELECTED_COLOR, MENU_UNSELECTED_COLOR, 1);

				draw_set_halign(fa_left);
				_text = string(options.current_value);
				if (_selected and options.current_value > options.minimum) {
					_text = "< " + _text;	
				} else {
					_text = "  " + _text;	
				}
				if (_selected and options.current_value < options.maximum) {
					_text = _text + " >";	
				} else {
					_text = _text + "  ";	
				}
				
				draw_text_transformed_color(_x, _y, _text, _text_scale, _text_scale, 0, _color, _color, _color, _color, 1);			
			break;
			
			default:
				draw_set_halign(fa_center);
				draw_text_transformed_color(_x, _y, text, _text_scale, _text_scale, 0, _color, _color, _color, _color, 1);
		}
	}
	
	///	@function					on_select()
	///	@description				Perform select actions and returns the value
	/// @returns {Any}				The value of the selected menu item.
	/// @self						Struct.MenuNode
	function on_select() {
		switch(type) {
			case MENU_TYPE.MENU_NODE:
				return options.return_value;

			case MENU_TYPE.TOGGLE:
				var _value = check_global_variable(options.global_variable) ?? false;
				variable_global_set(options.global_variable, (not _value));
				return (not _value);
				
			case MENU_TYPE.SCALE:
				if (options.loop) {
					if (options.current_value == options.maximum) {
						set_scale_value(options.minimum)
					} else {
						raise_value();	
					}
				}
			break;
		}
	}
	
	/// @function			lower_value()
	/// @description		Toggle the lower value option for special menu options
	/// @self				Struct.MenuNode
	function lower_value() {
		switch(type) {
			case MENU_TYPE.TOGGLE:
				var _value = check_global_variable(options.global_variable) ?? false;
				variable_global_set(options.global_variable, (not _value));
			break;
			case MENU_TYPE.SCALE:
				if (options.current_value > options.minimum) {
					set_scale_value(options.current_value - 1);	
				}
		}
	}

	/// @function			raise_value()
	/// @description		Toggle the upper value option for special menu options
	/// @self				Struct.MenuNode
	function raise_value() {
		switch(type) {
			case MENU_TYPE.TOGGLE:
				var _value = check_global_variable(options.global_variable) ?? false;
				variable_global_set(options.global_variable, (not _value));
			break;
			case MENU_TYPE.SCALE:
				if (options.current_value < options.maximum) {
					set_scale_value(options.current_value + 1);
				}
			break;
		}
	}
}

///	@function		draw_version_number()
///	@description	Draws the current version number to render on the bottom-right corner of the screen
/// @self {Any}
function draw_version_number() {
	var _version = "VERSION " + string(GM_version)
	draw_set_valign(fa_bottom);
	draw_set_halign(fa_right);
	draw_set_color(c_white);
	draw_text(display_get_gui_width() - 4, display_get_gui_height() - 4, _version);
}

///	@param {Array.MenuNode}		_node_list	The list of nodes that should be used for the menu
/// @param {String}				_title		The menu title
/// @param {Bool}				_overlay	Whether the menu should have an overlay over the GUI
/// @param {Real}				_text_scale	The scale to adjust the text with
///	@description				A menu to be used in the overlay
function Menu(_node_list, _title = GM_project_filename, _overlay = true, _text_scale = 2) constructor {
	return_value = "";
	nodes = _node_list;
	selected = 0;
	overlay = _overlay;
	padding = 4;
	margin = 6;
	text_scale = _text_scale;
	title = string_upper(_title);
	
	///	@function					next_menu_option()
	///	@description				Changes to the next selected menu item.
	///								loops if selected goes past the list.
	function next_menu_option() {
		selected = (selected + 1) mod array_length(nodes);
		audio_play_sound(snd_paddle_hit, 1, 0);
	}

	///	@function					previous_menu_option()
	///	@description				Changes to the previous selected menu item.
	///								loops if selected goes past the list.
	function previous_menu_option() {
		var _length = array_length(nodes)
		selected = (selected + _length - 1) mod _length;
		audio_play_sound(snd_paddle_hit, 1, 0);
	}
	
	///	@function					select()
	///	@description				Grabs the return value of the selected menu item.
	/// @returns {String, Bool}		The value of the selected menu item.
	function select() {
		return_value = nodes[selected].on_select();
		return return_value;
	}
	
	///	@function					check_if_selected()
	///	@description				Checks if something has been selected in the menu
	/// @returns {Bool}				Whether or not a menu item has been selected
	function check_if_selected() {
		return return_value != ""
	}
	
	function lower_option_value() {
		nodes[selected].lower_value();	
	}
	
	function raise_option_value() {
		nodes[selected].raise_value();
	}

	///	@function		render(x, y)
	///	@description	Renders the title and each menu item
	/// @param {Real}	_x	The horizontal position of the start of the menu options
	/// @param {Real}	_y	The vertical position of the start of the menu options
	function render(_x = MENU_CENTER, _y = MENU_MIDDLE) {
		if (overlay) {
			draw_set_color(c_black);
			draw_set_alpha(0.75);
			draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);	
		}

		draw_set_color(MENU_UNSELECTED_COLOR);
		draw_set_alpha(1);
		
		draw_text_transformed(MENU_CENTER, TITLE_HEIGHT, title, text_scale, text_scale, 0);

		var _gap = string_height("TEST") * text_scale + padding * 2 + margin * 2 + 2;
		
		var _offset = min(_gap * array_length(nodes) / 2, TITLE_HEIGHT);
		
		for (var _i = 0; _i < array_length(nodes); ++_i) {
			var _color = MENU_UNSELECTED_COLOR;
			var _is_selected = selected == _i;
			if (_is_selected) {
				_color = MENU_SELECTED_COLOR;
			}
			nodes[_i].render(_x, _y + (_gap * _i) - _offset, text_scale, _color, padding, _is_selected);
		}
	}
	
	function navigate() {
		if (INPUT_CONFIRM_BUTTON_PRESSED) {
			return select();	
		}
		
		if (INPUT_UP_PRESSED) {
			previous_menu_option();
		} else if (INPUT_DOWN_PRESSED) {
			next_menu_option();
		}
		
		if (INPUT_RIGHT_PRESSED) {
			raise_option_value();	
		} else if (INPUT_LEFT_PRESSED) {
			lower_option_value();	
		}

		return undefined;
	}
	
	function reset() {
		selected = 0;
		return_value = "";
	}
}

var _main_menu_items = [
		new MenuNode("Start Game", MENU_TYPE.MENU_NODE, {
			return_value: "start"
		}),
		new MenuNode("Game Mode", MENU_TYPE.TOGGLE, {
			enabled_text: "vs CPU",
			disabled_text: "2 player game",
			global_variable: "automation"
		}),
		new MenuNode("Player Side", MENU_TYPE.TOGGLE, {
			enabled_text: "Right",
			disabled_text: "Left",
			global_variable: "flip_sides"
		}),
		new MenuNode("Difficulty", MENU_TYPE.SCALE, {
			minimum: 1,
			maximum: 5,
			default_value: 2,
			change_function: set_difficulty,
			loop: true
		}),
		new MenuNode("Volume", MENU_TYPE.SCALE, {
			minimum: 0,
			maximum: 10,
			default_value: 10,
			change_function: audio_volume_set,
			loop: false
		}),
	];
var _pause_menu_items = [
		new MenuNode("Resume", MENU_TYPE.MENU_NODE, {return_value: "resume"} ),
		new MenuNode("Return to menu", MENU_TYPE.MENU_NODE, {return_value: "menu"}),
	];

if (NOT_ON_BROWSER) {
	// Add exit node to the menu items when not on a browser
	var _exit_node = new MenuNode("Exit Game", MENU_TYPE.MENU_NODE, {return_value: "exit"})
	array_push(_main_menu_items, _exit_node);
	array_push(_pause_menu_items, _exit_node);
}

global.main_menu = new Menu(_main_menu_items, GAME_TITLE);
global.pause_menu = new Menu(_pause_menu_items, "PAUSED");
