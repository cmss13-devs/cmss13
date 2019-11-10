/icon/proc/debugBlend(var/icon/I, var/op, var/x=1, var/y=1)
	log_debug("Icon Blend usage: srcref=\ref[src] / Arguments: iconref=\ref[I], operation=[op], x=[x], y=[y]", diary_only=TRUE)

	Blend(I, op, x, y)

/icon/proc/debugShift(var/dir, var/offset, var/wrap=0)
	log_debug("Icon Shift usage: srcref=\ref[src] / Arguments: dir=[dir], offset=[offset], wrap=[wrap]", diary_only=TRUE)

	Shift(dir, offset, wrap)

/icon/proc/debugTurn(var/angle)
	log_debug("Icon Turn usage: srcref=\ref[src] / Arguments: angle=[angle]", diary_only=TRUE)

	Turn(angle)

/icon/proc/debugScale(var/width, var/height)
	log_debug("Icon Scale usage: srcref=\ref[src] / Arguments: width=[width], height=[height]", diary_only=TRUE)

	Scale(width, height)

/icon/proc/debugCrop(var/x1, var/y1, var/x2, var/y2)
	log_debug("Icon Crop usage: srcref=\ref[src] / Arguments: x1=[x1], y1=[y1], x2=[x2], y2=[y2]", diary_only=TRUE)

	Crop(x1, y1, x2, y2)
