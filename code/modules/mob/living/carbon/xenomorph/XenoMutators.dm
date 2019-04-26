#define MUTATOR_COST_CHEAP 2
#define MUTATOR_COST_MODERATE 3
#define MUTATOR_COST_EXPENSIVE 6

#define MUTATOR_GAIN_PER_QUEEN_LEVEL 6
#define MUTATOR_GAIN_PER_XENO_LEVEL 3
//Individual mutator
/datum/xeno_mutator
	var/name = "Mutator name" //Name of the mutator, should be short but informative
	var/description = "Mutator description" //Description to be displayed on purchase
	var/cost = MUTATOR_COST_CHEAP //How expensive the mutator is
	var/required_level = 0 //Level of xeno upgrade required to unlock
	var/unique = TRUE //True if you can only buy it once
	var/death_persistent = FALSE //True if the mutators persists after Queen death (aka, mostly for "once ever" mutators)
	var/hive_only = FALSE //Hive-only mutators
	var/individual_only = FALSE //Individual-only mutators
	var/keystone = FALSE //Xeno can only take one Keystone mutator
	var/flaw = FALSE //Flaws give you points back, but you can only take one of them
	var/list/caste_whitelist = list() //List of the only castes that can buy this mutator
	
	// Rework by Fourkhan - 4/26/19
	// HOW TO ADD A NEW MUTATOR
	// Step 0: Write an action
	//			  the "handler" procs go in /code/modules/mob/living/Xenomorph/Abilities.dm
	// 			  the actual ACTION procs go in /code/modules/mob/living/Xenomorph/Powers.dm
	// 			  Any constants you need to access for your strain should be in the CASTE definiton and
	//			  accessed using a cast to the caste datum from the base caste type
	//		      vars that absolutely must be held on the xenos themselves can be added to the Xenomorph class itself.
	// 
	// Step 1: Copy/paste another datum definiton and edit it for your strain
	// 		  	make sure to populate each of the variables listed above (at least as much as other strains)
	// Step 2: Write the apply_mutator proc.
	//			FIRST:   populate mutator_actions_to_add and mutator_actions_to_remove according to that documentation.
	//			THEN:    write the body of the apply_mutator method according to your speficiations
	// 			FINALLY: call mutator_update_actions on your xeno
	//					 call recalculate actions on your mutator set (this should be auto populated)
	//	You're done!

	// mutator_actions_to_remove should be a list of STRINGS of the NAMES of actions that need to be removed
	// when a xeno takes the mutator. 
	// mutator_actions_to_add should be a list of PATHES of actions to be ADDED when the Xeno takes the mutator.
	// Both should be set to null when their use is not necessary.
	var/list/mutator_actions_to_remove = list()  //Actions to remove when the mutator is added (name)
	var/list/mutator_actions_to_add = list()	 //Actions to add when the mutator is added (paths)

/datum/xeno_mutator/New()
	. = ..()
	name = "[name] ([cost] points)"


/datum/xeno_mutator/proc/apply_mutator(datum/mutator_set/MS)
	if(!MS.can_purchase_mutator(name))
		return 0
	if(MS.remaining_points < cost)
		return 0
	MS.remaining_points -= cost
	MS.purchased_mutators += name
	return 1

// Sets up actions for when a mutator is taken 
// Must be called at the end of any mutator that changes available actions
// (read: Strains) apply_mutator proc for the mutator to work correctly.
/datum/xeno_mutator/proc/mutator_update_actions(mob/living/carbon/Xenomorph/X)
	if (mutator_actions_to_add)
		for (var/action_datum in mutator_actions_to_add)
			var/datum/action/xeno_action/A = new action_datum()
			A.give_action(X)
	if (mutator_actions_to_remove) 
		for (var/action_name in mutator_actions_to_remove)
			X.remove_action(action_name)

/datum/xeno_mutator/railgun
	name = "STRAIN: Boiler - Railgun"
	description = "In exchange for your gas and neurotoxin gas, you gain a new type of glob - the railgun glob. This will do a lot of damage to barricades and humans, with no scatter and perfect accuracy!"
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Boiler") //Only boiler.
	mutator_actions_to_remove = list("Toggle Bombard Type")
	mutator_actions_to_add = null
	keystone = TRUE

/datum/xeno_mutator/railgun/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if(. == 0)
		return
	
	var/datum/new_ammo = /datum/ammo/xeno/railgun_glob
	var/mob/living/carbon/Xenomorph/Boiler/B = MS.xeno
	B.bombard_speed = 15 + round(MS.bombard_cooldown * 0.5)
	MS.bombard_cooldown = 0
	MS.min_bombard_dist = 0
	B.bomb_delay = 125
	B.ammo = ammo_list[new_ammo]
	B.railgun = TRUE
	B.caste.tileoffset = 9
	B.caste.viewsize = 14
	mutator_update_actions(B)
	MS.recalculate_actions(description)
	

