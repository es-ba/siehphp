select i.pla_enc as id, i.pla_hog as nhogar, i.pla_mie as miembro, pla_edad, pla_sexo, pla_cond_activ, pla_tipodes, pla_categdes, pla_categori, 
   comun.buscar_reemplazar_espacios_raros(pla_t23) as pla_t23, 
   comun.buscar_reemplazar_espacios_raros(pla_t24) as pla_t24, 
   comun.buscar_reemplazar_espacios_raros(pla_t25) as pla_t25, 
   comun.buscar_reemplazar_espacios_raros(pla_t26) as pla_t26, 
   comun.buscar_reemplazar_espacios_raros(pla_t37) as pla_t37, pla_t37sd, pla_t38, pla_t40, 
   comun.buscar_reemplazar_espacios_raros(pla_t41) as pla_t41, 
   comun.buscar_reemplazar_espacios_raros(pla_t42) as pla_t42, 
   comun.buscar_reemplazar_espacios_raros(pla_t43) as pla_t43 
    from encu.plana_i1_ i 
     inner join encu.plana_s1_p p on  i.pla_enc=p.pla_enc and i.pla_hog=p.pla_hog and i.pla_mie=p.pla_mie and i.pla_exm=p.pla_exm 
     inner join encu.plana_tem_ t on i.pla_enc=t.pla_enc
   where t.pla_estado > 69 and pla_cond_activ <3;