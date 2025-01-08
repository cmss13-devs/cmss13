GLOBAL_DATUM_INIT(supply_controller_upp, /datum/controller/supply/upp, new())
/obj/structure/machinery/computer/supply/asrs/upp
	name = "UPP Supply ordering console"
	faction = FACTION_UPP
	circuit = /obj/item/circuitboard/computer/ordercomp/upp

/obj/structure/machinery/computer/supply/asrs/upp/Initialize()
	. = ..()
	asrs_name = "General Supply Storage"

/obj/structure/machinery/computer/supply/upp
	name = "UPP supply console"
	desc = "A console for the General Supply Storage"
	circuit = /obj/item/circuitboard/computer/supplycomp/upp
	faction = FACTION_UPP

/obj/structure/machinery/computer/supply/upp/Initialize()
	. = ..()
	asrs_name = "General Supply Storage"

/obj/item/paper/manifest/upp
	name = "UPP Supply Manifest"

/obj/structure/machinery/computer/supply/asrs/upp/attack_hand(mob/user as mob) //does not return when on non alamyer z level
	if(!allowed(user))
		to_chat(user, SPAN_DANGER("Access Denied."))
		return

	if(..())
		return

	tgui_interact(user)

/obj/item/paper/manifest/upp/generate_contents()
	info = "   \
		<style>    \
			#container { width: 500px; min-height: 500px; margin: 25px auto;  \
					font-family: monospace; padding: 0; font-size: 130% }  \
			#title { font-size: 250%; letter-spacing: 8px; \
					font-weight: bolder; margin: 20px auto }   \
			.header { font-size: 130%; text-align: center; }   \
			.important { font-variant: small-caps; font-size = 130%;   \
						font-weight: bolder; }    \
			.tablelabel { width: 150px; }  \
			.field { font-style: italic; } \
			li { list-style-type: disc; list-style-position: inside; } \
			table { table-layout: fixed }  \
		</style><div id='container'>   \
		<div class='header'>   \
			<p id='title' class='important'><img src = upplogo.png></p>   \
			<p class='important'>General Supply Storage order</p>    \
			<p class='field'>Order #[ordernum]</p> \
		</div><hr><table>  \
		<colgroup> \
			<col class='tablelabel important'> \
			<col class='field'>    \
		</colgroup>    \
		<tr><td>Shipment:</td> \
		<td>[ordername]</td></tr>  \
		<tr><td>Ordered by:</td>   \
		<td>[orderedby]</td></tr>  \
		<tr><td>Approved by:</td>  \
		<td>[approvedby]</td></tr> \
		<tr><td># packages:</td>   \
		<td class='field'>[length(packages)]</td></tr> \
		</table><hr><p class='header important'>Contents</p>   \
		<ul class='field'>"

	for(var/packagename in packages)
		info += "<li>[packagename]</li>"

	info += "  \
		</ul><br/><hr><br/><p class='important header'>    \
		<br/> Glory to the UPP<br/>\
			Please stamp below and return to confirm receipt of shipment   \
		</p></div>"

	name = "[name] - [ordername]"


/datum/controller/supply/upp
	manifest_to_print = /obj/item/paper/manifest/upp
	points = 120
	all_supply_groups = list(
		"UPP Weapons",
		"UPP Ammo",
		"UPP Special Weapon",
		"UPP Special Ammo",
		"UPP Attachments",
		"UPP Medical",
		"UPP Engineering",
		"UPP Food",
		"UPP Gear",
		"UPP Explosives",
		"UPP Clothing",
		"UPP Mortar",
		"UPP Additional supplies"
	)
	//No black market under communism
	contraband_supply_groups = list()

//No random crates for UPP
/datum/controller/supply/upp/process(delta_time)
	points += points_per_process
