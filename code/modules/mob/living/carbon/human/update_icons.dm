/*
	Global associative list for caching humanoid icons.
	Index format m or f, followed by a string of 0 and 1 to represent bodyparts followed by husk fat hulk skeleton 1 or 0.
	TODO: Proper documentation
	icon_key is [species.race_key][g][husk][fat][hulk][skeleton][ethnicity]
*/
var/global/list/human_icon_cache = list()
var/global/list/tail_icon_cache = list()

/proc/overlay_image(icon,icon_state,color,flags)
	var/image/ret = image(icon,icon_state)
	ret.color = color
	ret.appearance_flags = flags
	return ret

/*
	Global associative list for caching uniform masks.
	Each index is just 0 or 1 for not removed and removed (as in previously delimbed).
*/
var/global/list/uniform_mask_cache = list()

	///////////////////////
	//UPDATE_ICONS SYSTEM//
	///////////////////////
/*

Another feature of this new system is that our lists are indexed. This means we can update specific overlays!
So we only regenerate icons when we need them to be updated! This is the main saving for this system.

In practice this means that:
	Everytime you do something minor like take a pen out of your pocket, we only update the in-hand overlay
	etc...


There are several things that need to be remembered:

>	Whenever we do something that should cause an overlay to update (which doesn't use standard procs
	( i.e. you do something like l_hand = /obj/item/something new(src) )
	You will need to call the relevant update_inv_* proc:
		update_inv_head()
		update_inv_wear_suit()
		update_inv_gloves()
		update_inv_shoes()
		update_inv_w_uniform()
		update_inv_glasse()
		update_inv_l_hand()
		update_inv_r_hand()
		update_inv_belt()
		update_inv_wear_id()
		update_inv_ears()
		update_inv_s_store()
		update_inv_pockets()
		update_inv_back()
		update_inv_handcuffed()
		update_inv_wear_mask()

	All of these are named after the variable they update from. They are defined at the mob/ level like
	update_clothing was, so you won't cause undefined proc runtimes with usr.update_inv_wear_id() if the usr is a
	corgi etc. Instead, it'll just return without doing any work. So no harm in calling it for corgis and such.


>	There are also these special cases:
		update_mutations()	//handles updating your appearance for certain mutations.  e.g TK head-glows
		UpdateDamageIcon()	//handles damage overlays for brute/burn damage //(will rename this when I geta round to it)
		update_body()	//Handles updating your mob's icon to reflect their gender/race/complexion etc
		update_hair()	//Handles updating your hair overlay (used to be update_face, but mouth and
																			...eyes were merged into update_body)
		update_targeted() // Updates the target overlay when someone points a gun at you

>	If you need to update all overlays you can use regenerate_icons(). it works exactly like update_clothing used to.


*/

//Human Overlays Indexes/////////
#define MUTANTRACE_LAYER		1
#define MUTATIONS_LAYER			2
#define DAMAGE_LAYER			3
#define UNIFORM_LAYER			4
#define TAIL_LAYER				5	//bs12 specific. this hack is probably gonna come back to haunt me
#define ID_LAYER				6
#define SHOES_LAYER				7
#define GLOVES_LAYER			8
#define MEDICAL_LAYER			9	//For splint and gauze overlays
#define SUIT_LAYER				10
#define SUIT_GARB_LAYER			11
#define SUIT_SQUAD_LAYER		12
#define GLASSES_LAYER			13
#define BELT_LAYER				14
#define SUIT_STORE_LAYER		15
#define BACK_LAYER				16
#define HAIR_LAYER				17
#define EARS_LAYER				18
#define FACEMASK_LAYER			19
#define HEAD_LAYER				20
#define HEAD_GARB_LAYER			21
#define HEAD_SQUAD_LAYER		22
#define COLLAR_LAYER			23
#define HANDCUFF_LAYER			24
#define LEGCUFF_LAYER			25
#define L_HAND_LAYER			26
#define R_HAND_LAYER			27
#define BURST_LAYER				28	//Chestburst overlay
#define TARGETED_LAYER			29	//for target sprites when held at gun point, and holo cards.
#define FIRE_LAYER				30	//If you're on fire		//BS12: Layer for the target overlay from weapon targeting system
#define TOTAL_LAYERS			30
//////////////////////////////////

/mob/living/carbon/human
	var/list/overlays_standing[TOTAL_LAYERS]
	var/previous_damage_appearance // store what the body last looked like, so we only have to update it if something changed

