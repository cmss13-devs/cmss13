// PROC SHIT CUZ IM LAZY FOR NOW
/*
/mob/living/carbon/proc/throw_carbon(mob/living/carbon/target, direction, distance, speed = SPEED_VERY_FAST, shake_camera = TRUE, immobilize = TRUE)
	if(!direction)
		direction = get_dir(src, target)
	var/turf/target_destination = get_ranged_target_turf(target, direction, distance)

	var/list/end_throw_callbacks
	if(immobilize)
		end_throw_callbacks = list(CALLBACK(src, PROC_REF(throw_carbon_end), target))
		ADD_TRAIT(target, TRAIT_IMMOBILIZED, XENO_THROW_TRAIT)

	target.throw_atom(target_destination, distance, speed, src, spin = TRUE, end_throw_callbacks = end_throw_callbacks)
	if(shake_camera)
		shake_camera(target, 10, 1)

/mob/living/carbon/proc/throw_carbon_end(mob/living/carbon/target)
	REMOVE_TRAIT(target, TRAIT_IMMOBILIZED, XENO_THROW_TRAIT)
*/
// EVERYTHING ELSE (ALSO LAZY)

/datum/action/item_action/toggle_shield
	name = "Toggle Shield"
	action_icon_state = "shield"
	icon_file = 'icons/halo/mob/hud/actions.dmi'

/datum/action/item_action/toggle_shield/New(mob/living/user, obj/item/holder)
	..()
	name = "Toggle Shield"
	button.name = name
	button.overlays.Cut()
	button.icon = 'icons/halo/mob/hud/actions.dmi'
	var/image/IMG = image('icons/halo/mob/hud/actions.dmi', button, "shield")
	button.overlays += IMG

/datum/action/item_action/toggle_shield/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && !H.is_mob_incapacitated() && holder_item == H.wear_suit)
		return TRUE

/datum/action/item_action/toggle_shield/action_activate()
	. = ..()
	var/obj/item/clothing/suit/marine/shielded/shield = holder_item
	shield.toggle_shield()

/datum/action/human_action/activable/covenant
	name = "Covenant Actions"
	icon_file = 'icons/halo/mob/hud/actions.dmi'
	button_icon_state = "template"
	var/active = FALSE

/datum/action/human_action/activable/covenant/sangheili_kick
	name = "kick"
	icon_file = 'icons/halo/mob/hud/actions.dmi'
	action_icon_state = "kick"
	var/cd_kick = 15 SECONDS
	var/cd_stomp = 25 SECONDS
	var/cd_miss = 3 SECONDS
	var/kick_damage = 20
	var/stomp_damage = 80
	var/fling_distance = 2

/datum/action/human_action/activable/covenant/sangheili_kick/New(mob/living/user, obj/item/holder)
	..()
	name = "kick"
	button.icon = icon_file
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/halo/mob/hud/actions.dmi', button, "kick")
	button.overlays += IMG
	update_button_icon()

/datum/action/human_action/activable/covenant/sangheili_kick/use_ability(atom/target, mob/living/carbon/owner)
	owner = usr

	if (!owner.Adjacent(target))
		return

	if(owner.body_position == LYING_DOWN)
		return

	if(target == owner)
		return

	var/mob/living/carbon/human/human_target = target

	if(!action_cooldown_check())
		to_chat(owner, SPAN_WARNING("You can't do that yet..."))
		return

	if(!ishuman(human_target))
		owner.visible_message(SPAN_WARNING ("[owner] kicks at the air."), SPAN_WARNING ("You kick at the air..."))
		owner.face_atom(target)
		owner.animation_attack_on(target)
		playsound(target, 'sound/effects/alien_tail_swipe2.ogg', 25)
		enter_cooldown(cd_miss)
		return

	if(human_target.body_position == LYING_DOWN)
		owner.visible_message(SPAN_WARNING ("[owner] prepares to stomp down on [target]!"), SPAN_WARNING ("You raise your foot, preparing to stomp on [target]!"))
		owner.face_atom(target)
		if(!do_after(owner, 4 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, target, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
			owner.visible_message(SPAN_WARNING ("[owner] is interrupted!"), SPAN_WARNING ("You're interrupted!"))
			return
		owner.animation_attack_on(target)
		owner.flick_attack_overlay(target, "punch")
		owner.face_atom(target)
		human_target.apply_armoured_damage(stomp_damage, ARMOR_MELEE, BRUTE, "chest")
		playsound(target, 'sound/effects/alien_tail_swipe2.ogg', 25)
		playsound(target, "swing_hit", 25)
		human_target.make_jittery(2 SECONDS)
		enter_cooldown(cd_stomp)
		return

	else
		var/facing = get_dir(owner, target)
		owner.visible_message(SPAN_WARNING ("[owner] effortlessly kicks [target] down."), SPAN_WARNING ("You effortlessly kick [target] down."))
		human_target.apply_armoured_damage(kick_damage, ARMOR_MELEE, BRUTE, "chest")
		playsound(target, "swing_hit", 25)
		owner.face_atom(target)
		owner.animation_attack_on(target)
		owner.throw_carbon(target, facing, fling_distance)
		owner.flick_attack_overlay(target, "punch")
		enter_cooldown(cd_kick)
	return
