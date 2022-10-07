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
/// from /datum/controller/subsystem/ticker/fire
#define COMSIG_GLOB_MODE_PREGAME_LOBBY "!mode_pregame_lobby"
///from /datum/game_mode/proc/pre_setup
#define COMSIG_GLOB_MODE_PRESETUP "!mode_presetup"
///from /datum/game_mode/proc/post_setup
#define COMSIG_GLOB_MODE_POSTSETUP "!mode_postsetup"
///from /datum/game_mode/proc/ds_first_landed
#define COMSIG_GLOB_DS_FIRST_LANDED "!ds_first_landed"
///from /mob/living/carbon/human/death
#define COMSIG_GLOB_MARINE_DEATH "!marine_death"
///from /mob/living/carbon/Xenomorph/death
#define COMSIG_GLOB_XENO_DEATH "!xeno_death"

///from /mob/living/carbon/Xenomorph/Initialize
#define COMSIG_GLOB_XENO_SPAWN "!xeno_spawn"

#define COMSIG_GLOB_REMOVE_VOTE_BUTTON "!remove_vote_button"

#define COMSIG_GLOB_CLIENT_LOGIN "!client_login"

#define COMSIG_GLOB_MOB_LOGIN "!mob_login"

///from /datum/nmcontext/proc/run_steps
#define COMSIG_GLOB_NIGHTMARE_SETUP_DONE "!nightmare_setup_done"

///from /datum/controller/subsystem/ticker/PostSetup
#define COMSIG_GLOB_POST_SETUP "!post_setup"

///from /proc/set_security_level
#define COMSIG_GLOB_SECURITY_LEVEL_CHANGED "!security_level_changed"

//////////////////////////////////////////////////////////////////

#define COMSIG_CLIENT_LMB_DOWN "client_lmb_down"
#define COMSIG_CLIENT_LMB_UP "client_lmb_up"
#define COMSIG_CLIENT_LMB_DRAG "client_lmb_drag"

#define COMSIG_CLIENT_KEY_DOWN "client_key_down"
#define COMSIG_CLIENT_KEY_UP "client_key_up"

///from /datum/controller/subsystem/radio/get_available_tcomm_zs(): (list/tcomms)
#define COMSIG_SSRADIO_GET_AVAILABLE_TCOMMS_ZS "ssradio_get_available_tcomms_zs"

///from /mob/do_click(): (atom/A, list/mods)
#define COMSIG_CLIENT_PRE_CLICK "client_pre_click"

// /datum signals
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

/// fires on the target datum when an element is attached to it (/datum/element)
#define COMSIG_ELEMENT_ATTACH "element_attach"
/// fires on the target datum when an element is attached to it  (/datum/element)
#define COMSIG_ELEMENT_DETACH "element_detach"
/// From /atom/proc/Decorate
#define COMSIG_ATOM_DECORATED "atom_decorated"

///from base of atom/setDir(): (old_dir, new_dir). Called before the direction changes.
#define COMSIG_ATOM_DIR_CHANGE "atom_dir_change"

/// generally called before temporary non-parallel animate()s on the atom (animation_duration)
#define COMSIG_ATOM_TEMPORARY_ANIMATION_START "atom_temp_animate_start"

//from base of atom/movable/onTransitZ(): (old_z, new_z)
#define COMSIG_MOVABLE_Z_CHANGED "movable_ztransit"

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
/// From /mob/proc/update_canmove()
#define COMSIG_MOB_KNOCKED_DOWN "mob_knocked_down"
/// For when a mob is dragged
#define COMSIG_MOB_DRAGGED "mob_dragged"
/// From /mob/living/verb/resist()
#define COMSIG_MOB_RESISTED "mob_resist"
/// From /mob/living/verb/resist()
#define COMSIG_MOB_RECALCULATE_CLIENT_COLOR "mob_recalc_client_color"

/// From /obj/item/proc/unequipped()
#define COMSIG_MOB_ITEM_UNEQUIPPED "mob_item_unequipped"

/// For when a mob is devoured by a Xeno
#define COMSIG_MOB_DEVOURED "mob_devoured"
	#define COMPONENT_CANCEL_DEVOUR	(1<<0)
