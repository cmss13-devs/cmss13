/** Window sizes in pixels */
export enum WindowSize {
  Small = 30,
  Medium = 50,
  Large = 70,
  Width = 380,
}

/** Line lengths for autoexpand */
export enum LineLength {
  Small = 36,
  Medium = 70,
  Large = 104,
}

/**
 * Radio prefixes.
 * Contains the properties:
 * id - string. css class identifier.
 * label - string. button label.
 */
export const RADIO_PREFIXES = {
  ':h ': {
    id: 'department',
    label: 'Depart.',
  },
  '.h ': {
    id: 'department',
    label: 'Depart.',
  },
  '#h ': {
    id: 'department',
    label: 'Depart.',
  },
  ':i ': {
    id: 'comms',
    label: 'Intercom',
  },
  '.i ': {
    id: 'comms',
    label: 'Intercom',
  },
  '#i ': {
    id: 'comms',
    label: 'Intercom',
  },
  ':l ': {
    id: 'comms',
    label: 'L Hand',
  },
  '.l ': {
    id: 'comms',
    label: 'L Hand',
  },
  ':r ': {
    id: 'comms',
    label: 'R Hand',
  },
  '.r ': {
    id: 'comms',
    label: 'R Hand',
  },
  ':w ': {
    id: 'whisper',
    label: 'Whisper',
  },
  '.w ': {
    id: 'whisper',
    label: 'Whisper',
  },
  '#w ': {
    id: 'whisper',
    label: 'Whisper',
  },
  ':a ': {
    id: 'alpha',
    label: 'Alpha',
  },
  '.a ': {
    id: 'alpha',
    label: 'Alpha',
  },
  '#a ': {
    id: 'clf-med',
    label: 'CLF Med',
  },
  ':b ': {
    id: 'bravo',
    label: 'Bravo',
  },
  '.b ': {
    id: 'bravo',
    label: 'Bravo',
  },
  '#b ': {
    id: 'clf-engi',
    label: 'CLF Engi',
  },
  ':c ': {
    id: 'charlie',
    label: 'Charl.',
  },
  '.c ': {
    id: 'charlie',
    label: 'Charl.',
  },
  '#c ': {
    id: 'clf-cmd',
    label: 'CLF Cmd.',
  },
  ':d ': {
    id: 'delta',
    label: 'Delta',
  },
  '.d ': {
    id: 'delta',
    label: 'Delta',
  },
  '#d ': {
    id: 'clf-cct',
    label: 'CLF CCT',
  },
  ':e ': {
    id: 'echo',
    label: 'Echo',
  },
  '.e ': {
    id: 'echo',
    label: 'Echo',
  },
  '#e ': {
    id: 'pmc-engi',
    label: 'PMC Engi',
  },
  ':f ': {
    id: 'foxtrot',
    label: 'Foxtr.',
  },
  '.f ': {
    id: 'foxtrot',
    label: 'Foxtr.',
  },
  '#f ': {
    id: 'pmc-med',
    label: 'PMC Med',
  },
  ':g ': {
    id: 'ship',
    label: 'Ship',
  },
  '.g ': {
    id: 'ship',
    label: 'Ship',
  },
  '#g ': {
    id: 'clf',
    label: 'CLF',
  },
  ':j ': {
    id: 'jtac',
    label: 'JTAC',
  },
  '.j ': {
    id: 'jtac',
    label: 'JTAC',
  },
  '#j ': {
    id: 'upp-cct',
    label: 'UPP CCT',
  },
  ':k ': {
    id: 'sof',
    label: 'SOF',
  },
  '.k ': {
    id: 'sof',
    label: 'SOF',
  },
  '#k ': {
    id: 'specops',
    label: 'SpecOps',
  },
  '#l ': {
    id: 'provost',
    label: 'Provost',
  },
  ':m ': {
    id: 'medsci',
    label: 'MedSci',
  },
  '.m ': {
    id: 'medsci',
    label: 'MedSci',
  },
  '#m ': {
    id: 'upp-med',
    label: 'UPP Med',
  },
  ':n ': {
    id: 'engi',
    label: 'Engi',
  },
  '.n ': {
    id: 'engi',
    label: 'Engi',
  },
  '#n ': {
    id: 'upp-engi',
    label: 'UPP Engi',
  },
  ':o ': {
    id: 'colony',
    label: 'Colony',
  },
  '.o ': {
    id: 'colony',
    label: 'Colony',
  },
  '#o ': {
    id: 'pmc-cct',
    label: 'PMC CCT',
  },
  ':p ': {
    id: 'security',
    label: 'MP',
  },
  '.p ': {
    id: 'security',
    label: 'MP',
  },
  '#p ': {
    id: 'pmc',
    label: 'PMC',
  },
  ':q ': {
    id: 'hive',
    label: 'Hive',
  },
  '.q ': {
    id: 'hive',
    label: 'Hive',
  },
  '#q ': {
    id: 'hive',
    label: 'Hive',
  },
  '#r ': {
    id: 'yautja',
    label: 'Yautja',
  },
  ':s ': {
    id: 'cia',
    label: 'CIA',
  },
  '.s ': {
    id: 'cia',
    label: 'CIA',
  },
  '#s ': {
    id: 'yautja',
    label: 'Yautja Ovr.',
  },
  ':t ': {
    id: 'intel',
    label: 'Int',
  },
  '.t ': {
    id: 'intel',
    label: 'Int',
  },
  '#t ': {
    id: 'upp-kdo',
    label: 'UPP Kdo',
  },
  ':u ': {
    id: 'req',
    label: 'Req',
  },
  '.u ': {
    id: 'req',
    label: 'Req',
  },
  '#u ': {
    id: 'upp',
    label: 'UPP',
  },
  ':v ': {
    id: 'command',
    label: 'Cmd.',
  },
  '.v ': {
    id: 'command',
    label: 'Cmd.',
  },
  '#v ': {
    id: 'upp-cmd',
    label: 'UPP Cmd.',
  },
  ':x ': {
    id: 'hyperdyne',
    label: 'Hyperdyne',
  },
  '.x ': {
    id: 'hyperdyne',
    label: 'Hyperdyne',
  },
  '#x ': {
    id: 'hyperdyne',
    label: 'Hyperdyne',
  },
  ':y ': {
    id: 'wy',
    label: 'W-Y',
  },
  '.y ': {
    id: 'wy',
    label: 'W-Y',
  },
  '#y ': {
    id: 'wy',
    label: 'W-Y',
  },
  ':z ': {
    id: 'highcom',
    label: 'HC',
  },
  '.z ': {
    id: 'highcom',
    label: 'HC',
  },
  '#z ': {
    id: 'pmc-cmd',
    label: 'PMC Cmd.',
  },
} as const;

