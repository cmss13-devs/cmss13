// IAP-V2 Phalanx Collapsible Shield

// Basestat Defines
//-------------------------------------------------------

/// Regular block chance in percentage when the shield is collapsed (lowered)
#define PHALANX_SHIELD_CHANCE_COLLAPSED 25
/// Regular block chance in percentage when the shield is extended (raised)
#define PHALANX_SHIELD_CHANCE_EXTENDED 75
// Brace For Impact shield chance is found in the ability section

/// Multiplier on block chance for projectiles when the shield is collapsed (ie, multiplier * PHALANX_SHIELD_CHANCE_COLLAPSED)
#define PHALANX_PROJECTILE_BLOCK_CHANCE_COLLAPSED 1
/// Multiplier on block chance for projectiles when the shield is extended (ie, multiplier * PHALANX_SHIELD_CHANCE_EXTENDED/BRACED)
#define PHALANX_PROJECTILE_BLOCK_CHANCE_EXTENDED 2

/// Regular slowdown when the shield is extended (raised)
#define PHALANX_SLOWDOWN_EXTENDED 0.8
// Brace For Impact slowdown is found in the ability section

// Ability Defines
//-------------------------------------------------------

/// Delay for extending (raising) the shield
#define PHALANX_EXTEND_SHIELD_DELAY 1 SECONDS
/// Delay for retracting (lowering) the shield
#define PHALANX_LOWER_SHIELD_DELAY 0 SECONDS

// Shock Pulse

/// Anti-spam cooldown for toggling the Shock Pulse ability
#define PHALANX_SHOCK_PULSE_COOLDOWN_TIME 2.5 SECONDS
/// Shock Pulse battery drain value every PHALANX_SHOCK_PULSE_UPDATE_INTERVAL
#define PHALANX_SHOCK_PULSE_BATTERY_DRAIN 2
/// Shock Pulse interval for running checks with the ability, see update_shock() (visuals, apply_shock)
#define PHALANX_SHOCK_PULSE_UPDATE_INTERVAL 0.5 SECONDS
/// Maximum range the Shock Pulse travels, in tiles around the user
#define PHALANX_SHOCK_PULSE_RANGE 1
/// Range threshold for when the Shock Pulse applies "more debilitating" effects, in tiles around the user
#define PHALANX_SHOCK_PULSE_RANGE_THRESHOLD 1
/// Stamina threshold for when the Shock Pulse applies "more debilitating" effects, in tiles around the user
#define PHALANX_SHOCK_PULSE_STAMINA_THRESHOLD 50
/// Base damage value the Shock Pulse applies to affected mobs
#define PHALANX_SHOCK_PULSE_BASE_DAMAGE 5
/// Regular daze the Shock Pulse applies to affected mobs
#define PHALANX_SHOCK_PULSE_DAZE 5
/// Regular slow the Shock Pulse applies to affected mobs
#define PHALANX_SHOCK_PULSE_SLOW 3
/// Eyeblur the Shock Pulse applies to affected mobs in PHALANX_SHOCK_PULSE_RANGE_THRESHOLD range
#define PHALANX_SHOCK_PULSE_EYEBLUR 10
/// Color related to the Shock Pulse ability
#define PHALANX_SHOCK_PULSE_COLOR "#3dd8ff"

// Concussion Pulse

/// Regular cooldown for toggling the Concussion Pulse ability
#define PHALANX_CONCUSSION_PULSE_COOLDOWN_TIME 10 SECONDS
/// Concussion Pulse battery drain value for every use
#define PHALANX_CONCUSSION_PULSE_BATTERY_DRAIN 100
/// Delay between using the Concussion Pulse ability and it actually firing off
#define PHALANX_CONCUSSION_PULSE_DELAY 2 SECONDS
/// Range the Concussion Pulse travels, in tiles around the user
#define PHALANX_CONCUSSION_PULSE_RANGE 2
/// Daze value for affected_mobs hit by the Concussion Pulse
#define PHALANX_CONCUSSION_PULSE_DAZE 7.5
/// Slowdown the Concussion Pulse applies to affected mobs larger-equal than MOB_SIZE_LARGE
#define PHALANX_CONCUSSION_PULSE_SUPERSLOW 3
/// Knockdown the Concussion Pulse applies to affected mobs smaller than MOB_SIZE_LARGE
#define PHALANX_CONCUSSION_PULSE_KNOCKDOWN 1
/// Color related to the Concussion Pulse ability
#define PHALANX_CONCUSSION_PULSE_COLOR "#ecff3d"

// Brace For Impact

/// Anti-spam cooldown for toggling the Brace For Impact ability
#define PHALANX_BRACE_FOR_IMPACT_COOLDOWN_TIME 2.5 SECONDS
/// Special block chance in percentage when the shield is braced (ability)
#define PHALANX_SHIELD_CHANCE_BRACED 90
/// Special slowdown when the shield is braced (ability)
#define PHALANX_SLOWDOWN_BRACED 1.5
/// Color related to the Crace For Impact ability
#define PHALANX_BRACE_FOR_IMPACT_COLOR "#ff3da8"

