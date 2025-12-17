// Surgery Tools
/obj/item/tool/surgery
	icon = 'icons/obj/items/surgery_tools.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_righthand.dmi',
	)
	attack_speed = 4

/*
 * Retractor
 * Usual substitutes: crowbar for heavy prying, wirecutter for fine adjustment. Fork for extremely fine work.
 */
/obj/item/tool/surgery/retractor
	name = "retractor"
	desc = "A tool for surgery used to hold skin, tissues, or organs apart to expose and access the surgical site."
	icon_state = "retractor"
	hitsound = 'sound/weapons/genhit3.ogg'
	force = 10
	throwforce = 1
	matter = list("metal" = 10000, "glass" = 5000)
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_SMALL
	attack_verb = list("attacked", "hit", "bludgeoned", "pummeled", "beat")

/obj/item/tool/surgery/retractor/predatorretractor
	name = "opener"
	icon_state = "predator_retractor"

/*
 * Hemostat
 * Usual substitutes: wirecutter for clamping bleeds or pulling things out, fork for extremely fine work, surgical line/fixovein/cable coil for tying up blood vessels.
 */
/obj/item/tool/surgery/hemostat
	name = "hemostat"
	desc = "A tool for surgery used to control bleeding by pinching blood vessels closed. It can also be used to remove foreign objects and manipulate and lift small organs and tissues."
	icon_state = "hemostat"
	hitsound = 'sound/weapons/pierce.ogg'
	matter = list("metal" = 5000, "glass" = 2500)
	force = 10
	sharp = IS_SHARP_ITEM_SIMPLE
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_SMALL
	attack_verb = list("attacked", "pinched", "pierced", "punctured")

/obj/item/tool/surgery/hemostat/predatorhemostat
	name = "pincher"
	icon_state = "predator_hemostat"

/*
 * Cautery
 * Usual substitutes: cigarettes, lighters, welding tools.
 */
/obj/item/tool/surgery/cautery
	name = "cautery"
	desc = "A tool for surgery that uses extreme heat to stop bleeding, seal blood vessels, and remove unwanted tissue. Closes incisions by burning things, in this case."
	icon_state = "cautery"
	matter = list("metal" = 5000, "glass" = 2500)
	force = 10
	throwforce = 1
	damtype = "fire"
	hitsound = 'sound/surgery/cautery2.ogg'
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_TINY
	flags_item = ANIMATED_SURGICAL_TOOL
	attack_verb = list("burned", "seared", "scorched", "singed")

/obj/item/tool/surgery/cautery/predatorcautery
	name = "cauterizer"
	icon_state = "predator_cautery"
	flags_item = NO_FLAGS

/*
 * Surgical Drill
 * Usual substitutes: pen, metal rods.
 */
/obj/item/tool/surgery/surgicaldrill
	name = "surgical drill"
	desc = "A surgical tool used to drill through bone to make a cavity for implantation purposes."
	icon_state = "drill"
	hitsound = 'sound/weapons/circsawhit.ogg'
	matter = list("metal" = 15000, "glass" = 10000)
	flags_atom = FPRINT|CONDUCT
	force = 25
	attack_speed = 9
	throwforce = 9
	sharp = IS_SHARP_ITEM_ACCURATE //it makes holes in skin and bone... Yes, sharp.
	w_class = SIZE_SMALL
	attack_verb = list("drilled", "bored", "gored", "perforated")

/obj/item/tool/surgery/surgicaldrill/predatorsurgicaldrill
	name = "bone drill"
	icon_state = "predator_drill"

/*
 * Scalpel
 * Usual substitutes: bayonets, kitchen knives, glass shards.
 */
/obj/item/tool/surgery/scalpel
	name = "scalpel"
	desc = "A surgical tool used to create incisions, debride diseased flesh, and separate muscles and organs via a cutting motion. Can also remove foreign objects. Begins most surgeries."
	icon_state = "scalpel"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_righthand.dmi',
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/medical.dmi',
	)
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
	icon_state = "predator_scalpel"

