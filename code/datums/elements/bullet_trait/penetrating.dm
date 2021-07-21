/datum/element/bullet_trait_penetrating
	// Generic bullet trait vars
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 2

	/// The distance loss per hit
	var/distance_loss_per_hit = 3

/datum/element/bullet_trait_penetrating/Attach(datum/target, var/distance_loss_per_hit = 3)
	. = ..()
	if(!istype(target, /obj/item/projectile))
		return ELEMENT_INCOMPATIBLE

	src.distance_loss_per_hit = distance_loss_per_hit

	RegisterSignal(target, COMSIG_BULLET_POST_HANDLE_TURF, .proc/handle_passthrough_turf, override = TRUE)
	RegisterSignal(target, list(
		COMSIG_BULLET_POST_HANDLE_MOB,
		COMSIG_BULLET_POST_HANDLE_OBJ
	), .proc/handle_passthrough_movables, override = TRUE)

/datum/element/bullet_trait_penetrating/Detach(datum/target)
	UnregisterSignal(target, list(
		COMSIG_BULLET_POST_HANDLE_TURF,
		COMSIG_BULLET_POST_HANDLE_MOB,
		COMSIG_BULLET_POST_HANDLE_OBJ
	))
	return ..()

/datum/element/bullet_trait_penetrating/proc/handle_passthrough_movables(var/obj/item/projectile/P, var/atom/movable/A, var/did_hit)
	SIGNAL_HANDLER
	if(did_hit)
		P.distance_travelled += distance_loss_per_hit
	return COMPONENT_BULLET_PASS_THROUGH

/datum/element/bullet_trait_penetrating/proc/handle_passthrough_turf(var/obj/item/projectile/P, var/turf/closed/wall/T)
	SIGNAL_HANDLER
	P.distance_travelled += distance_loss_per_hit

	if(!istype(T))
		return COMPONENT_BULLET_PASS_THROUGH

	if(!T.hull)
		return COMPONENT_BULLET_PASS_THROUGH
