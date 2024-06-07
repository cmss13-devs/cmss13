
/obj/item/limb
	icon = 'icons/mob/humans/species/r_human.dmi'
	///Predators can flay limbs to eventually turn them into bones for their armor
	var/flayed = FALSE
	///What bone would be in this limb?
	var/bone_type

/obj/item/limb/New(loc, mob/living/carbon/human/H)
	..(loc)
	if(!istype(H))
		return

	//Forming icon for the limb

	//Setting base icon for this mob's race
	var/icon/base
	if(H.species && H.species.icobase)
		base = icon(H.species.icobase)
	else
		base = icon('icons/mob/humans/species/r_human.dmi')


	icon = base
	var/datum/skin_color/set_skin_color = GLOB.skin_color_list[H.skin_color]
	var/datum/body_type/set_body_type = GLOB.body_type_list[H.body_type]
	var/datum/body_size/set_body_size = GLOB.body_size_list[H.body_size]

	var/skin_color_icon
	var/body_type_icon
	var/body_size_icon

	if(!set_skin_color)
		skin_color_icon = "pale2"
	else
		skin_color_icon = set_skin_color.icon_name

	if(!set_body_type)
		body_type_icon = "lean"
	else
		body_type_icon = set_body_type.icon_name

	if(!set_body_size)
		body_size_icon = "avg"
	else
		body_size_icon = set_body_size.icon_name

	if(isspeciesyautja(H))
		skin_color_icon = H.skin_color
		body_type_icon = H.body_type

	icon_state = "[get_limb_icon_name(H.species, body_size_icon, body_type_icon, H.gender, name, skin_color_icon)]"
	setDir(SOUTH)
	apply_transform(turn(transform, rand(70,130)))



/obj/item/limb/arm/l_arm
	name = "left arm"
	icon_state = "l_arm"
	bone_type = /obj/item/clothing/accessory/limb/skeleton/l_arm
/obj/item/limb/foot/l_foot
	name = "left foot"
	icon_state = "l_foot"
	bone_type = /obj/item/clothing/accessory/limb/skeleton/l_foot
/obj/item/limb/hand/l_hand
	name = "left hand"
	icon_state = "l_hand"
	bone_type = /obj/item/clothing/accessory/limb/skeleton/l_hand
/obj/item/limb/leg/l_leg
	name = "left leg"
	icon_state = "l_leg"
	bone_type = /obj/item/clothing/accessory/limb/skeleton/l_leg
/obj/item/limb/arm/r_arm
	name = "right arm"
	icon_state = "r_arm"
	bone_type = /obj/item/clothing/accessory/limb/skeleton/r_arm
/obj/item/limb/foot/r_foot
	name = "right foot"
	icon_state = "r_foot"
	bone_type = /obj/item/clothing/accessory/limb/skeleton/r_foot
/obj/item/limb/hand/r_hand
	name = "right hand"
	icon_state = "r_hand"
	bone_type = /obj/item/clothing/accessory/limb/skeleton/r_hand
/obj/item/limb/leg/r_leg
	name = "right leg"
	icon_state = "r_leg"
	bone_type = /obj/item/clothing/accessory/limb/skeleton/r_leg

/obj/item/limb/head
	name = "head"
	icon_state = "head_m"
	bone_type = /obj/item/clothing/accessory/limb/skeleton/head
	unacidable = TRUE
	var/mob/living/brain/brainmob
	var/brain_op_stage = 0
	var/brain_item_type = /obj/item/organ/brain
	var/brain_mob_type = /mob/living/brain
	var/braindeath_on_decap = 1 //whether the brainmob dies when head is decapitated (used by synthetics)

/obj/item/limb/head/New(loc, mob/living/carbon/human/H, cause = "decapitation")
	if(istype(H))
		src.icon_state = H.gender == MALE? "head_m" : "head_f"
	..()

	if(!H)
		return

	//Add (facial) hair.
	if(H.f_style)
		var/datum/sprite_accessory/facial_hair_style = GLOB.facial_hair_styles_list[H.f_style]
		if(facial_hair_style)
			var/icon/facial = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			if(facial_hair_style.do_coloration)
				facial.Blend(rgb(H.r_facial, H.g_facial, H.b_facial), ICON_ADD)

			overlays.Add(facial) // icon.Blend(facial, ICON_OVERLAY)

	if(H.h_style && !(H.head && (H.head.flags_inv_hide & HIDETOPHAIR)))
		var/datum/sprite_accessory/hair_style = GLOB.hair_styles_list[H.h_style]
		if(hair_style)
			var/icon/hair = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			var/icon/eyes = new/icon("icon" = 'icons/mob/humans/onmob/human_face.dmi', "icon_state" = H.species ? H.species.eyes : "eyes_s")
			if(hair_style.do_coloration)
				hair.Blend(rgb(H.r_hair, H.g_hair, H.b_hair), ICON_ADD)
				eyes.Blend(rgb(H.r_eyes, H.g_eyes, H.b_eyes), ICON_ADD)

			overlays.Add(hair) //icon.Blend(hair, ICON_OVERLAY)
			overlays.Add(eyes) //icon.Blend(hair, ICON_OVERLAY)

	if(H.lip_style && (H.species && H.species.flags & HAS_LIPS))
		var/icon/lipstick = new/icon('icons/mob/humans/onmob/human_face.dmi', "paint_[H.lip_style]")
		overlays += lipstick

	if(brainmob && brainmob.client)
		brainmob.client.screen.len = null //clear the hud

	transfer_identity(H)

	name = "[H.real_name]'s head"

	H.regenerate_icons()

	if(braindeath_on_decap)
		brainmob.timeofdeath = world.time
		brainmob.set_stat(DEAD)
		brainmob.death(cause)

	GLOB.head_limb_list += src

