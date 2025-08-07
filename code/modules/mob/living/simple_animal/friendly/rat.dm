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

/mob/living/simple_animal/mouse/rat/white
	body_color = "white"
	icon_state = "rat_white"
	desc = "It's a small laboratory rat."
	holder_type = /obj/item/holder/rat/white

/mob/living/simple_animal/mouse/rat/gray
	body_color = "gray"
	icon_state = "rat_gray"
	holder_type = /obj/item/holder/rat/gray

/mob/living/simple_animal/mouse/rat/brown
	body_color = "brown"
	icon_state = "rat_brown"
	holder_type = /obj/item/holder/rat/brown
/mob/living/simple_animal/mouse/rat/black
	body_color = "black"
	icon_state = "rat_black"
	holder_type = /obj/item/holder/rat/black

/mob/living/simple_animal/mouse/rat/white/Milky
	name = "Milky"
	desc = "An escaped test rat from the Weyland-Yutani Research Facility. Hope it doesn't have some sort of genetically engineered disease or something..."
	gender = MALE
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "stamps on"
	holder_type = /obj/item/holder/rat/white/Milky

/mob/living/simple_animal/mouse/rat/brown/Old_Timmy
	name = "Old Timmy"
	desc = "An ancient looking rat from the old days of the colony."
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "splats"
	holder_type = /obj/item/holder/rat/brown/Old_Timmy
