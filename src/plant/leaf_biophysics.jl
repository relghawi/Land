#######################################################################################################################################################################################################
#
# Changes to this structure
# General
#     2021-Aug-04: refactor the structure with constants, variables, and temporary cache
#     2021-Aug-04: add concentrations and characteristic curves altogether
#     2021-Aug-10: add CBC and PRO supoort
#     2021-Agu-10: add constructors within the structure rather than initialize it externally
#     2021-Sep-30: rename LeafBio to LeafBiophysics to be more specific
#     2021-Oct-19: sort variable to prognostic and dignostic catergories
#     2021-Oct-21: rename f_sense and K_SENES to brown and K_BROWN
#     2021-Nov-24: tease apart the characteristic absorption curves to HyperspectralAbsorption
#     2022-Jan-24: fix documentation
#     2022-Mar-01: fix documentation
#
#######################################################################################################################################################################################################
"""

$(TYPEDEF)

Struct that contains leaf biophysical traits used to run leaf reflectance and transmittance.

# Fields

$(TYPEDFIELDS)

"""
mutable struct LeafBiophysics{FT<:AbstractFloat}
    # parameters that do not change with time
    "Leaf mesophyll structural parameter that describes mesophyll reflectance and transmittance"
    MESOPHYLL_N::FT
    "Doubling adding layers"
    NDUB::Int

    # prognostic variables that change with time
    "Anthocyanin content `[μg cm⁻²]`"
    ant::FT
    "Senescent material (brown pigments) fraction `[-]`"
    brown::FT
    "Chlorophyll a and b content `[μg cm⁻²]`"
    cab::FT
    "Carotenoid content `[μg cm⁻²]`"
    car::FT
    "Carbon-based constituents in lma `[g cm⁻²]`"
    cbc::FT
    "Zeaxanthin fraction in Carotenoid (1=all Zeaxanthin, 0=all Violaxanthin) `[-]`"
    f_zeax::FT
    "Equivalent water thickness `[cm]`"
    l_H₂O::FT
    "Dry matter content (dry leaf mass per unit area) `[g cm⁻²]`"
    lma::FT
    "Protein content in lma (pro = lma - cbc) `[g cm⁻²]`"
    pro::FT

    # dignostic variables that change with time
    "Specific absorption coefficients of all materials"
    k_all::Vector{FT}
    "Fluorescence excitation matrix backwards `[-]`"
    mat_b::Matrix{FT}
    "Fluorescence excitation matrix forwards `[-]`"
    mat_f::Matrix{FT}
    "Relative absorption by Chlorophyll `[-]`"
    α_cab::Vector{FT}
    "Relative absorption by Chlorophyll+Carotenoid `[-]`"
    α_cabcar::Vector{FT}
    "Shortwave absorption, 1 .- ρ_sw .- τ_sw  `[-]`"
    α_sw::Vector{FT}
    "Broadband thermal reflectance, related to blackbody emittance `[-]`"
    ρ_lw::FT
    "Shortwave leaf reflectance `[-]`"
    ρ_sw::Vector{FT}
    "Broadband thermal transmission, related to blackbody emittance `[-]`"
    τ_lw::FT
    "Shortwave leaf transmission `[-]`"
    τ_sw::Vector{FT}
end


#######################################################################################################################################################################################################
#
# Changes to this constructor
# General
#     2021-Nov-24: migrate the constructor from CanopyLayers
#     2022-Jan-24: fix documentation
#
#######################################################################################################################################################################################################
"""

    LeafBiophysics{FT}(wls::WaveLengthSet{FT} = WaveLengthSet{FT}()) where {FT<:AbstractFloat}

Constructor for `LeafBiophysics`, given
- `wls` [`WaveLengthSet`](@ref) type structure

---
# Examples
```julia
lbio = LeafBiophysics{Float64}();
lbio = LeafBiophysics{Float64}(WaveLengthSet{Float64}(collect(400:50:2400)));
```
"""
LeafBiophysics{FT}(wls::WaveLengthSet{FT} = WaveLengthSet{FT}()) where {FT<:AbstractFloat} = (
    @unpack NΛ, NΛ_SIF, NΛ_SIFE, SΛ = wls;

    return LeafBiophysics{FT}(
                1.4,                        # MESOPHYLL_N
                10,                         # NDUB
                0,                          # ant
                0,                          # brown
                40,                         # cab
                10,                         # car
                0,                          # cbc
                0,                          # f_zeax
                0.01,                       # l_H₂O
                0.012,                      # lma
                0,                          # pro
                zeros(FT,NΛ),               # k_all
                zeros(FT,NΛ_SIF,NΛ_SIFE),   # mat_b
                zeros(FT,NΛ_SIF,NΛ_SIFE),   # mat_f
                zeros(FT,NΛ),               # α_cab
                zeros(FT,NΛ),               # α_cabcar
                zeros(FT,NΛ),               # α_sw
                0.01,                       # ρ_lw
                zeros(FT,NΛ),               # ρ_sw
                0.01,                       # τ_lw
                zeros(FT,NΛ)                # τ_sw
    )
);
