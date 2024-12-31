import { useBackend } from '../backend';
import { Icon, Section, Table, Tooltip } from '../components';
import { TableCell, TableRow } from '../components/Table';
import { Window } from '../layouts';

type ManifestData = {
  departments_with_jobs: {
    [department: string]: string[]; // Role order for each department
  };
} & {
  [department: string]: Crew[]; // Dynamic keys for departments
};

type Crew = {
  name: string;
  rank: string;
  squad?: string | null;
  is_active: string;
};

export const CrewManifest = (props, context) => {
  const { act, data } = useBackend<ManifestData>();

  if (!data || Object.keys(data).length === 0) {
    return <Section>No crew manifest available.</Section>;
  }

  const departmentOrder = [
    'Command',
    'Auxiliary',
    'Security',
    'Alpha',
    'Bravo',
    'Charlie',
    'Delta',
    'Echo',
    'Foxtrot',
    'Intel',
    'Marines',
    'Engineering',
    'Requisitions',
    'Medical',
    'Miscellaneous',
  ];

  // Sort departments based on the predefined order, excluding "departments_with_jobs"
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
    <Window width={500} height={700}>
      <Window.Content className="CrewManifest">
        <Section>
          {sortedDepartments.map(([department, crewList]) => {
            if (!Array.isArray(crewList) || crewList.length === 0) {
              return null;
            }

            // Get the role order for this department
            const roleOrder = data.departments_with_jobs[department] || [];

            const supervisorRank = roleOrder[0];

            // Crew sorting
            const sortedCrewList = [...crewList].sort((a, b) => {
              const rankA = roleOrder.indexOf(a.rank);
              const rankB = roleOrder.indexOf(b.rank);
              return (
                (rankA === -1 ? Infinity : rankA) -
                (rankB === -1 ? Infinity : rankB)
              );
            });

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
                  {sortedCrewList.map((crew) => (
                    <TableRow
                      key={crew.name}
                      bold={crew.rank === supervisorRank}
                      overflow="hidden"
                    >
                      <TableCell
                        width="50%"
                        textAlign="center"
                        pt="10px"
                        nowrap
                      >
                        {crew.name}
                      </TableCell>
                      <TableCell
                        width="45%"
                        textAlign="right"
                        pr="2%"
                        pt="10px"
                        nowrap
                      >
                        {crew.rank}
                      </TableCell>
                      <TableCell textAlign="right" width="5%" pr="3%" pt="10px">
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
        </Section>
      </Window.Content>
    </Window>
  );
};
