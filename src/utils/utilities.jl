
function numel(Y)
    return length(Y)
end

function lastOne(n)
    ei = zeros(n)
    ei[end] = 1
    return ei
end

function fft2(Y)
    return fft(fft(Y,1),2)
end

function ifft2(Y)
    return ifft(ifft(Y,2),1)
end

    
function ndgrid_fill(a, v, s, snext)
	for j = 1:length(a)
		a[j] = v[div(rem(j-1, snext), s)+1]
	end
end

function ndgrid{T}(vs::AbstractVector{T}...)
	n = length(vs)
	sz = map(length, vs)
	out = ntuple(i->Array{T}(sz), n)
	s = 1
	for i=1:n
		a = out[i]::Array
		v = vs[i]
		snext = s*size(a,i)
		ndgrid_fill(a, v, s, snext)
		s = snext
	end
	out
end

# --- meshgrid
meshgrid(v::AbstractVector) = meshgrid(v, v)
function meshgrid{T}(vx::AbstractVector{T}, vy::AbstractVector{T})
	m, n = length(vy), length(vx)
	vx = reshape(vx, 1, n)
	vy = reshape(vy, m, 1)
	(repmat(vx, m, 1), repmat(vy, 1, n))
end

function meshgrid{T}(vx::AbstractVector{T}, vy::AbstractVector{T},
	                 vz::AbstractVector{T})
	m, n, o = length(vy), length(vx), length(vz)
	vx = reshape(vx, 1, n, 1)
	vy = reshape(vy, m, 1, 1)
	vz = reshape(vz, 1, 1, o)
	om = ones(Int, m)
	on = ones(Int, n)
	oo = ones(Int, o)
	(vx[om, :, oo], vy[:, on, oo], vz[om, on, :])
end
