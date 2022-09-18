local _, addon = ...

local L = LibStub("AceLocale-3.0"):GetLocale("RotationMaster")
local color = color

-- From constants
local operators = addon.operators

-- From utils
local compare, compareString, nullable, isin, getCached, round, isSpellOnSpec, getSpecSpellID, isActivePetSpell =
    addon.compare, addon.compareString, addon.nullable, addon.isin, addon.getCached, addon.round, addon.isSpellOnSpec, addon.getSpecSpellID, addon.isActivePetSpell

local helpers = addon.help_funcs
local Gap = helpers.Gap

local GCD_SPELL
if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) or (LE_EXPANSION_LEVEL_CURRENT >= 2) then
    GCD_SPELL = 61304 -- Dedicated spell for GCD
else
    GCD_SPELL = 2580  -- 61304 doesn't exist in classic, use 'Find Materials', which works if you're a miner or not.
end

addon:RegisterCondition("PETSPELL_AVAIL", {
    description = L["Pet Spell Available"],
    icon = "Interface\\Icons\\Ability_druid_bash",
    valid = function(_, value)
        if value.spell ~= nil then
            local name = GetSpellInfo(value.spell)
            return name ~= nil
        else
            return false
        end
    end,
    evaluate = function(value, cache, evalStart)
        local spellid = addon:Widget_GetSpellId(value.spell, false)
        if not spellid or not isActivePetSpell(spellid) then return false end
        local start, duration = getCached(cache, GetSpellCooldown, spellid)
        if start == 0 and duration == 0 then
            return true
        else
            -- A special spell that shows if the GCD is active ...
            local gcd_start, gcd_duration = getCached(cache, GetSpellCooldown, GCD_SPELL)
            if gcd_start ~= 0 and gcd_duration ~= 0 then
                local time = GetTime()
                local gcd_remain = round(gcd_duration - (time - gcd_start), 3)
                local remain = round(duration - (time - start), 3)
                if (remain <= gcd_remain) then
                    return true
                -- We factor in a fuzziness because we don't know exactly when the spell cooldown calls
                -- were made, so we say any value between now and the evaluation start is essentially 0
                elseif (remain - gcd_remain <= time - evalStart) then
                    return true
                else
                    return false
                end
            end
            return false
        end
    end,
    print = function(_, value)
        local link = addon:Widget_GetSpellLink(value.spell, false)
        return string.format(L["%s is available"], nullable(link, L["<spell>"]))
    end,
    widget = function(parent, spec, value)
        local top = parent:GetUserData("top")
        local root = top:GetUserData("root")
        local funcs = top:GetUserData("funcs")

        local spell_group = addon:Widget_SpellWidget(BOOKTYPE_PET, "Spec_EditBox", value,
                                    function(v) return getSpecSpellID(BOOKTYPE_PET, v) end,
                                    function(v) return isSpellOnSpec(BOOKTYPE_PET, v) end,
                                    function() top:SetStatusText(funcs:print(root, spec)) end)
        parent:AddChild(spell_group)
    end,
    help = function(frame)
        addon.layout_condition_spellwidget_help(frame)
    end
})

addon:RegisterCondition("PETSPELL_RANGE", {
    description = L["Pet Spell In Range"],
    icon = "Interface\\Icons\\inv_misc_bandage_03",
    valid = function(_, value)
        if value.spell ~= nil then
            local name = GetSpellInfo(value.spell)
            return name ~= nil
        else
            return false
        end
    end,
    evaluate = function(value, cache)
        if not getCached(cache, UnitExists, "target") then return false end
        local spellid = addon:Widget_GetSpellId(value.spell, false)
        if not spellid or not isActivePetSpell(spellid) then return false end
        if spellid then
            local sbid = getCached(addon.longtermCache, FindSpellBookSlotBySpellID, spellid, true)
            if sbid then
                return (getCached(cache, IsSpellInRange, sbid, BOOKTYPE_PET, "target") == 1)
            end
        end
        return false
    end,
    print = function(_, value)
        local link = addon:Widget_GetSpellLink(value.spell, false)
        return string.format(L["%s is in range"], nullable(link, L["<spell>"]))
    end,
    widget = function(parent, spec, value)
        local top = parent:GetUserData("top")
        local root = top:GetUserData("root")
        local funcs = top:GetUserData("funcs")

        local spell_group = addon:Widget_SpellWidget(BOOKTYPE_PET, "Spec_EditBox", value,
            function(v) return getSpecSpellID(BOOKTYPE_PET, v) end,
            function(v) return isSpellOnSpec(BOOKTYPE_PET, v) end,
            function() top:SetStatusText(funcs:print(root, spec)) end)
        parent:AddChild(spell_group)
    end,
    help = function(frame)
        addon.layout_condition_spellwidget_help(frame)
    end
})

