/datum/tutorial/marine/basic
	name = "Marine - Basic"
	desc = "A tutorial to get you acquainted with the very basics of how to play a groundside marine role."
	tutorial_id = "marine_basic_1"
	tutorial_template = /datum/map_template/tutorial/s9x10/no_baselight
	/// How many items need to be vended from the clothing vendor for the script to continue, if something vends 2 items (for example), increase this number by 2.
	var/clothing_items_to_vend = 8
	/// How many items need to be vended from the gun vendor to continue
	var/gun_items_to_vend = 2
	required_tutorial = "ss13_intents_1"
	var/area/tutorial_area
	var/list/tutorial_instance_lights = list()
	dialogue_presets = list("commander" = /datum/tutorial_speech_preset/basic_marine/commander)

// START OF SCRIPTING

/datum/tutorial/marine/basic/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	tutorial_area = get_area(bottom_left_corner)
	tutorial_instance_lights = tutorial_area.all_lights.Copy()
	for(var/obj/structure/machinery/light/light as anything in tutorial_instance_lights)
		light.set_light(5, 0.5, LIGHT_COLOR_DARK_BLUE)

	init_tracking_markers()
	init_mob()

	var/mob/living/carbon/human/target = tutorial_mob
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cryopod/tutorial, tutorial_pod)
	playsound_client(target.client, 'sound/machines/tcomms_on.ogg', tutorial_pod, 25, FALSE)
	target.overlay_fullscreen_timer(8 SECONDS, 10, "roundstart1", /atom/movable/screen/fullscreen/black)
	target.overlay_fullscreen_timer(8 SECONDS, 10, "roundstartcrt1", /atom/movable/screen/fullscreen/crt)
	var/message = "ARES v3.2 Training Module<br><br>Now loading...<br>marine_basic_1.disk<br><br>Cryopod #521 - Thawing activated<br><br>Occupant REM:NOMINAL"
	tutorial_mob.play_screen_text(message, /atom/movable/screen/text/screen_text/hypersleep_status)
	addtimer(CALLBACK(src, PROC_REF(wake_up)), 8 SECONDS)

/datum/tutorial/marine/basic/proc/wake_up()

	var/message = "- Press <b>[retrieve_bind("North")]</b> or <b>[retrieve_bind("East")]</b> to exit the cryopod -"
	playsound_client(tutorial_mob.client, 'sound/machines/screen_output1.ogg', tutorial_mob, 35, FALSE)
	tutorial_mob.play_screen_text(message, /atom/movable/screen/text/screen_text/hypersleep_status)

	update_objective("Exit the cryopod by pressing [retrieve_bind("North")] or [retrieve_bind("East")].")
	RegisterSignal(tracking_atoms[/obj/structure/machinery/cryopod/tutorial], COMSIG_CRYOPOD_GO_OUT, PROC_REF(on_cryopod_exit))

/datum/tutorial/marine/basic/proc/on_cryopod_exit()
	for(var/obj/structure/machinery/light/light as anything in tutorial_instance_lights)
		light.set_light(8, 1, LIGHT_COLOR_TUNGSTEN)
	playsound_client(tutorial_mob.client, 'sound/machines/telephone/scout_pick_up.ogg', tutorial_mob, 35, FALSE)
	speech_to_player(dialogue_presets["commander"], TRUE, list(
		"Good morning Marine!! Welcome to boot camp!",
		"This is the tutorial for marine rifleman",
		" to continue.",
	))

/datum/tutorial/marine/basic/proc/on_cryopod_exit2()
	SIGNAL_HANDLER

	UnregisterSignal(tracking_atoms[/obj/structure/machinery/cryopod/tutorial], COMSIG_CRYOPOD_GO_OUT)
	message_to_player("Good. You may notice the yellow \"food\" icon on the right side of your screen. Proceed to the outlined <b>Food Vendor</b> and vend the <b>USCM Protein Bar</b>.")
	update_objective("Vend a USCM Protein Bar from the outlined <font color='#d19a02'>ColMarTech Food Vendor.</font>")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/marine_food/tutorial, food_vendor)
	add_highlight(food_vendor)
	food_vendor.req_access = list()
	RegisterSignal(food_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND, PROC_REF(on_food_vend))

