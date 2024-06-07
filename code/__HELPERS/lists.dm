// List defines
/*
 * Holds procs to help with list operations
 * Contains groups:
 * Misc
 * Sorting
 */

/*
 * Misc
 */

//Returns a list in plain english as a string
/proc/english_list(list/input, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = "" )
	var/total = input.len
	if (!total)
		return "[nothing_text]"
	else if (total == 1)
		return "[input[1]]"
	else if (total == 2)
		return "[input[1]][and_text][input[2]]"
	else
		var/output = ""
		var/index = 1
		while (index < total)
			if (index == total - 1)
				comma_text = final_comma_text

			output += "[input[index]][comma_text]"
			index++

		return "[output][and_text][input[index]]"

//Returns list element or null. Should prevent "index out of bounds" error.
/proc/listgetindex(list/list,index)
	if(istype(list) && list.len)
		if(isnum(index))
			if(ISINRANGE(index,1,list.len))
				return list[index]
		else if(list[index])
			return list[index]
	return

//Checks for specific types in a list
/proc/is_type_in_list(atom/A, list/L)
	for(var/type in L)
		if(istype(A, type))
			return 1
	return 0

//Removes any null entries from the list
/proc/listclearnulls(list/list)
	if(istype(list))
		while(null in list)
			list -= null
	return

/*
 * Returns list containing all the entries from first list that are not present in second.
 * If skiprep = 1, repeated elements are treated as one.
 * If either of arguments is not a list, returns null
 */
/proc/difflist(list/first, list/second, skiprep=0)
	if(!islist(first) || !islist(second))
		return
	var/list/result = new
	if(skiprep)
		for(var/e in first)
			if(!(e in result) && !(e in second))
				result += e
	else
		result = first - second
	return result

/*
 * Returns list containing entries that are in either list but not both.
 * If skipref = 1, repeated elements are treated as one.
 * If either of arguments is not a list, returns null
 */
/proc/uniquemergelist(list/first, list/second, skiprep=0)
	if(!islist(first) || !islist(second))
		return
	var/list/result = new
	if(skiprep)
		result = difflist(first, second, skiprep)+difflist(second, first, skiprep)
	else
		result = first ^ second
	return result

//Pretends to pick an element based on its weight but really just seems to pick a random element.
/proc/pickweight(list/L)
	var/total = 0
	var/item
	for (item in L)
		if (!L[item])
			L[item] = 1
		total += L[item]

	total = rand(1, total)
	for (item in L)
		total -=L [item]
		if (total <= 0)
			return item
	return null

/// Pick a random element from the list and remove it from the list.
/proc/pick_n_take(list/L)
	RETURN_TYPE(L[_].type)
	if(L.len)
		var/picked = rand(1,L.len)
		. = L[picked]
		L.Cut(picked,picked+1) //Cut is far more efficient that Remove()

//Returns the top(last) element from the list and removes it from the list (typical stack function)
/proc/pop(list/L)
	if(L.len)
		. = L[L.len]
		L.len--

/proc/popleft(list/L)
	if(L.len)
		. = L[1]
		L.Cut(1,2)

//Returns the next element in parameter list after first appearance of parameter element. If it is the last element of the list or not present in list, returns first element.
/proc/next_in_list(element, list/L)
	for(var/i=1, i<L.len, i++)
		if(L[i] == element)
			return L[i+1]
	return L[1]

//Returns the previous element in parameter list before last appearance of parameter element. If it is the first element of the list or not present in list, returns last element.
/proc/prev_in_list(element, list/L)
	for(var/i=L.len, i>1, i--)
		if(L[i] == element)
			return L[i-1]
	return L[L.len]

/*
 * Sorting
 */

//Reverses the order of items in the list
/proc/reverselist(list/L)
	var/list/output = list()
	if(L)
		for(var/i = L.len; i >= 1; i--)
			output += L[i]
	return output

//Randomize: Return the list in a random order
/proc/shuffle(list/L, ref) //Reference override for indexed lists.
	if(L)
		var/L_n[] = new
		. = L_n
		var/L_o[] = L.Copy()
		var/i
		while(L_o.len)
			i = pick(L_o)
			if(!ref) L_n += i
			else L_n[i] = L_o[i]
			L_o -= i

//Return a list with no duplicate entries
/proc/uniquelist(list/L)
	var/list/K = list()
	for(var/item in L)
		if(!(item in K))
			K += item
	return K

//Mergesort: divides up the list into halves to begin the sort
/proc/sortKey(list/client/L, order = 1)
	if(isnull(L) || L.len < 2)
		return L
	var/middle = L.len / 2 + 1
	return mergeKey(sortKey(L.Copy(0,middle)), sortKey(L.Copy(middle)), order)

