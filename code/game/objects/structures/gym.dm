/obj/structure/punching_bag
	name = "punching bag"
	desc = "A punching bag. Can you get to speed level 4???"
	icon = 'icons/obj/structures/fitness.dmi'
	icon_state = "punchingbag"
	anchored = TRUE
	layer = WALL_OBJ_LAYER
	var/list/hit_sounds = list('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg',\
	'sound/weapons/punch1.ogg', 'sound/weapons/punch2.ogg', 'sound/weapons/punch3.ogg', 'sound/weapons/punch4.ogg')

/obj/structure/punching_bag/attack_hand(mob/user)
	if(!ishuman(user))
		return
	flick("[icon_state]2", src)
	playsound(loc, pick(hit_sounds), 25, TRUE, 3)


/obj/structure/weightmachine
	name = "weight machine"
	desc = "Just looking at this thing makes you feel tired."
	density = TRUE
	anchored = TRUE
	var/inuse_stun_time = 7 SECONDS
	var/icon_state_inuse

/obj/structure/weightmachine/proc/AnimateMachine(mob/living/user)
	return

/obj/structure/weightmachine/attack_hand(mob/living/user)
	if(!ishuman(user))
		return
	if(in_use)
		to_chat(user, "It's already in use - wait a bit.")
		return
	else
		in_use = TRUE
		icon_state = icon_state_inuse
		user.setDir(SOUTH)
		user.Stun(inuse_stun_time / GLOBAL_STATUS_MULTIPLIER)
		user.forceMove(src.loc)
		var/bragmessage = pick("pushing it to the limit","going into overdrive","burning with determination","rising up to the challenge", "getting strong now","getting ripped")
		user.visible_message("<B>[user] is [bragmessage]!</B>")
		AnimateMachine(user)

		playsound(user, 'sound/machines/click.ogg', 40, TRUE, 2)
		in_use = FALSE
		user.pixel_y = 0
		var/finishmessage = pick("You feel stronger!","You feel like you can take on the world!","You feel robust!","You feel indestructible!")
		icon_state = initial(icon_state)
		to_chat(user, finishmessage)

/obj/structure/weightmachine/stacklifter
	icon = 'icons/obj/structures/fitness.dmi'
	icon_state = "fitnesslifter"
	icon_state_inuse = "fitnesslifter2"
	inuse_stun_time = 5.5 SECONDS

/obj/structure/weightmachine/stacklifter/AnimateMachine(mob/living/user)
	var/lifts = 0
	while(lifts++ < 6)
		if(user.loc != src.loc)
			break
		sleep(3)
		animate(user, pixel_y = -2, time = 3)
		sleep(3)
		animate(user, pixel_y = -4, time = 3)
		sleep(3)
		playsound(user, 'sound/effects/spring.ogg', 40, TRUE, 2)

/obj/structure/weightmachine/weightlifter
	icon = 'icons/obj/structures/fitness.dmi'
	icon_state = "fitnessweight"
	icon_state_inuse = "fitnessweight-c"
	inuse_stun_time = 7 SECONDS

/obj/structure/weightmachine/weightlifter/AnimateMachine(mob/living/user)
	var/mutable_appearance/swole_overlay = mutable_appearance(icon, "fitnessweight-w", ABOVE_MOB_LAYER)
	overlays += swole_overlay
	var/reps = 0
	user.pixel_y = 5
	while(reps++ < 6)
		if(user.loc != src.loc)
			break
		for(var/innerReps = max(reps, 1), innerReps > 0, innerReps--)
			sleep(3)
			animate(user, pixel_y = (user.pixel_y == 3) ? 5 : 3, time = 3)
		playsound(user, 'sound/effects/spring.ogg', 40, TRUE, 2)
	sleep(3)
	animate(user, pixel_y = 2, time = 3)
	sleep(3)
	overlays -= swole_overlay
