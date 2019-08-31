
    
/obj/item/device/walkman
    name = "walkman"
    desc = "A cassette player that first hit the market over 200 years ago. Crazy how these never went out of style."
    icon = 'icons/obj/items/walkman.dmi'
    icon_state = "walkman_empty"
    w_class = SIZE_SMALL
    flags_equip_slot = SLOT_WAIST | SLOT_EAR 
    actions_types = list(/datum/action/item_action/walkman/play_pause,/datum/action/item_action/walkman/next_song,/datum/action/item_action/walkman/restart_song)
    var/obj/item/device/cassette_tape/tape  
    var/paused = TRUE 
    var/list/current_playlist = list()
    var/list/current_songnames = list()
    var/sound/current_song
    var/mob/current_listener
    var/pl_index = 1
    var/volume = 25

/obj/item/device/walkman/Dispose()
    if(tape)
        qdel(tape)
    break_sound()
    current_song = null
    current_listener = null
    processing_objects -= src
    . = ..()
    
/obj/item/device/walkman/attackby(obj/item/W, mob/user)
    if(istype(W,/obj/item/device/cassette_tape))
        if(W == user.get_active_hand() && src in user)
            if(!tape)
                insert_tape(W)
                playsound(src,'sound/weapons/handcuffs.ogg',20,1) 
                to_chat(user,SPAN_INFO("You insert \the [W] into \the [src]"))
            else
                to_chat(user,SPAN_WARNING("Remove the other tape first!"))
         
/obj/item/device/walkman/attack_self(mob/user)
    if(!current_listener)
        current_listener = user
        processing_objects += src
    if(istype(tape))
        if(paused)
            play()
            to_chat(user,SPAN_INFO("You press [src]'s 'play' button"))
        else
            pause()
            to_chat(user,SPAN_INFO("You pause [src]"))
    else
        to_chat(user,SPAN_INFO("There's no tape to play"))
    playsound(src,'sound/machines/click.ogg',20,1)

/obj/item/device/walkman/attack_hand(mob/user)
    if(tape && src == user.get_inactive_hand())
        eject_tape(user)
        return
    else
        ..()
    

/obj/item/device/walkman/proc/break_sound()
    var/sound/break_sound = sound(null,0,0,3)
    break_sound.priority = 255
    update_song(break_sound,current_listener,0)

/obj/item/device/walkman/proc/update_song(sound/S,mob/M,flags = SOUND_UPDATE)
    if(!istype(M) || !istype(S)) return
    if(M.ear_deaf > 0)
        flags |= SOUND_MUTE
    S.status = flags
    S.volume = src.volume
    sound_to(M,S)

/obj/item/device/walkman/proc/pause(mob/user)
    if(!current_song) return
    paused = TRUE
    update_song(current_song,current_listener,SOUND_PAUSED | SOUND_UPDATE)

/obj/item/device/walkman/proc/play()
    if(!current_song)
        if(current_playlist.len > 0)
            current_song = sound(current_playlist[pl_index],0,0,3,volume)
            current_song.status = SOUND_STREAM
        else
            return
    paused = FALSE
    if(current_song.status & SOUND_PAUSED)
        to_chat(current_listener,SPAN_INFO("Resuming : [current_songnames[pl_index]] ([pl_index] of [current_playlist.len])"))
        update_song(current_song,current_listener)
    else
        to_chat(current_listener,SPAN_INFO("Now playing : [current_songnames[pl_index]] ([pl_index] of [current_playlist.len])"))
        update_song(current_song,current_listener,0)
    
    update_song(current_song,current_listener)
   
/obj/item/device/walkman/proc/insert_tape(obj/item/device/cassette_tape/CT)
    if(tape || !istype(CT)) return 

    tape = CT
    if(ishuman(CT.loc))
        var/mob/living/carbon/human/H = CT.loc
        H.drop_held_item(CT)
    CT.forceMove(src)

    update_icon()
    paused = TRUE
    pl_index = 1
    if(tape.songs["side1"] && tape.songs["side2"])
        var/list/L = tape.songs["[tape.flipped ? "side2" : "side1"]"]
        for(var/S in L)
            current_playlist += S
            current_songnames += L[S]


/obj/item/device/walkman/proc/eject_tape(mob/user)
    if(!tape) return

    break_sound()
    
    current_song = null
    current_playlist.Cut()
    current_songnames.Cut()
    user.put_in_hands(tape)
    tape = null
    update_icon()
    playsound(src,'sound/weapons/handcuffs.ogg',20,1) 
    to_chat(user,SPAN_INFO("You eject the tape from [src]"))

