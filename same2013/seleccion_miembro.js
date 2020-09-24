"use strict";
var version_js_seleccion_miembro='v 3.00';

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
    'AHFBDJGCIE'].map(function(lista){ return lista.split(''); });

window.addEventListener('load',function(){
    if(document.getElementById('var_tp') && operativo_actual=='same2013'){
        var padre=document.getElementById('var_tp').parentNode;
        var boton=document.createElement("input");
        boton.value= "seleccionar miembro";
        boton.type="button";
        boton.id='boton_seleccionar_miembro';
        boton.onclick=function(){
            var esto=this;
            esto.style.backgroundImage=URL_IMAGEN_LOADING;
            setTimeout(function(){ 
                seleccionar_miembro(false,esto);
            },200);
        };
        padre.appendChild(boton);
    }
});

function seleccionar_miembro(solo_controla,este){
    var cant_candidatos=0;
    var uds_miembros={};
    var en_rango=[];
    rta_ud=rta_ud||JSON.parse(localStorage.getItem("ud_"+id_ud));
    if(solo_controla && !rta_ud){
        return;
    }
    for(var num_miembro=1; num_miembro<=100; num_miembro++){
        var pk_este=cambiandole(pk_ud,{tra_for:'SM1', tra_mat:'P', tra_mie:num_miembro}); // queda:mie es una dbo
        var otra_ud=JSON.stringify(pk_este);
        var ud_este=JSON.parse(localStorage.getItem("ud_"+otra_ud));
        if (ud_este){
            uds_miembros[num_miembro]=ud_este;  
            if(ud_este.var_edad>=16 && ud_este.var_edad<=65){
                cant_candidatos=cant_candidatos+1;
                en_rango.push({
                    edad:ud_este.var_edad, 
                    nacim:(dbo.texto_a_fecha(ud_este.var_f_nac_o)||[]).map(function(x){return Number(x)+1000}).reverse().join('x'), 
                    num:num_miembro
                });
            }else{                
                uds_miembros[num_miembro].var_l0=null;                
                localStorage.setItem("ud_"+otra_ud,JSON.stringify(uds_miembros[num_miembro]));        
            }            
        }         
    }
    var control=true
    if(cant_candidatos==0){
        if(solo_controla){
            control=(
                rta_ud.var_cr_ningun_miembro==1 &&
                !rta_ud.var_cr_num_miembro &&
                rta_ud.var_tp==0
            );
        }else{
            rta_ud.var_cr_ningun_miembro=1;
            rta_ud.var_cr_num_miembro=null;
            rta_ud.var_tp=0;
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
            if(solo_controla){
                control=control && uds_miembros[num_miembro_sorteado].var_l0==letra;
            }else{
                uds_miembros[num_miembro_sorteado].var_l0=letra;
                pk_este=cambiandole(pk_ud,{tra_for:'SM1', tra_mat:'P', tra_mie:num_miembro_sorteado}); // queda:mie es una dbo
                otra_ud=JSON.stringify(pk_este);
                localStorage.setItem("ud_"+otra_ud,JSON.stringify(uds_miembros[num_miembro_sorteado]));        
            }
            letra=String.fromCharCode(letra.charCodeAt(0)+1);        
        }
        var encuesta=String(pk_ud.tra_enc);
        var ultimo_digito_encuesta=encuesta.substring(encuesta.length,encuesta.length-1);
        var letra_elegido=tabla_aleatoria_miembro[cant_candidatos-1][ultimo_digito_encuesta!=0?ultimo_digito_encuesta-1:9];
        var elegido=LetraMiembro[letra_elegido];
        if(solo_controla){
            control=control && (
                !rta_ud.var_cr_ningun_miembro &&
                rta_ud.var_cr_num_miembro==elegido &&
                rta_ud.var_tp==cant_candidatos
            );
        }else{
            rta_ud.var_cr_ningun_miembro=null;
            rta_ud.var_cr_num_miembro=elegido;
            rta_ud.var_tp=cant_candidatos;
        }
    }
    if(solo_controla){
        elemento_existente("boton_seleccionar_miembro").style.backgroundColor=control?null:'Orange';
    }else{
        localStorage.setItem("ud_"+id_ud,JSON.stringify(rta_ud));
        sessionStorage.setItem('poner_foco',este.id);
        ir_a_url('same2013.php?hacer=desplegar_formulario&todo={"tra_ope":"same2013","tra_for":"SM1","tra_mat":""}');
    }
}

function habilitar_boton(idboton){
    var elemento=elemento_existente(idboton);
    elemento.disabled=false;
}  

