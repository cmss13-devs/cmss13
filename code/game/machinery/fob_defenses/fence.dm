GLOBAL_LIST_INIT(fence_recipes, list(
	new /datum/stack_recipe("electric fence", /obj/structure/fence/fob, 1, flags = RESULT_REQUIRES_LANDING_ZONE)
	))

#define STATE_ON "on"
#define STATE_OFF "off"

/obj/structure/fence/fob
	name = "\improper UE-02 Deployable Fence"
	desc = "A dark reinforced mesh grille with warning stripes, equipped with Tesla-like coils to regulate high voltage current. It is highly electrified and dangerous when powered."
	icon = 'icons/obj/structures/machinery/fob_machinery/electric_fence.dmi'
	icon_state = "fence0"
	basestate = "fence"
	throwpass = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	var/state = STATE_OFF

/obj/structure/fence/fob/Initialize(mapload, ...)
	. = ..()
	if(GLOB.transformer?.is_active())
		turn_on()

	AddComponent(/datum/component/fob_defense, CALLBACK(src, PROC_REF(turn_on)), CALLBACK(src, PROC_REF(turn_off)))

/obj/structure/fence/fob/proc/turn_off()
	if(state == STATE_ON)
		state = STATE_OFF
	update_icon()

/obj/structure/fence/fob/proc/turn_on()
	if(state == STATE_OFF)
		state = STATE_ON
	update_icon()

/obj/structure/fence/fob/update_icon()
	if(forms_junctions)
		. = ..()

	addtimer(CALLBACK(src, PROC_REF(do_update_icon)), 0.3 SECONDS) // As dumb as this is it is needed because the parent uses spawn

/obj/structure/fence/fob/proc/do_update_icon()
	if(cut)
		icon_state = "[basestate][junction]_broken"
		return

	if(state == STATE_ON)
		icon_state = "[basestate][junction]"
	else
		icon_state = "[basestate][junction]_off"

/obj/structure/fence/fob/hitby(atom/movable/AM)
	visible_message(SPAN_DANGER("[src] was hit by [AM]."))
	var/tforce = 0
	if(ismob(AM))
		if(state == STATE_ON)
			electrocute_mob(AM, get_area(src), src, 0.7, needs_power = FALSE)
			to_chat(AM, SPAN_DANGER("<B>You feel a powerful shock course through your body!</B>"))
		else
			tforce = 40
	health = max(0, health - tforce)
	healthcheck()

/obj/structure/fence/fob/attackby(obj/item/item, mob/user)
	if(HAS_TRAIT(item, TRAIT_TOOL_WIRECUTTERS))

		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			user.balloon_alert(user, "you do not know how to disassemble the [src.name].")
			return

		if(state == STATE_ON)
			user.balloon_alert(user, "you cannot disassemble the [src.name] while it is active.")

		if(!do_after(usr, 5 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
			return

		qdel(src)
		return

	if(state == STATE_ON)
		electrocute_mob(user, get_area(src), src, 0.7, needs_power = FALSE)
		to_chat(user, SPAN_DANGER("<B>You feel a powerful shock course through your body!</B>"))
		return
	. = ..()

/obj/structure/fence/fob/Collided(atom/movable/AM)
	if(!ismob(AM) || ishuman(AM))
		return
	var/mob/mob = AM
	if(state == STATE_ON)
		electrocute_mob(mob, get_area(src), src, 0.75, needs_power = FALSE)
		to_chat(mob, SPAN_DANGER("<B>You feel a powerful shock course through your body!</B>"))

/obj/structure/fence/fob/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(state == STATE_ON)
		electrocute_mob(xeno, get_area(src), src, 0.75, needs_power = FALSE)
		to_chat(xeno, SPAN_DANGER("<B>You feel a powerful shock course through your body!</B>"))
		return

	xeno.animation_attack_on(src)
	var/damage_dealt = 25
	xeno.visible_message(SPAN_DANGER("[xeno] mangles [src]!"),
	SPAN_DANGER("We mangle [src]!"),
	SPAN_DANGER("We hear twisting metal!"), 5, CHAT_TYPE_XENO_COMBAT)
	health -= damage_dealt
	healthcheck()
	return XENO_ATTACK_ACTION

/obj/structure/fence/fob/Destroy()
	new /obj/item/stack/fence(get_turf(src))

	. = ..()

/obj/item/stack/fence
	name = "folded electric fence"
	singular_name = "electric fence"
	icon = 'icons/obj/structures/machinery/fob_machinery/electric_fence.dmi'
	icon_state = "fence_stack"
	item_state = "fence_stack"
	w_class = SIZE_SMALL
	force = 2
	throwforce = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	max_amount = 10
	attack_verb = list("hit", "slapped", "whacked")
	stack_id = "electric fences"

/obj/item/stack/fence/Initialize(mapload, ...)
	. = ..()
	recipes = GLOB.fence_recipes

/obj/item/stack/fence/full
	amount = STACK_10

#undef STATE_ON
#undef STATE_OFF