/obj/item/device/walkman/proc/next_song(mob/user)
    
    if(user.is_mob_incapacitated() || current_playlist.len == 0) return

    break_sound()
    
    if(pl_index + 1 <= current_playlist.len)
        pl_index++
    else
        pl_index = 1
    current_song = sound(current_playlist[pl_index],0,0,3,volume)
    current_song.status = SOUND_STREAM
    play()
    to_chat(user,SPAN_INFO("You change the song"))


/obj/item/device/walkman/update_icon()
    if(tape)
        icon_state = "walkman"
    else
        icon_state = "walkman_empty"

/obj/item/device/walkman/process()
    if(!(src in current_listener.GetAllContents(3)) || current_listener.stat & DEAD)
        if(current_song)
            current_song = null
        break_sound()
        paused = TRUE
        current_listener = null
        processing_objects -= src
        return
    if(current_listener.ear_deaf > 0 && !(current_song.status & SOUND_MUTE))
        update_song(current_song,current_listener)
    if(current_listener.ear_deaf == 0 && current_song.status & SOUND_MUTE)
        update_song(current_song,current_listener)

/obj/item/device/walkman/verb/play_pause()
    set name = "Play/Pause"
    set category = "Object"
    set src in usr

    if(usr.is_mob_incapacitated()) return

    attack_self(usr)

/obj/item/device/walkman/verb/eject_cassetetape()
    set name = "Eject tape"
    set category = "Object"
    set src in usr

    eject_tape(usr)

/obj/item/device/walkman/verb/next_pl_song()
    set name = "Next song"
    set category = "Object"
    set src in usr

    next_song(usr)

/obj/item/device/walkman/verb/change_volume()
    set name = "Change Walkman volume"
    set category = "Object"
    set src in usr

    if(usr.is_mob_incapacitated() || !current_song) return    

    var/tmp = input(usr,"Change the volume (0 - 100)","Volume") as num|null
    if(tmp == null) return
    if(tmp > 100) tmp = 100
    if(tmp < 0) tmp = 0
    volume = tmp
    update_song(current_song,current_listener)

/obj/item/device/walkman/proc/restart_song(mob/user)
    if(user.is_mob_incapacitated() || !current_song) return 

    update_song(current_song,current_listener,0)
    to_chat(user,SPAN_INFO("You restart the song"))

/obj/item/device/walkman/verb/restart_current_song()
    set name = "Restart Song"
    set category = "Object"
    set src in usr

    restart_song(usr)

/*

    ACTION BUTTONS

*/

/datum/action/item_action/walkman  
    var/action_icon_state 

/datum/action/item_action/walkman/New()
    ..()
    button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/walkman/play_pause
    action_icon_state = "walkman_playpause"

/datum/action/item_action/walkman/play_pause/New()
    ..()
    name = "Play/Pause"
    button.name = name

/datum/action/item_action/walkman/play_pause/action_activate()
    if(target)
        var/obj/item/device/walkman/WM = target
        WM.attack_self(owner)

/datum/action/item_action/walkman/next_song
    action_icon_state = "walkman_next"

/datum/action/item_action/walkman/next_song/New()
    ..()
    name = "Next song"
    button.name = name

/datum/action/item_action/walkman/next_song/action_activate()
    if(target)
        var/obj/item/device/walkman/WM = target
        WM.next_song(owner)

/datum/action/item_action/walkman/restart_song
    action_icon_state = "walkman_restart"

/datum/action/item_action/walkman/restart_song/New()
    ..()
    name = "Restart song"
    button.name = name

/datum/action/item_action/walkman/restart_song/action_activate()
    if(target)
        var/obj/item/device/walkman/WM = target
        WM.restart_song(owner)

/*
    TAPES
*/
/obj/item/device/cassette_tape
    name = "cassette Tape"
    desc = "A cassette tape"
    icon = 'icons/obj/items/walkman.dmi'
    icon_state = "cassette_flip"
    w_class = SIZE_SMALL
    var/side1_icon = "cassette"
    var/flipped = FALSE //Tape side
    var/list/songs = list()

