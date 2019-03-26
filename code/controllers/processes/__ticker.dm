datum/controller/process/var/own_data
datum/controller/process/ticker

datum/controller/process/ticker/setup()
	name = "Ticker"
	schedule_interval = 5 //0.5 seconds

	if(!ticker)
		ticker = new /datum/controller/gameticker()
		own_data = ticker

	spawn(1)
		ticker.pregame()

datum/controller/process/ticker/doWork()
	ticker.process()
	individual_ticks++