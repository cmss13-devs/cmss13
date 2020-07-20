// Helper to make sure that flag groups (which are lists) are properly expanded
/proc/SETUP_LIST_FLAGS(...)
    var/list/flags = list()

    for (var/E in args)
        if (islist(E))
            flags |= E
        else
            flags |= list(E)
    
    return flags

// Assumes the first argument is a list
/proc/LIST_FLAGS_COMPARE(...)
    if (length(args) <= 1)
        return TRUE

    var/first = FALSE
    var/list/common
    for (var/E in args)
        if (!first)
            if (isnull(E))
                continue
            else if (islist(E))
                common = E
            else
                common = list(E)
            first = TRUE
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
    var/first = FALSE
    for (var/E in args)
        if (!first)
            if (!islist(E))
                CRASH("Tried to remove flags from a nonlist")
                return
            ret = E
            first = TRUE
            continue
        ret -= E
    return ret