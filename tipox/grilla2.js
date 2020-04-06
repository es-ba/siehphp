// grilla2lucap.js
// UTF-8:BOM
"use strict";

window.controlDependencias={
    deseables:[
        'controlParametros'
    ],
    necesarios:[
        'is_string',
        'is_array',
        'is_function',
        'is_bool',
        'is_dom_element',
        'Acumuladores',
        'rutaImagenes'
    ]
}

if(window.rutaImagenes===undefined) window.rutaImagenes='./'; // !QApred

function Grilla2(){
    this.secuenciaInterna++;
    this.secuencia=this.secuenciaInterna;
}

Grilla2.prototype.tiposCampos={};
Grilla2.prototype.tiposCampos.Generico=function(){};
Grilla2.prototype.tiposCampos.Generico.prototype.iniciarElemento=function(elemento,valorDeLaBase){ elemento.innerHTML=''; elemento.valor=valorDeLaBase; };
Grilla2.prototype.tiposCampos.Generico.prototype.desplegarElemento=function(elemento){ if(elemento.valor===null){elemento.innerHTML='';}else{elemento.textContent=elemento.valor; }};
Grilla2.prototype.tiposCampos.Generico.prototype.focoElemento=function(elemento){};
Grilla2.prototype.tiposCampos.Generico.prototype.finEdicionElemento=function(elemento){ this.iniciarElemento(elemento, elemento.textContent); };
Grilla2.prototype.tiposCampos.Generico.prototype.valorBase=function(elemento){ return elemento.valor; };
Grilla2.prototype.tiposCampos.texto=function(){};
Grilla2.prototype.tiposCampos.texto.prototype=Object.create(Grilla2.prototype.tiposCampos.Generico.prototype);
Grilla2.prototype.tiposCampos.fecha=function(){};
Grilla2.prototype.tiposCampos.fecha.prototype=Object.create(Grilla2.prototype.tiposCampos.Generico.prototype);
Grilla2.prototype.tiposCampos.fecha.prototype.iniciarElemento=function(elemento,valorDeLaBase,opciones){ 
    if(valorDeLaBase instanceof Date){
        elemento.valor=valorDeLaBase;
    }else if(valorDeLaBase){
        if(!opciones) opciones={}; // !QApred
        if(opciones.hora===undefined) opciones.hora=true; // !QApred
        var hoy=new Date();
        var fecha;
        if(opciones.construirDesde=='timestamp'){
            window.controlParametros={parametros:{timestsamp:valorDeLaBase},def_params:{timestamp:function(x){ return !isNaN(x); }}};
            fecha=new Date(valorDeLaBase);
        }else{
            fecha=new Date(Date.parse(valorDeLaBase)+(hoy.getTimezoneOffset())*60000);
        }
        elemento.valor=fecha;
    }else{
        elemento.valor=null;
    }
};
Grilla2.prototype.tiposCampos.fecha.prototype.finEdicionElemento=function(elemento,opciones){ 
    if(elemento.textContent){
        if(!opciones) opciones={}; // !QApred
        if(opciones.hora===undefined) opciones.hora=true; // !QApred
        var hoy=new Date();
        var partes=elemento.textContent.split(/[-/]/g);
        var fecha=new Date(partes[2]||hoy.getFullYear(),(partes[1]-1),partes[0]);
        elemento.valor=fecha;
    }else{
        elemento.valor=null;
    }
};
Grilla2.prototype.tiposCampos.fecha.prototype.desplegarElemento=function(elemento,opciones){ 
    if(elemento.valor){
        if(!opciones) opciones={}; // !QApred
        if(opciones.hora===undefined) opciones.hora=true; // !QApred
        var hoy=new Date();
        var fecha=elemento.valor;
        var rta=(fecha.getUTCDate()<10?"<span class=transparente>0</span>":"")+fecha.getUTCDate()+'/'+(fecha.getUTCMonth()+1);
        rta+="<small ";
        var la_hora=fecha.toTimeString();
        var hora_cero=la_hora.substr(0,8)=='00:00:00';
        if(!opciones.hora){
            rta+=hora_cero?'':'title="'+la_hora+'"';
        }
        if(fecha.getUTCFullYear()==hoy.getUTCFullYear()){
            rta+="class=anno_actual";
        }
        rta+=">/"+fecha.getUTCFullYear()+"</small></span>";
        if(fecha.getUTCFullYear()==hoy.getUTCFullYear() && fecha.getUTCMonth()==hoy.getUTCMonth()){
            if(fecha.getUTCDate()==hoy.getUTCDate()){
                rta="dds_hoy'>"+rta;
            }else{
                rta="dds_"+fecha.getUTCDay()+"'>"+rta;
            }
        }else{
            rta="'>"+rta;
        }
        rta="<span><span class='fecha "+rta;
        if(opciones.hora && !hora_cero){
            rta+=" <span title='"+la_hora+"' class='hora"+(hora_cero?' transparente':'')+"'> "+la_hora.substr(0,5)+"</span>";
        }
        rta+="</span>";
        elemento.innerHTML=rta;
    }else{
        elemento.innerHTML='';
    }
};
Grilla2.prototype.tiposCampos.fecha.prototype.focoElemento=function(elemento){ 
    elemento.textContent=elemento.textContent;
    elemento.focus();
}
Grilla2.prototype.tiposCampos.fecha.prototype.valorBase=function(elemento){ return elemento.valor?new Date(elemento.valor.getTime()-elemento.valor.getTimezoneOffset()*60000).toISOString().substr(0,10):null; };
Grilla2.prototype.tiposCampos.timestamp=function(){};
Grilla2.prototype.tiposCampos.timestamp.prototype=Object.create(Grilla2.prototype.tiposCampos.fecha.prototype);
Grilla2.prototype.tiposCampos.timestamp.prototype.iniciarElemento=function(elemento,valorDeLaBase){ 
    Grilla2.prototype.tiposCampos.fecha.prototype.iniciarElemento.call(this,elemento,valorDeLaBase,{construirDesde:'timestamp'});
}
Grilla2.prototype.tiposCampos.bool=function(){};
Grilla2.prototype.tiposCampos.bool.prototype=Object.create(Grilla2.prototype.tiposCampos.Generico.prototype);
Grilla2.prototype.tiposCampos.bool.prototype.formasConocidas={
    n:false, N:false, f:false, F:false, '0':false,
    s:true, S:true, y:true, Y:true, t:true, T:true, '1':true,
    '':null
}
Grilla2.prototype.tiposCampos.bool.prototype.iniciarElemento=function(elemento,valorDeLaBase){ 
    if(typeof valorDeLaBase=='string'){
        elemento.valor=this.formasConocidas[trim(valorDeLaBase).substr(0,1)];
    }else if(valorDeLaBase===null || valorDeLaBase===undefined){
        elemento.valor=null;
    }else{
        elemento.valor=!!valorDeLaBase;
    }
};
Grilla2.prototype.tiposCampos.bool.prototype.desplegarElemento=function(elemento){ 
    if(elemento.valor===null){
        elemento.innerHTML='';
    }else if(elemento.valor===false){
        elemento.innerHTML='<span class=falso>no</span>';
    }else{
        elemento.innerHTML='<span class=verdadero>S&iacute;</span>';
    }
};
Grilla2.prototype.tiposCampos.bool.prototype.focoElemento=function(elemento){ 
    if(elemento.valor===null){
        elemento.innerHTML='';
    }else if(elemento.valor===false){
        elemento.innerHTML='<span class=falso>N</span>';
    }else{
        elemento.innerHTML='<span class=verdadero>S</span>';
    }
};
Grilla2.prototype.tiposCampos.numerico=function(){};
Grilla2.prototype.tiposCampos.numerico.prototype=Object.create(Grilla2.prototype.tiposCampos.Generico.prototype);
Grilla2.prototype.tiposCampos.numerico.prototype.iniciarElemento=function(elemento,valorDeLaBase){ 
    if(valorDeLaBase===null || valorDeLaBase===undefined){
        elemento.valor=null;
    }else if(typeof valorDeLaBase=='string'){
        if(trim(valorDeLaBase)===''){
            elemento.valor=null;
        }else{
            elemento.valor=Number(valorDeLaBase);
            if(elemento.valor===NaN){
                elemento.valor=null;
            }
        }
    }else{
        elemento.valor=valorDeLaBase;
    }
};
Grilla2.prototype.tiposCampos.numerico.prototype.desplegarElemento=function(elemento,opciones){ 
    if(elemento.valor===null){
        elemento.innerHTML='';
    }else{
        if(!opciones) opciones={}; // !QApred
        if(!opciones.decimales && opciones.decimales!==0) opciones.decimales=2; // !QApred
        var rta=elemento.valor.toString().split('.');
        var parte_entera=rta[0];
        var parte_decimal=rta[1]||'';
        if(parte_decimal.length<opciones.decimales){
            parte_decimal+=new Array(opciones.decimales+1-parte_decimal.length).join('0');
        }
        var proximo_separador=parte_entera.length-3;
        parte_entera=parte_entera.split("");
        while(proximo_separador>0){
            parte_entera.splice(proximo_separador,0,"</span><span class=grupo_mil>");
            proximo_separador-=3;
        }
        elemento.innerHTML="<span "+(parte_entera[0]=='-'?'class=negativo':'')+"><span>"+parte_entera.join('')+"</span>"+(parte_decimal?'<small>.'+parte_decimal+"<small>":'')+'</span>';
    }
};
Grilla2.prototype.tiposCampos.entero=function(){};
Grilla2.prototype.tiposCampos.entero.prototype=Object.create(Grilla2.prototype.tiposCampos.numerico.prototype);
Grilla2.prototype.tiposCampos.entero.prototype.desplegarElemento=function(elemento,valorDeLaBase){ 
    Grilla2.prototype.tiposCampos.numerico.prototype.desplegarElemento.call(this,elemento,{decimales:0});
}
Grilla2.prototype.tiposCampos.HTML=function(){};
Grilla2.prototype.tiposCampos.HTML.prototype=Object.create(Grilla2.prototype.tiposCampos.Generico.prototype);
Grilla2.prototype.tiposCampos.HTML.prototype.iniciarElemento=function(elemento,valorDeLaBase){ 
    elemento.valor=valorDeLaBase;
}
Grilla2.prototype.tiposCampos.HTML.prototype.desplegarElemento=function(elemento){ 
    elemento.innerHTML=elemento.valor;
}
Grilla2.prototype.tiposCampos.bool_sn=function(){};
Grilla2.prototype.tiposCampos.bool_sn.prototype=Object.create(Grilla2.prototype.tiposCampos.bool.prototype);
Grilla2.prototype.tiposCampos.bool_sn.prototype.valorBase=function(elemento){ return elemento.valor===null?null:(elemento.valor?'S':'N'); }

