
//Simple items designed to realize a specific manual task (crowbar, scalpel, welding tool, etc)

/obj/item/tool
	var/list/tool_traits_init

/obj/item/tool/Initialize(mapload, ...)
	. = ..()
	if(!tool_traits_init)
		return
	for(var/T in tool_traits_init)
		ADD_TRAIT(src, T, TRAIT_SOURCE_TOOL)
