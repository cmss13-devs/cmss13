#define PREDATOR_ACTION_ON_CLICK 2 //If the action is on click, and not toggled on or off

/datum/action/predator_action
	icon_file = 'icons/mob/hud/actions_yautja.dmi'
	button_icon_state = "pred_template"
	///If the action requires bracers worn or in-hand
	var/require_bracers = FALSE
	///If the action requires a yautja mask to be worn
	var/require_mask = FALSE
	///The mob calling the action
	var/mob/living/carbon/human/yautja
	///The bracers on the mob (if applicable)
	var/obj/item/clothing/gloves/yautja/hunter/bracers
	///The mask on the mob (if applicable)
	var/obj/item/clothing/mask/gas/yautja/mask
	///If the action is currently on or in use
	var/active = FALSE

/datum/action/predator_action/remove_from(mob/user)
	yautja = null
	bracers = null
	mask = null
	. = ..()

/datum/action/predator_action/can_use_action()
	. = ..()
	if(!.)
		return FALSE

	yautja = null
	bracers = null
	mask = null

	var/mob/living/carbon/human/mob = owner
	if(!ishuman(mob))
		return FALSE
	if(mob.is_mob_incapacitated())
		return FALSE
	yautja = mob

	if(require_bracers)
		if(istype(yautja.gloves, /obj/item/clothing/gloves/yautja))
			bracers = yautja.gloves
		else if(istype(yautja.get_held_item(), /obj/item/clothing/gloves/yautja))
			bracers = yautja.get_held_item()
		if(!bracers)
			to_chat(yautja, SPAN_WARNING("You don't have bracers."))
			return FALSE

	if(require_mask)
		if(!istype(yautja.wear_mask, /obj/item/clothing/mask/gas/yautja))
			to_chat(yautja, SPAN_WARNING("You don't have a clan mask."))
			return FALSE
		mask = yautja.wear_mask

	return TRUE

/datum/action/predator_action/action_activate()
	. = ..()
	if(!can_use_action())
		return FALSE

/datum/action/predator_action/update_button_icon(enabled)
	. = ..()
	if(active == PREDATOR_ACTION_ON_CLICK)
		return

	if(isnull(enabled))
		active = !active
	else
		active = enabled

	button.icon_state = initial(button_icon_state)
	if(active)
		button.icon_state += "_on"

/datum/action/predator_action/mark_for_hunt
	name = "Mark for Hunt"
	action_icon_state = "mark_for_hunt"
	listen_signal = COMSIG_KB_YAUTJA_TOGGLE_MARK_FOR_HUNT
	active = PREDATOR_ACTION_ON_CLICK

/datum/action/predator_action/mark_for_hunt/action_activate()
	. = ..()
	if(yautja.hunter_data.prey) //You can only hunt one person at a time
		yautja.remove_from_hunt()
		return
	yautja.mark_for_hunt()

/datum/action/predator_action/mark_panel
	name = "Open Mark Panel"
	action_icon_state = "mark_panel"
	listen_signal = COMSIG_KB_YAUTJA_MARK_PANEL
	active = PREDATOR_ACTION_ON_CLICK

/datum/action/predator_action/mark_panel/action_activate()
	. = ..()
	yautja.mark_panel()

//Actions that require wearing a mask
/datum/action/predator_action/mask
	require_mask = TRUE

/datum/action/predator_action/mask/zoom
	name = "Toggle Mask Zoom"
	action_icon_state = "zoom"
	listen_signal = COMSIG_KB_YAUTJA_MASK_TOGGLE_ZOOM

/datum/action/predator_action/mask/zoom/action_activate()
	. = ..()
	mask.toggle_zoom()

/datum/action/predator_action/mask/visor
	name = "Toggle Mask Visor"
	action_icon_state = "visor"
	require_bracers = TRUE //Needs bracer power to operate
	listen_signal = COMSIG_KB_YAUTJA_MASK_TOGGLESIGHT

/datum/action/predator_action/mask/visor/action_activate()
	. = ..()
	mask.togglesight()

/datum/action/predator_action/mask/visor/update_button_icon(enabled) //Open or close the eye
	. = ..() //Overlays

	var/new_icon_state = action_icon_state
	if(enabled)
		new_icon_state += "_on"

	button.overlays.Cut()
	var/image/new_overlays
	new_overlays = image(icon_file, button, new_icon_state)

	button.overlays += new_overlays

/datum/action/predator_action/mask/control_falcon_drone
	name = "Control Falcon Drone"
	action_icon_state = "falcon_drone"
	listen_signal = COMSIG_KB_YAUTJA_CONTROL_FALCON
	active = PREDATOR_ACTION_ON_CLICK
	require_bracers = TRUE
	///The falcon drone that will be sent when the action is pressed
	var/obj/item/falcon_drone/linked_falcon_drone

/datum/action/predator_action/mask/control_falcon_drone/action_activate()
	. = ..()
	linked_falcon_drone.control_falcon_drone(yautja, bracers)


