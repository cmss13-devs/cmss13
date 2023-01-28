
#define COLOR_CLUSTER "#c75a51"
/// Max alpha for the filter outline.
#define CLUSTER_MAX_ALPHA 200
/// Once cluster_stacks reaches this number, it triggers apply_cluster_stacks() and resets to zero.
#define MAX_CLUSTER_STACKS 15
/// Loss of stack every second once it's been more than 5 seconds since last_stack.
#define CLUSTER_STACK_LOSS_PER_SECOND AMOUNT_PER_TIME(2, 1)

//stacks up to 15 while counting all damage, then at 15 explodes inside the target, dealing 35% of the counted damage
/datum/component/cluster_stack
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	/// Count of how many cluster rounds are in the current stack.
	var/cluster_stacks = 0
	/// Counter of how much damage each cluster round did, 30% of which will be given to the target of apply_cluster_stacks()
	var/damage_counter = 0
	/// Last world.time that the afflicted was hit by a cluster round.
	var/last_stack

/datum/component/cluster_stack/Initialize(cluster_stacks, damage_counter, time)
	. = ..()
	src.cluster_stacks = cluster_stacks
	src.damage_counter = damage_counter
	if(!time)
		time = world.time
	src.last_stack = time

/datum/component/cluster_stack/InheritComponent(datum/component/cluster_stack/C, i_am_original, cluster_stacks, damage, time)
	. = ..()
	if(!C)
		src.cluster_stacks += cluster_stacks
		src.damage_counter += damage
		src.last_stack = time
	else
		src.cluster_stacks += C.cluster_stacks
		src.damage_counter += C.damage_counter
		src.last_stack = C.last_stack

	src.cluster_stacks = min(src.cluster_stacks, MAX_CLUSTER_STACKS)

/datum/component/cluster_stack/process(delta_time)
	if(last_stack + 5 SECONDS < world.time)
		cluster_stacks = cluster_stacks - CLUSTER_STACK_LOSS_PER_SECOND * delta_time

	if(cluster_stacks <= 0)
		qdel(src)

	var/color = COLOR_CLUSTER
	var/intensity = cluster_stacks / MAX_CLUSTER_STACKS
	color += num2text(CLUSTER_MAX_ALPHA * intensity, 2, 16)

	if(parent)
		var/atom/A = parent
		A.add_filter("cluster_stacks", 2, list("type" = "outline", "color" = color, "size" = 1))

/datum/component/cluster_stack/RegisterWithParent()
	START_PROCESSING(SSdcs, src)
	RegisterSignal(parent, list(,
		COMSIG_XENO_BULLET_ACT,
		COMSIG_HUMAN_BULLET_ACT
	), PROC_REF(apply_cluster_stacks))
	RegisterSignal(parent, COMSIG_XENO_APPEND_TO_STAT, PROC_REF(stat_append))

/datum/component/cluster_stack/UnregisterFromParent()
	STOP_PROCESSING(SSdcs, src)
	UnregisterSignal(parent, list(
		COMSIG_HUMAN_BULLET_ACT,
		COMSIG_BULLET_ACT_XENO,
		COMSIG_XENO_APPEND_TO_STAT
	))
	var/atom/A = parent
	A.remove_filter("cluster_stacks")

/datum/component/cluster_stack/proc/stat_append(mob/M, list/L)
	SIGNAL_HANDLER
	L += "Cluster Stack: [cluster_stacks]/[MAX_CLUSTER_STACKS]"

/datum/component/cluster_stack/proc/apply_cluster_stacks(mob/living/L, damage_result, ammo_flags, obj/item/projectile/P)
	SIGNAL_HANDLER
	if(cluster_stacks >= MAX_CLUSTER_STACKS)
		var/old_dmg_cont = damage_counter
		//playsound("whoom")
		cluster_stacks = 0
		damage_counter = 0
		to_chat(L, SPAN_DANGER("You feel a cluster of explosions inside your body!"))
		L.visible_message(SPAN_DANGER("You hear an explosion from the insides of [L]!"))
		L.apply_armoured_damage(old_dmg_cont * 0.3, ARMOR_BOMB, BRUTE)
		var/datum/cause_data/cause_data = create_cause_data("cluster explosion", P.firer)
		INVOKE_ASYNC(GLOBAL_PROC, TYPE_PROC_REF(/atom, cell_explosion), get_turf(L), 50, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, P.dir, cause_data)


#undef COLOR_CLUSTER
#undef CLUSTER_MAX_ALPHA
#undef MAX_CLUSTER_STACKS
#undef CLUSTER_STACK_LOSS_PER_SECOND
