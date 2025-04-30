/*
//======
					Lever Action
//======
*/

/datum/ammo/bullet/lever_action
	name = "lever-action bullet"

	damage = 80
	penetration = 0
	accuracy = HIT_ACCURACY_TIER_1
	shell_speed = AMMO_SPEED_TIER_6
	accurate_range = 14
	effective_range_max = 7
	handful_state = "lever_action_bullet"

//unused and not working. need to refactor MD code. Unobtainable.
//intended mechanic is to have xenos hit with it show up very frequently on any MDs around
/datum/ammo/bullet/lever_action/tracker
	name = "tracking lever-action bullet"
	icon_state = "redbullet"
	damage = 70
	penetration = ARMOR_PENETRATION_TIER_3
	accuracy = HIT_ACCURACY_TIER_1
	handful_state = "tracking_lever_action_bullet"

/datum/ammo/bullet/lever_action/tracker/on_hit_mob(mob/M, obj/projectile/P, mob/user)
	//SEND_SIGNAL(user, COMSIG_BULLET_TRACKING, user, M)
	M.visible_message(SPAN_DANGER("You hear a faint beep under [M]'s [M.mob_size > MOB_SIZE_HUMAN ? "chitin" : "skin"]."))

/datum/ammo/bullet/lever_action/training
	name = "lever-action blank"
	icon_state = "blank"
	damage = 70  //blanks CAN hurt you if shot very close
	penetration = 0
	accuracy = HIT_ACCURACY_TIER_1
	effective_range_max = 0
	damage_falloff = DAMAGE_FALLOFF_BLANK //not much, though (comparatively)
	shell_speed = AMMO_SPEED_TIER_5
	handful_state = "training_lever_action_bullet"

//unused, and unobtainable... for now
/datum/ammo/bullet/lever_action/marksman
	name = "marksman lever-action bullet"
	shrapnel_chance = 0
	damage_falloff = 0
	accurate_range = 12
	damage = 70
	penetration = ARMOR_PENETRATION_TIER_6
	shell_speed = AMMO_SPEED_TIER_6
	handful_state = "marksman_lever_action_bullet"

/datum/ammo/bullet/lever_action/xm88
	name = ".458 SOCOM round"

	damage = 80
	penetration = ARMOR_PENETRATION_TIER_2
	accuracy = HIT_ACCURACY_TIER_1
	shell_speed = AMMO_SPEED_TIER_6
	accurate_range = 14
	handful_state = "boomslang_bullet"
	bullet_duramage = BULLET_DURABILITY_DAMAGE_INSUBSTANTIAL

/datum/ammo/bullet/lever_action/xm88/pen20
	penetration = ARMOR_PENETRATION_TIER_4
	bullet_duraloss = BULLET_DURABILITY_LOSS_INSUBSTANTIAL
	bullet_duramage = BULLET_DURABILITY_DAMAGE_FAIR

/datum/ammo/bullet/lever_action/xm88/pen30
	penetration = ARMOR_PENETRATION_TIER_6
	bullet_duraloss = BULLET_DURABILITY_LOSS_LOW
	bullet_duramage = BULLET_DURABILITY_DAMAGE_HIGH

/datum/ammo/bullet/lever_action/xm88/pen40
	penetration = ARMOR_PENETRATION_TIER_8
	bullet_duraloss = BULLET_DURABILITY_LOSS_MEDIUM
	bullet_duramage = BULLET_DURABILITY_DAMAGE_CRITICAL

/datum/ammo/bullet/lever_action/xm88/pen50
	penetration = ARMOR_PENETRATION_TIER_10
	bullet_duraloss = BULLET_DURABILITY_LOSS_SPECIAL // incrementing durability loss should be a good stopgap against this already powerful rifle
	bullet_duramage = BULLET_DURABILITY_DAMAGE_SPECIAL
