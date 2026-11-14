// This is where the fun begins.
// These are the main datums that emit light.

/datum/dynamic_light_source
	///source atom that we belong to
	var/atom/source_atom
	///The atom that the source atom is contained inside
	var/atom/movable/contained_atom
	///our last loc
	var/atom/cached_loc
	//the turf where cached loc was
	var/turf/source_turf
	///the turf the contained atom appears to be covering
	var/turf/pixel_turf
	/// Intensity of the emitter light.
	var/light_power = 0
	/// The range of the emitted light.
	var/light_range = 0
	/// The light_range to use when toggling back on (will be null if already on)
	VAR_PRIVATE/enabled_light_range = null
	/// The colour of the light, string, decomposed by PARSE_LIGHT_COLOR()
	var/light_color = NONSENSICAL_VALUE

	/// Whether we have applied our light yet or not.
	var/applied = FALSE

	///typepath for the mask type we are using
	var/mask_type
	///reference to the mask holder effect
	var/obj/effect/lighting_mask_holder/mask_holder
	///reference to the mask contained within the mask_holder objects vis_contents
	var/atom/movable/lighting_mask/our_mask

/datum/dynamic_light_source/New(atom/movable/owner, mask_type = /atom/movable/lighting_mask)
	source_atom = owner // Set our new owner.
	LAZYADD(source_atom.hybrid_light_sources, src)

	//Find the atom that contains us
	find_containing_atom()

	source_turf = get_turf(source_atom)

	src.mask_type = mask_type
	mask_holder = new(source_turf)
	our_mask = new mask_type
	mask_holder.assign_mask(our_mask)
	our_mask.attached_atom = owner

	//Set light vars
	set_light(owner.light_range, owner.light_power, owner.light_color)

	//Calculate shadows
	our_mask.queue_mask_update()

	//Set direction
	our_mask.rotate_mask_on_holder_turn(contained_atom.dir)
	RegisterSignal(contained_atom, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_dir_change))
	RegisterSignal(contained_atom, COMSIG_ATOM_SET_LIGHT_RANGE, PROC_REF(set_range))
	RegisterSignal(contained_atom, COMSIG_ATOM_SET_LIGHT_POWER, PROC_REF(set_power))
	RegisterSignal(contained_atom, COMSIG_ATOM_SET_LIGHT_COLOR, PROC_REF(set_color))
	RegisterSignal(contained_atom, COMSIG_ATOM_SET_LIGHT_ON, PROC_REF(on_toggle))

/datum/dynamic_light_source/Destroy(force)
	//Remove references to ourself.
	LAZYREMOVE(source_atom?.hybrid_light_sources, src)
	LAZYREMOVE(contained_atom?.hybrid_light_sources, src)
	QDEL_NULL(mask_holder)
	our_mask = null//deletion handled on holder
	return ..()

///Updates containing atom
/datum/dynamic_light_source/proc/find_containing_atom()
	//Remove ourselves from the old containing atoms light sources
	if(contained_atom && contained_atom != source_atom)
		LAZYREMOVE(contained_atom.hybrid_light_sources, src)
	//Find our new container
	if(isturf(source_atom) || isarea(source_atom))
		contained_atom = source_atom
		return
	contained_atom = source_atom.loc
	for(var/sanity in 1 to 20)
		if(!contained_atom)
			//Welcome to nullspace my friend.
			contained_atom = source_atom
			return
		if(isturf(contained_atom.loc))
			break
		contained_atom = contained_atom.loc
	//Add ourselves to their light sources
	if(contained_atom != source_atom)
		LAZYADD(contained_atom.hybrid_light_sources, src)

///Update light if changed.
/datum/dynamic_light_source/proc/set_light(l_range, l_power, l_color = NONSENSICAL_VALUE)
	if(!our_mask)
		return
	if(l_range && l_range != light_range)
		light_range = l_range
		our_mask.set_radius(l_range)
		enabled_light_range = null
		source_atom?.light_on = TRUE
	if(l_power && l_power != light_power)
		light_power = l_power
		our_mask.set_intensity(l_power)
	if(l_color != NONSENSICAL_VALUE && l_color != light_color)
		light_color = l_color
		our_mask.set_color(l_color)

/datum/dynamic_light_source/proc/update_position()
	mask_holder.forceMove(get_turf(source_atom))
	find_containing_atom()

	var/move_delay = 5 DECISECONDS
	if(ismob(source_atom))
		var/mob/source_mob = source_atom
		move_delay = source_mob.move_delay
	else if(istype(source_atom, /obj/vehicle))
		var/obj/vehicle/source_vehicle = source_atom
		move_delay = source_vehicle.move_delay

	mask_holder.held_mask.pixel_x = 0
	mask_holder.held_mask.pixel_y = 0
	switch(source_atom.dir)
		if(EAST)
			mask_holder.held_mask.pixel_x -= world.icon_size
		if(WEST)
			mask_holder.held_mask.pixel_x += world.icon_size
		if(SOUTH)
			mask_holder.held_mask.pixel_y += world.icon_size
		if(NORTH)
			mask_holder.held_mask.pixel_y -= world.icon_size

	animate(mask_holder.held_mask, pixel_x = 0, pixel_y = 0, time = move_delay)

///SIGNAL_HANDLER for COMSIG_ATOM_DIR_CHANGE
/datum/dynamic_light_source/proc/on_dir_change(atom/source, olddir, newdir)
	SIGNAL_HANDLER
	if(!our_mask)
		return
	if(contained_atom.dir == newdir)
		return
	our_mask.rotate_mask_on_holder_turn(newdir)

///Changes the range which the light reaches. 0 means no light
/datum/dynamic_light_source/proc/set_range(atom/source, new_range)
	SIGNAL_HANDLER
	if(!our_mask)
		return
	if(light_range == new_range)
		return
	if(new_range == 0)
		turn_off()
	source_atom?.light_on = !!new_range
	light_range = new_range
	our_mask.set_radius(new_range)

///Changes the intensity/brightness of the light by altering the visual object's alpha.
/datum/dynamic_light_source/proc/set_power(atom/source, new_power)
	SIGNAL_HANDLER
	if(!our_mask)
		return
	if(light_power == new_power)
		return
	light_power = new_power
	our_mask.set_intensity(new_power)

///Changes the light's color, pretty straightforward.
/datum/dynamic_light_source/proc/set_color(atom/source, new_color)
	SIGNAL_HANDLER
	if(!our_mask)
		return
	if(new_color == NONSENSICAL_VALUE || light_color == new_color)
		return
	light_color = new_color
	our_mask.set_color(new_color)

///Toggles the light on and off (only alters opacity).
/datum/dynamic_light_source/proc/on_toggle(atom/source, new_value)
	SIGNAL_HANDLER
	if(new_value) //Truthy value input, turn on.
		turn_on()
		return
	turn_off() //Falsey value, turn off.

///Toggles the light on (only alters range).
/datum/dynamic_light_source/proc/turn_on()
	if(!isnull(enabled_light_range))
		set_range(new_range=enabled_light_range)
		enabled_light_range = null

///Toggles the light off (only alters opacity).
/datum/dynamic_light_source/proc/turn_off()
	if(isnull(enabled_light_range))
		enabled_light_range = light_range
		set_range(new_range = 0)
