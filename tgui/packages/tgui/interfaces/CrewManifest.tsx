import { useBackend } from '../backend';
import { Icon, Section, Table, Tooltip } from '../components';
import { TableCell, TableRow } from '../components/Table';
import { Window } from '../layouts';

type ManifestData = {
  [department: string]: Crew[]; // Dynamic keys for each department
};

type Crew = {
  name: string;
  rank: string;
  squad?: string | null;
  is_active: string;
};

export const CrewManifest = (props, context) => {
  const { act, data, staticData } = useBackend<ManifestData>();

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

  // Sort departments based on the predefined order
  const sortedDepartments = Object.entries(data).sort(([deptA], [deptB]) => {
    const indexA = departmentOrder.indexOf(deptA);
    const indexB = departmentOrder.indexOf(deptB);

    // Departments not in the predefined order appear at the end
    return (
      (indexA === -1 ? Infinity : indexA) - (indexB === -1 ? Infinity : indexB)
    );
  });

  // Get the role order for sorting crew within each department
  const getRoleOrder = (department: string): string[] => {
    // Replace with actual role order from staticData if provided
    const defaultRoleOrder =
      staticData?.departments_with_jobs?.[department] || [];
    return defaultRoleOrder;
  };

  // Render each department as its own section
  return (
    <Window width={500} height={700}>
      <Window.Content className="CrewManifest">
        <Section>
          {sortedDepartments.map(([department, crewList]) => {
            if (!Array.isArray(crewList) || crewList.length === 0) {
              return null;
            }

            // Sort crew within the department based on role order
            const roleOrder = getRoleOrder(department);
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
                      bold={false} // Adjust based on logic for "head" or supervisors
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
                                .replace(/\*/g, '') // Removes asterisks
                                .replace(/\s/g, '-') // Replaces spaces with dashes
                                .replace(/:.*?$/, '') // Removes everything after a colon
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
