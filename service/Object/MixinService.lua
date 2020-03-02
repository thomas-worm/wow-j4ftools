local GlobalAddonName, J4FT = ...

J4FT = J4FT or {}
J4FT.Service = J4FT.Service or {}
J4FT.Service.Object = J4FT.Service.Object or {}
J4FT.Service.Object.MixinService = J4FT.Service.Object.MixinService or {}

local MixinService = J4FT.Service.Object.MixinService

function MixinService.Get()
    return MixinService
end

function MixinService:DeepMixin(object, ...)
	for i = 1, select("#", ...) do
        local mixin = select(i, ...);
        if type(mixin) == "table" then
            for k, v in pairs(mixin) do
                if (type(v) == "table") and (type(object[k] or false) == "table") then
                    self:DeepMixin(object[k] or {}, mixin[k] or {})
                else
                    object[k] = v
                end
            end
        end
	end

	return object;
end