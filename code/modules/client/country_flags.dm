/client/New()
	. = ..()
	if(CONFIG_GET(flag/ooc_country_flags))
		spawn if(src)
			ip2country(address, src)

/proc/ip2country(ipaddr, client/origin)
	if(!origin || origin?.country)
		return //null source, or already has a flag

	var/list/http_response[] = world.Export("http://ip-api.com/json/[ipaddr]")
	if(http_response) //check for a response
		var/page_content = http_response["CONTENT"]
		if(page_content)
			var/list/geodata = json_decode(html_decode(file2text(page_content)))
			if(geodata["countryCode"] == "GB")
				if((geodata["regionName"] == "Scotland") || (geodata["regionName"] == "Wales"))
					origin?.country = geodata["regionName"]
					return geodata["regionName"]
				else
					origin?.country = geodata["countryCode"]
					return geodata["countryCode"]
			else
				origin?.country = geodata["countryCode"]
				return geodata["countryCode"]
	else //null response, ratelimited most likely. Try again in 60s
		addtimer(CALLBACK(GLOBAL_PROC, /proc/ip2country, ipaddr, origin), 60 SECONDS)

var/list/countries = icon_states('icons/flags.dmi')

/proc/country2chaticon(country_code, var/targets)
	if(countries.Find(country_code))
		return "[icon2html('icons/flags.dmi', targets, country_code)]"
	else
		return "[icon2html('icons/flags.dmi', targets, "unknown")]"