/datum/tutorial/marine/basic/proc/on_food_vend(datum/source, obj/structure/machinery/cm_vending/vendor, list/itemspec, mob/living/carbon/human/user)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/marine_food/tutorial, food_vendor)
	UnregisterSignal(food_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND)
	remove_highlight(food_vendor)
	food_vendor.req_access = list(ACCESS_TUTORIAL_LOCKED)
	message_to_player("Now click on your character with the <b>USCM Protein Bar</b> in-hand until it is fully eaten. If you accidentally switched hands, switch back with <b>[retrieve_bind("swap_hands")]</b>.")
	update_objective("Eat the USCM Protein Bar by clicking on yourself while holding it, until it is gone.")
	RegisterSignal(tutorial_mob, COMSIG_MOB_EATEN_SNACK, PROC_REF(on_foodbar_eaten))

/datum/tutorial/marine/basic/proc/on_foodbar_eaten(datum/source, obj/item/reagent_container/food/snacks/eaten_food)
	SIGNAL_HANDLER

	if(!istype(eaten_food, /obj/item/reagent_container/food/snacks/protein_pack) || eaten_food.reagents.total_volume)
		return

	UnregisterSignal(source, COMSIG_MOB_EATEN_SNACK)
	message_to_player("Good. Now move to the outlined vendor and vend everything inside.")
	update_objective("Vend everything inside the ColMarTech Automated Closet.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/clothing/tutorial, clothing_vendor)
	add_highlight(clothing_vendor)
	clothing_vendor.req_access = list()
	RegisterSignal(clothing_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND, PROC_REF(on_clothing_vend))

/datum/tutorial/marine/basic/proc/on_clothing_vend(datum/source)
	SIGNAL_HANDLER

	clothing_items_to_vend--
	if(clothing_items_to_vend <= 0)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/clothing/tutorial, clothing_vendor)
		UnregisterSignal(clothing_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND)
		clothing_vendor.req_access = list(ACCESS_TUTORIAL_LOCKED)
		remove_highlight(clothing_vendor)
		message_to_player("Now, the room will darken. Take a <b>flare</b> out of your <b>flare pouch</b> by clicking on it with an empty hand, and then light it by using it in-hand with <b>[retrieve_bind("activate_inhand")]</b>.")
		update_objective("Click on your flare pouch to remove a flare before using it in-hand.")
		var/obj/item/storage/pouch/flare/flare_pouch = locate(/obj/item/storage/pouch/flare) in tutorial_mob.contents
		if(flare_pouch)
			add_highlight(flare_pouch)
		RegisterSignal(tutorial_mob, COMSIG_MOB_ITEM_ATTACK_SELF, PROC_REF(on_flare_light))
		addtimer(CALLBACK(src, PROC_REF(dim_room)), 2.5 SECONDS)

/datum/tutorial/marine/basic/proc/on_flare_light(datum/source, obj/item/used)
	SIGNAL_HANDLER

	if(!istype(used, /obj/item/device/flashlight/flare))
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_ITEM_ATTACK_SELF)
	var/obj/item/storage/pouch/flare/flare_pouch = locate(/obj/item/storage/pouch/flare) in tutorial_mob.contents
	if(flare_pouch)
		remove_highlight(flare_pouch)

	message_to_player("Now throw the <b>flare</b> by <b>clicking</b> on a nearby tile, or dropping it with <b>[retrieve_bind("drop_item")]</b>.")
	update_objective("Throw the flare by clicking on a nearby tile, or dropping it with [retrieve_bind("drop_item")].")
	RegisterSignal(tutorial_mob, COMSIG_MOB_ITEM_DROPPED, PROC_REF(on_flare_throw))

/datum/tutorial/marine/basic/proc/on_flare_throw(datum/source, obj/item/thrown)
	SIGNAL_HANDLER

	if(!istype(thrown, /obj/item/device/flashlight/flare))
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_ITEM_DROPPED)
	message_to_player("Good. Now, the room will brighten again. Proceed to the highlighted vendor and vend a <b>M41A Pulse Rifle MK2</b>, along with a <b>magazine</b>.")
	update_objective("Vend everything from the ColMarTech Automated Weapons Rack.")
	addtimer(CALLBACK(src, PROC_REF(brighten_room)), 1.5 SECONDS)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/tutorial, gun_vendor)
	gun_vendor.req_access = list()
	add_highlight(gun_vendor)
	RegisterSignal(gun_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND, PROC_REF(on_gun_vend))

