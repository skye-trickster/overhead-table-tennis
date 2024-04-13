
enum PADDLE_POWER_STATE {
	NONE,
	POWER_READY,
	SUPER_READY,
}

function paddle_power_behavior() {
	if (automated) {
		power_state = PADDLE_POWER_STATE.NONE;	
		power_meter_amount = 0;
		super_meter_amount = 0;
	} else {
		var _power_pressed = false;
		
		switch(player_type) {
			case PADDLE_SIDE.LEFT:
				_power_pressed = global.automation ? INPUT_SUPER_PRESSED : LEFT_INPUT_SUPER_PRESSED;
				break;
			case PADDLE_SIDE.RIGHT:
				_power_pressed = global.automation ? INPUT_SUPER_PRESSED : RIGHT_INPUT_SUPER_PRESSED;
				break;
		}

		switch(power_state) {
			case PADDLE_POWER_STATE.NONE:
				if (global.game_state == GAME_STATE.PLAYING and _power_pressed) {
					// power state check
					if (power_meter_amount >= power_meter_max and super_meter_amount >= super_meter_max) {
						power_state = PADDLE_POWER_STATE.SUPER_READY;
						audio_play_sound(snd_super_gain, 4, 0);
					} else if (power_meter_amount >= power_meter_max) {
						power_state = PADDLE_POWER_STATE.POWER_READY;	
						audio_play_sound(snd_power_gain, 4, 0);
					}
				}
			break;
			
			case PADDLE_POWER_STATE.SUPER_READY:
			case PADDLE_POWER_STATE.POWER_READY:
				if (global.game_state == GAME_STATE.MENU or global.game_state == GAME_STATE.BETWEEN_POINTS or global.game_state == GAME_STATE.WINNING) {
					power_state = PADDLE_POWER_STATE.NONE;	
				}
			break;
		}
	}
}

/// @description	Creates a PaddlePowerMeter object
/// @parameter		_paddle	The paddle instance
function PaddlePowerMeter(_paddle) constructor {
	paddle_id = _paddle
	change_speed = 0.1;
	current_power_draw = 0;
	current_super_draw = 0;
	width = 150;
	power_height = 15;
	super_height = 5;
	power_bar_color = new ColorScale(3);
	super_bar_color = new ColorScale(6);
	super_color = new ColorScale(15);
	power_color = new ColorScale(10);

	function update() {
		if (abs(current_power_draw - paddle_id.power_meter_amount) < 0.1) {
			current_power_draw = paddle_id.power_meter_amount;	
		} else {
			current_power_draw = lerp(current_power_draw, paddle_id.power_meter_amount, 0.1);
		}
		
		if (abs(current_super_draw - paddle_id.super_meter_amount) < 0.1) {
			current_super_draw = paddle_id.super_meter_amount;	
		} else {
			current_super_draw = lerp(current_super_draw, paddle_id.super_meter_amount, 0.1);
		}
		
		power_bar_color.update();
		super_bar_color.update();
		power_color.update();
		super_color.update();
	}

	function draw() {
		var _power_percent = current_power_draw / paddle_id.power_meter_max * 100;
		var _super_percent = current_super_draw / paddle_id.super_meter_max * 100;
		var _left_anchor = room_width / 2;
		var _health_bar_anchor = room_height / 10 * 9;
		var _power_color = _super_percent == 100 ? super_bar_color.color() : (_power_percent == 100 ? power_bar_color.color() : c_aqua);
		var _super_color = _super_percent == 100 ? super_bar_color.color() : c_aqua;

		switch(paddle_id.player_type) {
			case PADDLE_SIDE.LEFT:
				_left_anchor -= 10;
				draw_healthbar(_left_anchor - width, _health_bar_anchor - power_height, _left_anchor, _health_bar_anchor, _power_percent, c_dkgray, c_blue, _power_color, 1, true, true);
				draw_healthbar(_left_anchor - width, _health_bar_anchor, _left_anchor, _health_bar_anchor + super_height, _super_percent, c_dkgray, c_blue, _super_color, 1, true, true);
				draw_set_halign(fa_right);
				draw_set_valign(fa_top);
			break;
			case PADDLE_SIDE.RIGHT:
				_left_anchor += 10;
				draw_healthbar(_left_anchor, _health_bar_anchor - power_height, _left_anchor + width, _health_bar_anchor, _power_percent, c_dkgray, c_blue, _power_color, 1, true, true);
				draw_healthbar(_left_anchor, _health_bar_anchor, _left_anchor + width, _health_bar_anchor + super_height, _super_percent, c_dkgray, c_blue, _super_color, 1, true, true);
				draw_set_halign(fa_left);
				draw_set_valign(fa_top);
			break;
		}
		if (_super_percent == 100) {
			draw_text_color(_left_anchor, _health_bar_anchor + 10, "SUPER!", _super_color, _super_color, _super_color, _super_color, 1);
		} else if (_power_percent == 100) {
			draw_text_color(_left_anchor, _health_bar_anchor + 10, "POWER", _power_color, _power_color, _power_color, _power_color, 1);
		}
	}
}

function ColorScale(_speed) constructor {
	color_speed = _speed;
	current_amount = random(255);
	alpha_amount = random(255)
	
	function update() {
		current_amount = (current_amount + color_speed) mod 256;
		alpha_amount = (alpha_amount + color_speed) mod 256
	}
	
	function color() {
		return make_color_hsv(current_amount, 255, 255);	
	}
	
	function alpha() {
		return alpha_amount / 256;
	}
}