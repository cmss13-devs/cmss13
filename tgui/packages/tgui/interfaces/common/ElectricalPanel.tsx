import { classes } from 'common/react';
import { useBackend } from '../../backend';
import { Box, Button, Icon, Flex, NoticeBox } from '../../components';
import { BoxProps } from '../../components/Box';
import { Table, TableCell, TableRow } from '../../components/Table';

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

const ElectricalPanelClosed = (props: BoxProps, context) => {
  return (
    <NoticeBox
      className={classes([
        'PanelClosed',
        'ElectricalSafetySign',
        props.className,
      ])}>
      <Flex
        direction="row"
        justify="space-between"
        fill
        className="ElectricalSafetySign">
        <Flex.Item grow>
          <Flex
            justify="space-between"
            direction="column"
            fill
            className={classes(['ElectricalSafetySign'])}>
            <Flex.Item>
              <Icon name="circle-xmark" />
            </Flex.Item>
            <Flex.Item>
              <Icon name="circle-xmark" />
            </Flex.Item>
          </Flex>
        </Flex.Item>
        <Flex.Item fill>
          <Flex
            justify="space-around"
            align="center"
            inline
            fill
            wrap
            className="WarningIcon"
            direction="column">
            <Flex.Item>
              <Icon name="bolt" size={2} />
            </Flex.Item>
            <Flex.Item>
              <span>
                Electrical hazard <br />
                Authorised personnel only
              </span>
            </Flex.Item>
          </Flex>
        </Flex.Item>
        <Flex.Item grow>
          <Flex
            justify="space-between"
            align="flex-end"
            direction="column"
            fill
            className={classes(['ElectricalSafetySign'])}>
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

const WireControl = (props: { wire: WireSpec; index: number }, context) => {
  const { data, act } = useBackend<ElectricalData>(context);
  const target = props.index + 1;
  return (
    <>
      <TableCell>{props.wire.desc}</TableCell>
      <TableCell>
        <div
          className={classes([
            'led',
            props.wire.cut === 0 && 'led-green',
            props.wire.cut === 1 && 'led-red',
            data.electrical.powered === 1 && 'led-off',
          ])}
        />
      </TableCell>
      <TableCell>
        {props.wire.cut === 0 && (
          <Button
            icon="scissors"
            onClick={() => act('cutwire', { wire: target })}
          />
        )}
        {props.wire.cut === 1 && (
          <Button
            icon="wrench"
            onClick={() => act('fixwire', { wire: target })}
          />
        )}
      </TableCell>
      <TableCell>
        <Button
          icon="wave-square"
          disabled={props.wire.cut === 1}
          onClick={() => act('pulsewire', { wire: target })}
        />
      </TableCell>
    </>
  );
};

const ElectricalPanelOpen = (props: BoxProps, context) => {
  const { data } = useBackend<ElectricalData>(context);
  return (
    <Box className={classes(['PanelOpen', props.className])}>
      <Flex
        direction="column"
        justify="space-between"
        fill
        className="ElectricalSafetySign">
        <Flex.Item>
          <Table vertical className="WirePanel">
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

export const ElectricalPanel = (props: BoxProps, context) => {
  const { data } = useBackend<ElectricalData>(context);
  const isOpen = data.electrical.panel_open === 1;
  return (
    <div className={classes(['ElectricalAccessPanel', props.className])}>
      {!isOpen && <ElectricalPanelClosed />}
      {isOpen && <ElectricalPanelOpen />}
    </div>
  );
};
