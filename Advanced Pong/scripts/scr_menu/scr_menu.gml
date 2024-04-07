/// @param {String}	_text		The the menu node's text information
/// @param {String}	_value		The return value of the menu item
/// @param {Struct}	_options	The list of optional setings for the menu node.
function MenuNode(_text, _value) constructor {
	text = string_upper(_text);
	return_value = _value;
	
	function render(_x, _y, _text_scale, _color, _padding) {
		var _width = string_width(text) * _text_scale;
		var _height = string_height(text) * _text_scale;
		draw_text_transformed_color(_x, _y, text, _text_scale, _text_scale, 0, _color, _color, _color, _color, 1);
	}
}

///	@param {Array.MenuNode}		_node_list	The list of nodes that should be used for the menu
/// @param {String}				_title		The menu title
/// @param {Bool}				_overlay	Whether the menu should have an overlay over the GUI
/// @param {Real}				_text_scale	The scale to adjust the text with
///	@description				A menu to be used in the overlay
function Menu(_node_list, _title = "FAKE PONG GAME", _overlay = true, _text_scale = 2) constructor {
	return_value = "";
	nodes = _node_list;
	selected = 0;
	overlay = _overlay;
	padding = 4;
	margin = 6;
	text_scale = _text_scale;
	title = string_upper(_title);
	
	///	@function					next()
	///	@description				Changes to the next selected menu item.
	///								loops if selected goes past the list.
	function next() {
		selected = (selected + 1) mod array_length(nodes);
		audio_play_sound(snd_paddle_hit, 1, 0);
	}

	///	@function					previous()
	///	@description				Changes to the previous selected menu item.
	///								loops if selected goes past the list.
	function previous() {
		var _length = array_length(nodes)
		selected = (selected + _length - 1) mod _length;
		audio_play_sound(snd_paddle_hit, 1, 0);
	}
	
	///	@function					select()
	///	@description				Grabs the return value of the selected menu item.
	/// @returns {String}			The value of the selected menu item.
	function select() {
		return_value = nodes[selected].return_value;
		return return_value;
	}
	
	///	@function					check_if_selected()
	///	@description				Checks if something has been selected in the menu
	/// @returns {Bool}				Whether or not a menu item has been selected
	function check_if_selected() {
		return return_value != ""
	}
	
	function render(_x, _y) {
		var _width = display_get_gui_width();
		var _height = display_get_gui_height();
		if (overlay) {
			draw_set_color(c_black);
			draw_set_alpha(0.75);
			draw_rectangle(0, 0, _width, _height, false);	
		}

		draw_set_color(c_white);
		draw_set_alpha(1);
		
		draw_text_transformed(_width / 2, _height / 6, title, text_scale, text_scale, 0);

		var _gap = string_height("TEST") * text_scale + padding * 2 + margin * 2 + 2;
		
		var _offset = _gap * array_length(nodes) / 2;
		
		for (var _i = 0; _i < array_length(nodes); ++_i) {
			var _color = c_white;
			if (selected == _i) {
				_color = c_lime;
			}
			nodes[_i].render(_x, _y + (_gap * _i) - _offset, text_scale, _color, padding);
		}
	}
}

global.main_menu = new Menu([
	new MenuNode("Start Game", "start"),
	new MenuNode("Exit Game", "exit"),
], "ADVANCED PONG GAME");

global.pause_menu = new Menu([
	new MenuNode("Resume", "resume"),
	new MenuNode("Return to menu", "menu"),
	new MenuNode("Exit Game", "exit"),
], "PAUSED");

if (ON_BROWSER) {
	global.main_menu = new Menu([
		new MenuNode("Start Game", "start"),
	], "ADVANCED PONG GAME");

	global.pause_menu = new Menu([
		new MenuNode("Resume", "resume"),
		new MenuNode("Return to menu", "menu"),
	], "PAUSED");
}