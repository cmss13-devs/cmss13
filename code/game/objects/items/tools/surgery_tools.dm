

// Surgery Tools
/obj/item/tool/surgery
	icon = 'icons/obj/items/surgery_tools.dmi'
	/// reduced
	attack_speed = 4

/*
 * Retractor
 * Usual substitutes: crowbar for heavy prying, wirecutter for fine adjustment. Fork for extremely fine work.
 */
/obj/item/tool/surgery/retractor
	name = "retractor"
	desc = "Retracts stuff."
	icon_state = "retractor"
	matter = list("metal" = 10000, "glass" = 5000)
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_SMALL

/obj/item/tool/surgery/retractor/predatorretractor
	name = "opener"
	desc = "Retracts stuff."
	icon_state = "predator_retractor"

/*
 * Hemostat
 * Usual substitutes: wirecutter for clamping bleeds or pulling things out, fork for extremely fine work, surgical line/fixovein/cable coil for tying up blood vessels.
 */
/obj/item/tool/surgery/hemostat
	name = "hemostat"
	desc = "You think you have seen this before."
	icon_state = "hemostat"
	matter = list("metal" = 5000, "glass" = 2500)
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_SMALL

	attack_verb = list("attacked", "pinched")

/obj/item/tool/surgery/hemostat/predatorhemostat
	name = "pincher"
	desc = "You think you have seen this before."
	icon_state = "predator_hemostat"

/*
 * Cautery
 * Usual substitutes: cigarettes, lighters, welding tools.
 */
/obj/item/tool/surgery/cautery
	name = "cautery"
	desc = "This stops bleeding."
	icon_state = "cautery"
	matter = list("metal" = 5000, "glass" = 2500)
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_TINY
	flags_item = ANIMATED_SURGICAL_TOOL

	attack_verb = list("burnt")

/obj/item/tool/surgery/cautery/predatorcautery
	name = "cauterizer"
	desc = "This stops bleeding."
	icon_state = "predator_cautery"
	flags_item = NO_FLAGS

/*
 * Surgical Drill
 * Usual substitutes: pen, metal rods.
 */
/obj/item/tool/surgery/surgicaldrill
	name = "surgical drill"
	desc = "You can drill using this item. You dig?"
	icon_state = "drill"
	hitsound = 'sound/weapons/circsawhit.ogg'
	matter = list("metal" = 15000, "glass" = 10000)
	flags_atom = FPRINT|CONDUCT
	force = 0
	w_class = SIZE_SMALL

	attack_verb = list("drilled")

/obj/item/tool/surgery/surgicaldrill/predatorsurgicaldrill
	name = "bone drill"
	desc = "You can drill using this item. You dig?"
	icon_state = "predator_drill"

/*
 * Scalpel
 * Usual substitutes: bayonets, kitchen knives, glass shards.
 */
/obj/item/tool/surgery/scalpel
	name = "scalpel"
	desc = "Cut, cut, and once more cut."
	icon_state = "scalpel"
	flags_atom = FPRINT|CONDUCT
	force = 10
	sharp = IS_SHARP_ITEM_ACCURATE
	edge = 1
	demolition_mod = 0.1
	w_class = SIZE_TINY
	throwforce = 5
	flags_item = CAN_DIG_SHRAPNEL
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	matter = list("metal" = 10000, "glass" = 5000)

	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/tool/surgery/scalpel/predatorscalpel
	name = "cutter"
	desc = "Cut, cut, and once more cut."
	icon_state = "predator_scalpel"

/*
 * Researchable Scalpels
 */
/obj/item/tool/surgery/scalpel/laser
	name = "prototype laser scalpel"
	desc = "A scalpel augmented with a directed laser, for controlling bleeding as the incision is made. Also functions as a cautery. This one looks like an unreliable early model."
	icon_state = "scalpel_laser"
	damtype = "fire"
	flags_item = ANIMATED_SURGICAL_TOOL
	///The likelihood an incision made with this will be bloodless.
	var/bloodlessprob = 60
	black_market_value = 25

/obj/item/tool/surgery/scalpel/laser/improved
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for controlling bleeding as the incision is made. Also functions as a cautery. This one looks trustworthy, though it could be better."
	icon_state = "scalpel_laser_2"
	damtype = "fire"
	force = 12
	bloodlessprob = 80
	black_market_value = 35