// Block Defines
//-------------------------------------------------------

/// How low the user's stamina drops before we start rolling the dice on dropping the shield
#define PHALANX_STAMINA_DROP_CHECK_THRESHOLD 20
/// The chance in percentage for the user to drop their shield with every block after PHALANX_STAMINA_DROP_CHECK_THRESHOLD is reached
#define PHALANX_STAMINA_DROP_CHANCE 35

/// Regular stamina damage the user takes from blocked attacks
#define PHALANX_STAMINA_DAMAGE_REGULAR 10
/// The lowest that stamina damage can reach from regular blocked attacks
#define PHALANX_LOWEST_STAMINA_REGULAR 20

/// Projectile stamina damage the user takes from blocked attacks
#define PHALANX_STAMINA_DAMAGE_PROJECTILES 1
/// The lowest that stamina damage can reach from blocked projectile attacks
#define PHALANX_LOWEST_STAMINA_PROJECTILES 30

/obj/item/weapon/shield/collapsible/phalanx
	name = "\improper IAP-V2 Phalanx collapsible shield" // Integrated anti-personell version 2 Phalanx collapsible shield
	desc = "An experimental collapsible ballistic shield developed by Armat Battlefield Systems, designed to combat armed riots in densely populated colonies. This newer version comes equipped with two high-powered anti-personnell functions integrated into the shield itself, supercharged for maximum effect by separate battery systems. \n\nThe shield can be quickly extended after a short delay. Special functions remain deactivated until the shield is properly unpacked, although still offering limited defensive capability even in a collapsed state.\n"
	icon = 'icons/obj/items/weapons/melee/shields.dmi'

	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/melee/shields_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/melee/shields_righthand.dmi',
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/melee_weapons.dmi'
	)
	base_icon_state = "phalanx"
	icon_state = "phalanx"
	item_state = "phalanx"

	unacidable = TRUE
	explo_proof = TRUE
	flags_atom = QUICK_DRAWABLE|NO_CRYO_STORE
	flags_equip_slot = SLOT_BACK|SLOT_SUIT_STORE

	shield_type = SHIELD_DIRECTIONAL
	passive_block = PHALANX_SHIELD_CHANCE_COLLAPSED
	passive_projectile_mult = PHALANX_PROJECTILE_BLOCK_CHANCE_COLLAPSED
	readied_block = PHALANX_SHIELD_CHANCE_EXTENDED
	readied_slowdown = PHALANX_SLOWDOWN_EXTENDED
	readied_projectile_mult = PHALANX_PROJECTILE_BLOCK_CHANCE_EXTENDED
	blocks_on_back = TRUE

	force = MELEE_FORCE_WEAK
	throwforce = MELEE_FORCE_WEAK
	throw_speed = SPEED_SLOW
	throw_range = 4

	raise_delay = PHALANX_EXTEND_SHIELD_DELAY
	lower_delay = PHALANX_LOWER_SHIELD_DELAY

	/// The slot an user-dropped Phalanx shield automatically attaches itself to when dropped.
	var/drop_retrieval_slot = WEAR_BACK

	/// Holder for the shield's Shock Pulse battery, which functions as the usage limit and ammo stand-in.
	var/obj/item/phalanx/battery/shock_pulse_battery
	/// Holder for the shield's Concussion Pulse battery, which functions as the usage limit and ammo stand-in.
	var/obj/item/phalanx/battery/concussion_pulse_battery

	/// Holder for the Toggle Shield item action
	var/datum/action/item_action/specialist/phalanx/toggle_shield/toggle_shield_ability
	/// Holder for the Shock Pulse ability
	var/datum/action/item_action/specialist/phalanx/shock_pulse/shock_pulse_ability
	/// Holder for the Concussion Pulse ability
	var/datum/action/item_action/specialist/phalanx/concussion_pulse/concussion_pulse_ability
	/// Holder for the Brace For Impact! ability
	var/datum/action/item_action/specialist/phalanx/brace_for_impact/brace_for_impact_ability

/obj/item/weapon/shield/collapsible/phalanx/Initialize(mapload)
	. = ..()
	flags_item |= TWOHANDED // required for wield logic

	toggle_shield_ability = new(src)
	shock_pulse_battery = new(src)
	shock_pulse_ability = new(src)
	concussion_pulse_battery = new(src)
	concussion_pulse_ability = new(src)
	brace_for_impact_ability = new(src)

	set_light_range(PHALANX_SHOCK_PULSE_RANGE + 1)
	set_light_power(5)
	set_light_color(PHALANX_SHOCK_PULSE_COLOR)

	// We remove the actions again since we use different logic for when the buttons show up/disappear (on toggle instead pick-up).
	LAZYREMOVE(actions, list(shock_pulse_ability, concussion_pulse_ability, brace_for_impact_ability))
	AddElement(/datum/element/drop_retrieval/shield, drop_retrieval_slot)
	AddElement(/datum/element/corp_label/armat)

