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
	base_mag_icon = icon_state
	base_mag_item = item_state
	if(spawn_empty) current_rounds = 0
	switch(current_rounds)
		if(-1) current_rounds = max_rounds //Fill it up. Anything other than -1 and 0 will just remain so.
		if(0)
			icon_state += "_e" //In case it spawns empty instead.
			item_state += "_e"

/obj/item/ammo_magazine/update_icon(var/round_diff = 0) //inhand sprites only get their icon update called when picked back up or removed from storage, known issue.
	if(current_rounds <= 0) 
		icon_state = base_mag_icon + "_e"
		item_state = base_mag_item + "_e"
	else if(current_rounds - round_diff <= 0)
		icon_state = base_mag_icon
		item_state = base_mag_item //to-do, unique magazine inhands for majority firearms.

/obj/item/ammo_magazine/examine(mob/user)
	..()
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

/obj/item/ammo_magazine/handful/Dispose()
	..()
	return GC_HINT_RECYCLE

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

/obj/item/magazine_box
	name = "magazine box (M41A x 10)"
	w_class = SIZE_HUGE
	icon = 'icons/obj/items/ammo_box.dmi'
	icon_state = "mag_box_m41_closed"
	var/icon_base_name = "mag_box_m41"
	var/magazine_type = /obj/item/ammo_magazine/rifle
	var/num_of_magazines = 10
	var/spawn_full = 1
	var/handfuls = 0

/obj/item/magazine_box/empty
	spawn_full = 0

/obj/item/magazine_box/New()
	if(spawn_full)
		if(handfuls)
			var/obj/item/ammo_magazine/AM = new magazine_type(src)
			AM.max_rounds = num_of_magazines
			AM.current_rounds = num_of_magazines
		else
			var/i = 0
			while(i < num_of_magazines)
				contents += new magazine_type(src)
				i++
	else
		if(handfuls)
			var/obj/item/ammo_magazine/AM = new magazine_type(src)
			AM.max_rounds = num_of_magazines
			AM.current_rounds = 0

/obj/item/magazine_box/update_icon()
	icon_state = "[icon_base_name]_closed"

/obj/item/magazine_box/examine(mob/living/user)
	..()
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

/obj/item/magazine_box/attack_self(mob/living/user)
	deploy_ammo_box(user, user.loc)

/obj/item/magazine_box/proc/deploy_ammo_box(mob/living/user, turf/T)
	for(var/obj/structure/magazine_box/MB in T.contents)
		to_chat(user, SPAN_WARNING("There is a [MB] deployed here already."))
		return
	var/obj/structure/magazine_box/M = new /obj/structure/magazine_box(T)
	M.icon_base_name = icon_base_name
	M.name = name
	M.desc = desc
	M.item_box = src
	M.update_icon()
	user.drop_inv_item_on_ground(src)
	Move(M)
	//qdel(src)

/obj/item/magazine_box/afterattack(atom/target, mob/living/user, proximity)
	if(!proximity)
		return
	if(isturf(target))
		var/turf/T = target
		if(!T.density)
			deploy_ammo_box(user, T)

//-----------------------SHOTGUN SHELL BOXES-----------------------

/obj/item/magazine_box/shotgun
	name = "shotgun shell box (Slugs x 100)"
	icon_state = "shell_box_closed"
	icon_base_name = "shell_box"
	magazine_type = /obj/item/ammo_magazine/shotgun/slugs
	num_of_magazines = 100
	handfuls = 1

/obj/item/magazine_box/shotgun/empty
	spawn_full = 0

/obj/item/magazine_box/shotgun/buckshot
	name = "shotgun shell box (Buckshot x 100)"
	icon_state = "shell_box_buck_closed"
	icon_base_name = "shell_box_buck"
	magazine_type = /obj/item/ammo_magazine/shotgun/buckshot

/obj/item/magazine_box/shotgun/buckshot/empty
	spawn_full = 0

