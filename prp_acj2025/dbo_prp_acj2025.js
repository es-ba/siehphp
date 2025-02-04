//UTF8:Sí

//DBO de EAH

dbo.T_desoc2=function(id,nhogar,miembro){
    return true; // ojo revisar
};
dbo.suma_t1at54b=function(id,nhogar,miembro){
    return 1;
};
dbo.p5bfamiliar=function(encues, nhogar, respond){
    if(!respond){
        return 0;
    }
    var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'P', tra_enc:encues, tra_hog:nhogar, tra_mie:respond}); // queda:mie es una dbo
    var ud_este=otras_rta[JSON.stringify(pk_este)];
    if (ud_este || ud_este!=undefined){
        return ud_este.var_p5b;
    }else{
        return 0;
    }
};    
dbo.edadfamiliar=function(encues, nhogar, respond){
    if(!respond){
        return 0;
    }
    var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'P', tra_enc:encues, tra_hog:nhogar, tra_mie:respond}); // queda:mie es una dbo
    var ud_este=otras_rta[JSON.stringify(pk_este)];
    if (ud_este || ud_este!=undefined){
        return ud_este.var_edad;
    }else{
        return 0;
    }
};
dbo.existemiembro=function(encues, nhogar, P6_a){
    if(!P6_a){
        return 0;
    }   
    var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'P', tra_enc:encues, tra_hog:nhogar, tra_mie:P6_a}); // queda:mie es una dbo
    var ud_este=otras_rta[JSON.stringify(pk_este)];
    if (ud_este || ud_este!=undefined){
        return 1;
    }else{
        return 0;
    }
};
dbo.existejefe=function(encues, nhogar){
    var nro_mie = 1;
    var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'P', tra_enc:encues, tra_hog:nhogar, tra_mie:nro_mie});
    var ud_este = otras_rta[JSON.stringify(pk_este)];
    while(ud_este || ud_este!=undefined){
        if(ud_este.var_p4==1){
            return 1;
        }
        nro_mie++;
        pk_este = pk_este=cambiandole(pk_ud, {tra_for:'S1', tra_mat:'P', tra_enc:encues, tra_hog:nhogar, tra_mie:nro_mie});
        ud_este = otras_rta[JSON.stringify(pk_este)];
    }
    return 0;
};
dbo.edadjefe=function(encues, nhogar){
    var nro_mie=1; // queda:mie es una dbo
    var ud_este;
    var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'P', tra_enc:encues, tra_hog:nhogar, tra_mie:nro_mie}); // queda:mie es una dbo
    ud_este=otras_rta[JSON.stringify(pk_este)];
    while (ud_este || ud_este!=undefined){
        if (ud_este.var_p4==1){
            return ud_este.var_edad;    // queda:mie es una dbo
        }
        nro_mie++;
        pk_este=cambiandole(pk_este,{tra_mie:nro_mie}); // queda:mie es una dbo
        ud_este=otras_rta[JSON.stringify(pk_este)];
    }
    return 0;
};
dbo.existeindividual=function(encues, nhogar, nmiembro){ // ojo no busca en I1 ?
    if(!nmiembro){
        return 0;
    }
    var pk_este=cambiandole(pk_ud,{tra_for:'I1', tra_mat:'', tra_enc:encues, tra_hog:nhogar, tra_mie:nmiembro});
    ud_este=otras_rta[JSON.stringify(pk_este)];
    if (ud_este || ud_este!=undefined){
        return 1;
    }else{
        return 0;
    }        
};
dbo.sumah3=function(encues){
    var nhogar = 1;
    var ud_este;
    var rta=0;
    var pk_este=cambiandole(pk_ud,{tra_for:'A1', tra_mat:'', tra_enc:encues, tra_hog:nhogar, tra_mie:0});
    ud_este=otras_rta[JSON.stringify(pk_este)];
    while (ud_este || ud_este!=undefined){
        if (!dbo.nsnc(ud_este.var_h3) && !isNaN(ud_este.var_h3) && ud_este.var_h3>0){
            rta=rta + ud_este.var_h3;
        }
        nhogar++;
        var pk_este=cambiandole(pk_ud,{tra_for:'A1', tra_mat:'', tra_enc:encues, tra_hog:nhogar, tra_mie:0});
        ud_este=otras_rta[JSON.stringify(pk_este)];
    }
    return rta;       
};
dbo.anionac=function(encues, nhogar, nmiembro){
    if(!nmiembro){
        return 0;
    }
    var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'P', tra_enc:encues, tra_hog:nhogar, tra_mie:nmiembro}); // queda:mie es una dbo
    var ud_este=otras_rta[JSON.stringify(pk_este)];
    if (ud_este || ud_este!=undefined){
        if("CON FECHA PARTIDA"){
            return ud_este.var_f_nac_a;
        }else{
            var fecha=new Array();
            fecha = dbo.texto_a_fecha(ud_este.var_f_nac_o);
            var anio = parseInt(fecha[2],10);
            if(anio){
                return anio;
            }else{
                return 0;
            }
        }
    }else{
        return 0;
    }
};
dbo.sexofamiliar=function(encues, nhogar, P6_a){
    if(!P6_a){
        return 0;
    }
    var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'P', tra_enc:encues, tra_hog:nhogar, tra_mie:P6_a}); // queda:mie es una dbo
    var ud_este=otras_rta[JSON.stringify(pk_este)];
    if (ud_este || ud_este!=undefined){
        return ud_este.var_sexo;
    }else{
        return 0;
    }
};
dbo.nrojefes=function(encues,nhogar){
    var nro_mie=1;
    var rta = 0;
    var pk_este=cambiandole(pk_ud, {tra_for:'S1', tra_mat:'P', tra_enc:encues, tra_hog:nhogar, tra_mie:nro_mie});
    var ud_este = otras_rta[JSON.stringify(pk_este)];
    while (ud_este || ud_este!=undefined){
        if(ud_este.var_p4==1){
            rta++;
        }
        nro_mie++;
        pk_este = pk_este=cambiandole(pk_ud, {tra_for:'S1', tra_mat:'P', tra_enc:encues, tra_hog:nhogar, tra_mie:nro_mie});
        ud_este = otras_rta[JSON.stringify(pk_este)];
    }
    return rta;
};
dbo.nroconyuges=function(encues, nhogar){
    var nro_mie=1; // queda:mie es una dbo
    var ud_este;
    var rta=0;
    var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'P', tra_enc:encues, tra_hog:nhogar, tra_mie:nro_mie}); // queda:mie es una dbo
    ud_este=otras_rta[JSON.stringify(pk_este)];
    while (ud_este || ud_este!=undefined){
        if (ud_este.var_p4==2){
            rta++;    // queda:mie es una dbo
        }
        nro_mie++;
        var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'P', tra_enc:encues, tra_hog:nhogar, tra_mie:nro_mie}); // queda:mie es una dbo
        ud_este=otras_rta[JSON.stringify(pk_este)];
    }
    return rta;
};
dbo.edad_a_la_fecha=function(f_nac_o, f_realiz_o){
    var fecha_nacimiento=new Array();
    if(f_nac_o==null){
        return null;
    }
    fecha_nacimiento=dbo.texto_a_fecha(f_nac_o);
    var ud_este;
    if(!f_realiz_o){
        var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'', tra_mie:0}); 
        ud_este=otras_rta[JSON.stringify(pk_este)];
        f_realiz_o = ud_este.var_f_realiz_o;
    }
    if(f_realiz_o==null){
        return null;
    }
    var fecha_realizacion=new Array();
    fecha_realizacion=dbo.texto_a_fecha(f_realiz_o);
    if(fecha_nacimiento==null||fecha_realizacion==null){
        return null;
    }
    var   dia_nac  =  parseInt(fecha_nacimiento[0],10);
    var   mes_nac  =  parseInt(fecha_nacimiento[1],10);
    var  annio_nac =  parseInt(fecha_nacimiento[2],10);
    var   dia_rea  =  parseInt(fecha_realizacion[0],10);
    var   mes_rea  =  parseInt(fecha_realizacion[1],10);
    var annio_rea  =  parseInt(fecha_realizacion[2],10);
    var rta=0;        
    rta=annio_rea-annio_nac;
    if(rta<0){
        return rta;
    }
    if(mes_rea<mes_nac){
        rta=rta-1;
    }else if(mes_rea==mes_nac){
        if(dia_rea<dia_nac){
            rta=rta-1;
        }
    }
    return rta;
}; 
dbo.sexojefe=function(p_enc, p_hog){
    var nro_mie=1; // queda:mie es una dbo
    var ud_este;
    var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'P', tra_enc:p_enc, tra_hog:p_hog, tra_mie:nro_mie}); // queda:mie es una dbo
    ud_este=otras_rta[JSON.stringify(pk_este)];
    while (ud_este || ud_este!=undefined){
        if (ud_este.var_p4==1){
            return ud_este.var_sexo;    // queda:mie es una dbo
        }
        nro_mie++;
        pk_este=cambiandole(pk_este,{tra_mie:nro_mie}); // queda:mie es una dbo
        ud_este=otras_rta[JSON.stringify(pk_este)];
    }
    return 0;
};
dbo.total_hogares=function(p_enc){
    var nro_hog=1; 
    var ud_este;
    var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'', tra_enc:p_enc, tra_hog:nro_hog}); 
    ud_este=otras_rta[JSON.stringify(pk_este)];
    while (ud_este || ud_este!=undefined){
        nro_hog++;
        pk_este=cambiandole(pk_este,{tra_hog:nro_hog});
        ud_este=otras_rta[JSON.stringify(pk_este)];
    }
    return nro_hog-1;  
};
dbo.cantex=function(p_enc, p_hog){
    var nro_exm=1; 
    var ud_este;
    var pk_este=cambiandole(pk_ud,{tra_for:'A1', tra_mat:'X', tra_enc:p_enc, tra_hog:p_hog, tra_mie:0, tra_exm:nro_exm}); 
    ud_este=otras_rta[JSON.stringify(pk_este)];
    while (ud_este || ud_este!=undefined){
        nro_exm++;
        pk_este=cambiandole(pk_este,{tra_exm:nro_exm});
        ud_este=otras_rta[JSON.stringify(pk_este)];
    }
    return nro_exm-1;  
};
dbo.cant_menores=function(encues,nhogar,nedad){
    var cant_menores=0;
    var nro_mie=1;
    var ud_este;
    var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'P', tra_enc:encues, tra_hog:nhogar, tra_mie:nro_mie}); 
    ud_este=otras_rta[JSON.stringify(pk_este)];
    while(ud_este || ud_este!=undefined){
        if(ud_este.var_edad<nedad){
            cant_menores++;    
        }
        nro_mie++;
        pk_este=cambiandole(pk_este,{tra_mie:nro_mie}); 
        ud_este=otras_rta[JSON.stringify(pk_este)];
    }
    return cant_menores;
};
dbo.cant_registros_exm=function(p_enc, p_hog){
        var nro_exm=1; 
        var ud_este;
        var cant_ex_mie=0;
        var pk_este=cambiandole(pk_ud,{tra_for:'A1', tra_mat:'X', tra_enc:p_enc, tra_hog:p_hog, tra_mie:0, tra_exm:nro_exm}); 
        ud_este=otras_rta[JSON.stringify(pk_este)];
        while (ud_este || ud_este!=undefined){
            var hay_dato=false;     
            for(var campo in ud_este){
                if (campo!==null){
                    hay_dato=true;
                }
            }            
            if (hay_dato){
                cant_ex_mie++;                
            }
            nro_exm++;
            pk_este=cambiandole(pk_este,{tra_exm:nro_exm});
            ud_este=otras_rta[JSON.stringify(pk_este)];
        }
        return cant_ex_mie;        
};