// Reserved for tech trees
#define COMSIG_MOB_ENTER_TREE "mob_enter_tree"
	#define COMPONENT_CANCEL_TREE_ENTRY (1<<0)
/// From base of /mob/proc/set_face_dir(): (newdir)
#define COMSIG_MOB_SET_FACE_DIR "mob_set_face_dir"
	#define COMPONENT_CANCEL_SET_FACE_DIR (1<<0)

#define COMSIG_MOB_TAKE_DAMAGE "mob_take_damage"
#define COMSIG_XENO_TAKE_DAMAGE "xeno_take_damage"
#define COMSIG_HUMAN_TAKE_DAMAGE "human_take_damage"
	#define COMPONENT_BLOCK_DAMAGE (1<<0)

#define COMSIG_ITEM_ATTACK "item_attack" //Triggered on the item.
#define COMSIG_ITEM_ATTEMPT_ATTACK "item_attempt_attack" //Triggered on the target mob.
	#define COMPONENT_CANCEL_ATTACK (1<<0)

///Called in /mob/reset_view(): (atom/A)
#define COMSIG_MOB_RESET_VIEW "mob_reset_view"
#define COMSIG_CLIENT_RESET_VIEW "client_reset_view"
///called in /client/change_view()
#define COMSIG_MOB_CHANGE_VIEW "mob_change_view"
	#define COMPONENT_OVERRIDE_VIEW	(1<<0)

#define COMSIG_MOB_POST_CLICK "mob_post_click"

// Return a nonzero value to cancel these actions
#define COMSIG_BINOCULAR_ATTACK_SELF "binocular_attack_self"
#define COMSIG_BINOCULAR_HANDLE_CLICK "binocular_handle_click"

#define COMSIG_MOB_PRE_CLICK "mob_pre_click"
	#define COMPONENT_INTERRUPT_CLICK (1<<0)

#define COMSIG_DBLCLICK_SHIFT_MIDDLE "dblclick_shift_middle"
#define COMSIG_DBLCLICK_CTRL_SHIFT "dblclick_ctrl_shift"
#define COMSIG_DBLCLICK_CTRL_MIDDLE "dblclick_ctrl_middle"
#define COMSIG_DBLCLICK_MIDDLE "dblclick_middle"
#define COMSIG_DBLCLICK_SHIFT "dblclick_shift"
#define COMSIG_DBLCLICK_ALT "dblclick_alt"
#define COMSIG_DBLCLICK_CTRL "dblclick_ctrl"

#define COMSIG_MOB_LOGIN "mob_login"

/// From /mob/living/rejuvenate
#define COMSIG_LIVING_REJUVENATED "living_rejuvenated"
/// From /mob/living/proc/IgniteMob
#define COMSIG_LIVING_PREIGNITION "living_preignition"
	#define COMPONENT_CANCEL_IGNITION (1<<0)
#define COMSIG_LIVING_IGNITION "living_ignition"

/// From /mob/living/carbon/human/ExtinguishMob()
#define COMSIG_HUMAN_EXTINGUISH "human_extinguish"

/// From /obj/flamer_fire/Crossed
#define COMSIG_LIVING_FLAMER_CROSSED "living_flamer_crossed"
/// From /obj/flamer_fire/Initialize
#define COMSIG_LIVING_FLAMER_FLAMED "living_flamer_flamed"
	#define COMPONENT_NO_BURN		(1<<0)
	#define COMPONENT_NO_IGNITE		(1<<1)
	#define COMPONENT_XENO_FRENZY	(1<<2)
/// From /obj/item/proc/unzoom
#define COMSIG_LIVING_ZOOM_OUT "living_zoom_out"

#define COMSIG_LIVING_SPEAK "living_speak"
	#define COMPONENT_OVERRIDE_SPEAK (1<<0)

/// From /obj/item/device/defibrillator/attack
#define COMSIG_HUMAN_REVIVED "human_revived"
/// From /mob/living/carbon/human/bullet_act
#define COMSIG_HUMAN_PRE_BULLET_ACT "human_pre_bullet_act"
/// From /mob/living/carbon/human/bullet_act(): (damage_result, ammo_flags, obj/item/projectile/P)
#define COMSIG_HUMAN_BULLET_ACT "human_bullet_act"
	#define COMPONENT_CANCEL_BULLET_ACT (1<<0)
