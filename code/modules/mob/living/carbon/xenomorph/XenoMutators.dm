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

/datum/xeno_mutator/railgun
	name = "STRAIN: Boiler - Railgun"
	description = "In exchange for your gas and neurotoxin gas, you gain a new type of glob - the railgun glob. This will do a lot of damage to barricades and humans, with no scatter and perfect accuracy!"
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Boiler") //Only boiler.
	keystone = TRUE

/datum/xeno_mutator/railgun/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if(. == 0)
		return
	
	var/datum/new_ammo = /datum/ammo/xeno/railgun_glob
	var/mob/living/carbon/Xenomorph/Boiler/B = MS.xeno
	MS.bombard_cooldown = 10
	B.bomb_delay = 125
	B.remove_action("Toggle Bombard Type")
	B.ammo = ammo_list[new_ammo]
	B.bombard_speed = 15
	B.railgun = TRUE
	B.caste.tileoffset = 9
	B.caste.viewsize = 14
	MS.recalculate_actions(description)

/datum/xeno_mutator/royal_guard
	name = "STRAIN: Praetorian - Royal Guard"
	description = "In exchange for your ability to spit, you gain better pheromones, a lower activation time on acid spray and tail sweep."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Praetorian") //Only praetorian.
	keystone = TRUE

/datum/xeno_mutator/royal_guard/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Praetorian/P = MS.xeno
	P.remove_action("Xeno Spit")
	P.remove_action("Toggle Spit Type")
	for(var/path in P.new_actions)
		var/datum/action/xeno_action/A = new path()
		A.give_action(P)
	P.acid_spray_cooldown = 6
	MS.pheromones_boost_level = 1
	MS.recalculate_actions(description)

/datum/xeno_mutator/healer
	name = "STRAIN: Drone - Healer"
	description = "In exchange for your ability to build, you gain better pheromones and the ability to transfer life to other Xenomorphs. Be wary, this is a dangerous process, overexert yourself and you might die..."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Drone") //Only drone.
	keystone = TRUE

/datum/xeno_mutator/healer/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Drone/D = MS.xeno
	D.remove_action("Secrete Resin (75)")
	D.remove_action("Choose Resin Structure")
	MS.pheromones_boost_level = 1
	for(var/path in D.new_actions)
		var/datum/action/xeno_action/A = new path()
		A.give_action(D)
	MS.recalculate_actions(description)

/datum/xeno_mutator/vomiter 
	name = "STRAIN: Spitter - Vomiter"
	description = "In exchange for your ability to spit, you gain the ability to spray a weaker variant of acid spray that does not stun, but still damages."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Spitter") 
	keystone = TRUE

/datum/xeno_mutator/vomiter/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return
	
	var/mob/living/carbon/Xenomorph/Spitter/S = MS.xeno
	S.remove_action("Toggle Spit Type")
	S.remove_action("Xeno Spit")
	for(var/path in S.new_actions)
		var/datum/action/xeno_action/A = new path()
		A.give_action(S)
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
	keystone = TRUE

/datum/xeno_mutator/egg_sacs/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Carrier/C = MS.xeno
	C.remove_action("Use/Throw Facehugger")
	for(var/path in C.new_actions)
		var/datum/action/xeno_action/A = new path()
		A.give_action(C)
	MS.recalculate_actions(description)
	C.huggers_cur = 0
	C.huggers_max = 0

/datum/xeno_mutator/tremor 
	name = "STRAIN: Burrower - Tremor"
	description = "In exchange for your ability to create traps, you gain the ability to create tremors in the ground. These tremors will knock down those next to you, while confusing everyone on your screen."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Burrower")
	keystone = TRUE

/datum/xeno_mutator/tremor/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Burrower/B = MS.xeno
	B.remove_action("Place resin hole (200)")
	for(var/path in B.new_actions)
		var/datum/action/xeno_action/A = new path()
		A.give_action(B)
	MS.recalculate_actions(description)

/datum/xeno_mutator/boxer
	name = "STRAIN: Warrior - Boxer"
	description = "In exchange for your ability to fling, you gain the ability to Jab. Your punches no longer break bones, but they do more damage and confuse your enemies. Jab knocks down your target for a very short time, while also pulling you out of agility mode and refreshing your Punch cooldown."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Warrior")
	keystone = TRUE

/datum/xeno_mutator/boxer/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Warrior/W = MS.xeno
	W.remove_action("Fling")
	W.remove_action("Lunge")
	for(var/path in W.new_actions)
		var/datum/action/xeno_action/A = new path()
		A.give_action(W)
	MS.recalculate_actions(description)
