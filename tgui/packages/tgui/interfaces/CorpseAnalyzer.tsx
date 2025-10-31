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
  // Add graph stats
  current_damage_type: string;
  base_frequency: number;
  base_amplitude: number;
  base_phase: number;
  wave_color: string;
  plotData: {
    datasets: Array<{
      points: Array<[number, number]>;
      color: string;
      name: string;
    }>;
  } | null;
  componentData: {
    datasets: Array<{
      points: Array<[number, number]>;
      color: string;
      name: string;
    }>;
  } | null;
};

export const CorpseAnalyzer = () => {
  const { act, data } = useBackend<Data>();
  const topPlotRef = useRef<HTMLDivElement>(null);
  const bottomPlotRef = useRef<HTMLDivElement>(null);

  // Static plot configuration
  const plotConfig = {
    width: 600,
    height: 250,
    grid: true,
    disableZoom: true,
    xAxis: {
      label: 'Time (seconds)',
      domain: [0, data.analysis_duration || 10],
    },
    yAxis: {
      label: 'Analysis Data',
      domain: [-3, 3],
    },
  };

  useEffect(() => {
    // Top graph
    if (topPlotRef.current) {
      topPlotRef.current.innerHTML = '';

      if (data.plotData && data.plotData.datasets) {
        functionPlot({
          target: topPlotRef.current,
          ...plotConfig,
          data: data.plotData.datasets.map((dataset) => ({
            points: dataset.points,
            fnType: 'points',
            graphType: 'scatter',
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

      if (data.componentData && data.componentData.datasets) {
        functionPlot({
          target: bottomPlotRef.current,
          ...plotConfig,
          yAxis: {
            label: 'Component Data',
            domain: [-3, 3],
          },
          data: data.componentData.datasets.map((dataset) => ({
            points: dataset.points,
            fnType: 'points',
            graphType: 'scatter',
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
    data.analysis_duration,
  ]);

  return (
    <Window width={850} height={880}>
      <Window.Content>
        {/* Graph Stats Display */}
        <Section
          title={`${data.current_damage_type || 'Unknown'} Wave Analysis`}
        >
          <div
            style={{
              display: 'flex',
              gap: '20px',
              padding: '10px',
              backgroundColor: '#1a1a1a',
              borderRadius: '5px',
              marginBottom: '10px',
            }}
          >
            <div style={{ flex: 1 }}>
              <div
                style={{
                  fontSize: '14px',
                  fontWeight: 'bold',
                  marginBottom: '5px',
                }}
              >
                Base Wave Properties:
              </div>
              <div style={{ fontSize: '12px', lineHeight: '1.4' }}>
                <div>
                  <strong>Frequency:</strong>{' '}
                  {(data.base_frequency || 0).toFixed(3)} rad/s
                </div>
                <div>
                  <strong>Amplitude:</strong>{' '}
                  {(data.base_amplitude || 0).toFixed(2)}
                </div>
                <div>
                  <strong>Phase:</strong> {(data.base_phase || 0).toFixed(3)}{' '}
                  rad
                </div>
                <div>
                  <strong>Color:</strong>{' '}
                  <span style={{ color: data.wave_color || '#ffffff' }}>●</span>{' '}
                  {data.wave_color || '#ffffff'}
                </div>
              </div>
            </div>
            <div style={{ flex: 1 }}>
              <div
                style={{
                  fontSize: '14px',
                  fontWeight: 'bold',
                  marginBottom: '5px',
                }}
              >
                Current Modifiers:
              </div>
              <div style={{ fontSize: '12px', lineHeight: '1.4' }}>
                <div>
                  <strong>Phase Shift:</strong> +{(data.phase || 0).toFixed(3)}π
                  rad
                </div>
                <div>
                  <strong>Amplitude Scale:</strong> ×
                  {(data.amplitude || 1).toFixed(2)}
                </div>
                <div>
                  <strong>Effective Frequency:</strong>{' '}
                  {(data.base_frequency || 0).toFixed(3)} rad/s
                </div>
                <div>
                  <strong>Effective Amplitude:</strong>{' '}
                  {((data.base_amplitude || 0) * (data.amplitude || 1)).toFixed(
                    2,
                  )}
                </div>
              </div>
            </div>
          </div>
        </Section>

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
                  Phase: {(data.phase || 0.0).toFixed(3)}π radians
                </label>
                <Slider
                  animated
                  value={data.phase || 0.0}
                  minValue={0}
                  maxValue={1}
                  step={0.001} // Reduced from 0.01 for finer control
                  onChange={(e, value) => act('set_phase', { value: value })}
                />
              </div>

              <div>
                <label style={{ display: 'block', marginBottom: '5px' }}>
                  Amplitude: {(data.amplitude || 1.0).toFixed(2)}
                </label>
                <Slider
                  animated
                  value={data.amplitude || 1.0}
                  minValue={0.1}
                  maxValue={3.0}
                  step={0.005} // Reduced from 0.1 for smoother control
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