/obj/item/weapon/shield/collapsible/phalanx/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("<br>This weapon has three special abilities.<br><b>Toggle Shock Pulse</b>: Damage and slow hostiles adjacent with a continuous field of electricity. <br><b>Activate Concussion Pulse</b>: Knockdown and slow nearby targets with a powerful discharge of energy.<br><b>Brace For Impact</b>: Increase block-chance and receive full immunity to displacement. Requires both hands.<br>")
	. += SPAN_CYAN(shock_pulse_battery != null ? "Shock Pulse Charge: [shock_pulse_battery.power_cell.charge] / [shock_pulse_battery.power_cell.maxcharge]" : "No shock pulse battery inserted.")
	. += SPAN_CYAN(concussion_pulse_battery != null ? "Concussion Pulse Charge: [concussion_pulse_battery.power_cell.charge] / [concussion_pulse_battery.power_cell.maxcharge]" : "No concussion pulse battery inserted.")

/obj/item/weapon/shield/collapsible/phalanx/attack_self(mob/user)
	. = ..()
	if(flags_item & WIELDED)
		unwield(user)
	else
		wield(user)

/obj/item/weapon/shield/collapsible/phalanx/attackby(obj/item/attacking_object, mob/user)
	if(shock_pulse_ability.ability_active || concussion_pulse_ability.ability_winding_up)
		to_chat(user, SPAN_WARNING("You can not swap batteries while the shield is being activated!"))

	if(istype(attacking_object, /obj/item/phalanx/battery))
		var /obj/item/phalanx/battery/new_battery = attacking_object
		visible_message(SPAN_NOTICE("[user] swaps out a [new_battery] in [src]."),
			SPAN_NOTICE("You swap out a [new_battery] in [src] and drop the old one."))
		to_chat(user, SPAN_NOTICE("The new [new_battery] contains: [new_battery.power_cell.charge] power."))
		if(istype(new_battery, /obj/item/phalanx/battery/shock_pulse_battery))
			var /obj/item/phalanx/battery/shock_pulse_battery/new_shock_pulse_battery = new_battery
			shock_pulse_battery.update_icon()
			shock_pulse_battery.forceMove(get_turf(user))
			shock_pulse_battery = new_shock_pulse_battery
		else if(istype(new_battery, /obj/item/phalanx/battery/concussion_pulse_battery))
			var /obj/item/phalanx/battery/concussion_pulse_battery/new_concussion_pulse_battery = new_battery
			concussion_pulse_battery.update_icon()
			concussion_pulse_battery.forceMove(get_turf(user))
			concussion_pulse_battery = new_concussion_pulse_battery
		user.drop_inv_item_to_loc(new_battery, src)
		playsound(src, 'sound/machines/click.ogg', 25, 1)
		return

	return ..()
/// Called when the shield is dropped. Ensures that it is also unwielded and lowered (retracted).
/obj/item/weapon/shield/collapsible/phalanx/dropped(mob/user)
	if(flags_item & WIELDED)
		unwield(user)
	if(shield_readied)
		lower_shield(user)
	. = ..()

/// Called when the shield is to be no longer held in two hands. Ensures that Brace For Impact! is no longer active.
/obj/item/weapon/shield/collapsible/phalanx/unwield(mob/user)
	. = ..()
	var/mob/living/carbon/human/shield_wielder = user
	if(brace_for_impact_ability.ability_active)
		brace_for_impact_ability.stop_bracing(shield_wielder)

/obj/item/weapon/shield/collapsible/phalanx/place_offhand(mob/user,item_name)
	to_chat(user, SPAN_NOTICE("You grab the secondary handle on \the [item_name] with your other hand."))
	user.recalculate_move_delay = TRUE
	var/obj/item/weapon/twohanded/offhand/offhand = new /obj/item/weapon/twohanded/offhand(user)
	offhand.name = "[item_name] - offhand"
	offhand.desc = "Your secondary grip on the \the [item_name]."
	offhand.flags_item |= WIELDED
	offhand.force_wielded = 0
	offhand.force = 0
	user.put_in_inactive_hand(offhand)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand()

/obj/item/weapon/shield/collapsible/phalanx/remove_offhand(mob/user)
	to_chat(user, SPAN_NOTICE("You release your secondary grip on \the [name]."))
	user.recalculate_move_delay = TRUE
	var/obj/item/weapon/twohanded/offhand/offhand = user.get_inactive_hand()
	if(istype(offhand))
		offhand.unwield(user)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand()

/obj/item/weapon/shield/collapsible/phalanx/toggle_shield(mob/user as mob)
	if(shield_readied)
		if(flags_item & WIELDED)
			unwield(user)
		lower_shield(user)
	else
		if(flags_item & WIELDED)
			unwield(user)
		raise_shield(user)

