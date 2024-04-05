/// @description Insert description here
// You can write your code in this editor
draw_set_font(global.font ?? fnt_default);
var _score = string(points);

if (has_advantage()) {
	_score = "ADV";	
} else if (has_disadvantage()) {
	_score = "--";
} else if (has_deuce()) {
	_score = "DEUCE";	
}

draw_set_halign(fa_center);
draw_text_transformed(score_location.x, score_location.y, _score, score_location.scale, score_location.scale, 0);