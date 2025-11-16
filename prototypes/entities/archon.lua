--
-- Created by IntelliJ IDEA.
-- User: heyqule
-- Date: 12/15/2020
-- Time: 9:39 PM
-- To change this template use File | Settings | File Templates.
--



local ERM_UnitTint = require("__enemyracemanager__/lib/rig/unit_tint")
local ERM_UnitHelper = require("__enemyracemanager__/lib/rig/unit_helper")
local ERMDataHelper = require("__enemyracemanager__/lib/rig/data_helper")
local ERMPlayerUnitHelper = require("__enemyracemanager__/lib/rig/player_unit_helper")
local GlobalConfig = require("__enemyracemanager__/lib/global_config")
local TossSound = require("__erm_toss_hd_assets__/sound")
local AnimationDB = require("__erm_toss_hd_assets__/animation_db")
local util = require("util")

local name = "archon"


-- Hitpoints
local hitpoint = 460

-- Handles acid and poison resistance
local resistances = 80

local movement_speed = 0.3
-- Handles damages
local damage_modifier = 30
local distraction_cooldown = 30


local collision_box = { { -0.5, -0.5 }, { 0.5, 0.5 } }
local selection_box = { { -1, -1 }, { 1, 1 } }

local Unit = {}

function Unit.make(prefix, hp_mp, damage_mp)

    local attack_range = 2
    local vision_distance = ERMPlayerUnitHelper.get_vision_distance(attack_range)
    
    local attack_animation = AnimationDB.get_layered_animations("units", name, "attack")
    local archon_animation = AnimationDB.get_single_animation("units", name,"attack_attachment")
    table.insert(attack_animation, archon_animation)

    data:extend({
        {
            type = "unit",
            name = prefix..'--controllable--'..name,
            localised_name = { "entity-name." .. prefix..'--controllable--'..name },
            icon = "__erm_toss_hd_assets__/graphics/entity/icons/units/" .. name .. ".png",
            icon_size = 64,
            flags = { "placeable-enemy", "placeable-player", "placeable-off-grid", "breaths-air", "not-flammable", "not-repairable" },
            has_belt_immunity = true,
            max_health = hitpoint * hp_mp * ERMPlayerUnitHelper.get_health_multiplier(),
            order = prefix .. "--unit--" .. name,
            subgroup = "erm_controllable_units",
            shooting_cursor_size = 2,
            radar_range = 2,
            can_open_gates = true,
            resistances = {
                { type = "acid", percent = resistances },
                { type = "poison", percent = resistances },
                { type = "physical", percent = resistances },
                { type = "fire", percent = resistances },
                { type = "explosion", percent = resistances },
                { type = "laser", percent = resistances },
                { type = "electric", percent = resistances },
                { type = "cold", percent = resistances }
            },
            healing_per_tick = 0,
            collision_box = collision_box,
            selection_box = selection_box,
            sticker_box = selection_box,
            vision_distance = vision_distance,
            movement_speed = movement_speed * ERMPlayerUnitHelper.get_speed_multiplier(),
            absorptions_to_join_attack = { pollution = 100},
            distraction_cooldown = distraction_cooldown,
            spawning_time_modifier = 2,
            light = {
                intensity = 1,
                size = 16,
                color = ERM_UnitTint.tint_archon_light()
            },
            attack_parameters = {
                type = "projectile",
                range_mode = "bounding-box-to-bounding-box",
                range = attack_range,
                cooldown = 75,
                cooldown_deviation = 0.1,
                damage_modifier = damage_modifier * damage_mp,
                ammo_category = prefix.."--erm_controllable",
                ammo_type = {
                    target_type = "direction",
                    action = {
                        type = "direct",
                        action_delivery = {
                            type = "instant",
                            target_effects = {
                                {
                                    type = "create-explosion",
                                    entity_name = "protoss--archon-hit-explosion"
                                },
                                {
                                    type = "nested-result",
                                    action = {
                                        type = "area",
                                        force = "not-same",
                                        radius = 3,
                                        ignore_collision_condition = true,
                                        action_delivery = {
                                            type = "instant",
                                            target_effects = {
                                                type = "damage",
                                                damage = { amount = 50, type = "electric" }
                                            },
                                            apply_damage_to_trees = true
                                        }
                                    }
                                }
                            }
                        }
                    },
                },
                sound = TossSound.archon_attack(0.9),
                animation = attack_animation
            },

            distance_per_frame = 0.2,
            run_animation = AnimationDB.get_layered_animations("units", name, "run"),
            dying_sound = TossSound.enemy_death(name, 1),
            dying_explosion = "protoss--small-building-explosion",
            map_color = ERM_UnitTint.tint_army_color(),
            enemy_map_color = { r=1, b=0, g=0 },
            corpse = name .. "-corpse"
        },
        {
            type = "corpse",
            name = name .. "-corpse",
            icon = "__erm_toss_hd_assets__/graphics/entity/icons/units/" .. name .. ".png",
            icon_size = 64,
            flags = { "placeable-off-grid", "building-direction-8-way", "not-on-map" },
            selection_box = selection_box,
            selectable_in_game = false,
            dying_speed = 0.04,
            time_before_removed = second,
            subgroup = "corpses",
            animation = util.empty_sprite(),
        },
    })
end

return Unit
