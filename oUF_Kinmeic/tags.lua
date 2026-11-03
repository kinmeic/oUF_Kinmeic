-- Tags
oUF.Tags.Methods['k:curhp'] = function(unit)
	return string.format('|cffffffff%s|r - |cffAF5050%d%%|r',
		AbbreviateNumbers(UnitHealth(unit)),
		UnitHealthPercent(unit, true, CurveConstants.ScaleTo100))
end

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
