/// @description Initialize score for the player
score_location = {
	x: 256,
	y: 100,
	scale: 6,
};
opponent = noone;

if (player_type == "right") {
	score_location.x = 768;
}

if (player_type == "left") {
	global.left_paddle = id;
	if (variable_global_exists("right_paddle")) {
		opponent = global.right_paddle;
		global.right_paddle.opponent = id;
	}
} else {
	global.right_paddle = id;
	if (variable_global_exists("left_paddle")) {
		opponent = global.left_paddle;
		global.left_paddle.opponent = id;
	}
}

function has_advantage() {
	if (opponent == noone) return false;
	return points > 10 and (points - opponent.points) >= 1;
}

function has_disadvantage() {
	if (opponent == noone) return false;
	return opponent.points > 10 and (opponent.points - points) >= 1;
}

function has_deuce() {
	if (opponent == noone) return false;
	return points >= 10 and points == opponent.points;
}