Grilla2.prototype.secuenciaInterna=1;

Object.defineProperty(Grilla2.prototype, "proveedor", {
    set: function(proveedor){
        window.controlParametros={
            parametros:proveedor,
            def_params:{
                traerDatos:{validar:is_function, uso:'trae todos los datos de la grilla'},
                estiloFila:{validar:is_function, uso:'determina el estilo de la fila en función de los datos'},
                grabar:{validar:is_function, uso:'graba el valor en la base de datos'},
                eliminarFila:{validar:is_function, uso:'determina la forma de eliminar un registro'},
                grabarFila:{validar:is_function, uso:'determina la forma de grabar un registro completo'},
                grabarFilaInsertando:{validar:is_function, uso:'determina la forma de grabar un registro nuevo'},
            },
            ignorar_prototype:true
        }
        this.prov=proveedor;
        if(!this.prov.estiloFila) this.prov.estiloFila=function(fila){ return ''; } // !QApred
    }
});

Grilla2.prototype.agregarElemento=function(params,recursivo){
    window.controlParametros={
        parametros:params,
        def_params:{
            tagName:{validar:is_string, obligatorio:true, uso:'tipo de elemento'},
            destino:{validar:is_dom_element, uso:'donde agregarlo'},
            clase:{validar:is_string, uso:'nombre que se usará para el id, para la clase y para el miembro this'},
            dentro:{validar:is_array, uso:'si dentro de ese elemento debe crear otros'}
        }
    };
    if(recursivo){
        window.controlParametros={
            parametros:recursivo,
            def_params:{
                destino:{validar:is_dom_element, uso:'donde agregarlo'},
            }
        };
        if('destino' in recursivo) params.destino=recursivo.destino; // !AQpred
    }
    if(!('destino' in params)) params.destino=document.body; // !AQpred
    if(!('dentro' in params)) params.dentro=[]; // !AQpred
    if(params.clase in this) throw new Error('no puede haber '+params.clase+' en el this[Grilla2]'); // !AQparam
    var nuevo_elemento=document.createElement(params.tagName);
    nuevo_elemento.className='g2_'+params.clase;
    nuevo_elemento.id='g2_'+params.clase+'_'+this.secuencia;
    this[params.clase]=nuevo_elemento;
    params.destino.appendChild(this[params.clase]);
    params.dentro.forEach(function(valor){
        return this.agregarElemento(valor,{destino:nuevo_elemento});
    },this);
}

