/datum/techtree/proc/give_points_over_time(to_give, time, amount = 0.1)
	set waitfor = FALSE
	var/points_to_give = to_give
	var/delay = time / to_give * amount
	while(points_to_give > 0)
		points_to_give -= amount
		add_points(amount)
		sleep(delay)