/mob/living/carbon/human/apply_overlay(cache_index)
	var/image/I = overlays_standing[cache_index]
	if(I)
		overlays += I

/mob/living/carbon/human/remove_overlay(cache_index)
	if(overlays_standing[cache_index])
		overlays -= overlays_standing[cache_index]
		overlays_standing[cache_index] = null

//UPDATES OVERLAYS FROM OVERLAYS_LYING/OVERLAYS_STANDING
/mob/living/carbon/human/update_icons()
	lying_prev = lying	//so we don't update overlays for lying/standing unless our stance changes again
	update_hud()		//TODO: remove the need for this
	overlays.Cut()

	var/list/overlays_to_apply = list()
	if (icon_update)

		var/list/visible_overlays
		icon = stand_icon
		icon_state = null
		visible_overlays = overlays_standing

		for(var/i = 1 to LAZYLEN(visible_overlays))
			var/entry = visible_overlays[i]
			if(istype(entry, /image))
				var/image/overlay = entry
				overlays_to_apply += overlay
			else if(istype(entry, /list))
				for(var/image/overlay in entry)
					overlays_to_apply += overlay

	overlays = overlays_to_apply

	var/matrix/M = matrix()
	if(lying && !species.prone_icon) //Only rotate them if we're not drawing a specific icon for being prone.
		M.Turn(90)
		M.Scale(size_multiplier)
		M.Translate(1,-6)
		src.transform = M
	else
		M.Scale(size_multiplier)
		M.Translate(0, 16*(size_multiplier-1))
		src.transform = M

var/global/list/damage_icon_parts = list()
/mob/living/carbon/human/proc/get_damage_icon_part(damage_state, datum/limb/limb)
	var/icon/DI
	var/L_name = limb.icon_name
	if(!damage_icon_parts["[damage_state]_[species.blood_color]_[L_name]"])
		var/brutestate = copytext(damage_state, 1, 2)
		var/burnstate = copytext(damage_state, 2)
		DI = new /icon('icons/mob/dam_human.dmi', "grayscale_[brutestate]")// the damage icon for whole human in grayscale
		DI.Blend(species.blood_color, ICON_MULTIPLY) //coloring with species' blood color
		DI.Blend(new /icon('icons/mob/dam_human.dmi', "burn_[burnstate]"), ICON_OVERLAY)//adding burns
		DI.Blend(new /icon('icons/mob/body_mask.dmi', L_name), ICON_MULTIPLY)		// mask with this organ's pixels
		damage_icon_parts["[damage_state]_[species.blood_color]_[L_name]"] = DI
	else
		DI = damage_icon_parts["[damage_state]_[species.blood_color]_[L_name]"]
	for(var/datum/wound/W in limb.wounds)
		if(W.impact_icon)
			DI.Blend(W.impact_icon, ICON_OVERLAY)

	return DI



//DAMAGE OVERLAYS
//constructs damage icon for each organ from mask * damage field and saves it in our overlays_ lists
/mob/living/carbon/human/UpdateDamageIcon()
	// first check whether something actually changed about damage appearance
	var/damage_appearance = ""

	for(var/datum/limb/O in limbs)
		if(O.status & LIMB_DESTROYED) damage_appearance += "d"
		else
			damage_appearance += O.damage_state

	if(damage_appearance == previous_damage_appearance)
		// nothing to do here
		return

	remove_overlay(DAMAGE_LAYER)

	previous_damage_appearance = damage_appearance

	var/icon/standing = new /icon('icons/mob/dam_human.dmi', "00")

	var/image/standing_image = new /image(icon = standing, layer = -DAMAGE_LAYER)

	// blend the individual damage states with our icons
	for(var/datum/limb/O in limbs)
		var/icon/DI
		var/datum/limb/P = O.parent
		if(!(O.status & LIMB_DESTROYED))
			O.update_icon()
			if(O.damage_state == "00") continue

			DI = get_damage_icon_part(O.damage_state, O)

			standing_image.overlays += DI
		else if(O.has_stump_icon && (!P || !(P.status & LIMB_DESTROYED)))
			DI = new /icon('icons/mob/dam_human.dmi', "stump_[O.icon_name]")

			standing_image.overlays += DI


	overlays_standing[DAMAGE_LAYER]	= standing_image

	apply_overlay(DAMAGE_LAYER)

