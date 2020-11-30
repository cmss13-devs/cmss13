//Magazine items, and casings.
/*
Boxes of ammo. Certain weapons have internal boxes of ammo that cannot be removed and function as part of the weapon.
They're all essentially identical when it comes to getting the job done.
*/
/obj/item/ammo_magazine
	name = "generic ammo"
	desc = "A box of ammo."
	icon = 'icons/obj/items/weapons/guns/ammo.dmi'
	icon_state = null
	item_state = "ammo_mag" //PLACEHOLDER. This ensures the mag doesn't use the icon state instead.
	var/bonus_overlay = null //Sprite pointer in ammo.dmi to an overlay to add to the gun, for extended mags, box mags, and so on
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	matter = list("metal" = 1000)
	 //Low.
	throwforce = 2
	w_class = SIZE_SMALL
	throw_speed = SPEED_SLOW
	throw_range = 6
	var/default_ammo = /datum/ammo/bullet
	var/caliber = null // This is used for matching handfuls to each other or whatever the mag is. Examples are" "12g" ".44" ".357" etc.
	var/current_rounds = -1 //Set this to something else for it not to start with different initial counts.
	var/max_rounds = 7 //How many rounds can it hold?
	var/gun_type = null //Path of the gun that it fits. Mags will fit any of the parent guns as well, so make sure you want this.
	var/reload_delay = 1 //Set a timer for reloading mags. Higher is slower.
	var/flags_magazine = AMMUNITION_REFILLABLE //flags specifically for magazines.
	var/base_mag_icon //the default mag icon state.
	var/base_mag_item //the default mag item (inhand) state.

/obj/item/ammo_magazine/New(loc, spawn_empty)
	..()
	GLOB.ammo_magazine_list += src
	base_mag_icon = icon_state
	base_mag_item = item_state
	if(spawn_empty) current_rounds = 0
	switch(current_rounds)
		if(-1) current_rounds = max_rounds //Fill it up. Anything other than -1 and 0 will just remain so.
		if(0)
			icon_state += "_e" //In case it spawns empty instead.
			item_state += "_e"

/obj/item/ammo_magazine/Destroy()
	GLOB.ammo_magazine_list -= src
	return ..()

/obj/item/ammo_magazine/update_icon(var/round_diff = 0) //inhand sprites only get their icon update called when picked back up or removed from storage, known issue.
	if(current_rounds <= 0)
		icon_state = base_mag_icon + "_e"
		item_state = base_mag_item + "_e"
		add_to_garbage(src)
	else if(current_rounds - round_diff <= 0)
		icon_state = base_mag_icon
		item_state = base_mag_item //to-do, unique magazine inhands for majority firearms.

/obj/item/ammo_magazine/examine(mob/user)
	..()

	if(flags_magazine & AMMUNITION_HIDE_AMMO)
		return
	// It should never have negative ammo after spawn. If it does, we need to know about it.
	if(current_rounds < 0)
		to_chat(user, "Something went horribly wrong. Ahelp the following: ERROR CODE R1: negative current_rounds on examine.")
		log_debug("ERROR CODE R1: negative current_rounds on examine. User: <b>[usr]</b>")
	else
		to_chat(user, "[src] has <b>[current_rounds]</b> rounds out of <b>[max_rounds]</b>.")


/obj/item/ammo_magazine/attack_hand(mob/user)
	if(flags_magazine & AMMUNITION_REFILLABLE) //actual refillable magazine, not just a handful of bullets or a fuel tank.
		if(src == user.get_inactive_hand()) //Have to be holding it in the hand.
			if (current_rounds > 0)
				if(create_handful(user))
					return
			else to_chat(user, "[src] is empty. Nothing to grab.")
			return
	return ..() //Do normal stuff.

