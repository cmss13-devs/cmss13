import { BooleanLike } from '../../../common/react';
import { useBackend } from '../../backend';
import { Button, Icon, Section, Table, Tooltip } from '../../components';
import { TableCell, TableRow } from '../../components/Table';

type ManifestData = {
  Command?: Crew[];
  Auxiliary?: Crew[];
  Security?: Crew[];
  Engineering?: Crew[];
  Requisition?: Crew[];
  Medical?: Crew[];
  Marines?: Crew[];
  Miscellaneous?: Crew[];
  OOC_status: BooleanLike;
};

type Crew = {
  name: string;
  rank: string;
  squad?: string | null;
  is_active: string;
};

export const ManifestSection = (props, context) => {
  const { act, data } = useBackend<ManifestData>();

  // Remove OOC_status from the department list
  const manifestDepartments = Object.keys(data).filter(
    key => key !== 'OOC_status'
  );

  return (
    <Section>
      {manifestDepartments.length === 0 && 'There are no crew active.'}
      {manifestDepartments.map((dept) => {
        const deptCrew = data[dept];
        if (!deptCrew || deptCrew.length === 0) {
          return null;
        }
        return (
          <Section
            key={dept}
            title={dept}
            textAlign="center"
            className={'border-dept-' + dept.toLowerCase()}
            backgroundColor="rgba(10, 10, 10, 0.75)">
            <Table>
              {deptCrew.map((crewmate) => {
                return (
                  <TableRow
                    key={crewmate.name}
                    bold={false} // Set to true if there's a condition for 'head'
                    overflow="hidden">
                    <TableCell width="50%" textAlign="center" pt="10px" nowrap>
                      {crewmate.name}
                    </TableCell>
                    <TableCell
                      width="45%"
                      textAlign="right"
                      pr="2%"
                      pt="10px"
                      nowrap>
                      {crewmate.rank}
                    </TableCell>
                    <TableCell textAlign="right" width="5%" pr="3%" pt="10px">
                      <Tooltip content={crewmate.is_active}>
                        <Icon
                          name="circle"
                          className={
                            'manifest-indicator-' +
                            crewmate.is_active
                              .toLowerCase()
                              .replace(/\*/g, '') // removes asterisks
                              .replace(/\s/g, '-') // replaces spaces with a dash
                              .replace(/:.*?$/, '') // matches and removes : to the end of the string
                          }
                        />
                      </Tooltip>
                    </TableCell>
                    {data.OOC_status ? (
                      <TableCell textAlign="right">
                        <Tooltip content="Follow Mob">
                          <Button
                            content="F"
                            onClick={() =>
                              act('follow', { name: crewmate.name })
                            }
                          />
                        </Tooltip>
                      </TableCell>
                    ) : (
                      ''
                    )}
                  </TableRow>
                );
              })}
            </Table>
          </Section>
        );
      })}
    </Section>
  );
};
