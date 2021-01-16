// All signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

// global signals
// These are signals which can be listened to by any component on any parent
// start global signals with "!", this used to be necessary but now it's just a formatting choice

///from base of datum/controller/subsystem/mapping/proc/add_new_zlevel(): (list/args)
#define COMSIG_GLOB_NEW_Z "!new_z"
///from base of datum/controller/subsystem/mapping/proc/add_new_zlevel(): (list/args)
#define COMSIG_GLOB_VEHICLE_ORDERED "!vehicle_ordered"
///from /datum/game_mode/proc/pre_setup
#define COMSIG_GLOB_MODE_PRESETUP "!mode_presetup"
///from /datum/game_mode/proc/post_setup
#define COMSIG_GLOB_MODE_POSTSETUP "!mode_postsetup"
///from /mob/living/carbon/human/death
#define COMSIG_GLOB_MARINE_DEATH "!marine_death"
///from /mob/living/carbon/Xenomorph/death
#define COMSIG_GLOB_XENO_DEATH "!xeno_death"
#define COMSIG_GLOB_REMOVE_VOTE_BUTTON "!remove_vote_button"

#define COMSIG_GLOB_ENTITY_ROUND_INIT "!entity_round_init"

#define COMSIG_GLOB_CLIENT_LOGIN "!client_login"

#define COMSIG_GLOB_MOB_LOGIN "!mob_login"

//////////////////////////////////////////////////////////////////

#define COMSIG_CLIENT_LMB_DOWN "client_lmb_down"
#define COMSIG_CLIENT_LMB_UP "client_lmb_up"
#define COMSIG_CLIENT_LMB_DRAG "client_lmb_drag"

#define COMSIG_CLIENT_KEY_DOWN "client_key_down"
#define COMSIG_CLIENT_KEY_UP "client_key_up"

// /datum signals
/// when a component is added to a datum: (/datum/component)
#define COMSIG_COMPONENT_ADDED "component_added"
/// before a component is removed from a datum because of RemoveComponent: (/datum/component)
#define COMSIG_COMPONENT_REMOVING "component_removing"
/// before a datum's Destroy() is called: (force), returning a nonzero value will cancel the qdel operation
#define COMSIG_PARENT_PREQDELETED "parent_preqdeleted"
/// just before a datum's Destroy() is called: (force), at this point none of the other components chose to interrupt qdel and Destroy will be called
#define COMSIG_PARENT_QDELETING "parent_qdeleting"
/// generic topic handler (usr, href_list)
#define COMSIG_TOPIC "handle_topic"

/// fires on the target datum when an element is attached to it (/datum/element)
#define COMSIG_ELEMENT_ATTACH "element_attach"
/// fires on the target datum when an element is attached to it  (/datum/element)
#define COMSIG_ELEMENT_DETACH "element_detach"
/// From /atom/proc/Decorate
#define COMSIG_ATOM_DECORATED "atom_decorated"

///from base of atom/setDir(): (old_dir, new_dir). Called before the direction changes.
#define COMSIG_ATOM_DIR_CHANGE "atom_dir_change"

