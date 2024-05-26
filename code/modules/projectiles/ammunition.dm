//Magazine items, and casings.
/*
Boxes of ammo. Certain weapons have internal boxes of ammo that cannot be removed and function as part of the weapon.
They're all essentially identical when it comes to getting the job done.
*/
/obj/item/ammo_magazine
	name = "generic ammo"
	desc = "A box of ammo."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
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
	ground_offset_x = 7
	ground_offset_y = 6
	var/default_ammo = /datum/ammo/bullet
	var/caliber = null // This is used for matching handfuls to each other or whatever the mag is. Examples are" "12g" ".44" ".357" etc.
	var/current_rounds = -1 //Set this to something else for it not to start with different initial counts.
	var/max_rounds = 7 //How many rounds can it hold?
	var/max_inherent_rounds = 0 //How many extra rounds the magazine has thats not in use? Used for Sentry Post, specifically for inherent reloading
	var/gun_type = null //Path of the gun that it fits. Mags will fit any of the parent guns as well, so make sure you want this.
	var/reload_delay = 1 //Set a timer for reloading mags. Higher is slower.
	var/flags_magazine = AMMUNITION_REFILLABLE //flags specifically for magazines.
	var/base_mag_icon //the default mag icon state.
	var/base_mag_item //the default mag item (inhand) state.
	var/transfer_handful_amount = 8 //amount of bullets to transfer, 5 for 12g, 9 for 45-70
	var/handful_state = "bullet" //used for generating handfuls from boxes and setting their sprite when loading/unloading

	/// If this and ammo_band_icon aren't null, run update_ammo_band(). Is the color of the band, such as green on AP.
	var/ammo_band_color
	/// If this and ammo_band_color aren't null, run update_ammo_band() Is the greyscale icon used for the ammo band.
	var/ammo_band_icon
	/// Is the greyscale icon used for the ammo band when it's empty of bullets.
	var/ammo_band_icon_empty


/obj/item/ammo_magazine/Initialize(mapload, spawn_empty)
	. = ..()
	GLOB.ammo_magazine_list += src
	base_mag_icon = icon_state
	base_mag_item = item_state
	if(spawn_empty) current_rounds = 0
	switch(current_rounds)
		if(-1) current_rounds = max_rounds //Fill it up. Anything other than -1 and 0 will just remain so.
		if(0)
			icon_state += "_e" //In case it spawns empty instead.
			item_state += "_e"

	if(ammo_band_color && ammo_band_icon)
		update_ammo_band()


/obj/item/ammo_magazine/Destroy()
	GLOB.ammo_magazine_list -= src
	return ..()

/obj/item/ammo_magazine/proc/update_ammo_band()
	overlays.Cut()
	var/band_icon = ammo_band_icon
	if(!current_rounds)
		band_icon = ammo_band_icon_empty
	var/image/ammo_band_image = image(icon, src, band_icon)
	ammo_band_image.color = ammo_band_color
	ammo_band_image.appearance_flags = RESET_COLOR|KEEP_APART
	overlays += ammo_band_image

/obj/item/ammo_magazine/update_icon(round_diff = 0)
	if(current_rounds <= 0)
		icon_state = base_mag_icon + "_e"
		item_state = base_mag_item + "_e"
		add_to_garbage(src)
	else if(current_rounds - round_diff <= 0)
		icon_state = base_mag_icon
		item_state = base_mag_item //to-do, unique magazine inhands for majority firearms.
	if(iscarbon(loc))
		var/mob/living/carbon/C = loc
		if(C.r_hand == src)
			C.update_inv_r_hand()
		else if(C.l_hand == src)
			C.update_inv_l_hand()
	if(ammo_band_color && ammo_band_icon)
		update_ammo_band()

/obj/item/ammo_magazine/get_examine_text(mob/user)
	. = ..()

	if(flags_magazine & AMMUNITION_HIDE_AMMO)
		return
	// It should never have negative ammo after spawn. If it does, we need to know about it.
	if(current_rounds < 0)
		. += "Something went horribly wrong. Ahelp the following: ERROR CODE R1: negative current_rounds on examine."
		log_debug("ERROR CODE R1: negative current_rounds on examine. User: <b>[usr]</b> Magazine: <b>[src]</b>")
	else
		. += "[src] has <b>[current_rounds]</b> rounds out of <b>[max_rounds]</b>."

/obj/item/ammo_magazine/attack_hand(mob/user)
	if(flags_magazine & AMMUNITION_REFILLABLE) //actual refillable magazine, not just a handful of bullets or a fuel tank.
		if(src == user.get_inactive_hand()) //Have to be holding it in the hand.
			if(flags_magazine & AMMUNITION_CANNOT_REMOVE_BULLETS)
				to_chat(user, SPAN_WARNING("You can't remove ammo from \the [src]!"))
				return
			if (current_rounds > 0)
				if(create_handful(user))
					return
			else to_chat(user, "[src] is empty. Nothing to grab.")
			return
	return ..() //Do normal stuff.