///called when an atom starts orbiting another atom: (atom)
#define COMSIG_ATOM_ORBIT_BEGIN "atom_orbit_begin"
///called when an atom stops orbiting another atom: (atom)
#define COMSIG_ATOM_ORBIT_STOP "atom_orbit_stop"
/// From /obj/effect/decal/cleanable/blood/Crossed(): (amount, bcolor, dry_time_left)
#define COMSIG_HUMAN_BLOOD_CROSSED "human_blood_crossed"
#define COMSIG_HUMAN_CLEAR_BLOODY_FEET "human_clear_bloody_feet"
/// from /mob/living/carbon/human/attack_alien()
#define COMSIG_HUMAN_ALIEN_ATTACK "human_alien_attack"
/// From /obj/item/clothing/mask/facehugger/proc/impregnate(): (obj/item/clothing/mask/facehugger/hugger)
#define COMSIG_HUMAN_IMPREGNATE "human_impregnate"
	#define COMPONENT_NO_IMPREGNATE (1<<0)
/// From /mob/living/carbon/human/apply_overlay(): (cache_index, overlay_image)
#define COMSIG_HUMAN_OVERLAY_APPLIED "human_overlay_applied"
/// From /mob/living/carbon/human/remove_overlay(): (cache_index, overlay_image)
#define COMSIG_HUMAN_OVERLAY_REMOVED "human_overlay_removed"

#define COMSIG_HUMAN_BONEBREAK_PROBABILITY "human_bonebreak_probability"

/// from /mob/living/carbon/Xenomorph/attack_alien()
#define COMSIG_XENO_ALIEN_ATTACK "xeno_alien_attack"
#define COMSIG_XENO_OVERWATCH_XENO "xeno_overwatch_xeno"
#define COMSIG_XENO_STOP_OVERWATCH	"xeno_stop_overwatch"
#define COMSIG_XENO_STOP_OVERWATCH_XENO "xeno_stop_overwatch_xeno"
#define COMSIG_XENO_PRE_HEAL "xeno_pre_heal"
#define COMPONENT_CANCEL_XENO_HEAL (1<<0)

/// From /mob/living/carbon/Xenomorph/revive()
#define COMSIG_XENO_REVIVED "xeno_revived"

// From /obj/structure/safe/Topic()
#define COMSIG_SAFE_OPENED "safe_opened"

/// from /mob/living/carbon/Xenomorph/bullet_act(): (list/damagedata)
#define COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE "xeno_pre_calculate_armoured_damage_projectile"

// from /mob/living/carbon/Xenomorph/proc/gain_health()
#define COMSIG_XENO_ON_HEAL "xeno_on_heal"
#define COMSIG_XENO_ON_HEAL_WOUNDS "xeno_on_heal_wounds"

/// from /mob/living/carbon/Xenomorph/apply_armoured_damage(): (list/damagedata)
#define COMSIG_XENO_PRE_APPLY_ARMOURED_DAMAGE "xeno_pre_apply_armoured_damage"

/// From /mob/living/carbon/Xenomorph/bullet_act
#define COMSIG_XENO_BULLET_ACT "xeno_bullet_act"
	//#define COMPONENT_CANCEL_BULLET_ACT (1<<0) already defined

/// from /mob/living/carbon/Xenomorph/get_status_tab_items(): (list/statdata)
#define COMSIG_XENO_APPEND_TO_STAT "xeno_append_to_stat"

/// from /mob/living/carbon/Xenomorph/movement_delay()
#define COMSIG_XENO_MOVEMENT_DELAY "xeno_movement_delay"

/// From /mob/living/carbon/Xenomorph/Queen/proc/mount_ovipositor
#define COMSIG_QUEEN_MOUNT_OVIPOSITOR "queen_mount_ovipositor"
/// From /mob/living/carbon/Xenomorph/Queen/proc/dismount_ovipositor(): (instant_dismount)
#define COMSIG_QUEEN_DISMOUNT_OVIPOSITOR "queen_dismount_ovipositor"

