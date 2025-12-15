import { debounce } from 'common/timer';
import { useEffect, useRef } from 'react';

import { type BoxProps, computeBoxProps } from './Box';

type ByondUiElement = {
  render: (params: Record<string, any>) => void;
  unmount: () => void;
};

type BoundingBox = {
  pos: number[];
  size: number[];
};

type SampleByondParams = Partial<{
  /** Can be auto-generated. */
  id: string;
  /**  Defaults to the current window */
  parent: string;
  /** The type of control. Read-only. */
  type: string;
  /** Text shown in label/button/input. For input controls this setting is only available at runtime. */
  text: string;
}>;

type Props = Partial<{
  /** An object with parameters, which are directly passed to
   * the `winset` proc call.
   *
   * You can find a full reference of these parameters
   * in [BYOND controls and parameters guide](https://secure.byond.com/docs/ref/skinparams.html). */
  params: SampleByondParams & Record<string, any>;
}> &
  BoxProps;

// Stack of currently allocated BYOND UI element ids.
const byondUiStack: Array<string | null> = [];

function createByondUiElement(elementId: string | undefined): ByondUiElement {
  // Reserve an index in the stack
  const index = byondUiStack.length;
  byondUiStack.push(null);
  // Get a unique id
  const id = elementId || `byondui_${index}`;

  // Return a control structure
  return {
    render: (params: SampleByondParams) => {
      byondUiStack[index] = id;

      Byond.winset(id, { ...params, style: Byond.styleSheet });
    },
    unmount: () => {
      byondUiStack[index] = null;
      Byond.winset(id, {
        parent: '',
      });
    },
  } as ByondUiElement;
}

window.addEventListener('beforeunload', () => {
  // Cleanly unmount all visible UI elements
  for (let index = 0; index < byondUiStack.length; index++) {
    const id = byondUiStack[index];
    if (typeof id === 'string') {
      byondUiStack[index] = null;
      Byond.winset(id, {
        parent: '',
      });
    }
  }
});

/**
 * Get the bounding box of the DOM element in display-pixels.
 */
function getBoundingBox(element: HTMLDivElement): BoundingBox {
  const pixelRatio = window.devicePixelRatio ?? 1;
  const rect = element.getBoundingClientRect();

  return {
    pos: [rect.left * pixelRatio, rect.top * pixelRatio],
    size: [
      (rect.right - rect.left) * pixelRatio,
      (rect.bottom - rect.top) * pixelRatio,
    ],
  };
}

/**
 * ## ByondUi
 * Displays a BYOND UI element on top of the browser, and leverages browser's
 * layout engine to position it just like any other HTML element. It is
 * especially useful if you want to display a secondary game map in your
 * interface.
 *
 * @example
 * ```tsx
 * <ByondUi
 *   params={{
 *    id: 'test_button', // optional, can be auto-generated
 *    parent: 'some_container', // optional, defaults to the current window
 *    type: 'button',
 *    text: 'Hello, world!',
 *   }} />
 * ```
 *
 * @example
 * ```tsx
 * <ByondUi
 *   params={{
 *    id: 'test_map',
 *    type: 'map',
 *   }} />
 * ```
 *
 * It supports a full set of `Box` properties for layout purposes.
 */
export function ByondUi(props: Props) {
  const { params, ...rest } = props;

  const containerRef = useRef<HTMLDivElement>(null);
  const byondUiElement = useRef(createByondUiElement(params?.id));

  function updateRender() {
    const element = containerRef.current;
    if (!element) return;

    const box = getBoundingBox(element);
    byondUiElement.current.render({
      parent: Byond.windowId,
      ...params,
      pos: `${box.pos[0]},${box.pos[1]}`,
      size: `${box.size[0]}x${box.size[1]}`,
    });
  }

  const handleResize = debounce(() => {
    updateRender();
  }, 100);

  useEffect(() => {
    window.addEventListener('resize', handleResize);
    updateRender();

    return () => {
      window.removeEventListener('resize', handleResize);
      byondUiElement.current.unmount();
    };
  }, []);

  return (
    <div ref={containerRef} {...computeBoxProps(rest)}>
      {/* Filler */}
      <div style={{ minHeight: '22px' }} />
    </div>
  );
}
