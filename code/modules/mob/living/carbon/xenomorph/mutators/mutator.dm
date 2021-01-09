#define MUTATOR_COST_CHEAP 2
#define MUTATOR_COST_MODERATE 3
#define MUTATOR_COST_EXPENSIVE 1

//Individual mutator
/datum/xeno_mutator
	var/name = "Mutator name" //Name of the mutator, should be short but informative
	var/description = "Mutator description" //Description to be displayed on purchase
	var/flavor_description = null // Optional flavor text to be shown. Semi-OOC
	var/cost = MUTATOR_COST_CHEAP //How expensive the mutator is
	var/required_level = 0 //Level of xeno upgrade required to unlock
	var/unique = TRUE //True if you can only buy it once
	var/death_persistent = FALSE //True if the mutators persists after Queen death (aka, mostly for "once ever" mutators)
	var/hive_only = FALSE //Hive-only mutators
	var/individual_only = FALSE //Individual-only mutators
	var/keystone = FALSE //Xeno can only take one Keystone mutator
	var/flaw = FALSE //Flaws give you points back, but you can only take one of them
	var/list/caste_whitelist = list() //List of the only castes that can buy this mutator

	// Rework by Fourkhan - 4/26/19, redone again c. 2/2020
	// HOW TO ADD A NEW MUTATOR
	// Step 0: Write an action(s)
	//			  the "handler" procs go in the appropriate caste's subfolder under the "ABILITIES" file.
	// 			  the actual ACTION procs go in the appropriate caste's subfolder under the "POWERS" file.
	// 			  Any constants you need to access for your strain should be in the behavior holder and
	//			  accessed using a cast to it using the mutator_type variable as defined below. (Or using an istype of the behavior holder)
	//		      vars that absolutely must be held on the xenos themselves can be added to the Xenomorph class itself.
	//            Be sure to follow the spec in xeno_action.dm as far as setting up xeno_cooldown is concerned.
	//
	// Step 1: Write the Behavior Delegate datum IF NECESSARY
	//            the "behavior holder" datum defines all unique behavior and state for each xeno/strain. It works by embedding a number of 'hooks'
	// 			  for example, if you want to store bonus damage and apply it on slashes, behavior delegates are the way to do it.
	//            in common procs that call back to Xeno features. See other behavior delegates for examples. Afterward, set the behavior_delegate_type
	// 			  var on the strain datum to indicate which behavior holder to apply to your strain.
	//
	// Step 1: Copy/paste another datum definiton and edit it for your strain
	// 		  	make sure to populate each of the variables listed above (at least as much as other strains)
	//
	// Step 2: Write the apply_mutator proc.
	//			FIRST:   populate mutator_actions_to_add and mutator_actions_to_remove according to that documentation.
	//			THEN:    write the body of the apply_mutator method according to your speficiations
	// 			THEN:    call mutator_update_actions on your xeno
	//					 call recalculate actions on your mutator set (this should be auto populated)
	//                   You should probably also call recalculate_everything() on the host Xeno to make sure you don't end up with any
	//  				 strange transient values.
	//          THEN:    Set the mutation_type var on the host xeno to "name" the strain.
	//          FINALLY: Call apply_behavior_holder() to add the behavior datum to the new Xeno.
	//
	//	You're done!

	// mutator_actions_to_remove should be a list of STRINGS of the NAMES of actions that need to be removed
	// when a xeno takes the mutator.
	// mutator_actions_to_add should be a list of PATHES of actions to be ADDED when the Xeno takes the mutator.
	// Both should be set to null when their use is not necessary.
	var/list/mutator_actions_to_remove = list()  //Actions to remove when the mutator is added (name)
	var/list/mutator_actions_to_add = list()	 //Actions to add when the mutator is added (paths)

	// Type of the behavior datum to add
	var/behavior_delegate_type = null // Specify this on subtypes

/datum/xeno_mutator/New()
	. = ..()
	name = "[name]"


/datum/xeno_mutator/proc/apply_mutator(datum/mutator_set/MS)
	if(!MS.can_purchase_mutator(name))
		return FALSE
	if(MS.remaining_points < cost)
		return FALSE
	MS.remaining_points -= cost
	MS.purchased_mutators += name

	if(istype(MS, /datum/mutator_set/individual_mutators))
		var/datum/mutator_set/individual_mutators/IS = MS
		if(IS.xeno)
			IS.xeno.hive.hive_ui.update_xeno_info()

	return TRUE

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

// Substitutes the existing behavior delegate for the strain-defined one.
/datum/xeno_mutator/proc/apply_behavior_holder(mob/living/carbon/Xenomorph/X)
	if (!istype(X))
		log_debug("Null mob handed to apply_behavior_holder. Tell the devs.")
		log_admin("Null mob handed to apply_behavior_holder. Tell the devs.")
		message_admins("Null mob handed to apply_behavior_holder. Tell the devs.")

	if (behavior_delegate_type)
		X.behavior_delegate = new behavior_delegate_type()
		X.behavior_delegate.bound_xeno = X