export const LANGUAGE_PREFIXES = {
  '!0 ': {
    id: 'scandinavian',
    label: 'Scandinavian',
  },
  '!1 ': {
    id: 'english',
    label: 'English',
  },
  '!2 ': {
    id: 'japanese',
    label: 'Japanese',
  },
  '!3 ': {
    id: 'russian',
    label: 'Russian',
  },
  '!4 ': {
    id: 'german',
    label: 'German',
  },
  '!5 ': {
    id: 'spanish',
    label: 'Spanish',
  },
  '!6 ': {
    id: 'apollo',
    label: 'Apollo',
  },
  '!7 ': {
    id: 'telepathy',
    label: 'Telepathy',
  },
  '!8 ': {
    id: 'chinese',
    label: 'Chinese',
  },
  '!9 ': {
    id: 'french',
    label: 'French',
  },
  '!x ': {
    id: 'xenomorph',
    label: 'Xenomporph',
  },
  '!l ': {
    id: 'tactical sign language',
    label: 'Tactical Sign',
  },
  '!s ': {
    id: 'sainja',
    label: 'Sainja',
  },
  '!h ': {
    id: 'hellhound',
    label: 'Hellhound',
  },
  '!q ': {
    id: 'hivemind',
    label: 'Hivemind',
  },
  '!_ ': {
    id: 'primitive',
    label: 'Primitive',
  },
  // BANDAMARINES constants
  ':ь ': {
    id: 'medsci',
    label: 'MedSci',
  },
  ':т ': {
    id: 'engi',
    label: 'Engi',
  },
  ':п ': {
    id: 'ship',
    label: 'Ship',
  },
  ':м ': {
    id: 'command',
    label: 'Cmd.',
  },
  ':ф ': {
    id: 'alpha',
    label: 'Alpha',
  },
  ':и ': {
    id: 'bravo',
    label: 'Bravo',
  },
  ':с ': {
    id: 'charlie',
    label: 'Charl.',
  },
  ':в ': {
    id: 'delta',
    label: 'Delta',
  },
  ':у ': {
    id: 'echo',
    label: 'Echo',
  },
  ':а ': {
    id: 'foxtrot',
    label: 'Foxtr.',
  },
  ':з ': {
    id: 'security',
    label: 'MP',
  },
  ':г ': {
    id: 'req',
    label: 'Req',
  },
  ':о ': {
    id: 'jtac',
    label: 'JTAC',
  },
  ':е ': {
    id: 'intel',
    label: 'Int',
  },
  ':н ': {
    id: 'wy',
    label: 'W-Y',
  },
  ':щ ': {
    id: 'colony',
    label: 'Colony',
  },
  ':я ': {
    id: 'highcom',
    label: 'HC',
  },
  ':л ': {
    id: 'sof',
    label: 'SOF',
  },
  ':й ': {
    id: 'hive',
    label: 'Hive',
  },
  ':Ь ': {
    id: 'medsci',
    label: 'MedSci',
  },
  ':Т ': {
    id: 'engi',
    label: 'Engi',
  },
  ':П ': {
    id: 'ship',
    label: 'Ship',
  },
  ':М ': {
    id: 'command',
    label: 'Cmd.',
  },
  ':Ф ': {
    id: 'alpha',
    label: 'Alpha',
  },
  ':И ': {
    id: 'bravo',
    label: 'Bravo',
  },
  ':С ': {
    id: 'charlie',
    label: 'Charl.',
  },
  ':В ': {
    id: 'delta',
    label: 'Delta',
  },
  ':У ': {
    id: 'echo',
    label: 'Echo',
  },
  ':А ': {
    id: 'foxtrot',
    label: 'Foxtr.',
  },
  ':З ': {
    id: 'security',
    label: 'MP',
  },
  ':Г ': {
    id: 'req',
    label: 'Req',
  },
  ':О ': {
    id: 'jtac',
    label: 'JTAC',
  },
  ':Е ': {
    id: 'intel',
    label: 'Int',
  },
  ':Н ': {
    id: 'wy',
    label: 'W-Y',
  },
  ':Щ ': {
    id: 'colony',
    label: 'Colony',
  },
  ':Я ': {
    id: 'highcom',
    label: 'HC',
  },
  ':Л ': {
    id: 'sof',
    label: 'SOF',
  },
  ':Й ': {
    id: 'hive',
    label: 'Hive',
  },
  '.ь ': {
    id: 'medsci',
    label: 'MedSci',
  },
  '.т ': {
    id: 'engi',
    label: 'Engi',
  },
  '.п ': {
    id: 'ship',
    label: 'Ship',
  },
  '.м ': {
    id: 'command',
    label: 'Cmd.',
  },
  '.ф ': {
    id: 'alpha',
    label: 'Alpha',
  },
  '.и ': {
    id: 'bravo',
    label: 'Bravo',
  },
  '.с ': {
    id: 'charlie',
    label: 'Charl.',
  },
  '.в ': {
    id: 'delta',
    label: 'Delta',
  },
  '.у ': {
    id: 'echo',
    label: 'Echo',
  },
  '.а ': {
    id: 'foxtrot',
    label: 'Foxtr.',
  },
  '.з ': {
    id: 'security',
    label: 'MP',
  },
  '.г ': {
    id: 'req',
    label: 'Req',
  },
  '.о ': {
    id: 'jtac',
    label: 'JTAC',
  },
  '.е ': {
    id: 'intel',
    label: 'Int',
  },
  '.н ': {
    id: 'wy',
    label: 'W-Y',
  },
  '.щ ': {
    id: 'colony',
    label: 'Colony',
  },
  '.я ': {
    id: 'highcom',
    label: 'HC',
  },
  '.л ': {
    id: 'sof',
    label: 'SOF',
  },
  '.й ': {
    id: 'hive',
    label: 'Hive',
  },
  '.Ь ': {
    id: 'medsci',
    label: 'MedSci',
  },
  '.Т ': {
    id: 'engi',
    label: 'Engi',
  },
  '.П ': {
    id: 'ship',
    label: 'Ship',
  },
  '.М ': {
    id: 'command',
    label: 'Cmd.',
  },
  '.Ф ': {
    id: 'alpha',
    label: 'Alpha',
  },
  '.И ': {
    id: 'bravo',
    label: 'Bravo',
  },
  '.С ': {
    id: 'charlie',
    label: 'Charl.',
  },
  '.В ': {
    id: 'delta',
    label: 'Delta',
  },
  '.У ': {
    id: 'echo',
    label: 'Echo',
  },
  '.А ': {
    id: 'foxtrot',
    label: 'Foxtr.',
  },
  '.З ': {
    id: 'security',
    label: 'MP',
  },
  '.Г ': {
    id: 'req',
    label: 'Req',
  },
  '.О ': {
    id: 'jtac',
    label: 'JTAC',
  },
  '.Е ': {
    id: 'intel',
    label: 'Int',
  },
  '.Н ': {
    id: 'wy',
    label: 'W-Y',
  },
  '.Щ ': {
    id: 'colony',
    label: 'Colony',
  },
  '.Я ': {
    id: 'highcom',
    label: 'HC',
  },
  '.Л ': {
    id: 'sof',
    label: 'SOF',
  },
  '.Й ': {
    id: 'hive',
    label: 'Hive',
  },
  '#ь ': {
    id: 'upp-med',
    label: 'UPP Med',
  },
  '#т ': {
    id: 'upp-engi',
    label: 'UPP Engi',
  },
  '#п ': {
    id: 'clf',
    label: 'clf',
  },
  '#м ': {
    id: 'upp-cmd',
    label: 'UPP Cmd.',
  },
  '#ф ': {
    id: 'clf-med',
    label: 'CLF Med',
  },
  '#и ': {
    id: 'clf-engi',
    label: 'CLF Engi',
  },
  '#с ': {
    id: 'clf-cmd',
    label: 'CLF Cmd.',
  },
  '#в ': {
    id: 'clf-cct',
    label: 'CLF CCT',
  },
  '#у ': {
    id: 'pmc-engi',
    label: 'PMC Engi',
  },
  '#а ': {
    id: 'pmc-med',
    label: 'PMC Med',
  },
  '#з ': {
    id: 'pmc',
    label: 'PMC',
  },
  '#г ': {
    id: 'upp',
    label: 'UPP',
  },
  '#о ': {
    id: 'upp-cct',
    label: 'UPP CCT',
  },
  '#е ': {
    id: 'upp-kdo',
    label: 'UPP Kdo',
  },
  '#н ': {
    id: 'wy',
    label: 'W-Y',
  },
  '#щ ': {
    id: 'pmc-cct',
    label: 'PMC CCT',
  },
  '#я ': {
    id: 'pmc-cmd',
    label: 'PMC Cmd.',
  },
  '#л ': {
    id: 'specops',
    label: 'SpecOps',
  },
  '#й ': {
    id: 'hive',
    label: 'Hive',
  },
  '#Ь ': {
    id: 'upp-med',
    label: 'UPP Med',
  },
  '#Т ': {
    id: 'upp-engi',
    label: 'UPP Engi',
  },
  '#П ': {
    id: 'clf',
    label: 'clf',
  },
  '#М ': {
    id: 'upp-cmd',
    label: 'UPP Cmd.',
  },
  '#Ф ': {
    id: 'clf-med',
    label: 'CLF Med',
  },
  '#И ': {
    id: 'clf-engi',
    label: 'CLF Engi',
  },
  '#С ': {
    id: 'clf-cmd',
    label: 'CLF Cmd.',
  },
  '#В ': {
    id: 'clf-cct',
    label: 'CLF CCT',
  },
  '#У ': {
    id: 'pmc-engi',
    label: 'PMC Engi',
  },
  '#А ': {
    id: 'pmc-med',
    label: 'PMC Med',
  },
  '#З ': {
    id: 'pmc',
    label: 'PMC',
  },
  '#Г ': {
    id: 'upp',
    label: 'UPP',
  },
  '#О ': {
    id: 'upp-cct',
    label: 'UPP CCT',
  },
  '#Е ': {
    id: 'upp-kdo',
    label: 'UPP Kdo',
  },
  '#Н ': {
    id: 'wy',
    label: 'W-Y',
  },
  '#Щ ': {
    id: 'pmc-cct',
    label: 'PMC CCT',
  },
  '#Я ': {
    id: 'pmc-cmd',
    label: 'PMC Cmd.',
  },
  '#Л ': {
    id: 'specops',
    label: 'SpecOps',
  },
  '#Й ': {
    id: 'hive',
    label: 'Hive',
  },
  '№ь ': {
    id: 'upp-med',
    label: 'UPP Med',
  },
  '№т ': {
    id: 'upp-engi',
    label: 'UPP Engi',
  },
  '№п ': {
    id: 'clf',
    label: 'clf',
  },
  '№м ': {
    id: 'upp-cmd',
    label: 'UPP Cmd.',
  },
  '№ф ': {
    id: 'clf-med',
    label: 'CLF Med',
  },
  '№и ': {
    id: 'clf-engi',
    label: 'CLF Engi',
  },
  '№с ': {
    id: 'clf-cmd',
    label: 'CLF Cmd.',
  },
  '№в ': {
    id: 'clf-cct',
    label: 'CLF CCT',
  },
  '№у ': {
    id: 'pmc-engi',
    label: 'PMC Engi',
  },
  '№а ': {
    id: 'pmc-med',
    label: 'PMC Med',
  },
  '№з ': {
    id: 'pmc',
    label: 'PMC',
  },
  '№г ': {
    id: 'upp',
    label: 'UPP',
  },
  '№о ': {
    id: 'upp-cct',
    label: 'UPP CCT',
  },
  '№е ': {
    id: 'upp-kdo',
    label: 'UPP Kdo',
  },
  '№н ': {
    id: 'wy',
    label: 'W-Y',
  },
  '№щ ': {
    id: 'pmc-cct',
    label: 'PMC CCT',
  },
  '№я ': {
    id: 'pmc-cmd',
    label: 'PMC Cmd.',
  },
  '№л ': {
    id: 'specops',
    label: 'SpecOps',
  },
  '№й ': {
    id: 'hive',
    label: 'Hive',
  },
  '№Ь ': {
    id: 'upp-med',
    label: 'UPP Med',
  },
  '№Т ': {
    id: 'upp-engi',
    label: 'UPP Engi',
  },
  '№П ': {
    id: 'clf',
    label: 'clf',
  },
  '№М ': {
    id: 'upp-cmd',
    label: 'UPP Cmd.',
  },
  '№Ф ': {
    id: 'clf-med',
    label: 'CLF Med',
  },
  '№И ': {
    id: 'clf-engi',
    label: 'CLF Engi',
  },
  '№С ': {
    id: 'clf-cmd',
    label: 'CLF Cmd.',
  },
  '№В ': {
    id: 'clf-cct',
    label: 'CLF CCT',
  },
  '№У ': {
    id: 'pmc-engi',
    label: 'PMC Engi',
  },
  '№А ': {
    id: 'pmc-med',
    label: 'PMC Med',
  },
  '№З ': {
    id: 'pmc',
    label: 'PMC',
  },
  '№Г ': {
    id: 'upp',
    label: 'UPP',
  },
  '№О ': {
    id: 'upp-cct',
    label: 'UPP CCT',
  },
  '№Е ': {
    id: 'upp-kdo',
    label: 'UPP Kdo',
  },
  '№Н ': {
    id: 'wy',
    label: 'W-Y',
  },
  '№Щ ': {
    id: 'pmc-cct',
    label: 'PMC CCT',
  },
  '№Я ': {
    id: 'pmc-cmd',
    label: 'PMC Cmd.',
  },
  '№Л ': {
    id: 'specops',
    label: 'SpecOps',
  },
  '№Й ': {
    id: 'hive',
    label: 'Hive',
  },
  ':Ц ': {
    id: 'whisper',
    label: 'Whisper',
  },
  '.Ц ': {
    id: 'whisper',
    label: 'Whisper',
  },
  '#Ц ': {
    id: 'whisper',
    label: 'Whisper',
  },
  '№Ц ': {
    id: 'whisper',
    label: 'Whisper',
  },
  ':ц ': {
    id: 'whisper',
    label: 'Whisper',
  },
  '.ц ': {
    id: 'whisper',
    label: 'Whisper',
  },
  '#ц ': {
    id: 'whisper',
    label: 'Whisper',
  },
  '№ц ': {
    id: 'whisper',
    label: 'Whisper',
  },
  ':Р ': {
    id: 'department',
    label: 'Depart.',
  },
  '.Р ': {
    id: 'department',
    label: 'Depart.',
  },
  '#Р ': {
    id: 'department',
    label: 'Depart.',
  },
  '№Р ': {
    id: 'department',
    label: 'Depart.',
  },
  ':р ': {
    id: 'department',
    label: 'Depart.',
  },
  '.р ': {
    id: 'department',
    label: 'Depart.',
  },
  '#р ': {
    id: 'department',
    label: 'Depart.',
  },
  '№р ': {
    id: 'department',
    label: 'Depart.',
  },
  ':д ': {
    id: 'comms',
    label: 'L Hand',
  },
  '.д ': {
    id: 'comms',
    label: 'L Hand',
  },
  '#д ': {
    id: 'comms',
    label: 'L Hand',
  },
  '№д ': {
    id: 'comms',
    label: 'L Hand',
  },
  ':Д ': {
    id: 'comms',
    label: 'L Hand',
  },
  '.Д ': {
    id: 'comms',
    label: 'L Hand',
  },
  '#Д ': {
    id: 'comms',
    label: 'L Hand',
  },
  '№Д ': {
    id: 'comms',
    label: 'L Hand',
  },
  ':к ': {
    id: 'comms',
    label: 'R Hand',
  },
  '.к ': {
    id: 'comms',
    label: 'R Hand',
  },
  '#к ': {
    id: 'comms',
    label: 'R Hand',
  },
  '№к ': {
    id: 'comms',
    label: 'R Hand',
  },
  ':К ': {
    id: 'comms',
    label: 'R Hand',
  },
  '.К ': {
    id: 'comms',
    label: 'R Hand',
  },
  '#К ': {
    id: 'comms',
    label: 'R Hand',
  },
  '№К ': {
    id: 'comms',
    label: 'R Hand',
  },
  ':ш ': {
    id: 'comms',
    label: 'Intercom',
  },
  '.ш ': {
    id: 'comms',
    label: 'Intercom',
  },
  '#ш ': {
    id: 'comms',
    label: 'Intercom',
  },
  '№ш ': {
    id: 'comms',
    label: 'Intercom',
  },
  ':Ш ': {
    id: 'comms',
    label: 'Intercom',
  },
  '.Ш ': {
    id: 'comms',
    label: 'Intercom',
  },
  '#Ш ': {
    id: 'comms',
    label: 'Intercom',
  },
  '№Ш ': {
    id: 'comms',
    label: 'Intercom',
  },
} as const;
