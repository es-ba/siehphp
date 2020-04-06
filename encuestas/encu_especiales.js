//UTF-8:SÍ
"use strict";

function abrir_para_conciliar_claves(mensaje){
    guardar_en_sessionStorage('a_conciliar_claves',JSON.stringify(mensaje));
    ir_a_url(location.pathname+"?hacer=conciliar_grilla_claves");
}

function abrir_para_conciliar_visitas(mensaje){
    guardar_en_sessionStorage('a_conciliar_visitas',JSON.stringify(mensaje.respuestas));
    guardar_en_sessionStorage('tra_enc',JSON.stringify(mensaje.tra_enc));
    guardar_en_sessionStorage('tra_enc2',JSON.stringify(mensaje.tra_enc2));
    ir_a_url(location.pathname+"?hacer=conciliar_grilla_visitas");
}
