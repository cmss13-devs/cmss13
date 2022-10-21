var/global/client_count = 0

/world/New()
	..()
	TgsNew()
	TgsInitializationComplete()

/world/Reboot()
	TgsReboot()
	..()

/world/Topic()
	TGS_TOPIC
	..()

/client/New()
	..()
	++global.client_count

/client/Del()
	..()
	--global.client_count