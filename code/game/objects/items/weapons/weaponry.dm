/obj/item/weapon/banhammer
	desc = "A banhammer"
	name = "banhammer"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "toyhammer"
	flags_equip_slot = SLOT_WAIST
	throwforce = 0
	w_class = SIZE_SMALL
	throw_speed = SPEED_VERY_FAST
	throw_range = 15
	attack_verb = list("banned")

/obj/item/weapon/nullrod
	name = "null rod"
	desc = "A rod of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomena."
	icon_state = "nullrod"
	item_state = "nullrod"
	flags_equip_slot = SLOT_WAIST
	force = 15
	throw_speed = SPEED_FAST
	throw_range = 4
	throwforce = 10
	w_class = SIZE_SMALL

/obj/item/weapon/harpoon
	name = "harpoon"
	sharp = IS_SHARP_ITEM_SIMPLE
	edge = 0
	desc = "Tharr she blows!"
	icon_state = "harpoon"
	item_state = "harpoon"
	force = 20
	throwforce = 15
	w_class = SIZE_MEDIUM
	attack_verb = list("jabbed","stabbed","ripped")

/obj/item/weapon/ice_axe
	name = "ice axe"
	desc = "For climbing, mostly. Makes for a good improvised weapon."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "ice_axe"
	item_state = "ice_axe"
	sharp = IS_SHARP_ITEM_ACCURATE
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_SMALL
	force = 25
	throw_speed = SPEED_FAST
	throw_range = 2
	throwforce = 40

/obj/item/weapon/ice_axe/red
	icon_state = "ice_axe_red"

/obj/item/weapon/ice_axe/green
	icon_state = "ice_axe_green"

/obj/item/weapon/baseballbat
	name = "\improper wooden baseball bat"
	desc = "A large wooden baseball bat. Commonly used in colony recreation, but also used as a means of self defense. Often carried by thugs and ruffians."
	icon_state = "woodbat"
	item_state = "woodbat"
	sharp = 0
	edge = 0
	w_class = SIZE_MEDIUM
	force = MELEE_FORCE_NORMAL
	throw_speed = SPEED_VERY_FAST
	throw_range = 7
	throwforce = 7
	attack_verb = list("smashed", "beaten", "slammed", "struck", "smashed", "battered", "cracked")
	hitsound = 'sound/weapons/genhit3.ogg'

/obj/item/weapon/baseballbat/metal
	name = "\improper metal baseball bat"
	desc = "A large metal baseball bat. Compared to its wooden cousin, the metal bat offers a bit more more force. Often carried by thugs and ruffians."
	icon_state = "metalbat"
	item_state = "metalbat"
	force = MELEE_FORCE_STRONG
	w_class = SIZE_MEDIUM



/obj/item/weapon/butterfly
	name = "butterfly knife"
	desc = "A basic metal blade concealed in a lightweight plasteel grip. Small enough when folded to fit in a pocket."
	icon_state = "butterflyknife"
	item_state = null
	hitsound = null
	var/active = 0
	w_class = SIZE_TINY
	force = MELEE_FORCE_WEAK
	sharp = 0
	edge = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 4
	throwforce = 7
	attack_verb = list("patted", "tapped")
	attack_speed = 10


/obj/item/weapon/butterfly/attack_self(mob/user)
	..()

	active = !active
	if(active)
		to_chat(user, SPAN_NOTICE("You flip out your [src]."))
		playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
		force = MELEE_FORCE_STRONG //bay adjustments
		throwforce = MELEE_FORCE_NORMAL
		edge = 1
		sharp = IS_SHARP_ITEM_ACCURATE
		hitsound = 'sound/weapons/bladeslice.ogg'
		icon_state += "_open"
		w_class = SIZE_MEDIUM
		attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	else
		to_chat(user, SPAN_NOTICE("[src] can now be concealed."))
		force = initial(force)
		edge = 0
		sharp = 0
		hitsound = initial(hitsound)
		icon_state = initial(icon_state)
		w_class = initial(w_class)
		attack_verb = initial(attack_verb)
		add_fingerprint(user)

/obj/item/weapon/butterfly/switchblade
	name = "switchblade"
	desc = "A classic switchblade with gold engraving. Just holding it makes you feel like a gangster."
	icon_state = "switchblade"

/obj/item/weapon/butterfly/katana
	name = "katana"
	desc = "A ancient weapon from Japan."
	icon_state = "samurai"
	force = MELEE_FORCE_VERY_STRONG

/obj/item/weapon/wirerod
	name = "wired rod"
	desc = "A rod with some wire wrapped around the top. It'd be easy to attach something to the top bit."
	icon_state = "wiredrod"
	item_state = "rods"
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT
	force = MELEE_FORCE_WEAK
	throwforce = MELEE_FORCE_WEAK
	w_class = SIZE_MEDIUM
	attack_verb = list("hit", "bludgeoned", "whacked", "bonked")

/obj/item/weapon/wirerod/attackby(obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/shard))
		var/obj/item/weapon/twohanded/spear/S = new /obj/item/weapon/twohanded/spear

		user.put_in_hands(S)
		to_chat(user, SPAN_NOTICE("You fasten the glass shard to the top of the rod with the cable."))
		qdel(I)
		qdel(src)
		update_icon(user)

	else if(HAS_TRAIT(I, TRAIT_TOOL_WIRECUTTERS))
		var/obj/item/weapon/baton/cattleprod/P = new /obj/item/weapon/baton/cattleprod

		user.put_in_hands(P)
		to_chat(user, SPAN_NOTICE("You fasten the wirecutters to the top of the rod with the cable, prongs outward."))
		qdel(I)
		qdel(src)
		update_icon(user)
	update_icon(user)


