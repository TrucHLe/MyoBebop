-- cd developer/parrotdrone/samples/unix/BebopDroneDecodeStream

scriptId 				= 'bebop.parrot.0-14-0.myo'  
minMyoConnectVersion 	= '0.14.0'  
scriptTitle 			= 'Myo Bebop Connector'

description = [[ Let user control the Parrot Bebop Drone using Thalmic Labs' Myo armband ]]

controls 	= [[ 
- emergency landing = fingers spread
- take off/land 	= double tap

- pilot 	= fist
- hover		= release fist
- up 		= fist & arm out, roll 90 degrees toward upper body (just like waving to say "hi")
- down 		= fist & arm out, roll 90 degrees toward lower body
- left 		= fist & move arm to the left
- right 	= fist & move arm to the right
- forward	= fist & roll counter-clockwise
- backward	= fist & roll clockwise
- yaw left 	= wave out
- yaw right = wave in
 ]]

----------------------------
-- Fields
arm 		= "unknown"
isFlying 	= false
isPiloting	= false

canFlyUp 		= true
canFlyDown 		= true
canFlyLeft 		= true
canFlyRight 	= true
canFlyForward 	= true
canFlyBackward 	= true

canYawLeft		= false
canYawRight		= false

centerPitch	= 0
centerYaw 	= 0
centerRoll 	= 0

PI 				= 3.1416
TWO_PI 			= PI * 2
PITCH_DEADZONE 	= 0.3
YAW_DEADZONE 	= 0.3
ROLL_DEADZONE 	= 0.4

printPilotingSteps 	= false
printPitchYawRoll 	= false
printCounter 		= 0


----------------------------
-- Check if Terminal is in use
function onForegroundWindowChange( title, app )
	-- myo.debug("onForegroundWindowChange: " .. app .. " === " .. title)
	
	local titleMatch = string.match( title, "com.apple.Terminal" ) ~= nil
	-- com.apple.Terminal
	-- com.thalmic.myoconnect
	
	if ( titleMatch ) then
		myo.vibrate( "short" )
		arm = myo.getArm()
	end

	return titleMatch
end


function activeAppName()
	return "Terminal"
end



----------------------------
-- Piloting functions
function emergencyLanding()	
	isFlying = false
	myo.keyboard( "m", "press" )

	if flightDebugging then
		myo.debug( "emergencyLanding" )
	end
end


function takeOffAndLand()
	myo.vibrate( "medium" )
	myo.keyboard( "space", "press" )

	if not isFlying then
		isFlying = true

		if flightDebugging then
			myo.debug( "take off" )
		end
	else
		isFlying = false

		if flightDebugging then
			myo.debug( "land" )
		end
	end

end


function pilot()

	if isFlying then
		isPiloting = true
		myo.vibrate( "short" )

		if flightDebugging then
			myo.debug( "pilot" )
		end

		-- Get current pitch, yaw, and roll. Preparing to pilot.
		centerPitch = myo.getPitch()
		centerYaw 	= myo.getYaw()
		centerRoll 	= myo.getRoll()
	end
end


function hover()
	if isFlying then

		isPiloting 		= false
		
		canFlyUp 		= true
		canFlyDown 		= true
		canFlyLeft 		= true
		canFlyRight 	= true
		canFlyForward 	= true
		canFlyBackward 	= true
		
		myo.vibrate( "short" )

		if flightDebugging then
			myo.debug( "hover" )
		end
	end
end


function flyUp()
	if isPiloting and canFlyUp then

		canFlyDown 		= false
		canFlyLeft 		= false
		canFlyRight 	= false
		canFlyForward 	= false
		canFlyBackward 	= false

		myo.keyboard( "z", "down" )

		if flightDebugging then
			myo.debug( "up" )
		end
	end
end


function flyDown()
	if isPiloting and canFlyDown then
		
		canFlyUp 		= false
		canFlyLeft 		= false
		canFlyRight 	= false
		canFlyForward 	= false
		canFlyBackward 	= false

		myo.keyboard( "s", "down" )

		if flightDebugging then
			myo.debug( "down" )
		end
	end
end


function flyLeft()
	if isPiloting and canFlyLeft then
		
		canFlyUp 		= false
		canFlyDown 		= false
		canFlyRight 	= false
		canFlyForward 	= false
		canFlyBackward 	= false

		myo.keyboard( "left_arrow", "down" )

		if flightDebugging then
			myo.debug( "left" )
		end
	end
end


function flyRight()
	if isPiloting and canFlyRight then

		canFlyUp 		= false
		canFlyDown 		= false
		canFlyLeft 		= false
		canFlyForward 	= false
		canFlyBackward 	= false

		myo.keyboard( "right_arrow", "down" )

		if flightDebugging then
			myo.debug( "right" )
		end
	end
end


function flyForward()
	if isPiloting and canFlyForward then

		canFlyUp 		= false
		canFlyDown 		= false
		canFlyLeft 		= false
		canFlyRight 	= false
		canFlyBackward 	= false

		myo.keyboard( "up_arrow", "down" )

		if flightDebugging then
			myo.debug( "forward" )
		end
	end
end


function flyBackward()
	if isPiloting and canFlyBackward then

		canFlyUp 		= false
		canFlyDown 		= false
		canFlyLeft 		= false
		canFlyRight 	= false
		canFlyForward 	= false

		myo.keyboard( "down_arrow", "down" )

		if flightDebugging then
			myo.debug( "backward" )
		end
	end
end



----------------------------
-- Distinguish between waveIn and waveOut on left and right arm
-- to setup yawing functions

function setYawLeft()
	if not canYawLeft then
		canYawLeft = true
	else
		canYawLeft = false
	end
end


function setYawRight()
	if not canYawRight then
		canYawRight = true
	else
		canYawRight = false
	end
end


function setYawOut()
	if arm == "left" then
		setYawLeft()
	elseif arm == "right" then
		setYawRight()
	end
end


function setYawIn()
	if arm == "left" then
		setYawRight()
	elseif arm == "right" then
		setYawLeft()
	end
end


function yawLeft()
	if isFlying and canYawLeft then
		myo.keyboard( "q", "down" )

		if flightDebugging then
			myo.debug( "yawLeft" )
		end
	end
end


function yawRight()
	if isFlying and canYawRight then
		myo.keyboard( "d", "down" )

		if flightDebugging then
			myo.debug( "yawRight" )
		end
	end
end



----------------------------
-- Calculate current and new positions to pilot
function calculateDeltaRadians( current, center )
	local delta = current - center

	if delta > PI then
		delta = delta - TWO_PI
	elseif delta < -PI then
		delta = delta + TWO_PI
	end

	return delta
end



function onPeriodic()

	local currentPitch 	= myo.getPitch()
	local currentYaw 	= myo.getYaw()
	local currentRoll 	= myo.getRoll()

	local deltaPitch 	= calculateDeltaRadians( currentPitch, centerPitch )
	deltaYaw 		= calculateDeltaRadians( currentYaw, centerYaw )
	deltaRoll 	= calculateDeltaRadians( currentRoll, centerRoll );

	
	-- Debugging helper
	printCounter	= printCounter + 1
	if printCounter >= 200 and printPitchYawRoll then
		myo.debug( "deltaPitch = " .. deltaPitch )
		myo.debug( "deltaYaw = " .. deltaYaw )
		myo.debug( "deltaRoll = " .. deltaRoll )
		printCounter = 0
	end



	if deltaPitch > PITCH_DEADZONE then
		flyUp()
	end

	if deltaPitch < -PITCH_DEADZONE then
		flyDown()
	end
	
	if deltaYaw > YAW_DEADZONE then
		flyRight()
	end
	
	if deltaYaw < -YAW_DEADZONE then
		flyLeft()
	end
	
	if deltaRoll > ROLL_DEADZONE then
		if arm == "left" then
			flyBackward()
		elseif arm == "right" then
			flyForward()
		end
	end
	
	if deltaRoll < -ROLL_DEADZONE then		
		if arm == "left" then
			flyForward()
		elseif arm == "right" then
			flyBackward()
		end
	end

	if canYawLeft then
		yawLeft()
	end
	
	if canYawRight then
		yawRight()
	end

end


----------------------------
-- Map poses to functions
local BINDINGS =
{
	fingersSpread_on	= emergencyLanding,

	doubleTap_on 		= takeOffAndLand,
	
	fist_on 			= pilot,
	fist_off			= hover,

	waveOut_on			= setYawOut,
	waveOut_off			= setYawOut,
	waveIn_on			= setYawIn,
	waveIn_off			= setYawIn,
}

myo.setLockingPolicy("none")


function onPoseEdge( pose, edge )
	input = BINDINGS[pose.."_"..edge]
	if input then
		input()
	end
end

