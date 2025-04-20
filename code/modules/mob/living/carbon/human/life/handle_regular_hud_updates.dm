//Refer to life.dm for caller
/mob/living/carbon/human/proc/handle_regular_hud_updates()

	//Now handle what we see on our screen
	if(!client || QDELETED(client))
		return FALSE

	if(stat != DEAD) //the dead get zero fullscreens

		if(stat == UNCONSCIOUS)
			var/severity = 0
			switch(health)
				if(-20 to -10)
					severity = 1
				if(-30 to -20)
					severity = 2
				if(-40 to -30)
					severity = 3
				if(-50 to -40)
					severity = 4
				if(-60 to -50)
					severity = 5
				if(-70 to -60)
					severity = 6
				if(-80 to -70)
					severity = 7
				if(-90 to -80)
					severity = 8
				if(-95 to -90)
					severity = 9
				if(-INFINITY to -95)
					severity = 10
			if(client.prefs?.crit_overlay_pref == CRIT_OVERLAY_DARK)
				overlay_fullscreen("crit", /atom/movable/screen/fullscreen/crit/dark, severity)
			else
				overlay_fullscreen("crit", /atom/movable/screen/fullscreen/crit, severity)
		else
			clear_fullscreen("crit")
			if(oxyloss)
				var/severity = 0
				switch(oxyloss)
					if(10 to 20)
						severity = 1
					if(20 to 25)
						severity = 2
					if(25 to 30)
						severity = 3
					if(30 to 35)
						severity = 4
					if(35 to 40)
						severity = 5
					if(40 to 45)
						severity = 6
					if(45 to INFINITY)
						severity = 7
				overlay_fullscreen("oxy", /atom/movable/screen/fullscreen/oxy, severity)
			else
				clear_fullscreen("oxy")

			//Fire and Brute damage overlay (BSSR)
			var/max_health_normalisation = (species ? species.total_health : 100) / 100
			var/hurtdamage = (getBruteLoss() + getFireLoss()) / max_health_normalisation + damageoverlaytemp
			damageoverlaytemp = 0 // We do this so we can detect if someone hits us or not.
			if(hurtdamage)
				var/severity = 0
				switch(hurtdamage)
					if(5 to 15)
						severity = 1
					if(15 to 30)
						severity = 2
					if(30 to 45)
						severity = 3
					if(45 to 70)
						severity = 4
					if(70 to 85)
						severity = 5
					if(85 to INFINITY)
						severity = 6
				overlay_fullscreen("brute", /atom/movable/screen/fullscreen/brute, severity)
			else
				clear_fullscreen("brute")


		if(blinded)
			overlay_fullscreen("blind", /atom/movable/screen/fullscreen/blind)
		else
			clear_fullscreen("blind")

		///Pain should override the SetEyeBlur(0) should the pain be painful enough to cause eyeblur in the first place. Also, peepers is essential to make sure eye damage isn't overridden.
		var/datum/internal_organ/eyes/peepers = internal_organs_by_name["eyes"]
		if((disabilities & NEARSIGHTED) && !HAS_TRAIT(src, TRAIT_NEARSIGHTED_EQUIPMENT) && pain.current_pain < 80 && peepers.organ_status == ORGAN_HEALTHY)
			EyeBlur(2)
		else if((disabilities & NEARSIGHTED) && HAS_TRAIT(src, TRAIT_NEARSIGHTED_EQUIPMENT) && pain.current_pain < 80 && peepers.organ_status == ORGAN_HEALTHY)
			SetEyeBlur(0)

		if(druggy && src.client?.prefs?.allow_flashing_lights_pref)
			overlay_fullscreen("high", /atom/movable/screen/fullscreen/high)
		else
			clear_fullscreen("high")


		if(hud_used)
			if(hud_used.healths)
				switch(hal_screwyhud)
					if(1)
						hud_used.healths.icon_state = "health6"
					if(2)
						hud_used.healths.icon_state = "health7"
					else
						var/pain_percentage = max(pain.get_pain_percentage(), 100 - (stamina.current_stamina/stamina.max_stamina)*100) // Get the highest value from either
						switch(pain_percentage)
							if(80 to 100)
								hud_used.healths.icon_state = "health6"
							if(60 to 80)
								hud_used.healths.icon_state = "health5"
							if(50 to 60)
								hud_used.healths.icon_state = "health4"
							if(40 to 50)
								hud_used.healths.icon_state = "health3"
							if(20 to 40)
								hud_used.healths.icon_state = "health2"
							if(1 to 20)
								hud_used.healths.icon_state = "health1"
							else
								hud_used.healths.icon_state = "health0"

			if(hud_used.nutrition_icon)
				switch(nutrition)
					if(350 to INFINITY)
						hud_used.nutrition_icon.icon_state = "nutrition0"
					if(250 to 350)
						hud_used.nutrition_icon.icon_state = "nutrition1"
					if(150 to 250)
						hud_used.nutrition_icon.icon_state = "nutrition2"
					if(50 to 150)
						hud_used.nutrition_icon.icon_state = "nutrition3"
					else
						hud_used.nutrition_icon.icon_state = "nutrition3"

			if(hud_used.oxygen_icon)
				if(hal_screwyhud == 3 || oxygen_alert)
					hud_used.oxygen_icon.icon_state = "oxy1"
				else
					hud_used.oxygen_icon.icon_state = "oxy0"

			check_status_effects()

			if(hud_used.pulse_line)
				var/pain_percentage = pain.get_pain_percentage()
				switch(pain_percentage)
					if(70 to INFINITY)
						hud_used.pulse_line.icon_state = "pulse_dying"
					if(20 to 70)
						hud_used.pulse_line.icon_state = "pulse_hurt"
					else
						hud_used.pulse_line.icon_state = "pulse_good"

			if(hud_used.bodytemp_icon)
				if (!species)
					switch(bodytemperature) //310.055 optimal body temp
						if(370 to INFINITY)
							hud_used.bodytemp_icon.icon_state = "temp4"
						if(350 to 370)
							hud_used.bodytemp_icon.icon_state = "temp3"
						if(335 to 350)
							hud_used.bodytemp_icon.icon_state = "temp2"
						if(320 to 335)
							hud_used.bodytemp_icon.icon_state = "temp1"
						if(300 to 320)
							hud_used.bodytemp_icon.icon_state = "temp0"
						if(295 to 300)
							hud_used.bodytemp_icon.icon_state = "temp-1"
						if(280 to 295)
							hud_used.bodytemp_icon.icon_state = "temp-2"
						if(260 to 280)
							hud_used.bodytemp_icon.icon_state = "temp-3"
						else
							hud_used.bodytemp_icon.icon_state = "temp-4"
				else
					var/temp_step
					if(bodytemperature >= species.body_temperature)
						temp_step = (species.heat_level_1 - species.body_temperature)/4

						if(bodytemperature >= species.heat_level_1)
							hud_used.bodytemp_icon.icon_state = "temp4"
						else if(bodytemperature >= species.body_temperature + temp_step * 3)
							hud_used.bodytemp_icon.icon_state = "temp3"
						else if(bodytemperature >= species.body_temperature + temp_step * 2)
							hud_used.bodytemp_icon.icon_state = "temp2"
						else if(bodytemperature >= species.body_temperature + temp_step * 1)
							hud_used.bodytemp_icon.icon_state = "temp1"
						else
							hud_used.bodytemp_icon.icon_state = "temp0"

					else if(bodytemperature < species.body_temperature)
						temp_step = (species.body_temperature - species.cold_level_1)/4

						if(bodytemperature <= species.cold_level_1)
							hud_used.bodytemp_icon.icon_state = "temp-4"
						else if(bodytemperature <= species.body_temperature - temp_step * 3)
							hud_used.bodytemp_icon.icon_state = "temp-3"
						else if(bodytemperature <= species.body_temperature - temp_step * 2)
							hud_used.bodytemp_icon.icon_state = "temp-2"
						else if(bodytemperature <= species.body_temperature - temp_step * 1)
							hud_used.bodytemp_icon.icon_state = "temp-1"
						else
							hud_used.bodytemp_icon.icon_state = "temp0"

		if(interactee && isatom(interactee))
			interactee.check_eye(src)
	return TRUE

