//Adapted from a free algorithm written in BASIC (https://www.assa.org.au/edm#Computer)
/proc/easter_date(y)
	var/first_dig, remain_19, temp //Intermediate Results
	var/table_a, table_b, table_c, table_d, table_e //Table A-E results
	var/d, m //Day and Month returned

	first_dig = round((y / 100))
	remain_19 = y % 19

	temp = (round((first_dig - 15) / 2)) + 202 - 11 * remain_19

	switch(first_dig)
		if(21,24,25,27,28,29,30,31,32,34,35,38)
			temp -= 1
		if(33,36,37,39,40)
			temp -= 2
	temp %= 30

	table_a = temp + 21
	if(temp == 29)
		table_a -= 1
	if(temp == 28 && (remain_19 > 10))
		table_a -= 1
	table_b = (table_a - 19) % 7

	table_c = (40 - first_dig) % 4
	if(table_c == 3)
		table_c += 1
	if(table_c > 1)
		table_c += 1
	temp = y % 100
	table_d = (temp + round((temp / 4))) % 7

	table_e = ((20 - table_b - table_c - table_d) % 7) + 1
	d = table_a + table_e
	if(d > 31)
		d -= 31
		m = 4
	else
		m = 3
	return list("day" = d, "month" = m)
