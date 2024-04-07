/// @description Insert description here
// You can write your code in this editor
if (playing and (x < 0 or x > room_width)) {
	tally_score(self);
	playing = false;
}