/// when a component is added to a datum: (/datum/component)
#define COMSIG_COMPONENT_ADDED "component_added"
/// before a component is removed from a datum because of RemoveComponent: (/datum/component)
#define COMSIG_COMPONENT_REMOVING "component_removing"
/// before a datum's Destroy() is called: (force), returning a COMPONENT_ABORT_QDEL value will cancel the qdel operation
#define COMSIG_PARENT_PREQDELETED "parent_preqdeleted"
	#define COMPONENT_ABORT_QDEL (1<<0)
/// just before a datum's Destroy() is called: (force), at this point none of the other components chose to interrupt qdel and Destroy will be called
#define COMSIG_PARENT_QDELETING "parent_qdeleting"
/// generic topic handler (usr, href_list)
#define COMSIG_TOPIC "handle_topic"
/// from datum ui_act (usr, action)
#define COMSIG_UI_ACT "COMSIG_UI_ACT"
///from base of atom/attackby(): (/obj/item, /mob/living, params)
#define COMSIG_PARENT_ATTACKBY "atom_attackby"
///Return this in response if you don't want afterattack to be called
	#define COMPONENT_NO_AFTERATTACK (1<<0)
///from base of atom/examine(): (/mob, list/examine_text)
#define COMSIG_PARENT_EXAMINE "atom_examine"
/// handler for vv_do_topic (usr, href_list)
#define COMSIG_VV_TOPIC "vv_topic"
	#define COMPONENT_VV_HANDLED (1<<0)

/// fires on the target datum when an element is attached to it (/datum/element)
#define COMSIG_ELEMENT_ATTACH "element_attach"
/// fires on the target datum when an element is attached to it  (/datum/element)
#define COMSIG_ELEMENT_DETACH "element_detach"

/// From /datum/action/proc/give_to(): (mob/owner)
#define COMSIG_ACTION_GIVEN "action_given"
/// From base of /datum/action/proc/remove_from(): (mob/owner)
#define COMSIG_ACTION_REMOVED "action_removed"
/// From base of /datum/action/proc/hide_from(): (mob/owner)
#define COMSIG_ACTION_HIDDEN "action_hidden"
/// From base of /datum/action/proc/unhide_from(): (mob/owner)
#define COMSIG_ACTION_UNHIDDEN "action_unhidden"

///from /datum/component/bonus_damage_stack
#define COMSIG_BONUS_DAMAGE "bonus_damage"

/// from /datum/squad/proc/put_marine_in_squad
#define COMSIG_SET_SQUAD "set_squad"

// From /datum/surgery_step/tend_wounds/success()
// Sent to command the limb's suture datum to add sutures, NOT when sutures are added.
#define COMSIG_LIMB_ADD_SUTURES "limb_add_sutures"
// Sent to check if the limb can be sutured.
#define COMSIG_LIMB_SUTURE_CHECK "limb_suture_check"
// Sent to remove all sutures.
#define COMSIG_LIMB_REMOVE_SUTURES "limb_clear_sutures"

//from /datum/nmtask/mapload/proc/initialize_boundary_contents()
#define COMSIG_NIGHTMARE_TAINTED_BOUNDS "nightmare_tainted_bounds"
//from /datum/nmnode/
#define COMSIG_NIGHTMARE_APPLYING_NODE "nightmare_applying_node"
	#define COMPONENT_ABORT_NMNODE (1<<0)

/// From /datum/element/drop_retrieval usage: /obj/item/attachable/magnetic_harness/can_be_attached_to_gun(), /obj/item/storage/pouch/sling/can_be_inserted() (/obj/item/I)
#define COMSIG_DROP_RETRIEVAL_CHECK "drop_retrieval_check"
	#define COMPONENT_DROP_RETRIEVAL_PRESENT (1<<0)

// from /datum/emergency_call/proc/spawn_candidates()
#define COMSIG_ERT_SETUP "ert_setup"

// from /proc/update_living_queens() : /mob/living/carbon/xenomorph/queen
#define COMSIG_HIVE_NEW_QUEEN "hive_new_queen"

/// Fired on the lazy template datum when the template is finished loading. (list/loaded_atom_movables, list/loaded_turfs, list/loaded_areas)
#define COMSIG_LAZY_TEMPLATE_LOADED "lazy_template_loaded"