/obj/item/magazine_box/shotgun/flechette
	name = "shotgun shell box (Flechette x 100)"
	icon_state = "shell_box_flech_closed"
	icon_base_name = "shell_box_flech"
	magazine_type = /obj/item/ammo_magazine/shotgun/flechette

/obj/item/magazine_box/shotgun/flechette/empty
	spawn_full = 0

//-----------------------M41A Rifle Mag Boxes-----------------------

/obj/item/magazine_box/ap
	name = "magazine box (AP M41A x 10)"
	icon_state = "mag_box_m41_ap_closed"
	icon_base_name = "mag_box_m41_ap"
	magazine_type = /obj/item/ammo_magazine/rifle/ap

/obj/item/magazine_box/ap/empty
	spawn_full = 0

/obj/item/magazine_box/le
	name = "magazine box (LE M41A x 10)"
	icon_state = "mag_box_m41_le_closed"
	icon_base_name = "mag_box_m41_le"
	magazine_type = /obj/item/ammo_magazine/rifle/le

/obj/item/magazine_box/le/empty
	spawn_full = 0

/obj/item/magazine_box/ext
	name = "magazine box (Ext M41A x 8)"
	icon_state = "mag_box_m41_ext_closed"
	icon_base_name = "mag_box_m41_ext"
	num_of_magazines = 8
	magazine_type = /obj/item/ammo_magazine/rifle/extended

/obj/item/magazine_box/ext/empty
	spawn_full = 0

/obj/item/magazine_box/incen
	name = "magazine box (Incen M41A x 10)"
	icon_state = "mag_box_m41_incen_closed"
	icon_base_name = "mag_box_m41_incen"
	magazine_type = /obj/item/ammo_magazine/rifle/incendiary

/obj/item/magazine_box/incen/empty
	spawn_full = 0

/obj/item/magazine_box/explosive
	name = "magazine box (Explosive M41A x 10)"
	icon_state = "mag_box_m41_expl_closed"
	icon_base_name = "mag_box_m41_expl"
	magazine_type = /obj/item/ammo_magazine/rifle/explosive

/obj/item/magazine_box/explosive/empty
	spawn_full = 0

//-----------------------M39 Rifle Mag Boxes-----------------------

/obj/item/magazine_box/m39
	name = "magazine box (M39 x 12)"
	icon_state = "mag_box_m39_closed"
	icon_base_name = "mag_box_m39"
	num_of_magazines = 12
	magazine_type = /obj/item/ammo_magazine/smg/m39

/obj/item/magazine_box/m39/empty
	spawn_full = 0

/obj/item/magazine_box/m39/ap
	name = "magazine box (AP M39 x 12)"
	icon_state = "mag_box_m39_ap_closed"
	icon_base_name = "mag_box_m39_ap"
	magazine_type = /obj/item/ammo_magazine/smg/m39/ap

/obj/item/magazine_box/m39/ap/empty
	spawn_full = 0

/obj/item/magazine_box/m39/ext
	name = "magazine box (Ext m39 x 10)"
	icon_state = "mag_box_m39_ext_closed"
	icon_base_name = "mag_box_m39_ext"
	num_of_magazines = 10
	magazine_type = /obj/item/ammo_magazine/smg/m39/extended

/obj/item/magazine_box/m39/ext/empty
	spawn_full = 0

/obj/item/magazine_box/m39/incen
	name = "magazine box (Incen m39 x 12)"
	icon_state = "mag_box_m39_incen_closed"
	icon_base_name = "mag_box_m39_incen"
	magazine_type = /obj/item/ammo_magazine/smg/m39/incendiary

/obj/item/magazine_box/m39/incen/empty
	spawn_full = 0

/obj/item/magazine_box/m39/le
	name = "magazine box (LE m39 x 12)"
	icon_state = "mag_box_m39_le_closed"
	icon_base_name = "mag_box_m39_le"
	magazine_type = /obj/item/ammo_magazine/smg/m39/le

/obj/item/magazine_box/m39/le/empty
	spawn_full = 0

