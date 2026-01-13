import { round } from 'common/math';
import { Component, type PropsWithChildren } from 'react';
import { Button, ProgressBar, Stack } from 'tgui/components';

import { type BoxProps, computeBoxProps } from './Box';

const ZOOM_MIN_VAL = 0.5;
const ZOOM_MAX_VAL = 1.5;

const ZOOM_INCREMENT = 0.1;

export type InfinitePlaneProps = PropsWithChildren<
  {
    readonly onZoomChange?: (newZoomValue: number) => void;
    readonly onBackgroundMoved?: (newX: number, newY: number) => void;
    readonly initialLeft?: number;
    readonly initialTop?: number;
    readonly backgroundImage?: string;
    readonly imageWidth: number;
  } & BoxProps
>;

type InfinitePlaneState = {
  mouseDown: boolean;

  left: number;
  top: number;

  lastLeft: number;
  lastTop: number;

  zoom: number;
};

export type MouseEventExtension = {
  screenZoomX: number;
  screenZoomY: number;
};

export class InfinitePlane extends Component<
  InfinitePlaneProps,
  InfinitePlaneState
> {
  constructor(props: InfinitePlaneProps) {
    super(props);

    this.state = {
      mouseDown: false,

      left: 0,
      top: 0,

      lastLeft: 0,
      lastTop: 0,

      zoom: 1,
    };
  }

  componentDidMount() {
    window.addEventListener('mouseup', this.onMouseUp);

    window.addEventListener('mousedown', this.doOffsetMouse);
    window.addEventListener('mousemove', this.doOffsetMouse);
    window.addEventListener('mouseup', this.doOffsetMouse);
  }

  componentWillUnmount() {
    window.removeEventListener('mouseup', this.onMouseUp);

    window.removeEventListener('mousedown', this.doOffsetMouse);
    window.removeEventListener('mousemove', this.doOffsetMouse);
    window.removeEventListener('mouseup', this.doOffsetMouse);
  }

  // This is really, REALLY cursed and basically overrides a built-in browser event via propagation rules
  doOffsetMouse = (event: MouseEvent & MouseEventExtension) => {
    const { zoom } = this.state;
    event.screenZoomX = event.screenX * Math.pow(zoom, -1);
    event.screenZoomY = event.screenY * Math.pow(zoom, -1);
  };

  handleMouseDown = (event: React.MouseEvent<HTMLDivElement>) => {
    this.setState((state) => {
      return {
        mouseDown: true,
        lastLeft: event.clientX - state.left,
        lastTop: event.clientY - state.top,
      };
    });
  };

  onMouseUp = () => {
    this.setState({
      mouseDown: false,
    });
  };

  handleZoomIncrease = (event: any) => {
    const { onZoomChange } = this.props;
    const { zoom } = this.state;
    const newZoomValue = round(
      Math.min(zoom + ZOOM_INCREMENT, ZOOM_MAX_VAL),
      1,
    );
    this.setState({
      zoom: newZoomValue,
    });
    if (onZoomChange) {
      onZoomChange(newZoomValue);
    }
  };

  handleZoomDecrease = (event: any) => {
    const { onZoomChange } = this.props;
    const { zoom } = this.state;
    const newZoomValue = round(
      Math.max(zoom - ZOOM_INCREMENT, ZOOM_MIN_VAL),
      1,
    );
    this.setState({
      zoom: newZoomValue,
    });

    if (onZoomChange) {
      onZoomChange(newZoomValue);
    }
  };

  handleMouseMove = (event: React.MouseEvent<HTMLDivElement>) => {
    const { onBackgroundMoved, initialLeft = 0, initialTop = 0 } = this.props;
    if (this.state.mouseDown) {
      let newX, newY;
      this.setState((state) => {
        newX = event.clientX - state.lastLeft;
        newY = event.clientY - state.lastTop;
        if (onBackgroundMoved) {
          onBackgroundMoved(newX + initialLeft, newY + initialTop);
        }
        return {
          left: newX,
          top: newY,
        };
      });
    }
  };

  render() {
    const {
      children,
      backgroundImage,
      imageWidth,
      initialLeft = 0,
      initialTop = 0,
      ...rest
    } = this.props;
    const { left, top, zoom } = this.state;

    const finalLeft = initialLeft + left;
    const finalTop = initialTop + top;

    return (
      <div
        {...computeBoxProps({
          ...rest,
          style: {
            ...rest.style,
            overflow: 'hidden',
            position: 'relative',
          },
        })}
      >
        <div
          onMouseDown={this.handleMouseDown}
          onMouseMove={this.handleMouseMove}
          style={{
            position: 'fixed',
            height: '100%',
            width: '100%',
            backgroundImage: `url("${backgroundImage}")`,
            backgroundPosition: `${finalLeft}px ${finalTop}px`,
            backgroundRepeat: 'repeat',
            backgroundSize: `${zoom * imageWidth}px`,
          }}
        />
        <div
          onMouseDown={this.handleMouseDown}
          onMouseMove={this.handleMouseMove}
          style={{
            position: 'fixed',
            transform: `translate(${finalLeft}px, ${finalTop}px) scale(${zoom})`,
            transformOrigin: 'top left',
            height: '100%',
            width: '100%',
          }}
        >
          {children}
        </div>

        <Stack position="absolute" width="100%">
          <Stack.Item>
            <Button icon="minus" onClick={this.handleZoomDecrease} />
          </Stack.Item>
          <Stack.Item grow={1}>
            <ProgressBar
              minValue={ZOOM_MIN_VAL}
              value={zoom}
              maxValue={ZOOM_MAX_VAL}
            >
              {zoom}x
            </ProgressBar>
          </Stack.Item>
          <Stack.Item>
            <Button icon="plus" onClick={this.handleZoomIncrease} />
          </Stack.Item>
        </Stack>
      </div>
    );
  }
}
