"use strict";

function boton_seleccionar_supervisiones(){
"use strict";
    var todo_ok=true;
    enviar_paquete({
        proceso:'ejecutar_seleccionar_supervisiones',
        paquete:{
            tra_periodo:elemento_existente('tra_periodo').value, 
            tra_panel:elemento_existente('tra_panel').value
        },        
        cuando_ok:function(datos){
            ir_a_url(location.pathname+"?hacer=seleccionar_supervisiones&todo="+JSON.stringify({
            'tra_periodo':elemento_existente('tra_periodo').value,
            'tra_panel':elemento_existente('tra_panel').value,            
            })+'&y_luego=boton_ver');
//            resultados_supervision.innerHTML=datos.html;
        },
        cuando_error:function(mensaje){
            alert(mensaje);
        },        
        usar_fondo_de:elemento_existente('seleccionar'),
        mostrar_tilde_confirmacion:true
    });
}

var campos_proceso_resultados_elegidos=["tra_agrupacion","tra_periodo","tra_1_indicador","tra_1_contraperiodo","tra_1_contranivel"]; 

function mas_columnas_proceso_resultados_elegidos(boton){
    //var agregadas=document.getElementById('tra_cant_columnas_agredadas');
    var cantidad_parametros_clonar=3;
    var fila_boton=boton.parentNode.parentNode;
    var tabla_parametros=fila_boton.parentNode;
    var trs_a_clonar=[];
    //alert(fila_boton.rowIndex);
    for(var i=fila_boton.rowIndex-cantidad_parametros_clonar; i<fila_boton.rowIndex; i++){
        trs_a_clonar.push(tabla_parametros.rows[i]);
    }
    var ultimo_numero=trs_a_clonar[0].cells[0].children[0].htmlFor.split('_')[1];
    for(var i=0; i<trs_a_clonar.length; i++){
        var nueva_fila=tabla_parametros.insertRow(fila_boton.rowIndex);
        nueva_fila.innerHTML=trs_a_clonar[i].innerHTML.replace(new RegExp('tra_'+ultimo_numero+'_','g'),'tra_'+(Number(ultimo_numero)+1)+'_');
        campos_proceso_resultados_elegidos.push(nueva_fila.cells[0].children[0].htmlFor);
        //alert(nueva_fila.cells[0].children[0].htmlFor);
    }
    //elemento_existente('tra_cant_columnas_agredadas').value = elemento_existente('tra_cant_columnas_agredadas').value+1;
    //var agregadas = elemento_existente('tra_cant_columnas_agredadas').value;
    //alert(agregadas);
}

function ver_proceso_resultados_elegidos(boton){
    proceso_formulario_boton_ejecutar('resultados_elegidos','Ver',campos_proceso_resultados_elegidos,null,null,false);
}

function ProveedorIPCBA_Ingreso(params){
    window.controlParametros={parametros:params, def_params:{
        relvis:{},
        relpre:{},
        relatr:{},
    }};
    Object.defineProperty(this,'datos',{value:params});
    // this.datos=params;
}

ProveedorIPCBA_Ingreso.prototype=Object.create(ProveedorGrilla2.prototype);

ProveedorIPCBA_Ingreso.prototype.grabarFila=function(params){
    window.controlParametros={parametros:params, def_params:this.def_params_grabarFila};
    var parametros={};
    for(var campo in this.campos_grabar){
        parametros['tra_'+campo]=params.fila[campo];
        if(!this.campos_grabar[campo]){
            parametros['tra_ant_'+campo]=params.fila_original[campo];
        }
    };
    enviarPaquete({
        destino:window.location.pathname,
        datos:{
            proceso:'guardar_'+this.nombre_tabla,
            todo:JSON.stringify(parametros)
        },
        cuandoOk:function(respuesta){
            try{
                var rta=JSON.parse(respuesta);
            }catch(err){
                throw new Error('JSON error: '+respuesta);
            }
            if(!rta.ok){
                throw new Error(rta.mensaje);
            }
            params.cuandoOk(rta.mensaje);
        },
        cuandoFalla:params.cuandoFalla,
        relojEn:params.relojEn
    });
}

