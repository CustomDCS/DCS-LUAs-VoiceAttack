dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")

std_message_timeout = 8

local t_start = 0.0
local t_stop = 0.0
local dt = 0.07 -- Default Interval Between Commands In The stack


start_sequence_full = {}
stop_sequence_full = {}

function push_command(sequence, run_t, command)
	sequence[#sequence + 1] =  command
	sequence[#sequence]["time"] = run_t
end

function push_start_command(delta_t, command)
	t_start = t_start + delta_t
	push_command(start_sequence_full,t_start, command)
end

function push_stop_command(delta_t, command)
	t_stop = t_stop + delta_t
	push_command(stop_sequence_full,t_stop, command)
end

NO_FUEL = 1
COLLECTIVE = 2
BATTERY_LOW	= 3
APU_START_FAULT = 4
FUEL_PUMP_FAUL = 5
LEFT_ENGINE_START_FAULT = 6
RIGHT_ENGINE_START_FAULT = 7

alert_messages = {}
alert_messages[COLLECTIVE] = { message = _("SET THE COLLECTIVE STICK DOWN"), message_timeout = 10}
alert_messages[NO_FUEL] = 	 { message = _("CHECK FUEL QUANTITY"), message_timeout = 10}
alert_messages[BATTERY_LOW] = { message = _("POWER SUPPLY FAULT. CHECK THE BATTERY"), message_timeout = 10}
alert_messages[APU_START_FAULT] = { message = _("AI-9 NOT READY TO START ENGINE"), message_timeout = 10}
alert_messages[FUEL_PUMP_FAUL] = { message = _("FEEDING FUEL TANK PUMP FAULT"), message_timeout = 10}
alert_messages[LEFT_ENGINE_START_FAULT] = { message = _("LEFT ENGINE START FAULT"), message_timeout = 10}
alert_messages[RIGHT_ENGINE_START_FAULT] = { message = _("RIGHT ENGINE START FAULT"), message_timeout = 10}

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------


-- Function to collect all the start sequence commands.


push_start_command(dt, {message = _(" "), message_timeout = 120})	
push_start_command(dt, {message = _("=================================================="), message_timeout = 120})
push_start_command(dt, {message = _("  CustomDCS.com Super Quick Autostart Sequence Is Running (2m 10sec)"), message_timeout = 120})
push_start_command(dt, {message = _("          This Auto Start is Set For FARP SHARON"), message_timeout = 120})
push_start_command(dt, {message = _("=================================================="), message_timeout = 120})
	
	
-- Hide Seat

push_start_command(dt,{device = devices.CPT_MECH, action =  cockpit_mechanics_commands.Command_CPT_MECH_Elements_Hide, value = 1.0}) -- Turn Seat OFF

-- Close Doors

push_start_command(dt,{device = devices.CPT_MECH, action =  cockpit_mechanics_commands.Command_CPT_MECH_GENERAL_DOORS_CLOSE, value = 0.0}) -- Closes The Doors


-- Door Seal Rotary

push_start_command(0.3,{device = devices.ECS_INTERFACE,action =  ecs_commands.Sealing_valve, value = 0.0,}) -- Seal The Doors


-- Collective

push_start_command(0.1,{device = devices.ENGINE_INTERFACE, action = engine_commands.COLLECTIVE, value = -1.0,}) -- Collective Set To Down


-- Battery Switches

push_start_command(dt,{device = devices.ELEC_INTERFACE,action =  elec_commands.BatteryRight, value = 1.0}) -- Right Battery Switch ON
push_start_command(dt,{device = devices.ELEC_INTERFACE,action =  elec_commands.BatteryLeft, value = 1.0}) -- Left Battery Switch ON


--Network To Batteries Switch

push_start_command(dt,{device = devices.ELEC_INTERFACE,action =  elec_commands.NetworkToBatteriesCover, value = 1.0}) -- Network To Batteries Cover - OPEN
push_start_command(0.1,{device = devices.ELEC_INTERFACE,action =  elec_commands.NetworkToBatteries, value = 1.0}) -- Network To Batteries Switch ON


-- Circut Breakers

push_start_command(dt,{device = devices.ELEC_INTERFACE,action =  elec_commands.CB_FRAME_LEFT, value = 1.0}) -- Turn Left CBs ON
push_start_command(0.5,{device = devices.ELEC_INTERFACE,action =  elec_commands.CB_FRAME_LEFT, value = 0.0}) -- Release


-- Voice Warnings

push_start_command(dt,{device = devices.VMS,action =  RI65_commands.CMD_RI_Mi24_Off, value = 1.0})
push_start_command(0.5,{device = devices.VMS,action =  RI65_commands.CMD_RI_Mi24_Off, value = 0.0})


-- Circut Breakers

push_start_command(dt,{device = devices.ELEC_INTERFACE,action =  elec_commands.CB_FRAME_RIGHT, value = 1.0}) -- Turn Right CBs ON
push_start_command(0.5,{device = devices.ELEC_INTERFACE,action =  elec_commands.CB_FRAME_RIGHT, value = 0.0}) -- Release


-- Voice Warnings

push_start_command(0.0,{device = devices.VMS,action =  RI65_commands.CMD_RI_Mi24_Off, value = 1.0})
push_start_command(0.5,{device = devices.VMS,action =  RI65_commands.CMD_RI_Mi24_Off, value = 0.0})


-- Rectifiers - Generators - Transformers - Invertors

push_start_command(dt,{device = devices.ELEC_INTERFACE,action = elec_commands.RectifierLeft, value = 1.0,}) -- Left Rectifier Set To ON
push_start_command(dt,{device = devices.ELEC_INTERFACE,action = elec_commands.RectifierRight, value = 1.0,}) -- Right Rectifier Set To ON

push_start_command(dt,{device = devices.ELEC_INTERFACE,action = elec_commands.ACGeneratorLeft, value = 1.0}) -- Left Generator Set To ON
push_start_command(dt,{device = devices.ELEC_INTERFACE,action = elec_commands.ACGeneratorRight, value = 1.0}) -- Right Generator Set To ON

push_start_command(dt,{device = devices.ELEC_INTERFACE,action =  elec_commands.Transformer115vMainBackup, value = 1.0}) -- Left Transformer Set To ON
push_start_command(dt,{device = devices.ELEC_INTERFACE,action =  elec_commands.Transformer36vMainBackup, value = 1.0}) -- Right Transformer Set To ON

push_start_command(dt,{device = devices.ELEC_INTERFACE,action =  elec_commands.Rotary115vConverterCover, value = 1.0}) -- Inverter PO-750A Cover To OPEN
push_start_command(0.1,{device = devices.ELEC_INTERFACE,action =  elec_commands.Rotary115vConverter, value = 1.0}) -- Inverter PO-750A Cover Set To ON

push_start_command(dt,{device = devices.ELEC_INTERFACE,action =  elec_commands.Rotary36vConverterCover, value = 1.0}) -- Inverter PT-125Ts Cover To OPEN
push_start_command(0.1,{device = devices.ELEC_INTERFACE,action =  elec_commands.Rotary36vConverter, value = 1.0}) -- Inverter PT-125Ts Set To ON

push_start_command(0.0,{device = devices.VMS,action =  RI65_commands.CMD_RI_Mi24_Off, value = 1.0})
push_start_command(0.5,{device = devices.VMS,action =  RI65_commands.CMD_RI_Mi24_Off, value = 0.0})


-- Instrument Backing Lights

push_start_command(dt,{device = devices.INT_LIGHTS_SYSTEM,action =  int_lights_commands.RedLightsPilotInstrumentPanelRightPanel_1, value = 1.0,}) -- Red Lights Right And Pilot Panel Set To MAX
push_start_command(dt,{device = devices.INT_LIGHTS_SYSTEM,action =  int_lights_commands.RedLightsPilotInstrumentPanelRightPanel_2, value = 1.0,}) -- Red Lights Right And Pilot Panel Set To MAX
push_start_command(dt,{device = devices.INT_LIGHTS_SYSTEM,action =  int_lights_commands.RedLightsPilotLeftPanel_1, value = 1.0}) -- Red Lights Left Pilot Panel Set To MAX
push_start_command(dt,{device = devices.INT_LIGHTS_SYSTEM,action =  int_lights_commands.RedLightsPilotLeftPanel_2, value = 1.0}) -- Red Lights Left Pilot Panel Set To MAX
push_start_command(dt,{device = devices.INT_LIGHTS_SYSTEM,action =  int_lights_commands.RedLightsOperatorPanel_1, value = 1.0}) -- Red Lights Left And Operator Panel Set To MAX
push_start_command(dt,{device = devices.INT_LIGHTS_SYSTEM,action =  int_lights_commands.Transformer36vMainBackup, value = 1.0}) -- Red Lights Left And Operator Panel Set To MAX
push_start_command(dt,{device = devices.INT_LIGHTS_SYSTEM,action =  int_lights_commands.RedLightsPilotBuiltInRedLights, value = 1.0}) -- Builtin Red Lights Transformer Set To MAX


-- Voice Warnings

push_start_command(dt,{device = devices.VMS,action =  RI65_commands.CMD_RI_Mi24_Off, value = 1.0})
push_start_command(0.5,{device = devices.VMS,action =  RI65_commands.CMD_RI_Mi24_Off, value = 0.0})


-- Voice Warnings

push_start_command(0.4,{device = devices.VMS,action =  RI65_commands.CMD_RI_Mi24_Off, value = 1.0})
push_start_command(0.5,{device = devices.VMS,action =  RI65_commands.CMD_RI_Mi24_Off, value = 0.0})


-- Fuel Cutoff Switches

push_start_command(dt,{device = devices.FUELSYS_INTERFACE,action =  fuel_commands.ValveTank1, value = 1.0}) -- Tank 1 Cutoff Switch Set To ON
push_start_command(dt,{device = devices.FUELSYS_INTERFACE,action =  fuel_commands.ValveTank2, value = 1.0}) -- Tank 2 Cutoff Switch Set To ON
push_start_command(dt,{device = devices.FUELSYS_INTERFACE,action =  fuel_commands.Tank4Pump, value = 1.0}) -- Tank Pump 4 Set To ON
push_start_command(dt,{device = devices.FUELSYS_INTERFACE,action =  fuel_commands.Tank5Pump, value = 1.0}) -- Tank Pump 5 Set To ON
push_start_command(dt,{device = devices.FUELSYS_INTERFACE,action =  fuel_commands.Tank1Pump, value = 1.0}) -- Tank Pump 1 Set To ON
push_start_command(dt,{device = devices.FUELSYS_INTERFACE,action =  fuel_commands.Tank2Pump, value = 1.0}) -- Tank Pump 2 Set To ON
push_start_command(dt,{device = devices.FUELSYS_INTERFACE,action =  fuel_commands.ValveDelimiter, value = 1.0}) -- Fuel Delimiter Valve Set To ON


-- Voice Warnings

push_start_command(dt,{device = devices.VMS,action =  RI65_commands.CMD_RI_Mi24_Off, value = 1.0})
push_start_command(0.5,{device = devices.VMS,action =  RI65_commands.CMD_RI_Mi24_Off, value = 0.0})


-- APU Start START 15sec

push_start_command(dt,{device = devices.ENGINE_INTERFACE,action =  engine_commands.STARTUP_APU_Launch_Method, value = -1.0}) -- APU Selector Switch To START
push_start_command(dt,{device = devices.ENGINE_INTERFACE,action =  engine_commands.STARTUP_APU_StartUp, value = 1.0}) -- APU Start Button - Press
push_start_command(0.3,{device = devices.ENGINE_INTERFACE,action =  engine_commands.STARTUP_APU_StartUp, value = 0.0}) -- APU Start Button - Release

-- Voice Warnings

push_start_command(0.4,{device = devices.VMS,action =  RI65_commands.CMD_RI_Mi24_Off, value = 1.0})
push_start_command(0.4,{device = devices.VMS,action =  RI65_commands.CMD_RI_Mi24_Off, value = 0.0})


-- Voice Warnings

push_start_command(dt,{device = devices.VMS,action =  RI65_commands.CMD_RI_Mi24_Off, value = 1.0})
push_start_command(0.4,{device = devices.VMS,action =  RI65_commands.CMD_RI_Mi24_Off, value = 0.0})


-- Voice Warnings

push_start_command(4.5,{device = devices.VMS,action =  RI65_commands.CMD_RI_Mi24_Off, value = 1.0})
push_start_command(0.5,{device = devices.VMS,action =  RI65_commands.CMD_RI_Mi24_Off, value = 0.0})


-- APU Generator Switch

push_start_command(11,{device = devices.ELEC_INTERFACE,action =  elec_commands.DCGenerator, value = 1.0}) -- APU Gen Set To ON







