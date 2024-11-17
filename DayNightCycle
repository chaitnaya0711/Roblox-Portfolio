local CYCLEduration = 300
local DAYstartTime = 6
local nightSTARTtime = 18
local lighting = game:GetService("Lighting")
local soundSERVICE = game:GetService("SoundService")

local DayAMBIENT = Instance.new("Sound")
DayAMBIENT.Name = "DayAmbient"
DayAMBIENT.SoundId = "rbxassetid://6189453706"
DayAMBIENT.Looped = true
DayAMBIENT.Volume = 10
DayAMBIENT.Parent = soundSERVICE

local NIGHTambient = Instance.new("Sound")
NIGHTambient.Name = "NightAmbient"
NIGHTambient.SoundId = "rbxassetid://179507208"
NIGHTambient.Looped = true
NIGHTambient.Volume = 10
NIGHTambient.Parent = soundSERVICE

DayAMBIENT:Play()
NIGHTambient:Play()

local minutesPerCYCLE = CYCLEduration * 60 / 24
local currentMINUTES = DAYstartTime * 60

local function LERP(a, b, t)
	return a + (b - a) * t
end

local function updateCYCLE()
	local currentHOUR = math.floor(currentMINUTES / 60) % 24
	local normalizedTIME = (currentMINUTES % 1440) / 1440

	lighting.ClockTime = currentHOUR + (currentMINUTES % 60) / 60

	local isDaytransition = currentHOUR >= DAYstartTime and currentHOUR < nightSTARTtime
	local transitionDURATION = 1

	local ALPHA = 0
	if isDaytransition then
		if currentHOUR == DAYstartTime then
			ALPHA = (currentMINUTES % 60) / 60
		elseif currentHOUR == (nightSTARTtime - 1) then
			ALPHA = 1 - (currentMINUTES % 60) / 60
		else
			ALPHA = 1
		end
	else
		if currentHOUR == nightSTARTtime then
			ALPHA = 1 - (currentMINUTES % 60) / 60
		elseif currentHOUR == (DAYstartTime - 1) then
			ALPHA = (currentMINUTES % 60) / 60
		else
			ALPHA = 0
		end
	end

	lighting.Brightness = LERP(1, 4, ALPHA)
	lighting.OutdoorAmbient = Color3.new(
		LERP(40/255, 190/255, ALPHA),
		LERP(40/255, 190/255, ALPHA),
		LERP(60/255, 190/255, ALPHA)
	)
	lighting.Ambient = Color3.new(
		LERP(25/255, 180/255, ALPHA),
		LERP(25/255, 220/255, ALPHA),
		LERP(112/255, 255/255, ALPHA)
	)
	lighting.FogEnd = LERP(800, 1500, ALPHA)
	lighting.EnvironmentDiffuseScale = LERP(0.8, 1.5, ALPHA)
	lighting.EnvironmentSpecularScale = LERP(0.8, 1.5, ALPHA)
	lighting.ShadowSoftness = LERP(0.4, 0.2, ALPHA)

	DayAMBIENT.Volume = LERP(0, 0.5, ALPHA)
	NIGHTambient.Volume = LERP(0.5, 0, ALPHA)
end

game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
	currentMINUTES = currentMINUTES + (deltaTime * 1440 / CYCLEduration)
	if currentMINUTES >= 1440 then
		currentMINUTES = 0
	end
	updateCYCLE()
end)
