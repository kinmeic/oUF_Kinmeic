-- Tags
local healthPercentTextCurve = C_CurveUtil.CreateCurve()
healthPercentTextCurve:SetType(Enum.LuaCurveType.Step)
healthPercentTextCurve:AddPoint(0, 0)
healthPercentTextCurve:AddPoint(0.000001, 1)
for percent = 1, 99 do
	healthPercentTextCurve:AddPoint(percent / 100, percent)
end
healthPercentTextCurve:AddPoint(0.995, 0)
healthPercentTextCurve:AddPoint(1, 0)

local function formattedHealth(unit)
	local current = AbbreviateNumbers(UnitHealth(unit))
	local percent = UnitHealthPercent(unit, true, healthPercentTextCurve)
	local percentText = C_StringUtil.TruncateWhenZero(percent)
	local suffix = C_StringUtil.WrapString(percentText, ' - ', '%')
	return string.format('|cffffffff%s|r%s', current, suffix)
end

oUF.Tags.Methods['k:curhp'] = formattedHealth

oUF.Tags.Methods['k:curpp'] = function(unit)
	return string.format('|cffffffff%s|r - |cffAF5050%d%%|r',
		AbbreviateNumbers(UnitPower(unit)),
		UnitPowerPercent(unit, nil, true, CurveConstants.ScaleTo100))
end

oUF.Tags.Methods['k:perhp'] = function(unit)
	return string.format('|cffAF5050%d%%|r',
		UnitHealthPercent(unit, true, CurveConstants.ScaleTo100))
end

oUF.Tags.Events['k:curhp']   = 'UNIT_MAXHEALTH UNIT_HEALTH'
oUF.Tags.Events['k:perhp']   = 'UNIT_MAXHEALTH UNIT_HEALTH'
oUF.Tags.Events['k:curpp']   = 'UNIT_MAXPOWER UNIT_POWER_UPDATE'

oUF.Tags.Methods['k:playername'] = function(unit, realUnit)
	if unit == 'player' and oUF_KinmeicDB and oUF_KinmeicDB.hidePlayerName then
		return ''
	end

	return _TAGS['name'](unit, realUnit)
end

oUF.Tags.Events['k:playername'] = 'UNIT_NAME_UPDATE'
