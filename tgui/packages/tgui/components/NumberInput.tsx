/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { isEscape, KEY } from 'common/keys';
import { clamp } from 'common/math';
import { BooleanLike, classes } from 'common/react';
import { Component, createRef, MouseEventHandler, RefObject } from 'react';

import { AnimatedNumber } from './AnimatedNumber';
import { Box } from './Box';

type Props = Required<{
  value: number | string;
  minValue: number;
  maxValue: number;
  step: number;
}> &
  Partial<{
    stepPixelSize: number;
    disabled: BooleanLike;
    suppressFlicker: number;
    updateRate: number;

    className: string;
    fluid: BooleanLike;
    animated: BooleanLike;
    unit: string;
    height: string;
    width: string;
    lineHeight: string;
    fontSize: string;
    format: (value: number) => string;
    onChange: (value: number) => void;
    onDrag: (value: number) => void;
  }>;

type State = {
  value: string | number;
  editing: BooleanLike;
  dragging: BooleanLike;
  internalValue: number | string | null;
  origin: number | null;
  suppressingFlicker: boolean;
};
const DEFAULT_UPDATE_RATE = 400;

export class NumberInput extends Component<Props, State> {
  inputRef: RefObject<HTMLInputElement>;
  flickerTimer: NodeJS.Timeout | null;
  suppressFlicker: Function;
  handleDragStart: MouseEventHandler<HTMLDivElement>;
  ref: any;
  timer: NodeJS.Timeout;
  dragInterval: NodeJS.Timeout;
  handleDragMove: EventListener;
  handleDragEnd: EventListener;
  constructor(props: Props) {
    super(props);
    const { value } = props;
    this.inputRef = createRef();
    this.state = {
      value,
      dragging: false,
      editing: false,
      internalValue: null,
      origin: null,
      suppressingFlicker: false,
    };

    // Suppresses flickering while the value propagates through the backend
    this.flickerTimer = null;
    this.suppressFlicker = () => {
      const { suppressFlicker = 50 } = this.props;
      if (suppressFlicker > 0) {
        this.setState({
          suppressingFlicker: true,
        });
        clearTimeout(this.flickerTimer!);
        this.flickerTimer = setTimeout(
          () =>
            this.setState({
              suppressingFlicker: false,
            }),
          suppressFlicker,
        );
      }
    };

    this.handleDragStart = (e) => {
      const { value, disabled } = this.props;
      const { editing } = this.state;
      if (disabled || editing) {
        return;
      }
      document.body.style['pointer-events'] = 'none';
      this.ref = e.target;
      this.setState({
        dragging: false,
        origin: e.screenY,
        value,
        internalValue: value,
      });
      this.timer = setTimeout(() => {
        this.setState({
          dragging: true,
        });
      }, 250);
      this.dragInterval = setInterval(() => {
        const { dragging, value } = this.state;
        const { onDrag } = this.props;
        if (dragging && onDrag) {
          onDrag(+value);
        }
      }, this.props.updateRate || DEFAULT_UPDATE_RATE);
      document.addEventListener('mousemove', this.handleDragMove);
      document.addEventListener('mouseup', this.handleDragEnd);
    };

    this.handleDragMove = (e: MouseEvent) => {
      const { minValue, maxValue, step, stepPixelSize } = this.props;
      this.setState((prevState) => {
        const state = { ...prevState };
        const offset = state.origin! - e.screenY;
        if (prevState.dragging) {
          const stepOffset = Number.isFinite(minValue) ? minValue % step : 0;
          // Translate mouse movement to value
          // Give it some headroom (by increasing clamp range by 1 step)
          state.internalValue = clamp(
            Number(state.internalValue) +
              (offset * step) / (stepPixelSize || 1),
            minValue - step,
            maxValue + step,
          );
          // Clamp the final value
          state.value = clamp(
            Number(state.internalValue) -
              (Number(state.internalValue) % step) +
              stepOffset,
            minValue,
            maxValue,
          );
          state.origin = e.screenY;
        } else if (Math.abs(offset) > 4) {
          state.dragging = true;
        }
        return state;
      });
    };

    this.handleDragEnd = (e) => {
      const { onChange, onDrag } = this.props;
      const { dragging, value, internalValue } = this.state;
      document.body.style['pointer-events'] = 'auto';
      clearTimeout(this.timer);
      clearInterval(this.dragInterval);
      this.setState({
        dragging: false,
        editing: !dragging,
        origin: null,
      });
      document.removeEventListener('mousemove', this.handleDragMove);
      document.removeEventListener('mouseup', this.handleDragEnd);
      if (dragging) {
        this.suppressFlicker();
        if (onChange) {
          onChange(+value);
        }
        if (onDrag) {
          onDrag(+value);
        }
      } else if (this.inputRef) {
        const input = this.inputRef.current!;
        input.value = String(internalValue);
        setTimeout(() => {
          input.focus();
          input.select();
        }, 100);
      }
    };
  }