/obj/item/weapon/sword/katana/sharp
	name = "absurdly sharp katana"
	desc = "<p>That's it. I'm sick of all this \"Masterwork Bastard Sword\" bullshit that's going on in CM-SS13 right now. Katanas deserve much better than that. Much, much better than that.</p>\
<p>I should know what I'm talking about. I myself commissioned a genuine katana in Japan for 2,400,000 Yen (that's about $20,000) and have been practicing with it for almost 2 years now. I can even cut slabs of solid steel with my katana.</p>\
<p>Japanese smiths spend years working on a single katana and fold it up to a million times to produce the finest blades known to mankind.</p>\
<p>Katanas are thrice as sharp as European swords and thrice as hard for that matter too. Anything a longsword can cut through, a katana can cut through better. I'm pretty sure a katana could easily bisect a knight wearing full plate with a simple vertical slash.</p>\
<p>Ever wonder why medieval Europe never bothered conquering Japan? That's right, they were too scared to fight the disciplined Samurai and their katanas of destruction. Even in World War II, American soldiers targeted the men with the katanas first because their killing power was feared and respected.</p>"
	icon_state = "katana"
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT
	force = 4444
	throwforce = MELEE_FORCE_VERY_STRONG
	sharp = IS_SHARP_ITEM_BIG
	edge = 1
	w_class = SIZE_MEDIUM
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_speed = 1

	var/kill_delay = 25
	var/number_of_cuts = 8
	var/list/already_dead = list()

	attack_verb = list("sliced", "diced", "cut")

/obj/item/weapon/sword/katana/sharp/attack(mob/living/M, mob/living/user)

	if(flags_item & NOBLUDGEON)
		return

	if (!istype(M)) // not sure if this is the right thing...
		return 0

	if( (M in already_dead) || (M.stat == DEAD) )
		to_chat(user, "[M] is already dead.")
		return 0

	already_dead += M
	spawn(kill_delay)
		already_dead -= M

	/////////////////////////
	M.last_damage_data = create_cause_data(initial(name), user)

	user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [key_name(M)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYE: [uppertext(damtype)])</font>"
	M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [key_name(user)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYE: [uppertext(damtype)])</font>"
	msg_admin_attack("[key_name(user)] attacked [key_name(M)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYE: [uppertext(damtype)]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

	/////////////////////////

	add_fingerprint(user)

	var/power = force
	if(user.skills)
		power = floor(power * (1 + 0.3*user.skills.get_skill_level(SKILL_MELEE_WEAPONS))) //30% bonus per melee level


	//if the target also has a katana (and we aren't attacking ourselves), we add some suspense
	if( ( istype(M.get_active_hand(), /obj/item/weapon/sword/katana) || istype(M.get_inactive_hand(), /obj/item/weapon/sword/katana) ) && M != user )

		if(prob(50))
			user.visible_message(SPAN_DANGER("[M] and [user] cross blades!"))
		else
			M.visible_message(SPAN_DANGER("[user] and [M] cross blades!"))
		playsound(user, 'sound/weapons/bladeslice.ogg', 25, 1)
		playsound(M, 'sound/weapons/bladeslice.ogg', 25, 1)
		user.animation_attack_on(M)
		user.flick_attack_overlay(M, "punch")
		M.animation_attack_on(user)
		M.flick_attack_overlay(user, "punch")
		spawn(5)
			user.apply_effect((kill_delay-5)/15, STUN)
			M.apply_effect((kill_delay-5)/15, STUN)

	else //No katana

		var/showname = "."
		if(user)
			showname = " by [user]."
		if(!(user in viewers(M, null)))
			showname = "."

		var/used_verb = "attacked"
		if(attack_verb && attack_verb.len)
			used_verb = pick(attack_verb)
		user.visible_message(SPAN_DANGER("[M] has been [used_verb] with [src][showname]."),\
						SPAN_DANGER("You [used_verb] [M] with [src]."), null, 5)

		playsound(loc, 'sound/weapons/bladeslice.ogg', 25, 1)
		user.animation_attack_on(M)
		user.flick_attack_overlay(M, "punch")

		M.apply_effect(kill_delay/15, STUN)


	for (var/mob/O in hearers(GLOB.world_view_size, M))
		O << sound('sound/effects/Heart Beat.ogg', repeat = 1, wait = 0, volume = 100, channel = 2) //play on same channel as ambience
		spawn(kill_delay)
			O << sound(, , , , channel = 2) //cut sound


	spawn(kill_delay) //OMAE WA MOU SHINDEIRU

		playsound(M, 'sound/effects/bone_break1.ogg', 100, 1)

		for(var/i=1, i <= number_of_cuts, i++)
			var/def_zone = pick("head","l_leg","l_foot","r_leg","r_foot","l_arm","l_hand","r_arm","r_hand")
			switch(damtype)
				if("brute")
					M.apply_damage(power,BRUTE,def_zone)
				if("fire")
					M.apply_damage(power,BURN,def_zone)

	return 1
