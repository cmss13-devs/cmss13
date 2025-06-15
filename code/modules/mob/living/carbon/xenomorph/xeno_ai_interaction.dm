/*

Just as a note, eventually it may be prudent to convert most of attack_alien() checks into two parts.

attack_alien() gets called as usual by normal sources but then immediately goes into:
Can we do the attack_alien(), probably like can_attack_alien() or some such
And then the usual attack_alien() effect

This way we can keep our obstacle checks up to date with any future attack_alien() changes by calling can_attack_alien()

Future problem for the time being and maybe not worth pursuing :shrug:

As a second note, please god follow the xeno_ai_obstacle chain to atom if possible, things like if(get_turf(src) == target) NEEDING to return 0 most times is very important.
At bare minimum, make sure the relevant checks from parent types gets copied in if you need to snowflake something.

*/// - Morrow


/////////////////////////////
//       MINERAL DOOR      //
/////////////////////////////
/obj/structure/mineral_door/xeno_ai_obstacle(mob/living/carbon/xenomorph/X, direction, turf/target)
	return DOOR_PENALTY

/obj/structure/mineral_door/resin/xeno_ai_obstacle(mob/living/carbon/xenomorph/xeno, direction, turf/target)
	if(xeno.hivenumber != hivenumber)
		return ..()
	return 0

/obj/structure/mineral_door/resin/xeno_ai_act(mob/living/carbon/xenomorph/acting_xeno)
	if(IS_SAME_HIVENUMBER(acting_xeno, src))
		acting_xeno.a_intent = INTENT_HELP
	. = ..()


/////////////////////////////
//        PLATFORMS        //
/////////////////////////////
/obj/structure/platform/xeno_ai_obstacle(mob/living/carbon/xenomorph/X, direction, turf/target)
	. = ..()
	if(!.)
		return

	return DOOR_PENALTY


/////////////////////////////
//         PODDDOORS       //
/////////////////////////////
/obj/structure/machinery/door/poddoor/xeno_ai_obstacle(mob/living/carbon/xenomorph/X, direction, turf/target)
	. = ..()
	if(!.)
		return INFINITY

	if(unacidable)
		return INFINITY

	if(!(stat & NOPOWER))
		return INFINITY

	return DOOR_PENALTY


/////////////////////////////
//         SHUTTERS        //
/////////////////////////////
/obj/structure/machinery/door/poddoor/shutters/xeno_ai_obstacle(mob/living/carbon/xenomorph/X, direction, turf/target)
	. = ..()
	if(!.)
		return INFINITY

	if(unacidable)
		return INFINITY

	return DOOR_PENALTY


/////////////////////////////
//         AIRLOCK         //
/////////////////////////////
/obj/structure/machinery/door/airlock/xeno_ai_obstacle(mob/living/carbon/xenomorph/X, direction, turf/target)
	. = ..()
	if(!.)
		return

	if(locked || welded || isElectrified())
		return LOCKED_DOOR_PENALTY

	if(isfacehugger(X))
		return -1 // We LOVE going under doors!

	return DOOR_PENALTY

////////////////////////////////////////
//         AIRLOCK ASSEMBLIES         //
////////////////////////////////////////

/obj/structure/airlock_assembly/xeno_ai_obstacle(mob/living/carbon/xenomorph/X, direction, turf/target)
	. = ..()
	if(!.)
		return

	if(isfacehugger(X))
		return -1 // We LOVE going under doors!

	return DOOR_PENALTY

/////////////////////////////
//         TABLES          //
/////////////////////////////
/obj/structure/surface/table/xeno_ai_obstacle(mob/living/carbon/xenomorph/X, direction, turf/target)
	. = ..()
	if(isfacehugger(X))
		return -1 // We also love to skiddle under the tables!

	return


/////////////////////////////
//          MOBS           //
/////////////////////////////
/mob/living/ai_check_stat(mob/living/carbon/xenomorph/X)
//	if(X.target_unconscious)
//		return TRUE
	return X.target_unconscious || stat == CONSCIOUS && !(locate(/datum/effects/crit) in effects_list)

/////////////////////////////
//         CARBON          //
/////////////////////////////
/mob/living/carbon/proc/ai_can_target(mob/living/carbon/xenomorph/X)
	if(!ai_check_stat(X))
		return FALSE

	if(X.can_not_harm(src))
		return FALSE

	if(alpha <= 45 && get_dist(X, src) > 2)
		return FALSE

	if(isfacehugger(X))
		if(status_flags & XENO_HOST)
			return FALSE

		if(istype(wear_mask, /obj/item/clothing/mask/facehugger))
			return FALSE

	else if(HAS_TRAIT(src, TRAIT_NESTED))
		return FALSE

	return TRUE

/////////////////////////////
//         HUMANS         //
/////////////////////////////
/mob/living/carbon/human/xeno_ai_obstacle(mob/living/carbon/xenomorph/X, direction, turf/target)
	if(status_flags & GODMODE)
		return ..()

	return HUMAN_PENALTY

/mob/living/carbon/human/xeno_ai_act(mob/living/carbon/xenomorph/X)
	if(status_flags & GODMODE)
		return

	if(X.can_not_harm(src))
		return // No nibbles for friendlies

	. = ..()

/mob/living/carbon/human/ai_can_target(mob/living/carbon/xenomorph/X)
	. = ..()

	if(species.flags & IS_SYNTHETIC)
		return FALSE

