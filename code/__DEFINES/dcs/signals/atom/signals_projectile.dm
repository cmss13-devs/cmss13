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

/// Called on point blank for ammo effects
#define COMSIG_AMMO_POINT_BLANK "ammo_point_blank"
	#define COMPONENT_CANCEL_AMMO_POINT_BLANK (1<<0)

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
#define COMSIG_BULLET_TERMINAL "bullet_terminal"

/// Called when a bullet hits a living mob on a sprite click (original target is final target)
#define COMSIG_BULLET_DIRECT_HIT "bullet_direct_hit"
