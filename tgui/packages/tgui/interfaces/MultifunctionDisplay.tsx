import { useBackend } from '../backend';
import { Button, Flex } from '../components';
import { CrtPanel } from './CrtPanel';
import { Table, TableCell, TableRow } from '../components/Table';
import { InfernoNode } from 'inferno';

export type ButtonProps = {
  children?: InfernoNode;
  onClick?: () => void;
};

interface ButtonPanelProps {
  button1?: ButtonProps;
  button2?: ButtonProps;
  button3?: ButtonProps;
  button4?: ButtonProps;
  button5?: ButtonProps;
}

interface MfdProps {
  topPanel?: ButtonPanelProps;
  bottomPanel?: ButtonPanelProps;
  leftPanel?: ButtonPanelProps;
  rightPanel?: ButtonPanelProps;
  children?: Node;
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

export const HorizontalPanel = (props?: ButtonPanelProps, context) => {
  const arr = [
    props?.button1,
    props?.button2,
    props?.button3,
    props?.button4,
    props?.button5,
  ];
  return (
    <Flex
      justify="center"
      align="space-evenly"
      className="HorizontalButtonPanel">
      {arr.map((x, i) => (
        <Flex.Item key={i}>
          {x ? <MfdButton {...x} /> : <EmptyMfdButton />}
        </Flex.Item>
      ))}
    </Flex>
  );
};

export const VerticalPanel = (props?: ButtonPanelProps, context) => {
  const arr = [
    props?.button1,
    props?.button2,
    props?.button3,
    props?.button4,
    props?.button5,
  ];
  return (
    <Flex
      direction="column"
      justify="center"
      align="space-evenly"
      className="VerticalButtonPanel">
      {arr.map((x, i) => (
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
          <HorizontalPanel {...props.topPanel} />
        </TableCell>
        <TableCell />
      </TableRow>
      <TableRow>
        <TableCell>
          <VerticalPanel {...props.leftPanel} />
        </TableCell>
        <TableCell>
          <CrtPanel color="green" className="displaypanel">
            {props.children}
          </CrtPanel>
        </TableCell>
        <TableCell>
          <VerticalPanel {...props.rightPanel} />
        </TableCell>
      </TableRow>
      <TableRow>
        <TableCell />
        <TableCell>
          <HorizontalPanel {...props.bottomPanel} />
        </TableCell>
        <TableCell />
      </TableRow>
    </Table>
  );
};
