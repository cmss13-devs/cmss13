/proc/get_frequency_name(display_freq)
	var/freq_text

	// the name of the channel
	for(var/channel in GLOB.radiochannels)
		if(GLOB.radiochannels[channel] == display_freq)
			freq_text = channel
			break

	// --- If the frequency has not been assigned a name, just use the frequency as the name ---
	if(!freq_text)
		freq_text = format_frequency(display_freq)

	return freq_text

