local _, addon = ...

addon:RegisterSwitchCondition("LEVEL", addon.condition_self_level)
addon:RegisterSwitchCondition("PVP", addon.condition_pvp)
addon:RegisterSwitchCondition("ZONEPVP", addon.condition_zonepvp)
addon:RegisterSwitchCondition("ZONE", addon.condition_zone)
addon:RegisterSwitchCondition("INSTANCE", addon.condition_instance)
addon:RegisterSwitchCondition("OUTDOORS", addon.condition_outdoors)
addon:RegisterSwitchCondition("STEALTHED", addon.condition_stealthed)
addon:RegisterSwitchCondition("GROUP", addon.condition_group)
addon:RegisterSwitchCondition("FORM", addon.condition_form)
addon:RegisterSwitchCondition("CLASS", addon.condition_class)
addon:RegisterSwitchCondition("CLASS_GROUP", addon.condition_class_group)
addon:RegisterSwitchCondition("CREATURE", addon.condition_creature)
addon:RegisterSwitchCondition("CLASSIFICATION", addon.condition_classification)
addon:RegisterSwitchCondition("PET_NAME", addon.condition_pet_name)
addon:RegisterSwitchCondition("EQUIPPED", addon.condition_equipped)
addon:RegisterSwitchCondition("DISTANCE_COUNT", addon.condition_distance_count)
if (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC and
        LE_EXPANSION_LEVEL_CURRENT >= LE_EXPANSION_NORTHREND) then
    addon:RegisterCondition(CATEGORY_SPELLS, "GLYPH", addon.condition_glyph)
end