/mob/living/carbon/human/ai_check_stat(mob/living/carbon/xenomorph/X)
	. = ..()
	if(isfacehugger(X))
		return stat != DEAD


/////////////////////////////
//          XENOS          //
/////////////////////////////
/mob/living/carbon/xenomorph/xeno_ai_obstacle(mob/living/carbon/xenomorph/X, direction, turf/target)
	. = ..()
	if(!.)
		return

	if(!IS_SAME_HIVENUMBER(X, src))
		return HUMAN_PENALTY

	return XENO_PENALTY

/mob/living/carbon/xenomorph/xeno_ai_act(mob/living/carbon/xenomorph/X)
	if(X.can_not_harm(src))
		return

	. = ..()

/mob/living/carbon/xenomorph/ai_can_target(mob/living/carbon/xenomorph/X)
	. = ..()
	if(!.)
		return FALSE

	if(isfacehugger(X))
		return FALSE

	if(IS_SAME_HIVENUMBER(X, src))
		return FALSE

	return TRUE

/mob/living/carbon/xenomorph/ai_check_stat(mob/living/carbon/xenomorph/X)
	return stat != DEAD // Should slash enemy xenos, even if they are critted out


/////////////////////////////
//         VEHICLES        //
/////////////////////////////
/obj/vehicle/xeno_ai_obstacle(mob/living/carbon/xenomorph/X, direction, turf/target)
	. = ..()
	if(!.)
		return

	return VEHICLE_PENALTY


/////////////////////////////
//         SENTRY          //
/////////////////////////////
/obj/structure/machinery/defenses/xeno_ai_obstacle(mob/living/carbon/xenomorph/X, direction, turf/target)
	. = ..()
	if(!.)
		return

	return SENTRY_PENALTY

/////////////////////////////
//       STRUCTURE         //
/////////////////////////////
/obj/structure/xeno_ai_obstacle(mob/living/carbon/xenomorph/X, direction, turf/target)
	. = ..()
	if(!.)
		return

	if(!density)
		return 0

	if((unslashable || isfacehugger(X)) && !climbable)
		return

	return OBJECT_PENALTY

/obj/structure/machinery/xeno_ai_act(mob/living/carbon/xenomorph/X)
	if(stat & TIPPED_OVER)
		return

	return ..()

/// Allows this xenomorph to climb most structures that can be climbed, if they are capable of it.
/obj/structure/xeno_ai_act(mob/living/carbon/xenomorph/X)
	if(X.ai_movement_handler.do_climb_structures && can_climb(X))
		do_climb(X)
	else
		X.do_click(src, "", list())
	return TRUE

/////////////////////////////
//      WINDOW FRAME       //
/////////////////////////////
/obj/structure/window_frame/xeno_ai_obstacle(mob/living/carbon/xenomorph/X, direction, turf/target)
	if(X.claw_type == CLAW_TYPE_VERY_SHARP || (X.claw_type >= CLAW_TYPE_SHARP && !reinforced))
		return ..()
	return WINDOW_FRAME_PENALTY


/////////////////////////////
//       BARRICADES        //
/////////////////////////////
/obj/structure/barricade/xeno_ai_obstacle(mob/living/carbon/xenomorph/X, direction, turf/target)
	. = ..()
	if(!.)
		return

	return BARRICADE_PENALTY

/obj/structure/barricade/handrail/xeno_ai_obstacle(mob/living/carbon/xenomorph/X, direction, turf/target)
	. = ..()
	if(!.)
		return

	return DOOR_PENALTY


/////////////////////////////
//          FIRE           //
/////////////////////////////
/obj/flamer_fire/xeno_ai_obstacle(mob/living/carbon/xenomorph/xeno, direction, turf/target)
	if(xeno.caste?.fire_immunity & (FIRE_IMMUNITY_NO_IGNITE|FIRE_IMMUNITY_NO_DAMAGE))
		return 0

	return FIRE_PENALTY


/////////////////////////////
//          WALLS          //
/////////////////////////////
/turf/closed/wall/resin/xeno_ai_obstacle(mob/living/carbon/xenomorph/xeno, direction, turf/target)
	. = ..()
	if(!.)
		return

	return WALL_PENALTY


/////////////////////////////
//          FLOOR          //
/////////////////////////////
/*
	Sometimes open turfs are passed back as obstacles due to platforms and such,
	generally it's fast so very slight penalty mainly for handling subtypes properly
*/
/turf/open/xeno_ai_obstacle(mob/living/carbon/xenomorph/X, direction, turf/target)
	. = ..()
	if(!.)
		return

	return OPEN_TURF_PENALTY

/// For now there is no attack_alien() proc overrides on any child of /turf/open
/// Also, we don't want xenos swiping all around - forbit the clicking!
/turf/open/xeno_ai_act(mob/living/carbon/xenomorph/X)
	return FALSE

/// Space, do NOT path into space.
/turf/open/space/xeno_ai_obstacle(mob/living/carbon/xenomorph/X, direction, turf/target)
	. = ..()
	if(!.)
		return

	return INFINITY


/////////////////////////////
//          RIVER          //
/////////////////////////////
/turf/open/gm/river/xeno_ai_obstacle(mob/living/carbon/xenomorph/X, direction, turf/target)
	. = ..()
	if(. && !covered)
		. += base_river_slowdown

/turf/open/gm/river/desert/xeno_ai_obstacle(mob/living/carbon/xenomorph/X, direction, turf/target)
	if(toxic && !covered)
		return FIRE_PENALTY

	return ..()
