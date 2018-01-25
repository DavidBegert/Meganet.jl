using Base.Test
using Meganet

npixel = 20
nex = 8
nchannel = 3

@testset "normLayer" begin
for k=1:3
 L     = getNormLayer(Float64,[npixel,nchannel,nex],k)
 testAbstractMeganetElement(L)
end
end

@testset "getTVNormLayer (no scaling)" begin
Lb = getTVNormLayer(Float64,[npixel,nchannel,nex],isTrainable=false)
 testAbstractMeganetElement(Lb)
end

@testset "getBatchNormLayer (no scaling)" begin
Lb = getBatchNormLayer(Float64,[npixel,nchannel,nex],isTrainable=false)
 testAbstractMeganetElement(Lb)
end

@testset "getTVNormLayer (with scaling)" begin
Lb = getTVNormLayer(Float64,[npixel,nchannel,nex],isTrainable=true)
 testAbstractMeganetElement(Lb,out=false)
end

@testset "getBatchNormLayer (with scaling)" begin
Lb = getBatchNormLayer(Float64,[npixel,nchannel,nex],isTrainable=true)
 testAbstractMeganetElement(Lb)
end
