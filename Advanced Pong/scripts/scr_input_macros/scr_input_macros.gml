/* 
	NAME:			SCR_INPUT_MACROS.GML
	AUTHOR:			Skye Trickster
	VERSION:		0.0.2
	LAST MODIFIED:	3 APRIL 2024
*/

#region INPUT_MACROS

#region BUTTON_MACROS

#macro LEFT_UP_BUTTON ord("W")
#macro LEFT_DOWN_BUTTON ord("S")

#macro RIGHT_UP_BUTTON vk_up
#macro RIGHT_DOWN_BUTTON vk_down

#macro CONFIRM_BUTTON vk_space
#macro PAUSE_BUTTON vk_escape

#endregion

#macro LEFT_INPUT_UP_PRESSED keyboard_check_pressed(LEFT_UP_BUTTON)
#macro LEFT_INPUT_UP keyboard_check(LEFT_UP_BUTTON)

#macro LEFT_INPUT_DOWN_PRESSED keyboard_check_pressed(LEFT_DOWN_BUTTON)
#macro LEFT_INPUT_DOWN keyboard_check(LEFT_DOWN_BUTTON)

#macro RIGHT_INPUT_UP_PRESSED keyboard_check_pressed(RIGHT_UP_BUTTON)
#macro RIGHT_INPUT_UP keyboard_check(RIGHT_UP_BUTTON)

#macro RIGHT_INPUT_DOWN_PRESSED keyboard_check_pressed(RIGHT_DOWN_BUTTON)
#macro RIGHT_INPUT_DOWN keyboard_check(RIGHT_DOWN_BUTTON)

#macro INPUT_CONFIRM_BUTTON_PRESSED keyboard_check_pressed(CONFIRM_BUTTON)
#macro INPUT_PAUSE_BUTTON_PRESSSED keyboard_check_pressed(PAUSE_BUTTON)

#macro LEFT_INPUT_VERTICAL (LEFT_INPUT_DOWN - LEFT_INPUT_UP)
#macro RIGHT_INPUT_VERTICAL (RIGHT_INPUT_DOWN - RIGHT_INPUT_UP)

#endregion