//BASE MOB SPRITE
/mob/living/carbon/human/proc/update_body(var/update_icons = 1, var/force_cache_update = 0)
	var/husk_color_mod = rgb(96,88,80)
	var/hulk_color_mod = rgb(48,224,40)
	var/necrosis_color_mod = rgb(10,50,0)

	var/husk = (HUSK in src.mutations)
	var/fat = (FAT in src.mutations)
	var/hulk = (HULK in src.mutations)
	var/skeleton = (SKELETON in src.mutations)

	var/g = get_gender_name(gender)
	var/has_head = 0


	//CACHING: Generate an index key from visible bodyparts.
	//0 = destroyed, 1 = normal, 2 = robotic, 3 = necrotic.

	//Create a new, blank icon for our mob to use.
	if(stand_icon)
		qdel(stand_icon)

	stand_icon = new(species.icon_template ? species.icon_template : 'icons/mob/human.dmi',"blank")

	var/icon_key = "[species.race_key][g][ethnicity]"
	for(var/datum/limb/part in limbs)

		if(istype(part,/datum/limb/head) && !(part.status & LIMB_DESTROYED))
			has_head = 1

		if(part.status & LIMB_DESTROYED)
			icon_key = "[icon_key]0"
		else if(part.status & LIMB_ROBOT)
			icon_key = "[icon_key]2"
		else if(part.status & LIMB_NECROTIZED)
			icon_key = "[icon_key]3"
		else
			icon_key = "[icon_key]1"

	icon_key = "[icon_key][husk ? 1 : 0][fat ? 1 : 0][hulk ? 1 : 0][skeleton ? 1 : 0][ethnicity]"

	var/icon/base_icon
	if(!force_cache_update && human_icon_cache[icon_key])
		//Icon is cached, use existing icon.
		base_icon = human_icon_cache[icon_key]

		//log_debug("Retrieved cached mob icon ([icon_key] \icon[human_icon_cache[icon_key]]) for [src].")

	else

	//BEGIN CACHED ICON GENERATION.

		// Why don't we just make skeletons/shadows/golems a species? ~Z
		var/race_icon =   (skeleton ? 'icons/mob/human_races/r_skeleton.dmi' : species.icobase)
		var/deform_icon = (skeleton ? 'icons/mob/human_races/r_skeleton.dmi' : species.icobase)

		//Robotic limbs are handled in get_icon() so all we worry about are missing or dead limbs.
		//No icon stored, so we need to start with a basic one.
		var/datum/limb/chest = get_limb("chest")
		base_icon = chest.get_icon(race_icon,deform_icon,g)

		if(chest.status & LIMB_NECROTIZED)
			base_icon.ColorTone(necrosis_color_mod)
			base_icon.SetIntensity(0.7)

		for(var/datum/limb/part in limbs)

			var/icon/temp //Hold the bodypart icon for processing.

			if(part.status & LIMB_DESTROYED)
				continue

			if(istype(part, /datum/limb/chest)) //already done above
				continue

			if (istype(part, /datum/limb/groin) || istype(part, /datum/limb/head))
				temp = part.get_icon(race_icon,deform_icon,g)
			else
				temp = part.get_icon(race_icon,deform_icon)

			if(part.status & LIMB_NECROTIZED)
				temp.ColorTone(necrosis_color_mod)
				temp.SetIntensity(0.7)

			//That part makes left and right legs drawn topmost and lowermost when human looks WEST or EAST
			//And no change in rendering for other parts (they icon_position is 0, so goes to 'else' part)
			if(part.icon_position&(LEFT|RIGHT))

				var/icon/temp2 = new('icons/mob/human.dmi',"blank")

				temp2.Insert(new/icon(temp,dir=NORTH),dir=NORTH)
				temp2.Insert(new/icon(temp,dir=SOUTH),dir=SOUTH)

				if(!(part.icon_position & LEFT))
					temp2.Insert(new/icon(temp,dir=EAST),dir=EAST)

				if(!(part.icon_position & RIGHT))
					temp2.Insert(new/icon(temp,dir=WEST),dir=WEST)

				base_icon.Blend(temp2, ICON_OVERLAY)

				if(part.icon_position & LEFT)
					temp2.Insert(new/icon(temp,dir=EAST),dir=EAST)

				if(part.icon_position & RIGHT)
					temp2.Insert(new/icon(temp,dir=WEST),dir=WEST)

				base_icon.Blend(temp2, ICON_UNDERLAY)

			else

				base_icon.Blend(temp, ICON_OVERLAY)

		if(!skeleton)
			if(husk)
				base_icon.ColorTone(husk_color_mod)
			else if(hulk)
				var/list/tone = ReadRGB(hulk_color_mod)
				base_icon.MapColors(rgb(tone[1],0,0),rgb(0,tone[2],0),rgb(0,0,tone[3]))

		//Handle husk overlay.
		if(husk)
			var/icon/mask = new(base_icon)
			var/icon/husk_over = new(race_icon,"overlay_husk")
			mask.MapColors(0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,0)
			husk_over.Blend(mask, ICON_ADD)
			base_icon.Blend(husk_over, ICON_OVERLAY)


		human_icon_cache[icon_key] = base_icon

		//log_debug("Generated new cached mob icon ([icon_key] \icon[human_icon_cache[icon_key]]) for [src]. [human_icon_cache.len] cached mob icons.")

	//END CACHED ICON GENERATION.

	stand_icon.Blend(base_icon,ICON_OVERLAY)

	/*
	//Skin colour. Not in cache because highly variable (and relatively benign).
	if (species.flags & HAS_SKIN_COLOR)
		stand_icon.Blend(rgb(r_skin, g_skin, b_skin), ICON_ADD)
	*/

	if(has_head)
		//Eyes
		if(!skeleton)
			var/icon/eyes = new/icon('icons/mob/human_face.dmi', species.eyes)
			eyes.Blend(rgb(r_eyes, g_eyes, b_eyes), ICON_ADD)
			stand_icon.Blend(eyes, ICON_OVERLAY)

		//Mouth	(lipstick!)
		if(lip_style && (species && species.flags & HAS_LIPS))	//skeletons are allowed to wear lipstick no matter what you think, agouri.
			stand_icon.Blend(new/icon('icons/mob/human_face.dmi', "camo_[lip_style]_s"), ICON_OVERLAY)


	if(species.flags & HAS_UNDERWEAR)

		//Underwear
		if(underwear >0 && underwear < 3)
			if(!fat && !skeleton)
				var/icon/underwear_icon = new /icon('icons/mob/human.dmi', "cryo[underwear]_[g]_s")
				var/icon/BM = new /icon(icon = 'icons/mob/body_mask.dmi', icon_state = "groin")
				BM.Blend(new /icon('icons/mob/body_mask.dmi', "torso"), ICON_OR)
				for(var/datum/limb/leg/L in limbs)
					var/uniform_icon = "[L.icon_name]"
					if(L.status & LIMB_DESTROYED && !(L.status & LIMB_AMPUTATED))
						uniform_icon += "_removed"
					BM.Blend(new /icon('icons/mob/body_mask.dmi', "[uniform_icon]"), ICON_OR)
				underwear_icon.Blend(BM, ICON_MULTIPLY)
				stand_icon.Blend(underwear_icon, ICON_OVERLAY)

		if(job in ROLES_MARINES) //undoing override
			if(undershirt>0 && undershirt < 5)
				stand_icon.Blend(new /icon('icons/mob/human.dmi', "cryoshirt[undershirt]_s"), ICON_OVERLAY)
		else if(undershirt>0 && undershirt < 5)
			stand_icon.Blend(new /icon('icons/mob/human.dmi', "cryoshirt[undershirt]_s"), ICON_OVERLAY)

	icon = stand_icon

	//tail
	update_tail_showing(0)

