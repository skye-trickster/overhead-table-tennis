#macro DELTA_TIME delta_time / power(10, 6)
#macro GAME_PAUSED global.game_state == GAME_STATE.PAUSING
#macro ON_BROWSER os_browser != browser_not_a_browser
#macro NOT_ON_BROWSER os_browser == browser_not_a_browser
#macro GAME_TITLE "Overhead Table Tennis"

#macro DEBUG false or is_debug_overlay_open()