/// If we should allow a connection, despite what the codebase may allow.
/// Many codebases do not allow Guest connections, which would prevent SS13Hub
/// users from being able to connect. If we've already handled them, don't
/// intercept here, as we check later in the authentication flow to see if they
/// should be allowed to join if they fail to authenticate with us
/datum/ss13lib/proc/handle_banned(key, address, computer_id)
	if(is_guest(key) && !(key in isbanned_hook_ignore))
		return FALSE

	// This user is either not a Guest and should be handled by the usual /world/IsBanned,
	// or is a Guest and has failed to authenticate with us, so should be handled by /world/IsBanned
	return null

/// If a specified **key** is a Guest account
/datum/ss13lib/proc/is_guest(key)
	var/static/regex/guest_regex
	if(!guest_regex)
		guest_regex = regex(@"^Guest-\d+$")

	if(guest_regex.Find(key))
		return TRUE

	return FALSE