//HAIR OVERLAY
/mob/living/carbon/human/proc/update_hair()
	//Reset our hair
	remove_overlay(HAIR_LAYER)

	var/datum/limb/head/head_organ = get_limb("head")
	if( !head_organ || (head_organ.status & LIMB_DESTROYED) )
		return

	//masks and helmets can obscure our hair.
	if( (head && (head.flags_inv_hide & HIDEALLHAIR)) || (wear_mask && (wear_mask.flags_inv_hide & HIDEALLHAIR)))
		return

	//base icons
	var/icon/face_standing	= new /icon('icons/mob/human_hair.dmi',"bald_s")

	if(f_style && !(wear_suit && (wear_suit.flags_inv_hide & HIDELOWHAIR)) && !(wear_mask && (wear_mask.flags_inv_hide & HIDELOWHAIR)))
		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[f_style]
		if(facial_hair_style && facial_hair_style.species_allowed && src.species.name in facial_hair_style.species_allowed)
			var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			if(facial_hair_style.do_colouration)
				facial_s.Blend(rgb(r_facial, g_facial, b_facial), ICON_ADD)

			face_standing.Blend(facial_s, ICON_OVERLAY)

	if(h_style && !(head && (head.flags_inv_hide & HIDETOPHAIR)))
		var/datum/sprite_accessory/hair_style = hair_styles_list[h_style]
		if(hair_style && src.species.name in hair_style.species_allowed)
			var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			if(hair_style.do_colouration)
				hair_s.Blend(rgb(r_hair, g_hair, b_hair), ICON_ADD)

			face_standing.Blend(hair_s, ICON_OVERLAY)

	overlays_standing[HAIR_LAYER]	= image("icon"= face_standing, "layer" =-HAIR_LAYER)

	apply_overlay(HAIR_LAYER)


