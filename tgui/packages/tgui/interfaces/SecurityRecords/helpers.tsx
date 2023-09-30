import type { GenericRecord } from './types';

/** Matches search by name or rank */
export const isRecordMatch = (record: GenericRecord, search: string) => {
  if (!search) return true;
  const { name, rank } = record;

  switch (true) {
    case name?.toLowerCase().includes(search?.toLowerCase()):
    case rank?.toLowerCase().includes(search?.toLowerCase()):
      return true;

    default:
      return false;
  }
};
