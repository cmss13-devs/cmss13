/** Window sizes in pixels */
export enum WINDOW_SIZES {
  small = 30,
  medium = 45,
  large = 60,
  width = 380,
}

/** Line lengths for autoexpand */
export enum LINE_LENGTHS {
  small = 38,
  medium = 76,
}

/**
 * Radio prefixes.
 * Contains the properties:
 * id - string. css class identifier.
 * label - string. button label.
 */
export const RADIO_PREFIXES = {
  ':m ': {
    id: 'medsci',
    label: 'MedSci',
  },
  ':n ': {
    id: 'engi',
    label: 'Engi',
  },
  ':g ': {
    id: 'ship',
    label: 'Ship',
  },
  ':v ': {
    id: 'command',
    label: 'Cmd.',
  },
  ':a ': {
    id: 'alpha',
    label: 'Alpha',
  },
  ':b ': {
    id: 'bravo',
    label: 'Bravo',
  },
  ':c ': {
    id: 'charlie',
    label: 'Charl.',
  },
  ':d ': {
    id: 'delta',
    label: 'Delta',
  },
  ':e ': {
    id: 'echo',
    label: 'Echo',
  },
  ':f ': {
    id: 'foxtrot',
    label: 'Foxtr.',
  },
  ':p ': {
    id: 'security',
    label: 'MP',
  },
  ':u ': {
    id: 'req',
    label: 'Req',
  },
  ':j ': {
    id: 'jtac',
    label: 'JTAC',
  },
  ':t ': {
    id: 'intel',
    label: 'Int',
  },
  ':y ': {
    id: 'wy',
    label: 'W-Y',
  },
  ':o ': {
    id: 'colony',
    label: 'Colony',
  },
  ':z ': {
    id: 'highcom',
    label: 'HC',
  },
  ':k ': {
    id: 'sof',
    label: 'SOF',
  },
  ':q ': {
    id: 'hive',
    label: 'Hive',
  },
  ':M ': {
    id: 'medsci',
    label: 'MedSci',
  },
  ':N ': {
    id: 'engi',
    label: 'Engi',
  },
  ':G ': {
    id: 'ship',
    label: 'Ship',
  },
  ':V ': {
    id: 'command',
    label: 'Cmd.',
  },
  ':A ': {
    id: 'alpha',
    label: 'Alpha',
  },
  ':B ': {
    id: 'bravo',
    label: 'Bravo',
  },
  ':C ': {
    id: 'charlie',
    label: 'Charl.',
  },
  ':D ': {
    id: 'delta',
    label: 'Delta',
  },
  ':E ': {
    id: 'echo',
    label: 'Echo',
  },
  ':F ': {
    id: 'foxtrot',
    label: 'Foxtr.',
  },
  ':P ': {
    id: 'security',
    label: 'MP',
  },
  ':U ': {
    id: 'req',
    label: 'Req',
  },
  ':J ': {
    id: 'jtac',
    label: 'JTAC',
  },
  ':T ': {
    id: 'intel',
    label: 'Int',
  },
  ':Y ': {
    id: 'wy',
    label: 'W-Y',
  },
  ':O ': {
    id: 'colony',
    label: 'Colony',
  },
  ':Z ': {
    id: 'highcom',
    label: 'HC',
  },
  ':K ': {
    id: 'sof',
    label: 'SOF',
  },
  ':Q ': {
    id: 'hive',
    label: 'Hive',
  },
  '.m ': {
    id: 'medsci',
    label: 'MedSci',
  },
  '.n ': {
    id: 'engi',
    label: 'Engi',
  },
  '.g ': {
    id: 'ship',
    label: 'Ship',
  },
  '.v ': {
    id: 'command',
    label: 'Cmd.',
  },
  '.a ': {
    id: 'alpha',
    label: 'Alpha',
  },
  '.b ': {
    id: 'bravo',
    label: 'Bravo',
  },
  '.c ': {
    id: 'charlie',
    label: 'Charl.',
  },
  '.d ': {
    id: 'delta',
    label: 'Delta',
  },
  '.e ': {
    id: 'echo',
    label: 'Echo',
  },
  '.f ': {
    id: 'foxtrot',
    label: 'Foxtr.',
  },
  '.p ': {
    id: 'security',
    label: 'MP',
  },
  '.u ': {
    id: 'req',
    label: 'Req',
  },
  '.j ': {
    id: 'jtac',
    label: 'JTAC',
  },
  '.t ': {
    id: 'intel',
    label: 'Int',
  },
  '.y ': {
    id: 'wy',
    label: 'W-Y',
  },
  '.o ': {
    id: 'colony',
    label: 'Colony',
  },
  '.z ': {
    id: 'highcom',
    label: 'HC',
  },
  '.k ': {
    id: 'sof',
    label: 'SOF',
  },
  '.q ': {
    id: 'hive',
    label: 'Hive',
  },
  '.M ': {
    id: 'medsci',
    label: 'MedSci',
  },
  '.N ': {
    id: 'engi',
    label: 'Engi',
  },
  '.G ': {
    id: 'ship',
    label: 'Ship',
  },
  '.V ': {
    id: 'command',
    label: 'Cmd.',
  },
  '.A ': {
    id: 'alpha',
    label: 'Alpha',
  },
  '.B ': {
    id: 'bravo',
    label: 'Bravo',
  },
  '.C ': {
    id: 'charlie',
    label: 'Charl.',
  },
  '.D ': {
    id: 'delta',
    label: 'Delta',
  },
  '.E ': {
    id: 'echo',
    label: 'Echo',
  },
  '.F ': {
    id: 'foxtrot',
    label: 'Foxtr.',
  },
  '.P ': {
    id: 'security',
    label: 'MP',
  },
  '.U ': {
    id: 'req',
    label: 'Req',
  },
  '.J ': {
    id: 'jtac',
    label: 'JTAC',
  },
  '.T ': {
    id: 'intel',
    label: 'Int',
  },
  '.Y ': {
    id: 'wy',
    label: 'W-Y',
  },
  '.O ': {
    id: 'colony',
    label: 'Colony',
  },
  '.Z ': {
    id: 'highcom',
    label: 'HC',
  },
  '.K ': {
    id: 'sof',
    label: 'SOF',
  },
  '.Q ': {
    id: 'hive',
    label: 'Hive',
  },
  '#m ': {
    id: 'upp-med',
    label: 'UPP Med',
  },
  '#n ': {
    id: 'upp-engi',
    label: 'UPP Engi',
  },
  '#g ': {
    id: 'clf',
    label: 'clf',
  },
  '#v ': {
    id: 'upp-cmd',
    label: 'UPP Cmd.',
  },
  '#a ': {
    id: 'clf-med',
    label: 'CLF Med',
  },
  '#b ': {
    id: 'clf-engi',
    label: 'CLF Engi',
  },
  '#c ': {
    id: 'clf-cmd',
    label: 'CLF Cmd.',
  },
  '#d ': {
    id: 'clf-cct',
    label: 'CLF CCT',
  },
  '#e ': {
    id: 'pmc-engi',
    label: 'PMC Engi',
  },
  '#f ': {
    id: 'pmc-med',
    label: 'PMC Med',
  },
  '#p ': {
    id: 'pmc',
    label: 'PMC',
  },
  '#u ': {
    id: 'upp',
    label: 'UPP',
  },
  '#j ': {
    id: 'upp-cct',
    label: 'UPP CCT',
  },
  '#t ': {
    id: 'upp-kdo',
    label: 'UPP Kdo',
  },
  '#y ': {
    id: 'wy',
    label: 'W-Y',
  },
  '#o ': {
    id: 'pmc-cct',
    label: 'PMC CCT',
  },
  '#z ': {
    id: 'pmc-cmd',
    label: 'PMC Cmd.',
  },
  '#k ': {
    id: 'specops',
    label: 'SpecOps',
  },
  '#q ': {
    id: 'hive',
    label: 'Hive',
  },
  '#M ': {
    id: 'upp-med',
    label: 'UPP Med',
  },
  '#N ': {
    id: 'upp-engi',
    label: 'UPP Engi',
  },
  '#G ': {
    id: 'clf',
    label: 'clf',
  },
  '#V ': {
    id: 'upp-cmd',
    label: 'UPP Cmd.',
  },
  '#A ': {
    id: 'clf-med',
    label: 'CLF Med',
  },
  '#B ': {
    id: 'clf-engi',
    label: 'CLF Engi',
  },
  '#C ': {
    id: 'clf-cmd',
    label: 'CLF Cmd.',
  },
  '#D ': {
    id: 'clf-cct',
    label: 'CLF CCT',
  },
  '#E ': {
    id: 'pmc-engi',
    label: 'PMC Engi',
  },
  '#F ': {
    id: 'pmc-med',
    label: 'PMC Med',
  },
  '#P ': {
    id: 'pmc',
    label: 'PMC',
  },
  '#U ': {
    id: 'upp',
    label: 'UPP',
  },
  '#J ': {
    id: 'upp-cct',
    label: 'UPP CCT',
  },
  '#T ': {
    id: 'upp-kdo',
    label: 'UPP Kdo',
  },
  '#Y ': {
    id: 'wy',
    label: 'W-Y',
  },
  '#O ': {
    id: 'pmc-cct',
    label: 'PMC CCT',
  },
  '#Z ': {
    id: 'pmc-cmd',
    label: 'PMC Cmd.',
  },
  '#K ': {
    id: 'specops',
    label: 'SpecOps',
  },
  '#Q ': {
    id: 'hive',
    label: 'Hive',
  },
  ':W ': {
    id: 'whisper',
    label: 'Whisper',
  },
  '.W ': {
    id: 'whisper',
    label: 'Whisper',
  },
  '#W ': {
    id: 'whisper',
    label: 'Whisper',
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
  ':H ': {
    id: 'department',
    label: 'Depart.',
  },
  '.H ': {
    id: 'department',
    label: 'Depart.',
  },
  '#H ': {
    id: 'department',
    label: 'Depart.',
  },
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
  ':l ': {
    id: 'comms',
    label: 'L Hand',
  },
  '.l ': {
    id: 'comms',
    label: 'L Hand',
  },
  '#l ': {
    id: 'comms',
    label: 'L Hand',
  },
  ':L ': {
    id: 'comms',
    label: 'L Hand',
  },
  '.L ': {
    id: 'comms',
    label: 'L Hand',
  },
  '#L ': {
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
  '#r ': {
    id: 'comms',
    label: 'R Hand',
  },
  ':R ': {
    id: 'comms',
    label: 'R Hand',
  },
  '.R ': {
    id: 'comms',
    label: 'R Hand',
  },
  '#R ': {
    id: 'comms',
    label: 'R Hand',
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
  ':I ': {
    id: 'comms',
    label: 'Intercom',
  },
  '.I ': {
    id: 'comms',
    label: 'Intercom',
  },
  '#I ': {
    id: 'comms',
    label: 'Intercom',
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
