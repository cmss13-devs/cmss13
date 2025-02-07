/datum/element/bullet_trait_penetrating/guided_rocket
	// Generic bullet trait vars
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 2

	/// The distance loss per hit
	distance_loss_per_hit = 0

/datum/element/bullet_trait_penetrating/guided_rocket/Attach(datum/target, distance_loss_per_hit = 0)
	. = ..()
	if(!istype(target, /obj/projectile))
		return ELEMENT_INCOMPATIBLE

	src.distance_loss_per_hit = distance_loss_per_hit

	RegisterSignal(target, COMSIG_BULLET_POST_HANDLE_TURF, PROC_REF(handle_passthrough_turf), override = TRUE)
	RegisterSignal(target, list(
		COMSIG_BULLET_POST_HANDLE_MOB,
		COMSIG_BULLET_POST_HANDLE_OBJ
	), PROC_REF(handle_passthrough_movables), override = TRUE)

/datum/element/bullet_trait_penetrating/guided_rocket/Detach(datum/target)
	UnregisterSignal(target, list(
		COMSIG_BULLET_POST_HANDLE_TURF,
		COMSIG_BULLET_POST_HANDLE_MOB,
		COMSIG_BULLET_POST_HANDLE_OBJ
	))
	return ..()

