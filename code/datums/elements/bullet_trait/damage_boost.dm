GLOBAL_LIST_INIT(damage_boost_turfs, typecacheof(/turf))

GLOBAL_LIST_INIT(damage_boost_turfs_xeno, typecacheof(/turf/closed/wall/resin))

GLOBAL_LIST_INIT(damage_boost_breaching, typecacheof(list(
	/obj/structure/machinery/door,
	/obj/structure/mineral_door,
	/obj/structure/window_frame,
	/obj/structure/girder,
	/obj/structure/surface,
	/obj/structure/window,
	/obj/structure/grille,
	/obj/structure/barricade
)))

GLOBAL_LIST_INIT(damage_boost_pylons, typecacheof(list(
	/obj/effect/alien/resin/special/pylon,
	/obj/effect/alien/resin/special/cluster,
)))

GLOBAL_LIST_INIT(damage_boost_vehicles, typecacheof(/obj/vehicle/multitile))

/datum/element/bullet_trait_damage_boost
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 2

	var/damage_mult
	/// A typecache of objs or turfs that, upon being hit, boost the damage of the attached projectile
	var/list/damage_boosted_atoms

	//allows for nuance in Breaching-Resistant interactions
	var/active_damage_mult
	var/atom_type

/**
 * vars:
 * * damage_mult - the damage multiplier to be applied if the bullet hits an atom whose type is in `breaching_objs`
 * * damage_boosted_atoms - a typecache of objs that can be breached; should be a global list because the element is bespoke
 */
/datum/element/bullet_trait_damage_boost/Attach(datum/target, damage_mult, list/damage_boosted_atoms)
	. = ..()
	if(!istype(target, /obj/projectile))
		return ELEMENT_INCOMPATIBLE

	src.damage_mult = damage_mult
	src.damage_boosted_atoms = damage_boosted_atoms
	src.active_damage_mult = 1
	src.atom_type = 0

	RegisterSignal(target, list(
		COMSIG_BULLET_PRE_HANDLE_OBJ,
		COMSIG_BULLET_PRE_HANDLE_TURF,
		COMSIG_BULLET_PRE_HANDLE_MOB,
	), PROC_REF(handle_bullet))

/datum/element/bullet_trait_damage_boost/proc/check_type(atom/A)
	if(istype(A, /obj/structure/machinery/door)) return "door"
	//add more cases for other interactions (switch doesn't seem to work with istype)
	else return 0

/datum/element/bullet_trait_damage_boost/proc/handle_bullet(obj/projectile/boosted_projectile, atom/hit_atom)
	SIGNAL_HANDLER

	atom_type = check_type(hit_atom)

	switch(atom_type)
		if("door")
			var/obj/structure/machinery/door/hit_door = hit_atom
			if(hit_door.masterkey_resist)
				if(hit_door.masterkey_mod)
					active_damage_mult = damage_mult * hit_door.masterkey_mod
				else
					active_damage_mult = 1 //no bonus damage
			else
				active_damage_mult = damage_mult
		//add more cases for other interactions
		else
			active_damage_mult = damage_mult


	if(boosted_projectile.damage_boosted && ((boosted_projectile.last_atom_signaled?.resolve()) != hit_atom) && (!boosted_projectile.bonus_projectile_check))
	//If this is after a boosted hit, the last atom that procced this isn't the same as the current target, and this isn't a bonus projectile sharing the same damage_boost
		if(!boosted_projectile.last_damage_mult) //Make sure stored mult isn't 0
			boosted_projectile.last_damage_mult = 1

		boosted_projectile.damage = boosted_projectile.damage / boosted_projectile.last_damage_mult //Reduce the damage back to normal
		boosted_projectile.damage_boosted-- //Mark that damage has been returned to normal.

	if(damage_boosted_atoms[hit_atom.type]) //If hitting a valid atom for damage boost
		boosted_projectile.damage = floor(boosted_projectile.damage * active_damage_mult) //Modify Damage by multiplier

		if (active_damage_mult)
			boosted_projectile.last_damage_mult = active_damage_mult //Save multiplier for next check
		else
			boosted_projectile.last_damage_mult = 1

		boosted_projectile.damage_boosted++ //Mark that a boosted hit occurred.
		boosted_projectile.last_atom_signaled = WEAKREF(hit_atom) //Save the current triggering atom to the projectile
