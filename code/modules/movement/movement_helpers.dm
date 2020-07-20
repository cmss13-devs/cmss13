/proc/pass_flag_check(var/list/flags_pass, var/list/flags_can_pass)
    if (!length(flags_pass) || !length(flags_can_pass))
        return FALSE
    
    for (var/flag_pass in flags_pass)
		if (flag_pass in flags_can_pass)
			return TRUE
	return FALSE