/// From /turf/closed/wall/resin/attack_alien(): (mob/living/carbon/Xenomorph/X)
#define COMSIG_WALL_RESIN_XENO_ATTACK "wall_resin_attack_alien"

#define COMSIG_HUMAN_XENO_ATTACK "human_attack_alien"
	#define COMPONENT_CANCEL_XENO_ATTACK (1<<0)

/// From /turf/closed/wall/resin/attackby(): (obj/item/I, mob/M)
#define COMSIG_WALL_RESIN_ATTACKBY "wall_resin_attackby"
	#define COMPONENT_CANCEL_ATTACKBY (1<<0)

#define COMSIG_HUMAN_UPDATE_SIGHT "human_update_sight"
	#define COMPONENT_OVERRIDE_UPDATE_SIGHT (1<<0)

///from /mob/living/carbon/human/update_sight()
#define COMSIG_HUMAN_POST_UPDATE_SIGHT "human_post_update_sight"
///from /mob/living/carbon/human/movement_delay(): (list/movedata)
#define COMSIG_HUMAN_POST_MOVE_DELAY "human_post_move_delay"

// /obj/item signals
///from base of obj/item/dropped(): (mob/user)
#define COMSIG_ITEM_DROPPED "item_drop"
/// From base of /obj/item/proc/equipped(): (mob/user, slot)
#define COMSIG_ITEM_EQUIPPED "item_equipped"
/// From base of /obj/item/proc/unequipped(): (mob/user, slot)
#define COMSIG_ITEM_UNEQUIPPED "item_unequipped"
///from /obj/item/proc/unwield
#define COMSIG_ITEM_UNWIELD "item_unwield"
/// From base of /obj/item/proc/attack_self(): (mob/user)
#define COMSIG_ITEM_ATTACK_SELF "item_attack_self"

/// From /datum/element/drop_retrieval usage: /obj/item/attachable/magnetic_harness/can_be_attached_to_gun(), /obj/item/storage/pouch/sling/can_be_inserted() (/obj/item/I)
#define COMSIG_DROP_RETRIEVAL_CHECK "drop_retrieval_check"
	#define COMPONENT_DROP_RETRIEVAL_PRESENT (1<<0)

/// From /atom/movable/proc/launch_towards
#define COMSIG_MOVABLE_PRE_THROW "movable_pre_throw"
	#define COMPONENT_CANCEL_THROW (1<<0)
///from base of atom/movable/Moved(): (/atom, dir, forced)
#define COMSIG_MOVABLE_MOVED "movable_moved"
/// From /atom/movable/Move(): (atom/NewLoc)
#define COMSIG_MOVABLE_PRE_MOVE "movable_pre_move"
	#define COMPONENT_CANCEL_MOVE (1<<0)
/// From /turf/open/gm/river/Entered(): (turf/open/gm/river/river, covered)
#define COMSIG_MOVABLE_ENTERED_RIVER "movable_entered_river"

///from /obj/item/reagent_container/food/snacks/proc/On_Consume
#define COMSIG_SNACK_EATEN "snack_eaten"
///from /turf/closed/wall/proc/place_poster
#define COMSIG_POSTER_PLACED "poster_placed"

#define COMSIG_CLIENT_MOB_MOVE	"client_mob_move"
	#define COMPONENT_OVERRIDE_MOVE	(1<<0)

#define COMSIG_MOB_MOVE_OR_LOOK "mob_move_or_look"
	#define COMPONENT_OVERRIDE_MOB_MOVE_OR_LOOK (1<<0)

#define COMSIG_MOVABLE_TURF_ENTER "movable_turf_enter"
#define COMSIG_TURF_ENTER "turf_enter"
	#define COMPONENT_TURF_ALLOW_MOVEMENT (1<<0)
	#define COMPONENT_TURF_DENY_MOVEMENT  (1<<1)

/// Called when a bullet hits a turf
#define COMSIG_TURF_BULLET_ACT "turf_bullet_act"
	#define COMPONENT_BULLET_ACT_OVERRIDE (1<<0)

///from /turf/Entered
#define COMSIG_MOVABLE_TURF_ENTERED "movable_turf_entered"

///from /turf/ChangeTurf
#define COMSIG_ATOM_TURF_CHANGE "movable_turf_change"

