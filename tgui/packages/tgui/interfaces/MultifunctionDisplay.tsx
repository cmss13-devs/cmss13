import { useBackend } from '../backend';
import { Button, Flex } from '../components';
import { CrtPanel } from './CrtPanel';
import { Table, TableCell, TableRow } from '../components/Table';
import { InfernoNode } from 'inferno';

export interface ButtonProps {
  children?: InfernoNode;
  onClick?: () => void;
}

export interface FullButtonProps extends ButtonProps {
  location: 'top' | 'bottom' | 'left' | 'right';
}

interface MfdProps {
  topPanel?: Array<ButtonProps>;
  bottomPanel?: Array<ButtonProps>;
  leftPanel?: Array<ButtonProps>;
  rightPanel?: Array<ButtonProps>;
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

const EmptyMfdButton = () => {
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

export const MfdPanel = (props: MfdProps, context) => {
  return (
    <Table className="primarypanel">
      <TableRow>
        <TableCell />
        <TableCell>
          <HorizontalPanel buttons={props.topPanel ?? []} />
        </TableCell>
        <TableCell />
      </TableRow>
      <TableRow>
        <TableCell>
          <VerticalPanel buttons={props.leftPanel ?? []} />
        </TableCell>
        <TableCell>
          <CrtPanel color="green" className="displaypanel">
            {props.children}
          </CrtPanel>
        </TableCell>
        <TableCell>
          <VerticalPanel buttons={props.rightPanel ?? []} />
        </TableCell>
      </TableRow>
      <TableRow>
        <TableCell />
        <TableCell>
          <HorizontalPanel buttons={props.bottomPanel ?? []} />
        </TableCell>
        <TableCell />
      </TableRow>
    </Table>
  );
};
