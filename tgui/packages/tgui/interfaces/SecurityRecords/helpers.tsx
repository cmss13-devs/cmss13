import type { GenericRecord } from './types';

/** Matches search by name or rank */
export const isRecordMatch = (record: GenericRecord, search: string) => {
  if (!search) return true;
  const { name, rank } = record;
  const searchString = search?.toLowerCase();

  if (name?.toLowerCase().includes(searchString)) {
    return true;
  }

  if (rank?.toLowerCase().includes(searchString)) {
    return true;
  }

  return false;
};