//Mergsort: does the actual sorting and returns the results back to sortAtom
/proc/mergeKey(list/client/L, list/client/R, order = 1)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	while(Li <= L.len && Ri <= R.len)
		var/client/rL = L[Li]
		var/client/rR = R[Ri]
		if(sorttext(rL.ckey, rR.ckey) == order)
			result += L[Li++]
		else
			result += R[Ri++]

	if(Li <= L.len)
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))

// Quicksort implementation
/proc/sortAtom(list/atom/L, order = 1)
	if(isnull(L) || L.len < 2)
		return L
	var/startIndex = 1
	var/list/atom/M = new/list()
	for(var/atom/mob in L)
		if(istype(mob))
			M.Add(mob)
	var/endIndex = M.len - 1
	var/top = 0
	var/list/stack[endIndex*2]
	stack[++top] = startIndex
	stack[++top] = endIndex

	while(top >= 1)
		endIndex = stack[top--]
		startIndex = stack[top--]

		// BEGIN PARTITION CODE
		var/i = startIndex-1

		for(var/j = startIndex, j < endIndex, ++j)
			var/sort_res = sorttextEx(M[j].name, M[endIndex].name)
			if(sort_res == order)
				++i
				M.Swap(i,j)

		++i
		M.Swap(i,endIndex)
		// END PARTITION CODE
		// i is acting as the partition variable.

		if(i > startIndex)
			stack[++top] = startIndex
			stack[++top] = i-1
		if(i < endIndex)
			stack[++top] = i+1
			stack[++top] = endIndex
	return M




//Mergesort: Specifically for record datums in a list.
/proc/sortRecord(list/datum/data/record/L, field = "name", order = 1)
	if(isnull(L))
		return list()
	if(L.len < 2)
		return L
	var/middle = L.len / 2 + 1
	return mergeRecordLists(sortRecord(L.Copy(0, middle), field, order), sortRecord(L.Copy(middle), field, order), field, order)

//Mergsort: does the actual sorting and returns the results back to sortRecord
/proc/mergeRecordLists(list/datum/data/record/L, list/datum/data/record/R, field = "name", order = 1)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	if(!isnull(L) && !isnull(R))
		while(Li <= L.len && Ri <= R.len)
			var/datum/data/record/rL = L[Li]
			if(isnull(rL))
				L -= rL
				continue
			var/datum/data/record/rR = R[Ri]
			if(isnull(rR))
				R -= rR
				continue
			if(sorttext(rL.fields[field], rR.fields[field]) == order)
				result += L[Li++]
			else
				result += R[Ri++]

		if(Li <= L.len)
			return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))

/*
 * Get a list of successive items from start to end
 */
/proc/init_list_range(end, start=1)
	var/list/res = list()
	for(var/i in start to end)
		res += i
	return res

//Mergesort: any value in a list
// /!\ doesnt seem to work for assoc lists. use sort_list instead
/proc/sortList(list/L)
	RETURN_TYPE(/list)
	if(!istype(L))
		return
	if(L.len < 2)
		return L
	var/middle = L.len / 2 + 1 // Copy is first,second-1
	return mergeLists(sortList(L.Copy(0,middle)), sortList(L.Copy(middle))) //second parameter null = to end of list

//Mergsorge: uses sortList() but uses the var's name specifically. This should probably be using mergeAtom() instead
/proc/sortNames(list/L)
	var/list/Q = new()
	for(var/atom/x in L)
		Q[x.name] = x
	return sortList(Q)

/proc/mergeLists(list/L, list/R)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	while(Li <= L.len && Ri <= R.len)
		if(sorttext(L[Li], R[Ri]) < 1)
			result += R[Ri++]
		else
			result += L[Li++]

	if(Li <= L.len)
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))

/// Sums values in two associative lists, from mergee into result, in place
/proc/mergeListsSum(list/result, list/mergee)
	for(var/key as anything in mergee)
		if(result[key] == null)
			result[key] = 0
		result[key] += mergee[key]
	return result


// List of lists, sorts by element[key] - for things like crew monitoring computer sorting records by name.
/proc/sortByKey(list/L, key)
	if(L.len < 2)
		return L
	var/middle = L.len / 2 + 1
	return mergeKeyedLists(sortByKey(L.Copy(0, middle), key), sortByKey(L.Copy(middle), key), key)

/proc/mergeKeyedLists(list/L, list/R, key)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	while(Li <= L.len && Ri <= R.len)
		if(sorttext(L[Li][key], R[Ri][key]) < 1)
			// Works around list += list2 merging lists; it's not pretty but it works
			result += "temp item"
			result[result.len] = R[Ri++]
		else
			result += "temp item"
			result[result.len] = L[Li++]

	if(Li <= L.len)
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))


