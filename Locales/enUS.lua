local L = LibStub("AceLocale-3.0"):NewLocale("RotationMaster", "enUS", true)
if not L then return end

local color = color

-- from main.lua

L["/rm help                - This text"] = true
L["/rm config              - Open the config dialog"] = true
L["/rm current             - Print out the name of the current rotation"] = true
L["/rm set [auto|profile]  - $witch to a specific rotation, or use automatic switching again."] = true
L["                          This is reset upon switching specializations."] = true

L["No roation is currently active."] = true
L["The current rotation is " .. color.WHITE .. "%s" .. color.INFO] = true
L["Active rotation manually switched to " .. color.WHITE .. "%s" .. color.INFO] = true
L["Could not find rotation namned " .. color.WHITE .. "%s" .. color.WARN .. " for your current specialization."] = true
L["Invalid option " .. color.WHITE .. "%s" .. color.WARN] = true

L["Starting up version %s"] = true
L["Rotaion " .. color.WHITE .. "%s" .. color.DEBUG .. " is now available for auto-switching."] = true
L["Active rotation automatically switched to " .. color.WHITE .. "%s" .. color.INFO] = true
L["No rotation is active as there is none suitable to automatically switch to."] = true
L["Battle rotation enabled"] = true
L["Battle rotation disabled"] = true

L["[Tier: %d, Column: %d]"] = true
L["Autoswitch rotation list has been updated."] = true

L["Button Fetch triggered."] = true
L["Notified configuration to update it's status."] = true

-- from constants.lua

L["is less than"] = true
L["is less than or equal to"] = true
L["is greater than"] = true
L["is greater than or equal to"] = true
L["is equal to"] = true
L["is not equal to"] = true
L["is evenly divisible by"] = true

L["you"] = true
L["your pet"] = true
L["your target"] = true
L["your focus target"] = true
L["your mouseover target"] = true
L["your pet's target"] = true
L["your target's target"] = true
L["your focus target's target"] = true
L["your mouseover target's target"] = true

L["your"] = true
L["your pet's"] = true
L["your target's"] = true
L["your focus target's"] = true
L["your mouseover target's"] = true
L["your pet's target's target"] = true
L["your target's target's target"] = true
L["your focus target's target's target"] = true
L["your mouseover target's target's target"] = true

L["Warrior"] = true
L["Paladin"] = true
L["Hunter"] = true
L["Rogue"] = true
L["Priest"] = true
L["Death Knight"] = true
L["Shaman"] = true
L["Mage"] = true
L["Warlock"] = true
L["Monk"] = true
L["Druid"] = true
L["Demon Hunter"] = true

L["Tank"] = true
L["DPS"] = true
L["Healer"] = true

L["Magic"] = true
L["Disease"] = true
L["Poison"] = true
L["Curse"] = true

L["Arena"] = true
L["Controlled by your faction"] = true
L["Contested"] = true
L["Controlled by opposing faction"] = true
L["Sanctuary (no PVP)"] = true
L["Combat (auto-flagged)"] = true

L["Outside"] = true
L["Battleground"] = true
L["Arena"] = true
L["Dungeon"] = true
L["Raid"] = true

L["Fire"] = true
L["Earth"] = true
L["Water"] = true
L["Air"] = true

-- from utils.lua

L["<value>"] = true
L["<operator>"] = true

-- from Options/general.lua

L["Enable Rotation Master"] = true
L["Polling Interval (milliseconds)"] = true
L["Overlay Options"] = true
L["Overlay Texture"] = true
L["Magnification"] = true
L["Highlight Color"] = true
L["Debugging Options"] = true
L["Debug Logging"] = true
L["Verbose Debug Logging"] = true
L["Disable Auto-Switching"] = true
L["Live Status Update Frequency (seconds)"] = true
L["This is specifically how often the configuration pane will receive updates about live status.  Too frequently could make your configuration pane unusable.  0 = Disabled."] = true
L["Are you sure you wish to delete this rotation?"] = true
L["Import/Export Rotation"] = true
L["Copy and paste this text share your profile with others, or import someone else's."] = true
L["bytes"] = true
L["Imported on %c"] = true
L["Import/Export"] = true
L["Switch Condition"] = true
L["No other rotations match."] = true
L["Manual switch only."] = true
L["THIS CONDITION DOES NOT VALIDATE"] = true
L["THIS ROTATION WILL NOT BE USED AS IT IS INCOMPLETE"] = true
L["Cooldowns"] = true
L["Rotation"] = true
L["Rotations"] = true
L["Texture"] = true
L["Textures"] = true
L["Profiles"] = true

-- from Options/cooldowns.lua and Options/rotations.lua

L["Spells that you wish to conditionally highlight independent of your rotation.  And or all of these may be highlighted at the same time."] = true
L["Your main spell rotation.  Only one spell will be highlighted at once, which spell being based on the first satisfied condition."] = true
L["Move Up"] = true
L["Move Down"] = true
L["Action Type"] = true
L["Spell"] = true
L["Item"] = true
L["Conditions"] = true
L["THIS CONDITION DOES NOT VALIDATE"] = true
L["This conditions is currently satisfied."] = true
L["This conditions is currently not satisfied."] = true

