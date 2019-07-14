
/mob/proc/Stun(amount)
	if(status_flags & CANSTUN)
		stunned = max(max(stunned,amount),0) //can't go below 0, getting a low amount of stun doesn't lower your current stun
		update_canmove()
	return

/mob/proc/SetStunned(amount) //if you REALLY need to set stun to a set amount without the whole "can't go below current stunned"
	if(status_flags & CANSTUN)
		stunned = max(amount,0)
		update_canmove()
	return

/mob/proc/AdjustStunned(amount)
	if(status_flags & CANSTUN)
		stunned = max(stunned + amount,0)
		update_canmove()
	return

/mob/proc/Daze(amount)
	if(status_flags & CANDAZE)
		dazed = max(max(dazed,amount),0)
	return

/mob/proc/SetDazed(amount)
	if(status_flags & CANDAZE)
		dazed = max(amount,0)
	return

/mob/proc/AdjustDazed(amount)
	if(status_flags & CANDAZE)		
		dazed = max(dazed + amount,0)
	return

/mob/proc/Slow(amount)
	if(status_flags & CANSLOW)
		slowed = max(max(slowed,amount),0)
	return

/mob/proc/SetSlowed(amount)
	if(status_flags & CANSLOW)
		slowed = max(amount,0)
	return

/mob/proc/AdjustSlowed(amount)
	if(status_flags & CANSLOW)		
		slowed = max(slowed + amount,0)
	return

/mob/proc/Superslow(amount)
	if(status_flags & CANSLOW)
		superslowed = max(max(superslowed,amount),0)
	return

/mob/proc/SetSuperslowed(amount)
	if(status_flags & CANSLOW)
		superslowed = max(amount,0)
	return

/mob/proc/AdjustSuperslowed(amount)
	if(status_flags & CANSLOW)		
		superslowed = max(superslowed + amount,0)
	return

/mob/proc/KnockDown(amount, force)
	if((status_flags & CANKNOCKDOWN) || force)
		knocked_down = max(max(knocked_down,amount),0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/SetKnockeddown(amount)
	if(status_flags & CANKNOCKDOWN)
		knocked_down = max(amount,0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/AdjustKnockeddown(amount)
	if(status_flags & CANKNOCKDOWN)
		knocked_down = max(knocked_down + amount,0)
		update_canmove()	//updates lying, canmove and icons
	return

/mob/proc/KnockOut(amount)
	if(status_flags & CANKNOCKOUT)
		knocked_out = max(max(knocked_out,amount),0)
	return

/mob/proc/SetKnockedout(amount)
	if(status_flags & CANKNOCKOUT)
		knocked_out = max(amount,0)
	return

/mob/proc/AdjustKnockedout(amount)
	if(status_flags & CANKNOCKOUT)
		knocked_out = max(knocked_out + amount,0)
	return

/mob/proc/Sleeping(amount)
	sleeping = max(max(sleeping,amount),0)
	return

/mob/proc/SetSleeping(amount)
	sleeping = max(amount,0)
	return

/mob/proc/AdjustSleeping(amount)
	sleeping = max(sleeping + amount,0)
	return

/mob/proc/Resting(amount)
	resting = max(max(resting,amount),0)
	return

/mob/proc/SetResting(amount)
	resting = max(amount,0)
	return

/mob/proc/AdjustResting(amount)
	resting = max(resting + amount,0)
	return