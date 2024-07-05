require "__Hermios_Framework__.control-libs"
require "constants"
require "prototypes.roboport"

table.insert(list_events.on_init,function()
    global.max_construction_radius=0
    for _,roboport_prototype in pairs(game.get_filtered_entity_prototypes{{filter="type",type="roboport"}}) do
        global.max_construction_radius=math.max(global.max_construction_radius or 0,roboport_prototype.construction_radius)
    end
end)

table.insert(list_events.on_built,function(entity)
    for _,roboport_entity in pairs(game.get_surface(1).find_entities_filtered{type="roboport",position=entity.position,radius=global.max_construction_radius}) do
        if global.custom_entities[roboport_entity.unit_number] then
            global.custom_entities[roboport_entity.unit_number]:update_all()
        end
    end
end)

table.insert(list_events.on_marked_for_deconstruction,function (event)
    if event.entity.type~="cliff" then
        return
    end
    for _,roboport_entity in pairs(game.get_surface(1).find_entities_filtered{type="roboport",position=event.entity.position,radius=global.max_construction_radius}) do
        if global.custom_entities[roboport_entity.unit_number] then
            global.custom_entities[roboport_entity.unit_number]:update_all()
        end
    end
end)

table.insert(list_events.on_marked_for_upgrade,function (event)
    for _,roboport_entity in pairs(game.get_surface(1).find_entities_filtered{type="roboport",position=event.entity.position,radius=global.max_construction_radius}) do
        if global.custom_entities[roboport_entity.unit_number] then
            global.custom_entities[roboport_entity.unit_number]:update_all()
        end
    end
end)

table.insert(list_events.on_post_entity_died,function(event)
    if not event.ghost then
        return
    end
    for _,roboport_entity in pairs(game.get_surface(1).find_entities_filtered{type="roboport",position=event.ghost.position,radius=global.max_construction_radius}) do
        if global.custom_entities[roboport_entity.unit_number] then
            global.custom_entities[roboport_entity.unit_number]:update_all()
        end
    end
end)

table.insert(list_events.on_removed,function(entity)
    if entity.type=="entity-ghost" then
        for _,roboport_entity in pairs(game.get_surface(1).find_entities_filtered{type="roboport",position=entity.position,radius=global.max_construction_radius}) do
            if global.custom_entities[roboport_entity.unit_number] then
                global.custom_entities[roboport_entity.unit_number]:update_all()
            end
        end
    end
end)