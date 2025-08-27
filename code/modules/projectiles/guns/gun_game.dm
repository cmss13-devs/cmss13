/obj/item/weapon/gun/proc/start_gun_game()

	var/weapon_to_start
	var/mob/living/carbon/human/shooter = gun_user

	weapon_to_start = pick(gun_list_first)

	new weapon_to_start(get_turf(shooter))


/obj/item/weapon/gun/proc/move_onto_next_gun()
	SIGNAL_HANDLER

	var/mob/living/carbon/human/shooter = gun_user

	var/new_chosen_weapon
	var/old_weapon = src
	var/datum/next_weapon

	finished_gun_list += src

	if(!current_gun)
		current_gun = src

	switch(gun_game_phase)
		if(1)
			next_weapon = pick(gun_list_second)
		if(2)
			next_weapon = pick(gun_list_third)
		if(3)
			next_weapon = pick(gun_list_fourth)
		if(4)
			next_weapon = pick(final_list)

	finished_gun_list += next_weapon

	current_gun = old_weapon
	new_chosen_weapon = next_weapon
	qdel(old_weapon)

	shooter.equip_to_slot_or_del(new next_weapon(shooter), WEAR_R_HAND)

/obj/item/weapon/gun/lever_action/xm88/gun_game

/obj/item/weapon/gun/lever_action/xm88/gun_game/Initialize()
	. = ..()

	RegisterSignal(src, COMSIG_GUN_GAME_REGISTER, PROC_REF(move_onto_next_gun))
	ADD_TRAIT(src, GUN_GAME_TRAIT, TRAIT_SOURCE_GUNGAME)
	src.current_gun = src
	src.gun_game_phase = 3


/obj/item/weapon/gun/rifle/l42a/gun_game


	starting_attachment_types = list(/obj/item/attachable/reddot, /obj/item/attachable/flashlight/grip, /obj/item/attachable/extended_barrel)

/obj/item/weapon/gun/rifle/l42a/gun_game/Initialize()
	. = ..()

	RegisterSignal(src, COMSIG_GUN_GAME_REGISTER, PROC_REF(move_onto_next_gun))
	ADD_TRAIT(src, GUN_GAME_TRAIT, TRAIT_SOURCE_GUNGAME)
	src.current_gun = src
	src.gun_game_phase = 2

/obj/item/weapon/gun/rifle/m41a/gun_game


	starting_attachment_types = list(/obj/item/attachable/reflex, /obj/item/attachable/angledgrip,)


/obj/item/weapon/gun/rifle/m41a/gun_game/Initialize()

	. = ..()

	RegisterSignal(src, COMSIG_GUN_GAME_REGISTER, PROC_REF(move_onto_next_gun))
	ADD_TRAIT(src, GUN_GAME_TRAIT, TRAIT_SOURCE_GUNGAME)
	src.current_gun = src
	src.gun_game_phase = 1

/obj/item/weapon/gun/rifle/lmg/gun_game



/obj/item/weapon/gun/rifle/lmg/gun_game/Initialize()
	. = ..()

	starting_attachment_types = list(/obj/item/attachable/reflex, /obj/item/attachable/bipod)
	RegisterSignal(src, COMSIG_GUN_GAME_REGISTER, PROC_REF(move_onto_next_gun))
	ADD_TRAIT(src, GUN_GAME_TRAIT, TRAIT_SOURCE_GUNGAME)
	src.current_gun = src
	src.gun_game_phase = 2

/obj/item/weapon/gun/rifle/m41aMK1/gun_game

	starting_attachment_types = list(/obj/item/attachable/reflex)


/obj/item/weapon/gun/rifle/m41aMK1/gun_game/Initialize()
	. = ..()

	RegisterSignal(src, COMSIG_GUN_GAME_REGISTER, PROC_REF(move_onto_next_gun))
	ADD_TRAIT(src, GUN_GAME_TRAIT, TRAIT_SOURCE_GUNGAME)
	src.current_gun = src
	src.gun_game_phase = 1


/obj/item/weapon/gun/rifle/mar40/gun_game

/obj/item/weapon/gun/rifle/mar40/gun_game/Initialize()
	. = ..()

	RegisterSignal(src, COMSIG_GUN_GAME_REGISTER, PROC_REF(move_onto_next_gun))
	ADD_TRAIT(src, GUN_GAME_TRAIT, TRAIT_SOURCE_GUNGAME)
	src.current_gun = src
	src.gun_game_phase = 2


/obj/item/weapon/gun/rifle/type71/gun_game


/obj/item/weapon/gun/rifle/type71/gun_game/Initialize()
	. = ..()
	src.gun_game_phase = 2
	RegisterSignal(src, COMSIG_GUN_GAME_REGISTER, PROC_REF(move_onto_next_gun))
	ADD_TRAIT(src, GUN_GAME_TRAIT, TRAIT_SOURCE_GUNGAME)
	src.current_gun = src


/obj/item/weapon/gun/shotgun/pump/m37a/gun_game


/obj/item/weapon/gun/shotgun/pump/m37a/gun_game/Initialize()
	. = ..()
	src.gun_game_phase = 3
	RegisterSignal(src, COMSIG_GUN_GAME_REGISTER, PROC_REF(move_onto_next_gun))
	ADD_TRAIT(src, GUN_GAME_TRAIT, TRAIT_SOURCE_GUNGAME)
	src.current_gun = src
/obj/item/weapon/gun/shotgun/double/mou53/gun_game


/obj/item/weapon/gun/shotgun/double/mou53/gun_game/Initialize()
	. = ..()
	src.gun_game_phase = 3
	RegisterSignal(src, COMSIG_GUN_GAME_REGISTER, PROC_REF(move_onto_next_gun))
	ADD_TRAIT(src, GUN_GAME_TRAIT, TRAIT_SOURCE_GUNGAME)
	src.current_gun = src


/obj/item/weapon/gun/flamer/m240/gun_game

/obj/item/weapon/gun/flamer/m240/gun_game/Initialize()
	. = ..()
	src.gun_game_phase = 4
	RegisterSignal(src, COMSIG_GUN_GAME_REGISTER, PROC_REF(move_onto_next_gun))
	ADD_TRAIT(src, GUN_GAME_TRAIT, TRAIT_SOURCE_GUNGAME)
	src.current_gun = src


/obj/item/weapon/gun/pistol/m4a3/m4a4/gun_game


/obj/item/weapon/gun/pistol/m4a3/m4a4/gun_game/Initialize()
	. = ..()
	src.gun_game_phase = 4
	RegisterSignal(src, COMSIG_GUN_GAME_REGISTER, PROC_REF(move_onto_next_gun))
	ADD_TRAIT(src, GUN_GAME_TRAIT, TRAIT_SOURCE_GUNGAME)
	src.current_gun = src



/obj/item/weapon/gun/pistol/heavy/gun_game

/obj/item/weapon/gun/pistol/heavy/gun_game/Initialize()
	. = ..()
	src.gun_game_phase = 4
	RegisterSignal(src, COMSIG_GUN_GAME_REGISTER, PROC_REF(move_onto_next_gun))
	ADD_TRAIT(src, GUN_GAME_TRAIT, TRAIT_SOURCE_GUNGAME)
	src.current_gun = src
