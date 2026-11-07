import { Component, createRef } from 'react';
import { Box } from 'tgui/components';

export type FireSupportWarning = {
  id: string;
  x: number;
  y: number;
  label: string;
  color: string;
} & (
  | { shape: 'circle'; radius: number }
  | { shape: 'rectangle'; width: number; height: number }
);

type DrawMapRrops = {
  readonly fireSupportWarnings?: FireSupportWarning[];
  readonly svgData?: (
    string | number | CanvasGradient | CanvasPattern | null
  )[];
  readonly flatImage: string;
  readonly backupImage: string;
  readonly showLoading?: boolean;
};

export class DrawnMap extends Component<DrawMapRrops> {
  backupImgSrc: string;
  containerRef: React.RefObject<HTMLDivElement>;
  flatImgSrc: string;
  img: HTMLImageElement | null;
  svg?: (string | number | CanvasGradient | CanvasPattern | null)[];
  state: { mapLoad: boolean; loadingBackup: boolean };
  showLoading: boolean;
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
    this.showLoading = this.props.showLoading ?? true;
  }

  componentDidMount() {
    this.img = new Image();
    this.img.src = this.flatImgSrc;
    this.img.onload = () => {
      this.setState({ mapLoad: true });
    };

    this.img.onerror = () => {
      if (this.img) {
        this.img.src = this.backupImgSrc;
        this.setState({ mapLoad: false });
      }
    };

    const backupImg = new Image();
    backupImg.src = this.backupImgSrc;
    backupImg.onload = () => {
      this.setState({ loadingBackup: false });
    };
  }

  parseSvgData(svgDataArray) {
    if (!svgDataArray) return null;
    let lines: {
      x1: number;
      y1: number;
      x2: number;
      y2: number;
      stroke: string;
    }[] = [];
    for (let i = 0; i < svgDataArray.length; i += 5) {
      const x1 = svgDataArray[i];
      const y1 = svgDataArray[i + 1];
      const x2 = svgDataArray[i + 2];
      const y2 = svgDataArray[i + 3];
      const stroke = svgDataArray[i + 4];
      lines.push({ x1, y1, x2, y2, stroke });
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
        {this.state.loadingBackup &&
          !this.state.mapLoad &&
          this.showLoading && (
            <Box my="40%">
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
            {parsedSvgData.map((line, index) => (
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
            ))}
          </svg>
        )}
        {!!this.props.fireSupportWarnings?.length &&
          !!this.props.flatImage &&
          this.state.mapLoad && (
            <svg
              width={size.width}
              height={size.height}
              viewBox="0 0 512 512"
              style={{ pointerEvents: 'none', zIndex: 2 }}
            >
              {this.props.fireSupportWarnings?.map((warning) => (
                <g key={warning.id}>
                  {warning.shape === 'rectangle' ? (
                    <rect
                      x={warning.x}
                      y={warning.y}
                      width={warning.width}
                      height={warning.height}
                      fill={warning.color}
                      fillOpacity={0.18}
                      stroke={warning.color}
                      strokeWidth={1}
                    />
                  ) : (
                    <circle
                      cx={warning.x}
                      cy={warning.y}
                      r={warning.radius}
                      fill={warning.color}
                      fillOpacity={0.18}
                      stroke={warning.color}
                      strokeWidth={1}
                    />
                  )}
                  <text
                    x={
                      warning.x +
                      (warning.shape === 'rectangle' ? warning.width / 2 : 0)
                    }
                    y={
                      warning.y -
                      (warning.shape === 'circle' ? warning.radius : 0) -
                      3
                    }
                    fill={warning.color}
                    stroke="#000"
                    strokeWidth={0.5}
                    fontSize={7}
                    textAnchor="middle"
                  >
                    {warning.label}
                  </text>
                </g>
              ))}
            </svg>
          )}
      </div>
    );
  }
}
