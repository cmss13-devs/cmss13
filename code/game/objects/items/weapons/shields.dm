/obj/item/weapon/shield
	name = "shield"
	var/base_icon_state = "shield"
	var/passive_block = 15 // Percentage chance used in prob() to block incoming attack
	var/readied_block = 30 
	var/readied_slowdown = SLOWDOWN_ARMOR_VERY_LIGHT // Walking around in a readied shield stance slows you! The armor defs are a useful existing reference point.
	var/shield_readied = FALSE

// Toggling procs
/obj/item/weapon/shield/proc/raise_shield(mob/user as mob) // Prepare for an attack. Slows you down slightly, but increases chance to block.
	user.visible_message(SPAN_BLUE("[user] raises the [src]."))
	shield_readied = TRUE
	icon_state = "[base_icon_state]_ready"

	var/mob/living/carbon/human/H = user
	H.shield_slowdown = readied_slowdown
	H.recalculate_move_delay = TRUE

/obj/item/weapon/shield/proc/lower_shield(mob/user as mob)
	user.visible_message(SPAN_BLUE("[user] lowers the [src]."))
	shield_readied = FALSE
	icon_state = base_icon_state

	var/mob/living/carbon/human/H = user
	H.shield_slowdown = 0
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
	throwforce = 5.0
	throw_speed = SPEED_FAST
	throw_range = 4
	w_class = SIZE_LARGE
	matter = list("glass" = 7500, "metal" = 1000)
	
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time

/obj/item/weapon/shield/riot/IsShield()
	return 1

/obj/item/weapon/shield/riot/attack_self(var/mob/user)
	toggle_shield(user)

/obj/item/weapon/shield/riot/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/melee/baton) || istype(W, /obj/item/weapon/melee/claymore) || istype(W, /obj/item/weapon/melee/baseballbat) || istype(W, /obj/item/weapon/melee/katana) || istype(W, /obj/item/weapon/melee/twohanded/fireaxe) || istype(W, /obj/item/weapon/melee/chainofcommand))
		if(cooldown < world.time - 25)
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
	flags_atom = FPRINT|CONDUCT|NOBLOODY
	force = 3
	passive_block = 50 // Shield activation takes over functionality, and no slowdown.
	readied_block = 50
	throwforce = 5.0
	throw_speed = SPEED_FAST
	throw_range = 4
	w_class = SIZE_SMALL
	
	attack_verb = list("shoved", "bashed")
	var/active = 0
