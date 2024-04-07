/// @description Set GUI scaler depending on if it's on a browser

if (ON_BROWSER) {
	display_set_gui_size(room_width, room_height);
	surface_resize(application_surface, room_width, room_height);
} else {
	display_set_gui_size(display_get_width(), display_get_height());
	display_set_gui_maximize();
}