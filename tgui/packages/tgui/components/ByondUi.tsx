import { debounce } from 'common/timer';
import { useEffect, useRef } from 'react';

import { computeBoxProps } from './Box';

type BoundingBox = {
  pos: number[];
  size: number[];
};

function byondFmtDuple(size_array: number[]): string {
  const x_size = size_array[0];
  const y_size = size_array[1];
  return `${x_size}x${y_size}`;
}

function byondFmtAnchor(anchor_array: number[]): string {
  const x_anchor = anchor_array[0];
  const y_anchor = anchor_array[0];
  return `${x_anchor},${y_anchor}`;
}

function dupleFromViewSize(viewSizeStr: string): number[] | null {
  console.log('viewSizeStr');
  console.log(viewSizeStr);

  const regex = /(\d+)x(\d+)/;
  const matches = viewSizeStr.match(regex);
  if (!matches) {
    console.log('!matches');
    return null;
  }
  console.log(matches);

  let retn = [Number(matches[1]), Number(matches[2])];
  console.log(retn);
  return retn;
}

function getZoomFactor(
  domBox: BoundingBox,
  byondOriginalSizeX: number,
  byondOriginalSizeY: number,
): number {
  const possibleXScaleFactor = domBox.size[0] / byondOriginalSizeX;
  const possibleYScaleFactor = domBox.size[1] / byondOriginalSizeY;

  console.log('spam');
  console.log(byondOriginalSizeX);
  console.log(byondOriginalSizeY);
  console.log(domBox.size[0]);
  console.log(domBox.size[1]);
  console.log(possibleXScaleFactor);
  console.log(possibleYScaleFactor);

  return Math.min(possibleXScaleFactor, possibleYScaleFactor);
}

type ByondUiElement = {
  render: (
    containerRef: React.Ref<HTMLDivElement>,
    params: Record<string, any>,
  ) => void;
  unmount: () => void;
};

/**
 * Get the bounding box of the DOM element in display-pixels.
 */
function getBoundingBox(element: HTMLDivElement): BoundingBox {
  const pixelRatio = window.devicePixelRatio ?? 1;
  const rect = element.getBoundingClientRect();

  const to_return = {
    pos: [rect.left * pixelRatio, rect.top * pixelRatio],
    size: [
      (rect.right - rect.left) * pixelRatio,
      (rect.bottom - rect.top) * pixelRatio,
    ],
  };

  return to_return;
}

type SampleWinsetParams = Partial<{
  /** Can be auto-generated. */
  id: string;
  /**  Defaults to the current window */
  parent: string;
  /** The type of control. Read-only. */
  type: string;
  /** Text shown in label/button/input. For input controls this setting is only available at runtime. */
  text: string;
  /**
   * You can find a full reference of these parameters
   * in [BYOND controls and parameters guide](https://secure.byond.com/docs/ref/skinparams.html). */
}>;

function callWinset(
  index: number,
  id: string,
  constParams: any,
  container: React.RefObject<HTMLDivElement>,
) {
  byondUiStack[index] = id;

  const element = container.current;
  if (!element) {
    console.log('early return: 1');
    return;
  }
  const box = getBoundingBox(element);
  console.log('boundingBox:');
  console.log(box);

  // Calculate appropriate zoom
  const zoom = getZoomFactor(box);
  console.log('calculated zoom: ');
  console.log(zoom);

  console.log('static params:');
  console.log(constParams);

  let params = { ...constParams };
  params['pos'] = byondFmtDuple(box.pos);
  params['size'] = byondFmtDuple(box.size);
  params['zoom'] = zoom;

  console.log('final params:');
  console.log(params);

  Byond.winset(id, { ...params, style: Byond.styleSheet });
}

function createByondUiElement(elementId: string | undefined): ByondUiElement {
  // Reserve an index in the stack
  const index = byondUiStack.length;
  byondUiStack.push(null);
  // Get a unique id
  const id = elementId || `byondui_${index}`;

  // Return a control structure
  return {
    render: (
      containerRef: React.RefObject<HTMLDivElement>,
      constParams: SampleWinsetParams,
    ) => {
      callWinset(index, id, constParams, containerRef);
    },
    unmount: () => {
      byondUiStack[index] = null;
      Byond.winset(id, {
        parent: '',
      });
    },
  } as ByondUiElement;
}

type ByondUiProps = Partial<{
  /** An object with parameters, which are directly passed to
   * the `winset` proc call.
   *
   * You can find a full reference of these parameters
   * in [BYOND controls and parameters guide](https://secure.byond.com/docs/ref/skinparams.html). */
  winsetParams: SampleWinsetParams & Record<string, any>;
  boxProps: Record<string, any>;
}>;

// Stack of currently allocated BYOND UI element ids.
const byondUiStack: Array<string | null> = [];

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
 *   winsetParams={{
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
 *   winsetParams={{
 *    id: 'test_map',
 *    type: 'map',
 *   }} />
 * ```
 *
 * It supports a full set of `Box` properties for layout purposes.
 */
export function ByondUi(props: ByondUiProps) {
  const winsetParams = props.winsetParams;
  const boxProps = props.boxProps;

  const containerRef = useRef<HTMLDivElement>(null);
  const byondUiElement = useRef(createByondUiElement(winsetParams?.id));

  function updateRender() {
    const constParams = {
      parent: Byond.windowId,
      ...winsetParams,
    };
    byondUiElement.current.render(containerRef, constParams);
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
    <div ref={containerRef} {...computeBoxProps(boxProps)}>
      {/* Filler */}
      <div style={{ minHeight: '22px' }} />
    </div>
  );
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
