/// @description move and collide
// You can write your code in this editor

#region MOVE AND COLLISION CODE
var _y = y + yspeed;
var _x = x + xspeed;

if (place_meeting(_x, _y, obj_wall)) {
	var _bounce_amount = 0;
	do {
		_y -= sign(yspeed);
		_bounce_amount += sign(yspeed);
	} until(!place_meeting(_x, _y, obj_wall) or abs(_bounce_amount) >= abs(yspeed))

	_y -= _bounce_amount;
	yspeed *= -1;
}

if (place_meeting(_x, _y, obj_paddle)) {
	// TODO: change paddle direciton based on how far from the center the ball hit the paddle
	var _bounce_amount = 0;
	do {
		_x -= sign(xspeed);
		_bounce_amount += sign(xspeed);
	} until(!place_meeting(_x, _y, obj_paddle) or abs(_bounce_amount) >= abs(xspeed))

	_x -= _bounce_amount;
	if (current_speed < maximum_speed) {
		speed_multiplier += speed_increase
		current_speed = clamp(initial_speed * speed_multiplier, 0, maximum_speed);
	}
	
	xspeed = -sign(xspeed) * current_speed;
}

y = _y;
x = _x;
#endregion