dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")

local dt_mto = 10 -- seconds

local t_start = 0.0
local t_stop = 0.0
local dt = 0.2 -- seconds
local rotor_spin_down = 1*60 + 10 -- seconds

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

alert_messages = {}
alert_messages[COLLECTIVE] 	= { message = _("SET THE COLLECTIVE STICK DOWN"), message_timeout = 10}
alert_messages[NO_FUEL] 	= { message = _("CHECK FUEL QUANTITY"), message_timeout = 10}
alert_messages[BATTERY_LOW] = { message = _("CHECK THE BATTERY"), message_timeout = 10}


----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-- Start sequence
local function doStartSequence()
	push_start_command(0, {message = _("HAVOC'S QUICK AUTOSTART IS RUNNING"), message_timeout = dt_mto}) -- Message text and timeout will be modified by insertTimeRemaining function below.

	-- Set intercom mode knob to INT, allows rearming.
	push_start_command(dt, {message = _("INTERCOM MODE KNOB - INT"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.INTERCOM, action = device_commands.Button_8, value = 0.1})
	
	push_start_command(dt, {message = _("DOORS - CLOSE"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.CPT_MECH, action = device_commands.Button_7, value = 0.0})
	
	push_start_command(dt, {message = _("ENGINE START BUTTON - OFF"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_12, value = 0.0})
	--push_start_command(dt, {action = 97, value = 1.0,message = _("RESET CONTROLS TO NULL"), message_timeout = dt_mto})

	--for i = 0.0, 4.0, 0.1 do
		--push_start_command(0.1,{action = 632})
	--end

	-- Reset circuit breakers
	push_start_command(dt, {message = _("All CBs - IN"), message_timeout = dt_mto})
	-- NOTE cb_start_cmd and cb_emd_cmd are defined in command_defs.lua
	for i = cb_start_cmd, cb_end_cmd, 1 do
		push_start_command(0.01, {device = devices.ELEC_INTERFACE, action = i, value  = 1.0})
	end

	push_start_command(dt, {message = _("AC VOLTMETER - AC PHASE"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_7, value = 0.1})
	
	push_start_command(dt, {message = _("INVERTER - OFF"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_8, value = 0.0})
	
	push_start_command(dt, {message = _("MAIN GENERATOR - ON"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_19, value = 1.0}) -- Cover open (it starts open on cold spawn)
	push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_2, value = -1.0}) -- Switch
	push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_19, value = 0.0}) -- Cover close
	
	push_start_command(dt, {message = _("DC VOLTMETER - ESS BUS"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_4, value = 0.3})
	
	push_start_command(dt, {message = _("STARTER-GENERATOR - START"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_3, value = 1.0})
	
	push_start_command(dt, {message = _("BATTERY - ON"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_1, value = 0.0})
	
	push_start_command(dt, {message = _("LOW RPM WARNING AUDIO - OFF"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_21, value = 0.0})
	
	push_start_command(dt, {message = _("GOVERNOR - AUTO"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_14, value = 1.0})
	
	push_start_command(dt, {message = _("DE-ICE - OFF"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_2, value = 0.0})
	
	push_start_command(dt, {message = _("MAIN FUEL - ON"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.FUELSYS_INTERFACE, action = device_commands.Button_1, value = 1.0})
	
	push_start_command(dt, {message = _("CAUTION PANEL LIGHTS TEST"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.SYS_CONTROLLER, action = device_commands.Button_1, value = -1.0})
	push_start_command(dt, {device = devices.SYS_CONTROLLER, action = device_commands.Button_1, value = 0.0})
	
	push_start_command(dt, {message = _("HYDRAULIC CONTROL - ON"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.HYDRO_SYS_INTERFACE, action = device_commands.Button_3, value = 1.0})
	
	push_start_command(dt, {message = _("FORCE TRIM - ON"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.HYDRO_SYS_INTERFACE, action = device_commands.Button_4, value = 1.0})
	
	push_start_command(dt, {message = _("CHIP DETECTOR - BOTH"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_13, value = 0.0})

	push_start_command(dt, {message = _("THROTTLE - SET TO START POSITION"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_24, value = 0.0})
--	for i = 0.0, 20.0, 0.1 do
--		push_start_command(0.05, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_24, value = 0.0})
--	end
	
	push_start_command(dt, {message = _("START ENGINE (40s)"), message_timeout = 40.0})
	push_start_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_12, value = 1.0}) -- Press
	push_start_command(40.0, {message = _("ENGINE STARTED, RELEASING START BUTTON"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_12, value = 0.0}) -- Release
	
	push_start_command(dt, {message = _("INVERTER - MAIN ON"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_8, value = -1.0})
	
	push_start_command(dt, {message = _("STARTER-GENERATOR - STBY GEN"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_3, value = 0.0})
	
	push_start_command(dt, {message = _("DC VOLTMETER - MAIN GEN"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_4, value = 0.3})

	push_start_command(dt, {message = _("THROTTLE - SET TO FULL"), message_timeout = dt_mto})
	for i = 0.0, 20.0, 0.1 do
		push_start_command(0.05, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_25, value = 0.5})
	end
	push_start_command(dt, {message = _("WAIT FOR ROTOR TO SPOOL UP (15s)"), message_timeout = 15.0})
	push_start_command(15.0, {message = _("ROTOR SPOOLED UP"), message_timeout = dt_mto})
	
	push_start_command(dt, {message = _("LOW RPM WARNING AUDIO - ON"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_21, value = 1.0})
	
	push_start_command(dt, {message = _("MASTER CAUTION - RESET"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.SYS_CONTROLLER, action = device_commands.Button_1, value = 1.0})
	push_start_command(dt, {device = devices.SYS_CONTROLLER, action = device_commands.Button_1, value = 0.0})
	
	push_start_command(dt, {message = _("IFF - NORM"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.IFF, action = device_commands.Button_8, value = 0.4})
	
	push_start_command(dt, {message = _("RADAR ALTIMETER ON"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.RADAR_ALTIMETER, action = device_commands.Button_7, value = 1.0})
	push_start_command(dt, {message = _("RADAR ALTIMETER LOW ALT"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.RADAR_ALTIMETER, action = device_commands.Button_2, value = 0.6})
	push_start_command(dt, {device = devices.RADAR_ALTIMETER, action = device_commands.Button_2, value = 1.0})
	push_start_command(dt, {device = devices.RADAR_ALTIMETER, action = device_commands.Button_2, value = 0.8})
	
	push_start_command(dt, {message = _("RADAR ALTIMETER HIGH ALT"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.RADAR_ALTIMETER, action = device_commands.Button_3, value = 1.0})
	push_start_command(dt, {device = devices.RADAR_ALTIMETER, action = device_commands.Button_3, value = 1.0})
	push_start_command(dt, {device = devices.RADAR_ALTIMETER, action = device_commands.Button_3, value = 1.0})
	push_start_command(dt, {device = devices.RADAR_ALTIMETER, action = device_commands.Button_3, value = 1.0})
	push_start_command(dt, {device = devices.RADAR_ALTIMETER, action = device_commands.Button_3, value = 1.0})
	push_start_command(dt, {device = devices.RADAR_ALTIMETER, action = device_commands.Button_3, value = 0.5})

	push_start_command(dt, {message = _("ARC-51BX UHF RADIO (COM1) - T/R"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.UHF_ARC_51, action = device_commands.Button_6, value = 0.1})
	
	push_start_command(dt, {message = _("ARC-134 VHF AM RADIO (COM2) - ON"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.VHF_ARC_134, action = device_commands.Button_4, value = 0.1})
	
	push_start_command(dt, {message = _("ARC-131 VHF FM RADIO (COM3) - T/R"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.VHF_ARC_131, action = device_commands.Button_7, value = 0.1})
	
	push_start_command(dt, {message = _("MASTER ARM - ON"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.WEAPON_SYS, action = device_commands.Button_8, value = 1.0})
	
	push_start_command(dt, {message = _("ROCKET PAIRS - 1"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.WEAPON_SYS, action = device_commands.Button_11, value = 0.1})
	
	push_start_command(dt, {message = _("FLARE DISPENSER - ARM"), message_timeout = dt_mto})
	push_start_command(dt, {device = devices.XM_130, action = device_commands.Button_5, value = 1.0})
	
	push_start_command(dt, {message = _("FLARE DISPENSER COUNT - 30"), message_timeout = dt_mto})
	for i = 1, 30, 1 do
		push_start_command(0.01, {device = devices.XM_130, action = device_commands.Button_4, value = 0.1})
	end
	
	push_start_command(dt, {message = _("HAVOC'S QUICK AUTOSTART IS COMPLETE"), message_timeout = 60.0})
	push_start_command(dt, {message = _("Manual steps remaining:"), message_timeout = 60.0})
	push_start_command(dt, {message = _("Syncronize HSI compass (backup compass shows current heading)"), message_timeout = 60.0})
	push_start_command(dt, {message = _("Radios ... As needed"), message_timeout = 60.0})
	-- TODO:
	-- Weapons ARM
	-- Flares ARM
	-- Reminder to sync compass
end
doStartSequence()


----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-- Stop sequence
local function doStopSequence()
	push_stop_command(0, {message = _("HAVOC'S QUICK AUTOSTOP IS RUNNING"), message_timeout = dt_mto}) -- Message text and timeout will be modified by insertTimeRemaining function below.

	push_stop_command(dt, {message = _("ENGINE START BUTTON - OFF"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_12, value = 0.0})

	push_stop_command(dt, {message = _("THROTTLE - SET TO OFF"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_27, value = 1.0}) -- Throttle stop switch??
	for i = 0.0, 20.0, 0.2 do
		push_stop_command(0.1, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_25, value = -0.5})
	end
	push_stop_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_27, value = 0.0}) -- Throttle stop switch??
	
	push_stop_command(dt, {message = _("LOW RPM WARNING AUDIO - OFF"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_21, value = 0.0})
	
	push_stop_command(dt, {message = _("Waiting for rotor to spin down (" .. math.floor(rotor_spin_down / 60) .."m".. rotor_spin_down % 60 .. "s) ..."), message_timeout = rotor_spin_down})
	local rotor_spin_down_timer = t_start -- Start a timer for the alignment process at the current t_start value.

	push_stop_command(dt, {message = _("FORCE TRIM - OFF"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.HYDRO_SYS_INTERFACE, action = device_commands.Button_4, value = 0.0})
	
	push_stop_command(dt, {message = _("STARTER-GENERATOR - START"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_3, value = 1.0})
	
	push_stop_command(dt, {message = _("MAIN FUEL - OFF"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.FUELSYS_INTERFACE, action = device_commands.Button_1, value = 0.0})
	push_stop_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_21, value = 0.0})
	
	push_stop_command(dt, {message = _("AC VOLTMETER - AB"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_7, value = 0.0})
	
	push_stop_command(dt, {message = _("DC VOLTMETER - MAIN GEN"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_4, value = 0.3})
	
	push_stop_command(dt,{message = _("INVERTER - OFF"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_8, value = 0.0})
	
	push_stop_command(dt, {message = _("MAIN GENERATOR - OFF"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_19, value = 1.0}) -- Cover open
	push_stop_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_2, value = 0.0}) -- Switch
	push_stop_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_19, value = 0.0}) -- Cover close
	
	push_stop_command(dt, {message = _("PITOT HEATER - OFF"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_16, value = 0.0})
	
	push_stop_command(dt, {message = _("BATTERY - OFF"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.ELEC_INTERFACE, action = device_commands.Button_1, value = 1.0})
	
	push_stop_command(dt, {message = _("HYDRO CONTROL - OFF"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.HYDRO_SYS_INTERFACE, action = device_commands.Button_3, value = 0.0})
			
	push_stop_command(dt, {message = _("ARC-51BX UHF RADIO (COM1) - OFF"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.UHF_ARC_51, action = device_commands.Button_6, value = 0.0})
	
	push_stop_command(dt, {message = _("ARC-134 VHF AM RADIO (COM2) - OFF"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.VHF_ARC_134, action = device_commands.Button_4, value = 0.0})
	
	push_stop_command(dt, {message = _("ARC-131 VHF FM RADIO (COM3) - OFF"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.VHF_ARC_131, action = device_commands.Button_7, value = 0.0})
	
	push_stop_command(dt, {message = _("MASTER ARM - OFF"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.WEAPON_SYS, action = device_commands.Button_8, value = -1.0})
	
	push_stop_command(dt, {message = _("ROCKET PAIRS - 0"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.WEAPON_SYS, action = device_commands.Button_11, value = 0.0})
	
	push_stop_command(dt, {message = _("FLARE DISPENSER - SAFE"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.XM_130, action = device_commands.Button_5, value = 0.0})
	
	push_stop_command(dt, {message = _("FLARE DISPENSER COUNT - 0"), message_timeout = dt_mto})
	for i = 1, 30, 1 do
		push_stop_command(0.01, {device = devices.XM_130, action = device_commands.Button_3, value = 0.1})
	end
	
	-- Wait until the rotor has stopped (total process time minus the difference between now and when the process started).
	push_stop_command(rotor_spin_down - (t_start - rotor_spin_down_timer), {message = _("Rotor has stopped"), message_timeout = dt_mto})
	
	push_stop_command(dt, {message = _("LOW RPM WARNING AUDIO - ON"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.ENGINE_INTERFACE, action = device_commands.Button_21, value = 1.0})

	push_stop_command(dt, {message = _("OPENING COCKPIT DOORS"), message_timeout = dt_mto})
	push_stop_command(dt, {device = devices.CPT_MECH, action = device_commands.Button_7, value = 1.0})

	push_stop_command(dt, {message = _("HAVOC'S QUICK AUTOSTOP IS COMPLETE"), message_timeout = 60.0})
end
doStopSequence()


----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-- Inserts messages into the sequence that show how many minutes there are remaining in the sequence.  Adds " (XmXs)" time display to the end of the first item in the sequence (which must be a message, and is by default).  Sets the message timeout of the first item to be the total time.
local function insertTimeRemaining(sequence, endingTime)
	local totalTime = math.ceil(endingTime) -- Round up to the next whole second.
	local totalTimeMins = math.floor(totalTime / 60)
	local totalTimeSecs = totalTime % 60
	-- Add the total time onto the end of the initial sequence message.
	sequence[1]['message'] = sequence[1]['message']..' ('..totalTimeMins..'m'..totalTimeSecs..'s)'
	-- Set the message timeout to be the total time.
	sequence[1]['message_timeout'] = endingTime

	local minsRemaining = totalTimeMins
	local i = 1
	while sequence[i] do
		-- If the current array element has a time less than or equal to our current number of minutes remaining, insert an element at the current position that shows the time remaining.
		if minsRemaining ~= 0 and endingTime - sequence[i]['time'] <= minsRemaining * 60 then
			if minsRemaining == 1 then
				minutesString = 'MINUTE'
			else
				minutesString = 'MINUTES'
			end
			table.insert(sequence, i, {message = _('=== '..minsRemaining..' '..minutesString..' REMAINING ==='), message_timeout = 60})
			sequence[i]['time'] = endingTime - minsRemaining * 60.0
			--log.info('sequence[i]: '..sequence[i]['message'])
			-- Subtract 1 minute from the remaining minutes to do.
			minsRemaining = minsRemaining - 1
			-- Decrement the index counter since we just added an element.  This makes sure we don't skip one.
			i = i - 1
		end
		-- Increment the index counter to go to the next element.
		i = i + 1
	end
	log.info('Start/Stop sequence time: '..totalTimeMins..'m'..totalTimeSecs..'s')
end
insertTimeRemaining(start_sequence_full, t_start)
insertTimeRemaining(stop_sequence_full, t_stop)

-- Debug function to log all the timing and message data for the entire sequence.  Useful to check to make sure the right values are going in, and in the right order.
local function logSequenceData()
	for i = 1, #start_sequence_full do
		local message = '(action)'
		if start_sequence_full[i]['message'] then
			message = start_sequence_full[i]['message']
		end
		log.info("start_sequence_full[i]['time']: "..start_sequence_full[i]['time']..', remaining: '..t_start-start_sequence_full[i]['time']..', message: '..message)
	end
end
--logSequenceData()




