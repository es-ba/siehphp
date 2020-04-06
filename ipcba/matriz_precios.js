"use strict";


function agregarSpan(destino,clase,contenido){
    var span=document.createElement('span');
    span.textContent=contenido;
    span.className=clase;
    destino.appendChild(span);
    return span;
}

function TabuladosPrecios(){
    Tabulados.call(this);
}
TabuladosPrecios.prototype = Object.create(Tabulados.prototype);
TabuladosPrecios.prototype.constructor = TabuladosPrecios; 

TabuladosPrecios.prototype.colocar_celda=function(destino,celda){
    if(celda && celda.varios_campos){
        agregarSpan(destino,'matriz_precio',celda.valor.precio);
        agregarSpan(destino,'matriz_precio matriz_es_imputado',celda.valor.impobs);
        agregarSpan(destino,'matriz_tipoprecio',celda.valor.tipoprecio);
        agregarSpan(destino,'matriz_panel',celda.valor.cambio);
        agregarSpan(destino,'matriz_panel',celda.valor.blaprecio);
        agregarSpan(destino,'matriz_panel',celda.valor.blatipoprecio);
        agregarSpan(destino,'matriz_panel',celda.valor.blavalores);
        agregarSpan(destino,'matriz_panel',celda.valor.repregunta);

        if(celda.valor.panel!==undefined) {
            agregarSpan(destino,'matriz_panel',celda.valor.panel);
        }
        if(celda.valor.tarea!==undefined) {
            agregarSpan(destino,'matriz_tarea',celda.valor.tarea);
        }
        if(celda.valor.variacion!==undefined) {
            agregarSpan(destino,'matriz_variacion',celda.valor.variacion);
        }
    }else{
        Tabulados.prototype.colocar_celda.call(this,destino,celda);
    }
}

function matriz_precios(datos){
    var tabulado=new TabuladosPrecios();
    tabulado.claseTabla='matriz_precios';
    tabulado.desplegar(datos);
}