/obj/item/tool/surgery/scalpel/laser/advanced
	name = "advanced laser scalpel"
	desc = "A scalpel augmented with a directed laser, for controlling bleeding as the incision is made. Also functions as a cautery. This one looks to be the pinnacle of precision energy cutlery!"
	icon_state = "scalpel_laser_3"
	damtype = "fire"
	force = 15
	bloodlessprob = 100

/*
 * Special Variants
 */

/obj/item/tool/surgery/scalpel/pict_system
	name = "\improper PICT system"
	desc = "The Precision Incision and Cauterization Tool uses a high-frequency vibrating blade, laser cautery, and suction liquid control system to precisely sever target tissues while preventing all fluid leakage. Despite its troubled development program and horrifying price tag, outside of complex experimental surgeries it isn't any better than an ordinary twenty-dollar scalpel and can't create a full-length incision bloodlessly."
	icon_state = "pict_system"
	w_class = SIZE_SMALL
	force = 7.5
	black_market_value = 25

/obj/item/tool/surgery/scalpel/manager
	name = "incision management system"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	icon_state = "scalpel_manager"
	force = 7.5
	flags_item = ANIMATED_SURGICAL_TOOL
	black_market_value = 25

/*
 * Circular Saw
 * Usual substitutes: fire axes, machetes, hatchets, butcher's knife, bayonet. Bayonet is better than axes etc. for sawing ribs/skull, worse for amputation.
 */

/obj/item/tool/surgery/circular_saw
	name = "circular saw"
	desc = "For heavy-duty cutting."
	icon_state = "saw"
	hitsound = 'sound/weapons/circsawhit.ogg'
	flags_atom = FPRINT|CONDUCT
	force = 0
	w_class = SIZE_SMALL
	throwforce = 9
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	matter = list("metal" = 20000,"glass" = 10000)
	flags_item = ANIMATED_SURGICAL_TOOL

	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharp = IS_SHARP_ITEM_BIG
	edge = 1

/obj/item/tool/surgery/circular_saw/predatorbonesaw
	name = "bone saw"
	desc = "For heavy-duty cutting."
	icon_state = "predator_bonesaw"
	flags_item = NO_FLAGS

/*
 * Bone Gel
 * Usual substitutes: screwdriver.
 */

/obj/item/tool/surgery/bonegel
	name = "bottle of bone gel"
	desc = "A container for bone gel that often needs to be refilled from a specialized machine."
	desc_lore = "Bone gel is a biological synthetic bone-analogue with the consistency of clay. It is capable of fixing hairline fractures and complex fractures alike. Bone gel should not be used to fix missing bone, as it does not replace the body's bone marrow. Overuse in a short period may cause acute immunodeficiency or anemia."
	icon_state = "bone-gel"
	w_class = SIZE_SMALL
	matter = list("plastic" = 7500)
	///base icon state for update_icon() to reference, fixes bonegel/empty
	var/base_icon_state = "bone-gel"
	///percent of gel remaining in container
	var/remaining_gel = 100
	///If gel is used when doing bone surgery
	var/unlimited_gel = FALSE
	///Time it takes per 10% of gel refilled
	var/time_per_refill = 1 SECONDS
	///if the bone gel is actively being refilled
	var/refilling = FALSE

	///How much bone gel is needed to fix a fracture
	var/fracture_fix_cost = 5
	///How much bone gel is needed to mend bones
	var/mend_bones_fix_cost = 5

/obj/item/tool/surgery/bonegel/update_icon()
	. = ..()
	if(remaining_gel >= 100)
		icon_state = base_icon_state
		return
	if(remaining_gel > 50)
		icon_state = "[base_icon_state]_75"
		return
	if(remaining_gel > 25)
		icon_state = "[base_icon_state]_50"
		return
	if(remaining_gel > 0)
		icon_state = "[base_icon_state]_25"
		return
	icon_state = "[base_icon_state]_0"

