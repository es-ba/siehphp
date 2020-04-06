"use strict";
/*jshint eqnull:true */
/*jshint node:true */

(function codenautasModuleDefinition(root, name, factory) {
    /* global define */
    /* istanbul ignore next */
    if(typeof root.globalModuleName !== 'string'){
        root.globalModuleName = name;
    }
    /* istanbul ignore next */
    if(typeof exports === 'object' && typeof module === 'object'){
        module.exports = factory();
    }else if(typeof define === 'function' && define.amd){
        define(factory);
    }else if(typeof exports === 'object'){
        exports[root.globalModuleName] = factory();
    }else{
        root[root.globalModuleName] = factory();
    }
    root.globalModuleName = null;
})(/*jshint -W040 */this, 'GrillaUt', function() {
/*jshint +W040 */

var defPreguntasRescate=[
    {pre:'D1', "var":'d1'},
    {pre:'D2', "var":'d2'}
];

if(typeof window == 'undefined'){
    var jsToHtml = require('js-to-html');
    var TypedControls=require('typed-controls.js');
    var estructura_ut=require('estructura_ut2016.js');
}else{
    var jsToHtml = window.jsToHtml;
    var TypedControls=window.TypedControls;
    var estructura_ut=window.preguntas;
}
var html = jsToHtml.html;

function recontarFilas(tabla){
    Array.prototype.forEach.call(tabla.childNodes, function(child, i){
        child.numeroOrdenFila=i;
    });
}

function O_map(object, callback){
    return Object.keys(object).map(function(key, keysArray){
        return callback(object[key], key, object);
    })
}

function mostrar(mensaje){
    var lugar = document.getElementById('grilla-ut-zona-derecha').childNodes[0].childNodes[0].childNodes[4];
    lugar.textContent=mensaje;
}
    

function GrillaUt(){
    var colorOtros='#49FFFF';
    var colorInvalido='#FFED66';
    var colorAgujero='rgba(255,0,0,0.5)'
    var gu = this;
    function grabar_todo(){
        var tramos_a_grabar=gu.tramos.map(function(tramo){
            var tramo_puro={};
            gu.estructuraTramo.forEach(function(infoCampo){
                tramo_puro[infoCampo.nombre]=tramo[infoCampo.nombre];
            });
            return tramo_puro;
        }).filter(function(tramo){
            return tramo.desde || tramo.hasta || tramo.codigo || tramo.detalle;
        });
        var datos_matriz_json=JSON.stringify(tramos_a_grabar);
        rta_ud['var_'+variable_especial]=datos_matriz_json;
        localStorage.setItem("ud_"+id_ud, JSON.stringify(rta_ud));
    }
    
    gu.renglonVacio=function(){ return {desde:null, hasta:null, codigo:null, detalle:null}; };
    var medidas={
        horas:12,
        renglonesHora:6,
        pixelPorRenglon:10,
        pixelAncho:120,
        minutosRenglon:10,
        cantAct:3,
        separacionActividad:8,
    };
    var cortes=[
        //SETEO corY=0 para que se vea bien. Estaba en -10 y arruinaba la posición
        {id: 'caja1', desde:'00:00', hasta:'12:00', corX:15 , corY: -10},
        {id: 'caja2', desde:'12:00', hasta:'24:00', corX:205, corY: -10-medidas.horas*medidas.renglonesHora*medidas.pixelPorRenglon},
    ]
    var novalidar=function(){return true;}
    var nocompletar=function(x){ return x;}
    this.separaHoraTexto=function(horaNoSeparada){
        var indiceDosPuntos=horaNoSeparada.match(/:/).index;
        var preDosPuntos=horaNoSeparada.substr(0,indiceDosPuntos)
        var postDosPuntos=horaNoSeparada.substr(indiceDosPuntos+1,horaNoSeparada.length);
        return {
            hora:preDosPuntos,
            minutos:postDosPuntos
        };
    }
    this.completarHora = function completarHora(hora){
        if(hora==null) return null;
        if(!hora.match(/:/) && hora.match(/[,.;]/)){
            hora=hora.replace(/[,.;]/,':')
        }
        if(!hora.match(/:/)){
            if(hora.length<=2){
                hora=hora+':00';
            }else{
                hora=hora.substr(0,hora.length-2)+':'+hora.slice(-2);
            }
        }
        var horaSeparada=gu.separaHoraTexto(hora);
        hora=(horaSeparada.hora.length==1)?'0'+hora:hora;
        horaSeparada=gu.separaHoraTexto(hora);
        hora=(horaSeparada.minutos.length==0)?hora+'00':hora;
        hora=(horaSeparada.minutos.length==1)?hora+'0':hora;
        hora=(horaSeparada.minutos.length>2)?horaSeparada.hora+':'+horaSeparada.minutos.substr(0,2):hora;
        return hora;
    };
    this.validarHora = function validarHora(hora){
        var patt = new RegExp(/^([01]\d|2[0-3]):([0-5][0-9])$/);
        return patt.test(hora) || (hora=='24:00');
    };
    this.validarHoraYRango = function (hora, registroConDesdeHasta){
        var desde=registroConDesdeHasta.desde;
        var hasta=registroConDesdeHasta.hasta;
        var rangoInvalido = hasta != null && desde != null && hasta<=desde;
        return this.validarHora(hora) && !rangoInvalido;
    }
    this.validarActividad = function validarActividad(actividad){
      //  return !!codigosActividad[actividad];
        return !!actividades_codigos[actividad];
    };
    this.estructuraTramo=[
        {nombre:'desde'  ,tipo:'tel' , completador:this.completarHora, validador:this.validarHoraYRango},
        {nombre:'hasta'  ,tipo:'tel' , completador:this.completarHora, validador:this.validarHoraYRango},
        {nombre:'codigo' ,tipo:'tel' , completador:nocompletar       , validador:this.validarActividad , actualizaPlaceholder:'detalle'},
        {nombre:'rescate',tipo:'tel' , completador:nocompletar       , validador:novalidar             , tabindex:true, rescate:true},
        {nombre:'detalle',tipo:'text', completador:nocompletar       , validador:novalidar             , tabindex:true},
    ]
    this.cargar = function cargar(tramos){
        this.tramos = tramos;
        if(!this.tramos.length || this.tramos[this.tramos.length-1].desde){
            //ESTO TRAE PROBLEMAS CON EL TEST QUE NO HACE QUE NO PASE EL TEST DE ACOMODAR RENGLÓN: NO CONTEMPLA ACOMODAR EL RENGLÓN VACÍO
            this.tramos.push(this.renglonVacio());
        }
    }
    this.acomodar = function acomodar(){
        var tramos = this.tramos;
    /* separa los tramos en una o más columnas de modo de que:
        1) cada tramo esté en alguna columna
        2) dentro de cada columna los tramos estén ordenados
        3) dentro de cada columna los tramos no se superpongan
        4) se empiece llenando siempre la primera columna, luego la segunda, etc
       además calcula los agujeros (rangos horarios sin tramos) y
       el fin del tramo que termina último
    */  
        if(this.acomodo){
            this.acomodo.agujeros.forEach(function(agujero){
                cortes.forEach(function(corte){
                    if(agujero[corte.id]){
                        agujero[corte.id].parentNode.removeChild(agujero[corte.id]);
                    }
                });
            });
        }
        this.acomodo = {
            columnas:[],
            agujeros:[],
            cargadoHasta:''
        };
        var ancho = function(c){
            if(c==null){
                return 'zzzzzzzzzz';
            }
            while(c.length<10) c+=' ';
            return c;
        }
        var invertir = function(t){
            return t.split('').map(function(letra){
                return String.fromCharCode('|'.charCodeAt(0)-letra.charCodeAt(0));
            }).join('');
        }
        var lindo = function(x){
            return ancho(x.desde)+'/'+invertir(ancho(x.hasta))+'/'+x.codigo
        }
        tramos.sort(function(x,y){
            var xLindo=lindo(x);
            var yLindo=lindo(y);
            if(xLindo<yLindo){
                return -1;
            }else if(xLindo>yLindo){
                return 1;
            }else{
                return 0;
            }
        })
        this.acomodo.cargadoHasta=tramos[tramos.length-1].hasta;
        var columnas = this.acomodo.columnas;
        columnas.push([tramos[0]]);
        var actual;
        for(var i=1;i<tramos.length;i++){
            actual=tramos[i];
            var j=0;
            var ubicado= false;
            while (j<columnas.length){
                var colj=columnas[j];
                var cotacol=colj[colj.length-1];
                if (actual.desde>= cotacol.hasta ){
                    columnas[j].push(actual);
                    j=columnas.length;
                    ubicado=true;
                }
                j++;
            }
            if(!ubicado){
                columnas.push([actual]);
            }
        }
        var agujeros=[];
        if (tramos[0].desde>'00:00'){
            agujeros.push({desde:'00:00', hasta:tramos[0].desde});
        };
        var cargado_total=tramos[0].hasta;
        for(var i=1;i<tramos.length;i++){
            if (tramos[i].desde>cargado_total){
                var agujero={};
                agujero.desde=cargado_total;
                agujero.hasta=tramos[i].desde;
                agujeros.push(agujero);
            } 
            cargado_total= cargado_total<tramos[i].hasta? tramos[i].hasta: cargado_total;
        }
        this.acomodo.agujeros= agujeros;
        
        this.acomodo.cargadoHasta=cargado_total;
    }
    this.habilitarRescate = function habilitarRescate(tramo){
        tramo.rescatable=tramo.codigo && (rta_ud.var_d1==1 || rta_ud.var_d2==1) && actividades_codigos[tramo.codigo]&& actividades_codigos[tramo.codigo].rescatable ;
        tramo.inputs.rescate.style.visibility=tramo.rescatable?'visible':'hidden';
    }
    this.desplegar = function desplegar(idDivDestino, corYtotal){
        corYtotal=corYtotal||0;
        var tabla=html.table({id:'grilla-ut-tabla-externa'},[
            html.tr([
                html.td({id:'grilla-ut-zona-izquierda'}),
                html.td({id:'grilla-ut-zona-derecha'}),
            ])
        ]);
        document.getElementById(idDivDestino).appendChild(tabla.create());        
        var renglones_tramos=[];
        renglones_tramos.push(html.tr([
            html.th({"class":"col-desde"  },'desde'        ),
            html.th({"class":"col-hasta"  },'hasta'        ),
            html.th({"class":"col-codigo" },'c.act.'       ),
            html.th({"class":"col-rescate"},'R'            ),
            html.th({"class":"col-detalle"},'observaciones'),
        ]));
        var tablaTramos=html.table(renglones_tramos).create();
        var hastaDonde='';
        document.getElementById('grilla-ut-zona-derecha').appendChild(tablaTramos);
        this.desplegarRenglon = function(tramo, i_tramo){
            var celdas=[];
            tramo.inputs={};
            var classToggle=function(input,clase, sacoAgrego ){
                if(sacoAgrego){
                    input.classList.add(clase);
                }else{
                    input.classList.remove(clase);
                } 
            }
            var agregarPlaceholder=function(input, infoCampo){
                if(infoCampo.actualizaPlaceholder){
                   // var infoActividad = codigosActividad[tramo.codigo];
                   var infoActividad = actividades_codigos[tramo.codigo];
                    tramo.inputs[infoCampo.actualizaPlaceholder].placeholder=(infoActividad)?infoActividad.abr:'';
                }
            }
            var validarInput=function validarInput(input, infoCampo){
                if(input){
                    var valor = input.getTypedValue();
                    var invalido= valor==null?false: !infoCampo.validador.call(gu, valor, tramo);
                    classToggle(input,'edit-warning',invalido) 
                    agregarPlaceholder(input, infoCampo);
                }
            }
            var validarTramo=function validarTramo(){
                gu.estructuraTramo.forEach(function(infoCampo){
                    validarInput(tramo.inputs[infoCampo.nombre], infoCampo);
                });
                gu.habilitarRescate(tramo);
                var save_rta_ud=rta_ud;
                copia_ud.copia_enc=pk_ud.tra_enc;
                copia_ud.copia_hog=pk_ud.tra_hog;
                copia_ud.copia_mie=pk_ud.tra_mie;
                var save_id_ud=id_ud;
                rta_ud={};
                gu.estructuraTramo.forEach(function(infoCampo){
                    rta_ud["var_"+infoCampo.nombre] = tramo[infoCampo.nombre];
                });
                id_ud=id_ud+'t'+i_tramo;
                try{
                    gu.estructuraTramo.forEach(function(infoCampo){
                        if(infoCampo.nombre!='rescate'||actividades_codigos[tramo.codigo]&& actividades_codigos[tramo.codigo].rescatable ){  
                            aplicarConsistencias(estructura.formulario.UT[""], "var_"+infoCampo.nombre /*'var_codigo'*/,  "var_"+infoCampo.nombre/*'var_codigo'*/, 0, 0, tramo.inputs[infoCampo.nombre]/*tramo.inputs.codigo*/);
                        }   
                    });   
                    recontarFilas(tablaTramos);
                    rta_ud=save_rta_ud;
                    id_ud=save_id_ud;   
                }catch(err){
                    rta_ud=save_rta_ud;
                    id_ud=save_id_ud;
                    throw err;
                }
            }
            var tr=tablaTramos.insertRow(tablaTramos.rows.length);
            tr.className="renglon_variable";
            gu.estructuraTramo.forEach(function(infoCampo){
                var nombreVar=infoCampo.nombre;
                var input=null;
                input = html.input({type:infoCampo.tipo, "class":"edit-"+nombreVar}).create();
                if(infoCampo.tabindex){
                    input.tabIndex='-1';
                }
                TypedControls.adaptElement(input, {typeName:'text'});
                input.setTypedValue(tramo[nombreVar]||null);
                input.addEventListener('update',function(event){
                    sessionStorage['pantalla-especial-modifico-db']=true;
                    var valor=this.getTypedValue();
                    var valorCompletado = infoCampo.completador(valor);
                    grabar_todo();
                    if(valor!==valorCompletado){
                        this.setTypedValue(valorCompletado);
                    }
                    var valorAnterior=tramo[nombreVar];
                    tramo[nombreVar]=valorCompletado;
                    validarTramo();
                    if(valorAnterior != valorCompletado && tramo.rescatable && !infoCampo.rescate){
                        tramo.rescate='1';
                        tramo.inputs.rescate.setTypedValue(tramo.rescate);
                    }
                    gu.acomodar();
                    gu.desplegar_izquierda('grilla-ut-zona-izquierda', corYtotal);
                    if(i_tramo===gu.tramos.length-1){
                        var nuevaPosicion = gu.tramos.push(gu.renglonVacio())-1;
                        gu.desplegarRenglon(gu.tramos[nuevaPosicion], nuevaPosicion);
                        recontarFilas(tablaTramos);
                    }
                    document.getElementById('boton-cerrar').textContent=gu.acomodo.cargadoHasta=='24:00'?'cerrar':'cerrar incompleto';
                });
                tramo.inputs[nombreVar]=input;
                var celda=tr.insertCell(-1);
                celda.className="col-"+nombreVar;
                celda.appendChild(input);
            });
            tr.numeroOrdenFila=tablaTramos.childNodes.length-1;
            validarTramo();
        }
        this.tramos.forEach(this.desplegarRenglon);
        recontarFilas(tablaTramos);
        tablaTramos.parentNode.appendChild(html.button({id:'boton-cerrar'},'cerrar...').create());
        var botonCerrar=document.getElementById('boton-cerrar');
        botonCerrar.addEventListener('click',function(){
            var partes=location.pathname.split('/');
            partes.pop();
            partes.pop();
            partes.pop();
            gu.desplegar_rescate();
            var ruta=partes.join('/')+"/ut2016/ut2016.php";
            var pk_nuevo_ud='{"tra_ope":"ut2016","tra_for":"I1","tra_mat":""}';
            grabar_todo();
            /*
            if(rta_ud["var_d1"] || rta_ud["var_d2"]){
                if(/OS 7/i.test(navigator.userAgent) || /OS 8/i.test(navigator.userAgent) || /OS 9/i.test(navigator.userAgent) || /OS 10/i.test(navigator.userAgent)){
                    window.location.href=ruta+'?hacer=desplegar_formulario&todo='+pk_nuevo_ud;
                }else{
                    history.go(-1);
                }
            }
            */
        })
        document.getElementById('boton-cerrar').textContent=gu.acomodo.cargadoHasta=='24:00'?'cerrar':'cerrar incompleto';
        this.desplegar_izquierda('grilla-ut-zona-izquierda', corYtotal);
        if(rta_ud["var_d1"] || rta_ud["var_d2"]){
            this.desplegar_rescate();
        }
    }
    this.desplegar_izquierda = function desplegar_izquierda(idDiv, corYtotal){
        var offsetSup=25;
        var offsets={
            x_hora:0,
            x_min:25,
            x_act:40,
            x_act2:90,
            x_act3:140,
            x_fin: 190,
            x_anchoActividad:50
        }
        var separarHora = function separarHora(texto){
            var separado={};
            separado.hora=Number(texto.split(':')[0]);
            separado.min=Number(texto.split(':')[1]);
            separado.renglon=(separado.hora*60+separado.min)/medidas.minutosRenglon;
            return separado;
        }
        var max = function(a,b){return a>b?a:b; }
        var min = function(a,b){return a<b?a:b; }
        var colocarCaja = function colocarCaja(tramo, nombrecaja, desdeLimite, hastaLimite, i_columna, correcionX, correccionY, propiedad){
        
            var desde=separarHora(max(min(tramo.desde,hastaLimite),desdeLimite));
            var hasta=separarHora(max(min(tramo.hasta,hastaLimite),desdeLimite));
            if(!tramo[nombrecaja]){
                tramo[nombrecaja] = html.div({"class":["caja-fija"]}).create();
                tramo[nombrecaja].style.display='none';
                document.getElementById(idDiv).appendChild(tramo[nombrecaja]);
            }
            var caja = tramo[nombrecaja];
            if(desde.renglon<hasta.renglon){
                if(caja.desde != tramo.desde ||caja.hasta != tramo.hasta || caja.codigo != tramo.codigo){
                    if(i_columna==='agujero'){
                        //caja.textContent='agujero'
                        caja.style.left=correcionX + offsets.x_act - medidas.separacionActividad/2 + 'px'; 
                        caja.style.width=offsets.x_anchoActividad * medidas.cantAct + 'px';
                        caja.style.backgroundColor=colorAgujero;
                    }else{
                        caja.textContent=tramo.codigo;
                        caja.style.left=correcionX + offsets.x_act+(i_columna>medidas.cantAct-1?2:i_columna)*offsets.x_anchoActividad + 'px';
                        caja.style.width=offsets.x_anchoActividad - medidas.separacionActividad + 'px';
//                        var infoActividad = codigosActividad[tramo.codigo];
                        var infoActividad = actividades_codigos[tramo.codigo];
                        if(infoActividad){
                            caja.style.backgroundColor=infoActividad.color || colorOtros;
                            caja.appendChild(html.br().create());
                            caja.appendChild(html.img({"class": "ico-actividad", src:'img/act_'+tramo.codigo+'.png', alt:'...'}).create());
                            caja.appendChild(html.br().create());
                            caja.appendChild(html.span({"class": "abr-actividad"}, infoActividad.abr).create());
                        }else{
                            caja.style.backgroundColor=colorInvalido;
                            caja.appendChild(html.br().create());
                            caja.appendChild(html.img({"src": "mini_Error.png"}).create());
                        }
                    }
                    caja.style.top=correccionY + offsetSup+desde.renglon*medidas.pixelPorRenglon + 'px';
                    caja.style.height=(hasta.renglon-desde.renglon)*medidas.pixelPorRenglon +'px';
                    if(hasta.renglon-desde.renglon>1){
                        caja.style.fontSize='100%';
                    }
//                    caja.style.display='';
                    caja.style.display=propiedad;
                    caja.desde = tramo.desde;
                    caja.desde = tramo.desde;
                    caja.desde = tramo.desde;
                }
                caja.style.display=propiedad;
            }else{
                caja.style.display='none';
            }
        }
        this.acomodo.columnas.forEach(function(columna, i_columna){
            columna.forEach(function(tramo){
                /*if(tramo.desde && tramo.hasta){
                    cortes.forEach(function(info){
                        colocarCaja(tramo, info.id, info.desde, info.hasta, i_columna,  info.corX, info.corY+corYtotal);
                    });
                }*/
                if(!tramo.hasta || !tramo.desde){
                    var propiedad='none';
                }else{propiedad='';}
                cortes.forEach(function(info){
                    colocarCaja(tramo, info.id, info.desde, info.hasta, i_columna,  info.corX, info.corY+corYtotal,propiedad);
                });
            });
        });
        this.acomodo.agujeros.forEach(function(agujero){
            var propiedad='';
            cortes.forEach(function(info){
                colocarCaja(agujero, info.id, info.desde, info.hasta, 'agujero',  info.corX, info.corY+corYtotal,propiedad);
            });
        });
    };
    this.desplegar_rescate=function(){
        var typeInfo={
            typeName:"enum",
            showOption: true,
            options:[
                {option: '1_', label: 'Sí, aunque no lo mencioné todas las veces'},
                {option: '2_', label: 'Sí, ya lo mencioné todas las veces'},
                {option: '3_', label: 'No'}
            ]
        };
        var tablaRescate=document.getElementById("tabla-rescate");
        var cartelRescate=document.getElementById('cartel-rescate');
        if(!tablaRescate){
            tablaRescate=html.table({id:"tabla-rescate"}).create();
            var filaRescate=html.tr([html.td({colspan:2},[
                tablaRescate
            ])]);
            document.getElementById('grilla-ut-tabla-externa').appendChild(filaRescate.create());
            var controlesRescate={};
            defPreguntasRescate.forEach(function(def){
                var typeInfo={
                    typeName:"enum",
                    showOption: true,
                    options:O_map(estructura.formulario.I1[""]["var_"+def.var].opciones, function(opcion, idOpcion){
                        return {option:idOpcion, label:opcion.texto};
                    })
                };
                var control=TypedControls.bestCtrl(typeInfo).create();
                controlesRescate[def.var]=control;
                var textoPregunta=preguntas[def.pre].pre_texto;
                TypedControls.adaptElement(control,typeInfo);
                control.addEventListener('update',function(){
                    rta_ud["var_"+def.var]=this.getTypedValue();
                    if(controlesRescate.d1.getTypedValue()==1 && controlesRescate.d2.getTypedValue() || controlesRescate.d2.getTypedValue()==1){
                        cartelRescate.textContent='Encuestador, pregunte cuándo y corrija la grilla de actividades'
                    }else{
                        cartelRescate.textContent=''
                    }
                    gu.tramos.forEach(function(tramo,i_tramo){
                        gu.habilitarRescate(tramo);
                    });
                });
                tablaRescate.appendChild(html.tr([html.td(textoPregunta), html.td([control])]).create());
                control.setTypedValue(rta_ud["var_"+def.var]);
            });
            if(!cartelRescate){
                cartelRescate=html.span({id:'cartel-rescate'}).create();
            }
//            tablaRescate.appendChild(html.tr([html.td(),html.td()]))
            var botonCerrar=document.getElementById('boton-cerrar');
            document.getElementById('tabla-rescate').appendChild(html.tr([html.td({colspan:2},[botonCerrar,cartelRescate])]).create());
            botonCerrar.addEventListener('click',function(){
                gu.desplegar_rescate();
                var partes=location.pathname.split('/');
                partes.pop();
                partes.pop();
                partes.pop();
                var ruta=partes.join('/')+"/ut2016/ut2016.php";
                var pk_nuevo_ud='{"tra_ope":"ut2016","tra_for":"I1","tra_mat":""}';
                grabar_todo();
                if(/OS 7/i.test(navigator.userAgent) || /OS 8/i.test(navigator.userAgent) || /OS 9/i.test(navigator.userAgent) || /OS 10/i.test(navigator.userAgent)){
                    window.location.href=ruta+'?hacer=desplegar_formulario&todo='+pk_nuevo_ud;
                }else{
                    history.go(-1);
                }
            })
            
        }
        /*crearCartelRepreguntar=function(d1,d2){
            if(d2!=null && (d1='1' or d2='1')){
                var divCartelRepreguntar=html.div({id:'cartel-repreguntar'},'Repregunte')
                document.getElementById('tabla-rescate').appendChild(divCartelRepreguntar.creatr());
            }
        }*/
        /*
        var botonCerrar=document.getElementById('boton-cerrar');
        document.getElementById('div-rescate').appendChild(botonCerrar)
        botonCerrar.addEventListener('click',function(){
            gu.desplegar_rescate();
            var partes=location.pathname.split('/');
            partes.pop();
            partes.pop();
            partes.pop();
            var ruta=partes.join('/')+"/ut2016/ut2016.php";
            var pk_nuevo_ud='{"tra_ope":"ut2016","tra_for":"I1","tra_mat":""}';
            grabar_todo();
            
            
            //if(rta_ud["var_d1"] && rta_ud["var_d2"]){
                if(/OS 7/i.test(navigator.userAgent) || /OS 8/i.test(navigator.userAgent) || /OS 9/i.test(navigator.userAgent) || /OS 10/i.test(navigator.userAgent)){
                    window.location.href=ruta+'?hacer=desplegar_formulario&todo='+pk_nuevo_ud;
                }else{
                    history.go(-1);
                }
            //}
        })
        */
    }
}

GrillaUt.defPreguntasRescate=defPreguntasRescate;

return GrillaUt;

});

window.addEventListener('keypress',function(event){
    if((event.key=='?' || event.key=='¿' || event.keyCode==63 || event.keyCode==191)  && event.target.parentNode.className=='col-codigo'){
        dialogManual().then(function(codigo){
            if(codigo && event.target.parentNode.className=='col-codigo'){
                event.target.setTypedValue(codigo);
                var updateEvent=new Event('update');
                event.target.dispatchEvent(updateEvent);
            }
        });
        event.preventDefault();
    }
})