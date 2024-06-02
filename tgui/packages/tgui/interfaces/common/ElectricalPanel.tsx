import { classes } from 'common/react';

import { useBackend } from '../../backend';
import { Box, Button, Flex, Icon, NoticeBox, Stack } from '../../components';
import { BoxProps } from '../../components/Box';
import { Table, TableRow } from '../../components/Table';

interface ElectricalData {
  electrical: MachineElectrical;
}

interface MachineElectrical {
  electrified: number;
  panel_open: number;
  wires: WireSpec[];
  powered: number;
}

interface WireSpec {
  desc: string;
  cut: number;
}

const ElectricalPanelClosed = (props: BoxProps) => {
  return (
    <NoticeBox
      className={classes([
        'PanelClosed',
        'ElectricalSafetySign',
        props.className,
      ])}
    >
      <Flex
        direction="row"
        justify="space-between"
        className="ElectricalSafetySign"
      >
        <Flex.Item grow>
          <Flex
            justify="space-between"
            direction="column"
            className={classes(['ElectricalSafetySign'])}
          >
            <Flex.Item>
              <Icon name="circle-xmark" />
            </Flex.Item>
            <Flex.Item>
              <Icon name="circle-xmark" />
            </Flex.Item>
          </Flex>
        </Flex.Item>
        <Flex.Item>
          <Flex
            justify="space-around"
            align="center"
            inline
            wrap
            className="WarningIcon"
            direction="column"
          >
            <Flex.Item>
              <Icon name="bolt" size={2} />
            </Flex.Item>
            <Flex.Item>
              <span>
                Electrical Hazard <br />
                Authorised Personnel Only
              </span>
            </Flex.Item>
          </Flex>
        </Flex.Item>
        <Flex.Item grow>
          <Flex
            justify="space-between"
            align="flex-end"
            direction="column"
            className={classes(['ElectricalSafetySign'])}
          >
            <Flex.Item>
              <Icon name="circle-xmark" />
            </Flex.Item>
            <Flex.Item>
              <Icon name="circle-xmark" />
            </Flex.Item>
          </Flex>
        </Flex.Item>
      </Flex>
    </NoticeBox>
  );
};

const WireControl = (props: {
  readonly wire: WireSpec;
  readonly index: number;
}) => {
  const { data, act } = useBackend<ElectricalData>();
  const target = props.index + 1;
  return (
    <Stack>
      <Stack.Item grow>{props.wire.desc}</Stack.Item>
      <Stack.Item pr={1}>
        <div
          className={classes([
            'led',
            props.wire.cut === 0 && 'led-green',
            props.wire.cut === 1 && 'led-red',
            data.electrical.powered === 1 && 'led-off',
          ])}
        />
      </Stack.Item>
      <Stack.Item>
        {props.wire.cut === 0 && (
          <Button
            icon="scissors"
            onClick={() => act('cutwire', { wire: target })}
            tooltip={'Cut'}
            tooltipPosition="left"
          />
        )}
        {props.wire.cut === 1 && (
          <Button
            icon="wrench"
            onClick={() => act('fixwire', { wire: target })}
            tooltip={'Fix'}
            tooltipPosition="left"
          />
        )}
      </Stack.Item>
      <Stack.Item>
        <Button
          icon="wave-square"
          disabled={props.wire.cut === 1}
          onClick={() => act('pulsewire', { wire: target })}
          tooltip={'Pulse'}
          tooltipPosition="left"
        />
      </Stack.Item>
    </Stack>
  );
};

const ElectricalPanelOpen = (props: BoxProps) => {
  const { data } = useBackend<ElectricalData>();
  return (
    <Box className={classes(['PanelOpen', props.className])}>
      <Flex
        direction="column"
        justify="space-between"
        fill={1}
        className="ElectricalSafetySign"
      >
        <Flex.Item>
          <Table className="WirePanel">
            {data.electrical.wires.map((x, index) => (
              <TableRow key={x.desc}>
                <WireControl wire={x} index={index} />
              </TableRow>
            ))}
          </Table>
        </Flex.Item>
        <Flex.Item>
          <NoticeBox className="OpenSafetySign" />
        </Flex.Item>
      </Flex>
    </Box>
  );
};

export const ElectricalPanel = (props: BoxProps) => {
  const { data } = useBackend<ElectricalData>();
  const isOpen = data.electrical.panel_open === 1;
  return (
    <div className={classes(['ElectricalAccessPanel', props.className])}>
      {!isOpen && <ElectricalPanelClosed />}
      {isOpen && <ElectricalPanelOpen />}
    </div>
  );
};
