import { Component, createRef, RefObject } from 'react';
import { Box, Icon, Tooltip } from 'tgui/components';

// this file should probably not be in interfaces, should move it later.
type PaintCanvasProps = {
  readonly onDraw: () => void;
  readonly imageSrc: string;
  readonly selection: string;
  readonly onImageExport: (img) => void;
  readonly onUndo: (e) => void;
} & Partial<{
  canvasRef: HTMLCanvasElement;
  actionQueueChange: number;
}>;

type Line = [
  number,
  number,
  number,
  number,
  string | CanvasGradient | CanvasPattern,
];

export class CanvasLayer extends Component<PaintCanvasProps> {
  canvasRef: RefObject<HTMLCanvasElement>;
  img: HTMLImageElement | null;
  imageSrc?: string;
  lineStack: Line[][];
  currentLine: Line[];
  ctx: CanvasRenderingContext2D | null;
  isPainting: boolean;
  lastX: number | null;
  lastY: number | null;
  complexity: number;
  state: { selection: string | undefined; mapLoad: boolean };
  constructor(props) {
    super(props);
    this.canvasRef = createRef();

    // color selection
    // using this.state prevents unpredictable behavior
    this.state = {
      selection: this.props.selection,
      mapLoad: true,
    };

    // needs to be of type png of jpg
    this.img = null;
    this.imageSrc = this.props.imageSrc;

    // stores the stacked lines
    this.lineStack = [];

    // stores the individual line drawn
    this.currentLine = [];

    this.ctx = null;
    this.isPainting = false;
    this.lastX = null;
    this.lastY = null;
    this.zlevel = this.props.zlevel;
    this.storedData = this.props.storedData;

    this.complexity = 0;
  }

  componentDidMount() {
    this.ctx = this.canvasRef.current!.getContext('2d');
    if (this.ctx) {
      this.ctx.lineWidth = 4;
      this.ctx.lineCap = 'round';

      this.img = new Image();

      this.img.src = this.imageSrc || '';

      this.img.onload = () => {
        this.setState({ mapLoad: true });
        this.drawCanvas();
      };

      this.img.onerror = () => {
        this.setState({ mapLoad: false });
      };

      this.drawCanvas();
    }
  }
  handleMouseDown = (e) => {
    if (!this.ctx) {
      return;
    }
    this.isPainting = true;

    const rect = this.canvasRef.current.getBoundingClientRect();
    const scaleX = this.canvasRef.current.width / rect.width;
    const scaleY = this.canvasRef.current.height / rect.height;

    const x = (e.clientX - rect.left) * scaleX;
    const y = (e.clientY - rect.top) * scaleY;

    this.ctx.beginPath();
    this.ctx.moveTo(this.lastX || 0, this.lastY || 0);
    this.lastX = x;
    this.lastY = y;
  };

  handleMouseMove = (e) => {
    if (!this.isPainting || !this.state.selection) return;
    if (e.buttons === 0) {
      // We probably dragged off the window - lets not get stuck drawing
      this.handleMouseUp(e);
      return;
    }

    if (!this.ctx) {
      return;
    }
    this.ctx.strokeStyle = this.state.selection;

    const rect = this.canvasRef.current.getBoundingClientRect();
    const scaleX = this.canvasRef.current.width / rect.width;
    const scaleY = this.canvasRef.current.height / rect.height;

    const x = (e.clientX - rect.left) * scaleX;
    const y = (e.clientY - rect.top) * scaleY;

    if (this.lastX !== null && this.lastY !== null) {
      // this controls how often we make new strokes
      if (Math.abs(this.lastX - x) + Math.abs(this.lastY - y) < 20) {
        return;
      }

      this.ctx.moveTo(this.lastX, this.lastY);
      this.ctx.lineTo(x, y);
      this.ctx.stroke();
      this.currentLine.push([
        this.lastX,
        this.lastY,
        x,
        y,
        this.ctx.strokeStyle,
        this.zlevel,
      ]);
    }

    this.lastX = x;
    this.lastY = y;
  };

  handleMouseUp = (e) => {
    if (!this.isPainting) return;

    const rect = this.canvasRef.current.getBoundingClientRect();
    const scaleX = this.canvasRef.current.width / rect.width;
    const scaleY = this.canvasRef.current.height / rect.height;

    const x = (e.clientX - rect.left) * scaleX;
    const y = (e.clientY - rect.top) * scaleY;

    this.ctx.moveTo(this.lastX, this.lastY);
    this.ctx.lineTo(x, y);
    this.ctx.stroke();
    this.currentLine.push([
      this.lastX,
      this.lastY,
      x,
      y,
      this.ctx.strokeStyle,
      this.zlevel,
    ]);

    this.isPainting = false;
    this.lastX = null;
    this.lastY = null;

    if (this.currentLine.length === 0) return;

    this.lineStack.push([...this.currentLine]);
    this.currentLine = [];
    this.complexity = this.getComplexity();
    this.props.onDraw(this.convertToSVG());
  };