/obj/item/weapon/shield/collapsible/phalanx/raise_shield(mob/user as mob)
	. = ..()
	if (!.)
		return // interrupted!

	if(shock_pulse_ability)
		shock_pulse_ability.give_to(user)
	if(concussion_pulse_ability)
		concussion_pulse_ability.give_to(user)
	if(brace_for_impact_ability)
		brace_for_impact_ability.give_to(user)

	flags_item |= NODROP|FORCEDROP_CONDITIONAL
	force = MELEE_FORCE_NORMAL

	var/mob/living/carbon/human/shield_wielder = user
	shield_wielder.status_flags &= ~CANKNOCKDOWN

/obj/item/weapon/shield/collapsible/phalanx/lower_shield(mob/user as mob)
	. = ..()

	if(shock_pulse_ability)
		shock_pulse_ability.remove_from(user)
	if(concussion_pulse_ability)
		concussion_pulse_ability.remove_from(user)
	if(brace_for_impact_ability)
		brace_for_impact_ability.remove_from(user)

	flags_item &= ~(NODROP|FORCEDROP_CONDITIONAL)
	force = MELEE_FORCE_WEAK

	var/mob/living/carbon/human/shield_wielder = user
	shield_wielder.status_flags |= CANKNOCKDOWN
	deactivate_all_abilities(shield_wielder)

/// Called on successful blocks with the shield. Consecutive hits apply stamina damage until the user can no longer hold the shield.
/obj/item/weapon/shield/collapsible/phalanx/on_block(mob/user as mob, attack_type)
	var/mob/living/carbon/human/shield_wielder = user
	if(!shield_wielder || !shield_wielder.stamina)
		return
	var/is_projectile_attack = attack_type == SHIELD_ATTACK_PROJECTILE
	if(shield_wielder.stamina.current_stamina >= (is_projectile_attack ? PHALANX_LOWEST_STAMINA_PROJECTILES : PHALANX_LOWEST_STAMINA_REGULAR))
		shield_wielder.apply_stamina_damage(is_projectile_attack ? PHALANX_STAMINA_DAMAGE_PROJECTILES : PHALANX_STAMINA_DAMAGE_REGULAR)

	// TODO: REMOVE DEBUG MESSAGE!!!
	shield_wielder.visible_message(SPAN_WARNING("DEBUG: [shield_wielder.stamina.current_stamina]"), \
		SPAN_WARNING("DEBUG: [shield_wielder.stamina.current_stamina]"))

	if(shield_wielder.stamina.current_stamina <= PHALANX_STAMINA_DROP_CHECK_THRESHOLD)
		if(prob(PHALANX_STAMINA_DROP_CHANCE))
			shield_wielder.visible_message(SPAN_WARNING("[shield_wielder] struggles to keep a hold of \the [src], dropping it on the ground!"), \
			SPAN_WARNING("Your strength wanes, forcing you to release \the [src]!"))
			shield_wielder.drop_inv_item_on_ground(src, force = TRUE)
		else
			shield_wielder.visible_message(SPAN_WARNING("[shield_wielder] seems have trouble holding \the [src]!"), \
			SPAN_WARNING("Exhausted, you barely manage to hold onto \the [src]!..."))

/obj/item/weapon/shield/collapsible/phalanx/verb/toggle_shield_verb()
	set name = "Extend/Collapse Phalanx Shield"
	set desc = "Extend or collapse the shield."
	set category = "Weapons"
	set src in usr
	if(!usr || usr.is_mob_incapacitated(TRUE))
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/shield_wielder = usr
	toggle_shield(shield_wielder)

/obj/item/weapon/shield/collapsible/phalanx/verb/shock_pulse_verb()
	set name = "Toggle Shock Pulse"
	set desc = "Toggle your shield's Shock Pulse ability."
	set category = "Weapons"
	set src in usr
	if(!usr || usr.is_mob_incapacitated(TRUE))
		return
	if(!ishuman(usr))
		return
	shock_pulse_ability.action_activate()

/obj/item/weapon/shield/collapsible/phalanx/verb/concussion_pulse_verb()
	set name = "Activate Concussion Pulse"
	set desc = "Activate your shield's Concussion Pulse ability."
	set category = "Weapons"
	set src in usr
	if(!usr || usr.is_mob_incapacitated(TRUE))
		return
	if(!ishuman(usr))
		return
	concussion_pulse_ability.action_activate()

/obj/item/weapon/shield/collapsible/phalanx/verb/brace_for_impact_verb()
	set name = "Brace For Impact"
	set desc = "Plant your feet and focus on incoming attacks. Requires both hands on the shield."
	set category = "Weapons"
	set src in usr
	if(!usr || usr.is_mob_incapacitated(TRUE))
		return
	if(!ishuman(usr))
		return
	brace_for_impact_ability.action_activate()

