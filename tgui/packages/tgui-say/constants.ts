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
    id: 'tatical',
    label: 'Tacitical Sign',
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
} as const;
