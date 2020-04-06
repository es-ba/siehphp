//UTF-8:SÍ
// variable global con las tablas que tienen titulos dinamicos
var TablasTituloDinamico=[];
// trae todos los elementos del dom que tengan esa etiqueta y esa clase
function buscarElementosPorClass(tag){
    var tags = ["table","div","span"];
    if(tags.indexOf(tag) == -1){
        throw "no existe el tag como posible";
    }
    var todasLasTablas = document.getElementsByTagName("table");
    var tablasConClass = Array();
    for(i = 0; i< todasLasTablas.length; i++){
        if(todasLasTablas[i].getAttribute('data-cabezales-moviles')){
            tablasConClass.push(todasLasTablas[i]);
        }        
    }
    return tablasConClass;
}
window.addEventListener('load',function(){
// busca todas las tablas que tengan la clase "TablaTituloDinamico" y las pone dentro de un array
    TablasTituloDinamico = buscarElementosPorClass("table");
    cabezales_tablas_php();
});

function luego_refrescar_grilla(nombre_grilla){
	return function(mensaje){
		proceso_formulario_respuesta.textContent=mensaje;
		proceso_formulario_respuesta.style.backgroundColor='LightGreen';
		editores[nombre_grilla].cargar_grilla(document.body,false);
	}
}

var contadorMejoras=0;

function mejorarUnaTabla(tabla,forzar){
    if(tabla.getAttribute('esta-mejorada')=='no' || forzar){
        contadorMejoras++;
        tabla.setAttribute('esta-mejorada','si'+contadorMejoras);
        var cantColumnas = tabla.getAttribute('data-cabezales-moviles')||2;
        var lefts=[];
        var anchoAcumulado=0;
        Array.prototype.forEach.call(tabla.tHead.rows[0].cells,function(cell, i){
            if(i<cantColumnas){
                lefts.push(anchoAcumulado);
                anchoAcumulado+=cell.offsetWidth;
            }
        });
        var style = document.createElement('style');
        document.head.appendChild(style);
        var determinante='[esta-mejorada=si'+contadorMejoras+']'
        style.textContent=determinante+' > thead > tr:first-child > td { position:sticky; top:0px }\n'+
            lefts.map(function(left, i){
                return determinante+' > thead > tr:first-child > td:nth-child('+(i+1)+') { position:sticky; top:0px; left:'+left+'px; z-index:1 }\n'+
                    determinante+' > tbody > tr > td:nth-child('+(i+1)+') { position:sticky; left:'+left+'px }\n';
            }).join('');
            
    }
}

function cabezales_tablas_php(forzar){
    var tablasAMejorar=document.querySelectorAll('table.editor_tabla');
    if(tablasAMejorar.length){
        for(var i=0; i<tablasAMejorar.length; i++){
            mejorarUnaTabla(tablasAMejorar[i],forzar);
        }
    }
}