#######################################################################################################################################################################################################
#
# Changes to this type
# General
#     2022-Jun-02: add abstract type for LIDF algorithms
#
#######################################################################################################################################################################################################
"""

$(TYPEDEF)

Hierarchy of AbstractLIDFAlgorithm:
- [`VerhoefLIDF`](@ref)

"""
abstract type AbstractLIDFAlgorithm{FT<:AbstractFloat} end


#######################################################################################################################################################################################################
#
# Changes to this structure
# General
#     2022-Jun-02: migrate from CanopyLayers
#     2022-Jun-02: rename Canopy4RT to HyperspectralMLCanopy
#     2022-Jun-02: abstractize LIDF as a field
#     2022-Jul-20: use kwdef for the constructor
#
#######################################################################################################################################################################################################
"""

$(TYPEDEF)

Structure for Verhoef LIDF algorithm

# Fields

$(TYPEDFIELDS)

"""
Base.@kwdef mutable struct VerhoefLIDF{FT<:AbstractFloat} <: AbstractLIDFAlgorithm{FT}
    # parameters that do not change with time
    "Leaf inclination angle distribution function parameter a"
    A::FT = 0
    "Leaf inclination angle distribution function parameter b"
    B::FT = 0
end


#######################################################################################################################################################################################################
#
# Changes to this type
# General
#     2022-Jun-02: add abstract type for canopy structure
#
#######################################################################################################################################################################################################
"""

$(TYPEDEF)

Hierarchy of AbstractCanopy:
- [`BroadbandSLCanopy`](@ref)
- [`HyperspectralMLCanopy`](@ref)

"""
abstract type AbstractCanopy{FT<:AbstractFloat} end


#######################################################################################################################################################################################################
#
# Changes to this structure
# General
#     2022-Jun-15: add struct for broadband radiative transfer scheme such as two leaf model
#     2022-Jun-15: add more cache variables
#     2022-Jun-15: add radiation profile
#     2022-Jun-15: remove RATIO_HV to compute the coefficient numerically
#     2022-Jun-16: remove some cache variables
#     2022-Jun-16: add fields: Θ_INCL_BNDS
#     2022-Jul-20: use kwdef for the constructor
#
#######################################################################################################################################################################################################
"""

$(TYPEDEF)

Structure to save single layer broadband canopy parameters

# Fields

$(TYPEDFIELDS)

"""
Base.@kwdef mutable struct BroadbandSLCanopy{FT<:AbstractFloat} <: AbstractCanopy{FT}
    # dimensions
    "Dimension of inclination angles"
    DIM_INCL::Int = 9

    # parameters that do not change with time
    "Leaf inclination angle distribution function algorithm"
    LIDF::Union{VerhoefLIDF{FT}} = VerhoefLIDF{FT}()
    "Inclination angle distribution"
    P_INCL::Vector{FT} = ones(FT, DIM_INCL) ./ DIM_INCL
    "Canopy radiation profiles"
    RADIATION::BroadbandSLCanopyRadiationProfile{FT} = BroadbandSLCanopyRadiationProfile{FT}(DIM_INCL = DIM_INCL)
    "Mean inclination angles `[°]`"
    Θ_INCL::Vector{FT} = collect(FT, range(start=0, stop=90, length=DIM_INCL+1))[1:end-1] .+ 90 / DIM_INCL / 2
    "Bounds of inclination angles `[°]`"
    Θ_INCL_BNDS::Matrix{FT} = FT[ collect(FT, range(start=0, stop=90, length=DIM_INCL+1))[1:end-1] collect(FT, range(start=0, stop=90, length=DIM_INCL+1))[2:end] ]

    # prognostic variables that change with time
    "Clumping index"
    ci::FT = 1
    "Leaf area index"
    lai::FT = 3
end


