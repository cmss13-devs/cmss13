/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/items/items.dmi'
	amount = 10
	max_amount = 10
	w_class = SIZE_SMALL
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	attack_speed = 3
	var/application_time = 2 SECONDS
	var/minimum_skill
	var/max_limb_damage
	var/list/wounds_stabilized = list()
	var/category
	var/icon/onbody_icon
	var/onbody_icon_state
	var/obj/limb/located_limb
	var/application_sound = null

/obj/item/stack/medical/Initialize(mapload, amount)
	. = ..()
	RegisterSignal(src, list(COMSIG_ITEM_ATTACK, COMSIG_ITEM_ATTACK_SELF), .proc/handle_application)

/obj/item/stack/medical/proc/handle_application(applied, mob/living/carbon/human/limb_owner, mob/user)
	if(isnull(user))
		user = limb_owner

	if(!istype(limb_owner) || user.a_intent == INTENT_HARM)
		return
	var/obj/limb/L = limb_owner.get_limb(user.zone_selected)
	if(isnull(L))
		return

	INVOKE_ASYNC(src, .proc/apply_to_limb, L, limb_owner, user)

	return COMPONENT_CANCEL_ATTACK

/obj/item/stack/medical/proc/apply_to_limb(obj/limb/L, mob/limb_owner, mob/user)
	if(!skillcheck(user, SKILL_MEDICAL, minimum_skill))
		to_chat(user, SPAN_WARNING("You're not skilled enough to apply \the [src]."))
		return

	var/list/found = list()
	var/obj/item/stack/medical/prev_applied = null
	SEND_SIGNAL(L, COMSIG_LIMB_GET_ATTACHED_ITEMS, found)

	if(length(found))
		for(var/obj/item/stack/medical/I in found)
			if(!istype(I))
				continue
			if(I.category == category)
				prev_applied = I
				break

	var/msg_apply
	var/obj/item/stack/medical/applied = src

	if(prev_applied)
		msg_apply = "replacing the [prev_applied.name] on [limb_owner.name]'s [parse_zone(user.zone_selected)] with the [src]"
	else
		msg_apply = "applying the [src] to [limb_owner.name]'s [parse_zone(user.zone_selected)]"

	to_chat(user, SPAN_NOTICE("You start [msg_apply]..."))
	if(do_after(user, application_time * user.get_skill_duration_multiplier(SKILL_MEDICAL), INTERRUPT_ALL, BUSY_ICON_MEDICAL, limb_owner, INTERRUPT_OUT_OF_RANGE))
		if(prev_applied)
			prev_applied.remove_from_limb(L)

		if(amount > 1) //"Take out" from the stack
			use(1)
			applied = new type(L, 1)
		else
			user.drop_held_item()
			applied.forceMove(L) //applied == src

		applied.RegisterSignal(L, COMSIG_LIMB_GET_ATTACHED_ITEMS, .proc/get_item)
		applied.RegisterSignal(L, COMSIG_LIMB_TAKEN_DAMAGE, .proc/on_limb_damaged)
		applied.RegisterSignal(applied, COMSIG_ITEM_REMOVED_FROM_LIMB, .proc/handle_item_removal)
		applied.RegisterSignal(L, COMSIG_PARENT_QDELETING, .proc/handle_item_removal)
		if(length(wounds_stabilized))
			applied.RegisterSignal(L, COMSIG_PRE_LOCAL_WOUND_EFFECTS, .proc/stabilize)
			SEND_SIGNAL(L, COMSIG_LIMB_WOUND_STABILIZER_ADDED)

		applied.located_limb = L
		applied.on_applied()

		limb_owner.update_med_icon()

		to_chat(user, SPAN_HELPFUL("You succeed!"))
		playsound(user, application_sound, 25, 1, 2)

/obj/item/stack/medical/proc/on_applied()

/obj/item/stack/medical/proc/stabilize(limb, wound_type)
	SIGNAL_HANDLER
	if(wounds_stabilized.Find(wound_type))
		return COMPONENT_STABILIZE_WOUND

/obj/item/stack/medical/proc/on_limb_damaged(limb, is_ff)
	SIGNAL_HANDLER
	if(!is_ff)
		var/dmg = located_limb.brute_dam + located_limb.burn_dam
		if(dmg > max_limb_damage)
			var/chance = (dmg - max_limb_damage) * 5
			if(prob(chance))
				remove_from_limb(TRUE)

/obj/item/stack/medical/proc/get_item(limb, list/item_list)
	SIGNAL_HANDLER
	item_list += src

/obj/item/stack/medical/proc/remove_from_limb(destroy = FALSE)
	forceMove(get_turf(located_limb))

	handle_item_removal(src, located_limb)

	if(destroy)
		qdel(src)

/obj/item/stack/medical/proc/handle_item_removal()
	SIGNAL_HANDLER
	UnregisterSignal(located_limb, list(COMSIG_PRE_LOCAL_WOUND_EFFECTS, COMSIG_LIMB_TAKEN_DAMAGE, COMSIG_PARENT_QDELETING, COMSIG_LIMB_GET_ATTACHED_ITEMS))
	UnregisterSignal(src, COMSIG_ITEM_REMOVED_FROM_LIMB)
	SEND_SIGNAL(located_limb, COMSIG_LIMB_WOUND_STABILIZER_REMOVED)

	located_limb.owner.update_med_icon()
	located_limb = null