//Mergesort: any value in a list, preserves key=value structure
/proc/sortAssoc(list/L)
	if(L.len < 2)
		return L
	var/middle = L.len / 2 + 1 // Copy is first,second-1
	return mergeAssoc(sortAssoc(L.Copy(0,middle)), sortAssoc(L.Copy(middle))) //second parameter null = to end of list

/proc/mergeAssoc(list/L, list/R)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	while(Li <= L.len && Ri <= R.len)
		if(sorttext(L[Li], R[Ri]) < 1)
			result += R&R[Ri++]
		else
			result += L&L[Li++]

	if(Li <= L.len)
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))

// Same as sortAssoc but rather than creating a whole new list keeps the original list ref and just returns that list modified
/proc/sortAssocKeepList(list/L)
	if(L.len < 2)
		return L
	var/middle = L.len / 2 + 1 // Copy is first,second-1
	return mergeAssocKeepList(sortAssoc(L.Copy(0,middle)), sortAssoc(L.Copy(middle)), L) //second parameter null = to end of list

/proc/mergeAssocKeepList(list/L, list/R, list/original)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	while(Li <= L.len && Ri <= R.len)
		if(sorttext(L[Li], R[Ri]) < 1)
			result += R&R[Ri++]
		else
			result += L&L[Li++]

	if(Li <= L.len)
		result += L.Copy(Li, 0)
	else
		result += R.Copy(Ri, 0)
	original.Cut()
	original += result
	return original

/// Returns a list of atoms sorted by each entry's distance to `target`.
/proc/sort_list_dist(list/atom/list_to_sort, atom/target)
	var/list/distances = list()
	for(var/atom/A as anything in list_to_sort)
		// Just in case this happens anyway.
		if(!istype(A))
			stack_trace("sort_list_dist() was called with a list containing a non-atom object. ([A.type])")
			return list_to_sort

		distances[A] = get_dist_sqrd(A, target)

	return sortTim(distances, GLOBAL_PROC_REF(cmp_numeric_asc), TRUE)

//Converts a bitfield to a list of numbers (or words if a wordlist is provided)
/proc/bitfield2list(bitfield = 0, list/wordlist)
	var/list/r = list()
	if(islist(wordlist))
		var/max = min(wordlist.len,16)
		var/bit = 1
		for(var/i=1, i<=max, i++)
			if(bitfield & bit)
				r += wordlist[i]
			bit = bit << 1
	else
		for(var/bit=1, bit<=65535, bit = bit << 1)
			if(bitfield & bit)
				r += bit

	return r

/proc/count_by_type(list/L, type)
	var/i = 0
	for(var/T in L)
		if(istype(T, type))
			i++
	return i

//Move a single element from position fromIndex within a list, to position toIndex
//All elements in the range [1,toIndex) before the move will be before the pivot afterwards
//All elements in the range [toIndex, L.len+1) before the move will be after the pivot afterwards
//In other words, it's as if the range [fromIndex,toIndex) have been rotated using a <<< operation common to other languages.
//fromIndex and toIndex must be in the range [1,L.len+1]
//This will preserve associations ~Carnie
/proc/moveElement(list/L, fromIndex, toIndex)
	if(fromIndex == toIndex || fromIndex+1 == toIndex) //no need to move
		return
	if(fromIndex > toIndex)
		++fromIndex //since a null will be inserted before fromIndex, the index needs to be nudged right by one

	L.Insert(toIndex, null)
	L.Swap(fromIndex, toIndex)
	L.Cut(fromIndex, fromIndex+1)

//Move elements [fromIndex,fromIndex+len) to [toIndex-len, toIndex)
//Same as moveElement but for ranges of elements
//This will preserve associations ~Carnie
/proc/moveRange(list/L, fromIndex, toIndex, len=1)
	var/distance = abs(toIndex - fromIndex)
	if(len >= distance) //there are more elements to be moved than the distance to be moved. Therefore the same result can be achieved (with fewer operations) by moving elements between where we are and where we are going. The result being, our range we are moving is shifted left or right by dist elements
		if(fromIndex <= toIndex)
			return //no need to move
		fromIndex += len //we want to shift left instead of right

		for(var/i=0, i<distance, ++i)
			L.Insert(fromIndex, null)
			L.Swap(fromIndex, toIndex)
			L.Cut(toIndex, toIndex+1)
	else
		if(fromIndex > toIndex)
			fromIndex += len

		for(var/i=0, i<len, ++i)
			L.Insert(toIndex, null)
			L.Swap(fromIndex, toIndex)
			L.Cut(fromIndex, fromIndex+1)

