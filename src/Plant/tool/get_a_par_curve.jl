# this function is meant to obtain the Anet-PAR curve
# this function may also be used to test the phtosynthesis module
function get_a_par_curve(;
                         v25::FT = FT(80.0),
                         j25::FT = FT(135.0),
                      Γ_star::FT = FT(2.5),
                         gsc::FT = FT(0.1),
                         p_a::FT = FT(40.0),
                         tem::FT = FT(298.15),
                       p_atm::FT = FT(101325.0),
                        p_O₂::FT = FT(21278.25),
                         r25::FT = FT(Inf)) where {FT}
    # generate a list of p_i from gamma to 200 Pa
    list_par = [val for val in 5.0:5.0:2000.0]
    list_ag  = list_par * -Inf
    list_an  = list_par * -Inf
    list_pi  = list_par * -Inf

    # iterate through the list
    for i in 1:length(list_par)
        par         = list_par[i]
        an,ag,r,p_i = get_leaf_an_ag_r_pi_from_gsc(
                                                   v25 = v25,
                                                   j25 = j25,
                                                Γ_star = Γ_star,
                                                   gsc = gsc,
                                                   p_a = p_a,
                                                   tem = tem,
                                                   par = par,
                                                 p_atm = p_atm,
                                                  p_O₂ = p_O₂,
                                                   r25 = r25)
        list_ag[i]  = ag
        list_an[i]  = an
        list_pi[i]  = p_i
    end

    # return the arrays
    return list_par,list_an,list_ag,list_pi
end
