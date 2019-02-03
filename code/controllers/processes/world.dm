datum/controller/process/world

datum/controller/process/world/setup()
	name = "World"
	schedule_interval = 23 //2.3 seconds

	populate_spawn_points()

	setup_economy()

	lighting_controller.Initialize()

datum/controller/process/world/doWork()

	TrashAuthority.EmptyTrash()
	vote.process()