//Move elements from [fromIndex, fromIndex+len) to [toIndex, toIndex+len)
//Move any elements being overwritten by the move to the now-empty elements, preserving order
//Note: if the two ranges overlap, only the destination order will be preserved fully, since some elements will be within both ranges ~Carnie
/proc/swapRange(list/L, fromIndex, toIndex, len=1)
	var/distance = abs(toIndex - fromIndex)
	if(len > distance) //there is an overlap, therefore swapping each element will require more swaps than inserting new elements
		if(fromIndex < toIndex)
			toIndex += len
		else
			fromIndex += len

		for(var/i=0, i<distance, ++i)
			L.Insert(fromIndex, null)
			L.Swap(fromIndex, toIndex)
			L.Cut(toIndex, toIndex+1)
	else
		if(toIndex > fromIndex)
			var/a = toIndex
			toIndex = fromIndex
			fromIndex = a

		for(var/i=0, i<len, ++i)
			L.Swap(fromIndex++, toIndex++)

//replaces reverseList ~Carnie
/proc/reverseRange(list/L, start=1, end=0)
	if(L.len)
		start = start % L.len
		end = end % (L.len+1)
		if(start <= 0)
			start += L.len
		if(end <= 0)
			end += L.len + 1

		--end
		while(start < end)
			L.Swap(start++,end--)

	return L

//creates every subtype of prototype (excluding prototype) and adds it to list L.
//if no list/L is provided, one is created.
/proc/init_subtypes(prototype, list/L)
	if(!istype(L))
		L = list()
	for(var/path in subtypesof(prototype))
		L += new path()
	return L

///replaces reverseList ~Carnie
/proc/reverse_range(list/inserted_list, start = 1, end = 0)
	if(inserted_list.len)
		start = start % inserted_list.len
		end = end % (inserted_list.len + 1)
		if(start <= 0)
			start += inserted_list.len
		if(end <= 0)
			end += inserted_list.len + 1

		--end
		while(start < end)
			inserted_list.Swap(start++, end--)

	return inserted_list

//Copies a list, and all lists inside it recusively
//Does not copy any other reference type
/proc/deep_copy_list(list/L)
	if(!islist(L))
		return L
	. = L.Copy()
	for(var/i in 1 to length(L))
		var/key = .[i]
		if(isnum(key))
			// numbers cannot ever be associative keys
			continue
		var/value = .[key]
		if(islist(value))
			value = deep_copy_list(value)
			.[key] = value
		if(islist(key))
			key = deep_copy_list(key)
			.[i] = key
			.[key] = value

/proc/copyListList(list/list/L)
	var/list/list/newList = list()
	for(var/i in L)
		if(isnum(i))
			newList += i
			continue

		var/temp_key = i
		var/temp_value = LAZYACCESS(L, i)
		if(islist(i))
			var/list/i_two = i
			temp_key = i_two.Copy()
		if(islist(L[i]))
			temp_value = L[i].Copy()

		newList[temp_key] = temp_value
	return newList

/atom/proc/contents_recursive()
	var/list/found = list()
	for(var/atom/A in contents)
		found += A
		if(A.contents.len)
			found += A.contents_recursive()
	return found

/atom/proc/contents_twice() // easier version of recursive proc, if we want to check people and items on them
	var/list/found = list()
	for(var/atom/A in contents)
		found += A
		if(A.contents.len)
			found += A.contents
	return found

// Mergesorts a list, using the sort callback to determine ordering
/proc/custom_mergesort(list/L, datum/callback/sort)
	if(!L)
		return L

	if(!sort)
		return L

	if(L.len <= 1)
		return L

	var/middle = floor(L.len / 2)
	var/list/left = custom_mergesort(L.Copy(1, middle + 1))
	var/list/right = custom_mergesort(L.Copy(middle + 1))
	var/list/result = list()

	while(left.len > 0 && right.len > 0)
		var/a = left[1]
		var/b = right[1]

		if(sort.Invoke(a, b))
			result += a
			left.Cut(1,2)
		else
			result += b
			right.Cut(1,2)

	while(left.len > 0)
		result += left[1]
		left.Cut(1,2)

	while(right.len > 0)
		result += right[1]
		right.Cut(1,2)

	return result

/proc/typecache_filter_list_reverse(list/atoms, list/typecache)
	RETURN_TYPE(/list)
	. = list()
	for(var/thing in atoms)
		var/atom/A = thing
		if(!typecache[A.type])
			. += A

//Checks for specific types in specifically structured (Assoc "type" = TRUE) lists ('typecaches')
#define is_type_in_typecache(A, L) (A && length(L) && L[(ispath(A) ? A : A:type)])