//-----------------------l42a Carbine Mag Boxes-----------------------

/obj/item/magazine_box/l42a
	name = "magazine box (L42A x 16)"
	icon_state = "mag_box_l42_closed"
	icon_base_name = "mag_box_l42"
	num_of_magazines = 16
	magazine_type = /obj/item/ammo_magazine/rifle/l42a

/obj/item/magazine_box/l42a/empty
	spawn_full = 0

/obj/item/magazine_box/l42a/ap
	name = "magazine box (AP L42A x 16)"
	icon_state = "mag_box_l42_ap_closed"
	icon_base_name = "mag_box_l42_ap"
	magazine_type = /obj/item/ammo_magazine/rifle/l42a/ap

/obj/item/magazine_box/l42a/ap/empty
	spawn_full = 0

/obj/item/magazine_box/l42a/le
	name = "magazine box (LE L42A x 16)"
	icon_state = "mag_box_l42_le_closed"
	icon_base_name = "mag_box_l42_le"
	magazine_type = /obj/item/ammo_magazine/rifle/l42a/le

/obj/item/magazine_box/l42a/le/empty
	spawn_full = 0

/obj/item/magazine_box/l42a/ext
	name = "magazine box (Ext L42A x 12)"
	icon_state = "mag_box_l42_ext_closed"
	icon_base_name = "mag_box_l42_ext"
	num_of_magazines = 12
	magazine_type = /obj/item/ammo_magazine/rifle/l42a/extended

/obj/item/magazine_box/l42a/ext/empty
	spawn_full = 0

/obj/item/magazine_box/l42a/incen
	name = "magazine box (Incen L42A x 16)"
	icon_state = "mag_box_l42_incen_closed"
	icon_base_name = "mag_box_l42_incen"
	magazine_type = /obj/item/ammo_magazine/rifle/l42a/incendiary

/obj/item/magazine_box/l42a/incen/empty
	spawn_full = 0

//-----------------------M16 Rifle Mag Box-----------------------

/obj/item/magazine_box/M16
	name = "magazine box (M16 x 12)"
	icon_state = "mag_box_m16_closed"
	icon_base_name = "mag_box_m16"
	num_of_magazines = 12
	magazine_type = /obj/item/ammo_magazine/rifle/m16

/obj/item/magazine_box/M16/empty
	spawn_full = 0

//-----------------------M4A3 Pistol Mag Box-----------------------

/obj/item/magazine_box/m4a3
	name = "magazine box (M4A3 x 16)"
	icon_state = "mag_box_m4a3_closed"
	icon_base_name = "mag_box_m4a3"
	num_of_magazines = 16
	magazine_type = /obj/item/ammo_magazine/pistol

/obj/item/magazine_box/m4a3/empty
	spawn_full = 0

/obj/item/magazine_box/m4a3/ap
	name = "magazine box (AP M4A3 x 16)"
	icon_state = "mag_box_m4a3_ap_closed"
	icon_base_name = "mag_box_m4a3_ap"
	num_of_magazines = 16
	magazine_type = /obj/item/ammo_magazine/pistol/ap

/obj/item/magazine_box/m4a3/ap/empty
	spawn_full = 0

//-----------------------SU-6 Smartpistol Mag Box-----------------------

/obj/item/magazine_box/su6
	name = "magazine box (SU-6 x 16)"
	icon_state = "mag_box_su6_closed"
	icon_base_name = "mag_box_su6"
	num_of_magazines = 16
	magazine_type = /obj/item/ammo_magazine/pistol/smart

/obj/item/magazine_box/su6/empty
	spawn_full = 0

//-----------------------88M4 Pistol Mag Box-----------------------

/obj/item/magazine_box/mod88
	name = "magazine box (88 Mod 4 AP x 16)"
	icon_state = "mag_box_mod88_closed"
	icon_base_name = "mag_box_mod88"
	num_of_magazines = 16
	magazine_type = /obj/item/ammo_magazine/pistol/mod88

