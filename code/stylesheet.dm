client/script = {"<style>
body					{font-family: Verdana, sans-serif;}

h1, h2, h3, h4, h5, h6	{color: #0000ff;	font-family: Georgia, Verdana, sans-serif;}

em						{font-style: normal;	font-weight: bold;}

.motd					{color: #638500;	font-family: Verdana, sans-serif;}
.motd h1, .motd h2, .motd h3, .motd h4, .motd h5, .motd h6
	{color: #638500;	text-decoration: underline;}
.motd a, .motd a:link, .motd a:visited, .motd a:active, .motd a:hover
	{color: #638500;}

.prefix					{					font-weight: bold;}

.ooc					{					font-weight: bold;}
.adminobserverooc		{color: #0099cc;	font-weight: bold;}
.adminooc				{color: #b82e00;	font-weight: bold;}
.xooc					{color: #6C0094;	font-weight: bold;}
.mooc					{color: #009900;	font-weight: bold;}
.yooc					{color: #999600;	font-weight: bold;}

.adminobserver			{color: #996600;	font-weight: bold;}
.admin					{color: #386aff;	font-weight: bold;}
.adminsay				{color: #9611D4;	font-weight: bold;}
.headminsay				{color: #5A0A7F;	font-weight: bold;}
.mod					{color: #735638;	font-weight: bold;}
.adminmod				{color: #402A14;	font-weight: bold;}
.mentorsay				{color: #d4af57;	font-weight: bold;}
.staffsay				{color: #b5850d;	font-weight: bold;}

.name					{					font-weight: bold;}

.say					{}
.deadsay				{color: #5c00e6;}
.radio					{color: #4E4E4E;}
.deptradio				{color: #993399;}
.comradio				{color: #004080;}
.syndradio				{color: #6D3F40;}
.centradio				{color: #5C5C8A;}
.airadio				{color: #FF00FF;}

.secradio				{color: #A30000;}
.engradio				{color: #A66300;}
.medradio				{color: #008160;}
.sciradio				{color: #993399;}
.supradio				{color: #5F4519;}
.jtacradio				{color: #702963;}
.intelradio				{color: #027D02;}
.wyradio				{color: #FE9B24;}

.alpharadio				{color: #EA0000;}
.bravoradio				{color: #C68610;}
.charlieradio			{color: #AA55AA;}
.deltaradio				{color: #007FCF;}

.medium					{					font-size: 2}
.big					{					font-size: 2}
.large					{					font-size: 3}
.extra_large			{					font-size: 4}
.huge					{					font-size: 5}

.bold					{font-weight: bold;}
.underline				{text-decoration: underline;}

.green					{color: #00ff00;}

.normal					{font-style: normal;}

.alert					{color: #ff0000;}
h1.alert, h2.alert		{color: #000000;}

.emote					{					font-style: italic;}
.selecteddna			{color: #FFFFFF; 	background-color: #001B1B}

.attack					{color: #ff0000;}
.moderate				{color: #CC0000;}
.disarm					{color: #990000;}
.passive				{color: #660000;}

.helpful				{color: #368f31;}

.scanner			{color: #ff0000;}
.scannerb			{color: #ff0000;	font-weight: bold;}
.scannerburn	{color: #ffa500;}
.scannerburnb	{color: #ffa500;	font-weight: bold;}
.rose					{color: #ff5050;}
.info					{color: #0000CC;}
.debuginfo				{color: #493D26;	font-style: italic;}
.notice					{color: #000099;}
.xenonotice				{color: #2a623d;}
.boldnotice				{color: #000099;	font-weight: bold;}
.warning				{color: #ff0000;	font-style: italic;}
.xenowarning			{color: #2a623d;	font-style: italic;}
.xenominorwarning		{color: #2a623d;	font-weight: bold; font-style: italic;}
.danger					{color: #ff0000;	font-weight: bold;}
.xenodanger				{color: #2a623d;	font-weight: bold;}
.avoidharm				{color:	#72a0e5;	font-weight: bold;}
.highdanger				{color: #ff0000;	font-weight: bold; font-size: 3;}
.xenohighdanger			{color: #2a623d; 	font-weight: bold; font-size: 3;}
.xenoannounce           {color: #1a472a;    font-family: book-antiqua; font-weight: bold; font-style: italic; font-size: 3;}
.yautjabold				{color: #800080;	font-weight: bold;}
.yautjaboldbig			{color: #800080;	font-weight: bold; font-size: 3;}

.objectivebig			{font-weight: bold; font-size: 3;}
.objectivegreen			{color: #00ff00;}
.objectivered			{color: #ff0000;}
.objectivesuccess		{color: #00ff00;	font-weight: bold; font-size: 3;}
.objectivefail			{color: #ff0000;	font-weight: bold; font-size: 3;}

.xeno					{color: #900090;	font-style: italic;}
.xenoleader				{color: #730d73;	font-style: italic;						font-size: 3;}
.xenoqueen				{color: #730d73; 	font-style: italic; font-weight: bold; font-size: 3;}
.newscaster				{color: #800000;}

.role_header			{color: #db0000		text-align: center; font-weight: bold; font-family: trebuchet-ms; font-size: 2;}
.role_body				{color: #000099;	text-align: center;}

.round_header			{color: #db0000; 	text-align: center; font-family: courier; font-weight: bold; font-size: 4;}
.round_body				{color: #001427; 	text-align: center; font-family: trebuchet-ms; font-weight: bold; font-size: 3;}
.event_announcement		{color: #600d48; 	font-family: arial-narrow; font-weight: bold; font-size: 3;}

.announce_header		{color: #000000;	font-weight: bold; font-size: 3;}
.announce_header_blue	{color: #000099;	font-weight: bold; font-size: 3;}
.announce_body			{color: #ff0000;	font-weight: normal;}

.centerbold				{				 	text-align: center; font-weight: bold;}

.modooc					{color: #184880;	font-weight: bold;}
.tajaran				{color: #803B56;}
.tajaran_signlang		{color: #941C1C;}
.skrell					{color: #00CED1;}
.soghun					{color: #228B22;}
.changeling				{color: #800080;}
.vox					{color: #AA00AA;}
.monkey					{color: #966C47;}
.rough					{font-family: trebuchet-ms, cursive, sans-serif;}
.german					{color: #858F1E; font-family: 'Times New Roman', Times, serif}
.spanish				{color: #CF982B;}
.japanese				{color: #0047A0}
.commando				{color: #FE9B24; font-style: bold;}
.say_quote				{font-family: Georgia, Verdana, sans-serif;}
</style>"}
