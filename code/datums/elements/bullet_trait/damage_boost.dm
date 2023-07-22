GLOBAL_LIST_INIT(damage_boost_turfs, typecacheof(/turf))

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

	//vars for dealing with interaction issues with the Penetrating trait
	var/boosted_hits
	var/last_damage_mult

	//allows for nuance in Breaching-Resistant interactions
	var/active_damage_mult
	var/atom_type

	//var for dealing with bonus projectiles
	var/bonus_projectile_check

/**
 * vars:
 * * damage_mult - the damage multiplier to be applied if the bullet hits an atom whose type is in `breaching_objs`
 * * damage_boosted_atoms - a typecache of objs that can be breached; should be a global list because the element is bespoke
 */
/datum/element/bullet_trait_damage_boost/Attach(datum/target, damage_mult, list/damage_boosted_atoms)
	. = ..()
	if(!istype(target, /obj/item/projectile))
		return ELEMENT_INCOMPATIBLE

	src.damage_mult = damage_mult
	src.damage_boosted_atoms = damage_boosted_atoms
	src.boosted_hits = 0
	src.last_damage_mult = 1
	src.active_damage_mult = 1
	src.atom_type = 0
	src.bonus_projectile_check = 0

	RegisterSignal(target, list(
		COMSIG_BULLET_PRE_HANDLE_OBJ,
		COMSIG_BULLET_PRE_HANDLE_TURF,
		COMSIG_BULLET_PRE_HANDLE_MOB,
	), PROC_REF(handle_bullet))

/datum/element/bullet_trait_damage_boost/proc/check_type(atom/A)
	if(istype(A, /obj/structure/machinery/door)) return "door"
	//add more cases for other interactions (switch doesn't seem to work with istype)
	else return 0

/datum/element/bullet_trait_damage_boost/proc/handle_bullet(obj/item/projectile/P, atom/A)
	SIGNAL_HANDLER

	atom_type = check_type(A)

	switch(atom_type)
		if("door")
			var/obj/structure/machinery/door/D = A
			if(D.masterkey_resist)
				if(D.masterkey_mod)
					active_damage_mult = damage_mult * D.masterkey_mod
				else
					active_damage_mult = 1 //no bonus damage
			else
				active_damage_mult = damage_mult
		//add more cases for other interactions
		else
			active_damage_mult = damage_mult

	if(boosted_hits > 0)
		if(bonus_projectile_check == P.damage)
			P.damage = P.damage / last_damage_mult
		boosted_hits--
	if(damage_boosted_atoms[A.type])
		P.damage = round(P.damage * active_damage_mult)
		last_damage_mult = active_damage_mult
		boosted_hits++
		bonus_projectile_check = P.damage
