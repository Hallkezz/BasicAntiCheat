---------------
--By Hallkezz--
---------------

-----------------------------------------------------------------------------------
--Default Settings
local Active = true -- Use Anti-Cheat ( Use: True/false )
local BulletCheck = true -- Bullet hit check.
local ExplosionCheck = false -- ( It is not recommended to enable. Can be a fakes suspicions. )
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
--Script
class 'GodCheck'

function GodCheck:__init()
	Events:Subscribe( "AntiCheat", self, self.AntiCheat )
	Events:Subscribe( "LocalPlayerBulletHit", self, self.LocalPlayerBulletHit )
	Events:Subscribe( "LocalPlayerExplosionHit", self, self.LocalPlayerExplosionHit )

	Network:Subscribe( "Checking", self, self.Checking )
	self.phealth = 1
end

function GodCheck:AntiCheat( args )
	Active = args.acActive
	BulletCheck = args.acBulletCheck
	ExplosionCheck = args.acExplosionCheck
end

function GodCheck:LocalPlayerBulletHit( args )
	if Active then
		if BulletCheck then
			self.phealth = LocalPlayer:GetHealth()
			if LocalPlayer:GetHealth() >= self.phealth then
				if LocalPlayer:GetHealth() >= 0.001 then
					Network:Send( "CheckThisPlayer" )
				end
			end
		end
	end
	Network:Send( "ExtremeBulletHitLogs" )
end

function GodCheck:LocalPlayerExplosionHit( args )
	if Active then
		if ExplosionCheck then
			self.phealth = LocalPlayer:GetHealth()
			if LocalPlayer:GetHealth() >= self.phealth then
				if LocalPlayer:GetHealth() >= 0.001 then
					Network:Send( "CheckThisPlayer" )
				end
			end
		end
	end
	Network:Send( "ExtremeExplosionHitLogs" )
end

function GodCheck:Checking()
	if LocalPlayer:GetHealth() >= self.phealth then
		if LocalPlayer:GetHealth() >= 0.001 then
			Network:Send( "ItsCheater" )
		end
	end
end

godcheck = GodCheck()
-----------------------------------------------------------------------------------
--Script Version
--v0.1--

--Release Date
--10.07.19--
-----------------------------------------------------------------------------------