/obj/item/stack/medical/bruise_pack
	name = "roll of gauze"
	singular_name = "medical gauze"
	desc = "Some sterile gauze to wrap around bloody stumps and lacerations."
	icon_state = "brutepack"

	stack_id = "bruise pack"
	onbody_icon_state = "gauze"
	category = CATEGORY_GAUZES

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat burns, infected wounds, and relieve itching in unusual places."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	stack_id = "ointment"

/obj/item/stack/medical/splint
	name = "medical splints"
	singular_name = "medical splint"
	desc = "A collection of different splints and securing gauze. What, did you think we only broke legs out here?"
	icon_state = "splint"
	amount = 5
	max_amount = 5
	stack_id = "splint"

	var/indestructible_splints = FALSE
	application_time = 8 SECONDS
	wounds_stabilized = list(/datum/limb_wound/fracture)
	onbody_icon_state = "splint"
	category = CATEGORY_SPLINTS
	application_sound = 'sound/handling/splint1.ogg'

//TODO: needs sprites, application sfx, onmob sprites. Should affect normal bleeding too, once that's added. Should probably have some kind of side effect
// - maybe preventing autoheal/trauma kit heal-over-time? Reducing chemical heals from the restricted bloodflow? IDK.
/obj/item/stack/medical/tourniquet
	name = "tourniquets"
	singular_name = "tourniquet"
	desc = "A collection of modern tourniquets, for controlling extreme bleeding. Because these deliberately cut off almost all circulation, there are a number of side effects - but if you can worry about those, it's because you didn't bleed to death."
	icon = 'icons/obj/items/marine-items.dmi' // <- placeholder
	icon_state = "barbed_wire" // <- placeholder
	amount = 5
	max_amount = 5
	stack_id = "tourniquet"

	var/indestructible_splints = FALSE
	application_time = 6 SECONDS //Takes a little while but faster than splinting.
	wounds_stabilized = list(/datum/limb_wound/bleeding_arterial)
	onbody_icon_state = "splint" // <- placeholder
	category = CATEGORY_TOURNIQUETS
	application_sound = 'sound/handling/splint1.ogg' // <- placeholder


//Healing items, such as trauma kits, work by healing the limb for a determined amount of time, becoming spent afterwards
//Additionally, they become spent upon being removed
/obj/item/stack/medical/healing
	var/brute_heal_instant = 0
	var/burn_heal_instant = 0
	var/brute_heal_rate = 0
	var/burn_heal_rate = 0
	var/healing_effect_duration = 0
	var/healing_effect_timer
	var/spent = FALSE

/obj/item/stack/medical/healing/apply_to_limb(obj/limb/L, mob/limb_owner, mob/user)
	if(spent)
		to_chat(user, SPAN_NOTICE("[src] is spent, there's no way you could apply it to a limb!"))
	else
		..()

/obj/item/stack/medical/healing/handle_item_removal()
	..()
	deltimer(healing_effect_timer)
	if(!spent)
		spend() //Has to be in this order, since spend() sets the timer to null

/obj/item/stack/medical/healing/on_applied()
	located_limb.heal_damage(brute_heal_instant, burn_heal_instant)
	START_PROCESSING(SSobj, src)
	healing_effect_timer = addtimer(CALLBACK(src, .proc/spend), healing_effect_duration, TIMER_STOPPABLE)

/obj/item/stack/medical/healing/process(delta_time)
	located_limb.heal_damage(brute_heal_rate * delta_time, burn_heal_rate * delta_time)

/obj/item/stack/medical/healing/proc/spend()
	spent = TRUE
	name += " (spent)"
	stack_id += "_spent"
	healing_effect_timer = null
	STOP_PROCESSING(SSobj, src)

/obj/item/stack/medical/healing/traumakit
	name = "advanced trauma kit"
	singular_name = "advanced trauma kit"
	desc = "An advanced trauma kit for severe injuries."
	icon_state = "traumakit"

	stack_id = "advanced bruise pack"

	brute_heal_instant = 10
	burn_heal_instant = 0
	brute_heal_rate = 0.5
	burn_heal_rate = 0
	healing_effect_duration = 20 SECONDS
	application_sound = 'sound/handling/bandage.ogg'
	category = CATEGORY_BRUTEHEALER

/obj/item/stack/medical/healing/traumakit/predator
	name = "mending herbs"
	singular_name = "mending herb"
	desc = "A poultice made of soft leaves that is rubbed on bruises."
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "brute_herbs"
	stack_id = "mending herbs"

/obj/item/stack/medical/healing/burnkit
	name = "advanced burn kit"
	singular_name = "advanced burn kit"
	desc = "An advanced treatment kit for severe burns."
	icon_state = "burnkit"

	stack_id = "advanced burn kit"

	brute_heal_instant = 0
	burn_heal_instant = 10
	brute_heal_rate = 0
	burn_heal_rate = 0.5
	healing_effect_duration = 20 SECONDS
	application_sound = 'sound/handling/ointment_spreading.ogg'
	category = CATEGORY_BURNHEALER

/obj/item/stack/medical/healing/burnkit/predator
	name = "soothing herbs"
	singular_name = "soothing herb"
	desc = "A poultice made of cold, blue petals that is rubbed on burns."
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "burn_herbs"
	stack_id = "soothing herbs"
