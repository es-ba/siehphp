"use strict";

var agregarP=function(texto){
    var elemento=document.createElement('p');
    elemento.textContent=texto;
    document.body.appendChild(elemento);    
}

agregarP('seguimos');
var p=agregarP;
p('con esto');

var vocal={'a':true, 'e':true, 'i':true, 'o':true, 'u':true};

var Palabra=function(texto, tipo){
    var tienePlural={
        'sustantivo':true,
        'adjetivo':true,
        'advervio':true,
    }
    this.pluralSi=function(condicion){
        if(condicion){
            return this.plural();
        }else{
            return texto;
        }
    }
    this.plural=function(){
        if(tienePlural[tipo]){
            if(vocal[texto[texto.length-1]]){
                return texto+'s';
            }else{
                return texto+'es';
            }
        }else{
            return texto;
        }
    }
}

var archivo=new Palabra('archivo','sustantivo');
var cajon=new Palabra('cajón','sustantivo');

for(var cantidad=0; cantidad<3; cantidad++){
    agregarP('se borraron '+cantidad+' '+archivo.pluralSi(cantidad!=1)+
        ' y lo borrado se guardó en '+cantidad+' '+cajon.pluralSi(cantidad!=1));
}

/*
var Word=function(texto, tipo){
    this.plural=function(){
        // busco en un diccionario
        return this.plurales[texto];
    }
}
*/