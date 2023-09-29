import { Component, createRef } from 'inferno';

export class DrawnMap extends Component {
  constructor(props) {
    super(props);
    this.containerRef = createRef();
    this.flatImgSrc = this.props.flatImage;
    this.backupImgSrc = this.props.backupImage;
    this.state = {
      mapLoad: true,
    };
    this.img = null;
    this.svg = this.props.svgData;
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
  }

  parseSvgData(svgDataArray) {
    if (!svgDataArray) return null;
    let lines = [];
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

  render() {
    const parsedSvgData = this.parseSvgData(this.svg);

    return (
      <div
        ref={this.containerRef}
        style={{
          position: 'relative',
          width: '100%',
          height: '100%',
        }}>
        <img
          src={this.img.src}
          style={{
            position: 'absolute',
            zIndex: 0,
          }}
          width={650}
          height={590}
        />
        {parsedSvgData && this.state.mapLoad && (
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width={650}
            height={590}
            viewBox={`0 0 650 590`}
            style={{
              position: 'absolute',
              top: 0,
              left: 0,
              zIndex: 1,
            }}>
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
      </div>
    );
  }
}
