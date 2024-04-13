/// @description Draw menu and UI information

var _variables = draw_store_variables();

var _width = display_get_gui_width();
var _height = display_get_gui_height();
var _overlay_scale = 5;

#region Score rendering
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

var _score_scale = 6
var _effect = check_effect();

// LEFT SCORE
if (global.paddle[PADDLE_SIDE.LEFT].score or global.paddle[PADDLE_SIDE.LEFT].score == 0) {
	
	var _left_score = global.paddle[PADDLE_SIDE.LEFT].score;
	draw_set_color(c_white);
	switch(_effect) {
		case SCORE_EFFECT.DEUCE:
			_left_score = "DEUCE";
		break;

		case SCORE_EFFECT.LEFT_ADVANTAGE:
			_left_score = "ADV";
		break;

		case SCORE_EFFECT.RIGHT_ADVANTAGE:
			_left_score = "--";
		break;

		case SCORE_EFFECT.LEFT_WIN:
			_left_score = "WIN";
			draw_set_color(win_color);
		break;

		case SCORE_EFFECT.RIGHT_WIN:
			_left_score = "LOSE";
		break;
	}
	draw_text_transformed(_width / 4, _height / 8, _left_score, _score_scale, _score_scale, 0);	
}

// RIGHT SCORE
if (global.paddle[PADDLE_SIDE.RIGHT].score or global.paddle[PADDLE_SIDE.RIGHT].score == 0) {
	var _colors = [c_red, c_orange, c_yellow, c_green, c_blue, c_purple];
	var _right_score = global.paddle[PADDLE_SIDE.RIGHT].score;
	draw_set_color(c_white);
	switch(_effect) {
		case SCORE_EFFECT.DEUCE:
			_right_score = "DEUCE";
		break;
		
		case SCORE_EFFECT.RIGHT_ADVANTAGE:
			_right_score = "ADV";
		break;

		case SCORE_EFFECT.LEFT_ADVANTAGE:
			_right_score = "--";
		break;

		case SCORE_EFFECT.RIGHT_WIN:
			_right_score = "WIN";
			draw_set_color(win_color);
		break;

		case SCORE_EFFECT.LEFT_WIN:
			_right_score = "LOSE";
		break;
	}
	draw_text_transformed(3 * _width / 4, _height / 8, _right_score, _score_scale, _score_scale, 0);
}
#endregion

#region State-based Overlay
switch(global.game_state) {
	case GAME_STATE.MENU:
		global.main_menu.render();
		draw_version_number();
	break;

	case GAME_STATE.PAUSING:
		global.pause_menu.render();
	break;
}

#endregion

draw_set_variables(_variables);
