local GM = GM or GAMEMODE

local color_bg = Color(52, 73, 94, 80)

local PANEL = {}

function PANEL:Init()
	self.Navigation = vgui.Create( "DScrollPanel", self )
	self.Navigation:Dock( LEFT )
	self.Navigation:SetWidth( 100 )
	self.Navigation:DockMargin( 10, 10, 10, 0 )

	self.Content = vgui.Create( "Panel", self )
	self.Content:Dock( FILL )

	self.Items = {}
end

function PANEL:AddSheet( label, panel, material )

	if ( !IsValid( panel ) ) then return end

	local Sheet = {}

	if ( self.ButtonOnly ) then
		Sheet.Button = vgui.Create( "DImageButton", self.Navigation )
	else
		Sheet.Button = vgui.Create( "DButton", self.Navigation )
	end

	--Sheet.Button:SetImage( material )
	Sheet.Button.Target = panel
	Sheet.Button:Dock( TOP )
	Sheet.Button:SetText( label )
	Sheet.Button:DockMargin(0, 1, 0, 0)

	Sheet.Button.DoClick = function()
		self:SetActiveButton( Sheet.Button )
	end

	Sheet.Panel = panel
	Sheet.Panel:SetParent( self.Content )
	Sheet.Panel:SetVisible( false )

	if ( self.ButtonOnly ) then
		Sheet.Button:SizeToContents()
		--Sheet.Button:SetColor( Color( 150, 150, 150, 100 ) )
	end

	table.insert( self.Items, Sheet )

	if ( !IsValid( self.ActiveButton ) ) then
		self:SetActiveButton( Sheet.Button )
	end

	return Sheet
end

function PANEL:Paint(w, h)
	local height = 50

	for _, v in ipairs(self.Items) do
		height = height + v.Button:GetTall()
	end

	draw.RoundedBox( 16, 0, 0, w * 0.084, height, color_bg )
end

--[[function PANEL:PaintOver(w, h)
	surface.SetDrawColor(color_fg)
	surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
end]]

function PANEL:OnRemove()
	--timer.Simple(0.1, function()
		--PLUGIN.healthPanel = nil
	--end)
end

function PANEL:SetActiveButton( active )

	if ( self.ActiveButton == active ) then return end

	if ( self.ActiveButton and self.ActiveButton.Target ) then
		self.ActiveButton.Target:SetVisible( false )
		self.ActiveButton:SetSelected( false )
		self.ActiveButton:SetToggle( false )
		--self.ActiveButton:SetColor( Color( 150, 150, 150, 100 ) )
	end

	self.ActiveButton = active
	active.Target:SetVisible( true )
	active:SetSelected( true )
	active:SetToggle( true )
	--active:SetColor( color_white )

	self.Content:InvalidateLayout()

end

vgui.Register("slsColumnSheet", PANEL, "EditablePanel")