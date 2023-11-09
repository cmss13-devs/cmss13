#define COMSIG_XENO_TAKE_DAMAGE "xeno_take_damage"

/// from /mob/living/carbon/xenomorph/attack_alien()
#define COMSIG_XENO_ALIEN_ATTACK "xeno_alien_attack"

#define COMSIG_XENO_OVERWATCH_XENO "xeno_overwatch_xeno"
#define COMSIG_XENO_STOP_OVERWATCH "xeno_stop_overwatch"
#define COMSIG_XENO_STOP_OVERWATCH_XENO "xeno_stop_overwatch_xeno"

#define COMSIG_XENO_PRE_HEAL "xeno_pre_heal"
	#define COMPONENT_CANCEL_XENO_HEAL (1<<0)

/// From ../xeno_action/activable/xeno_spit/use_ability
#define COMSIG_XENO_POST_SPIT "xeno_spit"

/// From /mob/living/carbon/xenomorph/revive()
#define COMSIG_XENO_REVIVED "xeno_revived"

// From /obj/structure/safe/Topic()
#define COMSIG_SAFE_OPENED "safe_opened"

/// from /mob/living/carbon/xenomorph/bullet_act(): (list/damagedata)
#define COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE "xeno_pre_calculate_armoured_damage_projectile"

// from /mob/living/carbon/xenomorph/proc/gain_health()
#define COMSIG_XENO_ON_HEAL "xeno_on_heal"
#define COMSIG_XENO_ON_HEAL_WOUNDS "xeno_on_heal_wounds"

/// from /mob/living/carbon/xenomorph/apply_armoured_damage(): (list/damagedata)
#define COMSIG_XENO_PRE_APPLY_ARMOURED_DAMAGE "xeno_pre_apply_armoured_damage"

/// From /mob/living/carbon/xenomorph/bullet_act
#define COMSIG_XENO_BULLET_ACT "xeno_bullet_act"

/// from /mob/living/carbon/xenomorph/get_status_tab_items(): (list/statdata)
#define COMSIG_XENO_APPEND_TO_STAT "xeno_append_to_stat"

/// from /mob/living/carbon/xenomorph/movement_delay()
#define COMSIG_XENO_MOVEMENT_DELAY "xeno_movement_delay"

/// Called whenever xeno should stop momentum (when charging)
#define COMSIG_XENO_STOP_MOMENTUM "xeno_stop_momentum"
/// Called whenever xeno should resume charge
#define COMSIG_XENO_START_CHARGING "xeno_start_charging"

// Used in resin_constructions.dm
// Checks whether the xeno can build a thick structure regardless of hive weeds
#define COMSIG_XENO_THICK_RESIN_BYPASS "xeno_thick_resin_bypass"
	#define COMPONENT_THICK_BYPASS (1<<0)

/// From /datum/action/xeno_action/proc/use_ability_wrapper(): (mob/owner)
#define COMSIG_XENO_ACTION_USED "xeno_action_used"
/// From /mob/living/carbon/xenomorph/proc/check_blood_splash()
#define COMSIG_XENO_DEAL_ACID_DAMAGE "xeno_deal_acid_damage"
/// From /mob/living/carbon/xenomorph/proc/recalculate_speed()
#define COMSIG_XENO_RECALCULATE_SPEED "xeno_recalculate_speed"

/// From /mob/living/carbon/xenomorph/queen/proc/mount_ovipositor
#define COMSIG_QUEEN_MOUNT_OVIPOSITOR "queen_mount_ovipositor"
/// From /mob/living/carbon/xenomorph/queen/proc/dismount_ovipositor(): (instant_dismount)
#define COMSIG_QUEEN_DISMOUNT_OVIPOSITOR "queen_dismount_ovipositor"

/// For any additional things that should happen when a xeno's melee_attack_additional_effects_self() proc is called
#define COMSIG_XENO_SLASH_ADDITIONAL_EFFECTS_SELF "xeno_slash_additional_effects_self"
