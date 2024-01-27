require "__Hermios_Framework__.control-libs"
require "constants"
require "prototypes.roboport"

table.insert(list_events.on_built,function(entity)
    for _,roboport_entity in pairs(game.get_surface(1).find_entities_filtered{type="roboport",position=entity.position,radius=global.max_construction_radius}) do
        if global.custom_entities[roboport_entity.unit_number] then
            if entity.type=="entity-ghost" then
                global.custom_entities[roboport_entity.unit_number]:update_ghost(entity,true)
            else
                global.custom_entities[roboport_entity.unit_number]:update_all()
            end
        end
    end
end)

table.insert(list_events.on_post_entity_died,function(event)
    if not event.ghost then
        return
    end
    for _,roboport_entity in pairs(game.get_surface(1).find_entities_filtered{type="roboport",position=event.ghost.position,radius=global.max_construction_radius}) do
        if global.custom_entities[roboport_entity.unit_number] then
            global.custom_entities[roboport_entity.unit_number]:update_ghost(event.ghost,true)
        end
    end
end)

table.insert(list_events.on_removed,function(entity)
    if entity.type=="entity-ghost" then
        for _,roboport_entity in pairs(game.get_surface(1).find_entities_filtered{type="roboport",position=entity.position,radius=global.max_construction_radius}) do
            if global.custom_entities[roboport_entity.unit_number] then
                global.custom_entities[roboport_entity.unit_number]:update_ghost(entity,false)
            end
        end
    end
end)