Grilla2.prototype.colocarRepositorio=function(params){
    this.agregarElemento({tagName:'div', clase:'englobador', dentro:[
        {tagName:'div', clase:'statusBar', dentro:[
            {tagName:'pre', clase:'statusBarText'},
            {tagName:'img', clase:'statusBarImg'}
        ]},
        {tagName:'div', clase:'destino'},
    ]},params);
    this.statusBarText.textContent='iniciando...';
    this.statusBarImg.src=rutaImagenes+'cargando.png';
    this.statusBarImg.classList.add('girando');
}

Grilla2.prototype.ejecutarSecuencia=function(secuencia,continua,cuandoFalla){
    var ahora=new Date();
    if(!continua){
        this.statusBarText.empezo=ahora.getTime();
    }
    var esto=this;
    for(var leyenda in secuencia){
        // this.statusBarText.textContent=leyenda;
        this.statusBarText.textContent+=' ~ '+(ahora.getTime()-this.statusBarText.empezo)/1000+'\n'+leyenda;
        var accion=secuencia[leyenda];
        break;
    }
    delete secuencia[leyenda];
    if(accion){
        setTimeout(function(){
            try{
                ahora=new Date();
                esto.statusBarText.textContent+=' '+(ahora.getTime()-esto.statusBarText.empezo)/1000;
                accion.call(esto);
                ahora=new Date();
                esto.ejecutarSecuencia(secuencia,true,cuandoFalla);
            }catch(err){
                cuandoFalla(err);
            }
        },0);
    }else{
        // this.statusBar.style.visibility='hidden';
        this.statusBarImg.style.display='none';
    }
}

Grilla2.prototype.calcularSumas=function(params){
    if(params.momento){
        var valores=this.acumuladores.totalizar();
    }else{
        var valores=this.acumuladores.subtotalizar();
    }
    var filaConSumas={};
    for(var n_campo in params.iterarEn){
        var def_campo=this.datos.campos[n_campo];
        if(!def_campo.invisible){
            if(def_campo.acumular){
                filaConSumas[n_campo]=valores[n_campo];
            }
        }
    }
    return filaConSumas;
}

Grilla2.prototype.colocarSumas=function(params){
    var tr=this.cuerpo.insertRow(params.posicion);
    tr.className='grupo_pie'+(params.momento||'');
    if("con columna izquierda"){
        var td=tr.insertCell(-1);
    }
    for(var n_campo in params.iterarEn){
        var def_campo=this.datos.campos[n_campo];
        if(!def_campo.invisible){
            var td=tr.insertCell(-1);
            if(def_campo.acumular){
                var valor=params.datos[n_campo];
                def_campo.campeador.iniciarElemento(td,valor);
                def_campo.campeador.desplegarElemento(td);
            }
        }
    }
    return tr;
}

Grilla2.prototype.crearBotonInsertar=function(params){
    var boton=document.createElement('button');
    boton.className='boton_fila';
    boton.title='agregar nuevo registro abajo de esta fila';
    var esto=this;
    boton.onclick=function(){
        var nuevaFila={};
        var tr=buscarPadre(this,'TR');
        // for(var n_campo in tr.filaDatos){
        for(var n_campo in esto.datos.campos){
            var def_campo=esto.datos.campos[n_campo];
            if(!def_campo.invisible){
                nuevaFila[n_campo]=null;
            }
        }
        esto.colocarFila({fila:nuevaFila, paraInsertar:true, posicionBajo:params.arribaDeTodo?null:tr});
    }
    var img=document.createElement('img');
    img.src=window.rutaImagenes+'fila_insertar.png';
    boton.appendChild(img);
    return boton;
}

