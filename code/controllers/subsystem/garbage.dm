#define GC_COLLECTIONS_PER_TICK 300 // Was 100.
#define GC_COLLECTION_TIMEOUT (60 SECONDS)
#define GC_FORCE_DEL_PER_TICK 10
//#define GC_DEBUG
//#define GC_FINDREF


var/datum/subsystem/garbage/SSgarbage

/datum/subsystem/garbage
	name          = "Garbage"
	init_order    = SS_INIT_GARBAGE
	wait          = 5 SECONDS
	display_order = SS_DISPLAY_GARBAGE
	priority      = SS_PRIORITY_GARBAGE
	flags         = SS_BACKGROUND | SS_NO_TICK_CHECK | SS_FIRE_IN_LOBBY

	var/list/queue = new
	var/force_hard_deletion = FALSE
	var/gc_count = 0
	var/hard_del_count = 0
	var/list/hard_del_profiling = list()

	var/can_hard_del = FALSE


/datum/subsystem/garbage/New()
	NEW_SS_GLOBAL(SSgarbage)


/datum/subsystem/garbage/stat_entry()
	var/msg = ""
	msg += "Q:[queue.len]|TD:[gc_count]|HD:[hard_del_count]"
	if (force_hard_deletion)
		msg += "|QDEL OFF"

	..(msg)



/datum/subsystem/garbage/fire(resumed = FALSE)
	process()

///////////////////////////////////////////////////////////////






/client/proc/gc_dump_hdl()
	set name = "G: GC Hard Del List"
	set desc = "List types that fail to soft del and are hard del()'d by the GC."
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return

	if(!SSgarbage)
		return

	var/list/L = list()
	for(var/A in SSgarbage.hard_del_profiling)
		L += "<br>[A] = [SSgarbage.hard_del_profiling[A]]"
	if(L.len == 1)
		to_chat(usr, "No garbage collector deletions this round")
		return
	show_browser(usr, jointext(L,""), "Garbage Collector Forced Deletions in This Round", "harddellogs")




/datum/subsystem/garbage/proc/process()
	var/remainingCollectionPerTick = GC_COLLECTIONS_PER_TICK
	var/remainingForceDelPerTick = GC_FORCE_DEL_PER_TICK
	var/collectionTimeScope = world.time - GC_COLLECTION_TIMEOUT

	var/static/count = 0
	if (count) //runtime last run before we could do this.
		queue.Cut(1, count+1)
		count = 0 //so if we runtime on the Cut, we don't try again.


	for(var/refID in queue)
		if(--remainingCollectionPerTick < 0)
			break

		if(!refID)
			count++
			if(MC_TICK_CHECK)
				return
			continue

		var/destroyedAtTime = queue[refID]
		if(destroyedAtTime > collectionTimeScope)
			break

		var/datum/D = locate(refID)
		if(!D || D.disposed != destroyedAtTime) //No ref left, or two objects sharing the same ref coincidentally.
			count++
			gc_count++
			if(MC_TICK_CHECK)
				return
			continue

		// Something's still referring to the qdel'd object. del it.

		if(remainingForceDelPerTick <= 0)
			break
		
		if(world.cpu > 50)
			continue // no time to harddel

		#ifdef GC_FINDREF
		to_chat(world, "picnic! searching [locate(D)]")
		if(istype(D, /atom/movable))
			var/atom/movable/A = D
			testing("GC: Searching references for [A] | [A.type]")
			if(A.loc != null)
				testing("GC: [A] | [A.type] is located in [A.loc] instead of null")
			if(A.contents.len)
				testing("GC: [A] | [A.type] has contents:")
				for(var/atom/B in A.contents)
					testing("[B] | [B.type]")

		var/world_found = 0
		var/datum_found = 0
		var/client_found = 0
		var/global_vars_found = 0
		for(var/datum/R in world) // ATOMS
			world_found += LookForRefs(R, D)
		for(var/datum/R)
			datum_found += LookForRefs(R, D)
		for(var/client/R)
			client_found += LookForRefs(R, D)
		for(var/A in global.vars)
			global_vars_found += LookForListRefs(global.vars[A], D, null, A)
		to_chat(world, "we found in world [world_found]")
		to_chat(world, "we found in datum [datum_found]")
		to_chat(world, "we found in client [client_found]")
		to_chat(world, "we found in global vars [global_vars_found]")
		#endif


		#ifdef GC_DEBUG
		WARNING("gc process force delete [D.type]")
		#endif

		if(hard_del_profiling[D.type])
			hard_del_profiling[D.type]++
		else
			hard_del_profiling[D.type] = 1

		if(can_hard_del)
			del(D)
		gc_count++
		hard_del_count++
		remainingForceDelPerTick--
		
		count++

		if(MC_TICK_CHECK)
			return

	if(count)
		queue.Cut(1,count+1)
		count = 0



