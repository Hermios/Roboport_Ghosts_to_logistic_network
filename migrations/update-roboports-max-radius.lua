global.max_construction_radius=0
for _,roboport_prototype in pairs(game.get_filtered_entity_prototypes{{filter="type",type="roboport"}}) do
    global.max_construction_radius=math.max(global.max_construction_radius or 0,roboport_prototype.construction_radius)
end
