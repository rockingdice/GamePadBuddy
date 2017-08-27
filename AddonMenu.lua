local _
local LAM = LibStub:GetLibrary("LibAddonMenu-2.0")

GamePadBuddy.AddonMenu = {}
local changed = false
function GamePadBuddy.AddonMenu.Init()
	GamePadBuddy.UpdateCurrentSavedVars()
	local panelData =  {
		type = "panel",
		name = "GamePadBuddy",
		displayName = "RockingDice's GamePadBuddy",
		author = "RockingDice",
		version = "1.00",
		slashCommand = "/gb",
		registerForRefresh = true,
		registerForDefaults = false
	}
	
	local optionsTable = {
		{
			type = "header",
			name = "|c0066FFAccount Settings|r",
			width = "full"
		},
		{
			type = "checkbox",
			name = "Account Wide Setting",
			tooltip = "Use account-wide settings instead of this character.",
			getFunc = function() return GamePadBuddy.acctSavedVariables.accountWideSetting end,
			setFunc = function(value) GamePadBuddy.acctSavedVariables.accountWideSetting = value
				GamePadBuddy.UpdateCurrentSavedVars()
				if value then
				else
				end
			end,
		},
		{
			type = "header",
			name = "|c0066FF[General Enhancement]|r",
			width = "full",
		},
		{
			type = "checkbox",
			name = "Show Wearing Gears In Inventory Menu",
			tooltip = "Add a tooltip for showing current wearing gears, in orginal gamepad ui.",
			getFunc = function() return GamePadBuddy.curSavedVars.invtooltip end,
			setFunc = function(value) GamePadBuddy.curSavedVars.invtooltip = value
			end,
		},
		{
			type = "checkbox",
			name = "Trait Markers",
			tooltip = "Add an icon to show researching/known/duplicated/researchable status.",
			getFunc = function() return GamePadBuddy.curSavedVars.traitmarkers end,
			setFunc = function(value) GamePadBuddy.curSavedVars.traitmarkers = value
			end,
		},
		{
			type = "checkbox",
			name = "Ornate/Intricate Markers",
			tooltip = "Add an icon to show ornate/intricate status. Stolen items with green quality or better will be marked as ornate for selling.",
			getFunc = function() return GamePadBuddy.curSavedVars.ornateintricate end,
			setFunc = function(value) GamePadBuddy.curSavedVars.ornateintricate = value
			end,
		},
		{
			type = "checkbox",
			name = "Quest Markers: The Covetous Countess",
			tooltip = "Show icons to indicate stolen items with white quality for completing this quest. Only active when you have this quest.",
			getFunc = function() return GamePadBuddy.curSavedVars.qhtcc end,
			setFunc = function(value) GamePadBuddy.curSavedVars.qhtcc = value
			end,
		},
		{
			type = "checkbox",
			name = "Hide Researchable Items",
			tooltip = "If checked, preserved items for researching will be hidden in deconstruct/improvement menu.",
			getFunc = function() return GamePadBuddy.curSavedVars.hideresearchables end,
			setFunc = function(value) GamePadBuddy.curSavedVars.hideresearchables = value
			end,
		},
		{
			type = "checkbox",
			name = "Fast Teleport",
			tooltip = "You can fast teleport to any locations if you have online guild members in the map.",
			getFunc = function() return GamePadBuddy.curSavedVars.fastteleport end,
			setFunc = function(value) GamePadBuddy.curSavedVars.fastteleport = value
				changed = true
			end,
			warning = "Needs to reload UI."
		},
		{             
			type = "button",             
			name = "Apply Changes",             
			func = function() ReloadUI() end, 			
			disabled = function() return not changed end,         
		},		
		{
			type = "header",
			name = "|c0066FF[Tooltips Enhancement]|r",
			width = "full",
		},
		{
			type = "checkbox",
			name = "Master Merchant",
			tooltip = "Add a tooltip for showing item info from add-on 'Master Merchant'.",
			getFunc = function() return GamePadBuddy.curSavedVars.mm end,
			setFunc = function(value) GamePadBuddy.curSavedVars.mm = value
			end,
		},
		{
			type = "checkbox",
			name = "Tamriel Trade Centre",
			tooltip = "Add a tooltip for showing item info from add-on 'Tamriel Trade Centre'.",
			getFunc = function() return GamePadBuddy.curSavedVars.ttc end,
			setFunc = function(value) GamePadBuddy.curSavedVars.ttc = value
			end,
		},
		{
			type = "checkbox",
			name = "Arkadius Trade Tools",
			tooltip = "Add a tooltip for showing item info from add-on 'Arkadius Trade Tools'.",
			getFunc = function() return GamePadBuddy.curSavedVars.att end,
			setFunc = function(value) GamePadBuddy.curSavedVars.att = value
			end,
		},
		{
			type = "checkbox",
			name = "Recipes Info",
			tooltip = "Add a tooltip for showing recipes status and related prices(need ttc or mm).",
			getFunc = function() return GamePadBuddy.curSavedVars.recipes end,
			setFunc = function(value) GamePadBuddy.curSavedVars.recipes = value
			end,
		}, 
		{
			type = "checkbox",
			name = "Set Info",
			tooltip = "Add a tooltip for showing full-set reward.",
			getFunc = function() return GamePadBuddy.curSavedVars.setinfo end,
			setFunc = function(value) GamePadBuddy.curSavedVars.setinfo = value
			end,
		},        
	}
	LAM:RegisterAddonPanel("GAMEPADBUDDY_SETTINGS", panelData)
	LAM:RegisterOptionControls("GAMEPADBUDDY_SETTINGS", optionsTable)
end