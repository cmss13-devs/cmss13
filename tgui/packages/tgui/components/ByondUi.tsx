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

type ZoomDrawingMode =
  | { type: 'NativeScaling' }
  | { type: 'ManuallyCalculate'; nativeSize: number[] };

function getZoomFactor(
  zoomDrawingMode: ZoomDrawingMode,
  domBox: BoundingBox,
): number {
  switch (zoomDrawingMode.type) {
    case 'NativeScaling':
      return 0;
    case 'ManuallyCalculate': {
      const byondOriginalSizeX = zoomDrawingMode.nativeSize[0];
      const byondOriginalSizeY = zoomDrawingMode.nativeSize[1];

      const possibleXScaleFactor = domBox.size[0] / byondOriginalSizeX;
      const possibleYScaleFactor = domBox.size[1] / byondOriginalSizeY;

      // XXX 4khan: the byond zoom winset param always scales the entire image.
      // This means that for a square image like tacmaps, we can't apply one
      // scaling factor horizontally and another vertically, so we have to
      // choose the smaller of the two.
      return Math.min(possibleXScaleFactor, possibleYScaleFactor);
    }
    default:
      return 0;
  }
}

type ByondUiElement = {
  render: (
    containerRef: React.Ref<HTMLDivElement>,
    params: Record<string, any>,
    zoomDrawingMode: ZoomDrawingMode,
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
   * You can find a full list of possible parameters
   * in [BYOND controls and parameters guide](https://secure.byond.com/docs/ref/skinparams.html). */
}>;

function callWinset(
  index: number,
  id: string,
  constParams: any,
  zoomDrawingMode: ZoomDrawingMode,
  container: React.RefObject<HTMLDivElement>,
) {
  byondUiStack[index] = id;

  const element = container.current;
  if (!element) {
    return;
  }
  const box = getBoundingBox(element);

  // Calculate appropriate zoom
  const zoom = getZoomFactor(zoomDrawingMode, box);

  let params = { ...constParams };
  params['pos'] = byondFmtDuple(box.pos);
  params['size'] = byondFmtDuple(box.size);
  params['zoom'] = zoom;

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
      zoomDrawingMode: ZoomDrawingMode,
    ) => {
      callWinset(index, id, constParams, zoomDrawingMode, containerRef);
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
  /**
   * Parameters passed directly to the underlying winset() BYOND call.
   * You can find a full reference of these parameters
   * in [BYOND controls and parameters guide](https://secure.byond.com/docs/ref/skinparams.html). */
  winsetParams: SampleWinsetParams & Record<string, any>;

  /** params passed to calculateBoxProps from ../box.tsx */
  boxProps: Record<string, any>;

  /**
   * For map byond UIs, whether or not to hand-calculate the 'zoom'
   * winset attr. The default behavior is to pass zoom=0, which auto-calculates
   * the zoom factor based on the size of the parent element. However, this zoom
   * assumes a square view which isn't always the case, causing the window to
   * draw outside the DOM bounding box. The first index of the passed number
   * array for the ManuallyCalculate variant should be the width of the
   * byond object in pixels, the second index should be the height.
   */
  zoomDrawingMode: ZoomDrawingMode;
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
  const zoomDrawingMode = props.zoomDrawingMode;

  const containerRef = useRef<HTMLDivElement>(null);
  const byondUiElement = useRef(createByondUiElement(winsetParams?.id));

  function updateRender() {
    const constParams = {
      parent: Byond.windowId,
      ...winsetParams,
    };
    byondUiElement.current.render(
      containerRef,
      constParams,
      zoomDrawingMode ? zoomDrawingMode : { type: 'NativeScaling' },
    );
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