ProveedorIPCBA_Ingreso.prototype.estiloFila=function(fila){
    return fila.class_name||'';
}

function ProveedorIPCBA_RelVis(datos){
    ProveedorIPCBA_Ingreso.call(this,datos);
    Object.defineProperty(this,'campos_grabar',{value:{
        periodo:true, informante:true, visita:true, formulario:true, 
        fechasalida:false, fechaingreso:false, encuestador:false, supervisor:false, recepcionista:false, ingresador:false, razon:false, comentarios:false
    }});
    Object.defineProperty(this,'nombre_tabla',{value:'relvis'});
}

ProveedorIPCBA_RelVis.prototype=Object.create(ProveedorIPCBA_Ingreso.prototype);

ProveedorIPCBA_RelVis.prototype.traerDatos=function(params){
    window.controlParametros={parametros:params, def_params:this.def_params_traerDatos};
    params.cuandoOk({
        filas:this.datos.relvis.filas,
        campos:{
            periodo:{ancho:'100px'},
            informante:{tipo:'entero',tituloHTML:'inf'},
            nombreinformante:{tituloHTML:'informante',ancho:'140px'},
            visita:{tipo:'entero',ancho:'40px'},
            formulario:{tipo:'entero',ancho:'40px',tituloHTML:'for'},
            nombreformulario:{tituloHTML:'formulario',ancho:'140px'},
            panel:{tipo:'entero',ancho:'50px'},
            tarea:{tipo:'entero',ancho:'50px'},
            fechasalida:{editable:true, tipo:'fecha',ancho:'110px',tituloHTML:'salida'},
            fechaingreso:{editable:true, tipo:'fecha',ancho:'110px',tituloHTML:'ingreso'},
            encuestador:{editable:true,ancho:'50px'},
            supervisor:{editable:true,ancho:'50px'},
            recepcionista:{editable:true,ancho:'50px'},
            ingresador:{editable:true,ancho:'50px'},
            razon:{editable:true,ancho:'50px'},
            nombrerazon:{tituloHTML:'razón',ancho:'100px'},
        },
        modo_grabar:'fila',
        caption:{visible:false},
    });
}

ProveedorIPCBA_RelVis.prototype.obtenerSubgrilla=function(params){
    window.controlParametros={parametros:params, def_params:this.def_params_obtenerSubgrilla};
    var grilla=new Grilla2();
    var relpre_filtrado={filas:this.datos.relpre.filas.filter(function(registro){
        return registro.periodo==params.fila.periodo &&
            registro.informante==params.fila.informante &&
            registro.visita==params.fila.visita &&
            registro.formulario==params.fila.formulario;
    })};
    grilla.proveedor=new ProveedorIPCBA_RelPre({
        relpre:relpre_filtrado, relatr:this.datos.relatr
    });
    return grilla;
}

function ProveedorIPCBA_RelPre(datos){
    Object.defineProperty(this,'campos_grabar',{value:{
        periodo:true, producto:true, observacion:true, informante:true, visita:true, 
        precio:false, tipoprecio:false, cambio:false, comentariosrelpre:false
    }});
    Object.defineProperty(this,'nombre_tabla',{value:'relpre'});
    ProveedorIPCBA_Ingreso.call(this,datos);
}

ProveedorIPCBA_RelPre.prototype=Object.create(ProveedorIPCBA_Ingreso.prototype);

