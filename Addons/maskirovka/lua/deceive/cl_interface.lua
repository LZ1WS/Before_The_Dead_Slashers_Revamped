--[[
addons/weapon_maskirovka/lua/deceive/cl_interface.lua
--]]


if IsValid(deceive.GUI) then
	deceive.GUI:Remove()
end

local cmd = deceive.Config and deceive.Config.UndisguiseCommand or "undisguise"

surface.CreateFont("deceive.title", {
	font = "Roboto Cn",
	size = 21,
	weight = 0
})

surface.CreateFont("deceive.line", {
	font = "Roboto Cn",
	size = 16,
	weight = 0
})

surface.CreateFont("deceive.line2", {
	font = "Roboto",
	size = 12,
	weight = 800
})

surface.CreateFont("deceive.close", {
	font = "Trebuchet",
	size = 14,
	weight = 800
})

surface.CreateFont("deceive.close2", {
	font = "Trebuchet",
	size = 10,
	weight = 800
})

local L = deceive.Translate

local PANEL = {}

function PANEL:Init()
	self:SetSize(400, 368)
	self:Center()

	self.PlayerList = vgui.Create("DListView", self)
	self.PlayerList:Dock(LEFT)
	self.PlayerList:DockMargin(8, 28 + 8, 8, 8)
	self.PlayerList:SetWide(math.ceil(self:GetWide() * 0.58 - 12))

	self.PlayerList:SetMultiSelect(false)
	self.PlayerList:AddColumn(L"disguise_ui_row_name")
	self.PlayerList:AddColumn(L"disguise_ui_row_job")

	self:RefreshList()
	function self.PlayerList.OnRowSelected(_, _, line)
		local ply = line.Player
		if not IsValid(ply) then
			self:RefreshList()
			return
		end

		self.Player = ply

		if not self.PlayerModel:IsVisible() then
			self.PlayerModel:SetVisible(true)
			self.Info:SetVisible(true)
		end
		self.PlayerModel:SetModel(ply:GetModel())
		self.PlayerModel:LayoutEntity()
		self.PlayerModel.Entity.GetPlayerColor = function()
			return ply:GetPlayerColor()
		end

		local yes, no = L"disguise_ui_yes", L"disguise_ui_no"
		local txt =  L"disguise_ui_info_player" .. " " .. ply:Nick(true) .. "\n"
		txt = txt .. L"disguise_ui_info_job" .. " " .. GetLangRole(ply:GetNClass()) .. "\n"
		self.Info:SetText(txt)
		self.Info:SizeToContents()

		self.Disguise:SetVisible(true)
	end

	self.RightSide = vgui.Create("EditablePanel", self)
	self.RightSide:Dock(RIGHT)
	self.RightSide:DockMargin(8, 28 + 8, 8, 8)
	self.RightSide:SetWide(math.ceil(self:GetWide() * 0.42 - 12))

	self.PlayerModel = vgui.Create("DModelPanel", self.RightSide)
	self.PlayerModel:Dock(TOP)
	self.PlayerModel:SetTall(150)
	self.PlayerModel:SetVisible(false)
	self.PlayerModel:SetFOV(12.5)
	function self.PlayerModel:LayoutEntity()
		local head = self.Entity:LookupBone("ValveBiped.Bip01_Head1")

		local headPos
		if head then
			headPos = self.Entity:GetBonePosition(head)
			self.Entity:ManipulateBoneAngles(head, Angle(-10, -5, -20))
		else
			local mins, maxs = self.Entity:GetModelBounds()
			headPos = maxs * 0.85 + Vector(-2.5, 0, 0)
		end
		self:SetLookAt(headPos + Vector(0, 0, 1.5))

		local vec = self.Entity:GetAngles():Forward() * 20 + self.Entity:GetAngles():Up() * 62.5 + self.Entity:GetAngles():Right() * 12
		self.Entity:SetEyeTarget(vec)
		self.Entity:SetPos(Vector(0, -2, 0))
		self.Entity:SetAngles(Angle(5, 70, 0))
	end

	self.Info = vgui.Create("DLabel", self.RightSide)
	self.Info:Dock(TOP)
	self.Info:DockMargin(0, 2, 0, 0)
	self.Info:SetVisible(false)
	self.Info:SetFont("deceive.line")
	self.Info:SetTextColor(Color(230, 230, 255, 192))

	self.Disguise = vgui.Create("DButton", self.RightSide)
	self.Disguise:Dock(BOTTOM)
	self.Disguise:SetVisible(false)
	self.Disguise:SetText(L"disguise_ui_action")
	self.Disguise:SetImage("icon16/briefcase.png")
	function self.Disguise.DoClick()
		if not IsValid(self.Player) then
			notification.AddLegacy(L"disguise_ui_invalid_target", NOTIFY_ERROR, 5)
			-- notification.AddLegacy("Your target isn't valid anymore!", NOTIFY_ERROR, 5)
			self:RefreshList()
			return
		end

		net.Start("deceive.interface")
			net.WriteUInt(self.Player:UserID(), 32)
		net.SendToServer()
		self:Remove()
	end

	self.Info2 = vgui.Create("DLabel", self.RightSide)
	self.Info2:Dock(BOTTOM)
	self.Info2:DockMargin(0, 0, 0, 2)
	-- self.Info2:SetVisible(false)
	self.Info2:SetFont("deceive.line2")
	self.Info2:SetTextColor(Color(230, 230, 255, 64))
	self.Info2:SetWrap(true)
	self.Info2:SetAutoStretchVertical(true)
	self.Info2:SetText(
		string.format(L"disguise_ui_undisguise1", cmd) .. "\n" ..
		string.format(L"disguise_ui_undisguise2", cmd)
	)
	-- self.Info2:SetText("/" .. cmd .. " in chat to remove\nbind '" .. cmd .. "' to a key (through console) to quickly remove")
	self.Info2:SizeToContents()

	self.Close = vgui.Create("DButton", self)
	self.Close:SetSize(40, 20)
	function self.Close.DoClick()
		self:Remove()
	end

	self:Theme()

	self:MakePopup()
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(true)

	self:SetVisible(false)