/obj/item/weapon/shield/collapsible/phalanx/proc/deactivate_all_abilities(mob/living/carbon/human/shield_wielder)
	if(shock_pulse_ability.ability_active)
		shock_pulse_ability.stop_shocking(shield_wielder)
	if(concussion_pulse_ability.ability_winding_up)
		concussion_pulse_ability.ability_winding_up = FALSE
	if(brace_for_impact_ability.ability_active)
		brace_for_impact_ability.stop_bracing(shield_wielder)

//-------------------------------------------------------
// Phalanx Abilities
//-------------------------------------------------------

/datum/action/item_action/specialist/phalanx/toggle_shield
	ability_primacy = SPEC_NOT_PRIMARY_ACTION

/datum/action/item_action/specialist/phalanx/toggle_shield/New(mob/living/user, obj/item/holder)
	..()
	name = "Extend/Collapse Phalanx Shield"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/mob/hud/actions.dmi', button, "extend_stock")
	button.overlays += IMG
	update_button_icon()

/datum/action/item_action/specialist/phalanx/toggle_shield/action_activate()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/shield_wielder = owner
	var/obj/item/weapon/shield/collapsible/phalanx/shield = holder_item

	if(!skillcheck(shield_wielder, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && shield_wielder.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_PHALANX)
		to_chat(shield_wielder, SPAN_WARNING("You don't seem to know how to use \the [shield]..."))
		return

	if(shield.concussion_pulse_ability.ability_winding_up)
		to_chat(shield_wielder, SPAN_WARNING("You can not toggle \the [shield] while it is charging a concussive blast!"))
		return

	shield.toggle_shield(shield_wielder)

// Shock Pulse
//-------------------------------------------------------

/datum/action/item_action/specialist/phalanx/shock_pulse
	ability_primacy = SPEC_PRIMARY_ACTION_1
	var/ability_active = FALSE

/datum/action/item_action/specialist/phalanx/shock_pulse/New(mob/living/user, obj/item/holder)
	..()
	name = "Toggle Shock Pulse"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/mob/hud/actions.dmi', button, "smartpack_immobile")
	button.overlays += IMG
	update_button_icon()

/datum/action/item_action/specialist/phalanx/shock_pulse/action_activate()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/shield_wielder = owner
	var/obj/item/weapon/shield/collapsible/phalanx/shield = holder_item

	if(!action_cooldown_check())
		to_chat(shield_wielder, SPAN_WARNING("Shock Pulse was recently activated, wait before trying to activate it again."))
		return

	if(!shield.shock_pulse_battery || shield.shock_pulse_battery.power_cell.charge < PHALANX_SHOCK_PULSE_BATTERY_DRAIN)
		to_chat(shield_wielder, SPAN_WARNING("Shock Pulse requires an adequately charged battery to function!"))
		return

	if(shield.brace_for_impact_ability.ability_active)
		shield.brace_for_impact_ability.stop_bracing(shield_wielder)

	if(ability_active)
		stop_shocking(shield_wielder)
	else
		start_shocking(shield_wielder)

	enter_cooldown(PHALANX_SHOCK_PULSE_COOLDOWN_TIME)

/datum/action/item_action/specialist/phalanx/shock_pulse/proc/start_shocking(mob/living/carbon/human/shield_wielder)
	var/obj/item/weapon/shield/collapsible/phalanx/shield = holder_item
	shield_wielder.visible_message(SPAN_WARNING("[shield_wielder]'s [shield] starts emitting sparks!"), \
			SPAN_WARNING("Your [shield] starts emitting sparks!"))
	if(shield.shock_pulse_battery)
		to_chat(shield_wielder, SPAN_WARNING("<b>SHOCK PULSE</b>: [shield.shock_pulse_battery.power_cell.charge] / [shield.shock_pulse_battery.power_cell.maxcharge] CHARGE REMAINING."))
	shield_wielder.add_filter("shock_pulse_outline", 1, outline_filter(1, PHALANX_SHOCK_PULSE_COLOR))
	shield.set_light_on(TRUE)
	button.icon_state = "template_on"
	ability_active = TRUE
	update_shock(shield_wielder)

/datum/action/item_action/specialist/phalanx/shock_pulse/proc/update_shock()
	var/mob/living/carbon/human/shield_wielder = owner
	var/obj/item/weapon/shield/collapsible/phalanx/shield = holder_item
	if(!shield.shock_pulse_ability.ability_active)
		return
	if(shield.shock_pulse_battery && shield.shock_pulse_battery.power_cell.charge % 50 == 0)
		to_chat(shield_wielder, SPAN_CYAN("<b>SHOCK PULSE</b>: [shield.shock_pulse_battery.power_cell.charge] / [shield.shock_pulse_battery.power_cell.maxcharge] CHARGE REMAINING."))
	if(shield.shock_pulse_battery.power_cell.charge == 0)
		stop_shocking(shield_wielder)
		return

	for(var/turf/target_turf in range(PHALANX_SHOCK_PULSE_RANGE, shield_wielder))
		if(istype(target_turf, /turf/open/space))
			continue
		var/ring = get_dist(shield_wielder, target_turf)
		addtimer(CALLBACK(src, PROC_REF(apply_shock), target_turf, ring), ring)

	shield.shock_pulse_battery.power_cell.charge -= PHALANX_SHOCK_PULSE_BATTERY_DRAIN
	addtimer(CALLBACK(src, PROC_REF(update_shock), shield_wielder), PHALANX_SHOCK_PULSE_UPDATE_INTERVAL)

/datum/action/item_action/specialist/phalanx/shock_pulse/proc/apply_shock(turf/target_turf, distance)
	var/mob/living/carbon/human/shield_wielder = owner
	if(prob(5))
		var/datum/effect_system/spark_spread/sparks= new
		sparks.set_up(1, 1, target_turf)
		sparks.start()
		qdel(sparks)
	if(prob(75))
		new /obj/effect/overlay/temp/emp_sparks(target_turf)


	/**
	* At ranges below threshold: Humans take stamina damage, non-humans take regular damage.
	* Prolonged exposure (approximated by having low stamina values) apply actual damage even to humans.
	*/

	var/damage_applied = PHALANX_SHOCK_PULSE_BASE_DAMAGE
	for(var/mob/living/affected_mob in target_turf)
		if(affected_mob == shield_wielder)
			continue
		affected_mob.Daze(PHALANX_SHOCK_PULSE_DAZE)
		affected_mob.Slow(PHALANX_SHOCK_PULSE_DAZE)

		// mobs start being jittery at 100, we call make_jittery(1) to trigger the processing, then remove it after PHALANX_SHOCK_PULSE_UPDATE_INTERVAL
		if(!affected_mob.is_jittery)
			affected_mob.jitteriness = 100
			affected_mob.make_jittery(1)
		addtimer(CALLBACK(affected_mob, TYPE_PROC_REF(/mob, remove_jittery)), PHALANX_SHOCK_PULSE_UPDATE_INTERVAL)

		if(distance <= PHALANX_SHOCK_PULSE_RANGE_THRESHOLD)
			if(ishuman(affected_mob))
				affected_mob.jitteriness = 500
				var/mob/living/carbon/human/shocked_human = affected_mob
				if(isspeciessynth(shocked_human)) // Overvoltage to ungrounded robots is pretty bad
					damage_applied *= 1.5
					new /obj/effect/overlay/temp/elec_arc(get_turf(shocked_human))
					to_chat(shocked_human, SPAN_HIGHDANGER("All of your systems jam up as your main bus is overvolted by [damage_applied*2] volts."))
					shocked_human.visible_message(SPAN_WARNING("[shocked_human] seizes up from the electric shock."))
				shocked_human.apply_stamina_damage(damage_applied)
				if(shocked_human.stamina.current_stamina <= PHALANX_SHOCK_PULSE_STAMINA_THRESHOLD)
					shocked_human.take_overall_armored_damage(damage_applied, ARMOR_ENERGY, BURN, 90) // 90% chance to be on additional limbs
					shocked_human.make_dizzy(damage_applied)
					shocked_human.emote("pain")
			else
				if(isxeno(affected_mob))
					var/mob/living/carbon/xenomorph/shocked_xeno = affected_mob
					shocked_xeno.xeno_jitter()
				affected_mob.apply_damage(damage_applied, BURN)
				affected_mob.EyeBlur(PHALANX_SHOCK_PULSE_EYEBLUR)
				if(iswydroid(affected_mob))
					affected_mob.emote("pain")

/datum/action/item_action/specialist/phalanx/shock_pulse/proc/stop_shocking(mob/living/carbon/human/shield_wielder)
	shield_wielder.visible_message(SPAN_WARNING("[shield_wielder]'s shield stops emitting sparks!"), \
			SPAN_WARNING("Your shield stops emitting sparks!"))
	var/obj/item/weapon/shield/collapsible/phalanx/shield = holder_item
	if(shield.shock_pulse_battery)
		to_chat(shield_wielder, SPAN_CYAN("<b>SHOCK PULSE: </b>[shield.shock_pulse_battery.power_cell.charge] / [shield.shock_pulse_battery.power_cell.maxcharge] CHARGE REMAINING."))
	shield_wielder.remove_filter("shock_pulse_outline")
	shield.set_light_on(FALSE)
	button.icon_state = "template"
	ability_active = FALSE

// Concussion Pulse
//-------------------------------------------------------

/datum/action/item_action/specialist/phalanx/concussion_pulse
	ability_primacy = SPEC_PRIMARY_ACTION_2
	var/ability_winding_up = FALSE

/datum/action/item_action/specialist/phalanx/concussion_pulse/New(mob/living/user, obj/item/holder)
	..()
	name = "Activate Concussion Pulse"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/mob/hud/actions.dmi', button, "smartpack_repair")
	button.overlays += IMG
	update_button_icon()

/datum/action/item_action/specialist/phalanx/concussion_pulse/action_activate()
	. = ..()

	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/shield_wielder = owner
	var/obj/item/weapon/shield/collapsible/phalanx/shield = holder_item

	if(!action_cooldown_check())
		to_chat(shield_wielder, SPAN_WARNING("Concussion Pulse was recently activated, wait before trying to activate it again."))
		return

	if(!shield.concussion_pulse_battery || shield.concussion_pulse_battery.power_cell.charge < PHALANX_CONCUSSION_PULSE_BATTERY_DRAIN)
		to_chat(shield_wielder, SPAN_WARNING("Concussion Pulse requires an adequately charged battery to function!"))
		return

	if(shield.shock_pulse_ability.ability_active)
		shield.shock_pulse_ability.stop_shocking(shield_wielder)

	to_chat(shield_wielder, SPAN_WARNING("<b>CONCUSSION PULSE</b>: [shield.concussion_pulse_battery.power_cell.charge] / [shield.concussion_pulse_battery.power_cell.maxcharge] CHARGE REMAINING."))
	playsound(shield_wielder.loc, 'sound/machines/chime.ogg', 20)
	shield.concussion_pulse_battery.power_cell.charge -= PHALANX_CONCUSSION_PULSE_BATTERY_DRAIN
	shield_wielder.visible_message(SPAN_WARNING("[shield_wielder]'s [shield] begins charging a devastating shock!"), \
			SPAN_WARNING("Your [shield] heats up as it charges a devastating shock!"))
	shield_wielder.add_filter("concussion_pulse_outline", 1, outline_filter(1, PHALANX_CONCUSSION_PULSE_COLOR))
	addtimer(CALLBACK(src, PROC_REF(release_concussion_pulse), shield_wielder), PHALANX_CONCUSSION_PULSE_DELAY)
	ability_winding_up = TRUE

	enter_cooldown(PHALANX_CONCUSSION_PULSE_COOLDOWN_TIME)

/datum/action/item_action/specialist/phalanx/concussion_pulse/proc/release_concussion_pulse(mob/living/carbon/human/shield_wielder)
	var/obj/item/weapon/shield/collapsible/phalanx/shield = holder_item
	shield_wielder.remove_filter("concussion_pulse_outline")

	if(!ability_winding_up)
		return

	FOR_DOVIEW(var/mob/living/affected_mob, PHALANX_CONCUSSION_PULSE_RANGE, shield_wielder.loc, HIDE_INVISIBLE_OBSERVER)
		if(affected_mob.stat == DEAD)
			continue
		if(HAS_TRAIT(affected_mob, TRAIT_CHARGING))
			to_chat(affected_mob, SPAN_WARNING("You power through a shocking sensation as you charge."))
			continue
		if(affected_mob.get_target_lock(FACTION_LIST_MARINE))
			continue
		var/datum/effect_system/spark_spread/sparks = new()
		sparks.set_up(5, 0, affected_mob)
		sparks.attach(affected_mob)
		sparks.start()
		qdel(sparks)
		shield_wielder.beam(affected_mob, "electric", 'icons/effects/beam.dmi', 5, 5)

		affected_mob.Daze(PHALANX_CONCUSSION_PULSE_DAZE)
		if (affected_mob.mob_size >= MOB_SIZE_BIG)
			affected_mob.Superslow(PHALANX_CONCUSSION_PULSE_SUPERSLOW)
		else
			affected_mob.KnockDown(PHALANX_CONCUSSION_PULSE_KNOCKDOWN)
	FOR_DOVIEW_END

	FOR_DOVIEW(var/obj/structure/machinery/defenses/defense, PHALANX_CONCUSSION_PULSE_RANGE, shield_wielder.loc, HIDE_INVISIBLE_OBSERVER)
		var/datum/effect_system/spark_spread/sparks = new()
		sparks.set_up(5, 0, defense)
		sparks.attach(defense)
		sparks.start()
		qdel(sparks)
		shield_wielder.beam(defense, "electric", 'icons/effects/beam.dmi', 5, 5)

		if(defense.turned_on)
			defense.power_off()
	FOR_DOVIEW_END

	if(shield.concussion_pulse_battery)
		to_chat(shield_wielder, SPAN_CYAN("<b>CONCUSSION PULSE</b>: [shield.concussion_pulse_battery.power_cell.charge] / [shield.concussion_pulse_battery.power_cell.maxcharge] CHARGE REMAINING."))

	ability_winding_up = FALSE

// Brace For Impact
//-------------------------------------------------------

/datum/action/item_action/specialist/phalanx/brace_for_impact
	ability_primacy = SPEC_NOT_PRIMARY_ACTION
	var/ability_active = FALSE

/datum/action/item_action/specialist/phalanx/brace_for_impact/New(mob/living/user, obj/item/holder)
	..()
	name = "Brace For Impact"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/mob/hud/actions.dmi', button, "smartpack_protect")
	button.overlays += IMG
	update_button_icon()

/datum/action/item_action/specialist/phalanx/brace_for_impact/action_activate()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/shield_wielder = owner
	var/obj/item/weapon/shield/collapsible/phalanx/shield = holder_item

	if(shield.shock_pulse_ability.ability_active)
		shield.shock_pulse_ability.stop_shocking(shield_wielder)

	if(ability_active)
		stop_bracing(shield_wielder)
	else
		start_bracing(shield_wielder)

/datum/action/item_action/specialist/phalanx/brace_for_impact/proc/start_bracing(mob/living/carbon/human/shield_wielder)
	var/obj/item/weapon/shield/collapsible/phalanx/shield = holder_item
	if(!(shield.flags_item & WIELDED))
		to_chat(shield_wielder, SPAN_WARNING("You can not begin maneuvering your shield into harm's way with just one hand. Use both hands!"))
		return

	if(!action_cooldown_check())
		to_chat(shield_wielder, SPAN_WARNING("Brace For Impact was recently activated, wait before trying to activate it again."))
		return

	shield_wielder.status_flags &= ~(CANPUSH|CANSTUN)
	shield.readied_block = PHALANX_SHIELD_CHANCE_BRACED

	var/current_shield_slowdown = shield_wielder.shield_slowdown
	shield_wielder.shield_slowdown = max(PHALANX_SLOWDOWN_BRACED, shield_wielder.shield_slowdown)
	if(shield_wielder.shield_slowdown != current_shield_slowdown)
		shield_wielder.recalculate_move_delay = TRUE

	to_chat(shield_wielder, "Your grip tightens on the shield, and you focus on what's to come!")
	shield_wielder.add_filter("brace_for_impact", 1, outline_filter(1, PHALANX_BRACE_FOR_IMPACT_COLOR))
	button.icon_state = "template_on"
	ability_active = TRUE
	enter_cooldown(PHALANX_BRACE_FOR_IMPACT_COOLDOWN_TIME)

/datum/action/item_action/specialist/phalanx/brace_for_impact/proc/stop_bracing(mob/living/carbon/human/shield_wielder)
	var/obj/item/weapon/shield/collapsible/phalanx/shield = holder_item
	shield_wielder.status_flags |= (CANPUSH|CANSTUN)
	shield.readied_block = PHALANX_SHIELD_CHANCE_EXTENDED
	shield.readied_slowdown = PHALANX_SLOWDOWN_EXTENDED

	var/current_shield_slowdown = shield_wielder.shield_slowdown
	shield_wielder.shield_slowdown = shield.readied_slowdown
	if(shield_wielder.shield_slowdown != current_shield_slowdown)
		shield_wielder.recalculate_move_delay = TRUE

	to_chat(shield_wielder, "You lessen your grip, no longer trying to defend against all attacks.")
	shield_wielder.remove_filter("brace_for_impact")
	button.icon_state = "template"
	ability_active = FALSE

//-------------------------------------------------------
// Ability Batteries
//-------------------------------------------------------

/obj/item/phalanx/battery
	name = "\improper PCS 24V battery" // Phalanx collapsible shield 24V battery
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "smartguncell"
	var/obj/item/cell/power_cell
	w_class = SIZE_MEDIUM

/obj/item/phalanx/battery/Initialize(mapload)
	. = ..()
	power_cell = new(src)
	AddElement(/datum/element/corp_label/armat)

/obj/item/phalanx/battery/Destroy()
	QDEL_NULL(power_cell)
	return ..()

/obj/item/phalanx/battery/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("The power indicator reads [power_cell.charge] charge out of [power_cell.maxcharge] total.")

/obj/item/phalanx/battery/shock_pulse_battery
	name = "\improper PCS 24V shock pulse battery"
	desc = "A special-issue 24-volt lithium-polymer battery pack with an in-built capacitor bank, used to power and amplify the shock pulse function of the Phalanx collapsible shield. Per the manual, one battery is good for up to five minutes of continuous use. Its rather large size and uncommon design makes it incompatible with most standard electrical systems. Recharging requires special heavy duty equipment, currently available only to certified Armat workshop engineers due to safety concerns."

/obj/item/phalanx/battery/concussion_pulse_battery
	name = "\improper PCS 24V concussion pulse battery"
	desc = "A special-issue 24-volt lithium-polymer battery pack with an in-built capacitor bank, used to power and amplify the concussion pulse function of the Phalanx collapsible shield. Per the manual, one battery is good for up to twenty consecutive uses. Its rather large size and uncommon design makes it incompatible with most standard electrical systems. Recharging requires special heavy duty equipment, currently available only to certified Armat workshop engineers due to safety concerns."
