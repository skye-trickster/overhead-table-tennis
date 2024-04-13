/// @description Draw paddle sprite
var _variables = draw_store_variables()
power_meter.draw();

switch(power_state) {
	case PADDLE_POWER_STATE.NONE:
		image_blend = c_white;
	break;
	
	case PADDLE_POWER_STATE.POWER_READY:
		image_blend = power_color.color();
	break;
	
	case PADDLE_POWER_STATE.SUPER_READY:
		image_blend = super_color.color();
	break;
}

if (shown)
	draw_sprite_ext(sprite_index, image_number, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

draw_set_variables(_variables);