//Actions that require wearing bracers
/datum/action/predator_action/bracer
	require_bracers = TRUE

/datum/action/predator_action/bracer/wristblade
	name = "Use Bracer Attachments"
	action_icon_state = "wristblade"
	listen_signal = COMSIG_KB_YAUTJA_BRACER_ATTACHMENT

/datum/action/predator_action/bracer/wristblade/action_activate()
	. = ..()
	bracers.bracer_attachment()

/datum/action/predator_action/bracer/chained
	name = "Yank Weapon"
	action_icon_state = "combi"
	listen_signal = COMSIG_KB_YAUTJA_CALL_COMBI
	active = PREDATOR_ACTION_ON_CLICK

/datum/action/predator_action/bracer/chained/action_activate()
	. = ..()
	yautja.call_combi_internal(yautja, forced = FALSE)

/datum/action/predator_action/bracer/smartdisc
	name = "Recall nearby smart-discs"
	action_icon_state = "smartdisc"
	listen_signal = COMSIG_KB_YAUTJA_CALL_DISC
	active = PREDATOR_ACTION_ON_CLICK

/datum/action/predator_action/bracer/smartdisc/action_activate()
	. = ..()
	bracers.call_disc()

/datum/action/predator_action/bracer/caster
	name = "Toggle Plasma Caster"
	action_icon_state = "plasma_caster"
	listen_signal = COMSIG_KB_YAUTJA_CASTER

/datum/action/predator_action/bracer/caster/action_activate()
	. = ..()
	bracers.caster()

/datum/action/predator_action/bracer/cloak
	name = "Toggle Cloak"
	action_icon_state = "cloak"
	listen_signal = COMSIG_KB_YAUTJA_CLOAKER

/datum/action/predator_action/bracer/cloak/action_activate()
	. = ..()
	bracers.cloaker()

/datum/action/predator_action/bracer/thwei
	name = "Create Stabilizing Crystal"
	action_icon_state = "thwei"
	listen_signal = COMSIG_KB_YAUTJA_INJECTORS
	active = PREDATOR_ACTION_ON_CLICK

/datum/action/predator_action/bracer/thwei/action_activate()
	. = ..()
	bracers.injectors()

/datum/action/predator_action/bracer/capsule
	name = "Create Healing Capsule"
	action_icon_state = "gel_vial"
	listen_signal = COMSIG_KB_YAUTJA_CAPSULE
	active = PREDATOR_ACTION_ON_CLICK

/datum/action/predator_action/bracer/capsule/action_activate()
	. = ..()
	bracers.healing_capsule()

/datum/action/predator_action/bracer/translator
	name = "Use Translator"
	action_icon_state = "translator"
	listen_signal = COMSIG_KB_YAUTJA_TRANSLATE
	active = PREDATOR_ACTION_ON_CLICK

/datum/action/predator_action/bracer/translator/action_activate()
	. = ..()
	bracers.translate()

/datum/action/predator_action/bracer/self_destruct
	name = "Self Destruct"
	action_icon_state = "self_destruct"
	listen_signal = COMSIG_KB_YAUTJA_ACTIVATE_SUICIDE

/datum/action/predator_action/bracer/self_destruct/action_activate()
	. = ..()
	bracers.activate_suicide()

//Misc actions
/datum/action/yautja_emote_panel
	name = "Open Emote Panel"
	icon_file = 'icons/mob/hud/actions_yautja.dmi'
	button_icon_state = "pred_template"
	action_icon_state = "looc_toggle"

/datum/action/yautja_emote_panel/action_activate()
	. = ..()
	var/mob/living/carbon/human/human_owner = owner
	var/datum/species/yautja/yautja_species = human_owner.species
	yautja_species.open_emote_panel()

/datum/yautja_emote_panel
	/// Static dict ("category" : (emotes)) of every yautja emote typepath
	var/static/list/yautja_emotes
	/// Static list of categories
	var/static/list/yautja_categories = list()
	/// Panel allows you to spam, so a manual CD is added here
	COOLDOWN_DECLARE(panel_emote_cooldown)

/datum/yautja_emote_panel/New()
	if(length(yautja_emotes))
		return
	var/list/emotes_to_add = list()
	for(var/datum/emote/living/carbon/human/yautja/emote as anything in subtypesof(/datum/emote/living/carbon/human/yautja))
		if(!initial(emote.key) || initial(emote.no_panel))
			continue

		if(!(initial(emote.category) in yautja_categories))
			yautja_categories += initial(emote.category)
		emotes_to_add += emote
	yautja_emotes = emotes_to_add

/datum/yautja_emote_panel/proc/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Emotes", "Yautja Audio Panel")
		ui.open()

/datum/yautja_emote_panel/ui_data(mob/user)
	var/list/data = list()

	data["on_cooldown"] = !COOLDOWN_FINISHED(src, panel_emote_cooldown)

	return data

/datum/yautja_emote_panel/ui_state(mob/user)
	return GLOB.conscious_state