end

function PANEL:PerformLayout()
	self.Close:SetPos(self:GetWide() - self.Close:GetWide() - 16, 1)
end

function PANEL:RefreshList()
	self.PlayerList:Clear()
	for _, ply in next, player.GetAll() do
		if ply:UserID() ~= LocalPlayer():UserID() and not table.HasValue(deceive.Config.NoDisguiseIntoJobs, GetLangRole(ply:GetNClass())) then
			local line = self.PlayerList:AddLine(ply:Nick(true), team.GetName(ply:Team(true)))
			line.Player = ply
		end
	end
	self.Players = player.GetCount()
end

local gradient_u = Material("vgui/gradient-u.png")
function PANEL:Theme()
	function self.Close:Paint(w, h)
		surface.SetDrawColor(255, 64, 64, 64)
		surface.DrawRect(0, 0, w, h - 1)
		surface.DrawRect(1, h - 1, w - 2, 1)

		local col = Color(0, 0, 0, 0)
		if self:IsHovered() and self.Depressed then
			col = Color(0, 0, 0, 64)
		elseif self:IsHovered() then
			col = Color(255, 255, 255, 3)
		end
		surface.SetDrawColor(col)
		surface.DrawRect(0, 0, w, h)

		surface.SetFont("deceive.close")
		local txt = "✕" -- x, ×, X, ✕, ☓, ✖, ✗, ✘, etc.
		local txtW, txtH = surface.GetTextSize(txt)
		draw.SimpleTextOutlined(txt, "deceive.close", -2 + w * 0.5 - txtW * 0.5, h * 0.5 - txtH * 0.5, Color(230, 230, 255, 192), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(0, 0, 0, 127))

		return true
	end

	self.PlayerList:SetHeaderHeight(24)
	function self.PlayerList:Paint(w, h)
		surface.SetDrawColor(47, 47, 65, 127)
		surface.DrawRect(1, 1, w - 2, h - 2)

		surface.SetDrawColor(17, 17, 25, 192)
		surface.DrawRect(0, 1, 1, h - 2) -- left
		surface.DrawRect(w - 1, 1, 1, h - 2) -- right
		surface.DrawRect(1, 0, w - 2, 1) -- top
		surface.DrawRect(1, h - 1, w - 2, 1) -- bottom
	end
	function self.PlayerList.VBar:Paint(w, h)
		surface.SetDrawColor(27, 27, 35, 127)
		surface.DrawRect(0, 0, w, h)
	end
	function self.PlayerList.VBar.btnGrip:Paint(w, h)
		surface.SetDrawColor(45, 45, 64, 192)
		surface.DrawRect(1, 1, w - 2, h - 2)

		if self.Depressed then
			surface.SetDrawColor(0, 0, 0, 64)
			surface.DrawRect(1, 1, w - 2, h - 2)
		elseif self:IsHovered() then
			surface.SetDrawColor(255, 255, 255, 2)
			surface.DrawRect(1, 1, w - 2, h - 2)
		end

		surface.SetDrawColor(17, 17, 25, 225)
		surface.DrawRect(0, 1, 1, h - 2) -- left
		surface.DrawRect(w - 1, 1, 1, h - 2) -- right
		surface.DrawRect(1, 0, w - 2, 1) -- top
		surface.DrawRect(1, h - 1, w - 2, 1) -- bottom
	end
	for k, v in next, {"Up", "Down"} do
		self.PlayerList.VBar["btn" .. v].Paint = function(self, w, h)
			surface.SetDrawColor(45, 45, 64, 192)
			surface.DrawRect(1, 1, w - 2, h - 2)

			if self.Depressed then
				surface.SetDrawColor(0, 0, 0, 64)
				surface.DrawRect(1, 1, w - 2, h - 2)
			elseif self:IsHovered() then
				surface.SetDrawColor(255, 255, 255, 2)
				surface.DrawRect(1, 1, w - 2, h - 2)
			end

			surface.SetFont("deceive.close2")
			local txt = k == 1 and "▲" or "▼" -- x, ×, X, ✕, ☓, ✖, ✗, ✘, etc.
			local txtW, txtH = surface.GetTextSize(txt)
			draw.SimpleTextOutlined(txt, "deceive.close2", -1 + w * 0.5 - txtW * 0.5, h * 0.5 - txtH * 0.5, Color(230, 230, 255, 192), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(0, 0, 0, 127))

			surface.SetDrawColor(17, 17, 25, 225)
			surface.DrawRect(0, 1, 1, h - 2) -- left
			surface.DrawRect(w - 1, 1, 1, h - 2) -- right
			surface.DrawRect(1, 0, w - 2, 1) -- top
			surface.DrawRect(1, h - 1, w - 2, 1) -- bottom
		end
	end

	for k, column in next, self.PlayerList.Columns do
		function column.Header:Paint(w, h)
			surface.SetDrawColor(27, 27, 47, 192)
			surface.DrawRect(0, 0, w, h)

			surface.SetMaterial(gradient_u)
			surface.SetDrawColor(47, 47, 65, 64)
			surface.DrawTexturedRect(1, 1, w - 2, h - 2)

			if self.Depressed then
				surface.SetDrawColor(0, 0, 0, 64)
				surface.DrawRect(1, 1, w - 2, h - 2)
			elseif self:IsHovered() then
				surface.SetDrawColor(255, 255, 255, 2)
				surface.DrawRect(1, 1, w - 2, h - 2)
			end

			surface.SetDrawColor(17, 17, 25, 92)
			surface.DrawOutlinedRect(0, 0, w, h)

			surface.SetFont("deceive.line")
			local txt = self:GetText()
			local txtW, txtH = surface.GetTextSize(txt)
			surface.SetTextPos(w * 0.5 - txtW * 0.5, h * 0.5 - txtH * 0.5)
			surface.SetTextColor(240, 240, 255, 192)
			surface.DrawText(txt)

			return true
		end
	end

	for k, line in next, self.PlayerList.Lines do
		function line:Paint(w, h)
			local ply = line.Player
			if not IsValid(ply) then self:Remove() end

			-- local col = Color(120, 120, 180, 0)
			local col = table.Copy(ply.getJobTable and ply:getJobTable(true).color or team.GetColor(ply:Team(true)))
			col.a = 10
			if self:IsHovered() and self:IsSelected() or self:IsSelected() then
				col.a = 50
			elseif self:IsHovered() or self:IsSelected() then
				col.a = 25
			end
			surface.SetDrawColor(col)
			surface.DrawRect(0, 0, w - 1, h)
		end

		for _, column in next, line.Columns do
			column:SetFont("deceive.line")
			function column:UpdateColours()
				if self:GetParent():IsLineSelected() then
					return self:SetTextStyleColor(Color(230, 230, 255, 255))
				end

				return self:SetTextStyleColor(Color(192, 192, 225, 127))
			end
		end
	end

	function self.PlayerModel:Paint(w, h)
		surface.SetDrawColor(27, 27, 35, 127)
		surface.DrawRect(0, 0, w, h)

		DModelPanel.Paint(self, w, h)

		DisableClipping(true)

		surface.SetDrawColor(17, 17, 25, 192)
		surface.DrawRect(-1, 0, 1, h) -- left
		surface.DrawRect(w, 0, 1, h) -- right
		surface.DrawRect(0, -1, w, 1) -- top
		surface.DrawRect(0, h, w, 1) -- bottom

		DisableClipping(false)
	end

	function self.Disguise:Paint(w, h)
		surface.SetDrawColor(27, 27, 47, 192)
		surface.DrawRect(0, 0, w, h)

		surface.SetMaterial(gradient_u)
		surface.SetDrawColor(47, 47, 65, 64)
		surface.DrawTexturedRect(1, 1, w - 2, h - 2)

		if self.Depressed then
			surface.SetDrawColor(0, 0, 0, 64)
			surface.DrawRect(1, 1, w - 2, h - 2)
		elseif self:IsHovered() then
			surface.SetDrawColor(255, 255, 255, 2)
			surface.DrawRect(1, 1, w - 2, h - 2)
		end

		surface.SetDrawColor(17, 17, 25, 92)
		surface.DrawOutlinedRect(0, 0, w, h)

		surface.SetFont("deceive.line")
		local txt = self:GetText()
		local txtW, txtH = surface.GetTextSize(txt)
		surface.SetTextPos(w * 0.5 - txtW * 0.5, h * 0.5 - txtH * 0.5)
		surface.SetTextColor(240, 240, 255, 192)
		surface.DrawText(txt)

		return true
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(37, 37, 45, 235)
	surface.DrawRect(1, 1, w - 2, h - 2)

	surface.SetDrawColor(17, 17, 25, 92)
	surface.DrawRect(1, 1, w - 2, 28)

	surface.SetDrawColor(17, 17, 25, 225)
	surface.DrawRect(0, 1, 1, h - 2) -- left
	surface.DrawRect(w - 1, 1, 1, h - 2) -- right
	surface.DrawRect(1, 0, w - 2, 1) -- top
	surface.DrawRect(1, h - 1, w - 2, 1) -- bottom

	surface.SetFont("deceive.title")
	local txt = L"disguise_ui_title"
	local txtW, txtH = surface.GetTextSize(txt)
	surface.SetTextPos(w * 0.5 - txtW * 0.5, 1 + 28 * 0.5 - txtH * 0.5)
	surface.SetTextColor(240, 240, 255, 192)
	surface.DrawText(txt)
