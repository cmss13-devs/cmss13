export type BackendContext = {
  records: SecurityRecord[];
  active_record: ActiveRecord;
  assigned_view: String;
  wanted_statuses: string[];
  prints: Print[];
};

// Basic info for all records.
export type SecurityRecord = {
  ref: string;
  name: string;
  rank: string;
  criminal_status: string;
};

// Detailed info for selected record.
export type ActiveRecord = {
  name: string;
  ref: string;
  criminal_status: string;
  id: string;
  rank: string;
  sex: string;
  age: number;
  physical_status: string;
  mental_status: string;
  comments: Comment[];
  incidents: Incident[];
};

// Lazy type union for searching function.
export type GenericRecord = {
  name: string;
  rank: string;
};

export type Comment = {
  entry: string;
  created_by_name: string;
  created_by_rank: string;
  created_at: string;
  deleted_by: string;
  deleted_at: string;
};

export type Incident = {
  crimes: string[];
  summary: string;
};

export type Print = {
  name: string;
  desc: string;
  rank: string;
};