/datum/yautja_emote_panel/ui_static_data(mob/user)
	var/list/data = list()

	data["categories"] = yautja_categories
	data["theme"] = "crtred"
	data["emotes"] = list()

	for(var/datum/emote/living/carbon/human/yautja/emote as anything in yautja_emotes)
		data["emotes"] += list(list(
			"id" = initial(emote.key),
			"text" = (initial(emote.override_say) || initial(emote.say_message) || initial(emote.key)),
			"category" = initial(emote.category),
			"path" = "[emote]",
		))

	return data

/datum/yautja_emote_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("emote")
			var/datum/emote/living/carbon/human/yautja/path
			if(!params["emotePath"])
				return FALSE

			path = text2path(params["emotePath"])

			if(!path || !COOLDOWN_FINISHED(src, panel_emote_cooldown))
				return

			if(!(path in subtypesof(/datum/emote/living/carbon/human/yautja)))
				return FALSE

			COOLDOWN_START(src, panel_emote_cooldown, 2.5 SECONDS)
			ui.user.emote(initial(path.key))
			return TRUE

/datum/action/predator_action/leap
	name = "Leap"
	action_icon_state = "leap_placeholder"
	listen_signal = COMSIG_KB_YAUTJA_LEAP
	active = FALSE
	var/max_distance = 7
	var/leap_speed = 5
	var/cooldown_duration = 15 SECONDS
	COOLDOWN_DECLARE(leap_cooldown)

/datum/action/predator_action/leap/can_use_action()
	var/mob/living/carbon/human/user = owner
	if(user.is_mob_incapacitated())
		return FALSE
	return TRUE

/datum/action/predator_action/leap/action_activate()
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(user.selected_ability == src)
		to_chat(user, "You will no longer use [name] with [user.get_ability_mouse_name()].")
		button.icon_state = "template"
		user.set_selected_ability(null)
	else
		to_chat(user, "You will now use [name] with [user.get_ability_mouse_name()].")
		if(user.selected_ability)
			user.selected_ability.button.icon_state = "template"
			user.set_selected_ability(null)
		button.icon_state = "template_on"
		user.set_selected_ability(src)

/datum/action/predator_action/leap/proc/use_ability(atom/target_atom)
	var/mob/living/carbon/human/user = owner

	if(user.is_mob_incapacitated())
		to_chat(user, SPAN_WARNING("You're a bit too incapacitated for that."))
		return FALSE

	if(!COOLDOWN_FINISHED(src, leap_cooldown))
		to_chat(user, SPAN_WARNING("You cannot leap again so soon, give your legs a break!"))
		return FALSE

	if(!isturf(user.loc))
		to_chat(user, SPAN_WARNING("You can't leap from here!"))
		return FALSE

	if(user.legcuffed)
		to_chat(user, SPAN_WARNING("You can't leap with that thing on your leg!"))
		return FALSE

	if(!target_atom || target_atom.layer >= FLY_LAYER)
		return FALSE

	var/turf/t_turf = get_turf(target_atom)
	var/obj/effect/warning/yautja_leap/warning = new(t_turf)
	calculate_warning_turf(warning, user, t_turf)

	user.face_dir(get_cardinal_dir(user, target_atom))
	user.visible_message(SPAN_WARNING("\The [user] prepares to leap at [target_atom]!"), SPAN_WARNING("You get ready to leap at [target_atom]!"))

	/// Default delay
	if(!do_after(user, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		qdel(warning)
		return FALSE

	/// Extra if you're going upwards
	if((target_atom.z > user.z) && !do_after(user, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		qdel(warning)
		return FALSE

	COOLDOWN_START(src, leap_cooldown, cooldown_duration)
	if(isspeciesyautja(user))
		var/sound_file = pick('sound/effects/pred_leap1.ogg', 'sound/effects/pred_leap2.ogg')
		playsound(user, sound_file, 25, TRUE)

	RegisterSignal(user, COMSIG_CLIENT_MOB_MOVE, PROC_REF(disable_flying_movement))
	user.throw_atom(t_turf, max_distance, leap_speed, launch_type = LOW_LAUNCH, pass_flags = PASS_MOB_THRU|PASS_OVER_THROW_MOB)
	user.visible_message(SPAN_WARNING("\The [user] leaps at [target_atom]!"), SPAN_WARNING("You leap at [target_atom]!"))

	UnregisterSignal(user, COMSIG_CLIENT_MOB_MOVE)
	qdel(warning)

/datum/action/predator_action/leap/proc/disable_flying_movement(mob/living/carbon/human/user)
	SIGNAL_HANDLER
	return COMPONENT_OVERRIDE_MOVE

/datum/action/predator_action/leap/proc/calculate_warning_turf(obj/effect/warning/warning, mob/living/user, turf/t_turf)
	var/t_dist = get_dist(user, t_turf)
	if(!(t_dist > max_distance))
		return
	var/list/turf/path = get_line(user, t_turf, FALSE)
	warning.forceMove(path[max_distance])

#undef PREDATOR_ACTION_ON_CLICK
