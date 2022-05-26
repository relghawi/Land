module PlantHydraulics

using ClimaCache: ComplexVC, Leaf, LeafHydraulics, LinearPVCurve, LogisticVC, MonoElementSPAC, MonoGrassSPAC, MonoPalmSPAC, MonoTreeSPAC, PowerVC, RootHydraulics, SegmentedPVCurve, StemHydraulics,
      WeibullVC
using DocStringExtensions: METHODLIST
using PkgUtility: GAS_R
using UnPack: @unpack

import SoilHydraulics: relative_hydraulic_conductance


# export public types from ClimaCache
export ComplexVC, LeafHydraulics, LinearPVCurve, LogisticVC, MonoElementSPAC, MonoGrassSPAC, MonoPalmSPAC, MonoTreeSPAC, PowerVC, RootHydraulics, SegmentedPVCurve, StemHydraulics, WeibullVC

# export public functions
export clear_legacy!, critical_pressure, relative_hydraulic_conductance, xylem_pressure


# include functions
include("critical_pressure.jl")
include("legacy.jl"           )
include("pressure_volume.jl"  )
include("vulnerability.jl"    )

# include old module
include("old/PlantHydraulicsOld.jl")


end # module