//Call when target overlay should be added/removed
/mob/living/carbon/human/update_targeted()
	remove_overlay(TARGETED_LAYER)
	var/image/I
	if (targeted_by && target_locked)
		I = image("icon" = target_locked, "layer" =-TARGETED_LAYER)
	else if (!targeted_by && target_locked)
		qdel(target_locked)
		target_locked = null
	if(holo_card_color)
		if(I)
			I.overlays += image("icon" = 'icons/effects/Targeted.dmi', "icon_state" = "holo_card_[holo_card_color]")
		else
			I = image("icon" = 'icons/effects/Targeted.dmi', "icon_state" = "holo_card_[holo_card_color]", "layer" =-TARGETED_LAYER)
	if(I)
		overlays_standing[TARGETED_LAYER] = I
	apply_overlay(TARGETED_LAYER)


//Call when someone is gauzed or splinted, or when one of those items are removed
/mob/living/carbon/human/update_med_icon()
	remove_overlay(MEDICAL_LAYER)

	var/icon/standing = new /icon('icons/mob/med_human.dmi', "blank")

	var/image/standing_image = new /image(icon = standing, layer = -MEDICAL_LAYER)

	// blend the individual damage states with our icons
	for(var/datum/limb/L in limbs)
		for(var/datum/wound/W in L.wounds)
			if(!W.bandaged)
				continue
			if(!W.bandaged_icon)
				var/bandaged_icon_name = "gauze_[L.icon_name]"
				if(L.bandage_icon_amount > 1)
					bandaged_icon_name += "_[rand(1, L.bandage_icon_amount)]"
				W.bandaged_icon = new /icon('icons/mob/med_human.dmi', "[bandaged_icon_name]")
			standing_image.overlays += W.bandaged_icon
		if(L.status & LIMB_SPLINTED)
			if(!L.splinted_icon)
				var/splinted_icon_name = "splint_[L.icon_name]"
				if(L.splint_icon_amount > 1)
					splinted_icon_name += "_[rand(1, L.splint_icon_amount)]"
				L.splinted_icon = new /icon('icons/mob/med_human.dmi', "[splinted_icon_name]")
			standing_image.overlays += L.splinted_icon
		else
			L.splinted_icon = null

	overlays_standing[MEDICAL_LAYER] = standing_image

	apply_overlay(MEDICAL_LAYER)


/* --------------------------------------- */
//For legacy support.
/mob/living/carbon/human/regenerate_icons()
	if(monkeyizing)		return
	update_mutations(0)
	update_inv_w_uniform(0)
	update_inv_wear_id(0)
	update_inv_gloves(0)
	update_inv_glasses(0)
	update_inv_ears(0)
	update_inv_shoes(0)
	update_inv_s_store(0)
	update_inv_wear_mask(0)
	update_inv_head(0)
	update_inv_belt(0)
	update_inv_back(0)
	update_inv_wear_suit(0)
	update_inv_r_hand(0)
	update_inv_l_hand(0)
	update_inv_handcuffed(0)
	update_inv_legcuffed(0)
	update_inv_pockets(0)
	update_fire(0)
	update_burst(0)
	UpdateDamageIcon(0)
	update_icons()
	update_hud()


/* --------------------------------------- */
//vvvvvv UPDATE_INV PROCS vvvvvv

/mob/living/carbon/human/update_inv_w_uniform(var/update_icons=1)
	if(istype(w_uniform, /obj/item/clothing/under) && !(wear_suit && wear_suit.flags_inv_hide & HIDEJUMPSUIT))
		overlays_standing[UNIFORM_LAYER] = w_uniform.get_mob_overlay(src, WEAR_UNIFORM)
	else
		overlays_standing[UNIFORM_LAYER] = null

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_wear_id(var/update_icons=1)
	var/image/id_overlay
	if(wear_id && istype(w_uniform, /obj/item/clothing/under))
		var/obj/item/clothing/under/U = w_uniform
		if(U.displays_id && !U.rolled_sleeves)
			id_overlay = wear_id.get_mob_overlay(src, WEAR_ID)

	overlays_standing[ID_LAYER]	= id_overlay

	if(update_icons)
		update_icons()