Grilla2.prototype.sumarFila=function(params){
    window.controlParametros={parametros:params, def_params:{
        fila:{uso:'la fila que contiene los datos'},
    }};
    var grilla=this;
    var fila=params.fila;
    for(var n_campo in fila){
        var def_campo=this.datos.campos[n_campo];
        if(!def_campo.invisible){
            var valor=fila[n_campo];
            if(def_campo.acumular && valor){
                this.acumuladores.acumular(n_campo,valor instanceof Grilla2Dato?valor.valor:valor);
            }
        }
    }
}

Grilla2.prototype.colocarFila=function(params){
    window.controlParametros={parametros:params, def_params:{
        fila:{uso:'la fila que contiene los datos'},
        paraInsertar:{validar:is_bool, uso:'si la fila es una fila nueva que se está por insertar en la tabla'},
        posicionBajo:{uso:'TR bajo la cual hay que insertar la filla o NULL si es arriba de todo'},
        filaTotales:{validar:is_object, uso:'la fila de totales que se debe colocar antes de la fila'},
        encabezarGrupo:{validar:is_bool, uso:'junto con filaTotales indica si se debe iniciar un grupo nuevo'}
    }};
    var grilla=this;
    var fila=params.fila;
    params.posicion=params.posicionBajo?params.posicionBajo.sectionRowIndex+1:(params.paraInsertar?0:0);
    var tr=this.cuerpo.insertRow(params.posicion);
    tr.filaDatos=fila;
    if("con columna izquierda"){
        var td=tr.insertCell(-1);
        td.className='selector_fila';
        if(!params.paraInsertar && this.datos.con_selector_filas){
            tr.checkbox=document.createElement('input');
            tr.checkbox.type='checkbox';
            tr.checkbox.disabled=true;
            tr.checkbox.saltearEnter=true;
            td.appendChild(tr.checkbox);
        }
        if(this.datos.puede_eliminar){
            var boton=document.createElement('button');
            boton.className='boton_fila';
            boton.title='eliminar registro';
            boton.onclick=function(){
                tr.classList.add('por_eliminar');
                if(confirm('eliminar el registro')){
                    grilla.eliminarFila({tr:tr, fila:fila});
                }else{
                    tr.classList.remove('por_eliminar');
                }
            }
            td.appendChild(boton);
            var img=document.createElement('img');
            img.src=window.rutaImagenes+'fila_eliminar.png';
            boton.appendChild(img);
        }
        if(params.paraInsertar){
            var boton=document.createElement('button');
            boton.className='boton_fila';
            boton.title='grabar';
            boton.onclick=function(){
                for(var i_celda=0; i_celda<tr.cells.length; i_celda++){
                    var celda=tr.cells[i_celda];
                    if(celda.nombre_campo){
                        fila[celda.nombre_campo]=celda.valor;
                    }
                }
                grilla.grabarFilaInsertando({tr:tr, fila:fila});
            }
            td.appendChild(boton);
            var img=document.createElement('img');
            img.src=window.rutaImagenes+'fila_grabar.png';
            boton.appendChild(img);
        }else if(this.datos.puede_insertar){
            td.appendChild(this.crearBotonInsertar({}));
        }
        if(this.datos.modo_grabar=='fila' && !params.paraInsertar){
            var boton=document.createElement('button');
            boton.className='boton_fila';
            boton.title='grabar';
            boton.onclick=function(){
                grilla.grabarFila({
                    tr:tr, 
                    cuandoOk:function(){
                        boton.style.visibility='hidden';
                    }
                });
            }
            td.appendChild(boton);
            var img=document.createElement('img');
            img.src=window.rutaImagenes+'fila_grabar.png';
            boton.appendChild(img);
            boton.style.visibility='hidden';
            tr.addEventListener('focusout',function(evento){
                if(evento.relatedTarget!==this && buscarPadre(evento.relatedTarget||{},'TR')!==this){
                    boton.style.visibility='visible';
                    grilla.grabarFila({
                        tr:this, 
                        fila:fila, 
                        cuandoOk:function(){
                            boton.style.visibility='hidden';
                        }
                    });
                }
            });
        }
    }
    this.incorporarDatosFilaActualizada({fila:fila, momento:'desplegando', tr:tr});
    if(params.paraInsertar){
        tr.classList.add('fila_para_insertar');
    }
    var obtenerSubgrilla;
    if(obtenerSubgrilla=this.prov.obtenerSubgrilla({fila:params.fila})){ // !QAcod =
        var tr_sub=this.cuerpo.insertRow(tr.sectionRowIndex+1);
        td=tr_sub.insertCell(-1); 
        td=tr_sub.insertCell(-1);
        td.colSpan=999;
        td.grilla=obtenerSubgrilla;
        td.grilla.colocarRepositorio({destino:td});
        td.grilla.obtenerDatos();
        tr_sub.style.display='none';
        tr.checkbox.disabled=false;
        tr.checkbox.onchange=function(){
            tr_sub.style.display=this.checked?'':'none';
        }
        tr=tr_sub;
    }
    return tr;
}

Grilla2.prototype.eventoMostrarFilas=function(){ // para ser corrido en el contexto de un boton
    var grilla=this.guardador.grilla; 
    // for(var i_fila=this.guardador.filas.length-1; i_fila>=0; i_fila--){
    var tr=this.guardador.tr;
    var span_contador=grilla.botonesGuardar[this.guardador.guardar].span_contador;
    span_contador.textContent=Number(span_contador.textContent)-this.guardador.filas.length;
    if(span_contador.textContent==0){
        grilla.botonesGuardar[this.guardador.guardar].parentNode.removeChild(grilla.botonesGuardar[this.guardador.guardar]);
        delete grilla.botonesGuardar[this.guardador.guardar];
    }
    for(var i_fila=0; i_fila<this.guardador.filas.length; i_fila++){
        var fila=this.guardador.filas[i_fila];
        tr=grilla.colocarFila({fila:fila, posicionBajo:tr});
    }
    grilla.cuerpo.deleteRow(this.guardador.tr.sectionRowIndex);
    delete grilla.filasGuardadasPorGrupo[this.guardador.grupo][this.guardador.guardar];
}