/obj/item/limb/head/Destroy()
	brainmob = null
	GLOB.head_limb_list -= src
	return ..()

/obj/item/limb/head/proc/transfer_identity(mob/living/carbon/human/H)//Same deal as the regular brain proc. Used for human-->head
	brainmob = new brain_mob_type(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.blood_type = H.blood_type
	if(H.mind && !iszombie(H))
		H.mind.transfer_to(brainmob)
	brainmob.container = src

/obj/item/limb/head/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/tool/surgery/scalpel))
		switch(brain_op_stage)
			if(0)
				user.visible_message(SPAN_WARNING("[brainmob] is beginning to have \his head cut open with [W] by [user]."), \
									SPAN_WARNING("You cut [brainmob]'s head open with [W]!"))
				to_chat(brainmob, SPAN_WARNING("[user] begins to cut open your head with [W]!"))

				brain_op_stage = 1

			if(2)
				user.visible_message(SPAN_WARNING("[brainmob] is having \his connections to the brain delicately severed with [W] by [user]."), \
									SPAN_WARNING("You cut [brainmob]'s head open with [W]!"))
				to_chat(brainmob, SPAN_WARNING("[user] begins to cut open your head with [W]!"))

				brain_op_stage = 3
			else
				..()
	else if(istype(W,/obj/item/tool/surgery/circular_saw))
		switch(brain_op_stage)
			if(1)
				user.visible_message(SPAN_WARNING("[brainmob] has \his head sawed open with [W] by [user]."), \
							SPAN_WARNING("You saw [brainmob]'s head open with [W]!"))
				to_chat(brainmob, SPAN_WARNING("[user] saw open your head with [W]!"))
				brain_op_stage = 2
			if(3)
				user.visible_message(SPAN_WARNING("[brainmob] has \his spine's connection to the brain severed with [W] by [user]."), \
									SPAN_WARNING("You sever [brainmob]'s brain's connection to the spine with [W]!"))
				to_chat(brainmob, SPAN_WARNING("[user] severs your brain's connection to the spine with [W]!"))

				user.attack_log += "\[[time_stamp()]\]<font color='red'> Debrained [brainmob.name] ([brainmob.ckey]) with [W.name] (INTENT: [uppertext(intent_text(user.a_intent))])</font>"
				brainmob.attack_log += "\[[time_stamp()]\]<font color='orange'> Debrained by [user.name] ([user.ckey]) with [W.name] (INTENT: [uppertext(intent_text(user.a_intent))])</font>"
				msg_admin_attack("[user] ([user.ckey]) debrained [brainmob] ([brainmob.ckey]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

				//TODO: ORGAN REMOVAL UPDATE.
				var/obj/item/organ/brain/B = new brain_item_type(loc)
				if(brainmob.stat != DEAD)
					brainmob.death(create_cause_data("brain extraction", user)) //brain mob doesn't survive outside a head
				B.transfer_identity(brainmob)

				brain_op_stage = 4
			else
				..()
	else
		..()


//synthetic head, allowing brain mob inside to talk
/obj/item/limb/head/synth
	name = "synthetic head"
	brain_item_type = /obj/item/organ/brain/prosthetic
	brain_mob_type = /mob/living/brain/synth
	braindeath_on_decap = 0

/obj/item/limb/head/synth/Initialize()
	. = ..()
	flags_atom |= USES_HEARING

//as ugly and painful as it is to write, the synth can still be revived, and mind needs to be updated if ghosted
/obj/item/limb/head/synth/transfer_identity(mob/living/carbon/human/H)
	..()
	if(!brainmob.mind)
		for(var/mob/dead/observer/G in GLOB.observer_list)
			if(istype(G) && G.mind && G.mind.original == H && G.can_reenter_corpse)
				G.mind.original = brainmob
				break

#ifdef OBJECTS_PROXY_SPEECH
// Transfers speech to synth brainmob (ie the player)
/obj/item/limb/head/synth/hear_talk(mob/living/sourcemob, message, verb, language, italics)
	if(istype(brainmob))
		proxy_object_heard(src, sourcemob, brainmob, message, verb, language, italics)
	else
		..(sourcemob, message, verb, language, italics)
#endif // ifdef OBJECTS_PROXY_SPEECH