/obj/item/device/cassette_tape/attack_self(mob/user)
    if(flipped == TRUE)
        flipped = FALSE
        icon_state = side1_icon
    else
        flipped = TRUE
        icon_state = "cassette_flip"
    to_chat(user,"You flip [src]")

/obj/item/device/cassette_tape/verb/flip()
    set name = "Flip tape"
    set category = "Object"
    set src in usr

    attack_self()

/obj/item/device/cassette_tape/pop1
    name = "blue cassette"
    desc = "A plastic cassette tape with a blue sticker. It has marker scrawled on the front. It reads:\nSide 1\nStarship - We Built this City \nDire Straits - Money For Nothing \nTears for Fears - Everybody Wants to Rule the World\nSide 2\nBonnie Tyler - Holding Out for a Hero\nBruce Springsteen - Dancing in the Dark\nAsia - Heat of the Moment"
    icon_state = "cassette_blue"
    side1_icon = "cassette_blue"
    songs = list("side1" = list('sound/music/walkman/pop1/1-1-1WeBuiltThisCity.ogg' = "Starship - We Built this City",\
                                'sound/music/walkman/pop1/1-1-2MoneyForNothing.ogg' = "Dire Straits - Money For Nothing",\
                                'sound/music/walkman/pop1/1-1-3EverybodyWantsToRuleTheWorld.ogg' = "Tears for Fears - Everybody Wants to Rule the World"),\
                 "side2" = list('sound/music/walkman/pop1/1-2-1HoldingOutForAHero.ogg' = "Bonnie Tyler - Holding Out for a Hero",\
                                'sound/music/walkman/pop1/1-2-2DancingInTheDark.ogg' = "Bruce Springsteen - Dancing in the Dark",\
                                'sound/music/walkman/pop1/1-2-3HeatoftheMoment.ogg' = "Asia - Heat of the Moment"))

/obj/item/device/cassette_tape/pop2
    name = "rainbow cassette"
    desc = "A plastic cassette tape with a rainbow colored sticker. It has marker scrawled on the front. It reads:\nSide 1\nDuran Duran - Rio\nMen Without Hats - Safety Dance\nDead or Alive - You Spin Me Right Round\nSide 2\nSoft Cell - Tainted Love\nA-HA - Take on Me\nEurythmics - Sweet Dreams"
    icon_state = "cassette_rainbow"
    side1_icon = "cassette_rainbow"
    songs = list("side1" = list('sound/music/walkman/pop2/2-1-1Rio.ogg' = "Duran Duran - Rio",\
                                'sound/music/walkman/pop2/2-1-2SafetyDance.ogg' = "Men Without Hats - Safety Dance",\
                                'sound/music/walkman/pop2/2-1-3YouSpinMeRightRound.ogg' = "Dead or Alive - You Spin Me Right Round"),\
                 "side2" = list('sound/music/walkman/pop2/2-2-1TaintedLove.ogg' = "Soft Cell - Tainted Love",\
                                'sound/music/walkman/pop2/2-2-2TakeOnMe.ogg' = "A-HA - Take on Me",\
                                'sound/music/walkman/pop2/2-2-3SweetDreams.ogg' = "Eurythmics - Sweet Dreams"))

/obj/item/device/cassette_tape/pop3
    name = "orange cassette"
    desc = "A plastic cassette tape with an orange sticker. It has marker scrawled on the front. It reads:\nSide 1\nREM - It's the End of the World as We Know It\nFlashdance - Maniac\nCorey Hart - Sunglasses at Night\nSide 2\nThe Go Go's - We Got the Beat\nWhitney Houston - I Wanna Dance with Somebody\nHuey Lewis - The Power Of Love "
    icon_state = "cassette_orange"
    side1_icon = "cassette_orange" 
    songs = list("side1" = list('sound/music/walkman/pop3/3-1-1EndOfTheWorldAsWeKnowIt.ogg' = "REM - It's the End of the World as We Know It",\
                                'sound/music/walkman/pop3/3-1-2Maniac.ogg' = "Flashdance - Maniac",\
                                'sound/music/walkman/pop3/3-1-3SunglassesAtNight.ogg' = "Corey Hart - Sunglasses at Night"),\
                 "side2" = list('sound/music/walkman/pop3/3-2-1WeGotTheBeat.ogg' = "The Go Go's - We Got the Beat",\
                                'sound/music/walkman/pop3/3-2-2IWannaDanceWithSomebody.ogg' = "Whitney Houston - I Wanna Dance with Somebody",\
                                'sound/music/walkman/pop3/3-2-3ThePowerOfLove.ogg' = "Huey Lewis - The Power Of Love"))

