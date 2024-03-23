/datum/battlepass_reward/marine

/datum/battlepass_reward/marine/can_claim(mob/target_mob)
	. = ..()
	if(!.)
		return .

	if(!ishuman(target_mob))
		return FALSE

	return TRUE


/datum/battlepass_reward/marine/diamond_armor
	name = "Diamond Armor"
	icon_state = "diamond_armor"
	category = REWARD_CATEGORY_ARMOR

/datum/battlepass_reward/marine/diamond_armor/on_claim(mob/target_mob)
	if(!ishuman(target_mob))
		return FALSE

	var/mob/living/carbon/human/target_human = target_mob
	if(!istype(target_human.wear_suit, /obj/item/clothing/suit/storage/marine))
		to_chat(target_human, SPAN_WARNING("You need to be wearing marine armor to claim this!"))
		return FALSE

	var/obj/item/clothing/suit/storage/marine/marine_armor = target_human.wear_suit
	if(marine_armor.flags_inventory & BLOCK_KNOCKDOWN) // a bit of fairness
		to_chat(target_human, SPAN_WARNING("Armor that blocks knockdowns cannot have a skin!"))
		return FALSE

	marine_armor.flags_marine_armor &= ~ARMOR_SQUAD_OVERLAY
	marine_armor.flags_atom |= NO_SNOW_TYPE
	marine_armor.armor_variation = FALSE
	marine_armor.icon = 'code/modules/battlepass/rewards/sprites/armorobj.dmi'
	marine_armor.icon_state = "diamond_armor"
	marine_armor.name = "diamond [marine_armor.name]"
	marine_armor.desc = "This suit of diamond armor looks impossible to get into. How the hell would anyone be able to afford this?"
	marine_armor.item_icons = list(
		WEAR_JACKET = 'code/modules/battlepass/rewards/sprites/armor.dmi'
	)
	marine_armor.update_icon()
	marine_armor.update_clothing_icon()

	if(target_human.shoes)
		target_human.shoes.flags_atom |= NO_SNOW_TYPE
		target_human.shoes.icon = 'code/modules/battlepass/rewards/sprites/armorobj.dmi'
		target_human.shoes.icon_state = "diamond_boots"
		target_human.shoes.item_icons = list(
			WEAR_FEET = 'code/modules/battlepass/rewards/sprites/armor.dmi'
		)
		if(istype(target_human.shoes, /obj/item/clothing/shoes/marine))
			var/obj/item/clothing/shoes/marine/marine_shoes = target_human.shoes
			marine_shoes.base_icon_state = "diamond_boots"

		target_human.shoes.name = "diamond [target_human.shoes]"
		target_human.shoes.desc = "This pair of diamond boots look impossible to walk around in, but you think you can manage, somehow."
		target_human.shoes.update_icon()
		target_human.update_inv_shoes()

	if(istype(target_human.head, /obj/item/clothing/head/helmet/marine))
		var/obj/item/clothing/head/helmet/marine/marine_helmet = target_human.head
		target_human.head.flags_atom |= NO_SNOW_TYPE
		marine_helmet.flags_marine_helmet = NONE
		marine_helmet.icon = 'code/modules/battlepass/rewards/sprites/armorobj.dmi'
		marine_helmet.icon_state = "diamond_helmet"
		marine_helmet.name = "diamond [marine_helmet.name]"
		marine_helmet.desc = "A diamond helmet. This thing is definitely better than whatever the corps would give you, that's for sure."
		marine_helmet.item_icons = list(
			WEAR_HEAD = 'code/modules/battlepass/rewards/sprites/armor.dmi'
		)
		marine_helmet.update_icon()
	return TRUE


/datum/battlepass_reward/marine/toy
	category = REWARD_CATEGORY_TOY
	var/item_path

/datum/battlepass_reward/marine/toy/on_claim(mob/target_mob)
	if(!ishuman(target_mob) || !item_path)
		return FALSE

	var/mob/living/carbon/human/target_human = target_mob
	var/obj/item/new_toy = new item_path
	target_human.put_in_hands(new_toy, TRUE)
	return TRUE


/datum/battlepass_reward/marine/toy/sus_crayon
	name = "Suspicious Crayon"
	icon_state = "sus_crayon"
	item_path = /obj/item/toy/suspicious


/datum/battlepass_reward/marine/toy/runner_toy
	name = "Runner Toy"
	icon = 'code/modules/battlepass/rewards/sprites/toy.dmi'
	icon_state = "runner_toy"
	item_path = /obj/item/toy/plush/runner_toy


/datum/battlepass_reward/marine/toy/warrior_toy
	name = "Warrior Toy"
	icon = 'code/modules/battlepass/rewards/sprites/toy.dmi'
	icon_state = "warrior_toy"
	item_path = /obj/item/toy/plush/warrior_toy


/datum/battlepass_reward/marine/toy/queen_toy
	name = "Queen Toy"
	icon = 'code/modules/battlepass/rewards/sprites/toy.dmi'
	icon_state = "queen_toy"
	item_path = /obj/item/toy/plush/queen_toy
