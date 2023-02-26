import { Component } from 'inferno';

interface TimedCallbackProps {
  time: number;
  callback: () => void;
}

interface TimedCallbackState {
  timeout?: NodeJS.Timeout;
}

export class TimedCallback extends Component<
  TimedCallbackProps,
  TimedCallbackState
> {
  timeout?: NodeJS.Timeout;
  constructor(props: TimedCallbackProps) {
    super(props);
  }

  componentDidMount() {
    this.timeout = setTimeout(() => this.props.callback(), this.props.time);
  }

  componentWillUnmount() {
    if (this.state?.timeout) {
      clearTimeout(this.state.timeout);
    }
  }
  render() {
    return <div />;
  }
}
