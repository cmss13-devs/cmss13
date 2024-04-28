import { Component, createRef } from 'react';

import { Box, Icon, Tooltip } from '../components';

// this file should probably not be in interfaces, should move it later.
export class CanvasLayer extends Component {
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

    this.complexity = 0;
  }

  componentDidMount() {
    this.ctx = this.canvasRef.current.getContext('2d');
    this.ctx.lineWidth = 4;
    this.ctx.lineCap = 'round';

    this.img = new Image();

    this.img.src = this.imageSrc;

    this.img.onload = () => {
      this.setState({ mapLoad: true });
    };

    this.img.onerror = () => {
      this.setState({ mapLoad: false });
    };

    this.drawCanvas();
  }

  handleMouseDown = (e) => {
    this.isPainting = true;

    const rect = this.canvasRef.current.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;

    this.ctx.beginPath();
    this.ctx.moveTo(this.lastX, this.lastY);
    this.lastX = x;
    this.lastY = y;
  };

  handleMouseMove = (e) => {
    if (!this.isPainting || !this.state.selection) {
      return;
    }
    if (e.buttons === 0) {
      // We probably dragged off the window - lets not get stuck drawing
      this.handleMouseUp(e);
      return;
    }

    this.ctx.strokeStyle = this.state.selection;

    const rect = this.canvasRef.current.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;

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
      ]);
    }

    this.lastX = x;
    this.lastY = y;
  };

  handleMouseUp = (e) => {
    if (
      this.isPainting &&
      this.state.selection &&
      this.lastX !== null &&
      this.lastY !== null
    ) {
      const rect = this.canvasRef.current.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;

      this.ctx.moveTo(this.lastX, this.lastY);
      this.ctx.lineTo(x, y);
      this.ctx.stroke();
      this.currentLine.push([
        this.lastX,
        this.lastY,
        x,
        y,
        this.ctx.strokeStyle,
      ]);
    }

    this.isPainting = false;
    this.lastX = null;
    this.lastY = null;

    if (this.currentLine.length === 0) {
      return;
    }

    this.lineStack.push([...this.currentLine]);
    this.currentLine = [];
    this.complexity = this.getComplexity();
    this.props.onDraw();
  };

  handleSelectionChange = () => {
    const { selection } = this.props;

    if (selection === 'clear') {
      this.ctx.clearRect(
        0,
        0,
        this.canvasRef.current.width,
        this.canvasRef.current.height,
      );
      this.ctx.drawImage(
        this.img,
        0,
        0,
        this.canvasRef.current.width,
        this.canvasRef.current.height,
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
      if (line.length === 0) {
        return;
      }

      const prevColor = line[0][4];

      this.ctx.clearRect(
        0,
        0,
        this.canvasRef.current.width,
        this.canvasRef.current.height,
      );
      this.ctx.drawImage(
        this.img,
        0,
        0,
        this.canvasRef.current.width,
        this.canvasRef.current.height,
      );
      this.ctx.globalCompositeOperation = 'source-over';

      this.lineStack.forEach((currentLine) => {
        currentLine.forEach(([lastX, lastY, x, y, colorSelection]) => {
          this.ctx.strokeStyle = colorSelection;
          this.ctx.beginPath();
          this.ctx.moveTo(lastX, lastY);
          this.ctx.lineTo(x, y);
          this.ctx.stroke();
        });
      });

      this.complexity = this.getComplexity();
      this.setState({ selection: prevColor });
      this.props.onUndo(prevColor);
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
    };
  }

  convertToSVG() {
    const lines = this.lineStack.flat();
    const combinedArray = lines.flatMap(
      ([lastX, lastY, x, y, colorSelection]) => [
        lastX,
        lastY,
        x,
        y,
        colorSelection,
      ],
    );
    return combinedArray;
  }

  getComplexity() {
    let count = 0;
    this.lineStack.forEach((item) => {
      count += item.length;
    });
    return count;
  }

  displayCanvas() {
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
              mt="25px"
            />
          </Tooltip>
        )}
        <canvas
          ref={this.canvasRef}
          width={650}
          height={600}
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

  render() {
    if (this.state.mapLoad) {
      return this.displayCanvas();
    } else {
      // edge case where a new user joins and tries to draw on the canvas before they cached the png
      return this.displayLoading();
    }
  }
}
