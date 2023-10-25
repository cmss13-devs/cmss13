type LazeTarget = {
  target_name: string;
  target_tag: number;
};

type MedevacTargets = {
  area: string;
  occupant: string;
  ref: string;
  triage_card?: string;
  damage?: {
    hp: number;
    brute: number;
    oxy: number;
    tox: number;
    fire: number;
    undefib: number;
  };
};

type SentrySpec = {
  rounds?: number;
  max_rounds?: number;
  name: string;
  area: string;
  active: 0 | 1;
  index: number;
  engaged?: number;
  nickname: string;
  health: number;
  health_max: number;
  kills: number;
  iff_status: string[];
  camera_available: number;
  deployed: number;
};

type MGSpec = {
  name: string;
  health: number;
  health_max: number;
  rounds: number;
  max_rounds: number;
  deployed: 0 | 1;
};