Grilla2.prototype.colocarFilas=function(maximo){
    var grilla=this;
    var ultima_llamada=maximo<0;
    if(!('procesadaFilaHasta' in this)){
        this.cantidadFilasColocadas=0;
        this.procesadaFilaHasta=-1;
        this.grupoActual=null;
    }
    this.datos.filas.every(function(fila, i){
        if(i>this.procesadaFilaHasta){
            var colocar={fila:fila};
            if(this.datos.campoAgrupador && this.datos.campoAgrupador in fila){
                if(this.grupoActual!==fila[this.datos.campoAgrupador]){
                    if(this.grupoActual){
                        var sumas=this.calcularSumas({iterarEn:fila});
                        this.ultimaFilaColocada=this.colocarSumas({iterarEn:fila,datos:sumas,posicion:this.ultimaFilaColocada.sectionRowIndex+1});
                    }
                    this.grupoActual=fila[this.datos.campoAgrupador];
                    var tr=this.cuerpo.insertRow(this.ultimaFilaColocada?this.ultimaFilaColocada.sectionRowIndex+1:0);
                    tr.className='grupo';
                    var td=tr.insertCell(-1);
                    td.textContent=this.grupoActual;
                    td.colSpan=999;
                    this.ultimaFilaColocada=tr;
                }
            }
            this.sumarFila({fila:fila});
            if(!fila.grilla2_guardar){
                colocar.posicionBajo=this.ultimaFilaColocada;
                this.ultimaFilaColocada=this.colocarFila(colocar);
                maximo--;
                this.cantidadFilasColocadas++;
            }else{
                if(!(fila.grilla2_guardar in this.filasGuardadas)){
                    this.filasGuardadas[fila.grilla2_guardar]=[];
                }
                this.filasGuardadas[fila.grilla2_guardar].push(colocar);
                if(!(this.grupoActual in this.filasGuardadasPorGrupo)){
                    this.filasGuardadasPorGrupo[this.grupoActual]={};
                }
                if(!(fila.grilla2_guardar in this.filasGuardadasPorGrupo[this.grupoActual])){
                    var tr=this.cuerpo.insertRow(this.ultimaFilaColocada?this.ultimaFilaColocada.sectionRowIndex+1:0);
                    var td=tr.insertCell(-1);
                    tr.className='grupo_oculto';
                    tr.id=fila.grilla2_guardar+'_'+this.grupoActual+'__';
                    td.colSpan=999;
                    td.textContent='datos de '+fila.grilla2_guardar+': ';
                    var span=document.createElement('span');
                    span.textContent=0;
                    td.appendChild(span);
                    var boton=document.createElement('button');
                    boton.textContent='ver';
                    boton.className='ver_grupo_oculto';
                    var guardador={filas:[], tr:tr, elementoContador:span, boton:boton, grupo:this.grupoActual, guardar:fila.grilla2_guardar, grilla:this};
                    boton.guardador=guardador;
                    boton.onclick=this.eventoMostrarFilas;
                    td.appendChild(boton);
                    this.filasGuardadasPorGrupo[this.grupoActual][fila.grilla2_guardar]=guardador;
                    this.ultimaFilaColocada=tr;
                }
                var guardador=this.filasGuardadasPorGrupo[this.grupoActual][fila.grilla2_guardar];
                guardador.filas.push(fila);
                guardador.elementoContador.textContent=Number(guardador.elementoContador.textContent)+1;
                colocar.posicionBajo=guardador.tr;
            }
            this.procesadaFilaHasta=i;
        }
        if(!maximo){
            return false;
        }
        if(maximo<0){
        }
        return true;
    },this);
    if(this.grupoActual && ultima_llamada){
        var sumas=this.calcularSumas({iterarEn:this.datos.filas[0]});
        this.colocarSumas({iterarEn:this.datos.filas[0],datos:sumas,posicion:this.ultimaFilaColocada.sectionRowIndex+1});
        var sumas=this.calcularSumas({iterarEn:this.datos.filas[0], momento:'final'});
        this.colocarSumas({iterarEn:this.datos.filas[0],datos:sumas,posicion:this.ultimaFilaColocada.sectionRowIndex+2, momento:'final'});
    }
}

Grilla2.prototype.prepararFilaInsertar=function(){
}