/*
 * Researchable Scalpels
 */
/obj/item/tool/surgery/scalpel/laser
	name = "prototype laser scalpel"
	desc = "A scalpel augmented with a directed laser for controlling bleeding as the incision is made and for functioning as a cautery. Sadly, this is only a prototype that looks like a superheated laser crudely slapped on a modified scalpel, so don't expect any miracles."
	desc_lore = "The prototype laser scalpel was developed during the mid-1900s, a time where scientists had yet to solve their quandary of developing a laser that could cut through flesh and and burn the blood vessels closed simultaneously; they settled on a compromise: slapping a superheated directed laser beneath the blade of the scalpel and hoping the laser burns the incision the blade makes. While the prototype ironically functioned perfectly as a cautery, it left something to be desired where bloodless incisions were a concern. Somehow, the big heads in research forgot to calibrate the width of the laser to be equivalent to the precise width of the incision made by the blade, leaving some blood vessels untouched in the process."
	icon_state = "scalpel_laser"
	damtype = "fire"
	flags_item = ANIMATED_SURGICAL_TOOL
	///The likelihood an incision made with this will be bloodless.
	var/bloodlessprob = 60
	black_market_value = 15

/obj/item/tool/surgery/scalpel/laser/improved
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser for controlling bleeding as the incision is made and for functioning as a cautery. This standard model uses a CO2 laser to vaporize tissue and seal blood vessels, but the incisions are not always bloodless."
	desc_lore = "After figuring out how to make a laser that incises flesh, the prototype and its blade became nothing more than a distant memory and a reminder to not haphazardly slap two independently-functioning tools together and praying to Spess Jesus they will in tandem with one another. This design, hailing from the early 2000s, uses a CO2 laser to create an incision by using an invisible infrared beam that vaporizes tissue while sealing blood vessels. While pinpoint bleeding occurs on occasion, the laser scalpel is a perfect, if not expensive alternative to replacing a standard scalpel and cautery."
	icon_state = "scalpel_laser_2"
	damtype = "fire"
	bloodlessprob = 80
	black_market_value = 20

/obj/item/tool/surgery/scalpel/laser/advanced
	name = "advanced laser scalpel"
	desc = "A scalpel augmented with a directed laser for controlling bleeding as the incision is made and for functioning as a cautery. This one's laser has smart detection technology to target and burn every blood vessel in its vicinity and represents the pinnacle of precision energy cutlery!"
	desc_lore = "Scientists perfected the standard model by using a much stronger type of laser that creates explosions on the microscopic scale to vaporize any tissue and blood vessels in its way as it makes an incision. With a 100% success rate in creating bloodless incision, these scalpels have no issue taking the place of scalpels and cauteries, despite their exorbitant price tags."
	icon_state = "scalpel_laser_3"
	damtype = "fire"
	bloodlessprob = 100
	black_market_value = 25

/*
 * Special Variants
 */

/obj/item/tool/surgery/scalpel/pict_system
	name = "\improper PICT system"
	desc = "The Perivascular Incision and Cauterization Tool uses a high-frequency vibrating blade and suction liquid control system to precisely target and destroy the lymphatic and vascular systems feeding tumors while suctioning fluids that may contain traveling cancerous cells. Due to its specialty in cutting certain tissues, it is much slower than a scalpel in initiating surgeries and it can't create a full-length incision bloodlessly."
	desc_lore = "The PICT system has humble origins as yet another tool developed for cancer research. Designed to identify, sever and cauterize the lymphatic and vascular systems feeding tumors, it accomplishes goals with aplomb and is the standard tool for cutting and burning off nutrient supplies to tumors before extraction. Due to its mechanisms of targeting specific types of cells while incising and suctioning, it struggles to create a full-length incision bloodlessly."
	icon_state = "pict_system"
	force = 15
	attack_speed = 6
	w_class = SIZE_SMALL
	black_market_value = 25