  handleSelectionChange = () => {
    const { selection } = this.props;

    if (selection === 'clear' && this.ctx) {
      this.ctx.clearRect(
        0,
        0,
        this.canvasRef.current?.width || 0,
        this.canvasRef.current?.height || 0,
      );
      this.ctx.drawImage(
        this.img as CanvasImageSource,
        0,
        0,
        this.canvasRef.current?.width || 0,
        this.canvasRef.current?.height || 0,
      );

      this.lineStack = [];
      this.complexity = 0;
      return;
    }

    if (selection === 'undo') {
      if (this.lineStack.length === 0) {
        return;
      }

      const line = this.lineStack.pop();
      if (!line || line.length === 0 || !this.ctx) {
        return;
      }

      const prevColor = line[0][4];

      this.ctx.clearRect(
        0,
        0,
        this.canvasRef.current?.width || 0,
        this.canvasRef.current?.height || 0,
      );
      this.ctx.drawImage(
        this.img!,
        0,
        0,
        this.canvasRef.current?.width || 0,
        this.canvasRef.current?.height || 0,
      );
      this.ctx.globalCompositeOperation = 'source-over';

      this.lineStack.forEach((currentLine) => {
        currentLine.forEach(([lastX, lastY, x, y, colorSelection, zlevel]) => {
          if (zlevel === this.zlevel) {
            this.ctx.strokeStyle = colorSelection;
            this.ctx.beginPath();
            this.ctx.moveTo(lastX, lastY);
            this.ctx.lineTo(x, y);
            this.ctx.stroke();
          }
        });
      });

      this.complexity = this.getComplexity();
      this.setState({ selection: prevColor });
      this.props.onUndo(prevColor, this.lineStack);
      return;
    }

    if (selection === 'export') {
      const svgData = this.convertToSVG();
      this.props.onImageExport(svgData);
      return;
    }

    this.setState({ selection: selection });
  };

  componentDidUpdate(prevProps) {
    if (prevProps.actionQueueChange !== this.props.actionQueueChange) {
      this.handleSelectionChange();
    }
  }

  drawCanvas() {
    this.img.onload = () => {
      // this onload may or may not be causing problems.
      this.ctx.drawImage(
        this.img,
        0,
        0,
        this.canvasRef.current?.width,
        this.canvasRef.current?.height,
      );

      this.setSVG(this.storedData);
    };
  }

  convertToSVG() {
    const lines = this.lineStack.flat();
    const combinedArray = lines.flatMap(
      ([lastX, lastY, x, y, colorSelection, zlevel]) => [
        lastX,
        lastY,
        x,
        y,
        colorSelection,
        zlevel,
      ],
    );
    return combinedArray;
  }

  getSVG() {
    return this.lineStack;
  }

  setSVG(svg) {
    this.redrawSVG(svg);
  }

  redrawSVG(lineStack) {
    if (this.ctx === null || lineStack === null || lineStack === undefined) {
      return;
    }

    lineStack.forEach((stack) => {
      const newStack = [];
      stack.forEach((line) => {
        const [lastX, lastY, x, y, color, zlevel] = line;
        if (zlevel === this.zlevel) {
          this.ctx.strokeStyle = color;
          this.ctx.lineWidth = 4;
          this.ctx.lineCap = 'round';
          this.ctx.beginPath();
          this.ctx.moveTo(lastX, lastY);
          this.ctx.lineTo(x, y);
          this.ctx.stroke();
        }

        newStack.push([lastX, lastY, x, y, color, zlevel]);
      });

      this.lineStack.push(newStack);
    });
  }

  getComplexity() {
    let count = 0;
    this.lineStack.forEach((item) => {
      count += item.length;
    });
    return count;
  }

  displayCanvas() {
    const size = this.getSize();

    return (
      <div>
        {this.complexity > 500 && (
          <Tooltip
            position="bottom"
            content={
              'This drawing may be too complex to submit. (' +
              this.complexity +
              ')'
            }
          >
            <Icon
              name="fa-solid fa-triangle-exclamation"
              size={2}
              position="absolute"
              mx="50%"
              mt="140px"
              color="red"
              style={{ zIndex: '1' }}
            />
          </Tooltip>
        )}
        <canvas
          ref={this.canvasRef}
          width={684}
          height={684}
          className="TacticalMap"
          style={{
            width: size.width,
            height: size.height,
          }}
          onMouseDown={(e) => this.handleMouseDown(e)}
          onMouseUp={(e) => this.handleMouseUp(e)}
          onMouseMove={(e) => this.handleMouseMove(e)}
        />
      </div>
    );
  }

  displayLoading() {
    return (
      <div>
        <Box my="273.5px">
          <h1>
            Please wait a few minutes before attempting to access the canvas.
          </h1>
        </Box>
      </div>
    );
  }

  getSize() {
    const ratio = Math.min(
      (self.innerWidth - 16) / 684,
      (self.innerHeight - 166) / 684,
    );
    return { width: 684 * ratio, height: 684 * ratio };
  }

  render() {
    if (this.state.mapLoad) {
      return this.displayCanvas();
    } else {
      // edge case where a new user joins and tries to draw on the canvas before they cached the png
      return this.displayLoading();
    }
  }
}