/mob/living/carbon/human/on_dazed_trait_gain(datum/source)
	. = ..()
	overlay_fullscreen("eye_blurry", /atom/movable/screen/fullscreen/impaired, 5)
/mob/living/carbon/human/on_dazed_trait_loss(datum/source)
	. = ..()
	clear_fullscreen("eye_blurry")

/mob/living/carbon/human/proc/check_status_effects()
	var/status_effect_placement = 1

	var/datum/custom_hud/ui_datum
	if(client)
		ui_datum = GLOB.custom_huds_list[client.prefs.UI_style]
	else
		ui_datum = GLOB.custom_huds_list[HUD_MIDNIGHT]

	var/is_bleeding = is_bleeding()
	if(is_bleeding)
		hud_used.bleeding_icon.name = "bleeding"
		hud_used.bleeding_icon.icon_state = "status_bleed"
		hud_used.bleeding_icon.screen_loc = ui_datum.get_status_loc(status_effect_placement)
		status_effect_placement++
	else
		hud_used.bleeding_icon.name = ""
		hud_used.bleeding_icon.icon_state = "status_0"

	var/is_slowed = (slowed || superslowed)
	if(is_slowed)
		hud_used.slowed_icon.name = "slowed"
		hud_used.slowed_icon.icon_state = "status_slow"
		hud_used.slowed_icon.screen_loc = ui_datum.get_status_loc(status_effect_placement)
		status_effect_placement++
	else
		hud_used.slowed_icon.name = ""
		hud_used.slowed_icon.icon_state = "status_0"

	var/is_embedded = length(embedded_items)
	if(is_embedded)
		hud_used.shrapnel_icon.name = "shrapnel"
		hud_used.shrapnel_icon.icon_state = "status_shrapnel"
		hud_used.shrapnel_icon.screen_loc = ui_datum.get_status_loc(status_effect_placement)
		status_effect_placement++
	else
		hud_used.shrapnel_icon.name = ""
		hud_used.shrapnel_icon.icon_state = "status_0"

	var/is_tethering = is_tethering()
	if(is_tethering)
		hud_used.tethering_icon.name = "tethering"
		hud_used.tethering_icon.icon_state = "status_tethering"
		hud_used.tethering_icon.screen_loc = ui_datum.get_status_loc(status_effect_placement)
		status_effect_placement++
	else
		hud_used.tethering_icon.name = ""
		hud_used.tethering_icon.icon_state = "status_0"

	var/is_tethered = is_tethered()
	if(is_tethered)
		hud_used.tethered_icon.name = "tethered"
		hud_used.tethered_icon.icon_state = "status_tethered"
		hud_used.tethered_icon.screen_loc = ui_datum.get_status_loc(status_effect_placement)
		status_effect_placement++
	else
		hud_used.tethered_icon.name = ""
		hud_used.tethered_icon.icon_state = "status_0"

	if(length(active_transfusions))
		hud_used.tethered_icon.name = "transfusion"
		hud_used.tethered_icon.icon_state = "status_blood"
		hud_used.tethered_icon.screen_loc = ui_datum.get_status_loc(status_effect_placement)
		status_effect_placement++
	else
		hud_used.tethered_icon.name = ""
		hud_used.tethered_icon.icon_state = "status_0"
