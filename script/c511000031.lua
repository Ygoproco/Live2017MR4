--Power Converter
function c511000031.initial_effect(c)
	aux.AddEquipProcedure(c,0)
	--Gain LP
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511000031,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c511000031.condition)
	e3:SetOperation(c511000031.lpop)
	c:RegisterEffect(e3)
end
function c511000031.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c511000031.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local lp=ec:GetAttack()/2
	if ec and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		ec:RegisterEffect(e1)
	end
	Duel.Recover(tp,lp,REASON_EFFECT)
end