/obj/item/device/cassette_tape/pop4
    name = "pink cassette"
    desc = "A plastic cassette tape with a pink striped sticker. It has marker scrawled on the front. It reads:\nSide 1\nQueen - Under Pressure\nDexy's Midnight Runners - Come on Eileen\nSimple Minds - Don't You Forget About Me\nSide 2\nMichael Jackson - Beat It\nEurope - Final Countdown\nKenny Loggins - Danger Zone"
    icon_state = "cassette_pink_stripe"        
    side1_icon = "cassette_pink_stripe"
    songs = list("side1" = list('sound/music/walkman/pop4/4-1-1UnderPressure.ogg' = "Queen - Under Pressure",\
                                'sound/music/walkman/pop4/4-1-2ComeOnEileen.ogg' = "Dexy's Midnight Runners - Come on Eileen",\
                                'sound/music/walkman/pop4/4-1-3Don\'tYouForgetAboutMe.ogg' = "Simple Minds - Don't You Forget About Me"),\
                 "side2" = list('sound/music/walkman/pop4/4-2-1BeatIt.ogg' = "Michael Jackson - Beat It",\
                                'sound/music/walkman/pop4/4-2-2TheFinalCountdown.ogg' = "Europe - Final Countdown",\
                                'sound/music/walkman/pop4/4-2-3DangerZone.ogg' = "Kenny Loggins - Danger Zone"))

/obj/item/device/cassette_tape/heavymetal
    name = "red-black cassette"
    desc = "A plastic cassette tape with a red and black sticker. It has marker scrawled on the front. It reads:\nSide 1\nScorpions - Rock You Like A Hurricane\nRatt - Round and Round\nDon Felder - Takin' a Ride\nSide 2\nVan Halen - Panana\nIron Maiden - The Trooper\nCheap Trick - Reach Out"
    icon_state = "cassette_red_black"
    side1_icon = "cassette_red_black"
    songs = list("side1" = list('sound/music/walkman/heavymetal/5-1-1RockYouLikeAHurricane.ogg' = "Scorpions - Rock You Like A Hurricane",\
                                'sound/music/walkman/heavymetal/5-1-2RoundAndRound.ogg' = "Ratt - Round and Round",\
                                'sound/music/walkman/heavymetal/5-1-3TakinARide.ogg' = "Don Felder - Takin' a Ride"),\
                 "side2" = list('sound/music/walkman/heavymetal/5-2-1Panama.ogg' = "Van Halen - Panama",\
                                'sound/music/walkman/heavymetal/5-2-2TheTrooper.ogg' = "Iron Maiden - The Trooper",\
                                'sound/music/walkman/heavymetal/5-2-3ReachOut.ogg' = "Cheap Trick - Reach Out"))

/obj/item/device/cassette_tape/hairmetal
    name = "red striped cassette"
    desc = "A plastic cassette tape with a gray sticker with red stripes. It has marker scrawled on the front. It reads:\nSide 1\nMotley Crue - Kickstart My Heart\nPoison - Talk Dirty to Me\nWarrant - Cherry Pie\nSide 2\nDef Leppard - Pour Some Sugar on Me\nJudas Priest - You've Got Another Thing Comin'\nLita Ford - Kiss Me Deadly"
    icon_state = "cassette_red_stripe"
    side1_icon = "cassette_red_stripe"
    songs = list("side1" = list('sound/music/walkman/hairmetal/6-1-1KickstartMyHeart.ogg' = "Motley Crue - Kickstart My Heart",\
                                'sound/music/walkman/hairmetal/6-1-2TalkDirtyToMe.ogg' = "Poison - Talk Dirty to Me",\
                                'sound/music/walkman/hairmetal/6-1-3CherryPie.ogg' = "Warrant - Cherry Pie"),\
                 "side2" = list('sound/music/walkman/hairmetal/6-2-1PourSomeSugarOnMe.ogg' = "Def Leppard - Pour Some Sugar on Me",\
                                'sound/music/walkman/hairmetal/6-2-2YouGotAnotherThingComin.ogg' = "Judas Priest - You've Got Another Thing Comin'",\
                                'sound/music/walkman/hairmetal/6-2-3KissMeDeadly.ogg' = "Lita Ford - Kiss Me Deadly"))