//We should only attack it with handfuls. Empty hand to take out, handful to put back in. Same as normal handful.
/obj/item/ammo_magazine/attackby(obj/item/I, mob/living/user, var/bypass_hold_check = 0)
	if(istype(I, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/MG = I
		if(MG.flags_magazine & AMMUNITION_HANDFUL) //got a handful of bullets
			if(flags_magazine & AMMUNITION_REFILLABLE) //and a refillable magazine
				var/obj/item/ammo_magazine/handful/transfer_from = I
				if(src == user.get_inactive_hand() || bypass_hold_check) //It has to be held.
					if(default_ammo == transfer_from.default_ammo)
						transfer_ammo(transfer_from,user,transfer_from.current_rounds) // This takes care of the rest.
					else to_chat(user, "Those aren't the same rounds. Better not mix them up.")
				else to_chat(user, "Try holding [src] before you attempt to restock it.")

//Generic proc to transfer ammo between ammo mags. Can work for anything, mags, handfuls, etc.
/obj/item/ammo_magazine/proc/transfer_ammo(obj/item/ammo_magazine/source, mob/user, transfer_amount = 1)
	if(current_rounds == max_rounds) //Does the mag actually need reloading?
		to_chat(user, "[src] is already full.")
		return

	if(source.caliber != caliber) //Are they the same caliber?
		to_chat(user, "The rounds don't match up. Better not mix them up.")
		return

	var/S = min(transfer_amount, max_rounds - current_rounds)
	source.current_rounds -= S
	current_rounds += S
	if(source.current_rounds <= 0 && istype(source, /obj/item/ammo_magazine/handful)) //We want to delete it if it's a handful.
		if(user)
			user.temp_drop_inv_item(source)
		qdel(source) //Dangerous. Can mean future procs break if they reference the source. Have to account for this.
	else source.update_icon()

	if(!istype(src, /obj/item/ammo_magazine/internal) && !istype(src, /obj/item/ammo_magazine/shotgun) && !istype(source, /obj/item/ammo_magazine/shotgun))	//if we are shotgun or revolver or whatever not using normal mag system
		playsound(loc, pick('sound/weapons/handling/mag_refill_1.ogg', 'sound/weapons/handling/mag_refill_2.ogg', 'sound/weapons/handling/mag_refill_3.ogg'), 25, 1)

	update_icon(S)
	return S // We return the number transferred if it was successful.

//This will attempt to place the ammo in the user's hand if possible.
/obj/item/ammo_magazine/proc/create_handful(mob/user, transfer_amount, var/obj_name = src)
	var/R
	if (current_rounds > 0)
		var/obj/item/ammo_magazine/handful/new_handful = new /obj/item/ammo_magazine/handful
		var/MR = caliber == "12g" ? 5 : 8
		R = transfer_amount ? min(current_rounds, transfer_amount) : min(current_rounds, MR)
		new_handful.generate_handful(default_ammo, caliber, MR, R, gun_type)
		current_rounds -= R
		if(!istype(src, /obj/item/ammo_magazine/internal) && !istype(src, /obj/item/ammo_magazine/shotgun))	//if we are shotgun or revolver or whatever not using normal mag system
			playsound(loc, pick('sound/weapons/handling/mag_refill_1.ogg', 'sound/weapons/handling/mag_refill_2.ogg', 'sound/weapons/handling/mag_refill_3.ogg'), 25, 1)

		if(user)
			user.put_in_hands(new_handful)
			to_chat(user, SPAN_NOTICE("You grab <b>[R]</b> round\s from [obj_name]."))

		else new_handful.loc = get_turf(src)
		update_icon(-R) //Update the other one.
	return R //Give the number created.

//our magazine inherits ammo info from a source magazine
/obj/item/ammo_magazine/proc/match_ammo(obj/item/ammo_magazine/source)
	caliber = source.caliber
	default_ammo = source.default_ammo
	gun_type = source.gun_type

//~Art interjecting here for explosion when using flamer procs.
/obj/item/ammo_magazine/flamer_fire_act()
	switch(current_rounds)
		if(0) return
		if(1 to 100) explosion(loc,  -1, -1, 0, 2) //blow it up.
		else explosion(loc,  -1, -1, 1, 2) //blow it up HARDER
	qdel(src)

//Magazines that actually cannot be removed from the firearm. Functionally the same as the regular thing, but they do have three extra vars.
/obj/item/ammo_magazine/internal
	name = "internal chamber"
	desc = "You should not be able to examine it."
	//For revolvers and shotguns.
	var/chamber_contents[] //What is actually in the chamber. Initiated on New().
	var/chamber_position = 1 //Where the firing pin is located. We usually move this instead of the contents.
	var/chamber_closed = 1 //Starts out closed. Depends on firearm.

//Helper proc, to allow us to see a percentage of how full the magazine is.
/obj/item/ammo_magazine/proc/get_ammo_percent()		// return % charge of cell
	return 100.0*current_rounds/max_rounds

//----------------------------------------------------------------//
//Now for handfuls, which follow their own rules and have some special differences from regular boxes.

/*
Handfuls are generated dynamically and they are never actually loaded into the item.
What they do instead is refill the magazine with ammo and sometime save what sort of
ammo they are in order to use later. The internal magazine for the gun really does the
brunt of the work. This is also far, far better than generating individual items for
bullets/shells. ~N
*/

/obj/item/ammo_magazine/handful
	name = "generic handful"
	desc = "A handful of rounds to reload on the go."
	matter = list("metal" = 50) //This changes based on the ammo ammount. 5k is the base of one shell/bullet.
	flags_equip_slot = null // It only fits into pockets and such.

	w_class = SIZE_SMALL
	current_rounds = 1 // So it doesn't get autofilled for no reason.
	max_rounds = 5 // For shotguns, though this will be determined by the handful type when generated.
	flags_atom = FPRINT|CONDUCT|DIRLOCK
	flags_magazine = AMMUNITION_HANDFUL
	attack_speed = 3 // should make reloading less painful

/obj/item/ammo_magazine/handful/update_icon() //Handles the icon itself as well as some bonus things.
	if(max_rounds >= current_rounds)
		var/I = current_rounds*50 // For the metal.
		matter = list("metal" = I)
		dir = current_rounds + round(current_rounds/3)

/obj/item/ammo_magazine/handful/pickup(mob/user)
	return

/obj/item/ammo_magazine/handful/equipped(mob/user, slot)
	var/thisDir = src.dir
	..(user,slot)
	dir = thisDir
	return
/*
There aren't many ways to interact here.
If the default ammo isn't the same, then you can't do much with it.
If it is the same and the other stack isn't full, transfer an amount (default 1) to the other stack.
*/
/obj/item/ammo_magazine/handful/attackby(obj/item/ammo_magazine/handful/transfer_from, mob/user)
	if(istype(transfer_from)) // We have a handful. They don't need to hold it.
		if(default_ammo == transfer_from.default_ammo) //Has to match.
			transfer_ammo(transfer_from,user, transfer_from.current_rounds) // Transfer it from currently held to src
		else to_chat(user, "Those aren't the same rounds. Better not mix them up.")

/obj/item/ammo_magazine/handful/proc/generate_handful(new_ammo, new_caliber, maximum_rounds, new_rounds, new_gun_type)
	var/datum/ammo/A = ammo_list[new_ammo]
	var/ammo_name = A.name //Let's pull up the name.

	name = "handful of [ammo_name + (ammo_name == "shotgun buckshot"? " ":"s ") + "([new_caliber])"]"
	icon_state = new_caliber == "12g" ? ammo_name : "bullet"
	item_state = new_caliber == "12g" ? ammo_name : "bullet"
	default_ammo = new_ammo
	caliber = new_caliber
	max_rounds = maximum_rounds
	current_rounds = new_rounds
	gun_type = new_gun_type
	update_icon()

//----------------------------------------------------------------//


/*
Doesn't do anything or hold anything anymore.
Generated per the various mags, and then changed based on the number of
casings. .dir is the main thing that controls the icon. It modifies
the icon_state to look like more casings are hitting the ground.
There are 8 directions, 8 bullets are possible so after that it tries to grab the next
icon_state while reseting the direction. After 16 casings, it just ignores new
ones. At that point there are too many anyway. Shells and bullets leave different
items, so they do not intersect. This is far more efficient than using Bl*nd() or
Turn() or Shift() as there is virtually no overhead. ~N
*/
/obj/item/ammo_casing
	name = "spent casing"
	desc = "Empty and useless now."
	icon = 'icons/obj/items/casings.dmi'
	icon_state = "casing_"
	throwforce = 1
	w_class = SIZE_TINY
	layer = LOWER_ITEM_LAYER //Below other objects
	dir = 1 //Always north when it spawns.
	flags_atom = FPRINT|CONDUCT|DIRLOCK
	matter = list("metal" = 8) //tiny amount of metal
	var/current_casings = 1 //This is manipulated in the procs that use these.
	var/max_casings = 16
	var/current_icon = 0
	var/number_of_states = 10 //How many variations of this item there are.
	garbage = TRUE

/obj/item/ammo_casing/New()
	..()
	pixel_x = rand(-2.0, 2) //Want to move them just a tad.
	pixel_y = rand(-2.0, 2)
	icon_state += "[rand(1,number_of_states)]" //Set the icon to it.

//This does most of the heavy lifting. It updates the icon and name if needed, then changes .dir to simulate new casings.
/obj/item/ammo_casing/update_icon()
	if(max_casings >= current_casings)
		if(current_casings == 2) name += "s" //In case there is more than one.
		if(round((current_casings-1)/8) > current_icon)
			current_icon++
			icon_state += "_[current_icon]"

		var/I = current_casings*8 // For the metal.
		matter = list("metal" = I)
		var/base_direction = current_casings - (current_icon * 8)
		dir = base_direction + round(base_direction)/3
		switch(current_casings)
			if(3 to 5) w_class = SIZE_SMALL //Slightly heavier.
			if(9 to 10) w_class = SIZE_MEDIUM //Can't put it in your pockets and stuff.


//Making child objects so that locate() and istype() doesn't screw up.
/obj/item/ammo_casing/bullet

/obj/item/ammo_casing/cartridge
	name = "spent cartridge"
	icon_state = "cartridge_"

/obj/item/ammo_casing/shell
	name = "spent shell"
	icon_state = "shell_"


//---------------------------MAGAZINE BOXES------------------

/obj/item/ammo_box
	name = "generic ammo box"
	icon = 'icons/obj/items/weapons/guns/ammo_box.dmi'
	icon_state = "base"
	w_class = SIZE_HUGE
	var/empty = FALSE

/obj/item/ammo_box/magazine
	name = "magazine box (M41A x 10)"
	icon_state = "base_m41"			//base color of box
	var/overlay_ammo_type = "_reg"		//used for ammo type color overlay
	var/overlay_gun_type = "_m41"		//used for text overlay
	var/overlay_content = "_reg"
	var/magazine_type = /obj/item/ammo_magazine/rifle
	var/num_of_magazines = 10
	var/handfuls = FALSE

/obj/item/ammo_box/magazine/Initialize()
	. = ..()
	if(handfuls)
		var/obj/item/ammo_magazine/AM = new magazine_type(src)
		AM.max_rounds = num_of_magazines
		AM.current_rounds = empty ? 0 : num_of_magazines
	else if(!empty)
		var/i = 0
		while(i < num_of_magazines)
			contents += new magazine_type(src)
			i++
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)
	update_icon()

/obj/item/ammo_box/magazine/empty
	empty = TRUE

/obj/item/ammo_box/magazine/update_icon()
	if(overlays)
		overlays.Cut()
	overlays += image(icon, icon_state = "[icon_state]_lid")				//adding lid
	overlays += image(icon, icon_state = "text[overlay_gun_type]")		//adding text
	overlays += image(icon, icon_state = "base_type[overlay_ammo_type]")	//adding base color stripes
	overlays += image(icon, icon_state = "lid_type[overlay_ammo_type]")	//adding base color stripes

/obj/item/ammo_box/magazine/examine(mob/living/user)
	..()
	to_chat(user, SPAN_INFO("[SPAN_HELPFUL("Activate")] box in hand or [SPAN_HELPFUL("click")] with it on the ground to deploy it. Activating it while empty will fold it into cardboard sheet."))
	if(src.loc != user)		//feeling box weight in a distance is unnatural and bad
		return
	if(!handfuls)
		if(contents.len < (num_of_magazines/3))
			to_chat(user, SPAN_INFO("It feels almost empty."))
			return
		if(contents.len < ((num_of_magazines*2)/3))
			to_chat(user, SPAN_INFO("It feels about half full."))
			return
		to_chat(user, SPAN_INFO("It feels almost full."))
	else
		var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in contents
		if(AM)
			if(AM.current_rounds < (AM.max_rounds/3))
				to_chat(user, SPAN_INFO("It feels almost empty."))
				return
			if(AM.current_rounds < ((AM.max_rounds*2)/3))
				to_chat(user, SPAN_INFO("It feels about half full."))
				return
			to_chat(user, SPAN_INFO("It feels almost full."))

/obj/item/ammo_box/magazine/attack_self(mob/living/user)
	if(contents.len)
		if(!handfuls)
			deploy_ammo_box(user, user.loc)
			return
		else
			var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in contents
			if(AM && AM.current_rounds)
				deploy_ammo_box(user, user.loc)
				return
	unfold_box(user.loc)

/obj/item/ammo_box/magazine/proc/unfold_box(turf/T)
	new /obj/item/stack/sheet/cardboard(T)
	qdel(src)

/obj/item/ammo_box/magazine/proc/deploy_ammo_box(mob/living/user, turf/T)
	for(var/obj/structure/magazine_box/MB in T.contents)
		to_chat(user, SPAN_WARNING("There is a [MB] deployed here already."))
		return
	var/obj/structure/magazine_box/M = new /obj/structure/magazine_box(T)
	M.icon_state = icon_state
	M.name = name
	M.desc = desc
	M.item_box = src
	M.update_icon()
	user.drop_inv_item_on_ground(src)
	Move(M)

/obj/item/ammo_box/magazine/afterattack(atom/target, mob/living/user, proximity)
	if(!proximity)
		return
	if(isturf(target))
		var/turf/T = target
		if(!T.density)
			deploy_ammo_box(user, T)

//-----------------------------------------------------------------------------------

//-----------------------SHOTGUN SHELL BOXES-----------------------

/obj/item/ammo_box/magazine/shotgun
	name = "shotgun shell box (Slugs x 100)"
	icon_state = "base_slug"
	overlay_ammo_type = ""
	overlay_gun_type = "_shells"
	overlay_content = "_slug"
	magazine_type = /obj/item/ammo_magazine/shotgun/slugs
	num_of_magazines = 100
	handfuls = TRUE

/obj/item/ammo_box/magazine/shotgun/update_icon()
	if(overlays)
		overlays.Cut()
	overlays += image(icon, icon_state = "[icon_state]_lid")				//adding lid
	overlays += image(icon, icon_state = "text[overlay_gun_type]")		//adding text

/obj/item/ammo_box/magazine/shotgun/empty
	empty = TRUE

/obj/item/ammo_box/magazine/shotgun/buckshot
	name = "shotgun shell box (Buckshot x 100)"
	icon_state = "base_buck"
	overlay_content = "_buck"
	magazine_type = /obj/item/ammo_magazine/shotgun/buckshot

/obj/item/ammo_box/magazine/shotgun/buckshot/empty
	empty = TRUE

/obj/item/ammo_box/magazine/shotgun/flechette
	name = "shotgun shell box (Flechette x 100)"
	icon_state = "base_flech"
	overlay_content = "_flech"
	magazine_type = /obj/item/ammo_magazine/shotgun/flechette

/obj/item/ammo_box/magazine/shotgun/flechette/empty
	empty = TRUE

/obj/item/ammo_box/magazine/shotgun/incendiary
	name = "shotgun shell box (Incendiary slug x 100)"
	icon_state = "base_inc"
	overlay_content = "_incen"
	magazine_type = /obj/item/ammo_magazine/shotgun/incendiary

/obj/item/ammo_box/magazine/shotgun/incendiary/empty
	empty = TRUE

/obj/item/ammo_box/magazine/shotgun/beanbag
	name = "shotgun shell box (Beanbag x 100)"
	icon_state = "base_bean"
	overlay_content = "_bean"
	magazine_type = /obj/item/ammo_magazine/shotgun/beanbag

/obj/item/ammo_box/magazine/shotgun/beanbag/empty
	empty = TRUE

//-----------------------M41A Rifle Mag Boxes-----------------------

/obj/item/ammo_box/magazine/ap
	name = "magazine box (AP M41A x 10)"
	overlay_ammo_type = "_ap"
	overlay_content = "_ap"
	magazine_type = /obj/item/ammo_magazine/rifle/ap

/obj/item/ammo_box/magazine/ap/empty
	empty = TRUE

/obj/item/ammo_box/magazine/le
	name = "magazine box (LE M41A x 10)"
	overlay_ammo_type = "_le"
	overlay_content = "_le"
	magazine_type = /obj/item/ammo_magazine/rifle/le

/obj/item/ammo_box/magazine/le/empty
	empty = TRUE

/obj/item/ammo_box/magazine/ext
	name = "magazine box (Ext M41A x 8)"
	overlay_ammo_type = "_ext"
	num_of_magazines = 8
	magazine_type = /obj/item/ammo_magazine/rifle/extended

/obj/item/ammo_box/magazine/ext/empty
	empty = TRUE

/obj/item/ammo_box/magazine/incen
	name = "magazine box (Incen M41A x 10)"
	overlay_ammo_type = "_incen"
	overlay_content = "_incen"
	magazine_type = /obj/item/ammo_magazine/rifle/incendiary

/obj/item/ammo_box/magazine/incen/empty
	empty = TRUE

/obj/item/ammo_box/magazine/explosive
	name = "magazine box (Explosive M41A x 10)"
	overlay_ammo_type = "_expl"
	overlay_content = "_expl"
	magazine_type = /obj/item/ammo_magazine/rifle/explosive

/obj/item/ammo_box/magazine/explosive/empty
	empty = TRUE

//-----------------------M39 Rifle Mag Boxes-----------------------

/obj/item/ammo_box/magazine/m39
	name = "magazine box (M39 x 12)"
	icon_state = "base_m39"
	overlay_ammo_type = "_reg"
	overlay_gun_type = "_m39"
	overlay_content = "_hv"
	num_of_magazines = 12
	magazine_type = /obj/item/ammo_magazine/smg/m39

/obj/item/ammo_box/magazine/m39/empty
	empty = TRUE

/obj/item/ammo_box/magazine/m39/ap
	name = "magazine box (AP M39 x 12)"
	overlay_ammo_type = "_ap"
	overlay_content = "_ap"
	magazine_type = /obj/item/ammo_magazine/smg/m39/ap

/obj/item/ammo_box/magazine/m39/ap/empty
	empty = TRUE

/obj/item/ammo_box/magazine/m39/ext
	name = "magazine box (Ext m39 x 10)"
	overlay_ammo_type = "_ext"
	overlay_content = "_hv"
	num_of_magazines = 10
	magazine_type = /obj/item/ammo_magazine/smg/m39/extended

/obj/item/ammo_box/magazine/m39/ext/empty
	empty = TRUE

/obj/item/ammo_box/magazine/m39/incen
	name = "magazine box (Incen m39 x 12)"
	overlay_ammo_type = "_incen"
	overlay_content = "_incen"
	magazine_type = /obj/item/ammo_magazine/smg/m39/incendiary

/obj/item/ammo_box/magazine/m39/incen/empty
	empty = TRUE

/obj/item/ammo_box/magazine/m39/le
	name = "magazine box (LE m39 x 12)"
	overlay_ammo_type = "_le"
	overlay_content = "_le"
	magazine_type = /obj/item/ammo_magazine/smg/m39/le

/obj/item/ammo_box/magazine/m39/le/empty
	empty = TRUE

//-----------------------L42A Battle Rifle Mag Boxes-----------------------

/obj/item/ammo_box/magazine/l42a
	name = "magazine box (L42A x 16)"
	icon_state = "base_l42"
	overlay_gun_type = "_l42"
	num_of_magazines = 16
	magazine_type = /obj/item/ammo_magazine/rifle/l42a

/obj/item/ammo_box/magazine/l42a/empty
	empty = TRUE

/obj/item/ammo_box/magazine/l42a/ap
	name = "magazine box (AP L42A x 16)"
	overlay_ammo_type = "_ap"
	overlay_content = "_ap"
	magazine_type = /obj/item/ammo_magazine/rifle/l42a/ap

/obj/item/ammo_box/magazine/l42a/ap/empty
	empty = TRUE

/obj/item/ammo_box/magazine/l42a/le
	name = "magazine box (LE L42A x 16)"
	overlay_ammo_type = "_le"
	overlay_content = "_le"
	magazine_type = /obj/item/ammo_magazine/rifle/l42a/le

/obj/item/ammo_box/magazine/l42a/le/empty
	empty = TRUE

/obj/item/ammo_box/magazine/l42a/ext
	name = "magazine box (Ext L42A x 12)"
	overlay_ammo_type = "_ext"
	overlay_content = "_reg"
	num_of_magazines = 12
	magazine_type = /obj/item/ammo_magazine/rifle/l42a/extended

/obj/item/ammo_box/magazine/l42a/ext/empty
	empty = TRUE

/obj/item/ammo_box/magazine/l42a/incen
	name = "magazine box (Incen L42A x 16)"
	overlay_ammo_type = "_incen"
	overlay_content = "_incen"
	magazine_type = /obj/item/ammo_magazine/rifle/l42a/incendiary

/obj/item/ammo_box/magazine/l42a/incen/empty
	empty = TRUE

//-----------------------M16 Rifle Mag Box-----------------------

/obj/item/ammo_box/magazine/M16
	name = "magazine box (M16 x 12)"
	icon_state = "base_m16"
	overlay_ammo_type = "_reg"
	overlay_gun_type = "_m16"
	num_of_magazines = 12
	magazine_type = /obj/item/ammo_magazine/rifle/m16

/obj/item/ammo_box/magazine/M16/empty
	empty = TRUE

/obj/item/ammo_box/magazine/M16/ap
	name = "magazine box (AP M16 x 12)"
	icon_state = "base_m16"
	overlay_ammo_type = "_ap"
	overlay_gun_type = "_m16"
	num_of_magazines = 12
	magazine_type = /obj/item/ammo_magazine/rifle/m16/ap

/obj/item/ammo_box/magazine/M16/ap/empty
	empty = TRUE

//-----------------------M4A3 Pistol Mag Box-----------------------

/obj/item/ammo_box/magazine/m4a3
	name = "magazine box (M4A3 x 16)"
	icon_state = "base_m4a3"
	overlay_ammo_type = "_reg"
	overlay_gun_type = "_m4a3"
	num_of_magazines = 16
	magazine_type = /obj/item/ammo_magazine/pistol

/obj/item/ammo_box/magazine/m4a3/empty
	empty = TRUE

/obj/item/ammo_box/magazine/m4a3/ap
	name = "magazine box (AP M4A3 x 16)"
	overlay_ammo_type = "_ap"
	overlay_content = "_ap"
	magazine_type = /obj/item/ammo_magazine/pistol/ap

/obj/item/ammo_box/magazine/m4a3/ap/empty
	empty = TRUE

/obj/item/ammo_box/magazine/m4a3/hp
	name = "magazine box (HP M4A3 x 16)"
	overlay_ammo_type = "_hp"
	overlay_content = "_hp"
	magazine_type = /obj/item/ammo_magazine/pistol/hp

/obj/item/ammo_box/magazine/m4a3/hp/empty
	empty = TRUE

//-----------------------M44 Revolver Speed Loaders Box-----------------------

/obj/item/ammo_box/magazine/m44
	name = "speed loaders box (M44 x 16)"
	icon_state = "base_m44"
	overlay_ammo_type = "_m44_reg"
	overlay_gun_type = "_m44"
	overlay_content = "_speed"
	num_of_magazines = 16
	magazine_type = /obj/item/ammo_magazine/revolver

/obj/item/ammo_box/magazine/m44/empty
	empty = TRUE

/obj/item/ammo_box/magazine/m44/marksman
	name = "speed loaders box (Marksman M44 x 16)"
	overlay_ammo_type = "_m44_mark"
	magazine_type = /obj/item/ammo_magazine/revolver/marksman

/obj/item/ammo_box/magazine/m44/marksman/empty
	empty = TRUE

/obj/item/ammo_box/magazine/m44/heavy
	name = "speed loaders box (Heavy M44 x 16)"
	overlay_ammo_type = "_m44_heavy"
	magazine_type = /obj/item/ammo_magazine/revolver/heavy

/obj/item/ammo_box/magazine/m44/heavy/empty
	empty = TRUE

//-----------------------SU-6 Smartpistol Mag Box-----------------------

/obj/item/ammo_box/magazine/su6
	name = "magazine box (SU-6 x 16)"
	icon_state = "base_su6"
	overlay_ammo_type = "_reg"
	overlay_gun_type = "_su6"
	num_of_magazines = 16
	magazine_type = /obj/item/ammo_magazine/pistol/smart

/obj/item/ammo_box/magazine/su6/empty
	empty = TRUE

//-----------------------88M4 Pistol Mag Box-----------------------

/obj/item/ammo_box/magazine/mod88
	name = "magazine box (88 Mod 4 AP x 16)"
	icon_state = "base_mod88"
	overlay_ammo_type = "_ap"
	overlay_gun_type = "_mod88"
	overlay_content = "_ap"
	num_of_magazines = 16
	magazine_type = /obj/item/ammo_magazine/pistol/mod88

/obj/item/ammo_box/magazine/mod88/empty
	empty = TRUE

//-----------------------VP78 Pistol Mag Box-----------------------

/obj/item/ammo_box/magazine/vp78
	name = "magazine box (VP78 x 16)"
	icon_state = "base_vp78"
	overlay_ammo_type = "_reg"
	overlay_gun_type = "_vp78"
	num_of_magazines = 16
	magazine_type = /obj/item/ammo_magazine/pistol/vp78

/obj/item/ammo_box/magazine/vp78/empty
	empty = TRUE

//-----------------------Type71 Rifle Mag Box-----------------------

/obj/item/ammo_box/magazine/type71
	name = "magazine box (Type71 x 10)"
	icon_state = "base_type71"
	overlay_ammo_type = "_type71_reg"
	overlay_gun_type = "_type71"
	overlay_content = "_type71_reg"
	num_of_magazines = 14
	magazine_type = /obj/item/ammo_magazine/rifle/type71

/obj/item/ammo_box/magazine/type71/empty
	empty = TRUE

/obj/item/ammo_box/magazine/type71/ap
	name = "magazine box (Type71 AP x 10)"
	overlay_ammo_type = "_type71_ap"
	overlay_content = "_type71_ap"
	magazine_type = /obj/item/ammo_magazine/rifle/type71/ap

/obj/item/ammo_box/magazine/type71/ap/empty
	empty = TRUE

//-----------------------MAG BOX STRUCTURE-----------------------

/obj/structure/magazine_box
	name = "magazine_box"
	icon = 'icons/obj/items/weapons/guns/ammo_box.dmi'
	icon_state = "base_m41"
	var/obj/item/ammo_box/magazine/item_box

/obj/structure/magazine_box/MouseDrop(over_object, src_location, over_location)
	..()
	if(over_object == usr && Adjacent(usr))
		if(!ishuman(usr))	return
		visible_message(SPAN_NOTICE("[usr] picks up [name]."))

		usr.put_in_hands(item_box)
		item_box = null
		qdel(src)

/obj/structure/magazine_box/examine(mob/user)
	..()
	if(get_dist(src,user) > 2 && !isobserver(user))
		return
	to_chat(user, SPAN_INFO("[SPAN_HELPFUL("Click")] on the box with an empty hand to take a magazine out. [SPAN_HELPFUL("Drag")] it onto yourself to pick it up."))
	if(item_box.handfuls)
		var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in item_box.contents
		if(AM)
			to_chat(user, SPAN_INFO("It has roughly [round(AM.current_rounds/5)] handfuls remaining."))
	else
		to_chat(user, SPAN_INFO("It has [item_box.contents.len] magazines out of [item_box.num_of_magazines]."))

/obj/structure/magazine_box/update_icon()
	if(overlays)
		overlays.Cut()
		overlays += image(icon, icon_state = "text[item_box.overlay_gun_type]")			//adding text

	if(!item_box.handfuls)
		overlays += image(icon, icon_state = "base_type[item_box.overlay_ammo_type]")		//adding base color stripes
		if(item_box.contents.len == item_box.num_of_magazines)
			overlays += image(icon, icon_state = "magaz[item_box.overlay_content]")
		else if(item_box.contents.len > (item_box.num_of_magazines/2))
			overlays += image(icon, icon_state = "magaz[item_box.overlay_content]_3")
		else if(item_box.contents.len > (item_box.num_of_magazines/4))
			overlays += image(icon, icon_state = "magaz[item_box.overlay_content]_2")
		else if(item_box.contents.len > 0)
			overlays += image(icon, icon_state = "magaz[item_box.overlay_content]_1")
	else
		var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in item_box.contents
		if(AM.current_rounds == item_box.num_of_magazines)
			overlays += image(icon, icon_state = "shells[item_box.overlay_content]")
		else if(AM.current_rounds > (item_box.num_of_magazines/2))
			overlays += image(icon, icon_state = "shells[item_box.overlay_content]_3")
		else if(AM.current_rounds > (item_box.num_of_magazines/4))
			overlays += image(icon, icon_state = "shells[item_box.overlay_content]_2")
		else if(AM.current_rounds > 0)
			overlays += image(icon, icon_state = "shells[item_box.overlay_content]_1")


/obj/structure/magazine_box/attack_hand(mob/living/user)
	if(item_box.contents.len)
		if(!item_box.handfuls)
			var/obj/item/ammo_magazine/AM = pick(item_box.contents)
			item_box.contents -= AM
			user.put_in_hands(AM)
			to_chat(user, SPAN_NOTICE("You retrieve a [AM] from \the [src]."))
		else
			var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in item_box.contents
			if(AM)
				AM.create_handful(user, 5, src)
		update_icon()
	else
		to_chat(user, SPAN_NOTICE("\The [src] is empty."))


/obj/structure/magazine_box/attackby(obj/item/W, mob/living/user)
	if(!item_box.handfuls)
		if(istypestrict(W,item_box.magazine_type))
			if(item_box.contents.len < item_box.num_of_magazines)
				user.drop_inv_item_to_loc(W, src)
				item_box.contents += W
				to_chat(user, SPAN_NOTICE("You put a [W] in to \the [src]"))
				update_icon()
			else
				to_chat(user, SPAN_WARNING("\The [src] is full."))
		else
			to_chat(user, SPAN_WARNING("You don't want to mix different magazines in one box."))
	else
		if(istype(W, /obj/item/ammo_magazine/shotgun))
			var/obj/item/ammo_magazine/O = W
			var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine/shotgun) in item_box.contents
			if(!O || !W)
				return
			if(O.default_ammo == AM.default_ammo)
				if(O.current_rounds <= 0)
					to_chat(user, SPAN_WARNING("\The [O] is empty."))
					return
				if(AM.current_rounds >= AM.max_rounds)
					to_chat(user, SPAN_WARNING("\The [src] is full."))
					return
				else
					if(!do_after(user, 15, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
						return
					playsound(loc, 'sound/weapons/gun_revolver_load3.ogg', 25, 1)
					var/S = min(O.current_rounds, AM.max_rounds - AM.current_rounds)
					AM.current_rounds += S
					O.current_rounds -= S
					to_chat(user, SPAN_NOTICE("You transfer shells from [O] into \the [src]"))
					update_icon()
					O.update_icon()
			else
				to_chat(user, SPAN_WARNING("Wrong type of shells."))

		if(istype(W, /obj/item/ammo_magazine/handful))
			var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in item_box.contents
			AM.attackby(W, user, 1)
			update_icon()

//-----------------------BIG AMMO BOX-----------------------

/obj/item/ammo_box/rounds
	name = "rifle ammunition box (10x24mm)"
	desc = "A 10x24mm ammunition box. Used to refill M41A MK1, MK2, L42A and M41AE2 HPR magazines. It comes with a leather strap allowing to wear it on the back."
	icon_state = "base_m41"
	item_state = "base_m41"
	flags_equip_slot = SLOT_BACK
	var/overlay_gun_type = "_rounds"		//used for ammo type color overlay
	var/overlay_content = "_reg"
	var/default_ammo = /datum/ammo/bullet/rifle
	var/bullet_amount = 600
	var/max_bullet_amount = 600
	var/caliber = "10x24mm"

/obj/item/ammo_box/rounds/Initialize()
	. = ..()
	if(empty)
		bullet_amount = 0
	update_icon()

/obj/item/ammo_box/rounds/empty
	empty = TRUE

/obj/item/ammo_box/rounds/update_icon()
	if(overlays)
		overlays.Cut()
	overlays += image(icon, icon_state = "text[overlay_gun_type]")	//adding base color stripes

	if(bullet_amount == max_bullet_amount)
		overlays += image(icon, icon_state = "rounds[overlay_content]")
	else if(bullet_amount > (max_bullet_amount/2))
		overlays += image(icon, icon_state = "rounds[overlay_content]_3")
	else if(bullet_amount > (max_bullet_amount/4))
		overlays += image(icon, icon_state = "rounds[overlay_content]_2")
	else if(bullet_amount > 0)
		overlays += image(icon, icon_state = "rounds[overlay_content]_1")

/obj/item/ammo_box/rounds/examine(mob/user)
	..()
	to_chat(user, SPAN_INFO("To refill a magazine click on the box with it in your hand. Being on [SPAN_HELPFUL("HARM")] intent will fill box from the magazine."))
	if(bullet_amount)
		to_chat(user, "It contains [bullet_amount] round\s.")
	else
		to_chat(user, "It's empty.")

/obj/item/ammo_box/rounds/attack_self(mob/living/user)
	if(bullet_amount < 1)
		unfold_box(user.loc)

/obj/item/ammo_box/rounds/proc/unfold_box(turf/T)
	new /obj/item/stack/sheet/cardboard(T)
	qdel(src)

/obj/item/ammo_box/rounds/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/AM = I
		if(!isturf(loc))
			to_chat(user, SPAN_WARNING("\The [src] must be on the ground to be used."))
			return
		if(AM.flags_magazine & AMMUNITION_REFILLABLE)
			if(default_ammo != AM.default_ammo)
				to_chat(user, SPAN_WARNING("Those aren't the same rounds. Better not mix them up."))
				return
			if(caliber != AM.caliber)
				to_chat(user, SPAN_WARNING("The rounds don't match up. Better not mix them up."))
				return


			var/source
			var/source_current
			var/destination
			var/destination_max
			var/destination_current
			var/action_icon

			if(user.a_intent == INTENT_HARM)	//we REFILL BOX on harm intent, otherwise we refill FROM box
				source = AM
				source_current = AM.current_rounds
				destination = src
				destination_current = bullet_amount
				destination_max = max_bullet_amount
				action_icon = BUSY_ICON_HOSTILE
			else
				source = src
				source_current = bullet_amount
				destination = AM
				destination_current = AM.current_rounds
				destination_max = AM.max_rounds
				action_icon = BUSY_ICON_FRIENDLY

			if(source_current <= 0)
				to_chat(user, SPAN_WARNING("\The [source] is empty."))
				return

			if(destination_current == destination_max)
				to_chat(user, SPAN_WARNING("\The [destination] is already full."))
				return

			visible_message(SPAN_NOTICE("[user] starts refilling [destination] from [source]."), SPAN_NOTICE("You start refilling [destination] from [source]."))

			var/S = min(source_current, destination_max - destination_current)
			//Amount of bullets we plan to transfer depending on amount in source

			var/bullets_transferred = 0

			//Amount of times timed action will be activated.
			//Standard M41A mag of 40 rounds or SMG mag of 48 takes 1.5 to refill from the box.
			for(var/i = 1;i <= Ceiling(S / 48); i++)
				if(!do_after(user, 15, INTERRUPT_ALL, action_icon))
					to_chat(user, SPAN_NOTICE("You stop transferring rounds from [source] into [destination]."))
					break
				playsound(loc, pick('sound/weapons/handling/mag_refill_1.ogg', 'sound/weapons/handling/mag_refill_2.ogg', 'sound/weapons/handling/mag_refill_3.ogg'), 25, 1)
				var/transfer = min(S - bullets_transferred, 48)
				destination_current += transfer
				source_current -= transfer
				bullets_transferred += transfer
				to_chat(user, SPAN_NOTICE("You have transferred [bullets_transferred] rounds out of [S] from [source] into [destination]."))

			if(source == AM)
				AM.current_rounds = source_current
				bullet_amount = destination_current
			else if(source == src)
				AM.current_rounds = destination_current
				bullet_amount = source_current
			else
				to_chat(user, SPAN_NOTICE("Error \"Lost source\" has occured in transferring code. Report this on Gitlab, please."))

			AM.update_icon(S)
			update_icon()

		else if(AM.flags_magazine & AMMUNITION_HANDFUL)
			if(caliber != AM.caliber)
				to_chat(user, SPAN_WARNING("The rounds don't match up. Better not mix them up."))
				return
			if(bullet_amount == max_bullet_amount)
				to_chat(user, SPAN_WARNING("\The [src] is already full."))
				return

			playsound(loc, pick('sound/weapons/handling/mag_refill_1.ogg', 'sound/weapons/handling/mag_refill_2.ogg', 'sound/weapons/handling/mag_refill_3.ogg'), 25, 1)
			var/S = min(AM.current_rounds, max_bullet_amount - bullet_amount)
			AM.current_rounds -= S
			bullet_amount += S
			AM.update_icon()
			update_icon()
			to_chat(user, SPAN_NOTICE("You put [S] rounds into [src]."))
			if(AM.current_rounds <= 0)
				user.temp_drop_inv_item(AM)
				qdel(AM)

//explosion when using flamer procs.
/obj/item/ammo_box/rounds/flamer_fire_act()
	switch(bullet_amount)
		if(0) return
		if(1 to 100) explosion(loc,  0, 0, 1, 2) //blow it up.
		else explosion(loc,  0, 0, 2, 3) //blow it up HARDER
	qdel(src)

/obj/item/ammo_box/rounds/ap
	name = "rifle ammunition box (10x24mm AP)"
	desc = "A 10x24mm armor-piercing ammunition box. Used to refill M41A MK2 and L42A AP magazines. It comes with a leather strap allowing to wear it on the back."
	overlay_content = "_ap"
	default_ammo = /datum/ammo/bullet/rifle/ap

/obj/item/ammo_box/rounds/ap/empty
	empty = TRUE

/obj/item/ammo_box/rounds/le
	name = "rifle ammunition box (10x24mm LE)"
	desc = "A 10x24mm armor-shredding ammunition box. Used to refill M41A MK2 and L42A LE magazines. It comes with a leather strap allowing to wear it on the back."
	overlay_content = "_le"
	default_ammo = /datum/ammo/bullet/rifle/le

/obj/item/ammo_box/rounds/le/empty
	empty = TRUE

/obj/item/ammo_box/rounds/incen
	name = "rifle ammunition box (10x24mm Incen)"
	desc = "A 10x24mm incendiary ammunition box. Used to refill M41A MK2 and L42A incendiary magazines. It comes with a leather strap allowing to wear it on the back."
	overlay_content = "_incen"
	default_ammo = /datum/ammo/bullet/rifle/incendiary
	bullet_amount = 400		//Incen is OP
	max_bullet_amount = 400

/obj/item/ammo_box/rounds/incen/empty
	empty = TRUE

//UPP type71

/obj/item/ammo_box/rounds/type71
	name = "rifle ammunition box (5.45x39mm)"
	desc = "A 5.45x39mm ammunition box. Used to refill Type71 magazines. It comes with a leather strap allowing to wear it on the back."
	icon_state = "base_type71"
	overlay_gun_type = "_rounds_type71"
	overlay_content = "_type71_reg"
	caliber = "5.45x39mm"
	default_ammo = /datum/ammo/bullet/rifle

/obj/item/ammo_box/rounds/type71/empty
	empty = TRUE

/obj/item/ammo_box/rounds/type71/ap
	name = "rifle ammunition box (5.45x39mm AP)"
	desc = "A 5.45x39mm armor-piercing ammunition box. Used to refill Type71 AP magazines. It comes with a leather strap allowing to wear it on the back."
	icon_state = "base_type71"
	overlay_gun_type = "_rounds_type71"
	overlay_content = "_type71_ap"
	default_ammo = /datum/ammo/bullet/rifle/ap

/obj/item/ammo_box/rounds/type71/ap/empty
	empty = TRUE

//SMG

/obj/item/ammo_box/rounds/smg
	name = "SMG ammunition box (10x20mm HV)"
	desc = "A 10x20mm ammunition box. Used to refill M39 HV and extended magazines. It comes with a leather strap allowing to wear it on the back."
	caliber = "10x20mm"
	icon_state = "base_m39"
	overlay_content = "_hv"
	default_ammo = /datum/ammo/bullet/smg/m39

/obj/item/ammo_box/rounds/smg/empty
	empty = TRUE

/obj/item/ammo_box/rounds/smg/ap
	name = "SMG ammunition box (10x20mm AP)"
	desc = "A 10x20mm armor-piercing ammunition box. Used to refill M39 AP magazines. It comes with a leather strap allowing to wear it on the back."
	caliber = "10x20mm"
	overlay_content = "_ap"
	default_ammo = /datum/ammo/bullet/smg/ap

/obj/item/ammo_box/rounds/smg/ap/empty
	empty = TRUE

/obj/item/ammo_box/rounds/smg/le
	name = "SMG ammunition box (10x20mm LE)"
	desc = "A 10x20mm armor-shredding ammunition box. Used to refill M39 LE magazines. It comes with a leather strap allowing to wear it on the back."
	caliber = "10x20mm"
	overlay_content = "_le"
	default_ammo = /datum/ammo/bullet/smg/le

/obj/item/ammo_box/rounds/smg/le/empty
	empty = TRUE

/obj/item/ammo_box/rounds/smg/incen
	name = "SMG ammunition box (10x20mm Incen)"
	desc = "A 10x20mm incendiary ammunition box. Used to refill M39 incendiary magazines. It comes with a leather strap allowing to wear it on the back."
	caliber = "10x20mm"
	overlay_content = "_incen"
	default_ammo = /datum/ammo/bullet/smg/incendiary
	bullet_amount = 400		//Incen is OP
	max_bullet_amount = 400

/obj/item/ammo_box/rounds/smg/incen/empty
	empty = TRUE

//Misc

/obj/item/ammo_box/magazine/misc
	name = "miscellaneous equipment box"
	desc = "A box for miscellaneous equipment."
	icon_state = "supply_crate"
	overlay_ammo_type = "blank"
	overlay_gun_type = "blank"
	overlay_content = ""

/obj/item/ammo_box/magazine/misc/mre
	name = "box of MREs"
	desc = "A box of MREs. Nutritious, but not delicious."
	magazine_type = /obj/item/storage/box/MRE
	num_of_magazines = 12
	overlay_content = "_mre"

/obj/item/ammo_box/magazine/misc/mre/empty
	empty = TRUE

/obj/item/ammo_box/magazine/misc/flares
	name = "box of M94 marking flare packs"
	desc = "A box of M94 marking flare packs, to brighten up your day."
	magazine_type = /obj/item/storage/box/m94
	num_of_magazines = 10
	overlay_content = "_flares"

/obj/item/ammo_box/magazine/misc/flares/empty
	empty = TRUE