/obj/item/magazine_box/mod88/empty
	spawn_full = 0

//-----------------------VP78 Pistol Mag Box-----------------------

/obj/item/magazine_box/vp78
	name = "magazine box (VP78 x 16)"
	icon_state = "mag_box_vp78_closed"
	icon_base_name = "mag_box_vp78"
	num_of_magazines = 16
	magazine_type = /obj/item/ammo_magazine/pistol/vp78

/obj/item/magazine_box/vp78/empty
	spawn_full = 0

//-----------------------Type71 Rifle Mag Box-----------------------

/obj/item/magazine_box/type71
	name = "magazine box (Type71 x 10)"
	icon_state = "mag_box_type71_closed"
	icon_base_name = "mag_box_type71"
	num_of_magazines = 14
	magazine_type = /obj/item/ammo_magazine/rifle/type71

/obj/item/magazine_box/type71/empty
	spawn_full = 0

//-----------------------MAG BOX STRUCTURE-----------------------

/obj/structure/magazine_box
	name = "magazine_box"
	desc = "a box for holding many magazines, this one is open and needs to be closed before you can pick it up."
	icon = 'icons/obj/items/ammo_box.dmi'
	icon_state = "mag_box_m41"
	var/icon_base_name = "mag_box_m41"
	var/obj/item/magazine_box/item_box

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
	if(item_box.handfuls)
		var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in item_box.contents
		if(AM)
			to_chat(user, SPAN_INFO("It has roughly [round(AM.current_rounds/5)] handfuls remaining."))
	else
		to_chat(user, SPAN_INFO("It has [item_box.contents.len] magazines out of [item_box.num_of_magazines]."))

/obj/structure/magazine_box/update_icon()
	if(!item_box.handfuls)
		if(item_box.contents.len == item_box.num_of_magazines)
			icon_state = "[item_box.icon_base_name]"
		else if(item_box.contents.len > (item_box.num_of_magazines/2))
			icon_state = "[item_box.icon_base_name]_3"
		else if(item_box.contents.len > (item_box.num_of_magazines/4))
			icon_state = "[item_box.icon_base_name]_2"
		else if(item_box.contents.len > 0)
			icon_state = "[item_box.icon_base_name]_1"
		else
			icon_state = "[item_box.icon_base_name]_empty"
	else
		var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in item_box.contents

		if(AM.current_rounds == item_box.num_of_magazines)
			icon_state = "[item_box.icon_base_name]"
		else if(AM.current_rounds > (item_box.num_of_magazines/2))
			icon_state = "[item_box.icon_base_name]_3"
		else if(AM.current_rounds > (item_box.num_of_magazines/4))
			icon_state = "[item_box.icon_base_name]_2"
		else if(AM.current_rounds > 0)
			icon_state = "[item_box.icon_base_name]_1"
		else
			icon_state = "[item_box.icon_base_name]_empty"

/obj/structure/magazine_box/attack_hand(mob/living/user)
	if(item_box.contents.len)
		if(!item_box.handfuls)
			var/obj/item/ammo_magazine/AM = pick(item_box.contents)
			item_box.contents -= AM
			user.put_in_hands(AM)
			to_chat(user, SPAN_NOTICE("You retrieve a [AM] from \the [src], it has [AM.current_rounds] rounds remaining in the magazine."))
		else
			var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in item_box.contents
			if(AM)
				AM.create_handful(user, 5, src)
		update_icon()
	else
		to_chat(user, SPAN_NOTICE("\The [src] is empty."))


/obj/structure/magazine_box/attackby(obj/item/W, mob/living/user)
	if(!item_box.handfuls)
		if(istype(W,item_box.magazine_type))
			if(item_box.contents.len < item_box.num_of_magazines)
				user.drop_inv_item_to_loc(W, src)
				item_box.contents += W
				to_chat(user, SPAN_NOTICE("You put a [W] in to \the [src]"))
				update_icon()
			else
				to_chat(user, SPAN_WARNING("\The [src] is full."))
	else
		if(istype(W,/obj/item/ammo_magazine/handful))
			var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in item_box.contents
			AM.attackby(W, user, 1)
			update_icon()

