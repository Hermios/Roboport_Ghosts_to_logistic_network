for _,roboport_entity in pairs(game.get_surface(1).find_entities_filtered{type="roboport"}) do
    global.custom_entities[roboport_entity.unit_number]=roboport:new(roboport_entity)
    global.custom_entities[roboport_entity.unit_number].prototype_index="roboport"
    setmetatable(global.custom_entities[roboport_entity.unit_number],custom_prototypes["roboport"])
    custom_prototypes["roboport"].__index=custom_prototypes["roboport"]
end