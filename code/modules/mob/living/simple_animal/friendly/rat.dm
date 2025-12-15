/mob/living/simple_animal/mouse/rat
	name = "rat"
	real_name = "rat"
	desc = "It's a big, disease-ridden rodent."
	icon_state = "rat_gray"
	icon_living = "rat_gray"
	icon_dead = "rat_gray_dead"
	maxHealth = 10
	health = 10
	holder_type = /obj/item/holder/rat
	icon_base = "rat"

/*
 * Rat types
 */

/mob/living/simple_animal/mouse/rat/gray
	body_color = "gray"
	icon_state = "rat_gray"
	holder_type = /obj/item/holder/rat/gray

/mob/living/simple_animal/mouse/rat/brown
	body_color = "brown"
	icon_state = "rat_brown"
	holder_type = /obj/item/holder/rat/brown

/mob/living/simple_animal/mouse/rat/brown/Old_Timmy
	name = "Old Timmy"
	desc = "An ancient looking rat from the old days of the colony."
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "splats"
	holder_type = /obj/item/holder/rat/brown/Old_Timmy

/mob/living/simple_animal/mouse/rat/black
	body_color = "black"
	icon_state = "rat_black"
	holder_type = /obj/item/holder/rat/black

/mob/living/simple_animal/mouse/rat/white
	body_color = "white"
	icon_state = "rat_white"
	desc = "It's a small laboratory rat."
	holder_type = /obj/item/holder/rat/white

/mob/living/simple_animal/mouse/rat/white/Milky
	name = "Milky"
	desc = "An escaped test rat from the Weyland-Yutani Research Facility. Hope it doesn't have some sort of genetically engineered disease or something..."
	gender = MALE
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "stamps on"
	holder_type = /obj/item/holder/rat/white/Milky


//Specific Pets for Frozen's Rat Collecting Competition

/mob/living/simple_animal/mouse/rat/pet
	name = "Pet Rat"
	desc = "This is someone's pet rat. I wonder what it's doing here."
	holder_type = /obj/item/holder/rat/pet

/mob/living/simple_animal/mouse/rat/pet/marvin
	name = "Marvin"
	desc = "A sleek well kept rat with a tiny collar around its neck, it must belong to someone. For a rodent it appears remarkably clean and hygenic."
	body_color = "black"
	icon_state = "rat_black"
	holder_type = /obj/item/holder/rat/pet/marvin

/mob/living/simple_animal/mouse/rat/pet/ikit
	name = "Ikit"
	desc = "An albino rat with a tiny collar around its neck, it must belong to someone. Hope it doesn't have some sort of genetically engineered disease or something..."
	body_color = "white"
	icon_state = "rat_white"
	holder_type = /obj/item/holder/rat/pet/ikit


//Spawning those rats from cheese.

/obj/item/reagent_container/food/snacks/cheesewedge/attack_self(mob/user)
	if(user.mob_flags & HAS_SPAWNED_PET)
		return ..()
	if(GLOB.community_awards[user.ckey])
		for(var/award in GLOB.community_awards[user.ckey])
			if(award == "RatKing")
				return spawn_pet_rat(user)
	..()

/obj/item/reagent_container/food/snacks/cheesewedge/proc/spawn_pet_rat(mob/user)
	if(user.mob_flags & HAS_SPAWNED_PET)
		return FALSE
	if(tgui_alert(user, "Do you want to spawn your pet rat?", "Spawn Pet", list("Yes", "No")) != "Yes")
		return FALSE

	var/list/pet_rats = file2list("config/pet_rats.txt")
	var/rat_path
	for(var/rat_owner in pet_rats)
		if(!length(rat_owner))
			return FALSE
		if(copytext(rat_owner,1,2) == "#")
			continue

		//Split the line at every "-"
		var/list/split_rat_owner = splittext(rat_owner, " - ")
		if(!length(split_rat_owner))
			return FALSE

		//ckey is before the first "-"
		var/ckey = ckey(split_rat_owner[1])
		if(!ckey || (ckey != user.ckey))
			continue

		if(length(split_rat_owner) >= 2)
			rat_path = split_rat_owner[2]
			break

	if(!rat_path)
		return FALSE

	new rat_path(user.loc)
	user.mob_flags |= HAS_SPAWNED_PET
