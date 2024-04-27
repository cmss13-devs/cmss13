SUBSYSTEM_DEF(techtree)
	name = "Tech Tree"
	init_order = SS_INIT_TECHTREE

	flags = NO_FLAGS

	wait = 1 MINUTES

	var/list/datum/tech/techs = list()
	var/list/datum/techtree/trees = list()

	var/list/obj/structure/resource_node/resources = list()

/datum/controller/subsystem/techtree/Initialize()
	if(GLOB.perf_flags & PERF_TOGGLE_TECHWEBS)
		return SS_INIT_NO_NEED

	var/list/tech_trees = subtypesof(/datum/techtree)
	var/list/tech_nodes = subtypesof(/datum/tech)

	if(!length(tech_trees))
		log_admin(SPAN_DANGER("Error setting up tech trees, no datums found."))
	if(!length(tech_nodes))
		log_admin(SPAN_DANGER("Error setting up tech nodes, no datums found."))

	for(var/T in tech_trees)
		var/datum/techtree/tree = T
		if(initial(tree.flags) == NO_FLAGS)
			continue
		tree = new T()

		trees += list("[tree.name]" = tree)

		var/datum/space_level/zpos = SSmapping.add_new_zlevel(tree.name, list(ZTRAIT_TECHTREE))
		tree.zlevel = zpos

		for(var/tier in tree.tree_tiers)
			tree.unlocked_techs += tier
			tree.all_techs += tier
			tree.unlocked_techs[tier] = list()
			tree.all_techs[tier] = list()

		for(var/N in tech_nodes)
			var/datum/tech/node = N
			if(initial(node.flags) == NO_FLAGS || !(initial(node.tier) in tree.all_techs))
				continue

			node = new N()
			var/tier = node.tier

			if(tree.flags & node.flags)
				tree.all_techs[tier] += list(node.type = node)
				tree.techs_by_type[node.type] = node
				techs += node

				node.tier = tree.tree_tiers[node.tier]
				node.on_tree_insertion(tree)

		tree.generate_tree()
		var/msg = "Loaded [tree.name]!"
		to_chat(world, SPAN_BOLDANNOUNCE("[msg]"))

	return SS_INIT_SUCCESS

/datum/controller/subsystem/techtree/fire()
	for(var/name in trees)
		var/datum/techtree/tree_income = trees[name]
		tree_income.add_points(0.1) // 6 поинов час, 2 поинта до высадки

/datum/controller/subsystem/techtree/proc/activate_passive_nodes()
	for(var/name in trees)
		var/datum/techtree/T = trees[name]

		if(T.passive_node.active)
			continue

		T.passive_node.make_active()

/datum/controller/subsystem/techtree/proc/activate_all_nodes()
	for(var/obj/structure/resource_node/RN in resources)
		if(QDELETED(RN))
			resources.Remove(RN)
			continue

		if(RN.active)
			continue

		RN.make_active()
