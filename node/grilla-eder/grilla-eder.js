"use strict";
/*jshint eqnull:true */
/*jshint node:true */

/*jshint -W089 */
/*jshint -W116 */
/*jshint -W032 */
/*jshint -W004 */
/* global pk_ud */
/* global id_ud */
/* global rta_ud */

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
})(/*jshint -W040 */this, 'GrillaEder', function() {
/*jshint +W040 */


if(typeof window == 'undefined'){
    var jsToHtml = require('js-to-html');
    var TypedControls=require('typed-controls.js');
    var estructura_eder=require('estructura_eder2017.js');
}else{
    var jsToHtml = window.jsToHtml;
    var TypedControls=window.TypedControls;
    //var estructura_eder=window.estructura_eder;
    var estructura_eder_preguntas=window.preguntas;
    var estructura_eder_variables=window.variables;
    var estructura_eder_estructura=window.estructura;
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
    var lugar = document.getElementById('grilla-eder-zona-izquierda').childNodes[0].childNodes[0].childNodes[4];
    lugar.textContent=mensaje;
}

function is_integer(x){
    return (typeof x === 'number') && (x % 1 === 0);
}

function GrillaEder(){
    var colorOtros='#49FFFF';
    var colorInvalido='#FFED66';
    var colorAgujero='rgba(255,0,0,0.5)'
    var ge = this;
    ge.anio_actual= parseInt(new Date().getFullYear());
    ge.titulo=function(){
        var tit='';
        for( var xpk in pk_ud){
            var xx=xpk.slice(4);
            if (!(xx =='ope' ||xx =='mat'||xx =='exm')){
                tit=tit + xpk.slice(4) + ':'+ pk_ud[xpk] + ' ';
            };
        };
        // Falta agregar titulo de grilla, puede ser mejor que sea un cjto de items
        tit= tit+'  -  '+variable_especial;
        return tit;
    }
    function grabar_todo(){
        var lineas_a_grabar=ge.lineas.map(function(linea){
            var linea_puro={};
            ge.estructuraLinea.forEach(function(infoCampo){
                linea_puro[infoCampo.nombre]=linea[infoCampo.nombre];
            });
            return linea_puro;
        }).filter(function(linea){
            return linea.anio || linea.edad;
        });
        ge.datos_matriz[ge.columna_actual].lineas=lineas_a_grabar;
        var fija_puro={};
        for(var vfija in ge.estructuraFija){
            var infoCampo=ge.estructuraFija[vfija];
            var nombreVar=infoCampo.nombre;
            fija_puro[infoCampo.nombre]=ge.fijas[infoCampo.nombre];
        };
        ge.datos_matriz[ge.columna_actual].fijas=fija_puro;
        var datos_matriz_json=JSON.stringify(ge.datos_matriz);
        rta_ud['var_'+variable_especial]=datos_matriz_json;
        localStorage.setItem("ud_"+id_ud, JSON.stringify(rta_ud));
    }
    ge.renglonVacio=function(){ 
         var renglonv={
            anio:null ,
            edad:null ,
        }
        var e_grilla=this.estructuraLinea;
        for ( var xvar in e_grilla ){
            renglonv[xvar]=null;
        };
        return renglonv /*{anio:null, edad:null, col2123:null, colesp:null   };*/ /*{desde:null, hasta:null, codigo:null, detalle:null};*/ 
    };
    ge.fijasVacio=function(){ 
        var fijasv={};
        var e_grilla=this.estructuraFija;
        for ( var xvar in e_grilla ){
            if (e_grilla[xvar].var_fija){        
                fijasv[xvar]=null;
            }
        };
        return fijasv; 
    };
    
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
        var horaSeparada=ge.separaHoraTexto(hora);
        hora=(horaSeparada.hora.length==1)?'0'+hora:hora;
        horaSeparada=ge.separaHoraTexto(hora);
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
       //opc_var[xvar]=estFor['var_'+xvar].opciones||null;
        var desde=registroConDesdeHasta.desde;
        var hasta=registroConDesdeHasta.hasta;
        var rangoInvalido = hasta != null && desde != null && hasta<=desde;
        return this.validarHora(hora) && !rangoInvalido;
    }
    this.validarEdad=function(pvar){
        return  pvar>=this.retrospectiva && pvar<=this.edad+1;
    }
    this.validarAnnio=function(pvar){
        return pvar>=(this.anio_actual -1 - this.edad) && pvar<=this.anio_actual;
    }
    this.variablesQueNoPuedenTenerCero={'lugar3':true, 'hijos2':true}; //consultar cuales son las variables no pueden tener cero
    this.validarOpciones = function (pvar, registro,nombreCampo){
       if(pvar=='0'){
            return !(this.variablesQueNoPuedenTenerCero[nombreCampo]||false);
            
       }else{
            return this.opc_var[nombreCampo]==null ||this.opc_var[nombreCampo][pvar];
       }    
    };
    this.recuperarMetadatos = function (variable_especial,grilla){
      var estructura_grilla={}; 
      var estVar=estructura_eder_variables;
      var estFor=estructura_eder_estructura.formulario.I1["Z"];
      var opc_var={};
      var primera='';
      for (var xvar in estVar){
        if(estVar[xvar].var_for=='I1' && estVar[xvar].var_mat=='Z' && estVar[xvar].var_grilla==grilla){
           estructura_grilla[xvar]=estVar[xvar];
           opc_var[xvar]=estFor['var_'+xvar].opciones||null;
           if(primera==''){primera=xvar};
        }
      };
      this.es_repetitiva=estructura_eder_preguntas[estVar[primera].var_pre].pre_repetitiva?true:false;
      this.retrospectiva=estructura_eder_preguntas[estVar[primera].var_pre].pre_retrospectiva;
      this.estructura_grilla=estructura_grilla;
      cargar_otras_rta();
      this.edad=parseInt(dbo.edadfamiliar(pk_ud.tra_enc, pk_ud.tra_hog, pk_ud.tra_mie));
      this.fechaNacimiento=parseInt(dbo.anionac(pk_ud.tra_enc, pk_ud.tra_hog, pk_ud.tra_mie))
      //this.cantidadAnios=dbo.edad_a_la_fecha(this.fechaNacimiento+'-01-01','1954-01-01')
      this.opc_var=opc_var;
    };
    this.armarEstructuraLinea=function (variable_especial,grilla){ 
        this.recuperarMetadatos(variable_especial,grilla);     
        var estructuraLinea=[{nombre:'anio'  ,tipo:'tel' , ancho:'50',completador:nocompletar, validador:this.validarAnnio},
                           {nombre:'edad'  ,tipo:'tel' , ancho:'40',completador:nocompletar, validador:this.validarEdad}
        ];
        var estructuraFija={};
        var estructura_grilla=this.estructura_grilla;
        for (var xvar in estructura_grilla ){
            var esAngosto=estructura_grilla[xvar].var_tipovar=='opciones'||estructura_grilla[xvar].var_tipovar=='si_no';
            var xtipo=(estructura_grilla[xvar].var_tipovar =='texto' || estructura_grilla[xvar].var_tipovar =='texto_especificar'
                || estructura_grilla[xvar].var_tipovar =='texto_libre')?'texto':'tel'; // esto es prueba. Considerar otros tipos y revisar
            if (estructura_grilla[xvar].var_fija){
                estructuraFija[xvar]={nombre:estructura_grilla[xvar].var_var, tipo: xtipo, completador:nocompletar, validador:this.validarOpciones}; 
            }else{
                estructuraLinea.push({nombre:estructura_grilla[xvar].var_var, titulo:estructura_grilla[xvar].var_texto, tipo: xtipo, ancho:esAngosto?'40':'173' ,completador:nocompletar, validador:this.validarOpciones});
            }
        };
        this.estructuraLinea=estructuraLinea;
        this.estructuraFija=estructuraFija;
    };
    /*
    this.estructuraLinea=[

      //  {nombre:'desde'  ,tipo:'tel' , completador:this.completarHora, validador:this.validarHoraYRango},
      //  {nombre:'codigo' ,tipo:'tel' , completador:nocompletar       , validador:this.validarActividad , actualizaPlaceholder:'detalle'},
       
        {nombre:'anio'  ,tipo:'tel' , completador:nocompletar, validador:novalidar},
        {nombre:'edad'  ,tipo:'tel' , completador:nocompletar, validador:novalidar},
        {nombre:'col2123' ,tipo:'text' , completador:nocompletar       , validador:novalidar }, //,         actualizaPlaceholder:'detalle' 
        {nombre:'colesp',tipo:'text' , completador:nocompletar       , validador:novalidar             , tabindex:true, rescate:true},
    ]
    */
    this.garantizarColumna = function garantizarColumna(i){
        if(!(this.datos_matriz instanceof Array)){
            this.datos_matriz=[];
        }
        while(this.datos_matriz.length<=i){
            this.datos_matriz.push({
                lineas:[],
                fijas:{}
            })
        }
    }
    this.inicializar = function(datos_matriz){
        this.datos_matriz = datos_matriz;
        this.columna_actual = this.columna_actual||0;
        this.garantizarColumna(this.columna_actual);
        this.cargar(this.datos_matriz[this.columna_actual].lineas, this.datos_matriz[this.columna_actual].fijas)
    }
    this.cargar = function cargar(lineas, fijas){
        this.lineas = lineas;
        if(!this.lineas.length || this.lineas[this.lineas.length-1].edad){
            this.lineas.push(this.renglonVacio());
        }
        this.fijas=this.estructuraFija!=={}?(Object.keys(fijas).length? fijas:this.fijasVacio()): {} ;
        //this.fijas=this.fijasVacio();
    }
    this.acomodar = function acomodar(){
        var lineas = this.lineas; 
        /*if(this.acomodo){
            this.acomodo.agujeros.forEach(function(agujero){
                cortes.forEach(function(corte){
                    if(agujero[corte.id]){
                        agujero[corte.id].parentNode.removeChild(agujero[corte.id]);
                    }
                });
            });
        }*/
        this.acomodo = {
            columnas:[],
            //agujeros:[],
            //cargadoHasta:''
        };
        var ancho = function(c){
            if(c==null){
                return 'zzzzzzzzzz';
            }
            if(typeof c !== 'string'){
                c=c+'';
            }
            while(c.length<10) c= ' ' + c;
            return c;
        }
        //var invertir = function(t){
        //    return t.split('').map(function(letra){
        //        return String.fromCharCode('|'.charCodeAt(0)-letra.charCodeAt(0));
        //    }).join('');
        //}
        var lindo = function(x){
            return ancho(x.edad)+'/'+ancho(x.anio)
        }
        lineas.sort(function(x,y){
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
        return ;
        this.acomodo.cargadoHasta=lineas[lineas.length-1].hasta;
        var columnas = this.acomodo.columnas;
        columnas.push([lineas[0]]);
        var actual;
        for(var i=1;i<lineas.length;i++){
            actual=lineas[i];
            var j=0;
            var ubicado= false;
            while (j<columnas.length){
                var colj=columnas[j];
                var cotacol=colj[colj.length-1];
                if (actual.anio>= cotacol.anio ){
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
        if (lineas[0].desde>'00:00'){
            agujeros.push({desde:'00:00', hasta:lineas[0].desde});
        };
        var cargado_total=lineas[0].hasta;
        for(var i=1;i<lineas.length;i++){
            if (lineas[i].desde>cargado_total){
                var agujero={};
                agujero.desde=cargado_total;
                agujero.hasta=lineas[i].desde;
                agujeros.push(agujero);
            } 
            cargado_total= cargado_total<lineas[i].hasta? lineas[i].hasta: cargado_total;
        }
    }
    this.getRect = function getRect(element){
        var rect = {top:0, left:0, width:element.offsetWidth, height:element.offsetHeight};
        while( element != null ) {
            rect.top += element.offsetTop;
            rect.left += element.offsetLeft;
            element = element.offsetParent;
        }
        return rect;
    }
    this.desplegar = function desplegar(idDivDestino, corYtotal){
        var ge = this;
        document.getElementById(idDivDestino).innerHTML='';
        this.filasLaterales={};
        var titEncuestaGrilla=html.div({id:'titulo-Encuesta', "class": "cabezal_matriz"}).create();
        titEncuestaGrilla.textContent=ge.titulo();
        document.getElementById(idDivDestino).appendChild(titEncuestaGrilla);
        var array_botones=[];
        var agregar_boton_columna = function(columna, i){
            console.log('boton',i)
            var boton=html.button(
                {class:"boton-columna","numero-columna":i,"es-columna-actual":i==ge.columna_actual},
                [i==ge.datos_matriz.length?'+':(i+1).toString()]
            ).create();
            boton.onclick=function(){
                grabar_todo();
                ge.columna_actual = Number(this.getAttribute('numero-columna'));
                ge.garantizarColumna(ge.columna_actual);
                ge.cargar(ge.datos_matriz[ge.columna_actual].lineas,ge.datos_matriz[ge.columna_actual].fijas)
                ge.desplegar(idDivDestino, corYtotal);
            }
            array_botones.push(html.td({"es-columna-actual":i==ge.columna_actual},[boton]).create());
        };
         if (ge.es_repetitiva){
            ge.datos_matriz.map(agregar_boton_columna);
            agregar_boton_columna(null, ge.datos_matriz.length);
            var botonera=html.table({class:'botonera'}, [html.tr(array_botones)]).create();
            document.getElementById(idDivDestino).appendChild(botonera);
         };
        // poner la parte fija aca.
        corYtotal=corYtotal||0;
        var tabla=html.table({id:'grilla-eder-tabla-externa'},[
            html.tr([
                html.td({id:'grilla-eder-zona-izquierda'}),
                html.td({id:'grilla-eder-zona-derecha'}),
            ])
        ]);
        document.getElementById(idDivDestino).appendChild(tabla.create());
        var tablaFijas=html.table({id:'tabla-fijas-eder'}).create(); 
        document.getElementById('grilla-eder-zona-izquierda').appendChild(tablaFijas);        
       //hasta acá parte fija
        var renglones_lineas=[];
        
        //console.log("###################",estructura_eder['LR22'].pre_texto)
        
        var listath=[
            html.th({"class":"col-anio"     },'Anio'                  ),
            html.th({"class":"col-edad"     },'Edad'                  ),
        ]
        var e_grilla=this.estructura_grilla;
        for ( var xvar in e_grilla ){
            if(!e_grilla[xvar].var_fija){
                listath.push(html.th({"class":"col-"+xvar}, e_grilla[xvar].var_texto));
            }
        };
        renglones_lineas.push(html.tr( 
            listath
        ));
        var tablaLineas=html.table({id:'tabla-lineas-eder'},renglones_lineas).create();
        var hastaDonde='';
        document.getElementById('grilla-eder-zona-izquierda').appendChild(tablaLineas);
        this.desplegarRenglon = function(linea, i_linea){
            var celdas=[];
            linea.inputs={};
            var classToggle=function(input,clase, agregoClase ){
                if(agregoClase){
                    input.classList.add(clase);
                }else{
                    input.classList.remove(clase);
                }
            }
            var agregarPlaceholder=function(input, infoCampo){
                if(infoCampo.actualizaPlaceholder){
                   // var infoActividad = codigosActividad[linea.codigo];
                   var infoActividad = actividades_codigos[linea.codigo];
                    linea.inputs[infoCampo.actualizaPlaceholder].placeholder=(infoActividad)?infoActividad.abr:'';
                }
            }
            var validarInput=function validarInput(input, infoCampo,linea){
                if(input){
                    var valor = input.getTypedValue();
                    var invalido= valor==null?false: !infoCampo.validador.call(ge, valor, linea,infoCampo.nombre);
                    if(infoCampo.nombre==='anio'){
                        invalido=invalido || (linea.anio && linea.edad && Math.abs(linea.anio-linea.edad-ge.fechaNacimiento)>1)
                    }
                    if(!linea.edad && infoCampo.nombre!='anio' && infoCampo.nombre!='edad' && valor){
                        classToggle(linea.inputs.edad,'edit-warning',true) 
                    }
                    classToggle(input,'edit-warning',invalido) 
                    agregarPlaceholder(input, infoCampo);
                }
            }
            var validarLinea=function validarLinea(){
                ge.estructuraLinea.forEach(function(infoCampo){
                    validarInput(linea.inputs[infoCampo.nombre], infoCampo,linea);
                });
                var save_rta_ud=rta_ud;
                copia_ud.copia_enc=pk_ud.tra_enc;
                copia_ud.copia_hog=pk_ud.tra_hog;
                copia_ud.copia_mie=pk_ud.tra_mie;
                var save_id_ud=id_ud;
                rta_ud={};
                ge.estructuraLinea.forEach(function(infoCampo){
                    rta_ud["var_"+infoCampo.nombre] = linea[infoCampo.nombre];
                });
                id_ud=id_ud+'t'+i_linea;
                try{ // ESTO PARA CONSISTENCIAS CREO QUE AGREGARON UNA TABLA AUXILIAR PARA MANEJARLAS.
                //    ge.estructuraLinea.forEach(function(infoCampo){
                   //         aplicarConsistencias(estructura.formulario.EDER[""], "var_"+infoCampo.nombre /*'var_codigo'*/,  "var_"+infoCampo.nombre/*'var_codigo'*/, 0, 0, tramo.inputs[infoCampo.nombre]/*tramo.inputs.codigo*/);
                //         
                //    });   
                    recontarFilas(tablaLineas);
                    rta_ud=save_rta_ud;
                    id_ud=save_id_ud;   
                }catch(err){
                    rta_ud=save_rta_ud;
                    id_ud=save_id_ud;
                    throw err;
                }
            }
            var tr=tablaLineas.insertRow(tablaLineas.rows.length);
            tr.className="renglon_variable";
            ge.estructuraLinea.forEach(function(infoCampo){
                var nombreVar=infoCampo.nombre;
                var input=null;
                input = html.input({type:infoCampo.tipo, "class":"edit-"+infoCampo.tipo}).create();
                if(infoCampo.tabindex){
                    input.tabIndex='-1';
                }
                TypedControls.adaptElement(input, {typeName:'text'});
                input.setTypedValue(linea[nombreVar]||null);
                input.addEventListener('update',function(event){
                    sessionStorage['pantalla-especial-modifico-db']=true;
                    var valor=this.getTypedValue();
                    var valorCompletado = infoCampo.completador(valor);
                    grabar_todo();
                    if(valor!==valorCompletado){
                        this.setTypedValue(valorCompletado);
                    }
                    var valorAnterior=linea[nombreVar];
                    linea[nombreVar]=valorCompletado;
                    validarLinea();
                    ge.acomodar();
                    ge.desplegar_derecha('grilla-eder-zona-derecha', corYtotal);
                    if(i_linea===ge.lineas.length-1 && valor){
                        var nuevaPosicion = ge.lineas.push(ge.renglonVacio())-1;
                        ge.desplegarRenglon(ge.lineas[nuevaPosicion], nuevaPosicion);
                        recontarFilas(tablaLineas);
                    }
                    //document.getElementById('boton-cerrar').textContent='cerrar';//ge.acomodo.cargadoHasta=='24:00'?'cerrar':'cerrar incompleto';
                });
                linea.inputs[nombreVar]=input;
                var celda=tr.insertCell(-1);
                celda.className="col-"+nombreVar;
                celda.appendChild(input);
            });
            tr.numeroOrdenFila=tablaLineas.childNodes.length-1;
            validarLinea();
        }
      //****desplegar para Fijas
        this.desplegarRenglonFijas = function(fija){
            var celdas=[];
            fija.inputs={};
            var classToggle=function(input,clase, agregoClase ){
                if(agregoClase){
                    input.classList.add(clase);
                }else{
                    input.classList.remove(clase);
                } 
            }
            var agregarPlaceholder=function(input, infoCampo,data){
                if(infoCampo.actualizaPlaceholder){
                   // var infoActividad = codigosActividad[tramo.codigo];
                   var infoActividad = actividades_codigos[data.codigo];
                    data.inputs[infoCampo.actualizaPlaceholder].placeholder=(infoActividad)?infoActividad.abr:'';
                }
            }
            var validarInput=function validarInput(input, infoCampo, data){
                if(input){
                    var valor = input.getTypedValue();
                    var invalido= valor==null?false: !infoCampo.validador.call(ge, valor, data,infoCampo.nombre);
                    classToggle(input,'edit-warning',invalido) 
                    agregarPlaceholder(input, infoCampo);
                }
            }
            var validarFijas=function validarFijas(){
                for(var vfija in ge.estructuraFija){
                    var infoCampo=ge.estructuraFija[vfija];
                    validarInput(ge.fijas.inputs[infoCampo.nombre], infoCampo,fija);
                };
                /* 
                
              //  ge.habilitarRescate(tramo);
                var save_rta_ud=rta_ud;
                copia_ud.copia_enc=pk_ud.tra_enc;
                copia_ud.copia_hog=pk_ud.tra_hog;
                copia_ud.copia_mie=pk_ud.tra_mie;
                var save_id_ud=id_ud;
                rta_ud={};
                ge.estructuraTramo.forEach(function(infoCampo){
                    rta_ud["var_"+infoCampo.nombre] = tramo[infoCampo.nombre];
                });
                id_ud=id_ud+'t'+i_tramo;
                try{ // ESTO PARA CONSISTENCIAS CREO QUE AGREGARON UNA TABLA AUXILIAR PARA MANEJARLAS.
                    ge.estructuraTramo.forEach(function(infoCampo){          
                        if(infoCampo.nombre!='rescate'||actividades_codigos[tramo.codigo]&& actividades_codigos[tramo.codigo].rescatable ){  
                   //         aplicarConsistencias(estructura.formulario.EDER[""], "var_"+infoCampo.nombre ,  "var_"+infoCampo.nombre, 0, 0, tramo.inputs[infoCampo.nombre]);
                        null;    
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
                */
            }
            for(var vfija in ge.estructuraFija){
                var tr=tablaFijas.insertRow(tablaFijas.rows.length);
                tr.className="renglon_variable";
                
                var infoCampo=ge.estructuraFija[vfija];
                var nombreVar=infoCampo.nombre;
                var input=null;
                input = html.input({type:infoCampo.tipo, "class":"edit-"+infoCampo.tipo, id: 'i'+nombreVar}).create();
                if(infoCampo.tabindex){
                    input.tabIndex='-1';
                }
                TypedControls.adaptElement(input, {typeName:'text'});
                input.setTypedValue(fija[nombreVar]||null);
                
                input.addEventListener('update',function(event){
                    sessionStorage['pantalla-especial-modifico-db']=true;
                    var valor=this.getTypedValue();
                    var valorCompletado = infoCampo.completador(valor);
                    if(valor!==valorCompletado){
                        this.setTypedValue(valorCompletado);
                    }
                    var nombreVar=this.getAttribute('id').slice(1);
                    var valorAnterior=ge.fijas[nombreVar];
                    ge.fijas[nombreVar]=valorCompletado;
                    grabar_todo();
                    validarInput(ge.fijas.inputs[nombreVar], ge.estructuraFija[nombreVar],fija);
                    //validarLinea();
                    ge.acomodar();
                    //ge.desplegar_derecha('grilla-eder-zona-derecha', corYtotal);
                    //if(i_linea===ge.tramos.length-1){
                    //    var nuevaPosicion = ge.tramos.push(ge.renglonVacio())-1;
                    //    ge.desplegarRenglon(ge.tramos[nuevaPosicion], nuevaPosicion);
                    //    recontarFilas(tablaLineas);
                    //}
                    //document.getElementById('boton-cerrar').textContent='cerrar';//ge.acomodo.cargadoHasta=='24:00'?'cerrar':'cerrar incompleto';
                });
                fija.inputs[nombreVar]=input;
                
                //var filaFija=[html.td({"class":"col-"+nombreVar}, infoCampo.var_texto)),
                //    html.td({"class":"col-"nombreVar}, input))
                //];
                var celdaH=html.td({"class":"col-"+nombreVar}, ge.estructura_grilla[nombreVar].var_texto).create(); 
                var celda=tr.insertCell(-1);
                celda.className="hdr-var";
                celda.appendChild(celdaH);
                var celdaI=tr.insertCell(-1);
                celdaI.className="col-"+nombreVar;
                celdaI.appendChild(input);
                tr.numeroOrdenFila=tablaFijas.childNodes.length-1;
            };
            //validarLinea();
        }
        //**** desplegar para fijas
        this.desplegarRenglonFijas(this.fijas);
        //****hasta aqui fijas
        
        this.lineas.forEach(this.desplegarRenglon);
        recontarFilas(tablaLineas);
        tablaLineas.parentNode.appendChild(html.button({id:'boton-cerrar'},'Cerrar').create());
        var botonCerrar=document.getElementById('boton-cerrar');
        botonCerrar.addEventListener('click',function(){
            var partes=location.pathname.split('/');
            partes.pop();
            partes.pop();
            partes.pop();
            //* cambiar porque esta fijo*//
            var ruta=partes.join('/')+"/eder2017/eder2017.php";
            var pk_nuevo_ud='{"tra_ope":"eder2017","tra_for":"I1","tra_mat":""}';
            grabar_todo();
            if(/OS 7/i.test(navigator.userAgent) || /OS 8/i.test(navigator.userAgent) || /OS 9/i.test(navigator.userAgent) || /OS 10/i.test(navigator.userAgent)){
                window.location.href=ruta+'?hacer=desplegar_formulario&todo='+pk_nuevo_ud;
            }else{
                history.go(-1);
            }
            
        })
        //document.getElementById('boton-cerrar').textContent=='cerrar';//ge.acomodo.cargadoHasta=='24:00'?'cerrar':'cerrar incompleto';
        this.desplegar_derecha('grilla-eder-zona-derecha', corYtotal);
    }
    this.parametrosZonaDerecha={
        label:{
            columna:{
                top:0,
                left:0,
                width:50
            },
            fila:{
                top:0,
                left:0,
                height:13,
                width:50,
                ini:0,
                fin:70
            }
        },
        fila:{
            height:12
        },
        especial:{
            anioNacimiento:1980
        }
    }
    this.desplegar_derecha = function desplegar_derecha(idDiv, corYtotal){
        var ge=this;
        var zonaDerecha=document.getElementById('grilla-eder-zona-derecha');
        var rect=ge.getRect(zonaDerecha);
        ge.parametrosZonaDerecha.limites={
            top:rect.top,
            left:rect.left
        };
        var edadIni=ge.parametrosZonaDerecha.label.fila.ini;
        var edadFin=ge.parametrosZonaDerecha.label.fila.fin;
        var crearDivUbicado=function crearDivUbicado(top,left,height,width,clase,contenido){
            var div = html.div({class: clase}).create();
            div.style.boxSizing='border-box';
            div.style.position='absolute';
            div.style.overflow='hidden';
            div.style.top=top+'px';
            div.style.left=left+'px';
            div.style.height=(height=='auto')?height:height+'px';
            div.style.width=(width=='auto')?'auto':width+'px';
            div.innerHTML=(contenido||contenido===0)?contenido:'';
            div.style.borderBottom='1px solid #222';
            div.style.borderLeft='1px solid #222';
            div.style.fontFamily='courier new';
            div.style.fontSize='80%';
            if(width<80 || true){
                div.style.textAlign='center';
            }
            if(edad%2==1){
                div.style.backgroundColor='#DDD';
            }
            if(edad%10==9){
                div.style.borderBottom='2px solid black';
            }
            div.style.fontWeight='bold';
            return div;
        };
        var columnas=['anio','edad'];
        var e_grilla=ge.estructura_grilla;
        ge.nombreColumna=ge.nombreColumna||{'anio':'año'};
        for ( var xvar in e_grilla ){
            ge.nombreColumna[xvar]=e_grilla[xvar].var_texto;
            if(!e_grilla[xvar].var_fija){
                columnas.push(e_grilla[xvar].var_var)
            }
        };
        var anchosTipo={
            texto_especificar:150,
            texto_libre:130
        };
        var posTop=ge.parametrosZonaDerecha.limites.top+ge.parametrosZonaDerecha.label.fila.height;
        var posLeft=ge.parametrosZonaDerecha.limites.left;
        var labels=columnas.map(function(columna,iColumna){
            var width = anchosTipo[(e_grilla[columna]||{}).var_tipovar]||ge.parametrosZonaDerecha.label.columna.width;
            var div=crearDivUbicado(
                ge.parametrosZonaDerecha.limites.top,
                posLeft,
                ge.parametrosZonaDerecha.label.fila.height,
                width,
                'label',
                ge.nombreColumna[columna]||columna
            );
            posLeft=posLeft+width;
            return div;
        })
        this.filasLaterales=this.filasLaterales||{};
        for(var edad=ge.retrospectiva||edadIni;edad<=edadFin;edad++){
            var posLeft=ge.parametrosZonaDerecha.limites.left
            var listaRespuesta=[];
            var objetoRespuesta=this.filasLaterales[edad]||{};
            var existe=ge.lineas.filter(function(linea){
                return linea.edad==edad;
            });
            columnas.forEach(function(columna){
                var existeAnterior=ge.lineas.filter(function(linea){
                    return linea.edad<edad && linea[columna]!=null && linea[columna]!=='';
                });
                var width = anchosTipo[(e_grilla[columna]||{}).var_tipovar]||ge.parametrosZonaDerecha.label.columna.width;
                var contenidoColumnaFija=columna=='edad'?edad:'';
                var control=objetoRespuesta[columna]
                if(!control){
                    control=crearDivUbicado(posTop,posLeft,ge.parametrosZonaDerecha.fila.height,width,'respuestas',contenidoColumnaFija)
                    listaRespuesta.push(control)
                }
                objetoRespuesta[columna]=control;
                posLeft=posLeft+width;
                if((!existe || !existe.length) && columna != 'edad'){
                    control.textContent='';
                }
                if((existeAnterior && existeAnterior.length) && columna != 'edad' && columna != 'anio' && columna != 'xxxx' && edad+ge.fechaNacimiento<=2017){
                    control.textContent='|';
                }
            });
            posTop=posTop+ge.parametrosZonaDerecha.fila.height;
            zonaDerecha.appendChild(html.div({class:'fila'},listaRespuesta).create())
            this.filasLaterales[edad]=objetoRespuesta;
        }
        zonaDerecha.appendChild(html.div({class:'fila'},labels).create())
        ge.lineas.forEach(function(linea,iLinea){
            if(linea.edad){
                var fila = ge.filasLaterales[linea.edad];
                if(fila){
                    columnas.forEach(function(columna){
                        if(linea[columna]!=null && linea[columna]!==''){
                            fila[columna].textContent = linea[columna];
                        }
                    });
                }
            }
        })
    };
}


return GrillaEder;

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