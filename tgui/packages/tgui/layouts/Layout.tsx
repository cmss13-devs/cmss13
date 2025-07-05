/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { classes } from 'common/react';
import { type ComponentProps, useEffect, useRef } from 'react';
import {
  type Box,
  computeBoxClassName,
  computeBoxProps,
} from 'tgui/components/Box';
import { addScrollableNode, removeScrollableNode } from 'tgui/events';

type Props = Partial<{
  theme: string;
}> &
  ComponentProps<typeof Box>;

export function Layout(props: Props) {
  const { className, theme = 'weyland_yutani', children, ...rest } = props;
  document.documentElement.className = `theme-${theme}`;

  return (
    <div className={'theme-' + theme}>
      <div
        className={classes(['Layout', className, computeBoxClassName(rest)])}
        {...computeBoxProps(rest)}
      >
        {children}
      </div>
    </div>
  );
}

type ContentProps = Partial<{
  scrollable: boolean;
}> &
  ComponentProps<typeof Box>;

function LayoutContent(props: ContentProps) {
  const { className, scrollable, children, ...rest } = props;
  const node = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const self = node.current;

    if (self && scrollable) {
      addScrollableNode(self);
    }
    return () => {
      if (self && scrollable) {
        removeScrollableNode(self);
      }
    };
  }, []);

  return (
    <div
      className={classes([
        'Layout__content',
        scrollable && 'Layout__content--scrollable',
        className,
        computeBoxClassName(rest),
      ])}
      ref={node}
      {...computeBoxProps(rest)}
    >
      {children}
    </div>
  );
}

Layout.Content = LayoutContent;