/obj/item/tool/surgery/scalpel/manager
	name = "incision management system"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares and widens incisions simultaneously and bloodlessly, allowing for the immediate commencement of therapeutic steps. It can only be used to begin surgeries."
	desc_lore = "Thousands of surgeons across the galaxy can only dream of holding one of these in their hands. With the technology of an advanced laser scalpel and a mechanical retractor all in one tool, a surgeon can incise, seal blood vessels, and widen incisions all in one step. Sadly, the tool is overhyped, aiding in its unconscionable price tag; it cannot function as a retractor, hemostat, cautery in any circumstances other than making an incision."
	force = 15
	attack_speed = 6
	icon_state = "scalpel_manager"
	flags_item = ANIMATED_SURGICAL_TOOL
	black_market_value = 25

/*
 * Circular Saw
 * Usual substitutes: fire axes, machetes, hatchets, butcher's knife, bayonet. Bayonet is better than axes etc. for sawing ribs/skull, worse for amputation.
 */

/obj/item/tool/surgery/circular_saw
	name = "circular saw"
	desc = "A surgical tool used to saw through thick bone in the skull and ribcage prior to prying them apart, or for amputating diseased limbs."
	icon_state = "saw"
	hitsound = 'sound/weapons/circsawhit.ogg'
	flags_atom = FPRINT|CONDUCT
	force = 25
	attack_speed = 9
	sharp = IS_SHARP_ITEM_BIG
	w_class = SIZE_SMALL
	throwforce = 9
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	matter = list("metal" = 20000,"glass" = 10000)
	flags_item = ANIMATED_SURGICAL_TOOL
	attack_verb = list("attacked", "slashed", "sawed", "cut", "maimed", "gored")
	edge = 1

/obj/item/tool/surgery/circular_saw/predatorbonesaw
	name = "bone saw"
	icon_state = "predator_bonesaw"
	flags_item = NO_FLAGS

/*
 * Bone Gel
 * Usual substitutes: screwdriver.
 */

/obj/item/tool/surgery/bonegel
	name = "bottle of bone gel"
	desc = "A container for bone gel, a substance capable of fixing fractures using an analogue that mimics bone. It needs to be refilled from a specialized machine."
	desc_lore = "Bone gel is a biological synthetic bone-analogue with the consistency of clay. It is capable of fixing hairline fractures and complex fractures alike by sealing cracks through adhesion to compact bone and solidifying; the gel then naturally erodes away as the bone remodels itself. Bone gel should not be used to fix missing bone, as it does not replace the body's bone marrow. Overuse in a short period may cause acute immunodeficiency or anemia."
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

/obj/item/tool/surgery/bonegel/update_icon(mob/user)
	. = ..()
	switch(remaining_gel)
		if(76 to INFINITY)
			icon_state = base_icon_state
		if(51 to 75)
			icon_state = "[base_icon_state]_75"
		if(26 to 50)
			icon_state = "[base_icon_state]_50"
		if(5 to 25)
			icon_state = "[base_icon_state]_25"
		if(0 to 4)
			icon_state = "[base_icon_state]_0"

	if(user)
		user.update_inv_l_hand()
		user.update_inv_r_hand()