Grilla2.prototype.obtenerDatos=function(){
    this.statusBarText.textContent='leyendo...';
    var grilla=this;
    grilla.statusBarImg.src=rutaImagenes+'cargando.png';
    grilla.statusBarImg.className='girando';
    var ahora=new Date();
    this.statusBarText.empezo=ahora.getTime();
    var cuandoFalla=function(el_error){ // si dio error
        grilla.statusBarText.textContent+='\nERROR. '+el_error;
        grilla.statusBarImg.src=rutaImagenes+'error_carga.png';
        grilla.statusBarImg.className='movedizo';
    };
    this.prov.traerDatos({
        cuandoOk:function(obtenido){
            grilla.datos=obtenido;
            window.controlParametros={
                parametros:obtenido,
                def_params:{
                    campos:{
                        validar:is_object, 
                        estructuraElementos:{
                            tipo:{validar:function(tipo){ return tipo in grilla.tiposCampos; }, uso:'el tipo de datos'},
                            editable:{validar:is_bool},
                            editable_ins:{validar:is_bool,uso:'si es editable al insertar'},
                            invisible:{validar:is_bool},
                            decimales:{validar:function(decimales){ return !isNaN(decimales); }},
                            tituloHTML:{uso:'titulo en HTML'},
                            ancho:{validar:function(x){ return /(em|px)$/.test(x); }, uso:'ancho de la columna (no olvidar poner em ó px)'},
                            style:{validar:is_string, uso:'el texto CSS que tiene que tener cada celda'},
                            mostrar:{validar:is_string, uso:'indica qué mostrar en casos alternativos, ej:acumulado'},
                            acumular:{validar:function(acumulador){ return acumulador in Acumuladores.prototype.acumuladoresRegistrados; }}
                        },
                        uso:'definición de los campos (o columnas) de la grilla'
                    },
                    filas:{validar:is_array, uso:'las filas con los datos de la grilla'},
                    titulo:{validar:is_string, uso:'título de la grilla'},
                    campoAgrupador:{validar:function(campo){ return campo in obtenido.campos; }, uso:'nombre del campo que se usa como agrupador, si hay'},
                    puede_eliminar:{validar:is_bool, uso:'si debe mostrar y soportar eliminación'},
                    puede_insertar:{validar:is_bool, uso:'si debe mostrar y soportar inserción'},
                    modo_grabar:{validar:function(x){ return is_string(x) && {fila:true, celda:true}[x];}, uso:'si graba por fila o por celda'},
                    demora:{uso:'calcula la demora neta de proceso en el servidor'},
                    caption:{uso:'propiedades del caption'}
                }
            }
            if(!('caption' in grilla.datos)) grilla.datos.caption={visible:true};
            grilla.datos.con_selector_filas=true;
            grilla.ejecutarSecuencia({
                'calculando el ancho de las columnas...':function(){
                    var primera_fila=this.datos.filas[0];
                    this.anchos={};
                    this.anchoTotal=0;
                    this.cantidadColumnas=0;
                    this.cantidadColumnasVisibles=0;
                    this.acumuladores=new Acumuladores();
                    for(var n_campo in primera_fila){
                        var def_campo=this.datos.campos[n_campo]||{};
                        this.datos.campos[n_campo]=def_campo;
                        def_campo.campeador=new (this.tiposCampos[def_campo.tipo]||this.tiposCampos.Generico);
                        if(n_campo.substr(0,3)=='pk_'){ // GEN
                            this.datos.campos[n_campo].invisible=true;
                        }
                        this.anchos[n_campo]=0;
                        if(def_campo.acumular){
                            this.acumuladores.iniciar(n_campo,def_campo.acumular);
                        }
                    }
                    this.datos.filas.forEach(function(fila){
                        for(var n_campo in fila){
                            var valor=fila[n_campo]+"";
                            this.anchos[n_campo]=Math.max(this.anchos[n_campo],valor.length);
                        }
                    },this);
                    for(var n_campo in primera_fila){
                        this.anchos[n_campo]=(this.anchos[n_campo]+4)/2;
                        this.anchoTotal+=this.anchos[n_campo];
                        this.cantidadColumnas++;
                        if(!this.datos.campos[n_campo].invisible){
                            this.cantidadColumnasVisibles++;
                        }
                    }
                },
                'colocando los títulos...':function(){
                    this.agregarElemento({tagName:'table',clase:'tabla',destino:this.destino,dentro:[
                        {tagName:'caption', clase:'caption'},
                        {tagName:'colgroup', clase:'columnas'},
                        {tagName:'thead', clase:'encabezado', dentro:[
                            {tagName:'tr', clase:'filaTitulos'}
                        ]},
                        {tagName:'tbody', clase:'cuerpo'}
                    ]});
                    this.tabla.caption.innerHTML='<span class="botonera_tabla" al_copiar=""></span> ';
                    this.tabla.caption.appendChild(document.createTextNode(this.datos.titulo));
                    if(!grilla.datos.caption.visible){
                        this.tabla.caption.style.display='none';
                    }
                    this.tabla.classList.add('tabla_resultados'); // LUC
                    this.tabla.width=(this.anchoTotal+this.cantidadColumnas)+'em';
                    if("con columna izquierda"){
                        var col=document.createElement('col');
                        this.columnas.appendChild(col);
                        var ancho=10;
                        if(this.datos.con_selector_filas) ancho+=15;
                        if(this.datos.puede_eliminar) ancho+=24;
                        if(this.datos.puede_insertar) ancho+=24;
                        if(this.datos.modo_grabar=='fila') ancho+=24;
                        col.style.width=ancho+'px';
                        var celda=document.createElement('th');
                        celda.className='selector_fila';
                        this.filaTitulos.appendChild(celda);
                        if(this.datos.con_selector_filas){
                            var checkbox=document.createElement('input');
                            checkbox.type='checkbox';
                            checkbox.saltearEnter=true;
                            checkbox.onclick=function(){ 
                                for(var i_tr=0; i_tr<=grilla.cuerpo.rows.length; i_tr++){
                                    var tr=grilla.tabla.rows[i_tr];
                                    if(tr.checkbox){
                                        tr.checkbox.checked=this.checked;
                                        tr.checkbox.onchange.call(tr.checkbox);
                                    }
                                }
                            }
                            celda.appendChild(checkbox);
                        }
                        if(this.datos.puede_eliminar){
                            var boton=document.createElement('button');
                            boton.className='boton_fila';
                            boton.style.visibility='hidden';
                            celda.appendChild(boton);
                            var img=document.createElement('img');
                            img.src=window.rutaImagenes+'fila_eliminar.png';
                            boton.appendChild(img);
                        }
                        if(this.datos.puede_insertar){
                            celda.appendChild(this.crearBotonInsertar({arribaDeTodo:true}));
                        }
                        if(this.datos.modo_grabar=='fila'){
                        }
                    }
                    for(var n_campo in this.anchos){
                        var def_campo=this.datos.campos[n_campo];
                        if(!def_campo.invisible){
                            var col=document.createElement('col');
                            this.columnas.appendChild(col);
                            var ancho=def_campo.ancho||Math.max(Math.min(this.anchos[n_campo],50),4)+'em';
                            col.style.width=ancho;
                            var celda=document.createElement('th');
                            celda.textContent=def_campo.titulo||n_campo;
                            if('tituloHTML' in def_campo){
                                celda.innerHTML=def_campo.tituloHTML;
                            }
                            this.filaTitulos.appendChild(celda);
                            def_campo.cellIndex=celda.cellIndex;
                        }
                    }
                },
                'colocando las primeras filas...':function(){
                    this.filasGuardadas={};
                    this.filasGuardadasPorGrupo={};
                    this.ultimaFilaColocada=null;
                    this.colocarFilas(100);
                },
                'colocando el resto de las filas...':function(){
                    this.colocarFilas(-1);
                },
                'completando el título de las columnas...':function(){
                    for(var i_fila=0; i_fila<this.tabla.tHead.rows.length; i_fila++){
                        var row=this.tabla.tHead.rows[i_fila];
                        for(var i_celda=0; i_celda<row.cells.length; i_celda++){
                            var celda=row.cells[i_celda];
                            if(celda.offsetWidth<celda.scrollWidth && !celda.title){
                                celda.title=celda.textContent;
                            }
                        }
                    }
                },
                'agregando selectores para grupos no visibles...':function(){
                    var grilla=this;
                    var botonera=document.createElement('span');
                    botonera.textContent='mostrar:';
                    botonera.className='botonera_grupos_ocultos';
                    this.botonesGuardar={};
                    for(var guardar in this.filasGuardadas){
                        var boton=document.createElement('button');
                        boton.textContent=guardar;
                        var span=document.createElement('span');
                        span.style.fontsize='80%';
                        span.textContent=' (';
                        var span_contador=document.createElement('span');
                        span_contador.textContent=this.filasGuardadas[guardar].length;
                        span.appendChild(span_contador);
                        span.appendChild(document.createTextNode(')'));
                        boton.span_contador=span_contador;
                        boton.guardar=guardar;
                        boton.onclick=function(){
                            var guardar=this.guardar;
                            for(var grupo in grilla.filasGuardadasPorGrupo){
                                if(guardar in grilla.filasGuardadasPorGrupo[grupo]){
                                    var guardador=grilla.filasGuardadasPorGrupo[grupo][guardar];
                                    grilla.eventoMostrarFilas.call(guardador.boton);
                                }
                            }
                            this.disabled=true;
                        }
                        boton.appendChild(span);
                        botonera.appendChild(boton);
                        this.botonesGuardar[guardar]=boton;
                    }
                    this.tabla.caption.appendChild(botonera);
                },
                'listo':function(){
                    this.statusBar.style.display='none';
                }
            },true,cuandoFalla);
        },
        cuandoFalla:cuandoFalla
    });
}