/datum/tutorial/marine/basic/proc/on_gun_vend(datum/source)
	SIGNAL_HANDLER

	gun_items_to_vend--
	if(gun_items_to_vend <= 0)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/tutorial, gun_vendor)
		gun_vendor.req_access = list(ACCESS_TUTORIAL_LOCKED)
		remove_highlight(gun_vendor)
		UnregisterSignal(gun_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND)
		message_to_player("Now insert the <b>magazine</b> into the <b>M41A Pulse Rifle</b> by having the <b>magazine</b> in your active hand and hitting the <b>Pulse Rifle</b> with it. If it is in the off-hand, switch with <b>[retrieve_bind("swap_hands")]</b>.")
		update_objective("Insert the M41A magazine by hitting the M41A Pulse Rifle with it.")
		RegisterSignal(tutorial_mob, COMSIG_MOB_RELOADED_GUN, PROC_REF(on_magazine_insert))

/datum/tutorial/marine/basic/proc/on_magazine_insert(datum/source, atom/attacked, obj/item/attacked_with)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_RELOADED_GUN)
	message_to_player("Good. Now wield your gun by using it in-hand with <b>[retrieve_bind("activate_inhand")]</b>.")
	update_objective("Wield your gun with two hands by pressing [retrieve_bind("activate_inhand")] with the gun in your main hand.")
	RegisterSignal(tutorial_mob, COMSIG_MOB_ITEM_ATTACK_SELF, PROC_REF(on_gun_wield))

/datum/tutorial/marine/basic/proc/on_gun_wield(datum/source, obj/item/used)
	SIGNAL_HANDLER

	if(!istype(used, /obj/item/weapon/gun/rifle/m41a))
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_ITEM_ATTACK_SELF)
	message_to_player("Now, shoot at the highlighted <b>Xenomorph</b> until it dies.")
	update_objective("Shoot at the Xenomorph until it dies.")
	var/mob/living/carbon/xenomorph/drone/tutorial/xeno_dummy = new(loc_from_corner(4, 5))
	add_to_tracking_atoms(xeno_dummy)
	add_highlight(xeno_dummy, COLOR_VIVID_RED)
	RegisterSignal(xeno_dummy, COMSIG_MOB_DEATH, PROC_REF(on_xeno_death))
	RegisterSignal(tutorial_mob, COMSIG_MOB_GUN_EMPTY, PROC_REF(on_magazine_empty)) // I'd like to prevent unwilling softlocks as much as I can

/// Non-contiguous part of the script, called if the user manages to run out of ammo in the gun without the xeno dying
/datum/tutorial/marine/basic/proc/on_magazine_empty(obj/item/weapon/gun/empty_gun)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_GUN_EMPTY)
	message_to_player("Your gun's out of ammo. Go grab some more from the <b>Weaponry Vendor</b> and kill the <b>Xenomorph</b>.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/tutorial, gun_vendor)
	gun_vendor.req_access = list()
	gun_vendor.load_ammo() // 99 magazines, to make sure that the xeno dies

/datum/tutorial/marine/basic/proc/on_xeno_death(datum/source)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/xenomorph/drone/tutorial, xeno_dummy)
	UnregisterSignal(xeno_dummy, COMSIG_MOB_DEATH)
	UnregisterSignal(tutorial_mob, COMSIG_MOB_GUN_EMPTY)
	remove_highlight(xeno_dummy)
	addtimer(CALLBACK(src, PROC_REF(disappear_xeno)), 2.5 SECONDS)
	message_to_player("Very good. This is the end of the tutorial, proceed to the next one to learn the basics of <b>Medical</b>. You will be sent back to the lobby screen momentarily.")
	update_objective("")
	tutorial_end_in(7.5 SECONDS, TRUE)


// END OF SCRIPTING
// START OF SCRIPT HELPERS

/datum/tutorial/marine/basic/proc/dim_room()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/flashlight, flashlight)
	flashlight.set_light_on(FALSE)

/datum/tutorial/marine/basic/proc/brighten_room()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/flashlight, flashlight)
	flashlight.set_light_on(TRUE)

/datum/tutorial/marine/basic/proc/disappear_xeno()
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/xenomorph/drone/tutorial, xeno_dummy)
	animate(xeno_dummy, time = 5 SECONDS, alpha = 0)
	remove_from_tracking_atoms(xeno_dummy)
	QDEL_IN(xeno_dummy, 5.5 SECONDS)

// END OF SCRIPT HELPERS

/datum/tutorial/marine/basic/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/tutorial)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cryopod/tutorial, tutorial_pod)
	tutorial_pod.go_in_cryopod(tutorial_mob, TRUE, FALSE)

/datum/tutorial_speech_preset/basic_marine/commander
	speaker_name = "Maj. John Marine"
	portrait_icon_state = "overwatch_green"
	text_color = rgb(103, 214, 146)
	text_header = "<span class='langchat' style=font-size:24pt;text-align:left valign='top'><u>Command Update:</u></span><br>"
