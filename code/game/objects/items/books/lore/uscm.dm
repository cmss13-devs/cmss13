/obj/item/lore_book/marine_cryosleep
	name = "USCM post-hypersleep orientation pamphlet"
	desc = "A small USCM pamphlet issued to waking marines as a refresher for temporary hypersleep amnesia. The cover reads: 'Welcome Back, Marine.'"
	icon = 'icons/obj/items/pamphlets.dmi'
	icon_state = "pamphlet_written"
	item_state = "paper"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_righthand.dmi',
	)
	w_class = SIZE_TINY
	pickup_sound = 'sound/handling/paper_pickup.ogg'
	drop_sound = 'sound/handling/paper_drop.ogg'
	book_title = "Welcome Back, Marine"
	book_author = "USCM"
	book_contents = @{"
		<div class="LorePage">
			<p><em>Personnel orientation leaflet 01. Issued following hypersleep.</em></p>
			<h2>Still waking up?</h2>
			<p>
				Head full of fog? Having trouble placing the last few months? Temporary confusion and gaps in memory can follow
				prolonged hypersleep for the inexperienced. Read this leaflet and give yourself a moment. <strong>If you
				cannot remember your own name or the confusion persists, report to medical.</strong>
			</p>
			<h2>Who am I?</h2>
			<p>
				<img src="/logo_uscm.png" alt="USCM insignia" width="42" height="42">
				You are a <strong>United States Colonial Marine</strong>, a member of the <strong>USCM</strong>. Your service
				protects the people, colonies, and interests of the <strong>United Americas (UA)</strong>, the alliance of
				American nations on Earth and their holdings among the stars. Marines come from many worlds and backgrounds.
				What you have in common is the uniform and the chain of command.
			</p>
			<p>
				<img src="/falling_falcons.png" alt="Falling Falcons battalion insignia" width="68" height="68" class="PixelArt">
				You serve under <strong>Marine Space Force Herculis</strong>, the USCM command overseeing the Anglo-Japanese
				Arm and its frontier colonies. Your ship carries the <strong>2nd Company of the 2nd Battalion,
				the "Falling Falcons"</strong>. These marines patrol the Neroid Sector and answer colonial distress calls
				and provide the force for ground operations.
			</p>
		</div>

		<div class="LorePage">
			<h2>Where am I?</h2>
			<p>
				You are aboard the <strong>%SHIP_NAME%</strong>, a military vessel carrying a Colonial Marine force.
				Your patrol area is the <strong>Neroid Sector</strong>, a remote region of the colonial frontier in the
				<strong>Anglo-Japanese Arm</strong>, far from Earth. CLF insurgents threaten the sector's security. The USCM is
				here to protect colonial Settlements and support legitimate authorities.
			</p>
			<h2>What sort of world did I wake up in?</h2>
			<p>
				The year is <strong>%YEAR%</strong>. As of time of writing Humanity has been colonising space for the past
				hundred years, having spread beyond just the Sol System and settling among many star systems.
			</p>
			<p>
				Life on the frontier can be hard. Distant colonies may wait a long time for help. The Marines respond to
				distress calls and deal with trouble local authorities cannot handle alone.
			</p>
		</div>

		<div class="LorePage">
			<h2>Names to remember</h2>
			<p>
				<img src="/logo_wy.png" alt="Weyland-Yutani corporate logo" width="78" height="29">
				<strong>Weyland-Yutani Corporation (W-Y):</strong> Commonly called "the Company" A leading corporation in
				colonization, shipping, industry, and technology, and a valued supplier to the USCM. Company equipment,
				transport, and technical expertise help keep our colonies running and our Marines supplied.
			</p>
			<p>
				<img src="/ua_flag.png" alt="United Americas flag" width="80" height="52" class="PixelArt">
				<strong>United Americas (UA):</strong> This is your flag. The alliance of American nations on Earth and their colonies among the
				stars. The USCM serves the UA and defends its citizens and settlements. It is a close ally of the Three
				World Empire, and supports its security efforts in the Neroid Sector.
			</p>
			<p>
				<img src="/logo_twe.png" alt="Three World Empire emblem" width="64" height="64" class="PixelArt">
				<strong>Three World Empire (TWE/3WE):</strong> A major power led by Britain and Japan, with colonies and armed
				forces of its own. The Neroid Sector is officially 3WE territory. However, due to their relatively low military manpower,
				their allies, the UA, have had to aid them in controlling this sector. Hence the presence of Marine Space Force
				Herculis.
			</p>
			<p>
				<img src="/logo_upp.png" alt="Union of Progressive Peoples emblem" width="64" height="64" class="PixelArt">
				<strong>Union of Progressive Peoples (UPP):</strong> A socialist interstellar power and strategic rival of the
				United Americas. It covers most of Eurasia on Earth. Disputes over territory, colonies, and resources keep
				relations tense. <strong>The UPP is not
				automatically a hostile force.</strong> Observe your rules of engagement and await orders.
			</p>
		</div>

		<div class="LorePage">
			<p>
				<img src="/orientation_clf.png" alt="Colonial Liberation Front emblem" width="84" height="48" class="PixelArt">
				<strong>Colonial Liberation Front (CLF):</strong> A terrorist organization responsible for bombings, piracy,
				sabotage, and the murder of military personnel and colonial civilians. It seeks to drive legitimate colonial
				authorities and the USCM from the frontier. Its campaign of violence threatens the settlements and people we
				protect. <strong>Do not negotiate, provide assistance, or disclose military information to suspected
				insurgents.</strong> Report all suspected CLF activity to your superiors.
			</p>
			<h2>What now?</h2>
			<p>
				Check your assignment, find your squad or department, get equipped, and listen to the briefing. Ask those around you or the <strong>Senior Enlisted Advisor</strong> if you are unsure about anything. Protect civilians, follow lawful
				orders, and look after the marine beside you.
			</p>
			<p>
				<em>Keep this leaflet until your memory catches up. Welcome back to the Corps.</em>
			</p>
		</div>
	"}

/obj/item/lore_book/marine_cryosleep/Initialize()
	. = ..()
	book_contents = replacetext(book_contents, "%SHIP_NAME%", MAIN_SHIP_NAME)
	book_contents = replacetext(book_contents, "%YEAR%", "[GLOB.game_year]")
