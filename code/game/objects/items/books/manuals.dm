
//*********************MANUALS (BOOKS)***********************/

//Oh god what the fuck I am not good at computer
/obj/item/book/manual
	/// Game time in 1/10th seconds
	due_date = 0
	/// 0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified
	unique = 1


//Engineering related manuals

/obj/item/book/manual/engineering_guide
	name = "Tools, Radiowaves And Electrical Grids"
	desc = "A book containing basic and yet important information regarding engineering procedures."
	icon_state = "book_engineering"
	item_state = "book_engineering"
	author = "Colonial Marines Engineer Association"
	title = "Tools, Radiowaves And Electrical Grids"

	dat = {"

		<html><head>
		</head>

		<body>
		<iframe style="width:100%; height:85vh;" src="https://cm-ss13.com/wiki/Guide_to_Engineering" frameborder="0" id="main_frame"></iframe> </body>

		</html>

		"}


/obj/item/book/manual/engineering_construction
	name = "Construction Destruction"
	desc = "A detailed guide containing a series of diagrams and tables regarding the required resources and proper procedures to building, from barricades to floor tiles."
	icon_state = "book_engineering"
	item_state = "book_engineering"
	author = "Colonial Marines Engineer Association"
	title = "Construction Destruction: The guide"

	dat = {"

		<html><head>
		</head>

		<body>
		<iframe style="width:100%; height:85vh;" src="https://cm-ss13.com/wiki/Guide_to_construction" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}


/obj/item/book/manual/engineering_hacking
	name = "Hack-A-Mole: How Electrical Components Work"
	desc = "A guide specialized on the knowledge of 'hacking', being that of airlocks, vending machines, or anything else that your multi tool is capable of messing with."
	icon_state = "book_hacking"
	item_state = "book_hacking"
	author = "Colonial Marines Engineer Association"
	title = "Hack-A-Mole: How Electrical Components Work"

	dat = {"

		<html><head>
		</head>

		<body>
		<iframe style="width:100%; height:85vh;" src="https://cm-ss13.com/wiki/Guide_to_Engineering#Hacking" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}

/obj/item/book/manual/ordnance
	name = "Ordnance for Recruits or: How I Learned to Stop Worrying and Love the Maxcap"
	desc = "A manual containing absurdly detailed information regarding the production, assembly, and handling of all kinds of explosive devices."
	icon_state = "book_engineering2"
	item_state = "book_engineering2"
	author = "Colonial Marines Engineer Association"
	title = "Ordnance for Recruits or: How I Learned to Stop Worrying and Love the Maxcap"

	dat = {"

		<html><head>
		</head>

		<body>
		<iframe style="width:100%; height:85vh;" src="https://cm-ss13.com/wiki/Ordnance_Technician" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}

/obj/item/book/manual/comms
	name = "Subspace Telecommunications And You"
	desc = "An instructions manual regarding the use of communication channels and advice on how to be properly heard over the radiowaves while speaking all kinds of languages."
	icon_state = "book_particle"
	item_state = "book_particle"
	author = "Colonial Marines Engineer Association"
	title = "Subspace Telecommunications And You"

	dat = {"

		<html><head>
		</head>

		<body>
		<iframe style="width:100%; height:85vh;" src="https://cm-ss13.com/wiki/Comms" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}

/obj/item/book/manual/reactor
	name = "How to React: Steps to maintain a S-52 Fusion Reactor"
	desc = "A manual containing information on how to maintain S-52 Fusion Ship Reactors, very popular engines among space vessels."
	icon_state = "book_supermatter"
	item_state = "book_supermatter"
	author = "Colonial Marines Engineer Association"
	title = "How to React: Steps to maintain a S-52 Fusion Reactor"

	dat = {"

		<html><head>
		</head>

		<body>
		<iframe style="width:100%; height:85vh;" src="https://cm-ss13.com/wiki/S-52_Fusion_Reactor" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}


/obj/item/book/manual/orbital_cannon_manual
	name = "USCM Orbital Bombardment System Manual"
	desc = "This book contains instructions on how to operate a standard-issue United States Colonial Marines Orbital Artillery Cannon."
	icon_state = "book_engineering2"
	item_state = "book_engineering2"
	author = "Colonial Marines Engineer Association"
	title = "USCM Orbital Bombardment System Manual"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 18px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Guide to the USCM Orbital Bombardment System</h1>

				<h2>Step by step instructions:</h2>
				<ol>
					<li>Load a warhead in the Orbital Cannon Tray (Powerloader required).</li>
					<li>Load the required amount of solid fuel in the Orbital Cannon Tray <b>(See Orbital Cannon Console)</b>.</li>
					<li>Open the Orbital Cannon Console's interface.</li>
					<li>Load the Tray into the Cannon.</li>
					<li>Chamber the Tray's content into the cannon barrel. <b>(can't be undone!)</b></li>
					<li>The CIC staff can now fire the Orbital Cannon from any overwatch console.</li>
					<li>After firing, unload the Tray from the Orbital Cannon.</li>
					<li>Inspect the Tray to make sure it is empty and operational.</li>
				</ol>

				<h2>Troubleshooting:</h2>

				<ul>
					<li>If you've loaded a tray with an incorrect payload, you can still unload the tray's payload as long as it hasn't been chambered.</li>
					<li>If an incorrect payload is chambered, it can only be removed by firing it.</li>
					<li>If the Orbital Cannon Console has no power, check the Weapon Control Room's APC.</li>
					<li>If the Orbital Cannon Console is broken, contact USCM HQ for a replacement.</li>
					<li>In case of direct damage to the Orbital Cannon itself, do not attempt to use or repair the cannon.</li>
					<li>In case of hull breach or fire, make sure to remove the Cannon's payload and move it to a safe location.</li>
					<li>If the Orbital Tray jams, apply lubricant to the conveyor belt.</li>
					<li>If a cable of the Orbital Cannon System is severed, contact USCM HQ for a replacement.</li>
					<li>If the Cannon's cable connector breaks, turn off the Orbital Cannon Console and contact USCM HQ for a replacement.</li>
				</ul>

			</body>
			</html>
			"}


