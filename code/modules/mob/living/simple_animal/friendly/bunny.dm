//Bunny
/mob/living/simple_animal/bunny
	name = "bunny"
	desc = "A little white bunny rabbit. Likes carrots, allegedly."
	icon_state = "bunny"
	icon_living = "bunny"
	icon_dead = "bunny_dead"
	emote_hear = list("purrs", "hums", "squeaks")
	emote_see = list("flaps their ears", "sniffs")
	speak_chance = 1
	turns_per_move = 5
	meat_type = /obj/item/reagent_container/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	friendly = "nibbles"
	black_market_value = 50
	dead_black_market_value = 0

/mob/living/simple_animal/bunny/dave
	name = "Dave"
	desc = "Dave. The coolest bunny rabbit in town."
	icon_state = "dave"
	icon_living = "dave"
	icon_dead = "dave_dead"