-- from Options/conditional.lua

L["AND"] = true
L["OR"] = true
L["NOT"] = true
L["<INVALID CONDITION>"] = true
L["Please Choose ..."] = true
L["Condition Type"] = true
L["Edit Condition #%d"] = true
L["Edit Condition"] = true

-- From the Conditions

L["<unit>"] = true
L["<spell>"] = true
L["<item>"] = true
L["<role>"] = true
L["<class>"] = true
L["<talent>"] = true
L["<buff>"] = true
L["<debuff>"] = true
L["<element>"] = true
L["<totem>"] = true
L["<form>"] = true
L["<zone>"] = true
L["<name>"] = true

L["%s is in a %s role"] = true
L["%s is a %s"] = true
L["%s are a %s"] = true
L["%s have %s"] = true
L["%s has %s"] = true
L["%s have %s where %s"] = true
L["%s has %s where %s"] = true
L["you are talented in %s"] = true

L["Unit"] = true
L["Role"] = true
L["Class"] = true
L["Talent"] = true
L["Operator"] = true

L["Health"] = true
L["%s health"] = true
L["Health Percentage"] = true

L["Mana"] = true
L["%s mana"] = true
L["Mana Percentage"] = true

L["Power"] = true
L["%s power"] = true
L["Power Percentage"] = true

L["Spell Available"] = true
L["%s is available"] = true
L["Spell Cooldown"] = true
-- This is used for things like "the cooldown on <spell> is less than 5 seconds"
L["the %s"] = true
L["cooldown on %s"] = true
L["%s seconds"] = true
L["Seconds"] = true

L["Spell Time Remaining"] = true
L["remaining time on %s"] = true
L["Spell Charges"] = true
L["number of charges on %s"] = true
L["Charges"] = true

L["Pet Spell Available"] = true
L["Pet Spell Cooldown"] = true
L["Pet Spell Time Remaining"] = true
L["Pet Spell Charges"] = true

L["Buff Present"] = true
L["Buff Time Remaining"] = true
L["the remaining time"] = true
L["Buff Stacks"] = true
L["stacks of %s"] = true
L["Stacks"] = true
L["Has Stealable Buff"] = true
L["%s has a stealable buff"] = true

L["Debuff Present"] = true
L["Debuff Time Remaining"] = true
L["Debuff Stacks"] = true
L["Has Dispellable Debuff"] = true
L["%s have a %s debuff"] = true
L["%s has a %s debuff"] = true
L["<debuff type>"] = true
L["Debuff Type"] = true

L["Totem Present"] = true
L["%s totem is active"] = true
L["%s is active"] = true
L["Totem"] = true
L["Specific Totem Present"] = true
L["Totem Time Remaining"] = true
L["Specific Totem Time Remaining"] = true
L["you have a %s totem active with %s"] = true
L["%s is active with %s"] = true

L["Have Item Equipped"] = true
L["you have %s equipped"] = true
L["Have Item In Bags"] = true
L["you are carrying %s"] = true
L["Item Available"] = true
L["Item Cooldown"] = true

L["In Combat"] = true
L["%s are in combat"] = true
L["%s is in combat"] = true
L["Have Pet"] = true
L["you have a pet"] = true
L["Have Named Pet"] = true
L["you have a pet named %s"] = true
L["Stealth"] = true
L["you are stealthed"] = true
L["In Control"] = true
L["you are in control of your character"] = true
L["Threat"] = true
L["you have threat on %s"] = true
L["Shapeshift Form"] = true
L["humanoid"] = true
L["Form"] = true
L["Enemy"] = true

L["Channeling"] = true
L["Specific Spell Channeling"] = true
L["%s are currently channeling"] = true
L["%s is currently channeling"] = true
L["%s are currently channeling %s"] = true
L["%s is currently channeling %s"] = true
L["Channel Time Remaining"] = true
L["time remaining on spell channel"] = true
L["Channel Interruptable"] = true
L["%s's channeled spell is interruptable"] = true

L["Casting"] = true
L["Specific Spell Casting"] = true
L["%s are currently casting"] = true
L["%s is currently casting"] = true
L["%s are currently casting %s"] = true
L["%s is currently casting %s"] = true
L["Cast Time Remaining"] = true
L["time remaining on spell cast"] = true
L["Cast Interruptable"] = true
L["%s's spell is interruptable"] = true

L["PVP Flagged"] = true
L["%s are PVP flagged"] = true
L["%s is PVP flagged"] = true
L["Zone PVP"] = true
L["zone is a %s zone"] = true
L["no PVP"] = true
L["Mode"] = true
L["Instance"] = true
L["you are in a %s instance"] = true
L["Other (scenario)"] = true
L["in %s"] = true
L["Zone"] = true
L["SubZone"] = true
L["In Group"] = true
L["you are in a group"] = true
L["In Raid"] = true
L["you are in a raid"] = true
L["Outdoors"] = true
L["you are in a outdoors"] = true

