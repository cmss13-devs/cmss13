/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { classes } from 'common/react';
import type { ComponentProps } from 'react';
import { useBackend } from 'tgui/backend';
import { Box } from 'tgui/components';
import { useDebug } from 'tgui/debug';

import { Layout } from './Layout';

type Props = Partial<{
  theme: string;
}> &
  ComponentProps<typeof Box>;

export function Pane(props: Props) {
  const { theme, children, className, ...rest } = props;
  const { suspended } = useBackend();
  const { debugLayout = false } = useDebug();

  return (
    <Layout className={classes(['Window', className])} theme={theme} {...rest}>
      <Box fillPositionedParent className={debugLayout && 'debug-layout'}>
        {!suspended && children}
      </Box>
    </Layout>
  );
}

type ContentProps = Partial<{
  fitted: boolean;
  scrollable: boolean;
}> &
  ComponentProps<typeof Box>;

function PaneContent(props: ContentProps) {
  const { className, fitted, children, ...rest } = props;

  return (
    <Layout.Content
      className={classes(['Window__content', className])}
      {...rest}
    >
      {fitted ? (
        children
      ) : (
        <div className="Window__contentPadding">{children}</div>
      )}
    </Layout.Content>
  );
}

Pane.Content = PaneContent;
