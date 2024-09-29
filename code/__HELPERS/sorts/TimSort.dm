//TimSort interface
/proc/sortTim(list/L, cmp=/proc/cmp_numeric_asc, associative, fromIndex=1, toIndex=0)
	if(length(L) >= 2)
		fromIndex = fromIndex % length(L)
		toIndex = toIndex % (length(L)+1)
		if(fromIndex <= 0)
			fromIndex += length(L)
		if(toIndex <= 0)
			toIndex += length(L) + 1

		var/datum/sortInstance/sort_instance = GLOB.sortInstance
		if(!sort_instance)
			sort_instance = new()

		sort_instance.L = L
		sort_instance.cmp = cmp
		sort_instance.associative = associative

		sort_instance.timSort(fromIndex, toIndex)

	return L