end

function PANEL:Show()
	self:SetVisible(true)
end

function PANEL:Hide()
	self:SetVisible(false)
end

function PANEL:Think()
	if not IsValid(self.Entity) then self:Remove() return end

	--if LocalPlayer():GetPos():Distance(self.Entity:GetPos()) > 95 then
		--self:Remove()
		--return
	--end

	if self.Players ~= player.GetCount() then
		self:RefreshList()
		self:Theme()
	end
end

vgui.Register("deceive.interface", PANEL, "EditablePanel")

net.Receive("deceive.interface", function()
	if not IsValid(deceive.GUI) then
		deceive.GUI = vgui.Create("deceive.interface")
	end

	local entIndex = net.ReadUInt(32)
	local ent = Entity(entIndex)
	if not IsValid(ent) then return end

	deceive.GUI.Entity = ent
	deceive.GUI:Show()
end)

net.Receive("deceive.notify", function()
	local str = net.ReadString()
	local typ = net.ReadUInt(8)
	local time = net.ReadUInt(8)
	local extra = net.ReadTable()
	local _str = string.format(L(str), unpack(extra))
	notification.AddLegacy(_str, typ, time)
	print(_str)
end)

concommand.Add(cmd, function()
	-- lazy but should do the trick nicely
	RunConsoleCommand("say", "/" .. cmd)
end)


