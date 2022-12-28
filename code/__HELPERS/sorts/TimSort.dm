//TimSort interface
/proc/sortTim(list/L, cmp=/proc/cmp_numeric_asc, associative, fromIndex=1, toIndex=0)
	if(L && L.len >= 2)
		fromIndex = fromIndex % L.len
		toIndex = toIndex % (L.len+1)
		if(fromIndex <= 0)
			fromIndex += L.len
		if(toIndex <= 0)
			toIndex += L.len + 1

		var/datum/sortInstance/instance = GLOB.sortInstance
		if(!instance)
			instance = new

		instance.L = L
		instance.cmp = cmp
		instance.associative = associative

		instance.timSort(fromIndex, toIndex)

	return L
