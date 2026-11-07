oUF_KinmeicDB = oUF_KinmeicDB or {}
if oUF_KinmeicDB.hidePlayerName == nil then
	oUF_KinmeicDB.hidePlayerName = false
end

local function UpdatePlayerTags()
	for _, object in next, oUF.objects do
		if object.__unit == 'player' then
			object:UpdateTags()
		end
	end
end

local locale = GetLocale()
local settingName = locale == 'zhCN' and '隐藏玩家名称'
	or locale == 'zhTW' and '隱藏玩家名稱'
	or 'Hide Player Name'

if(Settings and Settings.RegisterVerticalLayoutCategory) then
	local category = Settings.RegisterVerticalLayoutCategory('oUF_Kinmeic')
	local setting = Settings.RegisterProxySetting(
		category,
		'oUF_Kinmeic_HidePlayerName',
		type(false),
		settingName,
		oUF_KinmeicDB.hidePlayerName,
		function()
			return oUF_KinmeicDB.hidePlayerName
		end,
		function(value)
			oUF_KinmeicDB.hidePlayerName = value == true
			UpdatePlayerTags()
		end
	)

	Settings.CreateCheckbox(category, setting)
	Settings.RegisterAddOnCategory(category)
end
