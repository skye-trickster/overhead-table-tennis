enum SCORE_EFFECT {
	NONE,
	LEFT_MATCH_POINT,
	LEFT_ADVANTAGE,
	RIGHT_MATCH_POINT,
	RIGHT_ADVANTAGE,
	DEUCE,
	LEFT_WIN,
	RIGHT_WIN
}

/// @function				check_effect()
/// @description			Checks the score effect with the current paddle scores.
/// @returns		{Real}	The current effect of the score
/// @pure
function check_effect() {
	var _left_score = global.paddle[PADDLE_SIDE.LEFT].score ?? 0;
	var _right_score = global.paddle[PADDLE_SIDE.RIGHT].score ?? 0;
	var _difference = _left_score - _right_score;
	
	if (_left_score > 10) {
		if (_difference == 0) return SCORE_EFFECT.DEUCE;
		if (_difference == 1) return SCORE_EFFECT.LEFT_ADVANTAGE;
		if (_difference > 1) return SCORE_EFFECT.LEFT_WIN;
	}
	if (_right_score > 10) {
		if (_difference == 0) return SCORE_EFFECT.DEUCE;
		if (_difference == -1) return SCORE_EFFECT.RIGHT_ADVANTAGE;

		return SCORE_EFFECT.RIGHT_WIN;
	}
	
	if (_left_score == 10) return _difference == 0 ? SCORE_EFFECT.DEUCE : SCORE_EFFECT.LEFT_MATCH_POINT;
	if (_right_score == 10) return _difference == 0 ? SCORE_EFFECT.DEUCE : SCORE_EFFECT.RIGHT_MATCH_POINT;
	

	return SCORE_EFFECT.NONE;
}

/// @function							tally_score(ball, [multiplier])
/// @param {Id.Instance}	_ball		The ball instance
/// @param {Real}			_multiplier	how much to scale the score by.
function tally_score(_ball, _multiplier = 1) {
	if (_ball.object_index != obj_ball) throw("score must be determined by the ball");
	var _paddle = _ball.last_paddle;
	_ball.id.playing = false;
	global.paddle[_paddle.player_type].score += _multiplier;
	var _effect = check_effect();
	
	if (_effect == SCORE_EFFECT.RIGHT_WIN or _effect == SCORE_EFFECT.LEFT_WIN) {
		global.game_state = GAME_STATE.WINNING;	
	} else {
		global.game_state = GAME_STATE.BETWEEN_POINTS;	
	}

	audio_play_sound(snd_point_gain, 0, 0);
}