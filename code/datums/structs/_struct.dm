/datum/struct
	var/name = "UNDEFINED"
	var/list/props
	/// The length of the lists to be generated
	/// which represent a struct
	var/len

	/// Standard list mapped 1:1 to the list produced when
	/// struct is created using STRUCT(...)
	var/list/can_qdel

/datum/struct/New()
	props = list()
	// First element of struct list is a string containing the struct name
	can_qdel = list(FALSE)
	STRUCTS.current_struct_idx = STRUCT_PROP_STARTING_INDEX
	add_props()
	// Index will go up by 1 when adding last element
	len = STRUCTS.current_struct_idx - 1

/datum/struct/proc/add_props()
	return

/datum/struct/proc/operator""()
	return "struct [name]([props.Join(", ")])"