/obj/item/tool/surgery/bonegel/get_examine_text(mob/user)
	. = ..()
	if(unlimited_gel) //Only show how much gel is left if it actually uses bone gel
		return
	. += "A volume reader on the side tells you there is still [remaining_gel]% of [src] is remaining."
	. += "[src] can be refilled from a osteomimetic lattice fabricator."

	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_DOCTOR)) //Know how much you will be using if you can use it
		return
	. += SPAN_NOTICE("You will need to use [fracture_fix_cost]% of the bone gel to repair a fracture.")
	. += SPAN_NOTICE("You will need to use [mend_bones_fix_cost]% of the bone gel to mend bones.")

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
	name = "\improper FixOVein"
	icon_state = "fixovein"
	desc = "A surgical tool used to repair broken blood vessels using a synthetic membrane. The tool can also be used to reconnect other ligaments and tissues in a pinch."
	desc_lore = "Hemophilics everywhere can thank a likewise hemophilic surgeon and their love for birds for the development of this tool. Inspired by the protective keratin sheath surrounding blood feathers as they grow and the crumbling of pin feather sheaths after the feather finishes growing, they worked with scientists to develop a tool that secretes a membrane of synthetic connective tissue to provide a framework and protective casing for the healing blood vessel until it naturally repairs itself, after which is sloughs off and dissolves. Since the membrane operates on a cellular level, it is practically infinite. With patients having been operated on experiencing a 100% recovery rate, the FixOVein has earned it a spot on every surgeon's surgical tray."
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
	name = "surgical line"
	desc = "A roll of military-grade surgical line, able to seamlessly sew up any wound. Also works as a robust fishing line for maritime deployments."
	icon_state = "line_brute"
	item_state = "line_brute"
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
	name = "synth-graft"
	desc = "An applicator for synthetic skin field grafts. The stuff reeks like processed space carp skin, itches like the dickens, stings like hell when applied, and the color is \
		a perfectly averaged multi-ethnic tone that doesn't blend with <i>anyone's</i> complexion. But at least you don't have to stay in sickbay for skin graft surgery."
	icon_state = "line_burn"
	item_state = "line_burn"
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
	desc = "Known formally as 'bone reduction forceps,' it is a surgical tool used for a procedure called 'fracture reduction,' during which it to repositions fractured bones into their proper positions so they may heal properly."
	icon_state = "bonesetter"
	hitsound = 'sound/weapons/genhit3.ogg'
	force = 15
	attack_speed = 6
	throwforce = 5
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	w_class = SIZE_SMALL
	attack_verb = list("grasped", "pinched", "pulled", "yanked")
	matter = list("plastic" = 7500)

/obj/item/tool/surgery/bonesetter/predatorbonesetter
	name = "bone placer"
	icon_state = "predator_bonesetter"

/*
WILL BE USED AT A LATER TIME

t. optimisticdude

/obj/item/tool/surgery/handheld_pump
	name = "handheld surgical pump"
	desc = "This sucks. Literally."
	icon_state = "pump"
	force = 0
	throwforce = 9
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	w_class = SIZE_SMALL
	attack_verb = list("attacked", "hit", "bludgeoned", "pummeled", "beat")
	matter = list("plastic" = 7500)
*/

/obj/item/tool/surgery/drapes //Does nothing at present. Might be useful for increasing odds of success.
	name = "surgical drapes"
	desc = "Used to cover a limb prior to the beginning of a surgical procedure."
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
		to_chat(user, SPAN_WARNING("You have no idea how to put [O] into [src]!"))
		return
	if(istype(O, /obj/item/tool/surgery/healing_gel))
		if(loaded)
			to_chat(user, SPAN_WARNING("There's already a capsule inside the healing gun!"))
			return
		user.visible_message(SPAN_NOTICE("[user] loads [src] with \a [O].") ,SPAN_NOTICE("You load [src] with \a [O]."))
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
	force = 10
	throwforce = 1
	w_class = SIZE_SMALL
	flags_item = ITEM_PREDATOR|ANIMATED_SURGICAL_TOOL
	black_market_value = 15


//XENO AUTOPSY TOOL

/obj/item/tool/surgery/WYautopsy
	name = "\improper Weyland Brand Automatic Autopsy System(TM)"
	desc = "Putting the FUN back in Autopsy. This little gadget performs an entire autopsy of whatever strange life form you've found in about 30 seconds."
	icon_state = "scalpel_laser_2"
	damtype = "fire"
	force = 10
	throwforce = 1
	flags_item = ANIMATED_SURGICAL_TOOL
	var/active = 0
	var/resetting = 0//For the reset, to prevent macro-spam abuse

