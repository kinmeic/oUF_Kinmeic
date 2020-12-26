-- Tags
local formatValue = function(value)
	if value < 9999 then
		return value
	elseif value < 999999 then
		return string.format("%.1fk", value / 1000)
	else
		return string.format("%.2fm", value / 1000000)
	end
end

oUF.Tags.Methods['k:curhp']  = function(unit)
	local min = UnitHealth(unit)
	local max = UnitHealthMax(unit)

	if min == max then
--		return "|cff559655"..formatValue(max).."|r"
		return "|cffffffff"..formatValue(max).."|r"
	else
--		return string.format("|cffAF5050%s|r - |cff559655%d%%|r", formatValue(min), floor(min / max * 100))
		return string.format("|cffffffff%s|r - |cffAF5050%d%%|r", formatValue(min), floor(min / max * 100))
	end
	
end

oUF.Tags.Methods['k:curpp']  = function(unit)
	local min = UnitPower(unit)
	local max = UnitPowerMax(unit)

	if min == max then
		return "|cffffffff"..formatValue(max).."|r"
	else
		return string.format("|cffffffff%s|r - |cffAF5050%d%%|r", formatValue(min), floor(min / max * 100))
	end
	
end

oUF.Tags.Methods['k:perhp'] = function(unit)
	local perc = UnitHealth(unit) / UnitHealthMax(unit) * 100
	perc = ceil(perc)
	
	if(unit:find('raid%d') and perc == 100) then
--		return string.format("|cff559655%s|r", formatValue(UnitHealthMax(unit)))
		return formatValue(UnitHealthMax(unit))
	else
		return string.format("|cffAF5050%s%%|r", perc)
	end
end

oUF.Tags.Events['k:curhp']   = 'UNIT_MAXHEALTH UNIT_HEALTH'
oUF.Tags.Events['k:perhp']   = 'UNIT_MAXHEALTH UNIT_HEALTH'
oUF.Tags.Events['k:curpp']   = 'UNIT_MAXPOWER UNIT_POWER'