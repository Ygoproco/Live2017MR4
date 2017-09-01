--Xyz Move 
--scripted by:urielkama
--fixed and cleaned up by MLD
function c511004104.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511004104.condition)
	e1:SetTarget(c511004104.target)
	e1:SetOperation(c511004104.activate)
	c:RegisterEffect(e1)
end
function c511004104.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c511004104.filter(c)
	return c:IsFaceup() and c:IsAbleToChangeControler() and c:IsType(TYPE_XYZ)
end
function c511004104.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511004104.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511004104.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c511004104.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c511004104.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsControler(tp) then
		Duel.GetControl(tc,1-tp)
		Duel.BreakEffect()
		Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	end
end
