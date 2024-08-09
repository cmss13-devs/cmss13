//A very crude linear approximatiaon of pythagoras theorem. (this is still used by chemsmoke)

/proc/cheap_pythag(dx, dy)
	dx = abs(dx); dy = abs(dy);
	if(dx>=dy) return dx + (0.5*dy) //The longest side add half the shortest side approximates the hypotenuse
	else return dy + (0.5*dx)
