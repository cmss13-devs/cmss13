
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

/datum/component/bonus_damage_stack/Initialize(bonus_damage_stacks, time)
	. = ..()
	src.bonus_damage_stacks = bonus_damage_stacks
	if(!time)
		time = world.time
	src.last_stack = time

/datum/component/bonus_damage_stack/InheritComponent(datum/component/bonus_damage_stack/BDS, i_am_original, bonus_damage_stacks, time)
	. = ..()
	if(!BDS)
		src.bonus_damage_stacks += bonus_damage_stacks
		src.last_stack = time
	else
		src.bonus_damage_stacks += BDS.bonus_damage_stacks
		src.last_stack = BDS.last_stack

	src.bonus_damage_stacks = min(src.bonus_damage_stacks, bonus_damage_cap)

/datum/component/bonus_damage_stack/process(delta_time)
	if(last_stack + 5 SECONDS < world.time)
		bonus_damage_stacks = bonus_damage_stacks - BONUS_DAMAGE_STACK_LOSS_PER_SECOND * delta_time

	if(bonus_damage_stacks <= 0)
		qdel(src)

	var/color = COLOR_BONUS_DAMAGE
	var/intensity = bonus_damage_stacks / (bonus_damage_cap * 2)
	color += num2text(BONUS_DAMAGE_MAX_ALPHA * intensity, 2, 16)

	if(parent)
		var/atom/A = parent
		A.add_filter("bonus_damage_stacks", 2, list("type" = "outline", "color" = color, "size" = 1))

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

/datum/component/bonus_damage_stack/proc/get_bonus_damage(mob/M, list/damage_data) // 10% damage bonus at most
	SIGNAL_HANDLER
	damage_data["bonus_damage"] = damage_data["damage"] * (min(bonus_damage_stacks, bonus_damage_cap) / 1000)

#undef COLOR_BONUS_DAMAGE
#undef BONUS_DAMAGE_MAX_ALPHA
#undef BONUS_DAMAGE_STACK_LOSS_PER_SECOND
