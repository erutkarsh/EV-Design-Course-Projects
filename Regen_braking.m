%% Regenerative Braking Simulation - PMSM EV

% Create new model
modelName = 'EV_REGEN';
new_system(modelName)
open_system(modelName)
%% Add Generic Battery Block
battery = [modelName '/Battery'];
add_block('powerlib/Elements/Voltage Source', battery, 'Position', [50 50 150 100]);
set_param(battery, 'amplitude', '48', 'Frequency', '0', 'Phase', '0');

%% Add Universal Bridge (Inverter)
inverter = [modelName '/Inverter'];
add_block('powerlib/Power Electronics/Universal Bridge', inverter, 'Position', [250 50 350 150]);
set_param(inverter, 'Device', 'IGBT/Diode', 'NumberofBridges', '1');

%% Add PMSM Motor
pmsm = [modelName '/PMSM'];
add_block('powerlib/Machines/Permanent Magnet Synchronous Machine', pmsm, 'Position', [500 50 650 150]);
set_param(pmsm, 'Rs', '0.1', 'Ld', '0.005', 'Lq', '0.005', 'FluxLinkage', '0.1', 'PolePairs', '4');

%% Add Rotational Damper (2-port)
damper = [modelName '/Rotational Damper'];
add_block('fl_lib/Mechanical/Rotational Elements/Rotational Damper', damper, 'Position', [500 250 600 300]);
set_param(damper, 'Damping', '10');

%% Add Inertia (1-port)
inertia = [modelName '/Inertia'];
add_block('fl_lib/Mechanical/Rotational Elements/Inertia', inertia, 'Position', [700 250 800 300]);
set_param(inertia, 'Inertia', '45');

%% Add Mechanical Reference (Ground)
ground = [modelName '/Mechanical Ground'];
add_block('fl_lib/Mechanical/Rotational Elements/Mechanical Reference', ground, 'Position', [900 250 950 300]);

%% Add Scope
scope = [modelName '/Scope'];
add_block('simulink/Sinks/Scope', scope, 'Position', [1000 50 1100 150]);

%% Connect Electrical Side
add_line(modelName, 'Battery/+', 'Inverter/1');
add_line(modelName, 'Battery/-', 'Inverter/2');
add_line(modelName, 'Inverter/1', 'PMSM/A');
add_line(modelName, 'Inverter/2', 'PMSM/B');
add_line(modelName, 'Inverter/3', 'PMSM/C');

%% Connect Mechanical Side (simplified without torque sensor)
add_line(modelName, 'PMSM/m', 'Rotational Damper/R');
add_line(modelName, 'Rotational Damper/C', 'Inertia/R');
add_line(modelName, 'Inertia/C', 'Mechanical Ground/1');

%% Optional: Add PS-Simulink Converter for Torque
torqueConv = [modelName '/Torque Converter'];
add_block('simscape/PS-Simulink Converter', torqueConv, 'Position', [800 50 900 100]);
add_line(modelName, 'PMSM/MechanicalTorque', 'Torque Converter/1');
add_line(modelName, 'Torque Converter/1', 'Scope/1');

%% Save and open model
save_system(modelName)
open_system(modelName)
