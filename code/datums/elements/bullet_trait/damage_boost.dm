GLOBAL_LIST_INIT(damage_boost_breaching, typecacheof(list(
	/turf,
	/obj/structure/machinery/door,
	/obj/structure/mineral_door,
	/obj/structure/window_frame,
	/obj/structure/girder,
	/obj/structure/surface,
	/obj/structure/window,
	/obj/structure/grille,
	/obj/structure/barricade,
)))

GLOBAL_LIST_INIT(damage_boost_pylons, typecacheof(/obj/effect/alien/resin/special/pylon))

/datum/element/bullet_trait_damage_boost
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 2

	var/damage_mult
	/// A typecache of objs or turfs that, upon being hit, boost the damage of the attached projectile
	var/list/damage_boosted_atoms

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

	RegisterSignal(target, list(
		COMSIG_BULLET_PRE_HANDLE_OBJ,
		COMSIG_BULLET_PRE_HANDLE_TURF,
	), .proc/handle_bullet)

/datum/element/bullet_trait_damage_boost/proc/handle_bullet(var/obj/item/projectile/P, var/atom/A)
	SIGNAL_HANDLER
	if(damage_boosted_atoms[A.type])
		P.damage = round(P.damage * damage_mult)
