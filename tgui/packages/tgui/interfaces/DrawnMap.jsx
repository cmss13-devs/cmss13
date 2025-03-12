import { Component, createRef } from 'react';

import { Box } from '../components';

export class DrawnMap extends Component {
  constructor(props) {
    super(props);
    this.containerRef = createRef();
    this.flatImgSrc = this.props.flatImage;
    this.backupImgSrc = this.props.backupImage;
    this.state = {
      mapLoad: true,
      loadingBackup: true,
    };
    this.img = null;
    this.svg = this.props.svgData;
    this.zlevel = this.props.zlevel;
  }

  componentDidMount() {
    this.img = new Image();
    this.img.src = this.flatImgSrc;
    this.img.onload = () => {
      this.setState({ mapLoad: true });
    };

    this.img.onerror = () => {
      this.img.src = this.backupImgSrc;
      this.setState({ mapLoad: false });
    };

    const backupImg = new Image();
    backupImg.src = this.backupImgSrc;
    backupImg.onload = () => {
      this.setState({ loadingBackup: false });
    };
  }

  parseSvgData(svgDataArray) {
    if (!svgDataArray || !Array.isArray(svgDataArray)) return [];
    const lines = [];
    for (let i = 0; i < svgDataArray.length; i += 6) {
      const lastX = svgDataArray[i];
      const lastY = svgDataArray[i + 1];
      const x = svgDataArray[i + 2];
      const y = svgDataArray[i + 3];
      const color = svgDataArray[i + 4];
      const zlevel = svgDataArray[i + 5];
      if (
        typeof lastX === 'number' &&
        typeof lastY === 'number' &&
        typeof x === 'number' &&
        typeof y === 'number' &&
        typeof color === 'string' &&
        typeof zlevel === 'number'
      ) {
        lines.push({
          x1: lastX,
          y1: lastY,
          x2: x,
          y2: y,
          stroke: color,
          zlevel: zlevel,
        });
      }
    }
    return lines;
  }

  getSize() {
    const ratio = Math.min(
      (self.innerWidth - 16) / 684,
      (self.innerHeight - 166) / 684,
    );
    return { width: 684 * ratio, height: 684 * ratio };
  }

  render() {
    const parsedSvgData = this.parseSvgData(this.svg);
    const size = this.getSize();

    return (
      <div ref={this.containerRef} className="TacticalMapDrawn">
        {this.state.loadingBackup && !this.state.mapLoad && (
          <Box my="40%" textAlign="center">
            <h1>Loading map...</h1>
          </Box>
        )}
        {this.img && this.state.mapLoad && (
          <img src={this.img.src} width={size.width} height={size.height} />
        )}
        {parsedSvgData && this.state.mapLoad && (
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width={size.width}
            height={size.height}
            viewBox={'0 0 684 684'}
          >
            {parsedSvgData.map(
              (line, index) =>
                this.zlevel === line.zlevel && (
                  <line
                    key={index}
                    x1={line.x1}
                    y1={line.y1}
                    x2={line.x2}
                    y2={line.y2}
                    stroke={line.stroke}
                    strokeWidth={4}
                    strokeLinecap={'round'}
                  />
                ),
            )}
          </svg>
        )}
      </div>
    );
  }
}