/mob/living/carbon/human/update_inv_gloves(var/update_icons=1)
	if(gloves && !(wear_suit && wear_suit.flags_inv_hide & HIDEGLOVES))
		overlays_standing[GLOVES_LAYER]	= gloves.get_mob_overlay(src, WEAR_GLOVES)
	else
		if(blood_DNA && species.blood_mask)
			var/image/bloodsies	= overlay_image(species.blood_mask, "bloodyhands", blood_color, RESET_COLOR)
			overlays_standing[GLOVES_LAYER]	= bloodsies
		else
			overlays_standing[GLOVES_LAYER]	= null
	if(update_icons)
		update_icons()


/mob/living/carbon/human/update_inv_glasses(var/update_icons=1)
	if(glasses)
		overlays_standing[GLASSES_LAYER] = glasses.get_mob_overlay(src, WEAR_GLASSES)
	else
		overlays_standing[GLASSES_LAYER] = null
	if(update_icons)
		update_icons()


/mob/living/carbon/human/update_inv_ears(var/update_icons=1)
	overlays_standing[EARS_LAYER] = null

	if(wear_ear)
		overlays_standing[EARS_LAYER] = wear_ear.get_mob_overlay(src, WEAR_EAR)
	else
		overlays_standing[EARS_LAYER] = null

	if(update_icons)
		update_icons()


/mob/living/carbon/human/update_inv_shoes(var/update_icons=1)
	if(shoes && !((wear_suit && wear_suit.flags_inv_hide & HIDESHOES) || (w_uniform && w_uniform.flags_inv_hide & HIDESHOES)))
		overlays_standing[SHOES_LAYER] = shoes.get_mob_overlay(src, WEAR_SHOES)
	else
		if(feet_blood_DNA && species.blood_mask)
			var/image/bloodsies = overlay_image(species.blood_mask, "shoeblood", feet_blood_color, RESET_COLOR)
			overlays_standing[SHOES_LAYER] = bloodsies
		else
			overlays_standing[SHOES_LAYER] = null
	if(update_icons)
		update_icons()


/mob/living/carbon/human/update_inv_s_store(var/update_icons=1)
	if(s_store)
		overlays_standing[SUIT_STORE_LAYER]	= s_store.get_mob_overlay(src, WEAR_S_STORE)
	else
		overlays_standing[SUIT_STORE_LAYER]	= null
	if(update_icons)
		update_icons()


/mob/living/carbon/human/update_inv_head(var/update_icons=1)
	if(head)
		overlays_standing[HEAD_LAYER] = head.get_mob_overlay(src, WEAR_HEAD)
		if(istype(head, /obj/item/clothing/head/helmet/marine))
			var/obj/item/clothing/head/helmet/marine/marine_helmet = head
			if(marine_helmet.flags_marine_helmet & HELMET_SQUAD_OVERLAY)
				if(assigned_squad)
					var/datum/squad/S = assigned_squad
					var/leader = S.squad_leader == src
					if(S.color <= helmetmarkings.len)
						overlays_standing[HEAD_SQUAD_LAYER] = leader? helmetmarkings_sql[S.color] : helmetmarkings[S.color]
			var/image/I
			for(var/i in marine_helmet.helmet_overlays)
				I = marine_helmet.helmet_overlays[i]
				if(I)
					overlays_standing[HEAD_GARB_LAYER] = image('icons/mob/helmet_garb.dmi',src,I.icon_state)
	else
		overlays_standing[HEAD_LAYER] = null
		overlays_standing[HEAD_SQUAD_LAYER] = null
		overlays_standing[HEAD_GARB_LAYER] = null

	if(update_icons)
		update_icons()


/mob/living/carbon/human/update_inv_belt(var/update_icons=1)
	if(belt)
		overlays_standing[BELT_LAYER] = belt.get_mob_overlay(src, WEAR_BELT)
	else
		overlays_standing[BELT_LAYER] = null
	if(update_icons)
		update_icons()


