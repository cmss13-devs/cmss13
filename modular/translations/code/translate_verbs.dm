// MARK: Attack
GLOBAL_LIST_INIT(ru_attack_verbs_unarmed, list(
	// unarmed_attack_verbs
	"slash" = "режет",
	"bump" = "ударяет",
	"bite" = "кусает",
	"chomp" = "грызет",
	"punch" = "бьет",
	"kick" = "пинает",
	"burn" = "жгёт",
	"sear" = "обжигает",
	"scratch" = "царапает",
	"claw" = "скребет",
	"slap" = "шлепает",
	"lash" = "стегает",
	// grappled_attack_verb
	"pummel" = "колотит",
	"lacerate" = "раздирает",
	"scorch" = "выжигает",
	"hit" = "бьёт",
	"punched" = "бьёт",
	"attacked" = "атакует",
	"pinched" = "щипает",
	"poked" = "тыкает",
	"bashed" = "колотит",
	"battered" = "колотит",
	"whacked" = "колотит",
	"bludgeoned" = "дубасит",
	"cleaved" = "рассекает",
	"slashed" = "режет",
	"cut" = "режет",
	"diced" = "режет",
	"stabbed" = "колит",
	"torn" = "рвёт",
	"ripped" = "рвёт",
	"sliced" = "шинкует",
	"carved" = "высекает",
	"minced" = "рубит",
	"chopped" = "рубит",
	"shredded" = "крошит",
	"cubed" = "нарезает кубиками",
))

/proc/ru_attacked_verb(attacked_verb)
	return GLOB.ru_attack_verbs_unarmed[attacked_verb] || attacked_verb

/proc/ru_attack_verb(attack_verb, list/override)
	var/list/list_to_use = override || GLOB.ru_attack_verbs
	return list_to_use[attack_verb] || attack_verb

// MARK: Eat
/proc/ru_eat_verb(eat_verb)
	return GLOB.ru_eat_verbs[eat_verb] || eat_verb

// MARK: Say
/proc/ru_say_verb(say_verb)
	return GLOB.ru_say_verb[say_verb] || say_verb