// /mob signals
/// From /obj/structure/machinery/door/airlock/proc/take_damage
#define COMSIG_MOB_DESTROY_AIRLOCK "mob_destroy_airlock"
/// From /obj/structure/machinery/door/airlock/attackby
#define COMSIG_MOB_DISASSEMBLE_AIRLOCK "mob_disassemble_airlock"
/// From /turf/closed/wall/proc/take_damage
#define COMSIG_MOB_DESTROY_WALL "mob_destroy_wall"
/// From /turf/closed/wall/ex_act
#define COMSIG_MOB_EXPLODED_WALL "mob_exploded_wall"
/// From /obj/structure/girder/proc/do_wall
#define COMSIG_MOB_CONSTRUCT_WALL "mob_construct_wall"
/// From /obj/structure/window/framed/ex_act
#define COMSIG_MOB_EXPLODE_W_FRAME "mob_destroy_w_frame"
/// From /obj/structure/window_frame/attackby
#define COMSIG_MOB_DISASSEMBLE_W_FRAME "mob_disassemble_w_frame"
/// From /obj/structure/window/proc/healthcheck
#define COMSIG_MOB_DESTROY_WINDOW "mob_destroy_window"
/// From /obj/structure/window/ex_act
#define COMSIG_MOB_WINDOW_EXPLODED "mob_window_exploded"
/// From /obj/structure/window_frame/attackby
#define COMSIG_MOB_CONSTRUCT_WINDOW "mob_construct_window"
/// From /obj/structure/window/attackby
#define COMSIG_MOB_DISASSEMBLE_WINDOW "mob_disassemble_window"
/// From /obj/structure/machinery/power/apc/attackby
#define COMSIG_MOB_APC_REMOVE_BOARD "mob_apc_remove_board"
/// From /obj/structure/machinery/power/apc/attack_hand
#define COMSIG_MOB_APC_REMOVE_CELL "mob_apc_remove_cell"
/// From /obj/structure/machinery/power/apc/proc/cut
#define COMSIG_MOB_APC_CUT_WIRE "mob_apc_cut_wire"
/// From /obj/structure/machinery/power/apc/proc/pulse
#define COMSIG_MOB_APC_POWER_PULSE "mob_apc_power_pulse"
/// From /projectiles/updated_projectiles/guns/proc/fire
#define COMSIG_MOB_FIRED_GUN "mob_fired_gun"
/// From /projectiles/updated_projectiles/guns/proc/fire_attachment
#define COMSIG_MOB_FIRED_GUN_ATTACHMENT "mob_fired_gun_attachment"
/// From /mob/proc/death
#define COMSIG_MOB_DEATH "mob_death"
/// From /mob/proc/update_canmove()
#define COMSIG_MOB_GETTING_UP "mob_getting_up"
/// For when a mob is dragged
#define COMSIG_MOB_DRAGGED "mob_dragged"
/// From /mob/living/verb/resist()
#define COMSIG_MOB_RESISTED "mob_resist"

/// from /mob/living/carbon/human/attack_alien()
#define COMSIG_HUMAN_ALIEN_ATTACK "human_alien_attack"
/// from /mob/living/carbon/Xenomorph/attack_alien()
#define COMSIG_XENO_ALIEN_ATTACK "xeno_alien_attack"

/// For when a mob is devoured by a Xeno
#define COMSIG_MOB_DEVOURED "mob_devoured"
	#define COMPONENT_CANCEL_DEVOUR	(1<<0)

// Reserved for tech trees
#define COMSIG_MOB_ENTER_TREE "mob_enter_tree"
	#define COMPONENT_CANCEL_TREE_ENTRY (1<<0)

#define COMSIG_MOB_TAKE_DAMAGE "mob_take_damage"
#define COMSIG_XENO_TAKE_DAMAGE "xeno_take_damage"
#define COMSIG_HUMAN_TAKE_DAMAGE "human_take_damage"
	#define COMPONENT_BLOCK_DAMAGE (1<<0)

#define COMSIG_MOB_RESET_VIEW "mob_reset_view"
	#define COMPONENT_OVERRIDE_VIEW	(1<<0)

// Return a nonzero value to cancel these actions
#define COMSIG_BINOCULAR_ATTACK_SELF "binocular_attack_self"
#define COMSIG_BINOCULAR_HANDLE_CLICK "binocular_handle_click"

#define COMSIG_MOB_PRE_CLICK "mob_pre_click"
	#define COMPONENT_INTERRUPT_CLICK (1<<0)

#define COMSIG_MOB_LOGIN "mob_login"

/// From /mob/living/rejuvenate
#define COMSIG_LIVING_REJUVENATED "living_rejuvenated"
/// From /mob/living/proc/IgniteMob
#define COMSIG_LIVING_PREIGNITION "living_preignition"
	#define COMPONENT_CANCEL_IGNITION (1<<0)

/// From /obj/flamer_fire/Crossed
#define COMSIG_LIVING_FLAMER_CROSSED "living_flamer_crossed"
/// From /obj/flamer_fire/Initialize
#define COMSIG_LIVING_FLAMER_FLAMED "living_flamer_flamed"
	#define COMPONENT_NO_BURN	(1<<0)
	#define COMPONENT_NO_IGNITE	(1<<1)
/// From /obj/item/proc/unzoom
#define COMSIG_LIVING_ZOOM_OUT "living_zoom_out"

