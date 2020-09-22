// Helper to make sure that flag groups (which are lists) are properly expanded
/proc/SETUP_LIST_FLAGS(...)
    var/list/nested = list()
    var/list/flags = list()

    // Whether we need to check for any nested lists (ie one of the elements is a list)
    for (var/E in args)
        if (islist(E))
            nested |= E
        else
            flags |= list(E)
    
    var/depth = 1
    while (length(nested))
        if (depth > 10)
            log_debug("List flags reached a depth greater than 10")
            break
        var/list/temp = list()
        for (var/E in nested)
            if (islist(E))
                temp |= E
            else
                flags |= list(E)
        nested = temp
        depth++
    
    return flags

// Assumes the first argument is a list
/proc/LIST_FLAGS_COMPARE(...)
    if (length(args) <= 1)
        return TRUE

    var/first = TRUE
    var/list/common
    for (var/E in args)
        if (first)
            if (isnull(E))
                continue
            else if (islist(E))
                common = E
            else
                common = list(E)
            first = FALSE
            continue
        var/list/common_buf
        if (isnull(E))
            continue
        else if (islist(E))
            common_buf = common & E
        else if (E in common)
            common_buf = list(E)
        common = common_buf
        if (!length(common))
            break
    
    if (!length(common))
        return FALSE
    return TRUE

/proc/LIST_FLAGS_ADD(...)
    var/list/ret = list()
    for (var/E in args)
        if (isnull(E))
            continue
        else if (islist(E))
            ret |= E
        else
            ret |= list(E)
    return ret

// Assumes the first argument is a list
/proc/LIST_FLAGS_REMOVE(...)
    var/list/ret
    var/first = TRUE
    for (var/E in args)
        if (first)
            if (isnull(E))
                return list()
            if (!islist(E))
                CRASH("Tried to remove flags from a nonlist")
            var/list/L = E
            ret = L.Copy()
            first = FALSE
            continue
        ret -= E
    return ret