Grilla2.prototype.eliminarFila=function(params){
    window.controlParametros={parametros:params, def_params:{
        fila:{uso:'la fila de datos que debe eliminarse (y que todavía no se ha hecho'},
        tr:{validar:is_dom_element, uso:'el elemento tr donde está la fila'}
    }};
    var esto=this;
    this.prov.eliminarFila({
        fila:params.fila,
        relojEn:params.tr,
        cuandoOk:function(datos){
            params.tr.parentNode.removeChild(params.tr);
            var posicion=esto.datos.filas.indexOf(params.fila);
            if(posicion<0){
                alert('debe refrescar');
            }else{
                esto.datos.filas.splice(posicion,1);
            }
        },
        cuandoFalla:function(datos){
            params.tr.classList.remove('por_eliminar');
        }
    });
};

Grilla2.prototype.grabarFilaInsertando=function(params){
    window.controlParametros={parametros:params, def_params:{
        fila:{uso:'la fila de datos que debe insertarse (y que todavía no se ha hecho'},
        tr:{validar:is_dom_element, uso:'el elemento tr donde está la fila'}
    }};
    var grilla=this;
    this.prov.grabarFilaInsertando({
        fila:params.fila,
        relojEn:params.tr.cells[0],  
        cuandoOk:function(datos){
            params.fila=cambiandole(params.fila,datos.fila);
            grilla.colocarFila({fila:params.fila, posicionBajo:params.tr});
            params.tr.parentNode.removeChild(params.tr);
        }
    });
}

Grilla2.prototype.grabarFila=function(params){
    window.controlParametros={parametros:params, def_params:{
        fila:{uso:'la fila de datos que debe insertarse (y que todavía no se ha hecho'},
        tr:{validar:is_dom_element, uso:'el elemento tr donde está la fila'},
        cuandoOk:{validar:is_function, uso:'si debe controlar qué pasó'}
    }};
    var grilla=this;
    var fila_original={};
    for(var i_celda=0; i_celda<params.tr.cells.length; i_celda++){
        var celda=params.tr.cells[i_celda];
        if(celda.nombre_campo){
            params.fila[celda.nombre_campo]=celda.valor;
            fila_original[celda.nombre_campo]=celda.valorOriginal;
        }
    }
    this.prov.grabarFila({
        fila:params.fila,
        fila_original:fila_original,
        relojEn:params.tr.cells[0],  
        cuandoOk:function(datos){
            grilla.incorporarDatosFilaActualizada({fila:params.fila, nueva_fila:datos.nueva_fila, tr:params.tr, momento:'actualizando'});
            if(params.cuandoOk){
                params.cuandoOk();
            }
        }
    });
}

