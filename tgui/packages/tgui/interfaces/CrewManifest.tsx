import { useState } from 'react';

import { useBackend } from '../backend';
import { Icon, Input, Section, Table, Tooltip } from '../components';
import { TableCell, TableRow } from '../components/Table';
import { Window } from '../layouts';

type ManifestData = {
  departments_with_jobs: {
    [department: string]: string[];
  };
} & {
  [department: string]: Crew[];
};

type Crew = {
  name: string;
  rank: string;
  squad?: string | null;
  is_active: string;
};

export const CrewManifest = (props, context) => {
  const { act, data } = useBackend<ManifestData>();
  const [searchTerm, setSearchTerm] = useState('');

  if (!data || Object.keys(data).length === 0) {
    return <Section>No crew manifest available.</Section>;
  }

  const departmentOrder = [
    'Command',
    'Auxiliary',
    'Alpha',
    'Bravo',
    'Charlie',
    'Delta',
    'Echo',
    'Foxtrot',
    'Intel',
    'Marines',
    'Security',
    'Engineering',
    'Requisitions',
    'Medical',
    'Miscellaneous',
  ];

  const sortedDepartments = Object.entries(data)
    .filter(([key]) => key !== 'departments_with_jobs')
    .sort(([deptA], [deptB]) => {
      const indexA = departmentOrder.indexOf(deptA);
      const indexB = departmentOrder.indexOf(deptB);
      return (
        (indexA === -1 ? Infinity : indexA) -
        (indexB === -1 ? Infinity : indexB)
      );
    });

  return (
    <Window width={550} height={800}>
      <Window.Content className="CrewManifest" scrollable>
        <Section>
          <Input
            value={searchTerm}
            onInput={(_, value) => setSearchTerm(value.toLowerCase())}
            width="100%"
            placeholder="Search by name or rank..."
          />
        </Section>

        {/* Manifest Content */}
        {sortedDepartments.map(([department, crewList]) => {
          if (!Array.isArray(crewList) || crewList.length === 0) {
            return null;
          }

          const roleOrder = data.departments_with_jobs[department] || [];
          const supervisorRank = roleOrder[0];

          // Sort and filter crew list based on search term
          const filteredCrewList = [...crewList]
            .filter(
              (crew) =>
                crew.name.toLowerCase().includes(searchTerm) ||
                crew.rank.toLowerCase().includes(searchTerm),
            )
            .sort((a, b) => {
              const rankA = roleOrder.indexOf(a.rank);
              const rankB = roleOrder.indexOf(b.rank);
              return (
                (rankA === -1 ? Infinity : rankA) -
                (rankB === -1 ? Infinity : rankB)
              );
            });

          if (filteredCrewList.length === 0) {
            return null; // Don't display empty departments after filtering
          }

          return (
            <Section
              key={department}
              title={department}
              textAlign="center"
              className={
                'border-dept-' + department.toLowerCase().replace(/\s+/g, '-')
              }
              backgroundColor="rgba(10, 10, 10, 0.75)"
            >
              <Table>
                {filteredCrewList.map((crew, index) => (
                  <TableRow
                    key={crew.name}
                    bold={crew.rank === supervisorRank}
                    overflow="hidden"
                    className={index % 2 === 0 ? 'row-even' : 'row-odd'}
                  >
                    <TableCell
                      width="50%"
                      textAlign="left"
                      pt="5px"
                      pb="5px"
                      pl="10px"
                      nowrap
                    >
                      {crew.name}
                    </TableCell>
                    <TableCell
                      width="45%"
                      textAlign="right"
                      pr="2%"
                      pt="5px"
                      pb="5px"
                      nowrap
                    >
                      {crew.rank}
                    </TableCell>
                    <TableCell
                      textAlign="right"
                      width="5%"
                      pr="5px"
                      pt="5px"
                      pb="5px"
                      pl="10px"
                    >
                      <Tooltip content={crew.is_active}>
                        <Icon
                          name="circle"
                          className={
                            'manifest-indicator-' +
                            crew.is_active
                              .toLowerCase()
                              .replace(/\*/g, '')
                              .replace(/\s/g, '-')
                              .replace(/:.*?$/, '')
                          }
                        />
                      </Tooltip>
                    </TableCell>
                  </TableRow>
                ))}
              </Table>
            </Section>
          );
        })}
      </Window.Content>
    </Window>
  );
};
