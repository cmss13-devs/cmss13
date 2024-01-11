
/proc/generate_templated_fax(show_wy_logo, fax_header, fax_subject, addressed_to, message_body, sent_by, sent_title, sent_department)
	var/datum/asset/asset = get_asset_datum(/datum/asset/simple/paper)

	var/dat = ""
	dat += "<style>"
	dat += "body {"
	dat += "margin:0 auto;"
	dat += "padding:0;"
	dat += "background-image: url('[asset.get_url_mappings()["faxbackground.jpg"]]');"
	dat += "font-family: monospace;"
	dat += "}"

	dat += "#fax-logo {"
	dat += "text-align: center;"
	dat += "}"

	dat += "#fax-logo img {"
	dat += "width:250px;"
	dat += "margin-top: 20px;"
	dat += "margin-bottom: 12px;"
	dat += "opacity: .6;"
	dat += "}"

	dat += "#width-container {"
	dat += "width: 500px;"
	dat += "min-height:500px;"
	dat += "margin:0 auto;"
	dat += "margin-top: 10px;"
	dat += "margin-bottom: 10px;"
	dat += "padding-left: 20px;"
	dat += "padding-right: 20px;"
	dat += "}"

	dat += ".message-header-text p {"
	dat += "text-align: center;"
	dat += "margin: 0;"
	dat += "margin-bottom: 40px;"
	dat += "}"

	dat += "#header-title {"
	dat += "font-size: 17px;"
	dat += "font-weight: 600;"
	dat += "margin-bottom: 7px;"
	dat += "}"

	dat += "#header-subtitle {"
	dat += "font-size: 17px;"
	dat += "}"

	dat += ".message-body-text p {"
	dat += "text-align: left;"
	dat += "font-size: 17px;"
	dat += "}"

	dat += ".message-signature-text p {"
	dat += "text-align:right;"
	dat += "font-size:15px;"
	dat += "margin-bottom: 20px;"
	dat += "}"
	dat += "</style>"

	dat += "<body>"
	dat += "<div id='width-container'>"

	if(show_wy_logo)
		dat += "<div id='fax-logo'>"
		dat += "<img src='[asset.get_url_mappings()["faxwylogo.png"]]' alt='Something fucked!'/>"
		dat += "</div>"

	dat += "<div class='message-header-text'>"
	dat += "<p id='header-title'>[fax_header]</p>"
	dat += "<p id='header-subtitle'>[fax_subject] - [time2text(world.realtime, "DD Month")] [GLOB.game_year]</p>"
	dat += "</div> <!-- /message-header-text -->"

	dat += "<div class='message-body-text'>"

	dat += "<p>[addressed_to],</p>"

	dat += "[message_body]"

	dat += "</div> <!-- /message-body-text -->"

	dat += "<div class='message-signature-text'>"
	dat += "<p>"
	dat += "<em>[sent_by]</em>"
	dat += "<br/>"
	dat += "<em>[sent_title]</em>"
	dat += "<br/>"
	dat += "<em>[sent_department]</em>"
	dat += "<br/>"
	dat += "</p>"
	dat += "</div> <!-- /message-signature-text -->"

	dat += "</div> <!-- /width-container -->"
	dat += "</body>"
	return dat