//We should only attack it with handfuls. Empty hand to take out, handful to put back in. Same as normal handful.
/obj/item/ammo_magazine/attackby(obj/item/I, mob/living/user, bypass_hold_check = 0)
	if(istype(I, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/MG = I
		if((MG.flags_magazine & AMMUNITION_HANDFUL) || (MG.flags_magazine & AMMUNITION_SLAP_TRANSFER)) //got a handful of bullets
			if(flags_magazine & AMMUNITION_REFILLABLE) //and a refillable magazine
				var/obj/item/ammo_magazine/handful/transfer_from = I
				if(src == user.get_inactive_hand() || bypass_hold_check) //It has to be held.
					if(default_ammo == transfer_from.default_ammo)
						if(transfer_ammo(transfer_from,user,transfer_from.current_rounds)) // This takes care of the rest.
							to_chat(user, SPAN_NOTICE("You transfer rounds to [src] from [transfer_from]."))
					else
						to_chat(user, SPAN_NOTICE("Those aren't the same rounds. Better not mix them up."))
				else
					to_chat(user, SPAN_NOTICE("Try holding [src] before you attempt to restock it."))

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

	if(!istype(src, /obj/item/ammo_magazine/internal) && !istype(src, /obj/item/ammo_magazine/shotgun) && !istype(source, /obj/item/ammo_magazine/shotgun)) //if we are shotgun or revolver or whatever not using normal mag system
		playsound(loc, pick('sound/weapons/handling/mag_refill_1.ogg', 'sound/weapons/handling/mag_refill_2.ogg', 'sound/weapons/handling/mag_refill_3.ogg'), 25, 1)

	update_icon(S)
	return S // We return the number transferred if it was successful.

/// Proc to reload the current_ammo using the items existing inherent ammo, used for Sentry Post
/obj/item/ammo_magazine/proc/inherent_reload(mob/user)
	if(current_rounds == max_rounds) //Does the mag actually need reloading?
		to_chat(user, SPAN_WARNING("[src] is already full."))
		return 0

	var/rounds_to_reload = max_rounds - current_rounds
	current_rounds += rounds_to_reload
	max_inherent_rounds -= rounds_to_reload

	return rounds_to_reload // Returns the amount of ammo it reloaded

//This will attempt to place the ammo in the user's hand if possible.
/obj/item/ammo_magazine/proc/create_handful(mob/user, transfer_amount, obj_name = src)
	var/amount_to_transfer
	if (current_rounds > 0)
		var/obj/item/ammo_magazine/handful/new_handful = new /obj/item/ammo_magazine/handful
		amount_to_transfer = transfer_amount ? min(current_rounds, transfer_amount) : min(current_rounds, transfer_handful_amount)
		new_handful.generate_handful(default_ammo, caliber, transfer_handful_amount, amount_to_transfer, gun_type)
		current_rounds -= amount_to_transfer
		if(!istype(src, /obj/item/ammo_magazine/internal) && !istype(src, /obj/item/ammo_magazine/shotgun)) //if we are shotgun or revolver or whatever not using normal mag system
			playsound(loc, pick('sound/weapons/handling/mag_refill_1.ogg', 'sound/weapons/handling/mag_refill_2.ogg', 'sound/weapons/handling/mag_refill_3.ogg'), 25, 1)

		if(user)
			user.put_in_hands(new_handful)
			to_chat(user, SPAN_NOTICE("You grab <b>[amount_to_transfer]</b> round\s from [obj_name]."))

		else new_handful.forceMove(get_turf(src))
		update_icon(-amount_to_transfer) //Update the other one.
	return amount_to_transfer //Give the number created.

//our magazine inherits ammo info from a source magazine
/obj/item/ammo_magazine/proc/match_ammo(obj/item/ammo_magazine/source)
	caliber = source.caliber
	default_ammo = source.default_ammo
	gun_type = source.gun_type

//~Art interjecting here for explosion when using flamer procs.
/obj/item/ammo_magazine/flamer_fire_act(damage, datum/cause_data/flame_cause_data)
	if(current_rounds < 1)
		return
	else
		var/severity = floor(current_rounds / 50)
		//the more ammo inside, the faster and harder it cooks off
		if(severity > 0)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(explosion), loc, -1, ((severity > 4) ? 0 : -1), clamp(severity, 0, 1), clamp(severity, 0, 2), 1, 0, 0, flame_cause_data), max(5 - severity, 2))

	if(!QDELETED(src))
		qdel(src)

//our fueltanks are extremely fire-retardant and won't explode
/obj/item/ammo_magazine/flamer_tank/flamer_fire_act(damage, datum/cause_data/flame_cause_data)
	return

