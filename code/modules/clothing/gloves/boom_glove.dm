/obj/item/clothing/gloves/marine/boom_glove
	name = "XXV-5 Forcegloves"
	desc = "A ridiculous prototype weapon made by crazy scientists. These gloves generate directed explosions when used."

	icon = 'icons/obj/items/clothing/gloves.dmi'
	icon_state = "s-ninjak"

	var/explosive_power = 60
	var/explosive_falloff = 20

	var/windup = 15
	var/cooldown = 50
	var/last_use = 0

	actions_types = list(/datum/action/item_action/toggle/use)

/obj/item/clothing/gloves/marine/boom_glove/item_action_slot_check(mob/user, slot)
	if(!ishuman(user)) return FALSE
	if(slot != WEAR_HANDS) return FALSE
	return TRUE //only give action button when the gloves are worn

/obj/item/clothing/gloves/marine/boom_glove/attack_self(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	// Gloves have to be worn to use them
	if(H.gloves != src)
		..()
		return

	// Check for cooldown
	if(world.time < last_use + cooldown)
		..()
		to_chat(H, SPAN_NOTICE("The gloves are still recharging!"))
		return

	if(!do_after(H, windup, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		return

	last_use = world.time

	var/turf/epicenter = get_turf(H)
	epicenter = get_step(epicenter, H.dir)

	if(!epicenter)
		return

	// boom
	cell_explosion(epicenter, explosive_power, explosive_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, H.dir, create_cause_data(initial(name), H))
