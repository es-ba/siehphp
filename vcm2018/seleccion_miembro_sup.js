"use strict";
var version_js_seleccion_miembro_sup='v 2.43';

var tabla_aleatoria_miembro=[
    'AAAAAAAAAA',
    'BABAABAABB',
    'ACCBBABBAC',
    'BAACCBDCDA',
    'CBEDAEADCB',
    'FDBAECEAFD',
    'ECDGGFCBBA',
    'DGAECDBFHC',
    'GEHCBIHDAF',
    'AHFBDJGCIE',
    'IAGHFEDBIK',
    'GDDJAAFECL',
    'ACHMEKHJBM',
    'JMCHIAENLC',
    'ÑGCKMIKÑJN'].map(function(lista){ return lista.split(''); });

window.addEventListener('load',function(){
    if(document.getElementById('var_sv_tp') && operativo_actual=='vcm2018'){
        var padre=document.getElementById('var_sv_tp').parentNode;
        var boton=document.createElement("input");
        boton.value= "seleccionar miembro_sup";
        boton.type="button";
        boton.id='boton_seleccionar_miembro_sup'; //otro id
        boton.onclick=function(){
            var esto=this;
            esto.style.backgroundImage=URL_IMAGEN_LOADING;
            esto.style.backgroundRepeat='no-repeat';
            esto.style.backgroundPosition='top right';
            setTimeout(function(){ 
                seleccionar_miembro_sup(false,esto);
            },200);
        };
        padre.appendChild(boton);
    }
});

function seleccionar_miembro_sup(solo_controla,este){
    var cant_candidatos=0;
    var uds_miembros={};
    var en_rango=[];
    rta_ud=rta_ud||JSON.parse(localStorage.getItem("ud_"+id_ud));
    if(solo_controla && !rta_ud){
        return;
    }
    var pk_tem=cambiandole(pk_ud,{tra_for:'TEM', tra_mat:'', tra_hog:0}); 
    var otra_ud_tem=JSON.stringify(pk_tem);
    var ud_este_tem=JSON.parse(localStorage.getItem("ud_"+otra_ud_tem));
    var dominio= ud_este_tem.copia_dominio;
    var letra_manual=dominio==5;
    for(var num_miembro=1; num_miembro<=100; num_miembro++){    
        var pk_este=cambiandole(pk_ud,{tra_for:'SUP', tra_mat:'P', tra_mie:num_miembro}); // queda:mie es una dbo
        var otra_ud=JSON.stringify(pk_este);
        var ud_este=JSON.parse(localStorage.getItem("ud_"+otra_ud));
        if (ud_este){
            uds_miembros[num_miembro]=ud_este;
            if ((letra_manual && uds_miembros[num_miembro].var_sv_l0) || (!letra_manual && ud_este.var_sv_edad>=18 && ud_este.var_sv_edad<=999 && ud_este.var_sv_sexo==2)){
                cant_candidatos=cant_candidatos+1;
                en_rango.push({
                    edad:ud_este.var_sv_edad, 
                    nacim:(dbo.texto_a_fecha(fechadma(ud_este.var_f_nac_d,ud_este.var_f_nac_m,ud_este.var_f_nac_a))
                    ||[]).map(function(x){return Number(x)+1000}).reverse().join('x'), 
                    num:num_miembro
                });
            }else{                
                uds_miembros[num_miembro].var_sv_l0=null;                
                localStorage.setItem("ud_"+otra_ud,JSON.stringify(uds_miembros[num_miembro]));        
            }            
            
        }         
    }
    var control=true
    if(cant_candidatos==0){
        if(solo_controla){
            control=(
                // rta_ud.var_cr_ningun_miembro==1 &&
                !rta_ud.var_sv_cr_num_miembro &&
                rta_ud.var_sv_tp==0
            );
        }else{
            // rta_ud.var_cr_ningun_miembro=1;
            rta_ud.var_sv_cr_num_miembro=null;
            rta_ud.var_sv_tp=0;
        }
    }else{
        en_rango.sort(function(a,b){
            if(a.edad<b.edad){
                return 1;
            }else if(a.edad>b.edad){
                return -1;
            }else{
                if(a.nacim<b.nacim){
                    return -1;
                }else if(a.nacim>b.nacim){
                    return 1;
                }else{
                    if(a.num<b.num){
                        return -1;
                    }else{
                        return 1;
                    }
                }
            }
        });
        var letra='A';
        var LetraMiembro={};
        for(var cada_miembro_sorteado in en_rango){
            var num_miembro_sorteado=en_rango[cada_miembro_sorteado].num;  
            LetraMiembro[letra]=num_miembro_sorteado;
            if(!letra_manual){
                if(solo_controla){                
                    control=control && uds_miembros[num_miembro_sorteado].var_sv_l0==letra;                
                }else{                
                    var ud_este=uds_miembros[num_miembro_sorteado];
                    ud_este.var_sv_l0=letra;
                    pk_este=cambiandole(pk_ud,{tra_for:'SUP', tra_mat:'P', tra_mie:num_miembro_sorteado}); // queda:mie es una dbo
                    otra_ud=JSON.stringify(pk_este);
                    localStorage.setItem("ud_"+otra_ud,JSON.stringify(ud_este));
                    if(!soy_un_ipad){
                        var estado_ud_este=JSON.parse(localStorage.getItem("estado_ud_"+otra_ud));
                        var elemento_boton=document.getElementById('boton_SUP_P_'+num_miembro_sorteado);
                        var vfecha_hora=fecha_amd_hora_hms();
                        enviar_paquete({
                            proceso:'grabar_ud',
                            paquete:{pk_ud:pk_este, rta_ud:ud_este, estados_rta_ud:estado_ud_este, tra_fecha_hora: vfecha_hora },
                            cuando_ok:function(){
                            },
                            cuando_error:function(mensaje){
                            },
                            usar_fondo_de:elemento_boton,
                            mostrar_tilde_confirmacion:true,
                            asincronico:false
                        });
                    }
                }
            }
            letra=String.fromCharCode(letra.charCodeAt(0)+1);        
        }
        var encuesta=String(pk_ud.tra_enc);
        var ultimo_digito_encuesta=encuesta.substring(encuesta.length,encuesta.length-1);
        var letra_elegido=tabla_aleatoria_miembro[cant_candidatos-1][ultimo_digito_encuesta!=0?ultimo_digito_encuesta-1:9];
        var elegido=LetraMiembro[letra_elegido];
        if(solo_controla){
            control=control && (
                // !rta_ud.var_cr_ningun_miembro && 
                rta_ud.var_sv_cr_num_miembro==elegido &&
                rta_ud.var_sv_tp==cant_candidatos
            );
        }else{
            // rta_ud.var_cr_ningun_miembro=null;
            rta_ud.var_sv_cr_num_miembro=elegido;
            rta_ud.var_sv_tp=cant_candidatos;
        }
    }
    if(solo_controla){
        elemento_existente("boton_seleccionar_miembro_sup").style.backgroundColor=control?null:'Orange';
    }else{
        modificado_db=true;
        localStorage.setItem("ud_"+id_ud,JSON.stringify(rta_ud));
        sessionStorage.setItem('poner_foco',este.id);
        if(grabar_si_es_necesario_o_seguir()){
            setTimeout(function(){
                ir_a_url('vcm2018.php?hacer=desplegar_formulario&todo={"tra_ope":"vcm2018","tra_for":"SUP","tra_mat":""}');
            },200);
        }
    }
}

function habilitar_boton(idboton){
    var elemento=elemento_existente(idboton);
    elemento.disabled=false;
}  

//function po