addon:RegisterCondition("PETSPELL_COOLDOWN", {
    description = L["Pet Spell Cooldown"],
    icon = "Interface\\Icons\\Spell_nature_sleep",
    valid = function(_, value)
        if value.spell ~= nil then
            local name = GetSpellInfo(value.spell)
            return (value.operator ~= nil and isin(operators, value.operator) and
                    name ~= nil and value.value ~= nil and value.value >= 0)
        else
            return false
        end
    end,
    evaluate = function(value, cache) -- Cooldown until the spell is available
        local spellid = addon:Widget_GetSpellId(value.spell, false)
        if not spellid or not isActivePetSpell(spellid) then return false end
        local start, duration = getCached(cache, GetSpellCooldown, spellid)
        local remain = 0
        if start ~= 0 and duration ~= 0 then
            remain = round(duration - (GetTime() - start), 3)
            if (remain < 0) then remain = 0 end
        end
        return compare(value.operator, remain, value.value)
    end,
    print = function(_, value)
        local link = addon:Widget_GetSpellLink(value.spell, false)
        return string.format(L["the %s"],
                compareString(value.operator, string.format(L["cooldown on %s"],  nullable(link, L["<spell>"])),
                string.format(L["%s seconds"], nullable(value.value))))
    end,
    widget = function(parent, spec, value)
        local top = parent:GetUserData("top")
        local root = top:GetUserData("root")
        local funcs = top:GetUserData("funcs")

        local spell_group = addon:Widget_SpellWidget(BOOKTYPE_PET, "Spec_EditBox", value,
                                    function(v) return getSpecSpellID(BOOKTYPE_PET, v) end,
                                    function(v) return isSpellOnSpec(BOOKTYPE_PET, v) end,
                                    function() top:SetStatusText(funcs:print(root, spec)) end)
        parent:AddChild(spell_group)

        local operator_group = addon:Widget_OperatorWidget(value, L["Seconds"],
                                    function() top:SetStatusText(funcs:print(root, spec)) end)
        parent:AddChild(operator_group)
    end,
    help = function(frame)
        addon.layout_condition_spellwidget_help(frame)
        frame:AddChild(Gap())
        addon.layout_condition_operatorwidget_help(frame, L["Pet Spell Cooldown"], L["Seconds"],
            "The number of seconds before you can cast " .. color.BLIZ_YELLOW .. L["Pet Spell"] .. color.RESET .. ".")
    end
})

addon:RegisterCondition("PETSPELL_REMAIN", {
    description = L["Pet Spell Time Remaining"],
    icon = "Interface\\Icons\\ability_hunter_pet_raptor",
    valid = function(_, value)
        if value.spell ~= nil then
            local name = GetSpellInfo(value.spell)
            return (value.operator ~= nil and isin(operators, value.operator) and
                    name ~= nil and value.value ~= nil and value.value >= 0)
        else
            return false
        end
    end,
    evaluate = function(value, cache) -- How long the spell remains effective
        local spellid = addon:Widget_GetSpellId(value.spell, false)
        if not spellid or not isActivePetSpell(spellid) then return false end
        local charges, _, start, duration = getCached(cache, GetSpellCharges, spellid)
        local remain = 0
        if (charges and charges >= 0) then
            remain = duration - (GetTime() - start)
        end
        return compare(value.operator, remain, value.value)
    end,
    print = function(_, value)
        local link = addon:Widget_GetSpellLink(value.spell, false)
        return string.format(L["the %s"],
            compareString(value.operator, string.format(L["remaining time on %s"], nullable(link, L["<spell>"])),
                            string.format(L["%s seconds"], nullable(value.value))))
    end,
    widget = function(parent, spec, value)
        local top = parent:GetUserData("top")
        local root = top:GetUserData("root")
        local funcs = top:GetUserData("funcs")

        local spell_group = addon:Widget_SpellWidget(BOOKTYPE_PET, "Spec_EditBox", value,
            function(v) return getSpecSpellID(BOOKTYPE_PET, v) end,
            function(v) return isSpellOnSpec(BOOKTYPE_PET, v) end,
            function() top:SetStatusText(funcs:print(root, spec)) end)
        parent:AddChild(spell_group)

        local operator_group = addon:Widget_OperatorWidget(value, L["Seconds"],
            function() top:SetStatusText(funcs:print(root, spec)) end)
        parent:AddChild(operator_group)
    end,
    help = function(frame)
        addon.layout_condition_spellwidget_help(frame)
        frame:AddChild(Gap())
        addon.layout_condition_operatorwidget_help(frame, L["Pet Spell Time Remaining"], L["Seconds"],
            "The number of seconds the effect of " .. color.BLIZ_YELLOW .. L["Pet Spell"] .. color.RESET ..
            " has left.")
    end
})

