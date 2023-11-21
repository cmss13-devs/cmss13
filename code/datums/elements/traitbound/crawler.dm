/datum/element/traitbound/crawler
	associated_trait = TRAIT_CRAWLER
	compatible_types = list(/mob/living)

/datum/element/traitbound/crawler/Attach(datum/target)
	. = ..()
	if(. & ELEMENT_INCOMPATIBLE)
		return
	add_verb(target, /mob/living/proc/ventcrawl)

/datum/element/traitbound/crawler/Detach(datum/target)
	remove_verb(target, /mob/living/proc/ventcrawl)
	return ..()
