//c_config - damage profile
//damage - total damage from the bullet/hit/fireproc
//armor - relates to % damage blocked somehow. Damage profile determines how this "somehow" works
//penetration - directly subtracts from armor. Good for damage but less useful for breaking armor
//pen_armor_punch - how much armor breaking will be done per point of penetration. This is for weapons that penetrate with their shape (like needle bullets)
//damage_armor_punch - how much armor breaking is done by sheer weapon force. This is for big blunt weapons
//armor_integrity - how effective in % armor is at the moment
/proc/armor_damage_reduction(datum/combat_configuration/c_config, damage, armor=0, penetration=0, pen_armor_punch=0, damage_armor_punch=0, armor_integrity = 100)
	//c_config.critical_chance - used instead of two vars. Just our chance to crit
	//c_config.armor_effective_health - how much of an increase in %/100 we have per armor "level"
	//c_config.armor_minimal_efficiency = 4 - how much armor you can have if it is completely broken. Also how much armor we count on crit
	//c_config.armor_steps - how much armor we need to do 1 step
	//c_config.non_null_damage_mult - how much slack we have to deal at least some damage
	//c_config.armor_full_deflection_mult - how much armor we need to have to have a chance at completely absorbing the hit
	//c_config.armor_full_destruction_mult - how much armor we need before it is completely overwhelmed by damage
	//c_config.armor_max_full_destruction_mult - how strong can be the full armor overwhelming
	//c_config.armor_integrity_damage_mult - multiplier over final damage to armor calc
	//c_config.armor_ignore_integrity - armor doesn't break at all
	//c_config.armor_random_range - how random our armor can be

	if(damage == 0)
		return 0 //why bother. Also saves a lot of checks down the line

	armor_integrity = max(armor_integrity, 0)
	damage = damage * c_config.damage_initial_multiplier
	penetration = penetration > 0 || armor > 0 ? penetration : 0		
	armor -= penetration
	var/is_crit_hit = prob(c_config.critical_chance)
	var/minimal_efficiency = c_config.armor_effective_health*c_config.armor_minimal_efficiency //lets not repeat ourselves
	var/armor_effect = c_config.armor_effective_health
	if(c_config.armor_ignore_integrity || armor_integrity < 100)
		armor_effect = minimal_efficiency + (armor_integrity/100)*((1-c_config.armor_minimal_efficiency)*c_config.armor_effective_health)
	if(is_crit_hit)
		armor_effect = minimal_efficiency
	var/armor_deflection_total = 1
	var/effective_deflection = 1

	if(armor>0)
		armor = armor * rand(100-c_config.armor_random_range,100) / 100
		armor_deflection_total = (1+armor_effect) ** (armor/c_config.armor_steps) //basically a concept of "Effective Health"
		effective_deflection = c_config.armor_ignore_integrity? 1 : armor_integrity/100


	damage /= armor_deflection_total

	if(damage < armor * c_config.armor_full_deflection_mult * effective_deflection)
		var/damage_with_armor = damage*c_config.non_null_damage_mult - armor * effective_deflection
		if(damage_with_armor <= 0) //PING
			damage = 0
		else
			var/dam_pass = damage_with_armor/(damage*c_config.non_null_damage_mult)
			damage = damage * dam_pass

	if(damage < 0)
		damage = 0
	return damage


/proc/armor_break_calculation(datum/combat_configuration/c_config, damage, armor=0, penetration=0, pen_armor_punch=0, damage_armor_punch=0, armor_integrity = 100)
	//c_config.critical_chance - used instead of two vars. Just our chance to crit
	//c_config.armor_effective_health - how much of an increase in %/100 we have per armor "level"
	//c_config.armor_minimal_efficiency = 4 - how much armor you can have if it is completely broken. Also how much armor we count on crit
	//c_config.armor_steps - how much armor we need to do 1 step
	//c_config.non_null_damage_mult - how much slack we have to deal at least some damage
	//c_config.armor_full_deflection_mult - how much armor we need to have to have a chance at completely absorbing the hit
	//c_config.armor_full_destruction_mult - how much armor we need before it is completely overwhelmed by damage
	//c_config.armor_max_full_destruction_mult - how strong can be the full armor overwhelming
	//c_config.armor_integrity_damage_mult - multiplier over final damage to armor calc
	//c_config.armor_ignore_integrity - armor doesn't break at all

	if(damage == 0 || armor == 0 || c_config.armor_ignore_integrity)
		return 0 //why bother. Also saves a lot of checks down the line
	
	damage = damage * c_config.damage_initial_multiplier
	var/dam_initial = damage
	var/initial_armor = armor
	penetration = penetration > 0 || armor > 0 ? penetration : 0		
	armor -= penetration
	var/is_crit_hit = prob(c_config.critical_chance)
	var/minimal_efficiency = c_config.armor_effective_health*c_config.armor_minimal_efficiency //lets not repeat ourselves
	var/armor_effect = c_config.armor_effective_health
	if(armor_integrity < 100)
		armor_effect = minimal_efficiency + (armor_integrity/100)*((1-c_config.armor_minimal_efficiency)*c_config.armor_effective_health)
	if(is_crit_hit)
		armor_effect = minimal_efficiency
	var/armor_deflection_total = 1
	var/effective_deflection = 1
	if(armor>0)
		armor = armor * rand(100-c_config.armor_random_range,100) / 100
		armor_deflection_total = (1+armor_effect) ** (armor/c_config.armor_steps) //basically a concept of "Effective Health"
		effective_deflection = c_config.armor_ignore_integrity? 1 : armor_integrity/100
	
	damage /= armor_deflection_total

	if(damage < armor * c_config.armor_full_deflection_mult * effective_deflection)
		var/damage_with_armor = damage*c_config.non_null_damage_mult - armor * effective_deflection
		if(damage_with_armor <= 0) //PING
			damage = 0
		else
			var/dam_pass = damage_with_armor/(damage*c_config.non_null_damage_mult)
			damage = damage * dam_pass

	var/armor_punch = pen_armor_punch * penetration + damage_armor_punch * (dam_initial - damage)

	if(damage + penetration > armor * c_config.armor_full_destruction_mult * effective_deflection)
		var/armor_punch_bonus = 1
		if(armor>0 && effective_deflection>0)
			armor_punch_bonus = (damage + penetration) / (armor * c_config.armor_full_destruction_mult  * effective_deflection)
			if(c_config.armor_max_full_destruction_mult<armor_punch_bonus)
				armor_punch_bonus = c_config.armor_max_full_destruction_mult
		else
			armor_punch_bonus = c_config.armor_max_full_destruction_mult
		armor_punch *= armor_punch_bonus
	if(initial_armor == 0)
		return 0
	var/armor_damage = c_config.armor_integrity_damage_mult * armor_punch
	if(armor_damage < 0)
		armor_damage = 0
	return armor_damage