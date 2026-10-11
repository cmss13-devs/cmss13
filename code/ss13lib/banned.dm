/// If we should allow a connection, despite what the codebase may allow.
/// Many codebases do not allow Guest connections, which would prevent SS13Hub
/// users from being able to connect. If we've already handled them, don't
/// intercept here, as we check later in the authentication flow to see if they
/// should be allowed to join if they fail to authenticate with us
/datum/ss13lib/proc/handle_banned(key, address, computer_id)
	SS13LIB_INFO_LOG("handle_banned: key=[key] address=[address]")

	// A Guest that has failed to authenticate with us, so should be handled by /world/IsBanned
	if(key in isbanned_hook_ignore)
		SS13LIB_INFO_LOG("Passing [key] through to codebase IsBanned (already screened by SS13Hub).")
		isbanned_hook_ignore -= key
		return null

	if(is_guest(key))
		SS13LIB_INFO_LOG("Allowing guest [key] through IsBanned (pending SS13Hub authentication).")
		return FALSE

	// This user is not a Guest and should be handled by the usual /world/IsBanned. That includes
	// SS13Hub keys, codebases also call IsBanned for offline checks (e.g. connection history), so
	// BYOND users using the hub suffix are turned away in handle_client() instead.
	return null

/// When we send a Guest that we've already screened (and they have failed to authenticate)
/// we just send them back into world.IsBanned() to determine if they should exit or not
/datum/ss13lib/var/isbanned_hook_ignore = list()

/datum/ss13lib/proc/has_hub_suffix(key)
	return findtext(key, SS13LIB_CKEY_SUFFIX, -length(SS13LIB_CKEY_SUFFIX))

/datum/ss13lib/proc/reject_hub_suffix(client/new_client)
	if(!has_hub_suffix(new_client.key))
		return FALSE
	SS13LIB_WARNING_LOG("Rejecting [new_client.key]: BYOND user using reserved SS13Hub suffix.")
	new_client << "This key is reserved for SS13Hub accounts. Please use a different BYOND key, or join through the SS13 launcher."
	del(new_client)
	return TRUE

/// If a specified **key** is a Guest account
/datum/ss13lib/proc/is_guest(key)
	var/static/regex/guest_regex
	if(!guest_regex)
		guest_regex = regex(@"^Guest-\d+$")

	if(guest_regex.Find(key))
		return TRUE

	return FALSE
