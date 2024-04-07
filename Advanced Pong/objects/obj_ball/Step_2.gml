/// @description Check if need to tally the score

if (playing and (x < 0 or x > room_width)) {
	tally_score(self);
	playing = false;
}