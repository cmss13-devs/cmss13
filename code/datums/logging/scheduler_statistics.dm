
/proc/log_scheduler()
	if(!round_scheduler_stats)
		return
	var/dat = "[worldtime2text(world.time)]\n"
	for (var/list/data in processScheduler.getStatusData())
		//Comma separated variables
		dat += "[data["name"]]"
		dat += ",[num2text(data["averageRunTime"]/10,3)]"
		dat += ",[num2text(data["lastRunTime"]/10,3)]"
		dat += ",[num2text(data["highestRunTime"]/10,3)]"
		dat += ",[num2text(data["ticks"],4)]"
		dat += ",[data["schedule"]]\n"
	dat += "world.cpu,[world.cpu]\n"
	dat += "[log_end]"
	round_scheduler_stats << dat