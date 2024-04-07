/// @function			draw_store_variables()
/// @description		Retrieves the current draw variables for storage later.
/// @returns {Struct}	The current draw variables
/// @self {Any}
/// @pure
function draw_store_variables() {
	return {
		color: draw_get_color(),
		alpha: draw_get_alpha(),
		halign: draw_get_halign(),
		valign: draw_get_valign(),
	}
}

/// @function			draw_set_variables(draw_variables)
/// @description		Sets the previously retrieved draw variables.
/// @param {Struct}		_variables	The stored draw variables
/// @self {Any}
function draw_set_variables(_variables) {
	draw_set_color(_variables.color);
	draw_set_alpha(_variables.alpha);
	draw_set_halign(_variables.halign);
	draw_set_valign(_variables.valign);
}