Grilla2.prototype.incorporarDatosFilaActualizada=function(params){
    window.controlParametros={parametros:params, def_params:{
        fila:{uso:'la fila actual donde deben refrescarse los datos'},
        nueva_fila:{uso:'la fila nueva, o sea los datos llegados de la base de datos o nada si no es una actualización sino un despliegue de traer datos'},
        tr:{validar:is_dom_element, uso:'el elemento tr donde está la fila'},
        momento:{obligatorio:true, validar:function(momento){ return {desplegando:true, actualizando:true}[momento]; }, uso:'indica si se está usando en un despliegue o después de actualizar una fila'}
    }};
    if(params.momento=='actualizando' && !params.nueva_fila) throw new Error('falta la nueva_fila');
    if(params.momento=='desplegando' && params.nueva_fila) throw new Error('sobra la nueva_fila');
    if(!params.nueva_fila) params.nueva_fila=params.fila;
    var grilla=this;
    for(var n_campo in params.nueva_fila){
        var def_campo=this.datos.campos[n_campo];
        if(!def_campo){
            throw new Error('falta la definición del campo '+n_campo);
        }
        var valor=params.fila[n_campo];
        if(!def_campo.invisible){
            if(params.momento=='desplegando'){
                var td=params.tr.insertCell(-1);
                td.nombre_campo=n_campo;
                if(def_campo.style){
                    td.style.cssText=def_campo.style;
                }
                td.className='g2_campo_'+n_campo;
                if(params.paraInsertar?def_campo.editable_ins:def_campo.editable){
                    td.defCampo=def_campo;
                    td.contentEditable=true;
                    td.onfocus=function(){
                        this.style.textOverflow='clip';
                        this.defCampo.campeador.focoElemento(this);
                    }
                    td.onblur=function(){
                        this.defCampo.campeador.finEdicionElemento(this,this.textContent);
                        this.defCampo.campeador.desplegarElemento(this);
                        var esto=this;
                        if(!params.paraInsertar && grilla.datos.modo_grabar!='fila'){
                            grilla.prov.grabar({
                                valor:this.defCampo.campeador.valorBase(this),
                                campo:this.nombre_campo,
                                fila:params.fila,
                                celda:this,
                                grilla:grilla,
                                cuandoOk:function(params_ok){
                                    window.controlParametros={parametros:params_ok, def_params:{
                                        nuevo_valor:{uso:'el nuevo valor que devolvió la base para ese campo (puede haber cambiado, ej: pasado a mayúsculas o trimeado espacios'},
                                        nueva_fila:{uso:'la nueva fila que devolvió porque al cambiar un campo pueden haber cambiado otros registros'}
                                    }};
                                    grilla.incorporarDatosFilaActualizada({fila:params.fila, nueva_fila:params_ok.nueva_fila, tr:params.tr, momento:'actualizando'});
                                }
                            });
                        }
                    }
                }else if(params.paraInsertar){ // no editable
                    td.classList.add('no_insertable');
                }
            }else{
                var valor=params.fila[n_campo]=params.nueva_fila[n_campo]; // !QAcod =
                var td=params.tr.cells[def_campo.cellIndex];
            }
            td.valorOriginal=valor;
            def_campo.campeador.iniciarElemento(td,valor instanceof Grilla2Dato?valor.mostrar:valor);
            def_campo.campeador.desplegarElemento(td);
        }else if(params.momento!='desplegando'){
            params.fila[n_campo]=params.nueva_fila[n_campo]; // !QAcod =
        }
    }
    params.tr.className=this.prov.estiloFila(params.fila);
}

function ProveedorGrilla2(){
}

ProveedorGrilla2.prototype.def_params_traerDatos={
    cuandoOk   :{validar:is_function},
    cuandoFalla:{validar:is_function}
};
ProveedorGrilla2.prototype.def_params_grabar={
    valor  :{uso:'el valor modificado'}, 
    campo  :{uso:'nombre del campo modificado'}, 
    fila   :{uso:'fila que contiene todos los datos donde estaba ese valor'}, 
    celda  :{uso:'celda física donde poner el reloj'}, 
    grilla :{uso:'grilla'},
    cuandoOk   :{validar:is_function, uso:'función a la que llamará después de grabar'},
    cuandoFalla:{validar:is_function, uso:'función a la que llamará después de grabar'},
};
ProveedorGrilla2.prototype.def_params_eliminarFila={
    fila   :{uso:'fila que contiene todos los datos a eliminar'}, 
    cuandoOk   :{validar:is_function, uso:'función a la que llamará después de grabar'},
    cuandoFalla:{validar:is_function, uso:'función a la que llamará después de grabar'},
    relojEn:{validar:is_dom_element}
};
ProveedorGrilla2.prototype.def_params_grabarFilaInsertando={
    fila   :{uso:'fila que contiene todos los datos nuevos a insertar'}, 
    cuandoOk   :{validar:is_function, uso:'función a la que llamará después de grabar'},
    cuandoFalla:{validar:is_function, uso:'función a la que llamará después de grabar'},
    relojEn:{validar:is_dom_element}
};
ProveedorGrilla2.prototype.def_params_grabarFila={
    fila   :{obligatorio:true, uso:'fila que contiene todos los datos que hay que grabar'}, 
    fila_original:{obligatorio:true, uso:'los datos que estaban antes en la fila'},
    cuandoOk   :{validar:is_function, uso:'función a la que llamará después de grabar'},
    cuandoFalla:{validar:is_function, uso:'función a la que llamará después de grabar'},
    relojEn:{validar:is_dom_element}
};
ProveedorGrilla2.prototype.obtenerSubgrilla=function(){
    return false;
}
ProveedorGrilla2.prototype.def_params_obtenerSubgrilla={
    fila:{uso:'fila que se usa para filtrar o identificar la subgrilla'},
}
function Grilla2Dato(){
}