/obj/item/book/manual/ripley_build_and_repair
	name = "APLU \"Ripley\" Construction and Operation Manual"
	icon_state = "book_borg"
	item_state = "book_borg"
	author = "Senior Mechanic Harry Snow, Weyland-Yutani Corporation"
	title = "APLU \"Ripley\" Construction and Operation Manual"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ul.a {list-style-type: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<center>
				<br>
				<b style='font-size: 12px;'>Weyland-Yutani - Building Better Worlds</b>
				<h1>Autonomous Power Loader Unit \"Ripley\"</h1>
				</center>
				<h2>Specifications:</h2>
				<ul class="a">
				<li><b>Class:</b> Autonomous Power Loader</li>
				<li><b>Scope:</b> Logistics and Construction</li>
				<li><b>Weight:</b> 820kg (without operator and with empty cargo compartment)</li>
				<li><b>Height:</b> 2.5m</li>
				<li><b>Width:</b> 1.8m</li>
				<li><b>Top speed:</b> 5km/hour</li>
				<li><b>Operation in vacuum/hostile environment:</b> Possible</b>
				<li><b>Airtank volume:</b> 500 liters</li>
				<li><b>Devices:</b>
					<ul class="a">
					<li>Hydraulic clamp</li>
					<li>High-speed drill</li>
					</ul>
				</li>
				<li><b>Propulsion device:</b> Powercell-powered electro-hydraulic system</li>
				<li><b>Powercell capacity:</b> Varies</li>
				</ul>

				<h2>Construction:</h2>
				<ol>
					<li>Connect all exosuit parts to the chassis frame.</li>
					<li>Connect all hydraulic fittings and tighten them up with a wrench.</li>
					<li>Adjust the servohydraulics with a screwdriver.</li>
					<li>Wire the chassis (Cable is not included).</li>
					<li>Use the wirecutters to remove the excess cable if needed.</li>
					<li>Install the central control module (Not included. Use supplied datadisk to create one).</li>
					<li>Secure the mainboard with a screwdriver.</li>
					<li>Install the peripherals control module (Not included. Use supplied datadisk to create one).</li>
					<li>Secure the peripherals control module with a screwdriver.</li>
					<li>Install the internal armor plating (Not included due to Weyland-Yutani regulations. Can be made using 5 metal sheets).</li>
					<li>Secure the internal armor plating with a wrench.</li>
					<li>Weld the internal armor plating to the chassis.</li>
					<li>Install the external reinforced armor plating (Not included due to Weyland-Yutani regulations. Can be made using 5 reinforced metal sheets).</li>
					<li>Secure the external reinforced armor plating with a wrench.</li>
					<li>Weld the external reinforced armor plating to the chassis.</li>
				</ol>

				<h2>Additional Information:</h2>
				<ul>
					<li>The firefighting variation is made in a similar fashion.</li>
					<li>A firesuit must be connected to the firefighter chassis for heat shielding.</li>
					<li>Internal armor is plasteel for additional strength.</li>
					<li>External armor must be installed in 2 parts, totalling 10 sheets.</li>
					<li>Completed mech is more resilient against fire, and is a bit more durable overall.</li>
					<li>Weyland-Yutani is determined to ensure the safety of its <s>investments</s> employees.</li>
				</ul>
				</body>
			</html>
			"}


/obj/item/book/manual/atmospipes
	name = "Pipes and You: Getting To Know Your Scary Tools"
	icon_state = "book_piping"
	item_state = "book_piping"
	author = "Colonial Marines Engineer Association"
	title = "Pipes and You: Getting To Know Your Scary Tools"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1><a name="Contents">Contents</a></h1>
				<ol>
					<li><a href="#Foreword">Author's Foreword</a></li>
					<li><a href="#Basic">Basic Piping</a></li>
					<li><a href="#Insulated">Insulated Pipes</a></li>
					<li><a href="#Devices">Atmospherics Devices</a></li>
					<li><a href="#HES">Heat Exchange Systems</a></li>
					<li><a href="#Final">Final Checks</a></li>
				</ol><br>

				<h1><a name="Foreword"><U><B>HOW TO NOT SUCK QUITE SO HARD AT ATMOSPHERICS</B></U></a></h1><BR>
				<I>Or: What the fuck does a "passive gate" do?</I><BR><BR>

				Alright. It has come to my attention that a variety of people are unsure of what a "pipe" is and what it does.
				Apparently, there is an unnatural fear of these arcane devices and their "gases." Spooky, spooky. So,
				this will tell you what every device constructable by an ordinary pipe dispenser within atmospherics actually does.
				You are not going to learn what to do with them to be the super best person ever, or how to play guitar with passive gates,
				or something like that. Just what stuff does.<BR><BR>


				<h1><a name="Basic"><B>Basic Pipes</B></a></h1>
				<I>The boring ones.</I><BR>
				Most ordinary pipes are pretty straightforward. They hold gas. If gas is moving in a direction for some reason, gas will flow in that direction.
				That's about it. Even so, here's all of your wonderful pipe options.<BR>

				<ul>
				<li><b>Straight pipes:</b> They're pipes. One-meter sections. Straight line. Pretty simple. Just about every pipe and device is based around this
				standard one-meter size, so most things will take up as much space as one of these.</li>
				<li><b>Bent pipes:</b> Pipes with a 90 degree bend at the half-meter mark. My goodness.</li>
				<li><b>Pipe manifolds:</b> Pipes that are essentially a "T" shape, allowing you to connect three things at one point.</li>
				<li><b>4-way manifold:</b> A four-way junction.</li>
				<li><b>Pipe cap:</b> Caps off the end of a pipe. Open ends don't actually vent air, because of the way the pipes are assembled, so, uh, use them to decorate your house or something.</li>
				<li><b>Manual valve:</b> A valve that will block off airflow when turned. Can't be used by the AI or cyborgs, because they don't have hands.</li>
				<li><b>Manual T-valve:</b> Like a manual valve, but at the center of a manifold instead of a straight pipe.</li><BR><BR>
				</ul>

				<h1><a name="Insulated"><B>Insulated Pipes</B></a></h1>
				<li><I>Bent pipes:</I> Pipes with a 90 degree bend at the half-meter mark. My goodness.</li>
				<li><I>Pipe manifolds:</I> Pipes that are essentially a "T" shape, allowing you to connect three things at one point.</li>
				<li><I>4-way manifold:</I> A four-way junction.</li>
				<li><I>Pipe cap:</I> Caps off the end of a pipe. Open ends don't actually vent air, because of the way the pipes are assembled, so, uh. Use them to decorate your house or something.</li>
				<li><I>Manual Valve:</I> A valve that will block off airflow when turned. Can't be used by the AI or cyborgs, because they don't have hands.</li>
				<li><I>Manual T-Valve:</I> Like a manual valve, but at the center of a manifold instead of a straight pipe.</li><BR><BR>

				<h1><a name="Insulated"><B>Insulated Pipes</B></a></h1><BR>
				<I>Special Public Service Announcement.</I><BR>
				Our regular pipes are already insulated. These are completely worthless. Punch anyone who uses them.<BR><BR>

				<h1><a name="Devices"><B>Devices: </B></a></h1>
				<I>They actually do something.</I><BR>
				This is usually where people get frightened, afraid, and start calling on their gods and/or cowering in fear. Yes, I can see you doing that right now.
				Stop it. It's unbecoming. Most of these are fairly straightforward.<BR>

				<ul>
				<li><b>Gas pump:</b> Take a wild guess. It moves gas in the direction it's pointing (marked by the red line on one end). It moves it based on pressure, the maximum output being 4500 kPa (kilopascals).
				Ordinary atmospheric pressure, for comparison, is 101.3 kPa, and the minimum pressure of room-temperature pure oxygen needed to not suffocate in a matter of minutes is 16 kPa
				(though 18 kPa is preferred using internals, for various reasons).</li>
				<li><b>Volume pump:</b> This pump goes based on volume, instead of pressure, and the possible maximum pressure it can create in the pipe on the receiving end is double the gas pump because of this,
				clocking in at an incredible 9000 kPa. If a pipe with this is destroyed or damaged, and this pressure of gas escapes, it can be incredibly dangerous depending on the size of the pipe filled.
				Don't hook this to the distribution loop, or you will make babies cry and the Chief Engineer brutally beat you.</li>
				<li><b>Passive gate:</b> This is essentially a cap on the pressure of gas allowed to flow in a specific direction.
				When turned on, instead of actively pumping gas, it measures the pressure flowing through it, and whatever pressure you set is the maximum: it'll cap after that.
				In addition, it only lets gas flow one way. The direction the gas flows is opposite the red handle on it, which is confusing to people used to the red stripe on pumps pointing the way.</li>
				<li><b>Unary vent:</b> The basic vent used in rooms. It pumps gas into the room, but can't suck it back out. Controlled by the room's air alarm system.</li>
				<li><b>Scrubber:</b> The other half of room equipment. Filters air, and can suck it in entirely in what's called a "panic siphon." Activating a panic siphon without very good reason will kill someone. Don't do it.</li>
				<li><b>Meter:</b> A little box with some gauges and numbers. Fasten it to any pipe or manifold and it'll read you the pressure in it. Very useful.</li>
				<li><b>Gas mixer:</b> Two sides are input, one side is output. Mixes the gases pumped into it at the ratio defined. The side perpendicular to the other two is "node 2," for reference.
				Can output this gas at pressures from 0-4500 kPa.</li>
				<li><b>Gas filter:</b> Essentially the opposite of a gas mixer. One side is input. The other two sides are output. One gas type will be filtered into the perpendicular output pipe,
				the rest will continue out the other side. Can also output from 0-4500 kPa.</li>
				</ul>

				<h1><a name="HES"><B>Heat Exchange Systems</B></a></h1>
				<I>Will not set you on fire.</I><BR>
				These systems are used to only transfer heat between two pipes. They will not move gases or any other element, but will equalize the temperature (eventually). Note that because of how gases work (remember: pv=nRt),
				a higher temperature will raise pressure, and a lower one will lower temperature.<BR>

				<li><I>Pipe:</I> This is a pipe that will exchange heat with the surrounding atmosphere. Place in fire for superheating. Place in space for supercooling.</li>
				<li><I>Bent pipe:</I> Take a wild guess.</li>
				<li><I>Junction:</I> The point where you connect your normal pipes to heat exchange pipes. Not necessary for heat exchangers, but necessary for H/E pipes/bent pipes.</li>
				<li><I>Heat exchanger:</I> These funky-looking bits attach to an open pipe end. Put another heat exchanger directly across from it, and you can transfer heat across two pipes without having to have the gases touch.
				This normally shouldn't exchange with the ambient air, despite being totally exposed. Just don't ask questions...</li><BR>

				That's about it for pipes. Go forth, armed with this knowledge, and try not to break, burn down, or kill anything. Please.

				</body>
			</html>
			"}


/obj/item/book/manual/evaguide
	name = "EVA Gear and You: Not Spending All Day Inside"
	icon_state = "book_eva"
	item_state = "book_eva"
	author = "Senior Technician Sandra Rose, Weyland-Yutani Corporation"
	title = "EVA Gear and You: Not Spending All Day Inside"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1><a name="Foreword">EVA Gear and You: Not Spending All Day Inside</a></h1>
				<I>Or: How not to suffocate because there's a hole in your shoes</I><BR>

				<h2><a name="Contents">Contents</a></h2>
				<ol>
					<li><a href="#Foreword">A foreword on using EVA gear</a></li>
					<li><a href="#Civilian">Donning a Civilian Suit</a></li>
					<li><a href="#Hardsuit">Putting on a Hardsuit</a></li>
					<li><a href="#Final">Final Checks</a></li>
				</ol>
				<br>

				EVA gear. Wonderful to use. It's useful for mining, engineering, and occasionally just surviving, if things are that bad. Most people have EVA training,
				but apparently there are some on a space station who don't. This guide should give you a basic idea of how to use this gear, safely. It's split into two sections:
				Civilian suits and hardsuits.<BR><BR>

				<h2><a name="Civilian">Civilian Suits</a></h2>
				<I>The bulkiest things this side of Alpha Centauri</I><BR>
				These suits are the grey ones that are stored in EVA. They're the more simple to get on, but are also a lot bulkier, and provide less protection from environmental hazards such as radiation or physical impact.
				As Medical, Engineering, Security, and Mining all have hardsuits of their own, these don't see much use, but knowing how to put them on is quite useful anyways.<BR><BR>

				First, take the suit. It should be in three pieces: A top, a bottom, and a helmet. Put the bottom on first, shoes and the like will fit in it. If you have magnetic boots, however,
				put them on on top of the suit's feet. Next, get the top on, as you would a shirt. It can be somewhat awkward putting these pieces on, due to the makeup of the suit,
				but to an extent they will adjust to you. You can then find the snaps and seals around the waist, where the two pieces meet. Fasten these, and double-check their tightness.
				The red indicators around the waist of the lower half will turn green when this is done correctly. Next, put on whatever breathing apparatus you're using, be it a gas mask or a breath mask. Make sure the oxygen tube is fastened into it.
				Put on the helmet now, straightforward, and make sure the tube goes into the small opening specifically for internals. Again, fasten seals around the neck, a small indicator light in the inside of the helmet should go from red to off when all is fastened.
				There is a small slot on the side of the suit where an emergency oxygen tank or extended emergency oxygen tank will fit,
				but it is recommended to have a full-sized tank on your back for EVA.<BR><BR>

				<h2><a name="Hardsuit">Hardsuits</a></h2>
				<I>Heavy, uncomfortable, still the best option.</I><BR>
				These suits come in Engineering, Mining, and the Armory. There's also a couple Medical Hardsuits in EVA. These provide a lot more protection than the standard suits.<BR><BR>

				Similarly to the other suits, these are split into three parts. Fastening the pant and top are mostly the same as the other spacesuits, with the exception that these are a bit heavier,
				though not as bulky. The helmet goes on differently, with the air tube feeding into the suit and out a hole near the left shoulder, while the helmet goes on turned ninety degrees counter-clockwise,
				and then is screwed in for one and a quarter full rotations clockwise, leaving the faceplate directly in front of you. There is a small button on the right side of the helmet that activates the helmet light.
				The tanks that fasten onto the side slot are emergency tanks, as well as full-sized oxygen tanks, leaving your back free for a backpack or satchel.<BR><BR>

				<h2><a name="Final">Final Checks</a></h2>
				<ul>
					<li>Are all seals fastened correctly?</li>
					<li>Do you either have shoes on under the suit, or magnetic boots on over it?</li>
					<li>Do you have a mask on and internals on the suit or your back?</li>
					<li>Do you have a way to communicate with the station in case something goes wrong?</li>
					<li>Do you have a second person watching if this is a training session?</li><BR>
				</ul>

				If you don't have any further issues, go out and do whatever is necessary.

				</body>
			</html>
			"}


//Law related manuals


/obj/item/book/manual/security_space_law
	name = "Standard Operating Procedure"
	desc = "One of the most important books onboard any United States Colonial Marines vessel, or at least that's how you are supposed to feel about it. The book carries within it's pages the USCM guidelines and procedures regarding all kinds of situations."
	icon_state = "book_sop"
	item_state = "book_sop"
	author = "Colonial Marines High Command"
	title = "Standard Operating Procedure"

	dat = {"

		<html><head>
		</head>

		<body>
		<iframe style="width:100%; height:85vh;" src="https://cm-ss13.com/wiki/Standard_Operating_Procedure" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}


/obj/item/book/manual/marine_law
	name = "Marine Law"
	desc = "Usually being the favorite read of any member of the Military Police of the USCM, it's whole meaning is to work as the scales for the sword of justice that brandishes onboard the vessels of the United States Colonial Marines, so peace and order can be maintained. It's nicknames may include but are not limited to: Devil's Red Book, Bible of All Sinners, THE Book, ML, Red Brick, Provost's Torture Manual, Provost's Red Devil's Torture Bible of All Sinners."
	icon_state = "book_marine_law"
	item_state = "book_marine_law"
	author = "Colonial Marines Provost Office"
	title = "Marine Law"

	dat = {"

		<html><head>
		</head>

		<body>
		<iframe style="width:100%; height:85vh;" src="http://cm-ss13.com/wiki/Marine_Law" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}


//Medical and Research related manuals


/obj/item/book/manual/surgery
	name = "Surgical Reference Manual"
	desc = "A detailed reference manual for surgical procedures. To be read mid-surgery when you forget a simple surgical step."
	icon_state = "book_medical"
	item_state = "book_medical"
	author = "Colonial Marines Bureau of Medicine and Surgery"
	title = "Surgical Reference Manual"

	dat = {"

		<html><head>
		</head>

		<body>
		<iframe style="width:100%; height:85vh;" src="https://cm-ss13.com/wiki/Surgery" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}


/obj/item/book/manual/medical_diagnostics_manual
	name = "Principles and Practice of Medicine"
	desc = "Firstly and foremost, do no harm. A detailed, thick and heavy medical practitioner's guide, with the first five full pages only being the book's dedication."
	icon_state = "book_medical"
	item_state = "book_medical"
	author = "Chief Medical Officer Pierre Corbeau, Colonial Marines Bureau of Medicine and Surgery"
	title = "Principles and Practice of Medicine"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<br>
				<h1>The Oath</h1>

				<i>Below, the Medical Oath sworn by recognised medical practitioners on service everywhere in space, including in the military branches of the United Americas.</i><br>
				<i>Ci-dessous, le serment medical prete par des medecins reconnus en service partout dans l'espace, y compris dans les branches militaires des Ameriques unies.</i><br>

				<ol>
					<li>Now, as a practitioner, I solemnly promise that I will, to the best of my ability, serve humanity by caring for the sick, promoting good health, and alleviating pain and suffering.</li>
					<li>I recognise that the practice of medicine is a privilege with which comes considerable responsibility and I will not abuse my position.</li>
					<li>I will practise medicine with integrity, humility, honesty, and compassion-working with my fellow practitioners and other colleagues to meet the needs of my patients.</li>
					<li>I shall never intentionally do or administer anything to the overall harm of my patients.</li>
					<li>I will not permit considerations of gender, race, religion, political affiliation, sexual orientation, nationality, or social standing to influence my duty of care.</li>
					<li>I will oppose policies in breach of human rights and will not participate in them. I will strive to change laws that are contrary to my profession's ethics and will work towards a fairer distribution of health resources.</li>
					<li>I will assist my patients to make informed decisions that coincide with their own values and beliefs and will uphold patient confidentiality.</li>
					<li>I will recognise the limits of my knowledge and seek to maintain and increase my understanding and skills throughout my professional life. I will acknowledge and try to remedy my own mistakes and honestly assess and respond to those of others.</li>
					<li>I will seek to promote the advancement of medical knowledge through teaching and research.</li>
					<li>I make this declaration solemnly, freely, and upon my honour.</li>
				</ol><br>

				<HR COLOR="steelblue" WIDTH="60%" ALIGN="LEFT">

				<h3>Main guide</h3>
				<iframe style="width:100%; height:85vh;" src="http://cm-ss13.com/wiki/Guide_to_Medicine" frameborder="0" id="main_frame"></iframe>
				</body>
			</html>

		"}

/obj/item/book/manual/chemistry
	name = "Chemical Reactions and How They Can Ruin Your Day"
	desc = "A detailed manual containing everything you need to know about chemistry. Recipes and methodology included."
	icon_state = "book_chemistry"
	item_state = "book_chemistry"
	author = "Colonial Marines Bureau of Medicine and Surgery"
	title = "Chemical Reactions and How They Can Ruin Your Day"

	dat = {"

		<html><head>
		</head>

		<body>
		<iframe style="width:100%; height:85vh;" src="https://cm-ss13.com/wiki/Chemistry" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}

/obj/item/book/manual/research_and_development
	name = "Research and Development: What there is to find?"
	desc = "Science: The final frontier. This book contains deeply specialized and educational information regarding research's continuing scientific mission: to explore strange new worlds; to seek out new life, new alloys and new vaccines; to boldly go where no one has researched before!"
	icon_state = "book_research_development"
	item_state = "book_research_development"
	author = "Senior Researcher Glen Brooks, Weyland-Yutani Corporation"
	title = "Research and Development: What there is to find?"

	dat = {"

		<html><head>
		</head>

		<body>
		<iframe style="width:100%; height:85vh;" src="https://cm-ss13.com/wiki/Researcher" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}


//Un-related manuals


/obj/item/book/manual/tychontackle
	name = "After Action Report No.55: Operation Tychon Tackle"
	desc = "An after action report of the infamous Operation 'Tychon Tackle', so big that it had to be turned into a book. Warning: Some information, such as personal names, have been REDACTED on this print."
	icon_state = "book_light_red"
	item_state = "book_light_red"
	author = "Executive Officer 'REDACTED', USS Heyst, United Americas"
	title = "After Action Report No.55: Operation Tychon Tackle"

	dat = {"

		<html><head>
		</head><body class='Paper'

		<body>
		<iframe style="width:100%; height:85vh;" src="https://cm-ss13.com/wiki/After_Action_Report_No.55" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}


/obj/item/book/manual/upphistory
	name = "The Raise And Steadying of the Union of Progressive Peoples, By Robert Mendes"
	desc = "A large, supposedly unbiased history book containing what's supposed to be the history of the so-called UPP."
	icon_state = "book_upp"
	item_state = "book_upp"
	author = "Historian Robert Mendes, United Americas"
	title = "The Raise And Steadying of the Union of Progressive Peoples, By Robert Mendes"

	dat = {"

		<html><head>
		</head><body class='Paper'

		<body>
		<iframe style="width:100%; height:85vh;" src="https://cm-ss13.com/wiki/UPP" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}


/obj/item/book/manual/paperwork
	name = "Bureaucracy and paperworking: Everything You Need to Know"
	desc = "A book containing all kinds of knowledge and pre-made formularies for the writing of important documents. You need it? This book have it."
	icon_state = "book"
	item_state = "book"
	author = "Colonial Marines High Command"
	title = "Bureaucracy and paperworking: Everything You Need to Know"

	dat = {"

		<html><head>
		</head><body class='Paper'

		<body>
		<iframe style="width:100%; height:85vh;" src="https://cm-ss13.com/wiki/Guide_to_Paperwork" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}

/obj/item/book/manual/rank
	name = "The Marine Ranks: United States Colonial Marines Chain of Command and Ranking"
	desc = "This book contains information regarding all ranks inside the United States Colonial Marines force, and its consequent chain of command."
	icon_state = "book"
	item_state = "book"
	author = "Colonial Marines High Command"
	title = "The Marine Ranks: United States Colonial Marines Chain of Command and Ranking"
	dat = {"

		<html><head>
		</head><body class='Paper'

		<body>
		<iframe style="width:100%; height:85vh;" src="https://cm-ss13.com/wiki/Rank" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}


/obj/item/book/manual/chef_recipes
	name = "Pans and Dishes: Your Way Around the Marine Kitchens"
	desc = "A huge book containing lots and lots of cooking recipes, perfect for those who wish to actually cook and not only stand in front of the microwave, staring at it."
	icon_state = "cooked_book"
	item_state = "cooked_book"
	author = "Food Service Specialist Louis Covenant, United Americas"
	title = "Pans and Dishes: Your Way Around the Marine Kitchens"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Food for New Mess Technicians</h1>
				This guide is directed to our new Food Service Specialists and for those whose memory aren't their strongest suit.

				<h3>Basics:</h3>
				Knead an egg and some flour to make dough. Bake that to make a bun or flatten and cut it.

				<h3>Burger:</h3>
				Put a bun and some meat into the microwave and turn it on. Then wait.

				<h3>Bread:</h3>
				Put some dough and an egg into the microwave and then wait.

				<h3>Waffles:</h3>
				Add two lumps of dough and 10 units of sugar to the microwave and then wait.

				<h3>Popcorn:</h3>
				Add 1 corn to the microwave and wait.

				<h3>Meat Steak:</h3>
				Put a slice of meat, 1 unit of salt, and 1 unit of pepper into the microwave and wait.

				<h3>Meat Pie:</h3>
				Put a flattened piece of dough and some meat into the microwave and wait.

				<h3>Boiled Spaghetti:</h3>
				Put the spaghetti (processed flour) and 5 units of water into the microwave and wait.

				<h3>Donuts:</h3>
				Add some dough and 5 units of sugar to the microwave and wait.

				<h3>Fries:</h3>
				Add one potato to the processor, then bake them in the microwave.

				<h3>Further recipes</h3>
				<iframe style="width:100%; height:85vh;" src="https://cm-ss13.com/wiki/Cooking" frameborder="0" id="main_frame"></iframe>
				</body>
			</html>
			"}


/obj/item/book/manual/barman_recipes
	name = "Barman Recipes: Mixing Drinks and Changing Lives Under the Blitz"
	desc = "One of the most popular recipe books for drinks in the entirety of humankind. Now on it's 39th edition, it was first published in 1946 after the end of the Second World War by Sir Hugh Fairfax, one of the most prestigious barmen of all time."
	icon_state = "barbook"
	item_state = "barbook"
	author = "Sir Hugh Fairfax, Three World Empire"
	title = "Barman Recipes: Mixing Drinks and Changing Lives Under the Blitz"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Drinks for the lads that are new to this wonderful art</h1>
				Here's a guide for some basic drinks.

				<h3>Black Russian:</h3>
				Mix vodka and Kahlua into a glass.

				<h3>Cafe Latte:</h3>
				Mix milk and coffee into a glass.

				<h3>Classic Martini:</h3>
				Mix vermouth and gin into a glass.

				<h3>Gin Tonic:</h3>
				Mix gin and tonic into a glass.

				<h3>Grog:</h3>
				Mix rum and water into a glass.

				<h3>Irish Cream:</h3>
				Mix cream and whiskey into a glass.

				<h3>The Manly Dorf:</h3>
				Mix ale and beer into a glass.

				<h3>Mead:</h3>
				Mix enzyme, water, and sugar into a glass.

				<h3>Screwdriver:</h3>
				Mix vodka and orange juice into a glass.

				<h3>Further recipes</h3>
				<iframe style="width:100%; height:85vh;" src="https://cm-ss13.com/wiki/Drinks" frameborder="0" id="main_frame"></iframe>
				</body>
			</html>
			"}


/obj/item/book/manual/detective
	name = "The Film Noir: Proper Procedures for Investigations"
	icon_state ="book_detective"
	item_state ="book_detective"
	author = "Lawyer Ruben Knight, Weyland-Yutani Corporation"
	title = "The Film Noir: Proper Procedures for Investigations"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>Detective Work</h1>

				Between your bouts of self-narration and drinking whiskey on the rocks, you might get a case or two to solve.<br>
				To have the best chance to solve your case, follow these directions:
				<p>
				<ol>
					<li>Go to the crime scene. </li>
					<li>Take your scanner and scan EVERYTHING (Yes, the doors, the tables, even the dog). </li>
					<li>Once you are reasonably certain you have every scrap of evidence you can use, find all possible entry points and scan them, too. </li>
					<li>Return to your office. </li>
					<li>Using your forensic scanning computer, scan your scanner to upload all of your evidence into the database.</li>
					<li>Browse through the resulting dossiers, looking for the one that either has the most complete set of prints, or the most suspicious items handled. </li>
					<li>If you have 80% or more of the print (The print is displayed), go to step 10, otherwise continue to step 8.</li>
					<li>Look for clues from the suit fibres you found on your perpetrator, and go about looking for more evidence with this new information, scanning as you go. </li>
					<li>Try to get a fingerprint card of your perpetrator, as if used in the computer, the prints will be completed on their dossier.</li>
					<li>Assuming you have enough of a print to see it, grab the biggest complete piece of the print and search the security records for it. </li>
					<li>Since you now have both your dossier and the name of the person, print both out as evidence and get security to nab your baddie.</li>
					<li>Give yourself a pat on the back and a bottle of the ship's finest vodka, you did it!</li>
				</ol>
				<p>
				It really is that easy! Good luck!

				</body>
			</html>"}


/obj/item/book/manual/nuclear
	name = "Fission Mailed: How to Operate a Blockbuster"
	desc = "A book containing important information and instructions regarding the operation of a 'Blockbuster' Large Atomic Fission Demolition Device"
	icon_state = "book_nuclear"
	item_state = "book_nuclear"
	author = "Nuclear Regulatory Commission of the United Americas"
	title = "Fission Mailed: How to Operate a Blockbuster"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>The Nuclear Explosive</h1>
				Hello and thank you for choosing the Nuclear Regulatory Comission archive for your nuclear information needs. Today's crash course will deal with the operation of a 'Blockbuster' Large Atomic Fission Demolition Device (ELAFDD), designed and manufactured by the Colonial Marines Engineer Association with the purpose of allowing USCM patrol vessels to carry and utilize atomic ordnance without having the capabilities of remotely launching them.<br><br>

				First and foremost, YOU CAN'T DO ANYTHING UNTIL THE BOMB IS IN PLACE. A specific button exists to allow for the deployment and anchoring of the device into place. If this is done, to unbolt it, you must utilize the same button you used to anchor.<br>

				Secondly, the device requires decryption through dial-up connection, of which is then transmitted by radio back to the receiving vessel, make sure all telecommunication towers available on the designated detonation zone are operating with no problems.

				<h2>To make the 'Blockbuster' functional</h2>
				<ul>
					<li>Make sure you have proper Identification access to the device's panel.</li>
					<li>Place the nuclear device in the designated detonation zone.</li>
					<li>Extend and anchor the nuclear device through its interface.</li>
					<li>Turn the safety of the nuclear device off through its interface.</li>
					<li>Make sure all forms of transmission by radio in the designated detonation zone are functional.</li>
					<li>When decryption is completed, the device will AUTOMATICALLY begin it's detonation timer.<br>
					<b>Note</b>: The decryption time will usually take 10 minutes, and the device's timer is fixed to detonate at exactly 3 minutes.
				</ul><br>

				You now have activated the device. Remember: After decryption is completed, the detonation timer will automatically begin and you are UNABLE to cancel it.<br><br>
				The bomb can ONLY be detonated using the timer. Manual detonation is not an option. Toggle off the SAFETY.<br>
				<b>Note</b>: You wouldn't believe how much, statistically, our personnel forget to toggle it off when operating the device.<br><br>

				If you wish or need to move the device to any other designated detonation zone at any point in time before the detonation timer begins, you need to firstly cancel decryption, and then toggle off the anchoring of the device, move it, and re-anchor, not forgetting to restart decryption.<br><br>

				Remember the order:<br>
				<b>Access, Position, Anchor, Safety, Transmission, Decryption, Begin, Vacate</b><br><br>

				Farewell and happy demolitions.
				</body>
			</html>
			"}

// This book is ultra old
/obj/item/book/manual/hydroponics_beekeeping
	name = "The Ins and Outs of Apiculture - A Precise Art"
	icon_state = "book_hydroponics_bees"
	item_state = "book_hydroponics_bees"
	author = "Beekeeper Dave"
	title = "The Ins and Outs of Apiculture - A Precise Art"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>Raising Bees</h1>

				Bees are loving but fickle creatures. Don't mess with their hive and stay away from any clusters of them, and you'll avoid their ire.
				Sometimes, you'll need to dig around in there for those delicious sweeties though - in that case make sure you wear sealed protection gear
				and carry an extinguisher or smoker with you - any bees chasing you, once calmed down, can thusly be netted and returned safely to the hive.<br.
				<br>
				BeezEez is a cure-all panacea for them, but use it too much and the hive may grow to apocalyptic proportions. Other than that, bees are excellent pets
				for all the family and are excellent caretakers of one's garden: having a hive or two around will aid in the longevity and growth rate of plants,
				and aid them in fighting off poisons and disease.

				</body>
			</html>
			"}


/obj/item/book/manual/orbital_cannon_manual/New()
	. = ..()

	LAZYADD(GLOB.objects_of_interest, src)

/obj/item/book/manual/orbital_cannon_manual/Destroy()
	. = ..()

	LAZYREMOVE(GLOB.objects_of_interest, src)
