enum SCORE_EFFECT {
	NONE,
	LEFT_MATCH_POINT,
	LEFT_ADVANTAGE,
	RIGHT_MATCH_POINT,
	RIGHT_ADVANTAGE,
	DEUCE,
	WIN
}

/// @function		check_effect()
/// @description	Checks the score effect with the current paddle scores.
/// @returns		{Enum.SCORE_EFFECT} The current effect of the score
/// @pure
function check_effect() {
	var _left_score = global.paddle[PADDLE_SIDE.LEFT].score ?? 0;
	var _right_score = global.paddle[PADDLE_SIDE.RIGHT].score ?? 0;
	var _difference = _left_score - _right_score;
	
	if (_left_score >= 10 and _right_score < 10) return SCORE_EFFECT.LEFT_MATCH_POINT;
	if (_right_score >= 10 and _left_score < 10) return SCORE_EFFECT.RIGHT_MATCH_POINT;
	if (_difference == 0 and _left_score >= 10) return SCORE_EFFECT.DEUCE;
	if (_left_score >= 10) {
		if (_difference == 0) return SCORE_EFFECT.DEUCE;
		
		return _difference > 0 ? SCORE_EFFECT.LEFT_ADVANTAGE : SCORE_EFFECT.RIGHT_ADVANTAGE;
	}

	return SCORE_EFFECT.NONE;
}

/// @function				tally_score(ball)
/// @param {id.instance}	_ball The ball instance
function tally_score(_ball) {
	if (_ball.object_index != obj_ball) throw("score must be determined by the ball");
	var _paddle = _ball.last_paddle;
	global.paddle[_paddle.player_type].score += 1;
	global.game_state = GAME_STATE.BETWEEN_POINTS;
	audio_play_sound(snd_point_gain, 0, 0)
}