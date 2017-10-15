--Contacting "C"
function c101003037.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_MUST_BE_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(REASON_FUSION+REASON_SYNCHRO+REASON_XYZ+REASON_LINK)
	c:RegisterEffect(e1)
end
