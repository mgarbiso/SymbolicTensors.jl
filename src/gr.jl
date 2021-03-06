function get_christoffel(x::TensorHead,TIT::TensorIndexType,metric::T ) where {T <: Tensor}
    """
    returns christoffel symbols as ``Γ_{ijk}``
    """
    @indices TIT i j k l
    g = metric

    simp(x) = contract_metric(x,TIT.metric)
    gg = diff(g(-i,-j),x(k))
    gg = simp(gg)

    h = (gg(-i,-j,-k) - gg(-j,-k,-i) + gg(-k,-i,-j))/2
    h = simp(h)

    return h(-i,-j,-k)
end


function get_riemann(x::TensorHead,h::S,TIT::TensorIndexType,metric::T) where {S <: Tensor, T <: Tensor}
    """
    compute Riemann curvature tensor as ``R_{ijkl}``
    """
    @indices TIT i j k l m n
    g = metric
    simp(x) = contract_metric(x,TIT.metric)
    dh = diff(h(-i,-j,-k),x(l))
    dh = simp(dh)

    hh = (TIT.metric(m,n)*h(-m,-i,-j))*h(-n,-k,-l)
    hh = simp(hh)

    Riemann = dh(-i,-l,-j,-k) - dh(-i,-k,-l,-j) + hh(-j,-k,-i,-l) - hh(-j,-l,-i,-k)
    return Riemann
end