dbo.estadofamiliar=function(encues, nhogar, respond){
    if(!respond){
        return 0;
    }
    var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'P', tra_enc:encues, tra_hog:nhogar, tra_mie:respond}); // queda:mie es una dbo
    var ud_este=otras_rta[JSON.stringify(pk_este)];
    if (ud_este || ud_este!=undefined){
        return ud_este.var_p5;
    }else{
        return 0;
    }
};
dbo.estadojefe=function(encues,nhogar){
    var nro_mie=1;
    var ud_este;
    var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'P', tra_enc:encues, tra_hog:nhogar, tra_mie:nro_mie}); // queda:mie es una dbo
    ud_este=otras_rta[JSON.stringify(pk_este)];
    while(ud_este || ud_este!=undefined){
        if(ud_este.var_p4==1){
            return ud_este.var_p5;    // queda:mie es una dbo
        }
        nro_mie++;
        pk_este=cambiandole(pk_este,{tra_mie:nro_mie}); // queda:mie es una dbo
        ud_este=otras_rta[JSON.stringify(pk_este)];
    }
    return 0;
};
dbo.cant_hog_norea_con_motivo=function(p_enc){
    var nro_hog=1; 
    var ud_este;
    var cant_hog_nr_m=0;
    var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'', tra_enc:p_enc, tra_hog:nro_hog}); 
    ud_este=otras_rta[JSON.stringify(pk_este)];
        while (ud_este || ud_este!=undefined){
           if(ud_este.var_entrea==2 && ud_este.var_razon1 !==null ){  
              cant_hog_nr_m++;
           }   
              nro_hog++;
              pk_este=cambiandole(pk_este,{tra_hog:nro_hog});
              ud_este=otras_rta[JSON.stringify(pk_este)];
           
        }
    return cant_hog_nr_m;  
};
dbo.cant_s1p_x_hog=function(p_enc, p_hog){
        var ud_este;
        var cant=0;        
        var nro_mie=1;
        var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'P', tra_enc:p_enc, tra_hog:p_hog, tra_mie:nro_mie}); 
        ud_este=otras_rta[JSON.stringify(pk_este)];
        while (ud_este || ud_este!=undefined){
            cant++;                
            nro_mie++;
            pk_este=cambiandole(pk_este,{tra_mie:nro_mie});
            ud_este=otras_rta[JSON.stringify(pk_este)];
        }
        return cant;        
};
dbo.cant_i1_x_hog=function(p_enc, p_hog){
        var ud_este;
        var cant=0;        
        var nro_mie=1;
        var pk_este=cambiandole(pk_ud,{tra_for:'I1', tra_mat:'', tra_enc:p_enc, tra_hog:p_hog, tra_mie:nro_mie}); 
        ud_este=otras_rta[JSON.stringify(pk_este)];
        while (ud_este || ud_este!=undefined){
            cant++;                
            nro_mie++;
            pk_este=cambiandole(pk_este,{tra_mie:nro_mie});
            ud_este=otras_rta[JSON.stringify(pk_este)];
        }
        return cant;        
};
dbo.max_hog_ingresado=function(p_enc){
    var max_hog=0;    
    for(var json_pk_ud_actual in JSON.parse(localStorage.getItem("claves_de_"+p_enc))){
        var pk_ud_actual=JSON.parse(json_pk_ud_actual);
        if(pk_ud_actual.tra_for=='S1' && pk_ud_actual.tra_mat=='' && pk_ud_actual.tra_ope==operativo_actual){ // OJO GENERALIZAR
            if(max_hog<pk_ud_actual.tra_hog){
                max_hog=pk_ud_actual.tra_hog;
            }
        }    
    }
    return max_hog;
};
dbo.meshort53bis=function(encues, nhogar, nmiembro){ // pensado en la pk actual que corresponde a I1
    //sobre pk_ud_actual
    var mesh=0; 
    if (!(pk_ud.tra_enc==encues && pk_ud.tra_hog==nhogar && pk_ud.tra_mie==nmiembro)){
        return null;
    }
    if ( evaluar_en_encuestas(
            '(i1=1 or i4=1 or informado(i10)) and t53_bis1<0 or t53_bis2<0 or (t53_bis1=1 or t53_bis1=2) and t53_bis1_sem<0 or t53_bis1=3 and t53_bis1_mes<0'
            , true)){
        mesh= -9;
    }else if(evaluar_en_encuestas('(not informado(t28) and not informado(t30)) or t45=3 or i1=2 and i4<>1', true)){
        mesh= 0;
    }else if(evaluar_en_encuestas('(t53_bis1=1 or t53_bis1=2 or t53_bis1<0) and t53_bis1_sem>0 and t53_bis2>0',true)){
        mesh=evaluar_en_encuestas('t53_bis1_sem*t53_bis2*4.3');
    }else if(evaluar_en_encuestas('(t53_bis1=3 or t53_bis1<0) and t53_bis1_mes>0 and t53_bis2>0',true)){
        mesh=evaluar_en_encuestas('t53_bis1_mes*t53_bis2',true); 
    }else{
        mesh=null;
    };
    return mesh;
};
dbo.inghort53bis=function(encues, nhogar, nmiembro){ 
    //sobre pk_ud_actual que corresponde a I1
    if (!(pk_ud.tra_enc==encues && pk_ud.tra_hog==nhogar && pk_ud.tra_mie==nmiembro)){
        return null;
    }
    var ingh=0;
    var v_meshort=dbo.meshort53bis(encues, nhogar, nmiembro); 
    if (nulo_a_neutro(v_meshort)<0 || nulo_a_neutro(rta_ud.var_i7a)<0 || nulo_a_neutro(rta_ud.var_i11)<0 ||
        nulo_a_neutro(rta_ud.var_i12)<0 || nulo_a_neutro(rta_ud.var_i13)<0 || nulo_a_neutro(rta_ud.var_i14)<0){
        ingh= -9;
    }else if(v_meshort>0 && rta_ud.var_i7a>0){
        ingh= parseInt(rta_ud.var_i7a/v_meshort);
    }else if(v_meshort>0 && rta_ud.var_i14>0){
        ingh=parseInt(rta_ud.var_i14/v_meshort);
    }else if(v_meshort>0 && rta_ud.var_i11==1 && rta_ud.var_i12 >0&& rta_ud.var_i13>0){
        ingh=parseInt((rta_ud.var_i12+ rta_ud.var_i13)/v_meshort);
    }else if(v_meshort>0 && rta_ud.var_i11==2 && rta_ud.var_i13>0){
        ingh=parseInt(rta_ud.var_i13/v_meshort); 
    }else{
        ingh=null;
    };
    return ingh;
};
dbo.suma_auh_i3_13a_hog=function(p_enc,p_hog){
    var ud_este;
    var ss=0;
    var suma=0;        
    for(var json_pk_ud_actual in JSON.parse(localStorage.getItem("claves_de_"+p_enc))){
        var pk_ud_actual=JSON.parse(json_pk_ud_actual);
        if(pk_ud_actual.tra_hog==p_hog && pk_ud_actual.tra_for=='I1' && pk_ud_actual.tra_mat=='' && pk_ud_actual.tra_ope==operativo_actual){
            ud_este=otras_rta[JSON.stringify(pk_ud_actual)];
            ss=0;
            if(ud_este.var_i3_13==1){
                if(ud_este.var_i3_13a>=0){
                    ss=ud_este.var_i3_13a;
                }else if(ud_este.var_i3_13a<0){
                    ss=1;                
                }else{
                    ss=0;
                }
            }
            suma=suma +ss;
        }    
    }
    return suma;      
};
//agregada para la consistencia f_realiz_o de relevamiento 1.
dbo.largo_cadena=function(cvalor){ 
    return cvalor.length; 
};
dbo.sin_dato_horario_tel=function(p_horario){
    return (p_horario == null || p_horario.indexOf('true')==-1);
};
dbo.sitconyjefe=function(encues,nhogar){ //a apartir de eah2019 se renombra estadojefe poe sitconyjefe
    var nro_mie=1;
    var ud_este;
    var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'P', tra_enc:encues, tra_hog:nhogar, tra_mie:nro_mie}); // queda:mie es una dbo
    ud_este=otras_rta[JSON.stringify(pk_este)];
    while(ud_este || ud_este!=undefined){
        if(ud_este.var_p4==1){
            return ud_este.var_p5;    // queda:mie es una dbo
        }
        nro_mie++;
        pk_este=cambiandole(pk_este,{tra_mie:nro_mie}); // queda:mie es una dbo
        ud_este=otras_rta[JSON.stringify(pk_este)];
    }
    return 0;
};

