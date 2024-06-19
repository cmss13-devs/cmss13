#define WAITING_HEALTH_THRESHOLD 300

/datum/tutorial/xenomorph/basic
	name = "Xenomorph - Basic"
	desc = "A tutorial to get you acquainted with the very basics of how to play a xenomorph."
	icon_state = "xeno"
	tutorial_id = "xeno_basic_1"
	tutorial_template = /datum/map_template/tutorial/s12x12
	starting_xenomorph_type = /mob/living/carbon/xenomorph/drone

// START OF SCRITPING

/datum/tutorial/xenomorph/basic/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()

	xeno.plasma_stored = 0
	xeno.plasma_max = 0
	xeno.melee_damage_lower = 40
	xeno.melee_damage_upper = 40
	xeno.lock_evolve = TRUE

	message_to_player("Welcome to the Xenomorph basic tutorial. You are [xeno.name], a drone, the workhorse of the hive.")

	addtimer(CALLBACK(src, PROC_REF(on_stretch_legs)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/on_stretch_legs()
	message_to_player("As a drone you can perform most basic functions of the Xenomorph Hive. Such as weeding, building, planting eggs and nesting captured humans.")
	addtimer(CALLBACK(src, PROC_REF(on_inform_health)), 5 SECONDS)

/datum/tutorial/xenomorph/basic/proc/on_inform_health()
	message_to_player("The green icon on the <b>right</b> of your screen and green bar next to your character represents your health.")
	addtimer(CALLBACK(src, PROC_REF(on_give_plasma)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/on_give_plasma()
	message_to_player("You have been given <b>plasma</b>, a resource used for casting your abilities. This is represented by the blue icon at the <b>right</b> of your screen and the blue bar next to your character.")
	xeno.plasma_max = 200
	xeno.plasma_stored = 200
	addtimer(CALLBACK(src, PROC_REF(on_damage_xenomorph)), 15 SECONDS)

/datum/tutorial/xenomorph/basic/proc/on_damage_xenomorph()
	xeno.apply_damage(350)
	xeno.emote("hiss")
	message_to_player("Oh no! You've been damaged. Notice your green health bars have decreased. Xenomorphs can recover their health by standing or resting on weeds.")
	addtimer(CALLBACK(src, PROC_REF(request_player_plant_weed)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/request_player_plant_weed()
	update_objective("Plant a weed node using the new ability <b>Plant Weeds</b> you've just been given.")
	give_action(xeno, /datum/action/xeno_action/onclick/plant_weeds)
	message_to_player("Plant a weed node to spread weeds using your new ability at the top of the screen. Weeds heal xenomorphs and regenerate their plasma. They also slow humans, making them easier to fight.")
	RegisterSignal(xeno, COMSIG_XENO_PLANT_RESIN_NODE, PROC_REF(on_plant_resinode))

/datum/tutorial/xenomorph/basic/proc/on_plant_resinode()
	SIGNAL_HANDLER
	UnregisterSignal(xeno, COMSIG_XENO_PLANT_RESIN_NODE)
	message_to_player("Well done. You can rest on the weeds to heal faster using the <b>Rest</b> ability or with the [retrieve_bind("rest")] key.")
	message_to_player("We have increased your plasma reserves. Notice also your plasma will regenerate while you are on weeds.")
	give_action(xeno, /datum/action/xeno_action/onclick/xeno_resting)
	update_objective("Rest or wait until you are at least [WAITING_HEALTH_THRESHOLD] health.")
	xeno.plasma_max = 500
	RegisterSignal(xeno, COMSIG_XENO_ON_HEAL_WOUNDS, PROC_REF(on_xeno_gain_health))

/datum/tutorial/xenomorph/basic/proc/on_xeno_gain_health()
	SIGNAL_HANDLER
	UnregisterSignal(xeno, COMSIG_XENO_ON_HEAL_WOUNDS)
	message_to_player("Even on weeds. Healing is a slow process. This can be sped up using pheromones. Emit \"Recovery\" pheromones now using your new ability to speed up your healing.")
	give_action(xeno, /datum/action/xeno_action/onclick/emit_pheromones)
	update_objective("Emit recovery pheromones.")
	RegisterSignal(xeno, COMSIG_XENO_START_EMIT_PHEROMONES, PROC_REF(on_xeno_emit_pheromone))

/datum/tutorial/xenomorph/basic/proc/on_xeno_emit_pheromone(emitter, pheromone)
	SIGNAL_HANDLER
	if(!(pheromone == "recovery"))
		message_to_player("These are not recovery pheromones. Click your ability again to stop emitting, and choose <b>Recovery</b> instead.")
	else if(xeno.health > WAITING_HEALTH_THRESHOLD)
		reach_health_threshold()
		UnregisterSignal(xeno, COMSIG_XENO_START_EMIT_PHEROMONES)
	else
		UnregisterSignal(xeno, COMSIG_XENO_START_EMIT_PHEROMONES)
		message_to_player("Well done. Recovery Pheromones will significantly speed up your health regeneration. Rest or wait until your health is at least [WAITING_HEALTH_THRESHOLD].")
		message_to_player("Pheromones also provide their effects to other xenomorph sisters nearby!")
		RegisterSignal(xeno, COMSIG_XENO_ON_HEAL_WOUNDS, PROC_REF(reach_health_threshold))

/datum/tutorial/xenomorph/basic/proc/reach_health_threshold()
	SIGNAL_HANDLER
	if(xeno.health < WAITING_HEALTH_THRESHOLD)
		return

	UnregisterSignal(xeno, COMSIG_XENO_ON_HEAL_WOUNDS)

	message_to_player("Good. Well done.")
	message_to_player("A hostile human or \"tallhost\" has appeared. Use your <b>harm intent</b> to kill it in melee!")
	update_objective("Kill the human!")

	var/mob/living/carbon/human/human_dummy = new(loc_from_corner(7,7))
	add_to_tracking_atoms(human_dummy)
	add_highlight(human_dummy, COLOR_RED)
	RegisterSignal(human_dummy, COMSIG_MOB_DEATH, PROC_REF(on_human_death_phase_one))

/datum/tutorial/xenomorph/basic/proc/on_human_death_phase_one()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)

	UnregisterSignal(human_dummy, COMSIG_MOB_DEATH)
	message_to_player("Well done. Killing humans is one of many ways to help the hive.")
	message_to_player("Another way is to <b>capture</b> them. This will grow a new xenomorph inside them which will eventually burst into a new playable xenomorph!")
	update_objective("")
	addtimer(CALLBACK(human_dummy, TYPE_PROC_REF(/mob/living, rejuvenate)), 8 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(proceed_to_tackle_phase)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/proceed_to_tackle_phase()
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	remove_highlight(human_dummy)
	RegisterSignal(human_dummy, COMSIG_MOB_TAKE_DAMAGE, PROC_REF(on_tackle_phase_human_damage))
	RegisterSignal(human_dummy, COMSIG_MOB_TACKLED_DOWN, PROC_REF(proceed_to_cap_phase))
	message_to_player("Tackle the human to the ground using your <b>disarm intent</b>. This can take up to four tries as a drone.")
	update_objective("Tackle the human to the ground!")

/datum/tutorial/xenomorph/basic/proc/on_tackle_phase_human_damage(source, damagedata)
	SIGNAL_HANDLER
	if(damagedata["damage"] <= 0)
		return
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	// Rejuvenate the dummy if it's less than half health so our player can't kill it and softlock themselves.
	if(human_dummy.health < (human_dummy.maxHealth / 2))
		message_to_player("Don't harm the human!")
		human_dummy.rejuvenate()

/datum/tutorial/xenomorph/basic/proc/proceed_to_cap_phase()
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)

	UnregisterSignal(human_dummy, COMSIG_MOB_TACKLED_DOWN)

	ADD_TRAIT(human_dummy, TRAIT_KNOCKEDOUT, TRAIT_SOURCE_TUTORIAL)
	ADD_TRAIT(human_dummy, TRAIT_FLOORED, TRAIT_SOURCE_TUTORIAL)
	xeno.melee_damage_lower = 0
	xeno.melee_damage_upper = 0
	message_to_player("Well done. Under normal circumstances, you would have to keep tackling the human to keep them down, but for the purposes of this tutorial they will stay down forever.")
	update_objective("")
	addtimer(CALLBACK(src, PROC_REF(cap_phase)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/cap_phase()
	var/obj/effect/alien/resin/special/eggmorph/morpher = new(loc_from_corner(2,2), GLOB.hive_datum[XENO_HIVE_TUTORIAL])
	morpher.stored_huggers = 1
	add_to_tracking_atoms(morpher)
	add_highlight(morpher, COLOR_YELLOW)
	message_to_player("In the south west is an egg morpher. Click the egg morpher to take a <b>facehugger</b>.")
	update_objective("Take a facehugger from the eggmorpher.")
	RegisterSignal(xeno, COMSIG_XENO_TAKE_HUGGER_FROM_MORPHER, PROC_REF(take_facehugger_phase))

/datum/tutorial/xenomorph/basic/proc/take_facehugger_phase(source, hugger)
	SIGNAL_HANDLER
	UnregisterSignal(xeno, COMSIG_XENO_TAKE_HUGGER_FROM_MORPHER)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/effect/alien/resin/special/eggmorph, morpher)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	add_to_tracking_atoms(hugger)
	remove_highlight(morpher)

	add_highlight(hugger, COLOR_YELLOW)
	message_to_player("This is a facehugger, highlighted in yellow. Pick up the facehugger by clicking it.")
	message_to_player("Stand next to the downed human and click them to apply the facehugger. Or drop the facehugger near them to see it leap onto their face automatically.")
	update_objective("Apply the facehugger to the human.")
	RegisterSignal(hugger, COMSIG_PARENT_QDELETING, PROC_REF(on_hugger_deletion))
	RegisterSignal(human_dummy, COMSIG_HUMAN_IMPREGNATE, PROC_REF(nest_cap_phase), override = TRUE)

/datum/tutorial/xenomorph/basic/proc/on_hugger_deletion(hugger)
	SIGNAL_HANDLER
	TUTORIAL_ATOM_FROM_TRACKING(/obj/effect/alien/resin/special/eggmorph, morpher)
	morpher.stored_huggers = 1
	add_highlight(morpher, COLOR_YELLOW)
	message_to_player("Click the egg morpher to take a <b>facehugger</b>.")
	update_objective("Take a facehugger from the eggmorpher.")
	RegisterSignal(xeno, COMSIG_XENO_TAKE_HUGGER_FROM_MORPHER, PROC_REF(take_facehugger_phase))

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase()
	SIGNAL_HANDLER
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/clothing/mask/facehugger, hugger)
	UnregisterSignal(human_dummy, COMSIG_MOB_TAKE_DAMAGE)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_IMPREGNATE)
	UnregisterSignal(hugger, COMSIG_PARENT_QDELETING)
	remove_highlight(hugger)

	message_to_player("We should nest the infected human to make sure they don't get away.")
	message_to_player("Humans cannot escape nests without help, and the nest will keep them alive long enough for our new sister to burst forth.")
	update_objective("")
	addtimer(CALLBACK(src, PROC_REF(nest_cap_phase_two)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase_two()

	loc_from_corner(8,0).ChangeTurf(/turf/closed/wall/resin/tutorial)
	loc_from_corner(8,1).ChangeTurf(/turf/closed/wall/resin/tutorial)
	loc_from_corner(9,1).ChangeTurf(/turf/closed/wall/resin/tutorial)

	addtimer(CALLBACK(src, PROC_REF(nest_cap_phase_three)), 5 SECONDS)

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase_three()
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	message_to_player("Grab the human using your grab intent. Or use control + click.")
	update_objective("Grab the human using grab intent or ctrl-click.")
	RegisterSignal(human_dummy, COMSIG_MOVABLE_XENO_START_PULLING, PROC_REF(nest_cap_phase_four))

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase_four()
	SIGNAL_HANDLER
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_MOVABLE_XENO_START_PULLING)
	message_to_player("Well done. Now devour the human by clicking on your character with the grab selected in your hand. You must not move during this process.")
	update_objective("Devour the grabbed human by clicking on them with the grab in-hand.")
	RegisterSignal(human_dummy, COMSIG_MOB_DEVOURED, PROC_REF(nest_cap_phase_five))

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase_five()
	SIGNAL_HANDLER
	message_to_player("Well done, you can reguritate the human using the new ability you have gained.")
	message_to_player("Be careful. Real humans may put up a fight and can try to cut out of you from inside!")
	give_action(xeno, /datum/action/xeno_action/onclick/regurgitate)
	addtimer(CALLBACK(src, PROC_REF(nest_cap_phase_six)), 15 SECONDS)

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase_six()
	message_to_player("Humans can only be nested on <b>hive weeds</b>. These are special weeds created by structures such as the hive core, or hive clusters.")
	message_to_player("We have set up hive weeds and walls for you in the south east.")
	addtimer(CALLBACK(src, PROC_REF(nest_cap_phase_seven)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase_seven()
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_MOB_DEVOURED)
	RegisterSignal(human_dummy, COMSIG_MOB_NESTED, PROC_REF(on_mob_nested))
	message_to_player("Nest the captive human!")
	update_objective("Nest the captive human!")
	message_to_player("Drag the human next to the wall so both you and human are directly adjacent to the wall.")
	message_to_player("With the grab selected in your hand. Click on the wall. Or click and drag the mouse from the human onto the wall. You must not move during this process.")
	new /obj/effect/alien/resin/special/cluster(loc_from_corner(9,0), GLOB.hive_datum[XENO_HIVE_TUTORIAL])

/datum/tutorial/xenomorph/basic/proc/on_mob_nested()
	SIGNAL_HANDLER
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_MOB_NESTED)

	message_to_player("Well done, this concludes the basic Xenomorph tutorial.")
	message_to_player("This tutorial will end shortly.")
	tutorial_end_in(10 SECONDS)

// END OF SCRIPTING

/datum/tutorial/xenomorph/basic/init_map()
	loc_from_corner(9,0).ChangeTurf(/turf/closed/wall/resin/tutorial)

#undef WAITING_HEALTH_THRESHOLD