///from /atom/hitby(): (atom/movable/AM)
#define COMSIG_ATOM_HITBY "atom_hitby"

#define COMSIG_MOB_POST_UPDATE_CANMOVE "mob_can_move"

#define COMSIG_GRENADE_PRE_PRIME "grenade_pre_prime"
	#define COMPONENT_GRENADE_PRIME_CANCEL	(1<<0)

#define COMSIG_OBJ_FLASHBANGED "flashbanged"

#define COMSIG_ITEM_PICKUP "item_pickup"

#define COMSIG_ATTEMPT_MOB_PULL "attempt_mob_pull"
	#define COMPONENT_CANCEL_MOB_PULL (1<<0)

///from /mob/living/carbon/Xenomorph/start_pulling(): (mob/living/carbon/Xenomorph/X)
#define COMSIG_MOVABLE_XENO_START_PULLING "movable_xeno_start_pulling"
	#define COMPONENT_ALLOW_PULL (1<<0)

#define COMSIG_MOVABLE_PULLED "movable_pulled"
	#define COMPONENT_IGNORE_ANCHORED (1<<0)

#define COMSIG_MOVABLE_PRE_LAUNCH "movable_pre_launch"
	#define COMPONENT_LAUNCH_CANCEL (1<<0)

// Return non-zero value to override original behaviour
#define COMSIG_MOB_SCREECH_ACT "mob_screech_act"
	#define COMPONENT_SCREECH_ACT_CANCEL (1<<0)

/// Called when a bullet hits a living mob on a sprite click (original target is final target)
#define COMSIG_DIRECT_BULLET_HIT "direct_bullet_hit"
// Bullet trait signals
/// Called when a bullet hits a living mob
#define COMSIG_BULLET_ACT_LIVING "bullet_act_living"
/// Called when a bullet hits a human
#define COMSIG_POST_BULLET_ACT_HUMAN "bullet_act_human"
/// Called when a bullet hits a xenomorph
#define COMSIG_BULLET_ACT_XENO "bullet_act_xeno"
/// Apply any effects to the bullet (primarily through bullet traits)
/// based on the user
#define COMSIG_BULLET_USER_EFFECTS "bullet_user_effects"
/// Called when checking whether bullet should skip mob for whatever reasons (like IFF)
#define COMSIG_BULLET_CHECK_MOB_SKIPPING "bullet_check_mob_skipping"
	#define COMPONENT_SKIP_MOB (1<<0)

/// From /obj/item/projectile/handle_mob(): (mob/living/target)
#define COMSIG_BULLET_PRE_HANDLE_MOB "bullet_pre_handle_mob"
/// From /obj/item/projectile/handle_mob(): (mob/living/target)
#define COMSIG_BULLET_POST_HANDLE_MOB "bullet_post_handle_mob"
/// From /obj/item/projectile/handle_obj(): (obj/target, did_hit)
#define COMSIG_BULLET_POST_HANDLE_OBJ "bullet_post_handle_obj"
/// From /obj/item/projectile/handle_obj(): (obj/target)
#define COMSIG_BULLET_PRE_HANDLE_OBJ "bullet_pre_handle_obj"
/// From /obj/item/projectile/scan_a_turf(): (turf/target)
#define COMSIG_BULLET_POST_HANDLE_TURF "bullet_post_handle_turf"
/// From /obj/item/projectile/scan_a_turf(): (turf/target)
#define COMSIG_BULLET_PRE_HANDLE_TURF "bullet_pre_handle_turf"
	#define COMPONENT_BULLET_PASS_THROUGH (1<<0)

/// For any additional things that should happen when a xeno's melee_attack_additional_effects_self() proc is called
#define COMSIG_XENO_SLASH_ADDITIONAL_EFFECTS_SELF "xeno_slash_additional_effects_self"

/// From /datum/action/proc/give_to(): (mob/owner)
#define COMSIG_ACTION_GIVEN "action_given"
/// From base of /datum/action/proc/remove_from(): (mob/owner)
#define COMSIG_ACTION_REMOVED "action_removed"
/// From base of /datum/action/proc/hide_from(): (mob/owner)
#define COMSIG_ACTION_HIDDEN "action_hidden"
/// From base of /datum/action/proc/unhide_from(): (mob/owner)
#define COMSIG_ACTION_UNHIDDEN "action_unhidden"


