/// @description Check if need to tally the score

if (playing and (x < 0 or x > room_width)) {
	if (power_state == BALL_POWER_STATE.SUPER) {
		tally_score(self, 2);	
	} else {
		tally_score(self);		
	}
}