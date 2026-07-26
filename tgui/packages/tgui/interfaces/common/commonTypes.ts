export type DataCoreData = {
  alert_level: number;
  evac_status: number;
  worldtime: number;
  ares_access_log: string[];
  apollo_access_log: string[];
  apollo_log: string[];
  distresstime: number;
  distresstimelock: number;
  quarterstime: number;
  mission_failed: boolean;
  nuketimelock: number;
  nuke_available: boolean;
  records_announcement: CustomRecord[];
  records_security: CustomRecord[];
  records_flight: CustomUserRecord[];
  records_bioscan: CustomRecord[];
  records_bombardment: CustomUserRecord[];
  records_deletion: CustomUserRecord[];
  deleted_discussions: BasicRecord[];
  records_requisition: CustomUserRecord[];
  records_tech: TechRecord[];
  records_discussions: DiscussionRecord[];
  security_vents: VentRecord[];
  maintenance_tickets: MaintTicketRecord[];
  access_tickets: AccessTicketRecord[];
  faction_options: string[];
  sentry_setting: string;
};

type MaintTicketRecord = {
  id: string;
  time: number;
  priority_status: boolean;
  category: string;
  details: string;
  status: string;
  submitter: string;
  assignee: string;
  lock_status: string;
  ref: string;
};

type AccessTicketRecord = {
  id: string;
  time: number;
  priority_status: boolean;
  title: string;
  details: string;
  status: string;
  submitter: string;
  assignee: string;
  lock_status: string;
  ref: string;
};

export type VentRecord = { vent_tag: string; ref: string; available: boolean };

type DiscussionRecord = BasicRecord & {
  user: string;
  conversation: string;
};

type TechRecord = {
  time: number;
  details: string;
  user: string;
  ref: string;
  tier_changer: number;
};

type BasicRecord = {
  time: number;
  title: string;
  ref: string;
};

type CustomRecord = BasicRecord & {
  details: string;
};

type CustomUserRecord = CustomRecord & {
  user: string;
};
