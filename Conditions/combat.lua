local addon_name, addon = ...

local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("RotationMaster")
local tostring, tonumber, pairs = tostring, tonumber, pairs

if (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE) then
    local ThreatClassic = LibStub("ThreatClassic-1.0")
    UnitThreatSituation = function(unit, mob)
        ThreatClassic:UnitThreatSituation(unit, mob)
    end
end

-- From constants
local units, threat, operators = addon.units, addon.threat, addon.operators

-- From utils
local compare, compareString, nullable, keys, isin, deepcopy, getCached, playerize =
    addon.compare, addon.compareString, addon.nullable, addon.keys, addon.isin, addon.deepcopy, addon.getCached, addon.playerize

addon:RegisterCondition("COMBAT", {
    description = L["In Combat"],
    icon = "Interface\\Icons\\ability_dualwield",
    valid = function(spec, value)
        return value.unit ~= nil and isin(units, value.unit);
    end,
    evaluate = function(value, cache, evalStart)
        return getCached(cache, UnitAffectingCombat, value.unit)
    end,
    print = function(spec, value)
        return string.format(playerize(value.unit, L["%s are in combat"], L["%s is in combat"]),
            nullable(units[value.unit], L["<unit>"]))
    end,
    widget = function(parent, spec, value)
        local top = parent:GetUserData("top")
        local root = top:GetUserData("root")
        local funcs = top:GetUserData("funcs")

        local unit = AceGUI:Create("Dropdown")
        parent:AddChild(unit)

        unit:SetLabel(L["Unit"])
        unit:SetList(units, keys(units))
        if (value.unit ~= nil) then
            unit:SetValue(value.unit)
        end
        unit:SetCallback("OnValueChanged", function(widget, event, v)
            value.unit = v
            top:SetStatusText(funcs:print(root, spec))
        end)
    end,
})

addon:RegisterCondition("PET", {
    description = L["Have Pet"],
    icon = "Interface\\Icons\\Inv_box_petcarrier_01",
    valid = function(spec, value)
        return true
    end,
    evaluate = function(value, cache, evalStart)
        return getCached(cache, UnitExists, "pet")
    end,
    print = function(spec, value)
        return L["you have a pet"]
    end,
    widget = function(parent, spec, value)
    end,
})

addon:RegisterCondition("PET_NAME", {
    description = L["Have Named Pet"],
    icon = "Interface\\Icons\\inv_box_birdcage_01",
    valid = function(spec, value)
        return value.value ~= nil
    end,
    evaluate = function(value, cache, evalStart)
        return getCached(cache, GetUnitName, "pet") == value.value
    end,
    print = function(spec, value)
        return string.format(L["you have a pet named %s"], nullable(value.value, L["<name>"]))
    end,
    widget = function(parent, spec, value)
        local top = parent:GetUserData("top")
        local root = top:GetUserData("root")
        local funcs = top:GetUserData("funcs")

        local health = AceGUI:Create("EditBox")
        parent:AddChild(health)

        health:SetLabel(NAME)
        if (value.value ~= nil) then
            health:SetText(value.value)
        end
        health:SetCallback("OnEnterPressed", function(widget, event, v)
            value.value = v
            top:SetStatusText(funcs:print(root, spec))
        end)
    end,
})

addon:RegisterCondition("STEALTHED", {
    description = L["Stealth"],
    icon = "Interface\\Icons\\ability_stealth",
    valid = function(spec, value)
        return true
    end,
    evaluate = function(value, cache, evalStart)
        return getCached(cache, IsStealthed)
    end,
    print = function(spec, value)
        return L["you are stealthed"]
    end,
})

addon:RegisterCondition("INCONTROL", {
    description = L["In Control"],
    icon = "Interface\\Icons\\spell_nature_polymorph",
    valid = function(spec, value)
        return true
    end,
    evaluate = function(value, cache, evalStart)
        return getCached(cache, HasFullControl)
    end,
    print = function(spec, value)
        return L["you are in control of your character"]
    end,
})