/// From /obj/item/device/defibrillator/attack
#define COMSIG_HUMAN_REVIVED "human_revived"
/// From /mob/living/carbon/human/bullet_act
#define COMSIG_HUMAN_PRE_BULLET_ACT "human_pre_bullet_act"
	#define COMPONENT_BULLET_NO_HIT (1<<0)
/// From /obj/effect/decal/cleanable/blood/Crossed(): (amount, bcolor, dry_time_left)
#define COMSIG_HUMAN_BLOOD_CROSSED "human_blood_crossed"
#define COMSIG_HUMAN_CLEAR_BLOODY_FEET "human_clear_bloody_feet"

#define COMSIG_XENOMORPH_OVERWATCH_XENO "xenomorph_overwatch_xeno"
#define COMSIG_XENOMORPH_STOP_OVERWATCH	"xenomorph_stop_overwatch"
#define COMSIG_XENOMORPH_STOP_OVERWATCH_XENO "xenomorph_stop_overwatch_xeno"

#define COMSIG_QUEEN_DISMOUNT_OVIPOSITOR "queen_dismount_ovipositor"

// /obj/item signals
///from base of obj/item/dropped(): (mob/user)
#define COMSIG_ITEM_DROPPED "item_drop"
///from /obj/item/proc/unwield
#define COMSIG_ITEM_UNWIELD "item_unwield"

/// From /atom/movable/proc/launch_towards
#define COMSIG_MOVABLE_PRE_THROW "movable_pre_throw"
	#define COMPONENT_CANCEL_THROW (1<<0)
///from base of atom/movable/Moved(): (/atom, dir, forced)
#define COMSIG_MOVABLE_MOVED "movable_moved"
/// From /atom/movable/Move(): (atom/NewLoc)
#define COMSIG_MOVABLE_PRE_MOVE "movable_pre_move"
	#define COMPONENT_CANCEL_MOVE (1<<0)

///from /obj/item/device/agents/floppy_disk/proc/insert_drive
#define COMSIG_AGENT_DISK_INSERTED "agent_disk_inserted"
///from /obj/item/reagent_container/food/snacks/proc/On_Consume
#define COMSIG_SNACK_EATEN "snack_eaten"
///from /turf/closed/wall/proc/place_poster
#define COMSIG_POSTER_PLACED "poster_placed"
///from /obj/item/device/agents/tracking_device/proc/plant_tracker
#define COMSIG_TRACKING_PLANTED "tracking_planted"
///from /obj/item/device/agents/tracking_device/attackby
#define COMSIG_TRACKING_DISARMED "tracking_disarmed"

#define COMSIG_CLIENT_MOB_MOVE	"client_mob_move"
	#define COMPONENT_OVERRIDE_MOVE	(1<<0)

#define COMSIG_TURF_ENTER "turf_enter"
	#define COMPONENT_TURF_ALLOW_MOVEMENT (1<<0)
	#define COMPONENT_TURF_DENY_MOVEMENT  (1<<1)

#define COMSIG_MOB_MOVE	"mob_move"
#define COMSIG_MOB_POST_MOVE "mob_post_move"

#define COMSIG_MOB_POST_UPDATE_CANMOVE "mob_can_move"

#define COMSIG_GRENADE_PRE_PRIME "grenade_pre_prime"
	#define COMPONENT_GRENADE_PRIME_CANCEL	(1<<0)

#define COMSIG_ITEM_PICKUP "item_pickup"

#define COMSIG_MOVABLE_PRE_LAUNCH "movable_pre_launch"
	#define COMPONENT_LAUNCH_CANCEL (1<<0)

// Return non-zero value to override original behaviour
#define COMSIG_MOB_SCREECH_ACT "mob_screech_act"
	#define COMPONENT_SCREECH_ACT_CANCEL (1<<0)

// Bullet trait signals
/// Called when a bullet hits a living mob
#define COMSIG_BULLET_ACT_LIVING "bullet_act_living"
/// Called when a bullet hits a human
#define COMSIG_BULLET_ACT_HUMAN "bullet_act_human"
/// Called when a bullet hits a xenomorph
#define COMSIG_BULLET_ACT_XENO "bullet_act_xeno"
/// Apply any effects to the bullet (primarily through bullet traits)
/// based on the user
#define COMSIG_BULLET_USER_EFFECTS "bullet_user_effects"
/// Called when checking IFF as bullet scans for targets
#define COMSIG_BULLET_CHECK_IFF "bullet_check_iff"
