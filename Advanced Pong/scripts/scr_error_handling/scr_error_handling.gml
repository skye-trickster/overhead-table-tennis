
function Error(_err = {code: 000, message: "Unknown error", object: noone}) constructor {
	code = _err.code;
	message = _err.message;
	object = _err.object;
}

/*exception_unhandled_handler(function(_error)
{
	show_debug_log(true);
	show_debug_message(_error);
});*/