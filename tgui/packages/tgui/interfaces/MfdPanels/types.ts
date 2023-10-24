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
