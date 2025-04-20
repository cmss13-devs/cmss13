
/obj/structure/mirror
	name = "mirror"
	desc = "Mirror mirror on the wall, who's the most robust of them all?"
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "mirror"
	density = FALSE
	anchored = TRUE
	var/shattered = 0

/obj/structure/mirror/attack_hand(mob/user as mob)

	if(shattered)
		return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		if(H.a_intent == INTENT_HARM)
			var/obj/limb/hand_target = H.get_limb(H.hand ? "l_hand" : "r_hand")
			if(shattered)
				playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 25, 1)
				user.visible_message(SPAN_DANGER("[user] punches [src], but it's already broken!"), SPAN_DANGER("You punch [src], but it's already broken!"))
				hand_target.take_damage(5)
				return
			if(prob(30) || H.species.can_shred(H))
				user.visible_message(SPAN_DANGER("[user] punches [src], smashing it!"), SPAN_DANGER("You punch [src], smashing it!"))
				shatter(user)
			else
				user.visible_message(SPAN_DANGER("[user] punches [src] and bounces off!"), SPAN_DANGER("You punch [src] and bounce off!"))
				hand_target.take_damage(5)
				playsound(loc, 'sound/effects/glassbash.ogg', 25, 1)
			return

		var/userloc = H.loc

		//see code/modules/mob/new_player/preferences.dm at approx line 545 for comments!
		//this is largely copypasted from there.

		//handle facial hair (if necessary)
		if(H.gender == MALE)
			var/list/species_facial_hair = list()
			if(H.species)
				for(var/i in GLOB.facial_hair_styles_list)
					var/datum/sprite_accessory/facial_hair/tmp_facial = GLOB.facial_hair_styles_list[i]
					if(H.species.name in tmp_facial.species_allowed)
						if(tmp_facial.selectable)
							species_facial_hair += i
			else
				species_facial_hair = GLOB.facial_hair_styles_list

			var/new_style = input(user, "Select a facial hair style", "Grooming")  as null|anything in species_facial_hair
			if(userloc != H.loc)
				return //no tele-grooming
			if(new_style)
				H.f_style = new_style

		//handle normal hair
		var/list/species_hair = list()
		if(H.species)
			for(var/i in GLOB.hair_styles_list)
				var/datum/sprite_accessory/hair/tmp_hair = GLOB.hair_styles_list[i]
				if(H.species.name in tmp_hair.species_allowed)
					if(tmp_hair.selectable)
						species_hair += i
		else
			species_hair = GLOB.hair_styles_list

		var/new_style = input(user, "Select a hair style", "Grooming")  as null|anything in species_hair
		if(userloc != H.loc)
			return //no tele-grooming
		if(new_style)
			H.h_style = new_style

		H.update_hair()


/obj/structure/mirror/proc/shatter(mob/living/carbon/human/user, grabbed = FALSE)
	shattered = TRUE
	icon_state = "mirror_broke"
	playsound(src, "shatter", 70, 1)
	desc = "Oh no, seven years of bad luck!"
	var/obj/item/shard/mirror_shard = new(loc)
	if(!user)
		return
	var/obj/limb/shard_target
	if(grabbed)
		shard_target = user.get_limb("head")
	else
		shard_target = user.get_limb(user.hand ? "l_hand" : "r_hand")
	shard_target.embed(mirror_shard)
	shard_target.take_damage(15)


/obj/structure/mirror/bullet_act(obj/projectile/Proj)
	if(prob(Proj.damage * 2))
		if(!shattered)
			shatter()
		else
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 25, 1)
	..()
	return 1


/obj/structure/mirror/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/grab))
		if(user.grab_level < GRAB_AGGRESSIVE)
			to_chat(user, SPAN_WARNING("You need a better grip to do that!"))
			return
		var/obj/item/grab/target_grab = I
		var/mob/living/carbon/human/target = target_grab.grabbed_thing
		var/obj/limb/head_target = target.get_limb("head")
		if(shattered)
			user.visible_message(SPAN_WARNING("[user] smashes [src] with [target]'s skull, but [src] is already broken!"), SPAN_WARNING("You smash [src] with [target]'s skull, but [src] is already broken!"))
			head_target.take_damage(5)
			playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 25, 1)
			return
		if(prob(30))
			user.visible_message(SPAN_WARNING("[user] smashes [src] with [target]'s skull, breaking [src]!"), SPAN_WARNING("You smash [src] with [target]'s skull, breaking [src]!"))
			shatter(target, TRUE)
			return
		user.visible_message(SPAN_WARNING("[user] smashes [src] with [target]'s skull!"), SPAN_WARNING("You smash [src] with [target]'s skull!"))
		head_target.take_damage(5)
		playsound(loc, 'sound/effects/Glasshit.ogg', 25, 1)
		return
	if(shattered)
		playsound(loc, 'sound/effects/hit_on_shattered_glass.ogg', 25, 1)
		user.visible_message(SPAN_WARNING("[user] hits [src] with [I],  but it's already broken!"), SPAN_WARNING("You hit [src] with [I], but it's already broken!"))
		return
	if(prob(I.force * I.demolition_mod * 2))
		user.visible_message(SPAN_WARNING("[user] smashes [src] with [I]!"), SPAN_WARNING("You smash [src] with [I]!"))
		shatter()
	else
		user.visible_message(SPAN_WARNING("[user] hits [src] with [I]!"), SPAN_WARNING("You hit [src] with [I]!"))
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 25, 1)

/obj/structure/mirror/attack_animal(mob/user as mob)
	if(!isanimal(user))
		return
	var/mob/living/simple_animal/M = user
	if(M.melee_damage_upper <= 0)
		return
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 25, 1)
		return
	user.visible_message(SPAN_DANGER("[user] smashes [src]!"))
	shatter()
