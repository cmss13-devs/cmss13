import { classes } from 'common/react';
import type { ComponentProps } from 'react';
import { Box } from 'tgui/components';
interface CrtPanelProps extends ComponentProps<typeof Box> {
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
