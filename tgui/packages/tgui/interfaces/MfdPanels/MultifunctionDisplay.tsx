import { classes } from 'common/react';
import { ReactNode } from 'react';

import { useBackend } from '../../backend';
import { Button, Flex } from '../../components';
import { Table, TableCell, TableRow } from '../../components/Table';
import { CrtPanel } from '../CrtPanel';
import { ButtonProps } from './types';

export interface MfdProps {
  readonly panelStateId: string; // eslint-disable-line
  readonly topButtons?: Array<ButtonProps>;
  readonly leftButtons?: Array<ButtonProps>;
  readonly rightButtons?: Array<ButtonProps>;
  readonly bottomButtons?: Array<ButtonProps>;
  readonly children?: ReactNode;
  readonly otherPanelStateId?: string; // eslint-disable-line
}

export const MfdButton = (props: ButtonProps) => {
  const { act } = useBackend();
  return (
    <Button
      onClick={() => {
        act('button_push');
        if (props.onClick) {
          props.onClick();
        }
      }}
      className={classes([
        props.children && 'mfd_button_active',
        !props.children && 'mfd_button',
      ])}
    >
      {props.children}
    </Button>
  );
};

export const EmptyMfdButton = () => {
  return <MfdButton />;
};

export const HorizontalPanel = (props: {
  readonly buttons: Array<ButtonProps>;
}) => {
  return (
    <Flex
      justify="center"
      align="space-evenly"
      className="HorizontalButtonPanel"
    >
      {props.buttons.map((x, i) => (
        <Flex.Item key={i}>
          {x ? <MfdButton {...x} /> : <EmptyMfdButton />}
        </Flex.Item>
      ))}
    </Flex>
  );
};

export const VerticalPanel = (props: {
  readonly buttons?: Array<ButtonProps>;
}) => {
  return (
    <Flex
      direction="column"
      justify="center"
      align="space-evenly"
      className="VerticalButtonPanel"
    >
      {props.buttons?.map((x, i) => (
        <Flex.Item key={i}>
          {x ? <MfdButton {...x} /> : <EmptyMfdButton />}
        </Flex.Item>
      ))}
    </Flex>
  );
};

const HexScrew = () => {
  return (
    <svg viewBox="0 0 10 10" width="30px" height="30px">
      <circle
        cx="5"
        cy="5"
        r="4"
        fill="#202020"
        stroke="#505050"
        strokeWidth="0.5"
      />
      <polygon
        points="3.5,2.5 6.5,2.5 8,5 6.5,7.5 3.5,7.5 2,5"
        fill="#040404"
      />
    </svg>
  );
};

export const MfdPanel = (props: MfdProps) => {
  const topProps = props.topButtons ?? [];
  const botProps = props.bottomButtons ?? [];
  const leftProps = props.leftButtons ?? [];
  const rightProps = props.rightButtons ?? [];

  const topButtons = Array.from({ length: 5 }).map((_, i) => topProps[i] ?? {});
  const bottomButtons = Array.from({ length: 5 }).map(
    (_, i) => botProps[i] ?? {},
  );
  const leftButtons = Array.from({ length: 5 }).map(
    (_, i) => leftProps[i] ?? {},
  );
  const rightButtons = Array.from({ length: 5 }).map(
    (_, i) => rightProps[i] ?? {},
  );
  return (
    <Table className="primarypanel">
      <TableRow>
        <TableCell className={classes(['Screw_cell_top', 'Screw_cell_left'])}>
          <HexScrew />
        </TableCell>
        <TableCell>
          <HorizontalPanel buttons={topButtons} />
        </TableCell>
        <TableCell className={classes(['Screw_cell_top', 'Screw_cell_right'])}>
          <HexScrew />
        </TableCell>
      </TableRow>
      <TableRow>
        <TableCell>
          <VerticalPanel buttons={leftButtons} />
        </TableCell>
        <TableCell>
          <CrtPanel color="green" className="displaypanel">
            {props.children}
          </CrtPanel>
        </TableCell>
        <TableCell>
          <VerticalPanel buttons={rightButtons} />
        </TableCell>
      </TableRow>
      <TableRow>
        <TableCell className={classes(['Screw_cell_bot', 'Screw_cell_left'])}>
          <HexScrew />
        </TableCell>
        <TableCell>
          <HorizontalPanel buttons={bottomButtons} />
        </TableCell>
        <TableCell className={classes(['Screw_cell_bot', 'Screw_cell_right'])}>
          <HexScrew />
        </TableCell>
      </TableRow>
    </Table>
  );
};
