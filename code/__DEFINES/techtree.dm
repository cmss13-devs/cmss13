#define TREE_ACCESS_MODIFY 1
#define TREE_ACCESS_VIEW 2

// Tree Flags
#define TREE_FLAG_MARINE (1<<0)
#define TREE_FLAG_XENO  (1<<1)

// Trees
#define TREE_NONE "Undefined"
#define TREE_MARINE "Marine Tech Tree"
#define TREE_XENO "Xenomorph Tech Tree"

#define INITIAL_STARTING_POINTS 0

// Tech Flags
/// The tech can be purchased multiple times
#define TECH_FLAG_MULTIUSE		(1<<0)
/// Prevents a tech from being added to the tech trees
#define TECH_FLAG_DISABLED		(1<<1)
/// Don't announce when this tech is bought.
#define TECH_FLAG_NO_ANNOUNCE	(1<<2)

#define SITREP_INTERVAL 15 MINUTES // How frequent the ARES updates are for tech point announcements.
// Resource
#define RESOURCE_HEALTH 200

#define RESOURCE_PER_SECOND AMOUNT_PER_TIME(1, 60 SECONDS) // 1 per 60 seconds

/// Controls the passive increase amount.
#define PASSIVE_INCREASE_AMOUNT RESOURCE_PER_SECOND // Increases by RESOURCE_PER_SECOND every second.

#define RESOURCE_PLASMA_PER_REPAIR 3 // Calculated like this: RESOURCE_PLASMA_PER_REPAIR * damage_to_repair
#define RESOURCE_FUEL_TO_REPAIR 5 // Calculated like this: RESOURCE_FUEL_TO_REPAIR * (damage_to_repair / max_health)

#define GET_TREE(treeid) (SStechtree? SStechtree.trees[treeid] : null)
#define GET_NODE(treeid, nodeid) (SStechtree? SStechtree.trees[treeid].get_node(nodeid) : null)

// For tiers
#define INFINITE_TECHS -1

#define TIER_FLAG_TRANSITORY (1<<0)

#define TECH_TIER_GAMEPLAY list(\
    /datum/tier/free,\
    /datum/tier/one,\
    /datum/tier/one_transition_two,\
    /datum/tier/two,\
    /datum/tier/two_transition_three,\
    /datum/tier/three,\
    /datum/tier/three_transition_four,\
    /datum/tier/four\
)

// Droppods
#define DROPPOD_DROPPED (1<<0)
#define DROPPOD_DROPPING (1<<1)
#define DROPPOD_OPEN (1<<2)
#define DROPPOD_STRIPPED (1<<3)
#define DROPPOD_RETURNING (1<<4)
