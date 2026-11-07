# World of Warcraft: Forever compatibility

The oUF TOC already lists interface `16001` and allows both `standard` and `camelot`, so the same addon build remains loadable on Retail and Forever. This follows the same game-type distinction used by the local Genius core addon while retaining oUF's existing Retail support.

## API audit

The API comparison lists the higher-risk APIs used by oUF as available on Forever 1.60.1: `C_Secrets.CanCompareUnitTokens`, `C_PetInfo.GetPetHappiness`, `C_UnitAuras.AddPrivateAuraAnchor`, `C_CVar.SetCVarBitfield`, `C_NamePlate.GetNamePlateForUnit`, `C_NamePlate.SetNamePlateSize`, `C_NamePlateManager.SetNamePlateHitTestInsets`, `C_ClassTalents.GetActiveConfigID`, `C_SpellBook.IsSpellKnownOrInSpellBook`, and `C_DurationUtil.CreateDurationTextBinding`. The legacy global `GetPetHappiness` is not used; the Forever-specific namespaced API is used instead.

## Changes applied

- `C_UnitAuras.AddPrivateAuraAnchor` renamed the `showCountdownFrame` option to `showCooldownFrame` in 12.1.0. The old key is ignored by current clients, so oUF now passes the renamed field.
- `C_CVar.SetCVar` and `C_CVar.SetCVarBitfield` dropped the old `scriptCVar` argument in 10.0.0. oUF already calls them with the current two- and three-argument signatures.
- `GetArenaOpponentSpec` remains available on Forever, but its result became secret in 12.1.5. oUF now filters secret IDs before comparisons or lookups. Arena-preparation callbacks still receive a generic update when an opponent is present, with `specID == nil` if the client hides that ID. The built-in `arenaspec` and `raidcolor` tags return no specialization-derived value in that case.
- The 12.1.5 `UnitFrameUtil` display helpers are available in the Classic/Forever UI, including safe arena-spec and role-icon display APIs. They are for rendering the allowed display information; they do not restore access to the raw specialization ID.

## Native durations and curves

- Rune bars now use `C_DurationUtil.CreateDuration`, `DurationObject:SetTimeFromStart`, and `StatusBar:SetTimerDuration`. The per-rune `OnUpdate` loop no longer increments the bar value or derives elapsed time in Lua.
- The castbar's GCD display now waits for `SPELL_UPDATE_COOLDOWN`, then uses `C_Spell.GetSpellCooldownDuration` and the returned duration object's `IsActive()` method. This avoids reading cooldown data before it has been updated for `UNIT_SPELLCAST_SUCCEEDED`. A hidden native `Cooldown` widget uses `SetCooldownFromDurationObject` and `OnCooldownDone` to reset the fake cast state; oUF no longer subtracts `GetTime()` from the cooldown start time.
- Cast/channel bars and aura/totem displays already use duration objects and Blizzard's duration text/cooldown widgets. Health, power, and alternative-power smooth colors already use `C_CurveUtil` color curves with the corresponding native percent/prediction APIs.
- The stagger bar still uses the legacy `UnitStagger / UnitHealthMax` threshold calculation for green/yellow/red severity only when both inputs are public. If either input is secret, it skips the calculation and uses the base color. The current API reference marks `C_PaperDollInfo.GetStaggerPercentage` as Mainline-only, so Forever 1.60.1 has no native API that returns the current stagger-pool percentage for a secret-safe curve. Forever shares Mainline UI architecture and has secret-value restrictions, so the base-color fallback can apply in restricted situations.

## References

- [World of Warcraft API](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API)
- [World of Warcraft API/Classic comparison](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API/Classic)
- [Patch 1.60.1 API changes](https://warcraft.wiki.gg/wiki/Patch_1.60.1/API_changes)
- [Patch 12.1.0 API changes](https://warcraft.wiki.gg/wiki/Patch_12.1.0/API_changes)
- [Patch 12.1.5 API changes](https://warcraft.wiki.gg/wiki/Patch_12.1.5/API_changes)
- [DurationObject](https://warcraft.wiki.gg/wiki/ScriptObject_DurationObject)
- [C_DurationUtil.CreateDuration](https://warcraft.wiki.gg/wiki/API_C_DurationUtil_CreateDuration)
- [C_Spell.GetSpellCooldownDuration](https://warcraft.wiki.gg/wiki/API_C_Spell_GetSpellCooldownDuration)
- [DurationObject:IsActive](https://warcraft.wiki.gg/wiki/API_DurationObject_IsActive)
- [StatusBar:SetTimerDuration](https://warcraft.wiki.gg/wiki/API_StatusBar_SetTimerDuration)
- [Cooldown:SetCooldownFromDurationObject](https://warcraft.wiki.gg/wiki/API_Cooldown_SetCooldownFromDurationObject)
- [C_CurveUtil.CreateColorCurve](https://warcraft.wiki.gg/wiki/API_C_CurveUtil_CreateColorCurve)
- [UnitPowerPercent](https://warcraft.wiki.gg/wiki/API_UnitPowerPercent)
- [C_PaperDollInfo.GetStaggerPercentage](https://warcraft.wiki.gg/wiki/API_C_PaperDollInfo.GetStaggerPercentage)
- [TOC format and Forever API baseline](https://warcraft.wiki.gg/wiki/.toc)

## Upgrade to 14.2.1

The installed framework uses the downloaded 14.2.1 release. Local native GCD tracking, rune duration timers, private-aura cooldown field naming, and secret-safe stagger coloring are retained. The upstream Retail-only stock stagger-bar guards are included. Arena preparation and arena tags now use the upstream UnitFrameUtil display helpers; the old local safeArenaOpponentSpecID helper has been removed.
