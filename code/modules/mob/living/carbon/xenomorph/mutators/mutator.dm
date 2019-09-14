#define MUTATOR_COST_CHEAP 2
#define MUTATOR_COST_MODERATE 3
#define MUTATOR_COST_EXPENSIVE 6

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
	//  	      When you write something in Abiltities.dm make sure to have a cooldown check proc as well or else the 
	//            icon will NOT correctly update when the ability is on cooldown. 
	// 
	// Step 1: Copy/paste another datum definiton and edit it for your strain
	// 		  	make sure to populate each of the variables listed above (at least as much as other strains)
	// 
	// Step 2: Write the apply_mutator proc.
	//			FIRST:   populate mutator_actions_to_add and mutator_actions_to_remove according to that documentation.
	//			THEN:    write the body of the apply_mutator method according to your speficiations
	// 			FINALLY: call mutator_update_actions on your xeno
	//					 call recalculate actions on your mutator set (this should be auto populated)
	//                   You should probably also call recalculate_everything() on the host Xeno to make sure you don't end up with any 
	//  				 strange transient values. 
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

	if(istype(MS, /datum/mutator_set/individual_mutators))
		var/datum/mutator_set/individual_mutators/IS = MS
		if(IS.xeno)
			IS.xeno.hive.hive_ui.update_xeno_info()

	return 1

// Sets up actions for when a mutator is taken 
// Must be called at the end of any mutator that changes available actions
// (read: Strains) apply_mutator proc for the mutator to work correctly.
/datum/xeno_mutator/proc/mutator_update_actions(mob/living/carbon/Xenomorph/X)
	if (mutator_actions_to_remove) 
		for (var/action_name in mutator_actions_to_remove)
			X.remove_action(action_name)
	if (mutator_actions_to_add)
		for (var/action_datum in mutator_actions_to_add)
			var/datum/action/xeno_action/A = new action_datum()
			A.give_action(X)

// Called when the xeno upgrades
/datum/xeno_mutator/proc/on_upgrade(datum/mutator_set/MS, level)
	return