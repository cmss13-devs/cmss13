/obj/item/weapon/shield
	name = "shield"
	var/base_icon_state = "shield"
	var/passive_block = 15 // Percentage chance used in prob() to block incoming attack
	var/readied_block = 30
	var/readied_slowdown = SLOWDOWN_ARMOR_VERY_LIGHT // Walking around in a readied shield stance slows you! The armor defs are a useful existing reference point.
	var/shield_readied = FALSE

// Toggling procs
/obj/item/weapon/shield/proc/raise_shield(mob/user as mob) // Prepare for an attack. Slows you down slightly, but increases chance to block.
	user.visible_message(SPAN_BLUE("\The [user] raises \the [src]."))
	shield_readied = TRUE
	icon_state = "[base_icon_state]_ready"

	var/mob/living/carbon/human/H = user
	var/current_shield_slowdown = H.shield_slowdown
	H.shield_slowdown = max(readied_slowdown, H.shield_slowdown)
	if(H.shield_slowdown != current_shield_slowdown)
		H.recalculate_move_delay = TRUE

/obj/item/weapon/shield/proc/lower_shield(mob/user as mob)
	user.visible_message(SPAN_BLUE("\The [user] lowers \the [src]."))
	shield_readied = FALSE
	icon_state = base_icon_state

	var/mob/living/carbon/human/H = user
	var/current_shield_slowdown = H.shield_slowdown
	var/set_shield_slowdown = 0
	var/obj/item/weapon/shield/offhand_shield
	if(H.l_hand == src && istype(H.r_hand, /obj/item/weapon/shield))
		offhand_shield = H.r_hand
	else if(H.r_hand == src && istype(H.l_hand, /obj/item/weapon/shield))
		offhand_shield = H.l_hand
	if(offhand_shield?.shield_readied)
		set_shield_slowdown = offhand_shield.readied_slowdown
	H.shield_slowdown = set_shield_slowdown
	if(H.shield_slowdown != current_shield_slowdown)
		H.recalculate_move_delay = TRUE

/obj/item/weapon/shield/proc/toggle_shield(mob/user as mob)
	if(shield_readied)
		lower_shield(user)
	else
		raise_shield(user)

// Making sure that debuffs don't stay
/obj/item/weapon/shield/dropped(mob/user as mob)
	if(shield_readied)
		lower_shield(user)
	..()

/obj/item/weapon/shield/equipped(mob/user, slot)
	if(shield_readied)
		lower_shield(user)
	..()

/obj/item/weapon/shield/riot
	name = "riot shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "riot"
	item_state = "riot"
	base_icon_state = "riot"
	flags_equip_slot = SLOT_BACK
	force = 15
	passive_block = 20
	readied_block = 40
	readied_slowdown = SLOWDOWN_ARMOR_LIGHT
	throwforce = 5
	throw_speed = SPEED_FAST
	throw_range = 4
	w_class = SIZE_LARGE
	matter = list("glass" = 7500, "metal" = 1000)
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/items_lefthand_1.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/items_righthand_1.dmi'
		)

	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time
	var/blocks_on_back = TRUE

/obj/item/weapon/shield/riot/IsShield()
	return 1

/obj/item/weapon/shield/riot/attack_self(mob/user)
	..()
	toggle_shield(user)

/obj/item/weapon/shield/riot/attackby(obj/item/W as obj, mob/user as mob)
	if(cooldown < world.time - 25)
		if(istype(W, /obj/item/weapon/baton) || istype(W, /obj/item/weapon/sword) || istype(W, /obj/item/weapon/telebaton) || istype(W, /obj/item/weapon/baseballbat) || istype(W, /obj/item/weapon/classic_baton) || istype(W, /obj/item/weapon/twohanded/fireaxe) || istype(W, /obj/item/weapon/chainofcommand))
			user.visible_message(SPAN_WARNING("[user] bashes [src] with [W]!"))
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 25, 1)
			cooldown = world.time
	else
		..()

/obj/item/weapon/shield/energy
	name = "energy combat shield"
	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "eshield0" // eshield1 for expanded
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT|NOBLOODY
	force = 3
	passive_block = 50 // Shield activation takes over functionality, and no slowdown.
	readied_block = 50
	throwforce = 5
	throw_speed = SPEED_FAST
	throw_range = 4
	w_class = SIZE_SMALL

	attack_verb = list("shoved", "bashed")
	var/active = 0

/obj/item/weapon/shield/riot/metal
	name = "metal shield"
	name = "A metal riot shield effective, but heavy."
	icon_state = "riotmetal"
	item_state = "riotmetal"
	base_icon_state = "riotmetal"
	passive_block = 40
	readied_block = 60

/obj/item/weapon/shield/riot/ballistic //FOR THE ROYAL MARINE SPEC DO NOT TOUCH SMELLY MAN
	name = "FBS-B Ballistic shield"
	desc = "Ballistic shield used by the royal marines commando. This shield is commonly used during boarding actions due to its lightweight but durible design."
	desc_lore = "The Fox Ballistic Shield-B (FBS-B), was originally introduced as the FBS, attempting to be a solution to high-impact operations following increased counter-insurgency deployments since 2151. It was designed to provide maximum protection, and for the user to be able to utilize their primary armament in tandem. By 2163 tertiary ballistics trials were undertaken to ascertain it's effectiveness against improved munitions, and was additionally used as an opportunity to  deal with user complaints making their way up from quartermasters. The complaints of the original FBS were twofold: weight and extended usage in combat causing the side to melt closest to the barrel. After further material research and in the field tests were conducted, by 2171, the FBS had attained a ballistics protection classification of D, the highest available for a portable shield, by being able to stop a singular armor piercing round. This reported success was due to the usage of a new fibre reinforced lightweight composite.  In the wake of the successful improvements, the FBS was later christened the FBS-B as with the enhanced shield, the user had a tendency for maximum aggression during engagements. The nickname 'Bellicose' was given to breachers by their squaddies and later became it's official designation."
	icon_state = "ballisticshield"
	item_state = "ballisticshield"
	base_icon_state = "ballisticshield"
	passive_block = 60
	readied_block = 90