/mob/living/carbon/human/update_inv_wear_suit(var/update_icons=1)
	if(wear_suit)
		overlays_standing[SUIT_LAYER] = wear_suit.get_mob_overlay(src, WEAR_SUIT)
		if(istype(wear_suit, /obj/item/clothing/suit/storage/marine))
			var/obj/item/clothing/suit/storage/marine/marine_armor = wear_suit
			if(marine_armor.flags_marine_armor & ARMOR_SQUAD_OVERLAY)
				if(assigned_squad)
					var/datum/squad/S = assigned_squad
					var/leader = S.squad_leader == src
					if(S.color <= helmetmarkings.len)
						overlays_standing[SUIT_SQUAD_LAYER] = leader? armormarkings_sql[S.color] : armormarkings[S.color]

			if(marine_armor.armor_overlays.len)
				var/image/I
				for(var/i in marine_armor.armor_overlays)
					I = marine_armor.armor_overlays[i]
					if(I)
						overlays_standing[SUIT_GARB_LAYER] = image(I.icon,src,I.icon_state)
		update_tail_showing(0)
	else
		overlays_standing[SUIT_LAYER] = null
		overlays_standing[SUIT_SQUAD_LAYER] = null
		overlays_standing[SUIT_GARB_LAYER] = null
		update_tail_showing(0)
		update_inv_w_uniform(0)
		update_inv_shoes(0)
		update_inv_gloves(0)

	update_collar(0)

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_pockets(var/update_icons=1)
	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_wear_mask(var/update_icons=1)
	if(wear_mask && ( istype(wear_mask, /obj/item/clothing/mask) || istype(wear_mask, /obj/item/clothing/accessory) ) && !(head && head.flags_inv_hide & HIDEMASK))
		overlays_standing[FACEMASK_LAYER] = wear_mask.get_mob_overlay(src, WEAR_MASK)
	else
		overlays_standing[FACEMASK_LAYER] = null
	if(update_icons)
		update_icons()


/mob/living/carbon/human/update_inv_back(var/update_icons=1)
	if(back)
		overlays_standing[BACK_LAYER] = back.get_mob_overlay(src, WEAR_BACK)
	else
		overlays_standing[BACK_LAYER] = null

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_hud()
	if(client)
		client.screen |= contents
		if(hud_used)
			hud_used.hidden_inventory_update()
			hud_used.persistant_inventory_update()

/mob/living/carbon/human/update_inv_handcuffed(var/update_icons=1)
	if(handcuffed)
		overlays_standing[HANDCUFF_LAYER] = handcuffed.get_mob_overlay(src, WEAR_HANDCUFFS)
	else
		overlays_standing[HANDCUFF_LAYER] = null
	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_legcuffed(var/update_icons=1)
	if(legcuffed)
		overlays_standing[LEGCUFF_LAYER] = handcuffed.get_mob_overlay(src, WEAR_LEGCUFFS)
	else
		overlays_standing[LEGCUFF_LAYER] = null
	if(update_icons)
		update_icons()


/mob/living/carbon/human/update_inv_r_hand(var/update_icons=1)
	if(r_hand)
		var/image/standing = r_hand.get_mob_overlay(src, WEAR_R_HAND)
		if(standing)
			standing.appearance_flags |= RESET_ALPHA
		overlays_standing[R_HAND_LAYER] = standing

		if (handcuffed) drop_r_hand() //this should be moved out of icon code
	else
		overlays_standing[R_HAND_LAYER] = null

	if(update_icons)
		update_icons()


/mob/living/carbon/human/update_inv_l_hand(var/update_icons=1)
	if(l_hand)
		var/image/standing = l_hand.get_mob_overlay(src, WEAR_L_HAND)
		if(standing)
			standing.appearance_flags |= RESET_ALPHA
		overlays_standing[L_HAND_LAYER] = standing

		if (handcuffed) drop_l_hand() //This probably should not be here
	else
		overlays_standing[L_HAND_LAYER] = null

	if(update_icons)
		update_icons()


/mob/living/carbon/human/proc/update_tail_showing(var/update_icons=1)
	overlays_standing[TAIL_LAYER] = null

	var/species_tail = species.get_tail(src)

	if(species_tail && !(wear_suit && wear_suit.flags_inv_hide & HIDETAIL))
		var/icon/tail_s = get_tail_icon()
		overlays_standing[TAIL_LAYER] = image(tail_s, icon_state = "[species_tail]_s")

	if(update_icons)
		update_icons()

