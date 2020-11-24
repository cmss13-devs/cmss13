/datum/pass_flags_container
	var/flags_pass

	var/flags_can_pass_all // Use for objects that are not ON_BORDER or for general pass characteristics of an atom
	var/flags_can_pass_front // Relevant mainly for ON_BORDER atoms with the BlockedPassDirs() proc
	var/flags_can_pass_behind // Relevant mainly for ON_BORDER atoms with the BlockedExitDirs() proc