/// From /obj/structure/proc/do_climb(var/mob/living/user, mods)
#define COMSIG_LIVING_CLIMB_STRUCTURE "climb_over_structure"
/// From /mob/living/Collide(): (atom/A)
#define COMSIG_LIVING_PRE_COLLIDE "living_pre_collide"
	#define COMPONENT_LIVING_COLLIDE_HANDLED (1<<0)

/// From /mob/living/carbon/human/MouseDrop_T(atom/dropping, mob/user)
//this is a jank way to use signals, but you would need to rework the entire proc otherwise
#define COMSIG_HUMAN_CARRY "fireman_carry"
	#define COMPONENT_CARRY_ALLOW (1<<0)
/// From /obj/item/grab/attack_self(mob/user)
#define COMSIG_MOB_GRAB_UPGRADE "grab_upgrade"

/// From /datum/action/xeno_action/proc/use_ability_wrapper(): (mob/owner)
#define COMSIG_XENO_ACTION_USED "xeno_action_used"
/// From /mob/living/carbon/Xenomorph/proc/check_blood_splash()
#define COMSIG_XENO_DEAL_ACID_DAMAGE "xeno_deal_acid_damage"
/// From /mob/living/carbon/Xenomorph/proc/recalculate_speed()
#define COMSIG_XENO_RECALCULATE_SPEED "xeno_recalculate_speed"

// shuttle
/// shuttle mode change
#define COMSIG_SHUTTLE_SETMODE "shuttle_setmode"
/// shuttle crushing something
#define COMSIG_MOVABLE_SHUTTLE_CRUSH "movable_shuttle_crush"

///from base of /atom/movable/proc/set_glide_size(): (target)
#define COMSIG_MOVABLE_UPDATE_GLIDE_SIZE "movable_glide_size"

/// from /obj/structure/transmitter/update_icon()
#define COMSIG_TRANSMITTER_UPDATE_ICON "transmitter_update_icon"

/// From /obj/effect/alien/weeds/Initialize()
#define COMSIG_WEEDNODE_GROWTH_COMPLETE "weednode_growth_complete"
/// From /obj/effect/alien/weeds/proc/on_weed_expand()
#define COMSIG_WEEDNODE_CANNOT_EXPAND_FURTHER "weednode_cannot_expand_further"

//from /mob/proc/on_deafness_gain()
#define COMSIG_MOB_DEAFENED "mob_deafened"
//from /mob/proc/on_deafness_loss()
#define COMSIG_MOB_REGAINED_HEARING "mob_regained_hearing"
//from /mob/living/carbon/human/equip_to_slot()
#define COMSIG_HUMAN_EQUIPPED_ITEM "human_equipped_item"

///from /datum/component/bonus_damage_stack
#define COMSIG_BONUS_DAMAGE "bonus_damage"

/// Called whenever xeno should stop momentum (when charging)
#define COMSIG_XENO_STOP_MOMENTUM "xeno_stop_momentum"
/// Called whenever xeno should resume charge
#define COMSIG_XENO_START_CHARGING "xeno_start_charging"
/// from /datum/squad/proc/put_marine_in_squad
#define COMSIG_SET_SQUAD "set_squad"

// From obj/limb/proc/take_damage()
// Sent after the limb has taken damage
#define COMSIG_LIMB_TAKEN_DAMAGE "limb_taken_damage"

// From /datum/surgery_step/tend_wounds/success()
// Sent to command the limb's suture datum to add sutures, NOT when sutures are added.
#define COMSIG_LIMB_ADD_SUTURES "limb_add_sutures"
// Sent to check if the limb can be sutured.
#define COMSIG_LIMB_SUTURE_CHECK "limb_suture_check"
// Sent to remove all sutures.
#define COMSIG_LIMB_REMOVE_SUTURES "limb_clear_sutures"


// Used in resin_constructions.dm
// Checks whether the xeno can build a thick structure regardless of hive weeds
#define COMSIG_XENO_THICK_RESIN_BYPASS "xeno_thick_resin_bypass"
	#define COMPONENT_THICK_BYPASS (1<<0)
