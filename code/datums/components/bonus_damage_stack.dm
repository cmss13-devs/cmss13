
#define COLOR_BONUS_DAMAGE "#c3ce2f"
/// Max alpha for the filter outline.
#define BONUS_DAMAGE_MAX_ALPHA 200
/// Loss of stack every second once it's been more than 5 seconds since last_stack.
#define BONUS_DAMAGE_STACK_LOSS_PER_SECOND 5


// Stacks up to 100. For every 10 stacks on a mob, the mob takes an extra 1% damage. At maximum stacks, the mob takes 10% damage, starting to wear off after 5 seconds of not getting hit by a holo-targeting round
/datum/component/bonus_damage_stack
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	/// extra damage multiplier, divided by 1000
	var/bonus_damage_stacks = 0
	/// extra damage multiplier, divided by 1000
	var/bonus_damage_cap = 100
	/// Last world.time that the afflicted was hit by a holo-targeting round.
	var/last_stack
	/// extra cap limit added by more powerful bullets
	var/bonus_damage_cap_increase = 0
	/// multiplies the BONUS_DAMAGE_STACK_LOSS_PER_SECOND calculation, modifying how fast we lose holo stacks
	var/stack_loss_multiplier = 1

/datum/component/bonus_damage_stack/Initialize(bonus_damage_stacks, time, bonus_damage_cap_increase, stack_loss_multiplier)
	. = ..()
	src.bonus_damage_stacks = bonus_damage_stacks
	src.stack_loss_multiplier = stack_loss_multiplier
	src.bonus_damage_cap = initial(bonus_damage_cap) + bonus_damage_cap_increase // this way it will never increase over the intended limit
	if(!time)
		time = world.time
	src.last_stack = time

/datum/component/bonus_damage_stack/InheritComponent(datum/component/bonus_damage_stack/BDS, i_am_original, bonus_damage_stacks, time, bonus_damage_cap_increase, stack_loss_multiplier)
	. = ..()
	if(!BDS)
		src.bonus_damage_stacks += bonus_damage_stacks
		src.last_stack = time
	else
		src.bonus_damage_stacks += BDS.bonus_damage_stacks
		src.last_stack = BDS.last_stack

	// if a different type of holo targetting bullet hits a mob and has a bigger bonus cap, it will get applied.
	if(src.bonus_damage_cap_increase < bonus_damage_cap_increase)
		src.bonus_damage_cap_increase = bonus_damage_cap_increase
		src.bonus_damage_cap = initial(bonus_damage_cap) + src.bonus_damage_cap_increase

	// however, if it has a worse stack_loss_multiplier, it will get applied instead.
	// this way, if a weapon is meant to have a big bonus cap but holo stacks that rapidly deplete, it will not be messed up by a weapon that a low stack_loss_multiplier.
	if(src.stack_loss_multiplier < stack_loss_multiplier)
		src.stack_loss_multiplier = stack_loss_multiplier

	src.bonus_damage_stacks = min(src.bonus_damage_stacks, src.bonus_damage_cap)

/datum/component/bonus_damage_stack/process(delta_time)
	if(last_stack + 5 SECONDS < world.time)
		bonus_damage_stacks = bonus_damage_stacks - BONUS_DAMAGE_STACK_LOSS_PER_SECOND * stack_loss_multiplier * delta_time

	if(bonus_damage_stacks <= 0)
		qdel(src)

	var/color = COLOR_BONUS_DAMAGE
	var/intensity = bonus_damage_stacks / (initial(bonus_damage_cap) * 2)
	// if intensity is too high of a value, the hex code will become invalid
	color += num2text(BONUS_DAMAGE_MAX_ALPHA * clamp(intensity, 0, 0.5), 2, 16)
	if(parent)
		var/atom/A = parent
		A.add_filter("bonus_damage_stacks", 2, list("type" = "outline", "color" = color, "size" = 1 + clamp(intensity, 0, 1)))

/datum/component/bonus_damage_stack/RegisterWithParent()
	START_PROCESSING(SSdcs, src)
	RegisterSignal(parent, COMSIG_XENO_APPEND_TO_STAT, PROC_REF(stat_append))
	RegisterSignal(parent, COMSIG_BONUS_DAMAGE, PROC_REF(get_bonus_damage))

/datum/component/bonus_damage_stack/UnregisterFromParent()
	STOP_PROCESSING(SSdcs, src)
	UnregisterSignal(parent, list(
		COMSIG_XENO_APPEND_TO_STAT,
		COMSIG_BONUS_DAMAGE
	))
	var/atom/A = parent
	A.remove_filter("bonus_damage_stacks")

/datum/component/bonus_damage_stack/proc/stat_append(mob/M, list/L)
	SIGNAL_HANDLER
	L += "Bonus Damage Taken: [bonus_damage_stacks * 0.1]%"

/datum/component/bonus_damage_stack/proc/get_bonus_damage(mob/M, list/damage_data) // 10% damage bonus in most instances
	SIGNAL_HANDLER
	damage_data["bonus_damage"] = damage_data["damage"] * (min(bonus_damage_stacks, bonus_damage_cap) / 1000)

#undef COLOR_BONUS_DAMAGE
#undef BONUS_DAMAGE_MAX_ALPHA
#undef BONUS_DAMAGE_STACK_LOSS_PER_SECOND
