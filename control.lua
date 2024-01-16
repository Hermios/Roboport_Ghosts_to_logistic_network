require "__HermiosLibs__.control-libs"
require "constants"
require "prototypes.roboport"

function mod_on_built(entity)
    for _,roboport_entity in pairs(game.get_surface(1).find_entities_filtered{type="roboport",position=entity.position,radius=global.max_construction_radius}) do
        if global.custom_entities[roboport_entity.unit_number] then
            if entity.type=="entity-ghost" then
                global.custom_entities[roboport_entity.unit_number]:update_ghost(entity,true)
            else
                global.custom_entities[roboport_entity.unit_number]:update_all()
            end
        end
    end
end

function on_post_entity_died(event)
    for _,roboport_entity in pairs(game.get_surface(1).find_entities_filtered{type="roboport",position=event.ghost.position,radius=global.max_construction_radius}) do
        if global.custom_entities[roboport_entity.unit_number] then
            global.custom_entities[roboport_entity.unit_number]:update_ghost(event.ghost,true)
        end
    end
end

function mod_on_removed(entity)
    if entity.type=="entity-ghost" then
        for _,roboport_entity in pairs(game.get_surface(1).find_entities_filtered{type="roboport",position=entity.position,radius=global.max_construction_radius}) do
            if global.custom_entities[roboport_entity.unit_number] then
                global.custom_entities[roboport_entity.unit_number]:update_ghost(entity,false)
            end
        end
    end
end