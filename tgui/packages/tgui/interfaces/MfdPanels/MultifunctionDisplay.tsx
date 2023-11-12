import { useBackend } from '../../backend';
import { Button, Flex } from '../../components';
import { CrtPanel } from '../CrtPanel';
import { Table, TableCell, TableRow } from '../../components/Table';
import { InfernoNode } from 'inferno';
import { ButtonProps } from './types';

export interface MfdProps {
  panelStateId: string;
  topButtons?: Array<ButtonProps>;
  leftButtons?: Array<ButtonProps>;
  rightButtons?: Array<ButtonProps>;
  bottomButtons?: Array<ButtonProps>;
  children?: InfernoNode;
}

export const MfdButton = (props: ButtonProps, context) => {
  const { act } = useBackend(context);
  return (
    <Button
      onClick={() => {
        act('button_push');
        if (props.onClick) {
          props.onClick();
        }
      }}
      className="mfd_button">
      {props.children}
    </Button>
  );
};

export const EmptyMfdButton = () => {
  return <MfdButton />;
};

export const HorizontalPanel = (
  props: { buttons: Array<ButtonProps> },
  context
) => {
  return (
    <Flex
      justify="center"
      align="space-evenly"
      className="HorizontalButtonPanel">
      {props.buttons.map((x, i) => (
        <Flex.Item key={i}>
          {x ? <MfdButton {...x} /> : <EmptyMfdButton />}
        </Flex.Item>
      ))}
    </Flex>
  );
};

export const VerticalPanel = (
  props: { buttons?: Array<ButtonProps> },
  context
) => {
  return (
    <Flex
      direction="column"
      justify="center"
      align="space-evenly"
      className="VerticalButtonPanel">
      {props.buttons?.map((x, i) => (
        <Flex.Item key={i}>
          {x ? <MfdButton {...x} /> : <EmptyMfdButton />}
        </Flex.Item>
      ))}
    </Flex>
  );
};

export const MfdPanel = (props: MfdProps) => {
  const topProps = props.topButtons ?? [];
  const botProps = props.bottomButtons ?? [];
  const leftProps = props.leftButtons ?? [];
  const rightProps = props.rightButtons ?? [];

  const topButtons = Array.from({ length: 5 }).map((_, i) => topProps[i] ?? {});
  const bottomButtons = Array.from({ length: 5 }).map(
    (_, i) => botProps[i] ?? {}
  );
  const leftButtons = Array.from({ length: 5 }).map(
    (_, i) => leftProps[i] ?? {}
  );
  const rightButtons = Array.from({ length: 5 }).map(
    (_, i) => rightProps[i] ?? {}
  );
  return (
    <Table className="primarypanel">
      <TableRow>
        <TableCell />
        <TableCell>
          <HorizontalPanel buttons={topButtons} />
        </TableCell>
        <TableCell />
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
        <TableCell />
        <TableCell>
          <HorizontalPanel buttons={bottomButtons} />
        </TableCell>
        <TableCell />
      </TableRow>
    </Table>
  );
};