/datum/subsystem/garbage/proc/addTrash(const/datum/D)
	if(!D || (istype(D, /atom) && !istype(D, /atom/movable)))
		return

	if(force_hard_deletion)
		del(D)
		hard_del_count++
		gc_count++
		return

	var/refid = "\ref[D]"

	var/gctime = world.time

	D.disposed = gctime

	if(queue[refid])
		queue -= refid // Removing any GC'd previous references so that the current object will be at the end of the list.

	queue[refid] = gctime


#ifdef GC_FINDREF
world/loop_checks = 0
#endif





/*
 * NEVER USE THIS FOR /atom OTHER THAN /atom/movable
 * BASE ATOMS CANNOT BE QDEL'D BECAUSE THEIR LOC IS LOCKED.
 */
/proc/qdel(const/datum/D, ignore_pooling = 0)
	if(isnull(D))
		return
	if(!istype(D))
		del(D)
		return

	if(isnull(SSgarbage))
		del(D)
		return

	if(istype(D, /atom) && !istype(D, /atom/movable))
		if(istype(D, /turf/))
			var/turf/ot = D
			var/gc_hint = ot.Dispose()

			if(gc_hint == GC_HINT_IGNORE)
				return

			if(gc_hint == GC_HINT_DELETE_NOW)
				del(D)

			return
		else
			warning("qdel() passed object of type [D.type]. qdel() cannot handle unmovable atoms.")
			del(D)
			SSgarbage.hard_del_count++
			SSgarbage.gc_count++
			return


	if(D.disposed) //already Dispose()'d
		return

	// Let our friend know they're about to get fucked up.
	var/gc_hint = D.Dispose()
	switch(gc_hint)
		if(GC_HINT_IGNORE)
			return

		if(GC_HINT_IWILLGC)
			D.disposed = world.time
			return

		// Return to the datum pool if the datum wants to be recycled
		if(GC_HINT_RECYCLE)
			if((D.type in masterdatumPool) && !ignore_pooling)
				returnToPool(D)
				return

		// Immediately hard delete the datum if the datum requires it
		if(GC_HINT_DELETE_NOW)
			del(D)
			return

	SSgarbage.addTrash(D)




#ifdef GC_FINDREF
/datum/subsystem/garbage/proc/LookForRefs(var/datum/D, var/datum/targ)
	. = 0
	for(var/V in D.vars)
		if(V == "contents")
			continue
		if(istype(D.vars[V], /datum))
			var/datum/A = D.vars[V]
			if(A == targ)
				testing("GC: [A] | [A.type] referenced by [D] | \ref[D] | [D.type], var [V]")
				. += 1
		else if(islist(D.vars[V]))
			. += LookForListRefs(D.vars[V], targ, D, V)

/datum/subsystem/garbage/proc/LookForListRefs(var/list/L, var/datum/targ, var/datum/D, var/V)
	. = 0
	for(var/F in L)
		if(istype(F, /datum))
			var/datum/A = F
			if(A == targ)
				testing("GC: [A] | [A.type] referenced by [D? "[D] | [D.type]" : "global list"], list [V]")
				. += 1
		if(islist(F))
			. += LookForListRefs(F, targ, D, "[F] in list [V]")
#endif

#ifdef GC_FINDREF
#undef GC_FINDREF
#endif

#ifdef GC_DEBUG
#undef GC_DEBUG
#endif

#undef GC_FORCE_DEL_PER_TICK
#undef GC_COLLECTION_TIMEOUT
#undef GC_COLLECTIONS_PER_TICK
