import { classes } from 'common/react';

import { Box } from '../components';
import { BoxProps } from '../components/Box';
interface CrtPanelProps extends BoxProps {
  readonly color: 'green' | 'yellow' | 'blue';
}
export const CrtPanel = (props: CrtPanelProps) => {
  return (
    <div className="panel-container">
      <Box
        className={classes([
          props.className,
          `panel-crt-${props.color}`,
          props.className,
        ])}
      >
        {props.children}
      </Box>
    </div>
  );
};
