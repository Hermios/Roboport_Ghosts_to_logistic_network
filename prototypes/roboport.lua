roboport={}
custom_prototypes["roboport"]=roboport

function roboport:new (entity)
    local sender = entity.surface.create_entity({name=roboport_converter_combinator,position=entity.position,force=entity.force})
	sender.operable = false
	sender.minable = false
	sender.destructible = false
	entity.connect_neighbour{wire=defines.wire_type.green,target_entity=sender}
	entity.connect_neighbour{wire=defines.wire_type.red,target_entity=sender}
    return {
        entity=entity,
        sender=sender
    }
end

function roboport:on_built()
    self:update_all()
end

function roboport:update_all()
    self.sender.get_or_create_control_behavior().parameters=nil
    local parameters={}
    for _,entity in pairs(game.get_surface(1).find_entities_filtered{type={"tile-ghost","item-request-proxy","entity-ghost"},position=self.entity.position,radius=self.entity.prototype.construction_radius}) do
        if  entity.type=="entity-ghost" and entity.ghost_prototype.mineable_properties.products then
            signal=entity.ghost_prototype.mineable_properties.products[1].name
            parameters[signal]=(parameters[signal] or 0) + 1
        elseif  entity.type=="tile-ghost" then
            signal=entity.ghost_name
            parameters[signal]=(parameters[signal] or 0) + 1
        elseif entity.type=="item-request-proxy" then
            for module,count in pairs(entity.item_requests) do
                parameters[module]=(parameters[module] or 0) + count
            end
        end
    end
    for _,entity in pairs(game.get_surface(1).find_entities_filtered{type={"cliff"},to_be_deconstructed=true,position=self.entity.position,radius=self.entity.prototype.construction_radius}) do
        local signal=entity.prototype.cliff_explosive_prototype
        parameters[signal]=(parameters[signal] or 0) + 1
    end
    for _,entity in pairs(game.get_surface(1).find_entities_filtered{to_be_upgraded=true,position=self.entity.position,radius=self.entity.prototype.construction_radius}) do
        local signal=entity.get_upgrade_target().name
        parameters[signal]=(parameters[signal] or 0) + 1
    end
    local i=1
    for signal,count in pairs(parameters) do
        if i>20 then
            return
        end
        self.sender.get_or_create_control_behavior().set_signal(i,{signal={type="item",name=signal},count=-1*count})
        i=i+1
    end
end

function roboport:on_removed()
    self.sender.destroy()
end