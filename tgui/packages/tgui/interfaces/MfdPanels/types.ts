import type { ReactNode } from 'react';

import type { DropshipEquipment } from '../DropshipWeaponsConsole';

export interface ButtonProps {
  children?: ReactNode;
  onClick?: () => void;
}

export type LazeTarget = {
  target_name: string;
  target_tag: number;
};

export type TargetContext = {
  targets_data: Array<LazeTarget>;
};

export type FultonProps = {
  fulton_targets: Array<string>;
  equipment_data: Array<DropshipEquipment>;
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

export type CameraProps = {
  camera_map_ref?: string;
};

export type EquipmentContext = {
  equipment_data: Array<DropshipEquipment>;
};

export type MedevacContext = {
  medevac_targets: Array<MedevacTargets>;
  equipment_data: Array<DropshipEquipment>;
};

export type FiremissionContext = {
  firemission_data: Array<CasFiremission>;
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
  deployed: 0 | 1;
  auto_deploy: 0 | 1;
};

export type SpotlightSpec = {
  name: string;
};

export type ParadropSpec = {
  signal: string | null;
  locked: 0 | 1;
};

export type MGSpec = {
  name: string;
  health: number;
  health_max: number;
  rounds: number;
  max_rounds: number;
  deployed: 0 | 1;
  auto_deploy: 0 | 1;
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

export type MapProps = {
  tactical_map_ref: string;
};

export const dirMap = (dir) => {
  switch (dir) {
    case 'NORTH':
      return 1;
    case 'SOUTH':
      return 2;
    case 'EAST':
      return 4;
    case 'WEST':
      return 8;
  }
};