//-----------------------BIG AMMO BOX-----------------------

/obj/item/big_ammo_box
	name = "rifle ammunition box (10x24mm)"
	desc = "A 10x24mm ammunition box. Used to refill M41A MK1, MK2, L42A and M41AE2 HPR magazines. It comes with a leather strap."
	w_class = SIZE_HUGE
	icon = 'icons/obj/items/ammo_box.dmi'
	icon_state = "big_ammo_box"
	item_state = "big_ammo_box"
	flags_equip_slot = SLOT_BACK
	var/base_icon_state = "big_ammo_box"
	var/default_ammo = /datum/ammo/bullet/rifle
	var/bullet_amount = 600
	var/max_bullet_amount = 600
	var/caliber = "10x24mm"

/obj/item/big_ammo_box/update_icon()
	if(bullet_amount == max_bullet_amount)
		icon_state = base_icon_state
	else if(bullet_amount > (max_bullet_amount/2))
		icon_state = "[base_icon_state]_3"
	else if(bullet_amount > (max_bullet_amount/4))
		icon_state = "[base_icon_state]_2"
	else if(bullet_amount > 0)
		icon_state = "[base_icon_state]_1"
	else
		icon_state = "[base_icon_state]_e"

/obj/item/big_ammo_box/examine(mob/user)
	..()
	if(bullet_amount)
		to_chat(user, "It contains [bullet_amount] round\s.")
	else
		to_chat(user, "It's empty.")