/mob/living/carbon/human/proc/get_tail_icon()
	var/icon_key = "[species.race_key][r_skin][g_skin][b_skin][r_hair][g_hair][b_hair]"
	var/icon/tail_icon = tail_icon_cache[icon_key]
	if(!tail_icon)
		//generate a new one
		tail_icon = icon('icons/effects/species.dmi', "[species.get_tail(src)]")
		tail_icon_cache[icon_key] = tail_icon

	return tail_icon

//Adds a collar overlay above the helmet layer if the suit has one
//	Suit needs an identically named sprite in icons/mob/collar.dmi
/mob/living/carbon/human/proc/update_collar(var/update_icons=1)
	if(istype(wear_suit,/obj/item/clothing/suit))
		var/obj/item/clothing/suit/S = wear_suit
		overlays_standing[COLLAR_LAYER]	= S.get_collar()
	else
		overlays_standing[COLLAR_LAYER]	= null

	if(update_icons)
		update_icons()



// Used mostly for creating head items
/mob/living/carbon/human/proc/generate_head_icon()
//gender no longer matters for the mouth, although there should probably be seperate base head icons.
//	var/g = "m"
//	if (gender == FEMALE)	g = "f"

	//base icons
	var/icon/face_lying	= new /icon('icons/mob/human_hair.dmi',"bald_l")

	if(f_style)
		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[f_style]
		if(facial_hair_style)
			var/icon/facial_l = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_l")
			facial_l.Blend(rgb(r_facial, g_facial, b_facial), ICON_ADD)
			face_lying.Blend(facial_l, ICON_OVERLAY)

	if(h_style)
		var/datum/sprite_accessory/hair_style = hair_styles_list[h_style]
		if(hair_style)
			var/icon/hair_l = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_l")
			hair_l.Blend(rgb(r_hair, g_hair, b_hair), ICON_ADD)
			face_lying.Blend(hair_l, ICON_OVERLAY)

	//Eyes
	// Note: These used to be in update_face(), and the fact they're here will make it difficult to create a disembodied head
	var/icon/eyes_l = new/icon('icons/mob/human_face.dmi', "eyes_l")
	eyes_l.Blend(rgb(r_eyes, g_eyes, b_eyes), ICON_ADD)
	face_lying.Blend(eyes_l, ICON_OVERLAY)

	if(lip_style)
		face_lying.Blend(new/icon('icons/mob/human_face.dmi', "lips_[lip_style]_l"), ICON_OVERLAY)

	var/image/face_lying_image = new /image(icon = face_lying)
	return face_lying_image

/mob/living/carbon/human/update_burst()
	remove_overlay(BURST_LAYER)
	var/image/standing
	if(chestburst == 1)
		standing = image("icon" = 'icons/Xeno/Effects.dmi',"icon_state" = "burst_stand", "layer" =BURST_LAYER)
	else if(chestburst == 2)
		standing = image("icon" = 'icons/Xeno/Effects.dmi',"icon_state" = "bursted_stand", "layer" =BURST_LAYER)

	overlays_standing[BURST_LAYER] = standing
	apply_overlay(BURST_LAYER)

/mob/living/carbon/human/update_fire()
	remove_overlay(FIRE_LAYER)
	if(on_fire)
		switch(fire_stacks)
			if(1 to 14)	overlays_standing[FIRE_LAYER] = image("icon"='icons/mob/OnFire.dmi', "icon_state"="Standing_weak", "layer"=FIRE_LAYER)
			if(15 to 20) overlays_standing[FIRE_LAYER] = image("icon"='icons/mob/OnFire.dmi', "icon_state"="Standing_medium", "layer"=FIRE_LAYER)

		apply_overlay(FIRE_LAYER)


//Human Overlays Indexes/////////
#undef MUTANTRACE_LAYER
#undef MUTATIONS_LAYER
#undef DAMAGE_LAYER
#undef UNIFORM_LAYER
#undef TAIL_LAYER
#undef ID_LAYER
#undef SHOES_LAYER
#undef GLOVES_LAYER
#undef EARS_LAYER
#undef SUIT_LAYER
#undef GLASSES_LAYER
#undef FACEMASK_LAYER
#undef BELT_LAYER
#undef SUIT_STORE_LAYER
#undef BACK_LAYER
#undef HAIR_LAYER
#undef HEAD_LAYER
#undef COLLAR_LAYER
#undef HANDCUFF_LAYER
#undef LEGCUFF_LAYER
#undef L_HAND_LAYER
#undef R_HAND_LAYER
#undef TARGETED_LAYER
#undef FIRE_LAYER
#undef BURST_LAYER
#undef TOTAL_LAYERS