addon:RegisterCondition("PETSPELL_CHARGES", {
    description = L["Pet Spell Charges"],
    icon = "Interface\\Icons\\Ability_mount_nightmarehorse",
    valid = function(_, value)
        if value.spell ~= nil then
            local name = GetSpellInfo(value.spell)
            return (value.operator ~= nil and isin(operators, value.operator) and
                    name ~= nil and value.value ~= nil and value.value >= 0)
        else
            return false
        end
    end,
    evaluate = function(value, cache)
        local spellid = addon:Widget_GetSpellId(value.spell, false)
        if not spellid or not isActivePetSpell(spellid) then return false end
        local charges = getCached(cache, GetSpellCharges, spellid)
        return compare(value.operator, charges, value.value)
    end,
    print = function(_, value)
        local link = addon:Widget_GetSpellLink(value.spell, false)
        return string.format(L["the %s"],
            compareString(value.operator, string.format(L["number of charges on %s"], nullable(link, L["<spell>"])), nullable(value.value)))
    end,
    widget = function(parent, spec, value)
        local top = parent:GetUserData("top")
        local root = top:GetUserData("root")
        local funcs = top:GetUserData("funcs")

        local spell_group = addon:Widget_SpellWidget(BOOKTYPE_PET, "Spec_EditBox", value,
            function(v) return getSpecSpellID(BOOKTYPE_PET, v) end,
            function(v) return isSpellOnSpec(BOOKTYPE_PET, v) end,
            function() top:SetStatusText(funcs:print(root, spec)) end)
        parent:AddChild(spell_group)

        local operator_group = addon:Widget_OperatorWidget(value, L["Charges"],
            function() top:SetStatusText(funcs:print(root, spec)) end)
        parent:AddChild(operator_group)
    end,
    help = function(frame)
        addon.layout_condition_spellwidget_help(frame)
        frame:AddChild(Gap())
        addon.layout_condition_operatorwidget_help(frame, L["Pet Spell Charges"], L["Charges"],
            "The number of charges of " .. color.BLIZ_YELLOW .. L["Pet Spell"] .. color.RESET .. " currently active.")
    end
})

addon:RegisterCondition("PETSPELL_HISTORY", {
    description = L["Pet Spell Cast History"],
    icon = "Interface\\Icons\\ability_racial_ultravision",
    valid = function(_, value)
        if value.spell ~= nil then
            local name = GetSpellInfo(value.spell)
            return (value.operator ~= nil and isin(operators, value.operator) and
                    name ~= nil and value.value ~= nil and value.value >= 0)
        else
            return false
        end
    end,
    evaluate = function(value)
        local spellid = addon:Widget_GetSpellId(value.spell, false)
        if not spellid or not isActivePetSpell(spellid) then return false end
        for idx, entry in pairs(addon.spellHistory) do
            return entry.spell == spellid and compare(value.operator, idx, value.value)
        end
        return false
    end,
    print = function(_, value)
        local link = addon:Widget_GetSpellLink(value.spell, false)
        return compareString(value.operator, string.format(L["%s was cast"], nullable(link, L["<spell>"])),
                        string.format(L["%s casts ago"], nullable(value.value)))
    end,
    widget = function(parent, spec, value)
        local top = parent:GetUserData("top")
        local root = top:GetUserData("root")
        local funcs = top:GetUserData("funcs")

        local spell_group = addon:Widget_SpellWidget(BOOKTYPE_PET, "Spec_EditBox", value,
            function(v) return getSpecSpellID(BOOKTYPE_PET, v) end,
            function(v) return isSpellOnSpec(BOOKTYPE_PET, v) end,
            function() top:SetStatusText(funcs:print(root, spec)) end)
        parent:AddChild(spell_group)

        local operator_group = addon:Widget_OperatorWidget(value, L["Count"],
            function() top:SetStatusText(funcs:print(root, spec)) end)
        parent:AddChild(operator_group)
    end,
    help = function(frame)
        addon.layout_condition_spellwidget_help(frame)
        frame:AddChild(Gap())
        addon.layout_condition_operatorwidget_help(frame, L["Pet Spell Cast History"], L["Count"],
            "How far back in your spell history to look for a casting of " .. color.BLIZ_YELLOW .. L["Pet Spell"] ..
            color.RESET .. " (by count).  A value of 1 means your last spell cast, 2 means two spells ago, etc.  " ..
            "Each instance of a the same spell cast is treated separately.  Any spell cast more than the setting " ..
            "of " .. color.BLUE .. L["Pet Spell History Memory (seconds)"] .. color.RESET .. " in the primary Rotation " ..
            "Master configuration screen ago will not be available.")
    end
})