addon:RegisterCondition("MOVING", {
    description = L["Moving"],
    icon = "Interface\\Icons\\Ability_druid_dash",
    valid = function(spec, value)
        return true
    end,
    evaluate = function(value, cache, evalStart)
        return (getCached(cache, GetUnitSpeed, "player") ~= 0)
    end,
    print = function(spec, value)
        return L["you are moving"]
    end,
})

addon:RegisterCondition("THREAT", {
    description = L["Threat"],
    icon = "Interface\\Icons\\ability_physical_taunt",
    valid = function(spec, value)
        return value.unit ~= nil and isin(units, value.unit) and
               value.value ~= nil and value.value >= 1 and value.value <= 4
    end,
    evaluate = function(value, cache, evalStart)
        local rv = getCached(cache, UnitThreatSituation, "player", value.unit)
        if rv ~= nil and rv >= value.value - 1 then
            return true
        else
            return false
        end
    end,
    print = function(spec, value)
        return string.format(L["you are at least %s on %s"], nullable(threat[value.value], L["<threat>"]),
        nullable(units[value.unit], L["<unit>"]))
    end,
    widget = function(parent, spec, value)
        local top = parent:GetUserData("top")
        local root = top:GetUserData("root")
        local funcs = top:GetUserData("funcs")
        local units = deepcopy(units, { "player", "pet" })

        local unit = AceGUI:Create("Dropdown")
        parent:AddChild(unit)
        local val = AceGUI:Create("Dropdown")
        parent:AddChild(val)

        unit:SetLabel(L["Unit"])
        unit:SetList(units, keys(units))
        if (value.unit ~= nil) then
            unit:SetValue(value.unit)
        end
        unit:SetCallback("OnValueChanged", function(widget, event, v)
            value.unit = v
            top:SetStatusText(funcs:print(root, spec))
        end)

        val:SetLabel(L["Threat"])
        val:SetList(threat)
        if (value.value ~= nil) then
            val:SetValue(value.value)
        end
        val:SetCallback("OnValueChanged", function(widget, event, v)
            value.value = v
            top:SetStatusText(funcs:print(root, spec))
        end)
    end,
})

addon:RegisterCondition("THREAT_COUNT", {
    description = L["Threat Count"],
    icon = "Interface\\Icons\\Ability_racial_bloodrage",
    valid = function(spec, value)
        return value.count ~= nil and value.count >= 0 and
                value.operator ~= nil and isin(operators, value.operator) and
                value.value ~= nil and value.value >= 1 and value.value <= 4
    end,
    evaluate = function(value, cache, evalStart)
        local count = 0
        for unit, entity in pairs(addon.unitsInRange) do
            if entity.enemy and entity.threat >= value.value - 1 then
                count = count + 1
            end
        end
        return compare(value.operator, count, value.count)
    end,
    print = function(spec, value)
        return compareString(value.operator,
                        string.format(L["number of enemies you are at least %s"],
                        nullable(threat[value.value], L["<threat>"])),
                        nullable(value.count))
    end,
    widget = function(parent, spec, value)
        local top = parent:GetUserData("top")
        local root = top:GetUserData("root")
        local funcs = top:GetUserData("funcs")
        local units = deepcopy(units, { "player", "pet" })

        local val = AceGUI:Create("Dropdown")
        parent:AddChild(val)
        local operator = AceGUI:Create("Dropdown")
        parent:AddChild(operator)
        local count = AceGUI:Create("EditBox")
        parent:AddChild(count)

        val:SetLabel(L["Threat"])
        val:SetList(threat)
        if (value.value ~= nil) then
            val:SetValue(value.value)
        end
        val:SetCallback("OnValueChanged", function(widget, event, v)
            value.value = v
            top:SetStatusText(funcs:print(root, spec))
        end)

        operator:SetLabel(L["Operator"])
        operator:SetList(operators, keys(operators))
        if (value.operator ~= nil) then
            operator:SetValue(value.operator)
        end
        operator:SetCallback("OnValueChanged", function(widget, event, v)
            value.operator = v
            top:SetStatusText(funcs:print(root, spec))
        end)

        count:SetLabel(L["Count"])
        count:SetWidth(100)
        if (value.count ~= nil) then
            count:SetText(value.count)
        end
        count:SetCallback("OnEnterPressed", function(widget, event, v)
            value.count = tonumber(v)
            top:SetStatusText(funcs:print(root, spec))
        end)
    end,
})

