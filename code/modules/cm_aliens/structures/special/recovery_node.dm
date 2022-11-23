//Recovery Node - Heals xenomorphs around it

/obj/effect/alien/resin/special/recovery
	name = XENO_STRUCTURE_RECOVERY
	desc = "A warm, soothing light source that pulsates with a faint hum."
	icon_state = "recovery"
	health = 400
	var/desc_dat = "Recovers the health of adjacent Xenomorphs."
	var/heal_amount = 10
	var/heal_cooldown = 5 SECONDS
	var/last_healed
	var/heal_message_you = "You feel a warm aura envelop you."
	var/heal_message_others = " glows as a warm aura envelops them."

/obj/effect/alien/resin/special/recovery/get_examine_text(mob/user)
	. = ..()
	if((isXeno(user) || isobserver(user)) && linked_hive)
		. += desc_dat

/obj/effect/alien/resin/special/recovery/process()
	if(last_healed && world.time < last_healed + heal_cooldown)
		return
	var/list/heal_candidates = list()
	for(var/mob/living/carbon/Xenomorph/X in range(src, 1))
		if(X.health >= X.maxHealth || !X.resting || X.hivenumber != linked_hive.hivenumber)
			continue
		heal_candidates += X
	last_healed = world.time
	if(!heal_candidates.len)
		return
	var/mob/living/carbon/Xenomorph/picked_candidate = pick(heal_candidates)
	picked_candidate.visible_message(SPAN_HELPFUL("\The [picked_candidate][heal_message_others]"), \
				SPAN_HELPFUL("[heal_message_you]"))
	if(!do_after(picked_candidate, heal_cooldown, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
		return
	picked_candidate.gain_health(heal_amount)

GLOBAL_LIST_EMPTY_TYPED(living_knight_list, /mob/living/carbon/Xenomorph/Warrior)
GLOBAL_LIST_EMPTY_TYPED(existing_holdfast_list, /obj/effect/alien/resin/special/recovery/holdfast)

//rest of the code is at knight.dm

/obj/effect/alien/resin/special/recovery/holdfast
	name = XENO_STRUCTURE_HOLDFAST
	desc = "An eerie, frigid light source that pulsates with a faint hum."
	icon_state = "holdfast"
	all_breakable = TRUE
	desc_dat = "Strengthens the abilities of Knights and faintly heals anyone resting in its range."
	health = 450
	heal_amount = 3
	heal_cooldown = 6 SECONDS
	heal_message_you = "You feel an impassoniate, but dutiful aura envelop you."
	heal_message_others = " faintly glows as a white aura envelops them."
	COOLDOWN_DECLARE(noisy_fx) //7 SECONDS
	var/buff_fx_on = FALSE
	var/mob/living/carbon/Xenomorph/Warrior/bound_knight
	var/list/current_buffed_knights

/obj/effect/alien/resin/special/recovery/holdfast/Initialize(mapload, hive_ref)
	. = ..()
	GLOB.existing_holdfast_list += WEAKREF(src)
	//Send a signal to every Knight so they get the buff without having to move.
	for(var/datum/weakref/ref as anything in GLOB.living_knight_list)
		var/mob/living/carbon/Xenomorph/Warrior/list_Knight = ref.resolve()
		SEND_SIGNAL(list_Knight, COMSIG_HOLDFAST_NODE_PULSE)

/obj/effect/alien/resin/special/recovery/holdfast/Destroy(mapload, hive_ref)

	if(bound_knight)
		to_chat(bound_knight, SPAN_XENOHIGHDANGER("Your holdfast node breaks! You will have to wait to replace it."))
		var/datum/behavior_delegate/warrior_knight/bound_knight_delegate = bound_knight.behavior_delegate
		bound_knight_delegate.apply_node_cooldown()
		if(bound_knight_delegate.bound_node)
			bound_knight_delegate.bound_node = null

	//Send a signal to every Knight so their buffs are instantaneously removed if necessary.
	for(var/mob/living/carbon/Xenomorph/Warrior/buffed_Knight as anything in src.current_buffed_knights)
		SEND_SIGNAL(buffed_Knight, COMSIG_HOLDFAST_NODE_PULSE)

	bound_knight = null
	current_buffed_knights = null
	GLOB.existing_holdfast_list -= WEAKREF(src)
	. = ..()

/obj/effect/alien/resin/special/recovery/holdfast/proc/buff_fx()

	if(buff_fx_on == TRUE)
		return
	buff_fx_on = TRUE
	var/icolor = "#4ADBC1"
	var/ialpha = 30
	icolor += num2text(ialpha, 2, 16)
	add_filter("holdfast_buff", 1, list("type" = "outline", "color" = icolor, "size" = 2)) //we keep this one until the woyars all leave. NNED TO TEST THIS WITH MULTIPLE WYOERS. CHECK EVERYTIN FOR THA!

	if(COOLDOWN_FINISHED(src, noisy_fx))
		visible_message(SPAN_HELPFUL("\The [src] shines brightly!"))

/obj/effect/alien/resin/special/recovery/holdfast/proc/debuff_fx()
	if(buff_fx_on == FALSE || length(current_buffed_knights)) //will not cease glowing if theres currently buffed knights
		return
	buff_fx_on = FALSE
	if(COOLDOWN_FINISHED(src, noisy_fx))
		visible_message(SPAN_HELPFUL("\The [src] ceases shining."))
		COOLDOWN_START(src, noisy_fx, 14 SECONDS)
	remove_filter("holdfast_buff")