/obj/item/tool/surgery/bonegel/get_examine_text(mob/user)
	. = ..()
	if(unlimited_gel) //Only show how much gel is left if it actually uses bone gel
		return
	. += "A volume reader on the side tells you there is still [remaining_gel]% of [src] is remaining."
	. += "[src] can be refilled from a osteomimetic lattice fabricator."

	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_DOCTOR)) //Know how much you will be using if you can use it
		return
	. += SPAN_NOTICE("You would need to use [fracture_fix_cost]% of the bone gel to repair a fracture.")
	. += SPAN_NOTICE("You would need to use [mend_bones_fix_cost]% of the bone gel to mend bones.")

/obj/item/tool/surgery/bonegel/proc/refill_gel(obj/refilling_obj, mob/user)
	if(unlimited_gel)
		to_chat(user, SPAN_NOTICE("[refilling_obj] refuses to fill [src]."))
		return
	if(remaining_gel >= 100)
		to_chat(user, SPAN_NOTICE("[src] cannot be filled with any more bone gel."))
		return

	if(refilling)
		to_chat(user, SPAN_NOTICE("You are already refilling [src] from [refilling_obj]."))
		return
	refilling = TRUE

	while(remaining_gel < 100)
		if(!do_after(user, time_per_refill, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, refilling_obj))
			break
		remaining_gel = clamp(remaining_gel + 10, 0, 100)
		update_icon()
		to_chat(user, SPAN_NOTICE("[refilling_obj] chimes, and displays \"[remaining_gel]% filled\"."))

	refilling = FALSE
	playsound(refilling_obj, "sound/machines/ping.ogg", 10)
	to_chat(user, SPAN_NOTICE("You remove [src] from [refilling_obj]."))

/obj/item/tool/surgery/bonegel/proc/use_gel(gel_cost)
	if(unlimited_gel)
		return TRUE

	if(remaining_gel < gel_cost)
		return FALSE
	remaining_gel -= gel_cost
	update_icon()
	return TRUE

/obj/item/tool/surgery/bonegel/empty
	remaining_gel = 0
	icon_state = "bone-gel_0"

/obj/item/tool/surgery/bonegel/predatorbonegel
	name = "gel gun"
	desc = "Inside is a liquid that is similar in effect to bone gel, but requires much smaller quantities, allowing near infinite use from a single capsule."
	base_icon_state = "predator_bone-gel"
	icon_state = "predator_bone-gel"
	unlimited_gel = TRUE

/*
 * Fix-o-Vein
 * Usual substitutes: surgical line, cable coil, headbands.
 */

/obj/item/tool/surgery/FixOVein
	name = "FixOVein"
	icon_state = "fixovein"
	desc = "Used for fixing torn blood vessels. Could also be used to reconnect other tissues, in a pinch."

	force = 0
	throwforce = 1
	matter = list("plastic" = 5000)

	w_class = SIZE_SMALL
	var/usage_amount = 10

/obj/item/tool/surgery/FixOVein/predatorFixOVein
	name = "vein fixer"
	icon_state = "predator_fixovein"

/*
 * Surgical line. Used for suturing wounds, and for some surgeries.
 * Surgical substitutes: fixovein, cable coil.
 */

/obj/item/tool/surgery/surgical_line
	name = "\proper surgical line"
	desc = "A roll of military-grade surgical line, able to seamlessly sew up any wound. Also works as a robust fishing line for maritime deployments."
	icon_state = "line_brute"
	force = 0
	throwforce = 1
	w_class = SIZE_SMALL

/obj/item/tool/surgery/surgical_line/Initialize(mapload, ...)
	. = ..()
	AddElement(/datum/element/suturing, TRUE, FALSE, 2.5, "suture", "suturing", "being stabbed with needles", "wounds")

/*
 * Synth-graft.
 * No substitutes. Not, strictly speaking, a surgical tool at all, but here for consistency with surgical line.
 */

/obj/item/tool/surgery/synthgraft
	name = "Synth-Graft"
	desc = "An applicator for synthetic skin field grafts. The stuff reeks, itches like the dickens, hurts going on, and the color is \
		a perfectly averaged multiethnic tone that doesn't blend with <i>anyone's</i> complexion. But at least you don't have to stay in sickbay."
	icon_state = "line_burn"
	force = 0
	throwforce = 1
	w_class = SIZE_SMALL