addon:RegisterCondition("PETSPELL_HISTORY_TIME", {
    description = L["Pet Spell Cast History Time"],
    icon = "Interface\\Icons\\ability_druid_mangle",
    valid = function(_, value)
        if value.spell ~= nil then
            local name = GetSpellInfo(value.spell)
            return (value.operator ~= nil and isin(operators, value.operator) and
                    name ~= nil and value.value ~= nil and value.value >= 0)
        else
            return false
        end
    end,
    evaluate = function(value, _, evalStart) -- Cooldown until the spell is available
        local spellid = addon:Widget_GetSpellId(value.spell, false)
        if not spellid or not isActivePetSpell(spellid) then return false end
        for _, entry in pairs(addon.spellHistory) do
            return entry.spell == spellid and compare(value.operator, (evalStart - entry.time), value.value)
        end
        return false
    end,
    print = function(_, value)
        local link = addon:Widget_GetSpellLink(value.spell, false)
        return compareString(value.operator, string.format(L["%s was cast"], nullable(link, L["<spell>"])),
                string.format(L["%s seconds ago"], nullable(value.value)))
    end,
    widget = function(parent, spec, value)
        local top = parent:GetUserData("top")
        local root = top:GetUserData("root")
        local funcs = top:GetUserData("funcs")

        local spell_group = addon:Widget_SpellWidget(BOOKTYPE_PET, "Spec_EditBox", value,
            function(v) return getSpecSpellID(BOOKTYPE_PET, v) end,
            function(v) return isSpellOnSpec(BOOKTYPE_PET, v) end,
            function() top:SetStatusText(funcs:print(root, spec)) end)
        parent:AddChild(spell_group)

        local operator_group = addon:Widget_OperatorWidget(value, L["Seconds"],
            function() top:SetStatusText(funcs:print(root, spec)) end)
        parent:AddChild(operator_group)
    end,
    help = function(frame)
        addon.layout_condition_spellwidget_help(frame)
        frame:AddChild(Gap())
        addon.layout_condition_operatorwidget_help(frame, L["Pet Spell Cast History Time"], L["Seconds"],
            "How far back in your spell history to look for a casting of " .. color.BLIZ_YELLOW .. L["Pet Spell"] ..
            color.RESET .. " (by time).  Any spell cast more than the setting of " .. color.BLUE ..
            L["Pet Spell History Memory (seconds)"] .. color.RESET .. " in the primary Rotation Master configuration " ..
            "screen ago will not be available.")
    end
})

addon:RegisterCondition("PETSPELL_ACTIVE", {
    description = L["Pet Spell Active or Pending"],
    icon = "Interface\\Icons\\ability_druid_supriseattack",
    valid = function(_, value)
        if value.spell ~= nil then
            local name = GetSpellInfo(value.spell)
            return name ~= nil
        else
            return false
        end
    end,
    evaluate = function(value)
        local spellid = addon:Widget_GetSpellId(value.spell, false)
        if not spellid or not isActivePetSpell(spellid) then return false end
        return IsCurrentSpell(spellid)
    end,
    print = function(_, value)
        local link = addon:Widget_GetSpellLink(value.spell, false)
        return string.format(L["%s is active or pending"], nullable(link, L["<spell>"]))
    end,
    widget = function(parent, spec, value)
        local top = parent:GetUserData("top")
        local root = top:GetUserData("root")
        local funcs = top:GetUserData("funcs")

        local spell_group = addon:Widget_SpellWidget(BOOKTYPE_PET, "Spec_EditBox", value,
            function(v) return getSpecSpellID(BOOKTYPE_PET, v) end,
            function(v) return isSpellOnSpec(BOOKTYPE_PET, v) end,
            function() top:SetStatusText(funcs:print(root, spec)) end)
        parent:AddChild(spell_group)
    end,
    help = function(frame)
        addon.layout_condition_spellwidget_help(frame)
    end
})