//Magazines that actually cannot be removed from the firearm. Functionally the same as the regular thing, but they do have three extra vars.
/obj/item/ammo_magazine/internal
	name = "internal chamber"
	desc = "You should not be able to examine it."
	//For revolvers and shotguns.
	var/chamber_contents[] //What is actually in the chamber. Initiated on New().
	var/chamber_position = 1 //Where the firing pin is located. We usually move this instead of the contents.
	var/chamber_closed = 1 //Starts out closed. Depends on firearm.

//Helper proc, to allow us to see a percentage of how full the magazine is.
/obj/item/ammo_magazine/proc/get_ammo_percent() // return % charge of cell
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
	icon = 'icons/obj/items/weapons/guns/handful.dmi'
	icon_state = "bullet_1"
	matter = list("metal" = 50) //This changes based on the ammo ammount. 5k is the base of one shell/bullet.
	flags_equip_slot = null // It only fits into pockets and such.
	w_class = SIZE_SMALL
	current_rounds = 1 // So it doesn't get autofilled for no reason.
	max_rounds = 5 // For shotguns, though this will be determined by the handful type when generated.
	flags_atom = FPRINT|CONDUCT
	flags_magazine = AMMUNITION_HANDFUL
	attack_speed = 3 // should make reloading less painful

/obj/item/ammo_magazine/handful/Initialize(mapload, spawn_empty)
	. = ..()
	update_icon()

/obj/item/ammo_magazine/handful/update_icon() //Handles the icon itself as well as some bonus things.
	if(max_rounds >= current_rounds)
		var/I = current_rounds*50 // For the metal.
		matter = list("metal" = I)
	icon_state = handful_state + "_[current_rounds]"

/obj/item/ammo_magazine/handful/pickup(mob/user)
	var/olddir = dir
	. = ..()
	dir = olddir

/obj/item/ammo_magazine/handful/equipped(mob/user, slot)
	var/thisDir = src.dir
	..(user,slot)
	setDir(thisDir)
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

/obj/item/ammo_magazine/handful/proc/generate_handful(new_ammo, new_caliber, new_max_rounds, new_rounds, new_gun_type)
	var/datum/ammo/A = GLOB.ammo_list[new_ammo]
	var/ammo_name = A.name //Let's pull up the name.
	var/multiple_handful_name = A.multiple_handful_name

	name = "handful of [ammo_name + (multiple_handful_name ? " ":"s ") + "([new_caliber])"]"

	default_ammo = new_ammo
	caliber = new_caliber
	max_rounds = new_max_rounds
	current_rounds = new_rounds
	gun_type = new_gun_type
	handful_state = A.handful_state
	if(A.handful_color)
		color = A.handful_color
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
	icon_state = "casing"
	throwforce = 1
	w_class = SIZE_TINY
	layer = LOWER_ITEM_LAYER //Below other objects
	dir = NORTH //Always north when it spawns.
	flags_atom = FPRINT|CONDUCT|DIRLOCK
	matter = list("metal" = 8) //tiny amount of metal
	var/current_casings = 1 //This is manipulated in the procs that use these.
	var/max_casings = 16
	var/current_icon = 0
	var/number_of_states = 10 //How many variations of this item there are.
	garbage = TRUE

/obj/item/ammo_casing/Initialize()
	. = ..()
	pixel_x = rand(-2.0, 2) //Want to move them just a tad.
	pixel_y = rand(-2.0, 2)
	icon_state += "_[rand(1,number_of_states)]" //Set the icon to it.

//This does most of the heavy lifting. It updates the icon and name if needed, then changes .dir to simulate new casings.
/obj/item/ammo_casing/update_icon()
	if(max_casings >= current_casings)
		if(current_casings == 2) name += "s" //In case there is more than one.
		if(floor((current_casings-1)/8) > current_icon)
			current_icon++
			icon_state += "_[current_icon]"

		var/I = current_casings*8 // For the metal.
		matter = list("metal" = I)
		var/base_direction = current_casings - (current_icon * 8)
		setDir(base_direction + floor(base_direction)/3)
		switch(current_casings)
			if(3 to 5) w_class = SIZE_SMALL //Slightly heavier.
			if(9 to 10) w_class = SIZE_MEDIUM //Can't put it in your pockets and stuff.


//Making child objects so that locate() and istype() doesn't screw up.
/obj/item/ammo_casing/bullet

/obj/item/ammo_casing/cartridge
	name = "spent cartridge"
	icon_state = "cartridge"

/obj/item/ammo_casing/shell
	name = "spent shell"
	icon_state = "shell"

/obj/item/ammo_box/magazine/lever_action/xm88
	name = "\improper .458 bullets box (.458 x 300)"
	icon_state = "base_458"
	overlay_ammo_type = "_blank"
	overlay_gun_type = "_458"
	overlay_content = "_458"
	magazine_type = /obj/item/ammo_magazine/handful/lever_action/xm88

/obj/item/ammo_box/magazine/lever_action/xm88/empty
	empty = TRUE
