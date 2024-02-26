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
    for _,ghost in pairs(game.get_surface(1).find_entities_filtered{type="entity-ghost",position=self.entity.position,radius=self.entity.prototype.construction_radius}) do
       self:update_ghost(ghost,true)
    end
end

function roboport:update_ghost(ghost,add)
    signal={type="item",name=ghost.ghost_name}
    first_emptyindex=nil
    parameters=self.sender.get_or_create_control_behavior().parameters
    for i,parameter in pairs(parameters) do
        if parameter.signal.type=="item" and parameter.signal.name==signal.name then
            parameter.count=parameter.count+(add and -1 or 1)
            if parameter.count==0 then
                parameter=nil
            end
            parameters[i]=parameter
            self.sender.get_or_create_control_behavior().parameters=parameters
            return
        elseif not first_emptyindex and not parameter.signal.signal then
            first_emptyindex=parameter.index
        end
    end
    
    if add  then
        if first_emptyindex then
            self.sender.get_or_create_control_behavior().set_signal(first_emptyindex,{signal=signal,count=-1})
        else
           game.get_user(1).print({"NO_SLOT_AVAILABLE"})
        end
    end
end

function roboport:on_removed()
    self.sender.destroy()
end