// What in the name of god is this?
// You'd think it'd be some form of process for the HTML interface module.
// But it isn't?
// It's some form of proc queue but ???
// Does anything even *use* this?

SUBSYSTEM_DEF(html_ui)
	name = "HTMLUI"
	wait = 1.7 SECONDS
	flags = SS_NO_INIT
	runlevels = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY
	var/list/update = list()

/datum/controller/subsystem/html_ui/fire(resumed = FALSE)
	if (update.len)
		var/list/L = list()
		var/key

		for (var/datum/procqueue_item/item in update)
			key = "[item.ref]_[item.procname]"

			if (item.args)
				key += "("
				var/first = 1
				for (var/a in item.args)
					if (!first)
						key += ","
					key += "[a]"
					first = 0
				key += ")"

			if (!(key in L))
				if (item.args)
					call(item.ref, item.procname)(arglist(item.args))
				else
					call(item.ref, item.procname)()

				L.Add(key)

		update.Cut()


/datum/controller/subsystem/html_ui/proc/queue(ref, procname, ...)
	var/datum/procqueue_item/item = new
	item.ref = ref
	item.procname = procname

	if (args.len > 2)
		item.args = args.Copy(3)

	update.Insert(1, item)


/datum/procqueue_item
	var/ref
	var/procname
	var/list/args