/obj/item/big_ammo_box/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/AM = I
		if(!isturf(loc))
			to_chat(user, SPAN_WARNING("[src] must be on the ground to be used."))
			return
		if(AM.flags_magazine & AMMUNITION_REFILLABLE)
			if(default_ammo != AM.default_ammo)
				to_chat(user, SPAN_WARNING("Those aren't the same rounds. Better not mix them up."))
				return
			if(caliber != AM.caliber)
				to_chat(user, SPAN_WARNING("The rounds don't match up. Better not mix them up."))
				return
			if(AM.current_rounds == AM.max_rounds)
				to_chat(user, SPAN_WARNING("[AM] is already full."))
				return
			if(!do_after(user,15, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
				return
			playsound(loc, 'sound/weapons/gun_revolver_load3.ogg', 25, 1)
			var/S = min(bullet_amount, AM.max_rounds - AM.current_rounds)
			AM.current_rounds += S
			bullet_amount -= S
			AM.update_icon(S)
			update_icon()
			if(AM.current_rounds == AM.max_rounds)
				to_chat(user, SPAN_NOTICE("You refill [AM]."))
			else
				to_chat(user, SPAN_NOTICE("You put [S] rounds in [AM]."))
		else if(AM.flags_magazine & AMMUNITION_HANDFUL)
			if(caliber != AM.caliber)
				to_chat(user, SPAN_WARNING("The rounds don't match up. Better not mix them up."))
				return
			if(bullet_amount == max_bullet_amount)
				to_chat(user, SPAN_WARNING("[src] is full!"))
				return
			playsound(loc, 'sound/weapons/gun_revolver_load3.ogg', 25, 1)
			var/S = min(AM.current_rounds, max_bullet_amount - bullet_amount)
			AM.current_rounds -= S
			bullet_amount += S
			AM.update_icon()
			update_icon()
			to_chat(user, SPAN_NOTICE("You put [S] rounds in [src]."))
			if(AM.current_rounds <= 0)
				user.temp_drop_inv_item(AM)
				qdel(AM)

//explosion when using flamer procs.
/obj/item/big_ammo_box/flamer_fire_act()
	switch(bullet_amount)
		if(0) return
		if(1 to 100) explosion(loc,  0, 0, 1, 2) //blow it up.
		else explosion(loc,  0, 0, 2, 3) //blow it up HARDER
	qdel(src)

/obj/item/big_ammo_box/ap
	name = "rifle ammunition box (10x24mm AP)"
	desc = "A 10x24mm armor-piercing ammunition box. Used to refill M41A MK2 and L42A AP magazines. It comes with a leather strap."
	icon_state = "big_ammo_box_ap"
	base_icon_state = "big_ammo_box_ap"
	item_state = "big_ammo_box"
	default_ammo = /datum/ammo/bullet/rifle/ap

/obj/item/big_ammo_box/le
	name = "rifle ammunition box (10x24mm LE)"
	desc = "A 10x24mm armor-shredding ammunition box. Used to refill M41A MK2 and L42A LE magazines. It comes with a leather strap."
	icon_state = "big_ammo_box_le"
	base_icon_state = "big_ammo_box_le"
	item_state = "big_ammo_box"
	default_ammo = /datum/ammo/bullet/rifle/le

/obj/item/big_ammo_box/incen
	name = "rifle ammunition box (10x24mm Incen)"
	desc = "A 10x24mm incendiary ammunition box. Used to refill M41A MK2 and L42A incendiary magazines. It comes with a leather strap."
	icon_state = "big_ammo_box_incen"
	base_icon_state = "big_ammo_box_incen"
	item_state = "big_ammo_box"
	default_ammo = /datum/ammo/bullet/rifle/incendiary
	bullet_amount = 400		//Incen is OP
	max_bullet_amount = 400

//UPP type71

/obj/item/big_ammo_box/type71
	name = "rifle ammunition box (7.62x39mm)"
	desc = "A 7.62x39mm ammunition box. Used to refill Type71 and MAR magazines. It comes with a leather strap."
	icon_state = "big_ammo_box_type71"
	base_icon_state = "big_ammo_box_type71"
	item_state = "big_ammo_box"
	default_ammo = /datum/ammo/bullet/rifle/mar40

//SMG

/obj/item/big_ammo_box/smg
	name = "SMG ammunition box (10x20mm)"
	desc = "A 10x20mm ammunition box. Used to refill M39 magazines. It comes with a leather strap."
	caliber = "10x20mm"
	icon_state = "big_ammo_box_m39"
	base_icon_state = "big_ammo_box_m39"
	item_state = "big_ammo_box_m39"
	default_ammo = /datum/ammo/bullet/smg

/obj/item/big_ammo_box/smg/ap
	name = "SMG ammunition box (10x20mm AP)"
	desc = "A 10x20mm armor-piercing ammunition box. Used to refill M39 AP magazines. It comes with a leather strap."
	caliber = "10x20mm"
	icon_state = "big_ammo_box_ap_m39"
	base_icon_state = "big_ammo_box_ap_m39"
	item_state = "big_ammo_box_m39"
	default_ammo = /datum/ammo/bullet/smg/ap

/obj/item/big_ammo_box/smg/incen
	name = "SMG ammunition box (10x20mm Incen)"
	desc = "A 10x20mm incendiary ammunition box. Used to refill M39 incendiary magazines. It comes with a leather strap."
	caliber = "10x20mm"
	icon_state = "big_ammo_box_m39_incen"
	base_icon_state = "big_ammo_box_incen_m39"
	item_state = "big_ammo_box_m39"
	default_ammo = /datum/ammo/bullet/smg/incendiary
	bullet_amount = 400		//Incen is OP
	max_bullet_amount = 400

/obj/item/big_ammo_box/smg/le
	name = "SMG ammunition box (10x20mm LE)"
	desc = "A 10x20mm armor-shredding ammunition box. Used to refill M39 LE magazines. It comes with a leather strap."
	caliber = "10x20mm"
	icon_state = "big_ammo_box_le_m39"
	base_icon_state = "big_ammo_box_le_m39"
	item_state = "big_ammo_box_le_m39"
	default_ammo = /datum/ammo/bullet/smg/le