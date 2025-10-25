import functionPlot from 'function-plot';
import { useEffect, useRef } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Section, Slider } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  analysis_duration: number;
  sensitivity: number;
  resolution: number;
  filter_mode: number;
  current_graph_index: number;
  phase: number;
  amplitude: number;
  plotData: {
    datasets: Array<{
      points: Array<[number, number]>;
      color: string;
      name: string;
    }>;
    xRange: [number, number];
    yRange: [number, number];
  } | null;
  componentData: {
    datasets: Array<{
      points: Array<[number, number]>;
      color: string;
      name: string;
    }>;
    xRange: [number, number];
    yRange: [number, number];
  } | null;
};

export const CorpseAnalyzer = (props) => {
  const { act, data } = useBackend<Data>();
  const topPlotRef = useRef<HTMLDivElement>(null);
  const bottomPlotRef = useRef<HTMLDivElement>(null);

  // Common plot configuration
  const plotConfig = {
    width: 600,
    height: 250,
    grid: true,
    disableZoom: true,
    xAxis: {
      label: 'Time (seconds)',
      domain: data.plotData?.xRange || [0, 10],
    },
    yAxis: {
      label: 'Analysis Data',
      domain: data.plotData?.yRange || [-2, 2],
    },
  };

  useEffect(() => {
    // Top graph
    if (topPlotRef.current) {
      topPlotRef.current.innerHTML = '';

      if (data.plotData) {
        functionPlot({
          target: topPlotRef.current,
          ...plotConfig,
          data: data.plotData.datasets.map((dataset) => ({
            points: dataset.points,
            fnType: 'points',
            graphType: 'polyline',
            color: dataset.color,
          })),
        });
      } else {
        // Fallback for top graph
        functionPlot({
          target: topPlotRef.current,
          ...plotConfig,
          data: [
            {
              fn: 'sin(x)',
              color: '#ff0000',
              graphType: 'polyline',
            },
          ],
        });
      }
    }

    // Bottom graph
    if (bottomPlotRef.current) {
      bottomPlotRef.current.innerHTML = '';

      if (data.componentData) {
        // Use componentData from backend instead of modified plotData
        functionPlot({
          target: bottomPlotRef.current,
          ...plotConfig,
          xAxis: {
            label: 'Time (seconds)',
            domain: data.componentData.xRange || [0, 10],
          },
          yAxis: {
            label: 'Component Data',
            domain: data.componentData.yRange || [-2, 2],
          },
          data: data.componentData.datasets.map((dataset) => ({
            points: dataset.points,
            fnType: 'points',
            graphType: 'polyline',
            color: dataset.color,
          })),
        });
      } else {
        // Fallback for bottom graph
        functionPlot({
          target: bottomPlotRef.current,
          ...plotConfig,
          data: [
            {
              fn: 'cos(x)',
              color: '#00ff00',
              graphType: 'polyline',
            },
          ],
        });
      }
    }
  }, [
    data.plotData,
    data.componentData,
    data.current_graph_index,
    data.phase,
    data.amplitude,
  ]);

  return (
    <Window width={850} height={880}>
      <Window.Content>
        {/* Displays total add of all components and a fit line */}
        <Section title="Total Analysis">
          <div
            ref={topPlotRef}
            style={{
              width: '600px',
              height: '250px',
              margin: '10px auto',
              border: '1px solid #ccc',
            }}
          />
        </Section>

        {/* Displays a singular component */}
        <Section title="Component Analysis">
          <div
            ref={bottomPlotRef}
            style={{
              width: '600px',
              height: '250px',
              margin: '10px auto',
              border: '1px solid #ccc',
            }}
          />
        </Section>

        {/* Control Panel - At Bottom */}
        <Section title="Analysis Controls">
          <div
            style={{
              display: 'flex',
              gap: '20px',
              alignItems: 'center',
              padding: '10px 0',
            }}
          >
            {/* Current Graph Indicator */}
            <div
              style={{
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                minWidth: '100px',
              }}
            >
              <div style={{ fontSize: '12px', color: '#888' }}>
                Current Graph
              </div>
              <div style={{ fontSize: '18px', fontWeight: 'bold' }}>
                {(data.current_graph_index || 0) + 1}
              </div>
            </div>

            {/* Sliders */}
            <div
              style={{
                display: 'flex',
                flexDirection: 'column',
                gap: '15px',
                flex: 1,
              }}
            >
              <div>
                <label style={{ display: 'block', marginBottom: '5px' }}>
                  Phase: {(data.phase || 0.0).toFixed(2)}π radians
                </label>
                <Slider
                  animated
                  value={data.phase || 0.0}
                  minValue={0}
                  maxValue={1}
                  step={0.01}
                  onChange={(e, value) => act('set_phase', { value: value })}
                />
              </div>

              <div>
                <label style={{ display: 'block', marginBottom: '5px' }}>
                  Amplitude: {(data.amplitude || 1.0).toFixed(1)}
                </label>
                <Slider
                  animated
                  value={data.amplitude || 1.0}
                  minValue={0.1}
                  maxValue={3.0}
                  step={0.1}
                  onChange={(e, value) =>
                    act('set_amplitude', { value: value })
                  }
                />
              </div>
            </div>

            {/* Navigation Buttons */}
            <div
              style={{ display: 'flex', flexDirection: 'column', gap: '5px' }}
            >
              <Button
                content="Next Graph"
                icon="chevron-up"
                color="blue"
                onClick={() => act('next_graph')}
              />
              <Button
                content="Previous Graph"
                icon="chevron-down"
                color="blue"
                onClick={() => act('previous_graph')}
              />
            </div>
          </div>
        </Section>
      </Window.Content>
    </Window>
  );
};