ProveedorIPCBA_RelPre.prototype.traerDatos=function(params){
    window.controlParametros={parametros:params, def_params:this.def_params_traerDatos};
    params.cuandoOk({
        filas:this.datos.relpre.filas,
        campos:{
            periodo:{invisible:true},
            producto:{ancho:'100px'},
            nombreproducto:{tituloHTML:'nombre'},
            observacion:{ancho:'50px', tipo:'entero',tituloHTML:'O<u><small><sup>bs</sup><small></u>'},
            precio:{editable:true, tipo:'numerico'},
            tipoprecio:{editable:true,ancho:'40px',tituloHTML:'<small>TP</small>'},
            cambio:{editable:true,ancho:'45px',tituloHTML:'C<small><sup><u>bio</u></sup></small>'},
            precio_1:{tipo:'numerico',tituloHTML:'anterior'},
            tipoprecio_1:{ancho:'40px',tituloHTML:'<small>TP</small>'},
            informante:{invisible:true},
            formulario:{invisible:true},
            visita:{invisible:true},
            comentariosrelpre:{editable:true,tituloHTML:'comentario'},
            ultima_visita:{invisible:true},
            masdatos:{tituloHTML:'más datos'},
            precionormalizado:{invisible:true},
            precionormalizado_1:{invisible:true},
            class_name:{invisible:true},
        },
        modo_grabar:'fila',
        caption:{visible:false}
    });
}

ProveedorIPCBA_RelPre.prototype.obtenerSubgrilla=function(params){
    window.controlParametros={parametros:params, def_params:this.def_params_obtenerSubgrilla};
    var grilla=new Grilla2();
    var relatr_filtrado={filas:this.datos.relatr.filas.filter(function(registro){
        return registro.periodo==params.fila.periodo &&
            registro.informante==params.fila.informante &&
            registro.visita==params.fila.visita &&
            registro.producto==params.fila.producto &&
            registro.observacion==params.fila.observacion;
    })};
    grilla.proveedor=new ProveedorIPCBA_RelAtr({
        relatr:relatr_filtrado
    });
    return grilla;
}

function ProveedorIPCBA_RelAtr(params){
    window.controlParametros={parametros:params, def_params:{
        relatr:{uso: 'lo que viene de RelAtr, pero filtrado'}
    }};
    Object.defineProperty(this,'campos_grabar',{value:{
        periodo:true, producto:true, observacion:true, informante:true, visita:true, atributo:true,
        valor:false
    }});
    Object.defineProperty(this,'nombre_tabla',{value:'relatr'});
    ProveedorIPCBA_Ingreso.call(this,params);
}

ProveedorIPCBA_RelAtr.prototype=Object.create(ProveedorIPCBA_Ingreso.prototype);

ProveedorIPCBA_RelAtr.prototype.traerDatos=function(params){
    window.controlParametros={parametros:params, def_params:this.def_params_traerDatos};
    params.cuandoOk({
        filas:this.datos.relatr.filas,
        campos:{
            periodo:{invisible:true},
            producto:{invisible:true},
            observacion:{invisible:true},
            informante:{invisible:true},
            visita:{invisible:true},
            atributo:{tipo:'entero',tituloHTML:'atr.',ancho:'60px'},
            nombreatributo:{tituloHTML:'nombre'},
            valor:{editable:true,ancho:'300px'},
            valor_1:{ancho:'300px',tituloHTML:'anterior'},
            fueraderango:{invisible:true, tipo:'bool', ancho:'40px', tituloHTML:'<small>R<sup><u>go</u></sup></small>'},
            tipodato:{invisible:true}, 
            orden:{invisible:true}, 
            rangodesde:{invisible:true}, 
            rangohasta:{invisible:true}, 
            alterable:{invisible:true}, 
            normalizable:{invisible:true},
            class_name:{invisible:true},
        },
        modo_grabar:'fila',
        caption:{visible:false}
    });
}

function mostrar_pantalla_ingreso(datos){
    proceso_formulario_respuesta.innerHTML="";
    var grilla=new Grilla2();
    grilla.proveedor=new ProveedorIPCBA_RelVis(datos);
    grilla.colocarRepositorio({destino:proceso_formulario_respuesta});
    grilla.obtenerDatos();
}