datum/controller/process/turfs

datum/controller/process/turfs/setup()
	name = "Turfs"
	schedule_interval = 5 //0.5 seconds
	own_data = processing_turfs

datum/controller/process/turfs/doWork()

	if(processing_turfs.len)
		for(var/turf/T in processing_turfs)
			T.process()
			individual_ticks++