#######################################################################################################################################################################################################
#
# Changes to this structure
# General
#     2022-Jun-02: migrate from CanopyLayers
#     2022-Jun-02: rename Canopy4RT to HyperspectralMLCanopy
#     2022-Jun-02: abstractize LIDF as a field
#     2022-Jun-07: add cache variable _1_AZI, _COS²_Θ_INCL, _COS_Θ_INCL_AZI, _COS²_Θ_INCL_AZI
#     2022-Jun-07: remove cache variable _cos_θ_azi_raa, _vol_scatter
#     2022-Jun-09: add new field: APAR_CAR, RADIATION, WLSET
#     2022-Jun-13: use Union instead of Abstract... for type definition
#     2022-Jun-15: rename to HyperspectralMLCanopyOpticalProperty and HyperspectralMLCanopyRadiationProfile
#     2022-Jun-16: remove some cache variables
#     2022-Jul-20: use kwdef for the constructor
#
#######################################################################################################################################################################################################
"""

$(TYPEDEF)

Structure to save multiple layer hyperspectral canopy parameters

# Fields

$(TYPEDFIELDS)

"""
Base.@kwdef mutable struct HyperspectralMLCanopy{FT<:AbstractFloat} <: AbstractCanopy{FT}
    # dimensions
    "Dimension of azimuth angles"
    DIM_AZI::Int = 36
    "Dimension of inclination angles"
    DIM_INCL::Int = 9
    "Dimension of canopy layers"
    DIM_LAYER::Int = 20

    # parameters that do not change with time
    "Whether Carotenoid absorption is accounted for in APAR"
    APAR_CAR::Bool = true
    "Hot spot parameter"
    HOT_SPOT::FT = 0.05
    "Leaf inclination angle distribution function algorithm"
    LIDF::Union{VerhoefLIDF{FT}} = VerhoefLIDF{FT}()
    "Canopy optical properties"
    OPTICS::HyperspectralMLCanopyOpticalProperty{FT} = HyperspectralMLCanopyOpticalProperty{FT}()
    "Inclination angle distribution"
    P_INCL::Vector{FT} = ones(FT, DIM_INCL) ./ DIM_INCL
    "Canopy radiation profiles"
    RADIATION::HyperspectralMLCanopyRadiationProfile{FT} = HyperspectralMLCanopyRadiationProfile{FT}()
    "Wave length set used to paramertize other variables"
    WLSET::WaveLengthSet{FT} = WaveLengthSet{FT}()
    "Clumping structure a"
    Ω_A::FT = 1
    "Clumping structure b"
    Ω_B::FT = 0
    "Mean azimuth angles `[°]`"
    Θ_AZI::Vector{FT} = collect(FT, range(start=0, stop=360, length=DIM_AZI+1))[1:end-1] .+ 360 / DIM_AZI / 2
    "Mean inclination angles `[°]`"
    Θ_INCL::Vector{FT} = collect(FT, range(start=0, stop=90, length=DIM_INCL+1))[1:end-1] .+ 90 / DIM_INCL / 2
    "Bounds of inclination angles `[°]`"
    Θ_INCL_BNDS::Matrix{FT} = FT[ collect(FT, range(start=0, stop=90, length=DIM_INCL+1))[1:end-1] collect(FT, range(start=0, stop=90, length=DIM_INCL+1))[2:end] ]

    # prognostic variables that change with time
    "Clumping index"
    ci::FT = 1
    "Leaf area index"
    lai::FT = 3

    # caches to speed up calculations
    "Ones with the length of Θ_AZI"
    _1_AZI::Vector{FT} = ones(FT, DIM_AZI)
    "Cosine of Θ_AZI"
    _COS_Θ_AZI::Vector{FT} = cosd.(Θ_AZI)
    "Square of cosine of Θ_INCL"
    _COS²_Θ_INCL::Vector{FT} = cosd.(Θ_INCL) .^ 2
    "Square of cosine of Θ_INCL at different azimuth angles"
    _COS²_Θ_INCL_AZI::Matrix{FT} = (cosd.(Θ_INCL) .^ 2) * _1_AZI'
    "Cache for level boundary locations"
    _x_bnds::Vector{FT} = collect(FT, range(start=0, stop=-1, length=DIM_LAYER+1))
end
