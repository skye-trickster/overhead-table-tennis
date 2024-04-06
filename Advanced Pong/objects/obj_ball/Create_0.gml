/// @desc Initialize ball

enum BALL_STATE {
	WAITING,
	PLAYING,
}

function reset_speed() {
	current_speed = initial_speed;
	speed_multiplier = 1;
}

function start_serve() {
	if (instance_number(obj_paddle) < 2) return;
	
	var _paddle = instance_find(obj_paddle, serving_player);
	var _angle = random_range(-return_angle / 2, return_angle / 2);
	
	xspeed = dcos(_angle) * current_speed * sign(_paddle.x - x);
	yspeed = dsin(_angle) * current_speed;
}

function initialize() {
	serving_player = random_range(0, 1);
	state = BALL_STATE.WAITING;
	reset_ball();
}

function reset_ball(_settings = {_adjust_y_value: false, _center_y: true}) {
	xspeed = 0;
	yspeed = 0;
	reset_speed();
	x = starting_point;
	if(_settings._center_y) {
		y = room_height / 2;	
	}
	if(_settings._adjust_y_value) {
		y = instance_find(obj_paddle, serving_player).y
	}
	last_paddle = instance_find(obj_paddle, (serving_player + 1) mod 2);
	state = BALL_STATE.PLAYING;
}

current_speed = 0;
last_paddle = id;
xspeed = 0;
yspeed = 0;
starting_point = x;
serving_player = 0;
state = BALL_STATE.WAITING;
switch_next_turn = false;

initialize();