/obj/item/tool/surgery/synthgraft/Initialize(mapload, ...)
	. = ..()
	AddElement(/datum/element/suturing, FALSE, TRUE, 2.5, "graft", "grafting", "being burnt away all over again", "burns")

/*
 * Bonesetter.
 * Usual substitutes: wrench.
 */

/obj/item/tool/surgery/bonesetter
	name = "bone setter"
	icon_state = "bonesetter"
	force = 0
	throwforce = 9
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	w_class = SIZE_SMALL
	attack_verb = list("attacked", "hit", "bludgeoned")
	matter = list("plastic" = 7500)

/obj/item/tool/surgery/bonesetter/predatorbonesetter
	name = "bone placer"
	icon_state = "predator_bonesetter"

/*
WILL BE USED AT A LATER TIME

t. optimisticdude

/obj/item/tool/surgery/handheld_pump
	name = "handheld surgical pump"
	desc = "This sucks. Literally"
	icon_state = "pump"
	force = 0
	throwforce = 9
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	w_class = SIZE_SMALL
	attack_verb = list("attacked", "hit", "bludgeoned")
	matter = list("plastic" = 7500)
*/

/obj/item/tool/surgery/drapes //Does nothing at present. Might be useful for increasing odds of success.
	name = "surgical drapes"
	desc = "Used to cover a limb prior to the beginning of a surgical procedure"
	icon_state = "drapes"
	gender = PLURAL
	w_class = SIZE_SMALL
	flags_item = NOBLUDGEON

/*
 * MEDICOMP TOOLS
 */

/obj/item/tool/surgery/stabilizer_gel
	name = "stabilizer gel vial"
	desc = "Used for stabilizing wounds for treatment."
	icon_state = "stabilizer_gel"
	force = 0
	throwforce = 1
	w_class = SIZE_SMALL
	flags_item = ITEM_PREDATOR
	black_market_value = 50

/obj/item/tool/surgery/healing_gun
	name = "healing gun"
	desc = "Used for mending stabilized wounds."
	icon_state = "healing_gun"
	force = 0
	throwforce = 1
	w_class = SIZE_SMALL
	flags_item = ITEM_PREDATOR|ANIMATED_SURGICAL_TOOL
	var/loaded  = TRUE
	black_market_value = 50

/obj/item/tool/surgery/healing_gun/update_icon()
	if(loaded)
		icon_state = "healing_gun"
	else
		icon_state = "healing_gun_empty"

/obj/item/tool/surgery/healing_gun/attackby(obj/item/O, mob/user)
	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		to_chat(user, SPAN_WARNING("You have no idea how to put \the [O] into \the [src]!"))
		return
	if(istype(O, /obj/item/tool/surgery/healing_gel))
		if(loaded)
			to_chat(user, SPAN_WARNING("There's already a capsule inside the healing gun!"))
			return
		user.visible_message(SPAN_NOTICE("[user] loads \the [src] with \a [O].") ,SPAN_NOTICE("You load \the [src] with \a [O]."))
		playsound(loc, 'sound/items/air_release.ogg',25)
		loaded = TRUE
		update_icon()
		qdel(O)
		return
	return ..()

/obj/item/tool/surgery/healing_gel
	name = "healing gel capsule"
	desc = "Used for reloading the healing gun."
	icon_state = "healing_gel"
	force = 0
	throwforce = 1
	w_class = SIZE_SMALL
	flags_item = ITEM_PREDATOR
	black_market_value = 15

/obj/item/tool/surgery/wound_clamp
	name = "wound clamp"
	desc = "Used for clamping wounds after treatment."
	icon_state = "wound_clamp"
	force = 0
	throwforce = 1
	w_class = SIZE_SMALL
	flags_item = ITEM_PREDATOR|ANIMATED_SURGICAL_TOOL
	black_market_value = 15


//XENO AUTOPSY TOOL

/obj/item/tool/surgery/WYautopsy
	name = "\improper Weyland Brand Automatic Autopsy System(TM)"
	desc = "Putting the FUN back in Autopsy.  This little gadget performs an entire autopsy of whatever strange life form you've found in about 30 seconds."
	icon_state = "scalpel_laser_2"
	damtype = "fire"
	force = 0
	flags_item = ANIMATED_SURGICAL_TOOL
	var/active = 0
	var/resetting = 0//For the reset, to prevent macro-spam abuse

