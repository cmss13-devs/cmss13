/// If we should allow a connection, despite what the codebase may allow.
/// Many codebases do not allow Guest connections, which would prevent SS13Hub
/// users from being able to connect. If Guest connections are not banned, we shouldn't
/// intercept here - they may have banned this Guest account for genuine reasons.
/// We only intercept if a Guest would be prevented from joining, everything else
/// should be handled by the codebase.
/datum/ss13lib/proc/handle_banned(key, address, computer_id)
	if(is_guest(key) && SS13LIB_GUESTS_BANNED)
		return FALSE

	// This user is either not a Guest and should be handled by the usual /world/IsBanned,
	// or is a Guest and guests are not banned, and still should be handled by the usual /world/IsBanned
	return null

/// If a specified **key** is a Guest account
/datum/ss13lib/proc/is_guest(key)
	var/static/regex/guest_regex
	if(!guest_regex)
		guest_regex = regex(@"^Guest-\d+$")

	if(guest_regex.Find(key))
		return TRUE

	return FALSE