  render() {
    const {
      dragging,
      editing,
      value: intermediateValue,
      suppressingFlicker,
    } = this.state;
    const {
      className,
      fluid,
      animated,
      value,
      unit,
      minValue,
      maxValue,
      height,
      width,
      lineHeight,
      fontSize,
      disabled,
      format,
      onChange,
      onDrag,
    } = this.props;
    let displayValue = value;
    if (dragging || suppressingFlicker) {
      displayValue = intermediateValue;
    }

    const contentElement = (
      <div className="NumberInput__content">
        {animated && !dragging && !suppressingFlicker ? (
          <AnimatedNumber value={+displayValue} format={format} />
        ) : format ? (
          format(+displayValue)
        ) : (
          displayValue
        )}

        {unit ? ' ' + unit : ''}
      </div>
    );

    return (
      <Box
        className={classes([
          'NumberInput',
          fluid && 'NumberInput--fluid',
          className,
        ])}
        minWidth={width}
        minHeight={height}
        lineHeight={lineHeight}
        fontSize={fontSize}
        onMouseDown={this.handleDragStart}
      >
        <div className="NumberInput__barContainer">
          <div
            className="NumberInput__bar"
            style={{
              height:
                clamp(
                  ((+displayValue - minValue) / (maxValue - minValue)) * 100,
                  0,
                  100,
                ) + '%',
            }}
          />
        </div>
        {contentElement}
        <input
          ref={this.inputRef}
          className="NumberInput__input"
          style={{
            display: !editing ? 'none' : undefined,
            height: height,
            lineHeight: lineHeight,
            fontSize: fontSize,
          }}
          onBlur={(e) => {
            if (!editing) {
              return;
            }
            const value = clamp(parseFloat(e.target.value), minValue, maxValue);
            if (Number.isNaN(value)) {
              this.setState({
                editing: false,
              });
              return;
            }
            this.setState({
              editing: false,
              value,
            });
            this.suppressFlicker();
            if (onChange) {
              onChange(value);
            }
            if (onDrag) {
              onDrag(value);
            }
          }}
          onKeyDown={(e) => {
            if (disabled) {
              return;
            }
            if (e.key === KEY.Enter) {
              // prettier-ignore
              const event = e.target;
              const value = clamp(
                parseFloat((event as HTMLInputElement).value),
                minValue,
                maxValue,
              );
              if (Number.isNaN(value)) {
                this.setState({
                  editing: false,
                });
                return;
              }
              this.setState({
                editing: false,
                value,
              });
              this.suppressFlicker();
              if (onChange) {
                onChange(value);
              }
              if (onDrag) {
                onDrag(value);
              }
              return;
            }
            if (isEscape(e.key)) {
              this.setState({
                editing: false,
              });
              return;
            }
          }}
        />
      </Box>
    );
  }
}
