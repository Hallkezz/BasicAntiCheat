---------------
--By Hallkezz--
---------------

-----------------------------------------------------------------------------------
--Default Settings
local Logs = true -- Save messages in logs? (Use: true/false )
local ExtremeLogs = false -- On bullet/explosion hit shows the number of player health in logs. (Use: true/false )
local KickCheaters = false -- Kick cheaters? (Use: true/false )
---------------------
local ACPrefix = "[Anti-Cheat] " -- It's prefix name.
local CHText = "Checking for cheats is progressing..." -- Message on check cheats.
local FCText = "Cheats found. Please disable cheats or send report to administration." -- Message on found cheats.
local NFCText = "Cheats not found." -- Message on not found cheats.
local KText = " has kicked for using cheats." -- Message on kick.
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
--Script
class 'GodCheck'

function GodCheck:__init()
	Events:Subscribe( "ModuleLoad", self, self.ModuleLoad )

	Network:Subscribe( "ExtremeBulletHitLogs", self, self.ExtremeBulletHitLogs )
	Network:Subscribe( "ExtremeExplosionHitLogs", self, self.ExtremeExplosionHitLogs )
	Network:Subscribe( "SuspicionLevel", self, self.SuspicionLevel )
	Network:Subscribe( "CheckThisPlayer", self, self.CheckThisPlayer )
	Network:Subscribe( "ItsCheater", self, self.ItsCheater )

	Console:Subscribe( "achelp", self, self.GetHelp )
	Console:Subscribe( "aclogs", self, self.ToggleLogs )
	Console:Subscribe( "acextremelogs", self, self.ToggleExtremeLogs )
	Console:Subscribe( "ackickcheaters", self, self.ToggleKickCheaters )

	Events:Subscribe( "PlayerQuit", self, self.PlayerQuit )

	self.phealth = {}
end

function GodCheck:ModuleLoad()
	print( "--------------------------------------------------" )
	print( "Type achelp in console to get ac help :)" )
	print( "Check for update - https://www.jc-mp.com/forums/index.php/topic,6234.0.html" )
	print( "--------------------------------------------------" )
end

function GodCheck:ExtremeBulletHitLogs( args, sender )
	if ExtremeLogs then
		print( "[BulletHit] " .. sender:GetName() .. " - Health: " .. sender:GetHealth() )
	end
end

function GodCheck:ExtremeExplosionHitLogs( args, sender )
	if ExtremeLogs then
		print( "[ExplosionHit] " .. sender:GetName() .. " - Health: " .. sender:GetHealth() )
	end
end

function GodCheck:SuspicionLevel( args, sender )
	if Logs then
		print( sender:GetName() .. " - " .. "Suspicion of cheating: Level 2/2" )
	end
end

function GodCheck:CheckThisPlayer( args, sender )
    if not sender:GetVehicle() then
    	self.phealth[ sender:GetId() ] = sender:GetHealth()
    	if sender:GetHealth() >= self.phealth[ sender:GetId() ] then
	      if sender:GetHealth() >= 0.001 then
		      	Network:Send( sender, "Checking" )
	    	end
        end
    end
end

function GodCheck:ItsCheater( args, sender )
	if sender:GetHealth() >= self.phealth[ sender:GetId() ] then
		if Logs then
			print( sender:GetName() .. " - " .. "Suspicion of cheating: Level 1/2" )
		end
		if sender:GetHealth() >= 0.001 then
			Chat:Send( sender, ACPrefix .. CHText, Color.Yellow )
			if Logs then
				print( sender:GetName() .. " - " .. CHText )
			end
			Chat:Send( sender, ACPrefix .. FCText, Color.Red )
			if Logs then
				print( sender:GetName() .. " - Health: " .. sender:GetHealth() )
				print( sender:GetName() .. " - " .. FCText )
			end
			if not KickCheaters then
				sender:SetHealth( 0 )
			end
			if Logs then
				print( sender:GetName() .. " - Health: " .. sender:GetHealth() )
			end
			if KickCheaters then
				sender:Kick( ACPrefix .. FCText )
				Chat:Broadcast( sender:GetName() .. KText, Color.Red )
				if Logs then
					print( sender:GetName() .. " - kiked" )
				end
			end
		else
			Chat:Send( sender, ACPrefix .. CHText, Color.Yellow )
			Chat:Send( sender, ACPrefix .. NFCText, Color.Yellow )
			if Logs then
				print( sender:GetName() .. " - " .. "Suspicion of cheating: Level 2/2" )
				print( sender:GetName() .. " - " .. CHText )
				print( sender:GetName() .. " - Health: " .. sender:GetHealth() )
				print( sender:GetName() .. " - " .. NFCText )
			end
		end
	end
end

function GodCheck:GetHelp()
	print( "--------------------------------------------------" )
	print( "Console commands:" )
	print( "aclogs - Enable/disable logs in console" )
	print( "acextremelogs - Enable/disable extreme logs in console" )
	print( "ackickcheaters - Enable/disable cheaters kick" )
	print( "--------------------------------------------------" )
end

function GodCheck:ToggleLogs()
	Logs = not Logs
	print( "Logs: ", Logs )
end

function GodCheck:ToggleExtremeLogs()
	ExtremeLogs = not ExtremeLogs
	print( "Extreme Logs: ", ExtremeLogs )
end

function GodCheck:ToggleKickCheaters()
	KickCheaters = not KickCheaters
	print( "Kick Cheaters: ", KickCheaters )
end

function GodCheck:PlayerQuit( args )
	self.phealth[ args.player:GetId() ] = nil
end

godcheck = GodCheck()
-----------------------------------------------------------------------------------
--Script Version
--v0.2--

--Release Date
--28.10.19--
-----------------------------------------------------------------------------------
