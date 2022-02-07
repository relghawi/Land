#######################################################################################################################################################################################################
#
# Changes to this function
# General
#     2022-Jan-14: refactor the function rubisco_limited_rate!
#
#######################################################################################################################################################################################################
"""
This function updates the RubisCO limited photosynthetic rate. Supported methods are

$(METHODLIST)

"""
function rubisco_limited_rate! end


#######################################################################################################################################################################################################
#
# Changes to this method
# General
#     2022-Jan-14: add input variable p_i to make the code more modular
#     2022-Jan-24: fix documentation
#
#######################################################################################################################################################################################################
"""

    rubisco_limited_rate!(psm::C3VJPModel{FT}, p_i::FT) where {FT<:AbstractFloat}

Update the RubisCO limited photosynthetic rate, given
- `psm` `C3VJPModel` structure for C3 photosynthesis model
- `p_i` Internal CO₂ partial pressure in `Pa`
"""
rubisco_limited_rate!(psm::C3VJPModel{FT}, p_i::FT) where {FT<:AbstractFloat} = (
    psm.a_c = psm.v_cmax * (p_i - psm.γ_star) / (p_i + psm.k_m);

    return nothing
);


#######################################################################################################################################################################################################
#
# Changes to this method
# General
#     2022-Feb-07: add method for C3CytochromeModel (as well as j_p680 and j_p700)
#
#######################################################################################################################################################################################################
"""

    rubisco_limited_rate!(psm::C3CytochromeModel{FT}, p_i::FT) where {FT<:AbstractFloat}

Update the RubisCO limited photosynthetic rate, given
- `psm` `C3CytochromeModel` structure for C3 photosynthesis model
- `p_i` Internal CO₂ partial pressure in `Pa`
"""
rubisco_limited_rate!(psm::C3CytochromeModel{FT}, p_i::FT) where {FT<:AbstractFloat} = (
    @unpack EFF_1, EFF_2 = psm;

    psm.a_c      = psm.v_cmax * (p_i - psm.γ_star) / (p_i + psm.k_m);
    psm.j_p680_c = psm.a_c * (EFF_1*p_i + EFF_2*psm.γ_star) / (p_i - psm.γ_star);
    psm.j_p700_c = psm.j_p680_c * psm.η;

    return nothing
);


#######################################################################################################################################################################################################
#
# Changes to this method
# General
#     2022-Jan-14: add input variable p_i to make the code more modular
#     2022-Jan-24: fix documentation
#
#######################################################################################################################################################################################################
"""

    rubisco_limited_rate!(psm::C4VJPModel{FT}, p_i::FT) where {FT<:AbstractFloat}

Update the RubisCO limited photosynthetic rate, given
- `psm` `C4VJPModel` structure for C3 photosynthesis model
- `p_i` Internal CO₂ partial pressure in `Pa`, not used in this method
"""
rubisco_limited_rate!(psm::C4VJPModel{FT}, p_i::FT) where {FT<:AbstractFloat} = (
    psm.a_c = psm.v_cmax;

    return nothing
);


#######################################################################################################################################################################################################
#
# Changes to this method
# General
#     2022-Jan-14: add input variable g_lc to make the code more modular
#     2022-Jan-24: fix documentation
# Bug fixes
#     2022-Jan-24: use v_cmax rather than v_max
#
#######################################################################################################################################################################################################
"""

    rubisco_limited_rate!(psm::C3VJPModel{FT}, air::AirLayer{FT}, g_lc::FT) where {FT<:AbstractFloat}

Update the RubisCO limited photosynthetic rate in conductance mode, given
- `psm` `C3VJPModel` structure for C3 photosynthesis model
- `air` `AirLayer` structure for environmental conditions like O₂ partial pressure
- `g_lc` Leaf diffusive conductance to CO₂ in `[mol m⁻² s⁻¹]`
"""
rubisco_limited_rate!(psm::C3VJPModel{FT}, air::AirLayer{FT}, g_lc::FT) where {FT<:AbstractFloat} = (
    _a = psm.v_cmax;
    _b = psm.v_cmax * psm.γ_star;
    _d = psm.k_m;
    _f = air.P_AIR / g_lc * FT(1e-6);
    _p = air.p_CO₂;
    _r = psm.r_d;

    _qa = _f;
    _qb = _f*_r - _p - _d - _a*_f;
    _qc = _a*_p - _b - _r*(_p + _d);
    _an = lower_quadratic(_qa, _qb, _qc);

    psm.a_c = _an + _r;

    return nothing
);


#######################################################################################################################################################################################################
#
# Changes to this method
# General
#     2022-Jan-14: add this new method to simplify the multiple dispatch of leaf_photosynthesis!
#     2022-Jan-24: fix documentation
#
#######################################################################################################################################################################################################
"""

    rubisco_limited_rate!(psm::C4VJPModel{FT}, air::AirLayer{FT}, g_lc::FT) where {FT<:AbstractFloat}

Update the RubisCO limited photosynthetic rate in conductance mode, given
- `psm` `C4VJPModel` structure for C3 photosynthesis model
- `air` `AirLayer` structure for environmental conditions like O₂ partial pressure, not used in the method
- `g_lc` Leaf diffusive conductance to CO₂ in `[mol m⁻² s⁻¹]`, not used in this methid
"""
rubisco_limited_rate!(psm::C4VJPModel{FT}, air::AirLayer{FT}, g_lc::FT) where {FT<:AbstractFloat} = (
    psm.a_c = psm.v_cmax;

    return nothing
);
