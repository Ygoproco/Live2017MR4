--エルシャドール・アノマリリス
function c19261966.initial_effect(c)
	c:EnableReviveLimit()
	c19261966.min_material_count=2
	c19261966.max_material_count=2
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c19261966.fuscon)
	e1:SetOperation(c19261966.fusop)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c19261966.splimit)
	c:RegisterEffect(e2)
	--spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetTarget(c19261966.sumlimit)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(19261966,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c19261966.thtg)
	e4:SetOperation(c19261966.thop)
	c:RegisterEffect(e4)
end
c19261966.material_setcode=0x9d
function c19261966.ffilter1(c)
	return (c:IsFusionSetCard(0x9d) or c:IsHasEffect(511002961)) and not c:IsHasEffect(6205579)
end
function c19261966.ffilter2(c,fc)
	return (c:IsHasEffect(511002961) or c:IsFusionAttribute(ATTRIBUTE_WATER) or c:IsHasEffect(4904633)) and not c:IsHasEffect(6205579)
end
function c19261966.exfilter(c,g,fc)
	return c:IsFaceup() and c:IsCanBeFusionMaterial(fc) and not g:IsContains(c) and (c19261966.ffilter1(c) or c19261966.ffilter2(c))
end
function c19261966.ffilter(c,fc)
	return c:IsCanBeFusionMaterial(fc) and (c19261966.ffilter1(c) or c19261966.ffilter2(c))
end
function c19261966.filterchk(c,tp,mg,sg,exg,fc,chkf)
	local res
	local rg=Group.CreateGroup()
	if c:IsHasEffect(73941492+TYPE_FUSION) then
		local eff={c:GetCardEffect(73941492+TYPE_FUSION)}
		for i,f in ipairs(eff) do
			if sg:IsExists(Auxiliary.TuneMagFilter,1,c,f,f:GetValue()) then
				mg:Merge(rg)
				return false
			end
			local sg2=mg:Filter(function(c) return not Auxiliary.TuneMagFilterFus(c,f,f:GetValue()) end,nil)
			rg:Merge(sg2)
			mg:Sub(sg2)
		end
	end
	local g2=sg:Filter(Card.IsHasEffect,nil,73941492+TYPE_FUSION)
	if g2:GetCount()>0 then
		local tc=g2:GetFirst()
		while tc do
			local eff={tc:GetCardEffect(73941492+TYPE_FUSION)}
			for i,f in ipairs(eff) do
				if Auxiliary.TuneMagFilter(c,f,f:GetValue()) then
					mg:Merge(rg)
					return false
				end
			end
			tc=g2:GetNext()
		end	
	end
	sg:AddCard(c)
	if sg:GetCount()<2 then
		if exg:IsContains(c) then
			mg:Sub(exg)
			rg:Merge(exg)
		end
		res=mg:IsExists(c19261966.filterchk,1,sg,tp,mg,sg,exg,fc,chkf)
	else
		res=aux.FCheckMixGoal(tp,sg,fc,true,true,chkf,c19261966.ffilter1,c19261966.ffilter2)
	end
	sg:RemoveCard(c)
	mg:Merge(rg)
	return res
end
function c19261966.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	local chkf=bit.band(chkf,0xff)
	local c=e:GetHandler()
	local mg=g:Filter(c19261966.ffilter,nil,c)
	local exg=Group.CreateGroup()
	local tp=e:GetHandlerPlayer()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		exg=Duel.GetMatchingGroup(c19261966.exfilter,tp,0,LOCATION_MZONE,nil,g,c)
		mg:Merge(exg)
	end
	if gc then
		return mg:IsContains(gc) and c19261966.filterchk(gc,tp,mg,Group.CreateGroup(),exg,c,chkf)
	end
	local sg2=Group.CreateGroup()
	return mg:IsExists(c19261966.filterchk,1,nil,tp,mg,Group.CreateGroup(),exg,c,chkf)
end
function c19261966.filterchk2(c,tp,mg,sg,exg,fc,chkf)
	return not exg:IsContains(c) and c19261966.filterchk(c,tp,mg,sg,exg,fc,chkf)
end
function c19261966.filterchk3(c,tp,mg,sg,exg,fc,chkf)
	return exg:IsContains(c) and c19261966.filterchk(c,tp,mg,sg,exg,fc,chkf)
end
function c19261966.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local c=e:GetHandler()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local tp=e:GetHandlerPlayer()
	local exg=Group.CreateGroup()
	local mg=eg:Filter(c19261966.ffilter,nil,c)
	local p=tp
	local sfhchk=false
	local urg=Group.CreateGroup()
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		local sg=Duel.GetMatchingGroup(c19261966.exfilter,tp,0,LOCATION_MZONE,nil,eg)
		exg:Merge(sg)
		mg:Merge(sg)
	end
	if Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
		p=1-tp Duel.ConfirmCards(1-tp,g)
		if mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
	end
	local sg
	if gc then
		sg=Group.FromCards(gc)
		urg:AddCard(gc)
		if exg:IsContains(gc) then
			mg:Sub(exg)
			fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
		end
	else
		sg=Group.CreateGroup()
	end
	while sg:GetCount()<2 do
		local tg=mg:Filter(c19261966.filterchk2,sg,tp,mg,sg,exg,c,chkf)
		local tg2=mg:Filter(c19261966.filterchk3,sg,tp,mg,sg,exg,c,chkf)
		if tg2:GetCount()>0 then
			tg:AddCard(fc)
		end
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
		local tc=Group.SelectUnselect(tg,sg,p)
		if fc then
			tg:RemoveCard(fc)
		end
		if not tc then break end
		if tc==fc then
			fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
			repeat
				tc=Group.SelectUnselect(tg2,sg,p)
			until not sg:IsContains(tc)
			mg:Sub(exg)
			urg:AddCard(tc)
			sg:AddCard(tc)
		end
		if not urg:IsContains(tc) then
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
			else
				sg:RemoveCard(tc)
			end
		end
	end
	if sfhchk then Duel.ShuffleHand(tp) end
	Duel.SetFusionMaterial(sg)
end
function c19261966.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c19261966.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se:IsActiveType(TYPE_SPELL+TYPE_TRAP) and se:IsHasType(EFFECT_TYPE_ACTIONS) 
		and c:IsLocation(LOCATION_GRAVE+LOCATION_HAND)
end
function c19261966.thfilter(c)
	return c:IsSetCard(0x9d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c19261966.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c19261966.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19261966.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c19261966.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c19261966.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
