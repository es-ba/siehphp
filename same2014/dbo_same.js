var dbo={
    anio:function(){
        return '2014';//generalizar
    },
	T_desoc2:function(id,nhogar,miembro){
		return true;
	}, 
	textoinformado:function(valor){
		return !!valor?1:0;
	},
	es_fecha_con_anio:function(str_fecha){
        return dbo.es_fecha(str_fecha,true);
	},
    es_fecha_sin_anio:function(str_fecha){
        return dbo.es_fecha(str_fecha,false);
    },
    es_fecha:function(str_fecha){
        var partes=new Array();
        str_fecha=str_fecha.toString();
        str_fecha=str_fecha.replace("-","/");
        partes=str_fecha.split("/");
        if (partes.length<2||partes.length>3){
            return null;
        }else if(partes.length==2){
            partes[2]=dbo.anio();
        }else{
            if(partes[2].length==3||partes[2].length>4){
                return null;
            }else if(partes[2].length==2){
                if(partes[2]>12){
                    partes[2]='19'+partes[2];
                }else{
                    partes[2]='20'+partes[2];
                }
            }else if(partes[2].length==1){
                    partes[2]='200'+partes[2];
            }
        }
        var fecha = partes[0]+"/"+partes[1]+"/"+partes[2];
        return dbo.esFechaValida(partes[0],partes[1],partes[2]);        
    },
	suma_t1at54b:function(id,nhogar,miembro){
		return 1;
	},
    p5bfamiliar:function(encues, nhogar, respond){
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
    },    
    estadofamiliar:function(encues, nhogar, respond){
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
    },
    edadfamiliar:function(encues, nhogar, respond){
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
    },
    existemiembro:function(encues, nhogar, P6_a){
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
    },
    existejefe:function(encues, nhogar){
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
    },
    edadjefe:function(encues, nhogar){
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
    },
    existeindividual:function(encues, nhogar, nmiembro){
        if(!nmiembro){
            return 0;
        }
        var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'P', tra_enc:encues, tra_hog:nhogar, tra_mie:miembro});
        ud_este=otras_rta[JSON.stringify(pk_este)];
        if (ud_este || ud_este!=undefined){
            return 1;
        }else{
            return 0;
        }        
    },
    sumah3:function(encues){
        var nhogar = 0;
        var ud_este;
        var rta=0;
        var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'', tra_enc:encues, tra_hog:nhogar, tra_mie:0});
        ud_este=otras_rta[JSON.stringify(pk_este)];
        while (ud_este || ud_este!=undefined){
            if (!dbo.nsnc(ud_este.var_h3)){
                rta=rta + ud_este.var_h3;
            }
            nhogar++;
            var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'', tra_enc:encues, tra_hog:nhogar, tra_mie:0});
            ud_este=otras_rta[JSON.stringify(pk_este)];
        }
        return rta;       
    },
    estadojefe:function(encues, nhogar){
        var nro_mie=1; // queda:mie es una dbo
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
    },        
    anionac:function(encues, nhogar, nmiembro){
        if(!nmiembro){
            return 0;
        }
        var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'P', tra_enc:encues, tra_hog:nhogar, tra_mie:nmiembro}); // queda:mie es una dbo
        var ud_este=otras_rta[JSON.stringify(pk_este)];
        if (ud_este || ud_este!=undefined){
            var fecha=new Array();
            fecha = dbo.texto_a_fecha(ud_este.var_p3a);
            var anio = parseInt(fecha[2],10);
            if(anio){
                return anio;
            }else{
                return 0;
            }

        }else{
            return 0;
        }
    },
    sexofamiliar:function(encues, nhogar, P6_a){
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
    },
    nrojefes:function(encues,nhogar){
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
    },
    nroconyuges:function(encues, nhogar){
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
    },
    texto_a_fecha:function(str_fecha){
        var partes=new Array();
        str_fecha=str_fecha.toString();
        str_fecha=str_fecha.replace("-","/");
        partes=str_fecha.split("/");
        if (partes.length<2||partes.length>3){
            return null;
        }else if(partes.length==2) {
            partes[2]=dbo.anio();
        }else{
            if(partes[2].length==3||partes[2].length>4){
                return null;
            }else if(partes[2].length==2){
                if(partes[2]>12){
                    partes[2]='19'+partes[2];
                }else{
                    partes[2]='20'+partes[2];
                }
            }else if(partes[2].length==1){
                    partes[2]='200'+partes[2];                
            }            
        }
        var fecha = partes[0]+"/"+partes[1]+"/"+partes[2];
        if(dbo.esFechaValida(partes[0],partes[1],partes[2])){
            return partes;
        }else{
            return null;
        }       
    },
    esFechaValida:function(p_dia,p_mes,p_annio){
            var dia  =  parseInt(p_dia,10);
            var mes  =  parseInt(p_mes,10);
            var annio =  parseInt(p_annio,10);
            var numDias;
        switch(mes){
            case 1:
            case 3:
            case 5:
            case 7:
            case 8:
            case 10:
            case 12:
                numDias=31;
                break;
            case 4: case 6: case 9: case 11:
                numDias=30;
                break;
            case 2:
                if (dbo.comprobarSiBisisesto(annio)){ numDias=29 }else{ numDias=28};
                break;
            default:
                return false;
        }
            if (dia>numDias || dia==0){
                return false;
            }
            if(annio<1900 || annio>dbo.anio()){
                return false;
            }
            return true;
    },
    comprobarSiBisisesto:function(annio){
    if ( ( annio % 100 != 0) && ((annio % 4 == 0) || (annio % 400 == 0))) {
        return true;
        }
    else {
        return false;
        }
    },
    edad_a_la_fecha:function(f_nac_o, f_realiz_o){
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
    }, 
    sexojefe:function(p_enc, p_hog){
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
    },
    total_hogares:function(p_enc){
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
    },
    cantex:function(p_enc, p_hog){
        var nro_exm=1; 
        var ud_este;
        var pk_este=cambiandole(pk_ud,{tra_for:'S1', tra_mat:'X', tra_enc:p_enc, tra_hog:p_hog, tra_mie:0, tra_exm:nro_exm}); 
        ud_este=otras_rta[JSON.stringify(pk_este)];
        while (ud_este || ud_este!=undefined){
            nro_exm++;
            pk_este=cambiandole(pk_este,{tra_exm:nro_exm});
            ud_este=otras_rta[JSON.stringify(pk_este)];
        }
        return nro_exm-1;  
    },
}	
