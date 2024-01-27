global.max_construction_radius=0
for _,roboport_prototype in pairs(game.get_filtered_entity_prototypes{{filter="type",type="roboport"}}) do
    global.max_construction_radius=math.max(global.max_construction_radius,roboport_prototype.construction_radius)
end

for _,roboport_entity in pairs(game.get_surface(1).find_entities_filtered{type="roboport"}) do
    global.custom_entities[roboport_entity.unit_number]=roboport:new(roboport_entity)
end