local character_class = select(2, UnitClass("player"))
addon.condition_form = {
    description = L["Shapeshift Form"],
    icon = "Interface\\Icons\\ability_hunter_pet_bear",
    valid = function(spec, value)
        return value.value ~= nil and value.value >= 0 and value.value <= (character_class == "SHAMAN" and 1 or GetNumShapeshiftForms())
    end,
    evaluate = function(value, cache, evalStart)
        return getCached(cache, GetShapeshiftForm) == value.value
    end,
    print = function(spec, value)
        local form
        if value.value ~= nil then
            if value.value == 0 then
                form = L["humanoid"]
            elseif character_class == "SHAMAN" then
                form = select(1, GetSpellInfo("Ghost Wolf"))
            else
                form = select(2, GetShapeshiftFormInfo(index))
            end
        end
        return string.format(L["you are in %s form"], nullable(form, L["<form>"]))
    end,
    widget = function(parent, spec, value)
        local top = parent:GetUserData("top")
        local root = top:GetUserData("root")
        local funcs = top:GetUserData("funcs")

        local forms = {}
        local formsOrder = {}

        forms["0"] = L["humanoid"]
        table.insert(formsOrder, "0")
        if character_class == "SHAMAN" then
            forms["1"] = select(1, GetSpellInfo("Ghost Wolf"))
            table.insert(formsOrder, tostring("1"))
        else
            for i=1,GetNumShapeshiftForms() do
                local _, name = GetShapeshiftFormInfo(index);
                forms[tostring(i)] = name;
                table.insert(formsOrder, tostring(i))
            end
        end

        local formIcon = AceGUI:Create("Icon")
        parent:AddChild(formIcon)
        local form = AceGUI:Create("Dropdown")
        parent:AddChild(form)


        formIcon:SetWidth(44)
        formIcon:SetHeight(44)
        formIcon:SetImageSize(36, 36)
        function set_form_icon()
            if value.value ~= nil then
                if value.value == 0 then
                    formIcon:SetImage("Interface\\Icons\\inv_misc_head_human_02")
                else
                    if character_class == "SHAMAN" then
                        if value.value == 1 then
                            formIcon:SetImage(GetSpellTexture("Ghost Wolf"))
                        end
                    else
                        formIcon:SetImage(GetShapeshiftFormInfo(value.value))
                    end
                end
            else
                formIcon:SetImage("Interface\\Icons\\INV_Misc_QuestionMark")
            end
        end
        set_form_icon()

        form:SetLabel(L["Form"])
        form:SetList(forms, formsOrder)
        if (value.value) then
            form:SetValue(tostring(value.value))
        end
        form:SetCallback("OnValueChanged", function(widget, event, v)
            value.value = tonumber(v)
            form:SetValue(v)
            set_form_icon()
            top:SetStatusText(funcs:print(root, spec))
        end)
    end,
}

addon:RegisterCondition("FORM", addon.condition_form)

addon:RegisterCondition("ENEMY", {
    description = L["Enemy"],
    icon = "Interface\\Icons\\inv_misc_head_dragon_01",
    valid = function(spec, value)
        return value.unit ~= nil and isin(units, value.unit);
    end,
    evaluate = function(value, cache, evalStart)
        return getCached(cache, UnitIsEnemy, "player", value.ulnit)
    end,
    print = function(spec, value)
        return string.format(L["%s is an enemy"], nullable(units[value.unit], L["<unit>"]))
    end,
    widget = function(parent, spec, value)
        local top = parent:GetUserData("top")
        local root = top:GetUserData("root")
        local funcs = top:GetUserData("funcs")
        local units = deepcopy(units, { "player", "pet" })

        local unit = AceGUI:Create("Dropdown")
        parent:AddChild(unit)

        unit:SetLabel(L["Unit"])
        unit:SetList(units, keys(units))
        if (value.unit ~= nil) then
            unit:SetValue(value.unit)
        end
        unit:SetCallback("OnValueChanged", function(widget, event, v)
            value.unit = v
            top:SetStatusText(funcs:print(root, spec))
        end)
    end,
})