/datum/xeno_mutator/royal_guard
	name = "STRAIN: Praetorian - Royal Guard"
	description = "In exchange for your ability to spit, you gain better pheromones, a lower activation time on acid spray and tail sweep."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Praetorian") //Only praetorian.
	mutator_actions_to_remove = list("Xeno Spit","Toggle Spit Type")
	mutator_actions_to_add = list(/datum/action/xeno_action/activable/tail_sweep)
	keystone = TRUE

/datum/xeno_mutator/royal_guard/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Praetorian/P = MS.xeno
	P.acid_spray_cooldown = 6
	MS.pheromones_boost_level = 1
	mutator_update_actions(P)
	MS.recalculate_actions(description)

/datum/xeno_mutator/healer
	name = "STRAIN: Drone - Healer"
	description = "In exchange for your ability to build, you gain better pheromones and the ability to transfer life to other Xenomorphs. Be wary, this is a dangerous process, overexert yourself and you might die..."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Drone") //Only drone.
	mutator_actions_to_remove = list("Secrete Resin (75)","Choose Resin Structure")
	mutator_actions_to_add = list(/datum/action/xeno_action/activable/transfer_health)
	keystone = TRUE

/datum/xeno_mutator/healer/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Drone/D = MS.xeno
	MS.pheromones_boost_level = 1
	mutator_update_actions(D)
	MS.recalculate_actions(description)

/datum/xeno_mutator/vomiter 
	name = "STRAIN: Spitter - Vomiter"
	description = "In exchange for your ability to spit, you gain the ability to spray a weaker variant of acid spray that does not stun, but still damages."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Spitter") 
	mutator_actions_to_remove = list("Toggle Spit Type", "Xeno Spit")
	mutator_actions_to_add = list (/datum/action/xeno_action/activable/spray_acid)
	keystone = TRUE

/datum/xeno_mutator/vomiter/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return
	
	var/mob/living/carbon/Xenomorph/Spitter/S = MS.xeno
	mutator_update_actions(S)
	MS.recalculate_actions(description)

/datum/xeno_mutator/steel_crest 
	name = "STRAIN: Defender - Steel Crest"
	description = "In exchange for your tail sweep and some of your damage, you gain the ability to move while in Fortify. Your headbutt can now be used while your crest is lowered. It also reaches further and does more damage."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Defender") 
	keystone = TRUE

/datum/xeno_mutator/steel_crest/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Defender/D = MS.xeno
	D.remove_action("Tail Sweep")
	MS.speed_multiplier *= 0.8
	MS.damage_multiplier *= 0.8
	D.spiked = TRUE
	if(D.fortify)
		D.ability_speed_modifier += 2.5
	MS.recalculate_actions(description)

/datum/xeno_mutator/egg_sacs 
	name = "STRAIN: Carrier - Egg Sacs"
	description = "In exchange for your ability to store huggers, you gain the ability to produce eggs."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Carrier") 
	mutator_actions_to_remove = list("Use/Throw Facehugger")
	mutator_actions_to_add = list(/datum/action/xeno_action/activable/lay_egg)
	keystone = TRUE

/datum/xeno_mutator/egg_sacs/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Carrier/C = MS.xeno
	C.huggers_cur = 0
	C.huggers_max = 0
	mutator_update_actions(C)
	MS.recalculate_actions(description)
	

/datum/xeno_mutator/tremor 
	name = "STRAIN: Burrower - Tremor"
	description = "In exchange for your ability to create traps, you gain the ability to create tremors in the ground. These tremors will knock down those next to you, while confusing everyone on your screen."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Burrower")
	mutator_actions_to_remove = list("Place resin hole (200)")
	mutator_actions_to_add = list(/datum/action/xeno_action/activable/tremor)
	keystone = TRUE

/datum/xeno_mutator/tremor/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Burrower/B = MS.xeno
	mutator_update_actions(B)
	MS.recalculate_actions(description)

/datum/xeno_mutator/boxer
	name = "STRAIN: Warrior - Boxer"
	description = "In exchange for your ability to fling, you gain the ability to Jab. Your punches no longer break bones, but they do more damage and confuse your enemies. Jab knocks down your target for a very short time, while also pulling you out of agility mode and refreshing your Punch cooldown."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Warrior")
	mutator_actions_to_remove = list("Fling","Lunge")
	mutator_actions_to_add = list(/datum/action/xeno_action/activable/jab)
	keystone = TRUE

/datum/xeno_mutator/boxer/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Warrior/W = MS.xeno
	mutator_update_actions(W)
	MS.recalculate_actions(description)

/datum/xeno_mutator/spin_slash
	// I like to call this one... the decappucino!
	name = "STRAIN: Ravager - Spin Slash"
	description = "In exchange for your charge, you gain the ability to perform a deadly spinning slash attack that reaches targets all around you."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Ravager")  	// Only Ravager.
	mutator_actions_to_remove = list("Charge (20)")
	mutator_actions_to_add = list(/datum/action/xeno_action/activable/spin_slash)
	keystone = TRUE

/datum/xeno_mutator/spin_slash/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return	

	var/mob/living/carbon/Xenomorph/Ravager/R = MS.xeno
	R.used_lunge = 0
	mutator_update_actions(R)
	MS.recalculate_actions(description)
