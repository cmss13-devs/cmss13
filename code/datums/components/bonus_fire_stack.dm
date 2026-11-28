
#define COLOR_BONUS_DAMAGE "#ce7726"
/// Max alpha for the filter outline.
#define BONUS_DAMAGE_MAX_ALPHA 200
/// Loss of stack every second once it's been more than 5 seconds since last_stack.
#define bonus_fire_stack_LOSS_PER_SECOND 4


// Stacks up to 100. For every 10 stacks on a mob, the mob takes an extra 1% damage. At maximum stacks, the mob takes 10% damage, starting to wear off after 5 seconds of not getting hit by a holo-targeting round
/datum/component/bonus_fire_stack
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	/// extra damage multiplier, divided by 1000
	var/bonus_fire_stacks = 0
	/// extra damage multiplier, divided by 1000
	var/ignite_threshold = 120
	/// Last world.time that the afflicted was hit by a holo-targeting round.
	var/last_stack
	/// reagent to apply on ignition
	var/burn_reagent = /datum/reagent/napalm/ut
	var/burn_stacks = 30

/datum/component/bonus_fire_stack/Initialize(bonus_fire_stacks, time)
	. = ..()
	src.bonus_fire_stacks = bonus_fire_stacks
	src.ignite_threshold = initial(ignite_threshold)
	if(!time)
		time = world.time
	src.last_stack = time


/datum/component/bonus_fire_stack/InheritComponent(datum/component/bonus_fire_stack/BDS, i_am_original, bonus_fire_stacks, time)
	. = ..()
	if(!BDS)
		src.bonus_fire_stacks += bonus_fire_stacks
		src.last_stack = time
	else
		src.bonus_fire_stacks += BDS.bonus_fire_stacks
		src.last_stack = BDS.last_stack

/datum/component/bonus_fire_stack/process(delta_time)

	if(bonus_fire_stacks >= ignite_threshold)
		if(ispath(burn_reagent))
			var/datum/reagent/temp = burn_reagent
			burn_reagent = GLOB.chemical_reagents_list[initial(temp.id)]
		if(parent)
			var/mob/living/target = parent
			target.TryIgniteMob(burn_stacks, burn_reagent) //30 burn stacks, proc needs a reagent to work.
			bonus_fire_stacks = 0
	if(last_stack + 5 SECONDS < world.time)
		bonus_fire_stacks = bonus_fire_stacks - bonus_fire_stack_LOSS_PER_SECOND * delta_time

	if(bonus_fire_stacks <= 0)
		qdel(src)

	var/color = COLOR_BONUS_DAMAGE
	var/intensity = bonus_fire_stacks / (initial(ignite_threshold) * 2)
	// if intensity is too high of a value, the hex code will become invalid
	color += num2text(BONUS_DAMAGE_MAX_ALPHA * clamp(intensity, 0, 0.5), 2, 16)
	if(parent)
		var/atom/A = parent
		A.add_filter("bonus_fire_stacks", 2, list("type" = "outline", "color" = color, "size" = 1 + clamp(intensity, 0, 1)))

/datum/component/bonus_fire_stack/RegisterWithParent()
	START_PROCESSING(SSdcs, src)

/datum/component/bonus_fire_stack/UnregisterFromParent()
	STOP_PROCESSING(SSdcs, src)
	var/atom/A = parent
	A.remove_filter("bonus_fire_stacks")

#undef COLOR_BONUS_DAMAGE
#undef BONUS_DAMAGE_MAX_ALPHA
#undef bonus_fire_stack_LOSS_PER_SECOND
