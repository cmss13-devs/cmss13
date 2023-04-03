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
/// From /obj/item/proc/unequipped()
#define COMSIG_MOB_ITEM_UNEQUIPPED "mob_item_unequipped"

/// For when a mob is devoured by a Xeno
#define COMSIG_MOB_DEVOURED "mob_devoured"
	#define COMPONENT_CANCEL_DEVOUR (1<<0)
// Reserved for tech trees
#define COMSIG_MOB_ENTER_TREE "mob_enter_tree"
	#define COMPONENT_CANCEL_TREE_ENTRY (1<<0)
/// From base of /mob/proc/set_face_dir(): (newdir)
#define COMSIG_MOB_SET_FACE_DIR "mob_set_face_dir"
	#define COMPONENT_CANCEL_SET_FACE_DIR (1<<0)

/// From /obj/effect/alien/weeds/Crossed(atom/movable/AM)
#define COMSIG_MOB_WEED_SLOWDOWN "mob_weeds_slowdown"

#define COMSIG_MOB_TAKE_DAMAGE "mob_take_damage" // TODO: move COMSIG_XENO_TAKE_DAMAGE & COMSIG_HUMAN_TAKE_DAMAGE to this
///called in /client/change_view()
#define COMSIG_MOB_CHANGE_VIEW "mob_change_view"
	#define COMPONENT_OVERRIDE_VIEW (1<<0)

#define COMSIG_MOB_POST_CLICK "mob_post_click"
///Called in /mob/reset_view(): (atom/A)
#define COMSIG_MOB_RESET_VIEW "mob_reset_view"
//Machine Guns (m56D, M2C)
#define COMSIG_MOB_MG_EXIT "mob_mg_exit"

#define COMSIG_MOB_PRE_CLICK "mob_pre_click"
	#define COMPONENT_INTERRUPT_CLICK (1<<0)

///from base of /mob/Login(): ()
#define COMSIG_MOB_LOGIN "mob_login"
///from base of /mob/Logout(): ()
#define COMSIG_MOB_LOGOUT "mob_logout"

//from /mob/proc/on_deafness_gain()
#define COMSIG_MOB_DEAFENED "mob_deafened"
//from /mob/proc/on_deafness_loss()
#define COMSIG_MOB_REGAINED_HEARING "mob_regained_hearing"

#define COMSIG_MOB_POST_UPDATE_CANMOVE "mob_can_move"

#define COMSIG_ATTEMPT_MOB_PULL "attempt_mob_pull"
	#define COMPONENT_CANCEL_MOB_PULL (1<<0)

// Return non-zero value to override original behaviour
#define COMSIG_MOB_SCREECH_ACT "mob_screech_act"
	#define COMPONENT_SCREECH_ACT_CANCEL (1<<0)

/// From /obj/item/grab/attack_self(mob/user)
#define COMSIG_MOB_GRAB_UPGRADE "grab_upgrade"

#define COMSIG_MOB_MOVE_OR_LOOK "mob_move_or_look"
	#define COMPONENT_OVERRIDE_MOB_MOVE_OR_LOOK (1<<0)

///from /mob/living/emote(): ()
#define COMSIG_MOB_EMOTE "mob_emote"

#define COMSIG_MOB_EMOTED(emote_key) "mob_emoted_[emote_key]"

//from /mob/living/set_stat()
#define COMSIG_MOB_STAT_SET_ALIVE "mob_stat_set_alive"
//from /mob/living/set_stat()
#define COMSIG_MOB_STAT_SET_DEAD "mob_stat_set_dead"
