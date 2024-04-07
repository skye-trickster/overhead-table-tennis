/// @description Set GUI scaler depending on if it's on a browser

if (ON_BROWSER) {
	// TODO: figure out how to get the window of an iframe?
	window_set_size(640, 480);
	display_set_gui_size(640, 480);
	surface_resize(application_surface, 640, 480);
} else {
	display_set_gui_size(display_get_width(), display_get_height());
	display_set_gui_maximize();
}