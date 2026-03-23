/datum/prefab_document/uacqs/inspection
	var/dat = ""
	var/body = ""
	var/closer = ""

/datum/prefab_document/uacqs/inspection/New()
	var/datum/asset/asset = get_asset_datum(/datum/asset/simple/paper)

	dat += "<body>"
	dat += "<style>"
	dat += "body {"
	dat += "margin:0 auto;"
	dat += "padding:0;"
	dat += "background-image: url('[asset.get_url_mappings()["background_dark_fractal.png"]]');"
	dat += "background-position: center;"
	dat += "background-color: #ffffff;"
	dat += "font-family: 'Courier New';"
	dat += "color: #ffffff;"
	dat += "}"

	dat += "i {"
	dat += "color: #ffffff;"
	dat += "}"

	dat += "p {"
	dat += "color: #ffffff;"
	dat += "}"

	dat += "b {"
	dat += "color: #ffffff;"
	dat += "}"

	dat += "#uscm-fax-logo {"
	dat += "text-align: center;"
	dat += "}"

	dat += "#uscm-fax-logo img {"
	dat += "width: 200px;"
	dat += "margin-top: 5px;"
	dat += "margin-bottom: 0px;"
	dat += "opacity: 0.;"
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
	dat += "}"

	dat += ".header-title {"
	dat += "font-size: 17px;"
	dat += "font-weight: 600;"
	dat += "margin-bottom: 0px;"
	dat += "color: #FF2E2E;"
	dat += "}"

	dat += ".header-subtitle {"
	dat += "font-size: 15px;"
	dat += "text-transform: uppercase;"
	dat += "letter-spacing: 1.5px;"
	dat += "color: #FF2E2E;"
	dat += "margin-top: 4px;"
	dat += "}"

	dat += ".message-body-text {"
	dat += "text-align: left;"
	dat += "font-size: 17px;"
	dat += "margin-bottom: 25px;"
	dat += "}"

	dat += ".message-subdata-text{"
	dat += "font-size: 20px;"
	dat += "text-align: center;"
	dat += "margin-bottom: 20px;"
	dat += "color: #FF0000;"
	dat += "font-family: inherit;"
	dat += "}"

	dat += ".disclaimer{"
	dat += "font-size: 11px;"
	dat += "color: #e49b0f;"
	dat += "}"

	dat += ".subheading{"
	dat += "text-align: center;"
	dat += "margin-top: -10px;"
	dat += "margin-bottom: -10px;"
	dat += "}"

	dat += ".sub-subheading{"
	dat += "text-align: center;"
	dat += "margin-top: -10px;"
	dat += "margin-bottom: -10px;"
	dat += "font-size:12px;"
	dat += "}"

	dat += "</style>"

	dat += "<div id=\"width-container\">"
	dat += "<div id=\"uscm-fax-logo\">"
	dat += "<img src='[asset.get_url_mappings()["logo_uacqs.png"]]' alt=\"UACQS Logo\"/>"
	dat += "</div>"

	dat += "<!--Header Info here-->"
	dat += "<div class=\"message-header-text\">"
	dat += "<hr style=\"margin-top:5px; margin-bottom:15px;\">"
	dat += "<p class=\"header-title\">DEPARTMENTAL INSPECTION</p>"
	body += "<p class=\"header-subtitle\">QS101</p>"
	body += "<hr style=\"margin-top:5px; margin-bottom:15px;\">"
	body += "</div> <!-- /Heasder Info -->"


	body += "<div class=\"message-body-text\">"
	body += "<b>Date:</b> <font face=\"Times New Roman\"><i>[time2text(REALTIMEOFDAY, "Day DD Month [GLOB.game_year]")]</i></font><br>"
	body += "<b>Subject Facility:</b> <span class=\"paper_field\"></span>"
	body += "<br>"
	body += "<b>Subject Department:</b> <span class=\"paper_field\"></span>"
	body += "<br><br>"
	body += "<b>Reason for Inspection:</b><br><span class=\"paper_field\"></span>"
	body += "<br>"
	body += "<hr style=\"margin-top:15px; margin-bottom:15px;\">"
	body += "<b>Cleanliness:</b> <span class=\"paper_field\"></span><br><span class=\"paper_field\"></span>"
	body += "<br><br>"
	body += "<b>Safety Compliance:</b> <span class=\"paper_field\"></span><br><span class=\"paper_field\"></span>"
	body += "<br><br>"
	body += "<b>Functional Capability:</b> <span class=\"paper_field\"></span><br><span class=\"paper_field\"></span>"
	body += "<br>"
	body += "<hr style=\"margin-top:5px; margin-bottom:15px;\">"
	body += "<b>Additional Notes:</b><br><span class=\"paper_field\"></span>"
	body += "<br><br>"
	body += "<b>Overall Grading:</b> <span class=\"paper_field\"></span>"
	body += "<br><br>"
	body += "<b>Inspector's signature:</b><br><span class=\"paper_field\"></span>"

	closer += "</div> <!-- /message-body-text -->"
	closer += "</div> <!-- /width-container -->"
	closer += "</body >"

	contents = dat
	contents += body
	contents += closer



/datum/prefab_document/uacqs/inspection/example/New()
	..()
	body = ""
	body += "<p class=\"header-subtitle\">QS101E</p>"
	body += "<p class=\"header-subtitle\">EXAMPLE DOCUMENT</p>"
	body += "<hr style=\"margin-top:5px; margin-bottom:15px;\">"
	body += "</div> <!-- /Heasder Info -->"

	body += "<div class=\"message-body-text\">"
	body += "<b>Date:</b> <font face=\"Times New Roman\"><i>[time2text(REALTIMEOFDAY, "Day DD Month [GLOB.game_year]")]</i></font><br>"
	body += "<b>Subject Facility:</b> <font face=\"Courier New\" color=white>Merian Tower</font>"
	body += "<br>"
	body += "<b>Subject Department:</b> <font face=\"Courier New\" color=white>Filing Archive</font>"
	body += "<br><br>"
	body += "<b>Reason for Inspection:</b><br><font face=\"Courier New\" color=white>Annual Standards Review</font>"
	body += "<br>"
	body += "<hr style=\"margin-top:15px; margin-bottom:15px;\">"
	body += "<b>Cleanliness:</b> <font face=\"Courier New\" color=red>POOR</font><br><font face=\"Courier New\" color=white>There was a mess everywhere.</font>"
	body += "<br><br>"
	body += "<b>Safety Compliance:</b> <font face=\"Courier New\" color=orange>ADEQUATE</font><br><font face=\"Courier New\" color=white>Minimum standards were met, but nothing exemplary.</font>"
	body += "<br><br>"
	body += "<b>Functional Capability:</b> <font face=\"Courier New\" color=orange>ADEQUATE</font><br><font face=\"Courier New\" color=white>Everything is functional, though efficiency has some room for improvement.</font>"
	body += "<br>"
	body += "<hr style=\"margin-top:5px; margin-bottom:15px;\">"
	body += "<b>Additional Notes:</b><br><span class=\"sealed_paper_field\"></span>"
	body += "<br><br>"
	body += "<b>Overall Grading:</b> <font face=\"Courier New\" color=orange>MARGINAL</font>"
	body += "<br><br>"
	body += "<b>Inspector's signature:</b><br><span class=\"sealed_paper_field\"></span>"

	contents = dat
	contents += body
	contents += closer
