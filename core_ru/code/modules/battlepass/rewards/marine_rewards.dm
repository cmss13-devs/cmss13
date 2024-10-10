/datum/battlepass_reward/marine
	lifeform_type = "Marine"

/datum/battlepass_reward/marine/can_claim(mob/target_mob)
	. = ..()
	if(!.)
		return .

	if(!ishuman(target_mob))
		return FALSE

	return TRUE


/datum/battlepass_reward/marine/toy
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
	icon = 'core_ru/code/modules/battlepass/rewards/sprites/toy.dmi'
	icon_state = "runner_toy"
	item_path = /obj/item/toy/plush/runner_toy


/datum/battlepass_reward/marine/toy/warrior_toy
	name = "Warrior Toy"
	icon = 'core_ru/code/modules/battlepass/rewards/sprites/toy.dmi'
	icon_state = "warrior_toy"
	item_path = /obj/item/toy/plush/warrior_toy


/datum/battlepass_reward/marine/toy/queen_toy
	name = "Queen Toy"
	icon = 'core_ru/code/modules/battlepass/rewards/sprites/toy.dmi'
	icon_state = "queen_toy"
	item_path = /obj/item/toy/plush/queen_toy


/datum/battlepass_reward/marine/toy/bikehorn
	name = "Bike Horn"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "bike_horn"
	item_path = /obj/item/toy/bikehorn
