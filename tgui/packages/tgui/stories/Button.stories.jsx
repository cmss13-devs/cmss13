/**
 * @file
 * @copyright 2021 Aleksej Komarov
 * @license MIT
 */

import { Box, Button, Section } from '../components';

export const meta = {
  title: 'Button',
  render: () => <Story />,
};

const COLORS_SPECTRUM = [
  'red',
  'orange',
  'yellow',
  'olive',
  'green',
  'teal',
  'blue',
  'violet',
  'purple',
  'pink',
  'brown',
  'grey',
];

const COLORS_STATES = ['good', 'average', 'bad', 'black', 'white'];

const Story = (props) => {
  return (
    <Section>
      <Box mb={1}>
        <Button>Simple</Button>
        <Button selected>Selected</Button>
        <Button altSelected>Alt Selected</Button>
        <Button disabled>Disabled</Button>
        <Button color="transparent">Transparent</Button>
        <Button icon="cog">Icon</Button>
        <Button icon="power-off" />
        <Button fluid>Fluid</Button>
        <Button my={1} lineHeight={2} minWidth={15} textAlign="center">
          With Box props
        </Button>
      </Box>
      <Box mb={1}>
        {COLORS_STATES.map((color) => (
          <Button key={color} color={color}>
            {color}
          </Button>
        ))}
        <br />
        {COLORS_SPECTRUM.map((color) => (
          <Button key={color} color={color}>
            {color}
          </Button>
        ))}
        <br />
        {COLORS_SPECTRUM.map((color) => (
          <Box inline mx="7px" key={color} color={color}>
            {color}
          </Box>
        ))}
      </Box>
    </Section>
  );
};