/obj/item/tool/surgery/WYautopsy/verb/reset()
	set category = "IC"
	set name = "Reset WY Autopsy tool"
	set desc = "Reset the WY Tool in case it breaks."
	set src in usr

	if(!active)
		to_chat(usr, "System appears to be working fine...")
		return
	if(active)
		resetting = 1
		to_chat(usr, "Resetting tool, This will take a few seconds...  Do not attempt to use the tool during the reset or it may malfunction.")
		while(active) //While keep running until it's reset (in case of lag-spam)
			active = 0 //Sets it to not active
			to_chat(usr, "Processing...")
			spawn(60) // runs a timer before the final check.  timer is longer than autopsy timers.
				if(!active)
					to_chat(usr, "System Reset completed")
					resetting = 0

/obj/item/tool/surgery/WYautopsy/attack(mob/living/carbon/xenomorph/T as mob, mob/living/user as mob)
/* set category = "Autopsy"
	set name = "Perform Alien Autopsy"
	set src in usr*/
	if(resetting)
		to_chat(usr, "Tool is currently returning to factory default.  If you have been waiting, try running the reset again.")
	if(!isxeno(T))
		to_chat(usr, "What are you, some sort of fucking MONSTER?")
		return
	if(T.health > 0)
		to_chat(usr, "Nope.")
		return
	if(active)
		to_chat(usr, "Your already performing an autopsy")
		return
	if(istype(T, /mob/living/carbon/xenomorph/larva))
		to_chat(usr, "It's too young... (This will be in a future update)")
		return
	active = 1
	var CHECK = user.loc
	playsound(loc, 'sound/weapons/pierce.ogg', 25)
	to_chat(usr, "You begin to cut into the alien... This might take some time...")
	if(T.health >-100)
		to_chat(usr, "HOLY SHIT IT'S STILL ALIVE.  It knocks you down as it jumps up.")
		usr.apply_effect(20, WEAKEN)
		to_chat(T, "You feel TREMENDOUS pain and jump back up to use the last of your strength to kill [usr] with your final moments of life. (~10 seconds)")
		T.health = T.maxHealth*2 //It's hulk levels of angry.
		active = 0
		spawn (1000) //Around 10 seconds
			T.apply_damage(5000, BRUTE) //to make sure it's DEAD after it's hyper-boost
		return

	switch(T.butchery_progress)
		if(0)
			spawn(50)
				if(CHECK != user.loc)
					to_chat(usr, "This is difficult, you probably shouldn't move")
					return
				to_chat(usr, "You've cut through the outer layers of Chitin")
				new /obj/item/XenoBio/Chitin(T.loc) //This will be 1-3 Chitin eventually (depending on tier)
				new /obj/item/XenoBio/Chitin(T.loc) //This will be 1-3 Chitin eventually (depending on tier)
				T.butchery_progress++
				active = 0
		if(1)
			spawn(50)
				if(CHECK != user.loc)
					to_chat(usr, "This is difficult, you probably shouldn't move.")
					return
				to_chat(usr, "You've cut into the chest cavity and retreived a sample of blood.")
				new /obj/item/XenoBio/Blood(T.loc)//This will be a sample of blood eventually
				T.butchery_progress++
				active = 0
		if(2)
			spawn(50)
				if(CHECK != user.loc)
					to_chat(usr, "This is difficult, you probably shouldn't move.")
					return
				//to_chat(usr, "You've cut out an intact organ.")
				to_chat(usr, "You've cut out some Biomass...")
				new /obj/item/XenoBio/Resin(T.loc)//This will be an organ eventually, based on the caste.
				T.butchery_progress++
				active = 0
		if(3)
			spawn(50)
				if(CHECK != user.loc)
					to_chat(usr, "This is difficult, you probably shouldn't move.")
					return
				to_chat(usr, "You scrape out the remaining biomass.")
				active = 0
				new /obj/item/XenoBio/Resin(T.loc)
				new /obj/effect/decal/remains/xeno(T.loc)
				qdel(T)
