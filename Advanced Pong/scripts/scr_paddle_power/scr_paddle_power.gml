
enum PADDLE_POWER_STATE {
	NONE,
	POWER_READY,
	SUPER_READY,
}

function paddle_power_behavior() {
	if (automated) {
		power_state = PADDLE_POWER_STATE.NONE;	
	} else {
		switch(power_state) {
			case PADDLE_POWER_STATE.NONE:
				if (global.game_state == GAME_STATE.PLAYING and INPUT_CONFIRM_BUTTON_PRESSED) {
					// power state check
					if (power_meter_amount >= power_meter_max and super_meter_amount >= super_meter_max) {
						power_state = PADDLE_POWER_STATE.SUPER_READY;
					} else if (power_meter_amount >= power_meter_max) {
						power_state = PADDLE_POWER_STATE.POWER_READY;	
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