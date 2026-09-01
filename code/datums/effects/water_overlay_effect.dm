//	we use an object because critically  we dont want to alter the hitboxes.. like we would by having these as part of the mob sprite
//	and the water overlay is created to over extend past just the pixels of the body sprites, to cover armors/backpacks/inhands/alt sprites etc
//	it can have its alpha adjusted as well, the sprites of water turfs are opaque... also like if we ever wanted to add quicksand or mud thats easy now

/obj/effect/water_overlay_effect
	name = ""
	mouse_opacity = FALSE
	alpha = 180
	blend_mode = BLEND_INSET_OVERLAY
	vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_PLANE
	appearance_flags = RESET_COLOR
	plane = FLOAT_PLANE
	layer = FLOAT_LAYER

/obj/effect/water_overlay_effect/proc/update_wateroverlay(turf/open/water_turf, mob/living/overlaid_mob, pixel_y_offset = 0)
	overlays.Cut()	//clean slate, dont need the old overlay
	var/add_no_texture = (isxeno(overlaid_mob) && pixel_y_offset >= DEPTH_INTERMEDIATE && (overlaid_mob.body_position == LYING_DOWN))
	if(add_no_texture)
		return
	var/key = ""
	var/toxic_key = 0
	var/found_angle = overlaid_mob.get_lying_angle()
	var/mob_type = overlaid_mob.type	//variable since we need to set this if human
	var/mob_texture_size = icon(overlaid_mob.icon, overlaid_mob.icon_state).Width()
	if(istype(water_turf, /turf/open/gm/river/desert) || istype(water_turf, /turf/open/desert/desert_shore))
		var/turf/open/gm/river/desert/toxic_turf = water_turf
		toxic_key = toxic_turf.toxic
	if(ishuman(overlaid_mob))			//all human subtypes will just use the single human overlay
		mob_type = /mob/living/carbon/human
		mob_texture_size = 32
	var/list/special_mob_types = SSwater_overlays.water_overlay_special["[mob_texture_size]"]
	var/list/special_mob_details = special_mob_types[mob_type] ? special_mob_types[mob_type] : null
	if(special_mob_details && special_mob_details[1])
		key = "_[mob_type]"
	if(overlaid_mob.resting || overlaid_mob.body_position == LYING_DOWN)	//resting will override the special key (deep waters)
		if(found_angle == 270)	//only humans have a found_angle (surely)
			key = "_/mob/living/carbon/human_e"
		else if(found_angle == 90)
			key = "_/mob/living/carbon/human_w"
		if(pixel_y_offset == DEPTH_DEEP)		//when resting in the deep all mobs will look like they're unda da watur
			key = "_u"
	var/mutable_appearance/final_texture = mutable_appearance(SSwater_overlays.water_overlay_icons["[mob_texture_size]_[water_turf.water_type]_[toxic_key]_[pixel_y_offset][key]"])
	final_texture.color = water_turf.color
	overlays += final_texture
