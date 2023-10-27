export type LazeTarget = {
  target_name: string;
  target_tag: number;
};

export type MedevacTargets = {
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

export type SentrySpec = {
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

export type MGSpec = {
  name: string;
  health: number;
  health_max: number;
  rounds: number;
  max_rounds: number;
  deployed: 0 | 1;
};

export type CasFiremissionStage = {
  weapon: number;
  offsets: Array<string>;
};

export type CasFiremission = {
  name: string;
  mission_length: number;
  records: Array<CasFiremissionStage>;
  mission_tag: number;
};
