export dnnObjFctn, evalObjFctn

"""
objective function for deep neural networks

J(theta,C) = loss(h(W*Y(theta)), C) + Rtheta(theta) + R(W)

"""
type dnnObjFctn
     net    :: NN              # network param (including data)
     pLoss             # loss function
     pRegTheta         # regularizer for network parameters
     pRegW             # regularizer for classifier
     dnnObjFctn(net,pLoss,pRegTheta,pRegW) =
               new(net,pLoss,pRegTheta,pRegW)
 end

splitWeights(this::dnnObjFctn,x) = (return x[1:nTheta(this.net)], x[nTheta(this.net)+1:end])

function getMisfit{T}(this::dnnObjFctn,thetaW::Vector{T},Y::Array{T},C::Array{T},doDerivative=true)
    theta,W = splitWeights(this,thetaW)
    return getMisfit(this,theta,W,Y,C,doDerivative)
end

function getMisfit{T}(this::dnnObjFctn,theta::Array{T},W::Array{T},Y::Array{T},C::Array{T},doDerivative=true)

    YN,dummy,tmp = apply(this.net,theta,Y,doDerivative)

    Fc,hisF,dWF,d2WF,dYF,d2YF = getMisfit(this.pLoss,W,YN,C,doDerivative,doDerivative)
	
    if doDerivative
		 dYF = JthetaTmv(this.net,dYF,zeros(T,0),theta,Y,tmp)
    end
    return Fc,hisF,vec(dYF),vec(dWF)
end

function evalObjFctn{T}(this::dnnObjFctn,thetaW::Array{T},Y::Array{T},C::Array{T},doDerivative=true)
    theta,W = splitWeights(this,thetaW)
	
    # compute misfit
    Fc,hisF,dFth,dFW = getMisfit(this,theta,W,Y,C,doDerivative)
	
    # regularizer for weights
    Rth,dRth, = regularizer(this.pRegTheta,theta)

    # regularizer for classifier
    RW,dRW, = regularizer(this.pRegW,W)

    Jc = Fc + Rth + RW
    dJ = [dFth+dRth; dFW+dRW]

    return convert(T,Jc),hisF,convert(Array{T},dJ)
end