/obj/item/tool/surgery/WYautopsy/verb/reset()
	set category = "IC"
	set name = "Reset WY Autopsy tool"
	set desc = "Reset the WY Tool in case it breaks."
	set src in usr

	if(!active)
		to_chat(usr, "The system appears to be working fine...")
		return
	if(active)
		resetting = 1
		to_chat(usr, "Resetting tool. This will take a few seconds...  Do not attempt to use the tool during the reset or it may malfunction.")
		while(active) //While keep running until it's reset (in case of lag-spam)
			active = 0 //Sets it to not active
			to_chat(usr, "Processing...")
			spawn(60) // runs a timer before the final check.  timer is longer than autopsy timers.
				if(!active)
					to_chat(usr, "System Reset completed!")
					resetting = 0

/obj/item/tool/surgery/WYautopsy/attack(mob/living/carbon/xenomorph/T as mob, mob/living/user as mob)
/* set category = "Autopsy"
	set name = "Perform Alien Autopsy"
	set src in usr*/
	if(resetting)
		to_chat(usr, "This tool is currently returning to its factory default settings. If you have been waiting, try running the reset again.")
	if(!isxeno(T))
		to_chat(usr, "What are you, some sort of fucking MONSTER?")
		return
	if(T.health > 0)
		to_chat(usr, "The fuck are you doing!? Kill it!")
		return
	if(active)
		to_chat(usr, "You are already performing an autopsy.")
		return
	if(istype(T, /mob/living/carbon/xenomorph/larva))
		to_chat(usr, "The larva has not developed any useful biomass for you to extract.") //It will in a future update, I guess.
		return
	active = 1
	var CHECK = user.loc
	playsound(loc, 'sound/weapons/pierce.ogg', 25)
	to_chat(usr, "You begin to cut into the alien... This might take some time...")
	if(T.health >-100)
		to_chat(usr, "HOLY SHIT! IT'S STILL ALIVE! It springs to life and uses its body weight to knock you down!")
		usr.apply_effect(20, WEAKEN)
		to_chat(T, "Though you feel a monumental amount of pain, you jump back up to use the last of your strength to kill [usr] with your final moments of life.") ///~10 seconds
		T.health = T.maxHealth*2 //It's hulk levels of angry.
		active = 0
		spawn (1000) //Around 10 seconds
			T.apply_damage(5000, BRUTE) //to make sure it's DEAD after it's hyper-boost
		return

	switch(T.butchery_progress)
		if(0)
			spawn(50)
				if(CHECK != user.loc)
					to_chat(usr, "This procedure requires uninterrupted focus; you need to remain still.")
					return
				to_chat(usr, "You've cut through the outer layers of Chitin.")
				new /obj/item/oldresearch/Chitin(T.loc) //This will be 1-3 Chitin eventually (depending on tier)
				new /obj/item/oldresearch/Chitin(T.loc) //This will be 1-3 Chitin eventually (depending on tier)
				T.butchery_progress++
				active = 0
		if(1)
			spawn(50)
				if(CHECK != user.loc)
					to_chat(usr, "This procedure requires uninterrupted focus; you need to remain still.")
					return
				to_chat(usr, "You've cut into the chest cavity and retrieved a sample of blood.")
				new /obj/item/oldresearch/Blood(T.loc)//This will be a sample of blood eventually
				T.butchery_progress++
				active = 0
		if(2)
			spawn(50)
				if(CHECK != user.loc)
					to_chat(usr, "This procedure requires uninterrupted focus; you need to remain still.")
					return
				//to_chat(usr, "You've cut out an intact organ.")
				to_chat(usr, "You've cut out some biomass...")
				new /obj/item/oldresearch/Resin(T.loc)//This will be an organ eventually, based on the caste.
				T.butchery_progress++
				active = 0
		if(3)
			spawn(50)
				if(CHECK != user.loc)
					to_chat(usr, "This procedure requires uninterrupted focus; you need to remain still.")
					return
				to_chat(usr, "You scrape out the remaining biomass.")
				active = 0
				new /obj/item/oldresearch/Resin(T.loc)
				new /obj/effect/decal/remains/xeno(T.loc)
				qdel(T)
