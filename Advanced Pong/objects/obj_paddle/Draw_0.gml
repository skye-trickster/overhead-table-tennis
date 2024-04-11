/// @description Draw paddle sprite

switch(power_state) {
	case PADDLE_POWER_STATE.NONE:
		image_blend = c_white;
	break;
	
	case PADDLE_POWER_STATE.POWER_READY:
		image_blend = c_lime;
	break;
	
	case PADDLE_POWER_STATE.SUPER_READY:
		image_blend = c_red;
	break;
}

draw_sprite_ext(sprite_index, image_number, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);