AddCSLuaFile()

//print("Added UP")

local function Dbg(Message)
	//print("[UP] " .. Message)
end

properties.Add( "use", {
	MenuLabel = "Use",
	Order = 1,
	MenuIcon = "icon16/arrow_in.png",
	//MenuIcon = "icon16/control_play_blue.png",
	
	Filter = function( self, ent, ply ) 
		
		if !gamemode.Call( "CanProperty", ply, class, ent) && IsValid(ent:GetOwner()) then return false end
		if ( !IsValid( ent ) ) then return false end
		if ( ent:IsPlayer() ) then return false end

		return true 

	end,
	
	Action = function( self, ent )

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()
		
	end,
	
	Receive = function( self, length, player )
	
		local ent = net.ReadEntity()
		
		if ( !IsValid( ent ) ) then return false end
		if ( !IsValid( player ) ) then return false end
		if ( ent:IsPlayer() ) then return false end
		if ( !self:Filter( ent, player ) ) then return false end
		
		if ent:IsVehicle() then
			Dbg("Entity is vehicle")
			if ent:GetDriver() == NULL then
				Dbg("Driver is NULL")
				if player:InVehicle() then
					Dbg("Kicking player out")
					local PrevChair = player:GetVehicle()
					local EyeAngle = player:EyeAngles()
					player:ExitVehicle()
					timer.Simple( 0.05, function()
						ent:Use( player, player, USE_ON,0) 
						ent:SetThirdPersonMode(PrevChair:GetThirdPersonMode())
						ent:SetCameraDistance(PrevChair:GetCameraDistance())
					end)
				else
					Dbg("Using without kicking")
					ent:Use( player, player, USE_ON,0)
				end
			else
				Dbg("Driver is valid.")
			end
		else
			Dbg("Entity is not vehicle")
			ent:Use( player, player, USE_ON,0)
		end
		
	end	

} )