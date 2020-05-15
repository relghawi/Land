# this function is meant to obtain the Anet-Ci curve
# this function may also be used to test the phtosynthesis module
function get_a_pi_curve(;
                        v25::FT = FT(80.0),
                        j25::FT = FT(135.0),
                     Γ_star::FT = FT(2.5),
                        tem::FT = FT(298.15),
                        par::FT = FT(1200.0),
                       p_O₂::FT = FT(21278.25),
                        r25::FT = FT(Inf)) where {FT}
    # generate a list of p_i from gamma to 200 Pa
    list_pi = [val for val in Γ_star:1.0:200.0]
    list_ag = list_pi * -Inf
    list_an = list_pi * -Inf

    # iterate through the list
    for i in 1:length(list_pi)
        p_i        = list_pi[i]
        a_n,a_g,r  = get_leaf_an_ag_r_from_pi(
                                              v25 = v25,
                                              j25 = j25,
                                           Γ_star = Γ_star,
                                              p_i = p_i,
                                              tem = tem,
                                              par = par,
                                             p_O₂ = p_O₂,
                                              r25 = r25)
        list_ag[i] = a_g
        list_an[i] = a_n
    end

    # return the arrays
    return list_pi,list_an,list_ag
end
