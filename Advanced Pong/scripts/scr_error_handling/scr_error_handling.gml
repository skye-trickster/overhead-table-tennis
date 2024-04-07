exception_unhandled_handler(function(_exception)
{
	show_debug_log(true);
	show_debug_message(_exception);
	show_message("Unknown error found: "+ string(_exception));
	
	if file_exists("crash.txt") file_delete("crash.txt");
    var _f = file_text_open_write("crash.txt");
    file_text_write_string(_f, string(_exception));
    file_text_close(_f);
	
	return 0;
});