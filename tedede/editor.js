//UTF-8:SÍ
"use strict";
// editor.js

if(!window.tedede){
    window.tedede={};
}

if(!tedede.diccionarios){
    tedede.diccionarios={};
}

tedede.diccionarios['for']={
    cantColumnas:1,
    datos:{
        'I1':'Formulario Individual',
        'S1':'Formulario de seguimiento',
        'A1':'Formulario de vivienda y hogar'
    }
}

var formas_de_entender_bool={
    "sí":true, 
    si:true, 
    s:true, 
    t:true, 
    y:true, 
    1:true, 
    "true":true, 
    n:false, 
    no:false, 
    "false":false, 
    0:false, 
    "ok":true
};

function Editor(indice_editor,nombre_grilla,filtro_para_lectura,profundidad,otras_opciones){
    otras_opciones=otras_opciones||{};
    controlar_parametros(otras_opciones,{
        'offline':false,
        agregando_filas_completas:false
    })
    this.indice_editor=indice_editor;
    this.filtro_manual={};
    this.pk_adicional=[];
    this.nombre_grilla=nombre_grilla;
    this.profundidad=profundidad||1;
    this.datos=null;
    this.ordenariando=null;
    this.ordenar_por_campos=[];
    this.mapeo_pk_numfila={};
    this.con_anotaciones=false;
    this.HTML={};
    this.tabla=null;
    this.simple=false;
    this.filtro_para_lectura=filtro_para_lectura||{};
    this.nombre_de_esta_variable='editores['+JSON.stringify(this.indice_editor)+']';
    this.invisibles=[];
    for(var clave in Editor.HTML){
        if(typeof(Editor.HTML[clave])=='string'){
            this.HTML[clave]=Editor.HTML[clave].replace('@@@@',this.nombre_de_esta_variable)
            .replace('@@@#',JSON.stringify(this.indice_editor));
        }else{
            this.HTML[clave]=Editor.HTML[clave];
        }
    }
    if(otras_opciones.agregando_filas_completas){
        this.HTML.boton_agregar_registro=this.HTML.boton_agregar_registro.replace("value='A'","value='a'");
    }else{
        this.HTML.boton_agregar_registro=this.HTML.boton_agregar_registro.replace('permitir_agregar_registros','agregar_un_registro');
    }
    editores[this.indice_editor]=this;
    if(otras_opciones.offline=='claves_a_conciliar'){
        this.enviar_a_soporte=function(parametros, elemento, hacer_si_ok, asincronico, sin_confirmar){
            switch(parametros.accion){
            case 'leer_grilla':
                var registros={};
                var a_conciliar_claves=JSON.parse(sessionStorage['a_conciliar_claves']);
                for(var i_rta_ud in a_conciliar_claves) if(iterable(i_rta_ud,a_conciliar_claves)){
                    var una_ud=a_conciliar_claves[i_rta_ud];
                    if("pk_ud" in una_ud){
                        var resumen_variables=JSON.stringify(una_ud.rta_ud)
                            .replace(/var_/g,'')
                            .replace(/","/g,',')
                            .replace(/":"/g,':')
                            .replace(/":null,"/g,':,')
                            .substr(2,115);
                        registros[JSON.stringify(una_ud.pk_ud)]=cambiandole(cambiandole(
                            cambiar_prefijo(una_ud.pk_ud,'tra_','nue_'),
                            cambiar_prefijo(una_ud.pk_ud,'tra_','vie_')),
                            {resumen:resumen_variables}
                        );
                    }
                }
                hacer_si_ok({
                    registros:registros,
                    atributos_fila:{},
                    definicion_campos:{},
                    campos_editables:['nue_enc','nue_hog','nue_mie','nue_exm'], // GENERALIZAR
                    solo_lectura:[],
                });
            break;
            case 'grabar_campo':
                elemento.style.backgroundColor='Pink';
                hacer_si_ok({
                    valor_grabado:parametros.nuevo_valor,
                    pk:JSON.stringify(parametros.pk),
                });
            break;
            }
        }
    }else{
        if(otras_opciones.offline=='visitas_a_conciliar'){
            this.enviar_a_soporte=function(parametros, elemento, hacer_si_ok, asincronico, sin_confirmar){
                switch(parametros.accion){
                case 'leer_grilla':
                    var registros={};
                    var a_conciliar_visitas=JSON.parse(sessionStorage['a_conciliar_visitas']);
                    for(var i_rta_ud in a_conciliar_visitas) if(iterable(i_rta_ud,a_conciliar_visitas)){
                        var una_ud=a_conciliar_visitas[i_rta_ud];
                        if("pk_ud" in una_ud){
                            var resumen_variables=JSON.stringify(una_ud.rta_ud);
                            var resumen_para_ver=(((JSON.stringify(una_ud.rta_ud).replace(/var_/g,'')).replace(/"/g,'')).replace(/}/g,'')).replace(/{/g,'');
                            registros[JSON.stringify(una_ud.pk_ud)]=cambiandole(cambiandole(
                                cambiar_prefijo(una_ud.pk_ud,'tra_','nue_'),
                                cambiar_prefijo(una_ud.pk_ud,'tra_','vie_')),
                                {resumen:resumen_para_ver}
                            );
                        }
                    }
                    hacer_si_ok({
                        registros:registros,
                        atributos_fila:{},
                        definicion_campos:{},
                        campos_editables:['nue_enc','nue_anoenc'], // GENERALIZAR
                        solo_lectura:[],
                    });
                break;                
                case 'grabar_campo':
                    var primer_encuesta=sessionStorage.getItem('tra_enc');
                    var segunda_encuesta=sessionStorage.getItem('tra_enc2');
                    if(parametros.nuevo_valor!=primer_encuesta && parametros.nuevo_valor!=segunda_encuesta){
                        elemento.style.backgroundColor='Red';  
                        alert('La encuesta '+parametros.nuevo_valor+' no es una de las ingresadas inicialmente');
                    }else{
                        elemento.style.backgroundColor='Pink';
                    }                    
                    hacer_si_ok({
                        valor_grabado:parametros.nuevo_valor,
                        pk:JSON.stringify(parametros.pk),
                    });
                break;
                }
            }
        }else{
            this.enviar_a_soporte=function(parametros, elemento, hacer_si_ok, asincronico, sin_confirmar){
                enviar_paquete({
                    proceso:'grilla_soporte',
                    paquete:parametros,
                    cuando_ok:hacer_si_ok,
                    asincronico:asincronico,
                    usar_fondo_de:sin_confirmar?false:elemento,
                    mostrar_tilde_confirmacion:true
                });
            }
        }
    }
}

Editor.prototype.obtener_el_contenedor=function(clase){
    clase=clase||'div';
    return "<"+clase+" id='"+this.nombre_de_esta_variable+"' style='background-image=url(../imagenes/cargando.gif); background-repeat:no-repeat; min-width:100px; min-height:40px'></"+clase+">";
}

Editor.prototype.obtener_el_contenedor_dom=function(clase){
"use strict;";
    clase=clase||'div';
    var contenedor=document.createElement(clase);
    contenedor.id=this.nombre_de_esta_variable;
    contenedor.style.cssText='background-image=url(../imagenes/cargando.gif); background-repeat:no-repeat; min-width:100px; min-height:40px';
    return contenedor;
}

Editor.prototype.poner_el_contenedor=function(){
    document.write(this.obtener_el_contenedor());
}

Editor.id_temporario=1;

Editor.prototype.cargar_grilla=function(elemento_para_el_tilde,mantener_arbol,finalmente_hacer){
    var editor=this;
    this.ordenariando=null;
    editor_elegido=editor.indice_editor;
	var fondo=elemento_para_el_tilde||elemento_existente(this.nombre_de_esta_variable);
	var hasta_profundidad=localStorage["editor_arbol_profundidad"];
	editor.enviar_a_soporte({
		accion:'leer_grilla', 
		grilla:this.nombre_grilla, 
		filtro_para_lectura:this.filtro_para_lectura,
        filtro_manual:this.filtro_manual,
        detallar:this.detallar||false
		}
	, fondo
	, function(datos){
		editor.datos=datos;
        if(!editor.datos.definicion_campos){
            editor.datos.definicion_campos={};
        }
		editor.datos.rexexp_remover_en_nombre_de_campo=new RegExp(datos.remover_en_nombre_de_campo);
		var tabla=editor.refrescar();
		if(mantener_arbol && tabla && editor.profundidad<hasta_profundidad){
			var nuevo_nivel=JSON.parse(localStorage["editor_arbol_profundidad_"+editor.profundidad+1]);
			if(nuevo_nivel){
				var numfila=editor.mapeo_pk_numfila[nuevo_nivel.pk_fila];
				if(numfila || numfila===0){
					var fila_invocadora=tabla.tBodies[0].rows[numfila];
					if(fila_invocadora){
						var celda_invocadora=fila_invocadora.cells[nuevo_nivel.num_columna];
						if(celda_invocadora){
							editor.abrir_subgrilla(celda_invocadora, nuevo_nivel.nombre_grilla, nuevo_nivel.filtro_para_lectura,mantener_arbol);
						}
					}
				}
			}
		}
        if(cabezales_tablas_php){
            setTimeout(function(){
                cabezales_tablas_php(true);
            },1000)
        }
        if(finalmente_hacer){
            finalmente_hacer();
        }
	}
	,true
	);
}

Editor.prototype.refrescar=function(){
"use strict";
    var editor=this;
    var elemento_destino_grilla=elemento_existente(editor.nombre_de_esta_variable);
    var cant_filas=editor.datos.cantidad_registros;
    if(cant_filas==0){
        elemento_destino_grilla.innerHTML="";
    }else{
        if(typeof cant_filas === 'undefined'){ // lo calcula porque a veces no viene el dato cantidad_registros
            cant_filas=0;
            for(i in editor.datos.registros) cant_filas++;
        }
        var tabla=document.createElement("table");
        if(this.tabla){
            var posicion=TablasTituloDinamico.indexOf(this.tabla);
            if(posicion>=0){
                TablasTituloDinamico.splice(posicion,1);
            }
        }
        this.tabla=tabla;
        TablasTituloDinamico.push(this.tabla);
        tabla.id="t:"+this.nombre_de_la_variable;
        tabla.className="editor_tabla";
        tabla.setAttribute('data-cabezales-moviles',(Number(editor.datos.cantidadColumnasFijas)||1)+1);
        tabla.border=1;
        tabla.setAttribute('nuestro_tabla',editor.nombre_grilla);
        var pk;
        var fila;
        var atributos_fila; 
        var colocar_fila=function(){
            fila=editor.datos.registros[pk];
            atributos_fila=editor.datos.atributos_fila[pk];
            var tmpRow = null;
            tmpRow=tabla.insertRow(-1);
            tmpRow.setAttribute('nuestro_pk',pk);
            tmpRow.name=pk;
            editor.mapeo_pk_numfila[pk]=tmpRow.rowIndex;
            var tmpCell = null;
            tmpCell=tmpRow.insertCell(-1);
            tmpCell.style.whiteSpace='nowrap';
            tmpCell.innerHTML='';
            if(editor.datos.puede_insertar && pk){
                tmpCell.innerHTML=tmpCell.innerHTML+editor.HTML.boton_agregar_registro_flotante;
            }
            if(editor.datos.puede_eliminar && pk){
                tmpCell.innerHTML=tmpCell.innerHTML+editor.HTML.boton_eliminar_registro;
            }
            if(editor.datos.puede_detallar && pk){
                tmpCell.innerHTML=tmpCell.innerHTML+editor.HTML.boton_detallar;
            }
            if(editor.datos.boton_enviar){
                // tmpCell.innerHTML+=editor.HTML.boton_enviar(editor.datos.boton_enviar);
                if(pk){
                    tmpCell.innerHTML=tmpCell.innerHTML+editor.HTML.boton_enviar(editor.datos.boton_enviar,pk);
                }
            }
            tmpCell.className='editor_botonera_registro';
            for(var campo in fila){ 
                var dato=fila[campo];
                var attr=(atributos_fila||{})[campo];
                var def_campo=editor.datos.definicion_campos[campo];
                if(!def_campo){
                    def_campo={};
                    editor.datos.definicion_campos[campo]=def_campo;
                }
                if(!def_campo.invisible){
                    tmpCell=tmpRow.insertCell(-1);
                    tmpCell.className=((attr||{}).clase||'')+' celda_comun';
                    var title=(attr||{}).title;
                    if(title){
                        tmpCell.title=title;
                    }
                    var style=(attr||{}).style;
                    if(style){
                        tmpCell.style.cssText=style;
                    }
                    tmpCell.onkeydown = function(nodo){
                        editor.el_onkeydown_de_celdas(this,event);
                    };
                    tmpCell.setAttribute('nuestro_campo',campo);
                    var boton=editor.datos.definicion_campos[campo].boton;
                    if(boton){
                        if(pk){
                            var tmpBoton=document.createElement("input");
                            tmpBoton.type="button";
                            tmpBoton.value=boton+' '+dato;
                            tmpBoton.setAttribute('nuestro_proceso',editor.datos.definicion_campos[campo].proceso);
                            tmpBoton.setAttribute('nuestro_post_proceso',editor.datos.definicion_campos[campo].post_proceso);
                            tmpBoton.setAttribute('nuestro_pre_proceso',editor.datos.definicion_campos[campo].pre_proceso);
                            tmpBoton.onclick=function(){
                                var fun_pre_proceso=null;
                                var pre_proceso=this.getAttribute('nuestro_pre_proceso');
                                if(pre_proceso){
                                    eval(pre_proceso);
                                }
                                var fun_post_proceso=null;
                                var post_proceso=this.getAttribute('nuestro_post_proceso');
                                if(post_proceso){
                                    var fun_post_proceso=function(){
                                        eval(post_proceso);
                                    }
                                }
                                editor.boton_generico(this,editor.indice_editor,fun_post_proceso);
                            }
                            tmpCell.style.textalign='center';
                            tmpCell.appendChild(tmpBoton);
                        }
                    }else{
                        tmpCell.onblur = function(nodo){
                            editor.el_onblur_de_celdas(this);
                        };
                        tmpCell.onfocus = function(nodo){
                            editor.el_onfocus_de_celdas(this);
                        };
                        tmpCell.onkeypress = function(nodo){
                            editor.el_onkeypress_de_celdas(this,event);
                        };
                        if(campo=='aux_anotacion'){
                            tmpCell.onclick=function(){
                                editor.abrir_detalles_y_anotaciones(this);
                            };
                        }else if(campo.substr(0,8)=='aux_cant' || campo.substr(0,10)=='subgrilla_' || campo.substr(0,9)=='tabulado_'){
                            tmpCell.onclick=function(){ 
                                var campo=this.getAttribute('nuestro_campo');
                                var pk=this.parentNode.getAttribute('nuestro_pk');
                                var fila=editor.datos.registros[pk];
                                var dato=fila[campo];
                                var nombre_subgrilla;
                                var pk_subgrilla;
                                if(campo.substr(0,10)=='subgrilla_'){
                                    nombre_subgrilla=dato['grilla'];
                                    pk_subgrilla=dato['pk'];
                                }else{
                                    pk_subgrilla={};
                                    nombre_subgrilla=campo.substr(9);
                                    if(!editor.datos.joins[nombre_subgrilla]){
                                        alert("No está definida la forma de ver los subdatos de "+nombre_subgrilla);
                                        throw new Exception("No esta definida la forma de ver los subdatos de "+nombre_subgrilla);
                                    }
                                    for(var campo_de_esta in editor.datos.joins[nombre_subgrilla]){
                                        var campo_de_la_otra=editor.datos.joins[nombre_subgrilla][campo_de_esta];
                                        pk_subgrilla[campo_de_la_otra]=fila[campo_de_esta];
                                    }
                                    pk_subgrilla=JSON.stringify(pk_subgrilla);
                                }
                                editor.abrir_subgrilla(this, nombre_subgrilla, pk_subgrilla); 
                            };
                            if(campo.substr(0,9)=='tabulado_'){
                                dato=String.fromCharCode(8862)+' '+dato;
                            }else{
                                if(campo.substr(0,10)=='subgrilla_'){
                                    dato=dato['mostrar'];
                                }
                                if(dato>0){
                                    dato=String.fromCharCode(8862)+' '+dato;
                                }else{
                                    dato=String.fromCharCode(8864)+' '+dato;
                                }
                            }
                        }else if(editor.datos.campos_editables===true && editor.datos.solo_lectura.indexOf(campo)<0 
                            || editor.datos.campos_editables!==true && editor.datos.campos_editables.indexOf(campo)>=0)
                            {
                            tmpCell.contentEditable=true;
                            tmpCell.classList.add('editables');
                            tmpCell.ondblclick=function(){
                                if(!this.isContentEditable){
                                    this.contentEditable=true;
                                }
                            };
                        }
                        editor.asignar_valor(tmpCell,dato,editor.datos.definicion_campos[campo].tipo);
                        tmpCell.setAttribute('nuestro_tipo',typeof dato);
                        if(typeof dato=='boolean'){
                            tmpCell.onfocus=function(){
                                editor.el_onfocus_de_bool(this);
                            };
                        }
                    }
                    if(def_campo.masInfo){
                        tmpCell=tmpRow.insertCell(-1);
                        tmpCell.className=((attr||{}).clase||'')+' celda_comun';
                        tmpCell.textContent=tedede.diccionarios[def_campo.campoPuro].datos[dato]||'';
                    }
                }
            }
        }
        if(editor.ordenariando){
            for(var i=0; i<editor.ordenariando.length; i++){
                pk=editor.ordenariando[i].pk;
                colocar_fila();
            }
        }else{
            editor.ordenariando=[];
            for(pk in editor.datos.registros){
                colocar_fila();
                editor.ordenariando.push({
                    orden:pk, 
                    pk:pk
                });
            }
        }
        var tHead=tabla.createTHead();
        var filaTitulos=tHead.insertRow(-1);
        var filaBotones=tHead.insertRow(-1);
        var filaFiltro=tHead.insertRow(-1);
        filaTitulos.className = 'tabla_titulos';
        filaBotones.className = 'tabla_botonera';
        filaFiltro.className = 'tabla_filtros';
        var celdaTitulos=filaTitulos.insertCell(-1);
        var celdaBotones=filaBotones.insertCell(-1);
        var celdaFiltro=filaFiltro.insertCell(-1);
        celdaBotones.innerHTML=editor.HTML.boton_herramientas;
        celdaFiltro.innerHTML=editor.HTML.boton_filtrar;
        celdaFiltro.className='editor_botonera_registro';
        if(editor.datos.puede_insertar){
            celdaTitulos.innerHTML=editor.HTML.boton_agregar_registro;
        }
        for(var campo in fila){ 
            var def_campo=editor.datos.definicion_campos[campo];
            if(!def_campo.invisible){
                var campoPuro=def_campo.campoPuro||campo.replace(editor.datos.rexexp_remover_en_nombre_de_campo,'').replace(/_/g,' ');
                def_campo.campoPuro=campoPuro;
                var colSpan=1;
                if(def_campo.masInfo){
                    colSpan=tedede.diccionarios[campoPuro].cantColumnas+1;
                }
                celdaTitulos=filaTitulos.insertCell(-1);
                celdaBotones=filaBotones.insertCell(-1);
                celdaFiltro=filaFiltro.insertCell(-1);
                celdaTitulos.className='celda_comun';
                celdaBotones.className='celda_comun';
                celdaFiltro.className='celda_filtrar';
                celdaTitulos.colSpan=colSpan;
                celdaBotones.colSpan=colSpan;
                celdaFiltro.colSpan=colSpan;
                if(campo=='aux_anotacion'){
                    setTimeout(editor.nombre_de_esta_variable+'.leer_anotaciones('+celdaTitulos.cellIndex+');',1000);
                }
                var titulo=campoPuro;
                celdaTitulos.textContent=titulo;
                celdaBotones.innerHTML = editor.HTML.boton_ordenar+editor.HTML.boton_ocultar;
                if(tedede.diccionarios[campoPuro]){
                    celdaBotones.innerHTML += editor.HTML.boton_mas_info;
                }
                celdaBotones.setAttribute('nuestro_campo',campo);
                if(!editor.datos.definicion_campos[campo]){
                    editor.datos.definicion_campos[campo]={};
                }
                editor.datos.definicion_campos[campo].posicion_columna=celdaBotones.cellIndex;
                celdaFiltro.contentEditable=true;
                celdaFiltro.setAttribute('nuestro_campo',campo);
                celdaFiltro.textContent=this.filtro_manual[campo]||'';
                celdaFiltro.onkeydown = function(nodo){
                    editor.el_onkeydown_de_celdas(this,event,true);
                };
                celdaFiltro.onkeypress = function(nodo){
                    editor.el_onkeypress_de_celdas_filtro(this,event);
                };
            }
        }
        editor.datos.cantidad_columnas=filaTitulos.cells.length;
        editor.fila_botones_orden=filaBotones;
        for(var i_campo in editor.ordenar_por_campos) if(iterable(i_campo,editor.ordenar_por_campos)){
            if(editor.datos.definicion_campos[campo].invisible){
                campo=editor.ordenar_por_campos[i_campo];
                var posicion=editor.datos.definicion_campos[campo].posicion_columna;
                editor.fila_botones_orden.cells[posicion].childNodes[0].value="\u21C5."+(Number(i_campo)+1);
            }
        }
        editor.fila_filtro=filaFiltro;
        var tmpCaption=tabla.createCaption();
        tmpCaption.className="tabla_titulos";
        tmpCaption.innerHTML=
            Editor.HTML.boton_alto_fijo+
            Editor.HTML.boton_exportar_xls+
            //Editor.HTML_boton_ancho_fijo+Editor.HTML_separador_vertical+
            "Grilla: <b><span style='font-size:120%'>"+editor.nombre_grilla+"</span></b>, registros: "+cant_filas;
        elemento_destino_grilla.innerHTML="";
        elemento_destino_grilla.appendChild(tabla);
        if(editor.simple){
            editor.fila_botones_orden.style.display='none';
            editor.fila_filtro.style.display='none';
        }
        return tabla;
    }
}

Editor.prototype.refresco_parcial=function(rta,modo){
"use strict";
    var editor=this;
    for(var pk_recibida in rta.registros||{}){
        var fila=rta.registros[pk_recibida];
        if(modo && modo.agregando){
            editor.datos.registros[pk_recibida]={};
        }
        for(var campo in fila||{}){
            var valor=fila[campo];
            editor.datos.registros[pk_recibida][campo]=valor;
            if(rta.atributos_fila && rta.atributos_fila[pk_recibida] && rta.atributos_fila[pk_recibida][campo]){
                editor.datos.atributos_fila[pk_recibida][campo]=rta.atributos_fila[pk_recibida][campo];
            }
        }
        var fila=editor.datos.registros[pk_recibida];
        var elemento_tr=editor.tabla.tBodies[0].rows[editor.mapeo_pk_numfila[pk_recibida]];
        if(!elemento_tr) return; //// MEJORAR
        var atributos_fila=(editor.datos.atributos_fila||{})[pk_recibida]||{};
        for(var i=1; i<elemento_tr.cells.length; i++){
            var elemento_td=elemento_tr.cells[i];
            var campo=elemento_td.getAttribute('nuestro_campo');
            editor.asignar_valor(elemento_td,fila[campo]);
            var attr=atributos_fila[campo];
            elemento_td.className=((attr||{}).clase||'')+' celda_comun';
            var title=(attr||{}).title;
            if(title){
                elemento_td.title=title;
            }
            var style=(attr||{}).style;
            if(style){
                elemento_td.style.cssText=style;
            }
        }
    }
}

Editor.prototype.boton_generico=function(elemento_boton,indice_editor,post_proceso){
"use strict";
    var pk=JSON.parse(elemento_boton.parentNode.parentNode.getAttribute('nuestro_pk'));
    var nombre_editor=elemento_boton.parentNode.parentNode.parentNode.parentNode.getAttribute('nuestro_tabla');
    pk=pk.concat(editores[nombre_editor].pk_adicional);
    var proceso=elemento_boton.getAttribute('nuestro_proceso');
    enviar_paquete({
        proceso:proceso||elemento_boton.parentNode.getAttribute('nuestro_campo').replace(editor.datos.rexexp_remover_en_nombre_de_campo,''),
        paquete:{argumentos_posicionales:pk},
        cuando_ok:function(rta){
            elemento_boton.title=rta.al_boton;
            elemento_boton.value='¡OK!';
            elemento_boton.disabled=true;
            var editor=editores[indice_editor];
            var elemento_tr=elemento_boton.parentNode.parentNode;
            editor.refresco_parcial(rta);
            if(post_proceso){
                post_proceso();
            }
        },
        usar_fondo_de:elemento_boton,
        mostrar_tilde_confirmacion:true
    })
}

Editor.prototype.nodo_de_arriba_o_abajo=function(nodo,direccion){
    var FILAS_DEL_ENCABEZADO=2;// OJO QUE ESTÁ TOMANDO LA CANTIDAD DE FILAS DEL ENCABEZADO
    var elemento_fila=nodo.parentNode;
    var tabla=elemento_fila.parentNode.parentNode;
    var num_fila=elemento_fila.rowIndex;
    var num_col=nodo.cellIndex;
    if(direccion==1 && num_fila<=tabla.rows.length-FILAS_DEL_ENCABEZADO
        || direccion==-1 && num_fila>FILAS_DEL_ENCABEZADO){ 
        var proxima_fila=tabla.rows[num_fila+direccion];
        var celda_de_la_proxima_fila=proxima_fila.cells[num_col];
        return celda_de_la_proxima_fila;
    }
    return false;
}

Editor.prototype.nodo_de_izquierda_o_derecha=function(nodo,direccion,desde){
    var elemento_fila=nodo.parentNode;
    var num_col=desde||nodo.cellIndex;
    num_col+=direccion;
    while((direccion==1 && num_col<elemento_fila.cells.length
        || direccion==-1 && num_col>=0)
    && !elemento_fila.cells[num_col].isContentEditable){
        num_col+=direccion;
    }
    var candidato_celda=elemento_fila.cells[num_col];
    return (candidato_celda||{}).isContentEditable?candidato_celda:false;
}

Editor.prototype.nodo_de_abajo=function(nodo){
    return this.nodo_de_arriba_o_abajo(nodo,1);
}

Editor.prototype.nodo_de_arriba=function(nodo){
    return this.nodo_de_arriba_o_abajo(nodo,-1);
}

Editor.prototype.el_onkeypress_de_celdas=function(nodo,evento){
    var editor=this;
    if(evento.which==13){ // Enter
        evento.preventDefault();
        var proxima_celda=editor.nodo_de_izquierda_o_derecha(nodo,1);
        if(proxima_celda){
            proxima_celda.focus();
        }else{
            var celda_de_la_proxima_fila=editor.nodo_de_abajo(nodo);
            if(celda_de_la_proxima_fila){
                proxima_celda=editor.nodo_de_izquierda_o_derecha(celda_de_la_proxima_fila,1,-1);
                if(proxima_celda){
                    proxima_celda.focus();
                }
            }
        }
        if(!proxima_celda){
            nodo.onblur();
        }
    }
    if(evento.which==2){
        evento.which='\u2422';
    }
}

Editor.prototype.el_onkeypress_de_celdas_filtro=function(nodo,evento){
    var editor=this;
    if(evento.which==13){ // Enter
        evento.preventDefault();
        var proxima_celda=editor.nodo_de_izquierda_o_derecha(nodo,1);
        if(proxima_celda){
            proxima_celda.focus();
        }
    }
}

var mostrar_proxima_tecla=false;

Editor.prototype.el_onkeydown_de_celdas=function(nodo,evento,filtro){
    var editor=this;
    var proxima_celda;
    if(evento.which==40 || evento.which==38){ // KeyDown, KeyUp
        if(!filtro){
            var proxima_celda=editor.nodo_de_arriba_o_abajo(nodo,evento.which-39);
        }
    }
    if(evento.ctrlKey && (evento.which==37 || evento.which==39)){ // izquierda o derecha
        proxima_celda=editor.nodo_de_izquierda_o_derecha(nodo,evento.which-38);
    }
    if(!evento.ctrlKey && (evento.which==37 || evento.which==39)){ // izquierda o derecha
        if(window.getSelection && window.getSelection().getRangeAt){
            var seleccion=window.getSelection();
            if(seleccion.anchorOffset==seleccion.focusOffset && seleccion.anchorNode==seleccion.focusNode){
                if(evento.which==37 && seleccion.focusOffset==0 || evento.which==39 && (seleccion.focusOffset==seleccion.focusNode.length || seleccion.focusNode.textContent=='')){
                    proxima_celda=editor.nodo_de_izquierda_o_derecha(nodo,evento.which-38);
                }
            }
        }
    }
    if(evento.ctrlKey && (evento.which==36)){ // home
        proxima_celda=editor.nodo_de_izquierda_o_derecha(nodo,1,-1);
    }
    if(evento.ctrlKey && (evento.which==35)){ // end
        proxima_celda=editor.nodo_de_izquierda_o_derecha(nodo,-1,nodo.parentNode.cells.length);
    }
    if(filtro && evento.ctrlKey && (evento.which==13)){ // enter
        editor.filtrar_tabla();
    }
    if(proxima_celda){
        proxima_celda.focus();
        evento.preventDefault();
    }
    // 36 home 35 end 37 <=   => 39
    if(evento.altKey && evento.which==113){ // F2
        mostrar_proxima_tecla=!mostrar_proxima_tecla;
    }else{
        if(mostrar_proxima_tecla){
            var mostrar='evento: ';
            for(var i in evento){
                mostrar+=i+'='+evento[i]+' ';
            }
            alert(mostrar);
        }
    }
    if(!filtro && evento.which==115){ //F4
        var celda_de_arriba=editor.nodo_de_arriba(nodo);
        if(celda_de_arriba){
            nodo.textContent=celda_de_arriba.textContent;
        }
        if(!evento.shiftKey){
            var celda_de_la_proxima_fila=editor.nodo_de_abajo(nodo);
            if(celda_de_la_proxima_fila){
                celda_de_la_proxima_fila.focus();
            }else{
                nodo.onblur();
            // editor.el_onblur
            }
        }else{
            proxima_celda=editor.nodo_de_izquierda_o_derecha(nodo,+1);
            if(proxima_celda){
                proxima_celda.focus();
            }
        }
    }
    if(evento.which==66 && evento.altKey){ // Alt B
        nodo.textContent='\u2422';
    }
}

Editor.prototype.el_onblur_de_celdas=function(nodo){
    var editor=this;
    en_celda=false;
    var campo=nodo.getAttribute('nuestro_campo');
    var pk=nodo.parentNode.getAttribute('nuestro_pk');
    var grilla=nodo.parentNode.parentNode.parentNode.getAttribute('nuestro_tabla');
    var viejo_valor=editor.datos.registros[pk][campo];
    var nuevo_valor=nodo.textContent;
    if(nuevo_valor=='' || nuevo_valor=='\n'){
        nuevo_valor=null;
    }else if(nuevo_valor=='\u2422'){
        nuevo_valor='';
    }else{
        nuevo_valor=nuevo_valor.replace(new RegExp('\u00A0|(\u000A|\u000D)+$','g'),' ');
        var tipo_campo=nodo.getAttribute('nuestro_tipo');
        switch(tipo_campo){
            case 'boolean':
                nuevo_valor=formas_de_entender_bool[nuevo_valor.toLowerCase()];
                if(nuevo_valor===true || nuevo_valor===false){
                    editor.asignar_valor(nodo,nuevo_valor);
                }
                break;
        }
    }
    if(nuevo_valor!=viejo_valor){
        var celda=nodo;
        editor.enviar_a_soporte({
            accion:'grabar_campo', 
            grilla:grilla, 
            pk:JSON.parse(pk), 
            campo:campo, 
            nuevo_valor:nuevo_valor, 
            viejo_valor:viejo_valor
        }
        , celda
        , function(respuesta){
            editor.datos.registros[pk][campo]=respuesta.valor_grabado;
            if(pk!=respuesta.pk){
                editor.datos.registros[respuesta.pk]=editor.datos.registros[pk];
                editor.datos.atributos_fila[respuesta.pk]=editor.datos.atributos_fila[pk];
                editor.mapeo_pk_numfila[respuesta.pk]=editor.mapeo_pk_numfila[pk];
                var fila=celda.parentNode;
                fila.setAttribute('nuestro_pk',respuesta.pk);
                delete editor.datos.registros[pk];
                delete editor.datos.atributos_fila[pk];
                delete editor.mapeo_pk_numfila[pk];
                editor.ordenariando=null;
            }
            editor.asignar_valor(celda,respuesta.valor_grabado);
            if(respuesta.registros){
                editor.refresco_parcial(respuesta);
            }
        }, true
        );
    }
    var fila_nodo= nodo.parentNode;
    fila_nodo.classList.remove("grilla_fila_cursor");
}

Editor.prototype.el_onfocus_de_celdas=function(nodo){
    en_celda=true;
    var fila_nodo=nodo.parentNode;
    fila_nodo.classList.add('grilla_fila_cursor');
}


Editor.prototype.el_onfocus_de_bool=function(nodo){
    var valor=nodo.textContent;
    if(valor.length>1){
        nodo.textContent=valor.substr(0,1);
    }
    var fila_nodo=nodo.parentNode;
    fila_nodo.classList.add('grilla_fila_cursor');
}

Editor.prototype.filtrar_tabla=function(){
"use strict";
    this.filtro_manual={};
    // for(var i_celda in elemento_fila.cells) if(iterable(i_celda,elemento_fila.cells)){
    var elemento_fila=this.fila_filtro;
    for(var i_celda=0; i_celda<elemento_fila.cells.length; i_celda++){
        var celda=elemento_fila.cells[i_celda];
        var valor=celda.textContent;
        if(valor!='' && valor!='\n'){
            this.filtro_manual[celda.getAttribute('nuestro_campo')]=celda.textContent;
        }
    }
    this.cargar_grilla(document.body,false);
}

Editor.HTML={
    separador_vertical:" | "
    , 
    boton_ancho_fijo:"<input type=button value='Ancho Fijo' onclick='@@@@.ancho_fijo(this);'>"
    , 
    boton_herramientas:"<input type=button value=H class=editor_registro_boton title='Herramientas' onclick='@@@@.herramientas(this);'>"
    , 
    boton_alto_fijo:"<input type=button class=boton_plano value='⌆' title='angostar renglones' onclick='Editor.angostar_renglones(this,true);' style='font-color:Green; font-weigth:bold; width:24px; height:16px; border:0px transparent; font-size:100%;'>"+
        "<input type=button class=boton_plano value='⌨✍' title='trabar edición directa para evitar modificaciones involuntarias (para editar hay que poner doble click)' onclick='Editor.trabar_edicion(this,true);' style='font-color:Green; font-weigth:bold; width:24px; height:16px; border:0px transparent; font-size:100%;'>"
    , 
    boton_exportar_xls:"<input type=button value='' class=editor_registro_boton title='Exportar a Excel' onclick='Editor.exportar_excel(this);' style='font-color:Green; font-weigth:bold; width:24px; height:16px; border:0px transparent; background-image:url(../imagenes/expo_xls18.png); background-repeat:no-repeat; background-color:inherit;'>"
    , 
    boton_eliminar_registro:"<input type=button value='B' class='editor_registro_boton' title='Borrar registro' onclick='@@@@.eliminar_registro(this);'>"
    , 
    boton_detallar:"<input type=button value='det' class='editor_registro_boton' title='Detallar los registros que componen este renglón' onclick='@@@@.detallar(this);'>"
    , 
    boton_ordenar:"<input type=button class=boton_barra_grilla value='\u2206' title='ordenar usando esta columna' onclick='@@@@.ordenar_por_columna(this)'>"
    , 
    boton_ocultar:"<input type=button class=boton_barra_grilla value='\u229D' title='ocultar columna' onclick='@@@@.ocultar_columna(this)'>"
    , 
    boton_mas_info:"<input type=button class=boton_barra_grilla value='\u2346' title='más información' onclick='@@@@.mas_info_columna(this)'>"
    , 
    boton_filtrar:"<input type=button value='F' title='Filtrar según los valores ingresados en esta fila' onclick='@@@@.filtrar_tabla()'>"
    , 
    boton_agregar_registro:"<input type=button value='A' title='Agregar un registro' onclick='@@@@.permitir_agregar_registros(this)'>"
    , 
    boton_agregar_registro_flotante:"<input type=button value='A' title='Agregar un registro' style='display:none' onclick='@@@@.agregar_un_registro_flotante(this)' nuestro_soy='boton_agregar'>"
    , 
    boton_quitar_tr:"<input type=button value='&#150;' title='ocultar' onclick='@@@@.quitar_tr(this,@@@#)'>"
    , 
    boton_refrescar_tr:"<input type=button value='&#8634;' title='refrescar' onclick='@@@@.refrescar_tr(this,texto_funcion_refrescar)'>"
    , 
    boton_enviar: function(boton_enviar,pk){
        if(boton_enviar.proceso){
            return "<a href='"+location.pathname+
                   "?hacer="+boton_enviar.proceso+ 
                   "&todo="+encodeURIComponent(JSON.stringify(ponerle_claves(JSON.parse(pk),boton_enviar.campos_parametros)))+ 
                   "&y_luego="+boton_enviar.y_luego+
                   "' title='"+boton_enviar.title+"'><span class=boton>"+boton_enviar.leyenda+"</span></a>";
        }
        if(boton_enviar.ir_a){
            return "<a href='"+boton_enviar.ir_a+"?cual="+pk+"' title='"+boton_enviar.title+"'><span class=boton>"+boton_enviar.leyenda+"</span></a>";
        }else if(boton_enviar.accion=='AbrirEncuesta'){
            return "<input type=button onclick='AbrirEncuesta("+JSON.parse(pk)+");' title='"+boton_enviar.title+"' value=' i ' style='font-family:courier; font-weight:bold'>";
        }else if(boton_enviar.accion=='MarcarSupervisiones'){
			/*
            return "<input type=button onclick='alert(\"x"+pk+"x\");' title='"+boton_enviar.title+"' value='S' style='font-family:courier; font-weight:bold'>";
			*/
            return "<input type=button onclick='MarcarSupervisiones("+pk+",this);' title='"+boton_enviar.title+"' value='S' style='font-family:courier; font-weight:bold'>";
        }
    }
}

Editor.url_imagen_loading='url(../imagenes/mini_loading.gif)';
Editor.url_imagen_error='url(../imagenes/mini_Error.png)';
Editor.url_imagen_confirmado='url(../imagenes/mini_confirmado.png)';

Editor.prototype.ancho_fijo=function(esto){
    // /*
    var tabla=esto.parentNode.parentNode;
    tabla.style.tableLayout='fixed';
    tabla.width=window.innerWidth;
// */
/*
	var contenedor=esto.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode;
	contenedor.style.tableLayout='fixed';
	contenedor.width=window.innerWidth;
	// */
/*
	var contenedor=esto.parentNode.parentNode.parentNode;
	contenedor.style.width=window.innerWidth;
	contenedor.width=window.innerWidth;
	contenedor.style.maxWidth=window.innerWidth+"px";
	// */
}

Editor.prototype.herramientas=function(boton_invocador){
    if(confirm('Confirme la habilitación de los botones peligrosos. Ej [B] para borrar registros')){
        var elemento_tr=boton_invocador.parentNode.parentNode; // input->td->tr
        var elemento_table=elemento_tr.parentNode.parentNode; // tr->tHead->table
        elemento_table.setAttribute('nuestro_herramientas_peligrosas',1);
    }
}

Editor.prototype.permitir_agregar_registros=function(boton_invocador){
    var elemento_tr=boton_invocador.parentNode.parentNode; // input->td->tr
    var elemento_table=elemento_tr.parentNode.parentNode; // tr->tbody->table
    for(var i_fila=0; i_fila<elemento_table.rows.length; i_fila++){
        var fila=elemento_table.rows[i_fila];
        var quizas_boton_agregar=fila.cells[0].childNodes[0];
        if(quizas_boton_agregar && quizas_boton_agregar.getAttribute('nuestro_soy')=='boton_agregar'){
            quizas_boton_agregar.style.display='';
        }
    }
}

Editor.prototype.grabar_registro_flotante=function(boton_invocador){
    var elemento_tr=boton_invocador.parentNode.parentNode; // input->td->tr
    var elemento_table=elemento_tr.parentNode.parentNode; // tr->tbody->table
    var editor=this;
    var campos={};
    for(var i_celda=1; i_celda<elemento_tr.cells.length; i_celda++){
        var tipo_campo=elemento_tr.cells[i_celda].getAttribute('nuestro_tipo');
        var nuevo_valor;
        switch(tipo_campo){
            case 'boolean':
                nuevo_valor=formas_de_entender_bool[elemento_tr.cells[i_celda].textContent.toLowerCase()];
                break;
            default:
                nuevo_valor=elemento_tr.cells[i_celda].textContent;
                break;
        }
        campos[elemento_tr.cells[i_celda].getAttribute('nuestro_campo')]=nuevo_valor;
    }
    editor.enviar_a_soporte(
        {
            accion:'agregar_registro_definitivo', 
            grilla:editor.nombre_grilla,
            filtro_para_lectura:editor.filtro_para_lectura,
            campos:campos
        }, 
        boton_invocador, 
        function(respuesta){
            boton_invocador.disabled=true;
            for(var i_celda=1; i_celda<elemento_tr.cells.length; i_celda++){
                elemento_tr.cells[i_celda].contentEditable=false;
            }
            if(respuesta.registros){
                editor.refresco_parcial(respuesta,{agregando:true});
            }
        }
    );
}

Editor.prototype.agregar_un_registro_flotante=function(boton_invocador){
    var editor=this;
    var elemento_tr=boton_invocador.parentNode.parentNode; // input->td->tr
    var elemento_table=elemento_tr.parentNode.parentNode; // tr->tbody->table
    // var pk=elemento_tr.getAttribute('nuestro_pk');
    var nuevo_num_fila=elemento_tr.rowIndex+1;
    var nuevo_tr=elemento_table.insertRow(nuevo_num_fila);
    for(var cada_pk in editor.mapeo_pk_numfila){
        if(editor.mapeo_pk_numfila[cada_pk]>=nuevo_tr.sectionRowIndex){
            editor.mapeo_pk_numfila[cada_pk]++;
        }
    }
    var nueva_celda=nuevo_tr.insertCell(-1);
    nueva_celda.className=elemento_tr.cells[0].className;
    var nuevo_boton_grabar=document.createElement('button');
    nuevo_boton_grabar.textContent='G';
    nuevo_boton_grabar.title='Grabar registro nuevo';
    nuevo_boton_grabar.onclick=function(){
        editor.grabar_registro_flotante(this);
    }
    nueva_celda.appendChild(nuevo_boton_grabar);
    for(var i_col=1; i_col<elemento_tr.cells.length; i_col++){
        var nueva_celda=nuevo_tr.insertCell(-1);
        nueva_celda.className=elemento_tr.cells[i_col].className+' celda_insertando';
        nueva_celda.setAttribute('nuestro_campo',elemento_tr.cells[i_col].getAttribute('nuestro_campo'));
        nueva_celda.setAttribute('nuestro_tipo',elemento_tr.cells[i_col].getAttribute('nuestro_tipo'));
        nueva_celda.contentEditable=true;
        nueva_celda.onkeydown = function(nodo){
            editor.el_onkeydown_de_celdas(this,event);
        };
    }
}

Editor.prototype.eliminar_registro=function(boton_invocador){
    var elemento_tr=boton_invocador.parentNode.parentNode; // input->td->tr
    var elemento_table=elemento_tr.parentNode.parentNode; // tr->tbody->table
    var pk=elemento_tr.getAttribute('nuestro_pk');
    var grilla=elemento_table.getAttribute('nuestro_tabla');
    var herramientas_peligrosas=elemento_table.getAttribute('nuestro_herramientas_peligrosas');
    var editor=this;
    if(boton_invocador.title!='borrado'){
        if(!herramientas_peligrosas){
            alert('Para poder usar este botón debe habilitar las herramients con el botón [H]');
        }else if(confirm('Confirme la eliminación del registro con clave '+pk+' de la tabla ["'+grilla+'"]')){
            boton_invocador.style.backgroundImage=null; // COMPLETAR
            editor.enviar_a_soporte({
                accion:'eliminar_registro', 
                grilla:grilla, 
                pk:JSON.parse(pk)
                }
            , boton_invocador
            , function(respuesta){
                elemento_tr.style.textDecoration='line-through';
                for(var i=0; i<elemento_tr.cells.length; i++){
                    var elemento_td=elemento_tr.cells[i];
                    elemento_td.contentEditable=false;
                }
                boton_invocador.title='borrado';
                delete editor.datos.registros[pk];
                delete editor.datos.atributos_fila[pk];
                delete editor.mapeo_pk_numfila[pk];
            }
            );
        }
    }
}

Editor.prototype.detallar=function(boton_invocador){
    this.detallar=true;
    this.filtro_manual={};
    var elemento_fila=boton_invocador.parentNode.parentNode;
    var pk=JSON.parse(elemento_fila.getAttribute('nuestro_pk'));
    if(pk[0]==undefined){ // es un solo valor, porque la pk tenía un solo campo entonces nuestro_pk es el json del valor y no el json del arreglo de valores
        for(i in this.datos.pks) if(iterable(i,this.datos.pks)){
            this.filtro_manual[this.datos.pks[i]]=pk;
        }
    }else{
        for(i in this.datos.pks) if(iterable(i,this.datos.pks)){
            this.filtro_manual[this.datos.pks[i]]=pk[i];
        }
    }
    this.cargar_grilla(document.body,false);
}

var copiar_formato_de_nodos={TD:true, SPAN:true, DIV:true}
//var copiar_formato_de_atributos={'font-size':true, 'font-color':true, 'background-color':true, 'border':true}
var copiar_formato_de_atributos={'font':true, 'background':true, 'border':true}

function reemplazar_input_por_span(nodos){
    for(var i in nodos.childNodes) if(iterable(i,nodos.childNodes)){
        var nodo=nodos.childNodes[i];
        if(nodo.nodeName=='INPUT'){
            var span=document.createElement('span');
            span.textContent=nodo.value;
            nodos.replaceChild(span,nodo);
        }else{
            reemplazar_input_por_span(nodo);
        }
        if(copiar_formato_de_nodos[nodo.nodeName]){
            var formato=window.getComputedStyle(nodo,null);
            for(var atributo in copiar_formato_de_atributos){
                var valor;
                if(valor=formato.getPropertyValue(atributo)){
                    nodo.style[atributo]=valor;
                }
            }
        }
    }
}

function reemplazar_estilos(nodos){
    for(var i in nodos.childNodes) if(iterable(i,nodos.childNodes)){
        var nodo=nodos.childNodes[i];
        reemplazar_estilos(nodo);
        if(copiar_formato_de_nodos[nodo.nodeName]){
            var formato=window.getComputedStyle(nodo,null);
            for(var atributo in copiar_formato_de_atributos){
                var valor;
                if(valor=formato.getPropertyValue(atributo)){
                    nodo.style[atributo]=valor;
                }
            }
        }
    }
}

Editor.angostar_renglones=function(boton){
"use strict";
    var tabla=boton;
    while(tabla && (tabla.nodeName!='TABLE')){
        tabla=tabla.parentNode;
    }
    if(tabla){
        var angostar=tabla.style.whiteSpace!='nowrap';
        tabla.style.whiteSpace=angostar?'nowrap':'inherit';
        tabla.style.overflow=angostar?'hidden':'visible';
        boton.value=angostar?'↯':'⌆';
        boton.title=angostar?'dejar de angostar renglones':'angostar renglones';
    }
}

Editor.trabar_edicion=function(boton){
"use strict";
    var tabla=boton;
    while(tabla && (tabla.nodeName!='TABLE')){
        tabla=tabla.parentNode;
    }
    if(tabla){
        boton.trabar=!boton.trabar;
        boton.value=!boton.trabar?'⌨':'✍';
        boton.title=!boton.trabar?'trabar ediciones involuntarias':'permitir edición libre en toda la grilla (para un solo campo hacer doble click en él)';
        var elementos=tabla.querySelectorAll(".editables");
        for(var i=0; i<elementos.length; i++){
            elementos[i].contentEditable=!boton.trabar;
        }
    }
}

Editor.exportar_excel=function(nodo){
"use strict";
    document.body.style.cursor = "wait";
    var tabla=nodo;
    while(tabla && (tabla.nodeName!='TABLE')){
        tabla=tabla.parentNode;
    }
    if(tabla){
        var rta=document.createElement('table');
        rta.innerHTML=tabla.innerHTML;
        reemplazar_input_por_span(rta);
        try{
            document.body.appendChild(rta);
            reemplazar_estilos(rta);
        }finally{
            document.body.removeChild(rta);
        }
        var formExpo=document.createElement('form');
        formExpo.action='../tedede/exportar_html.php';
        formExpo.method='post';
        formExpo.target='_blank';
        formExpo.id='FormularioExportacion';
        formExpo.innerHTML='<input type=hidden id=cuadro name=cuadro>';
        document.body.appendChild(formExpo);
        document.getElementById("cuadro").value=rta.outerHTML;
        document.forms["FormularioExportacion"].submit();
        document.body.removeChild(formExpo);
    }
/*
    nodo.focus();
    nodo.select();
    document.execCommand( 'Copy' );
    alert('listo');
*/    
    document.body.style.cursor = "default";
}

Editor.prototype.ordenar_por_columna=function(boton_invocador){
    var editor=this;
    var elemento_td=boton_invocador.parentNode; // input->td
    var elemento_tr=elemento_td.parentNode; // td->tr
    var elemento_table=elemento_tr.parentNode.parentNode; // tr->tbody->table
    editor.ordenariando=[];
    var campo=elemento_td.getAttribute('nuestro_campo');
    var estaba_en=editor.ordenar_por_campos.indexOf(campo);
    if(estaba_en>=0){
        editor.ordenar_por_campos.splice(estaba_en,1);
    }
    editor.ordenar_por_campos.unshift(campo);
    // creo un array paralelo para ordenar
    for(var pk in editor.datos.registros){
        var orden=[];
        for(var i_campo in editor.ordenar_por_campos) if(iterable(i_campo,editor.ordenar_por_campos)){
            campo=editor.ordenar_por_campos[i_campo];
            orden.push(para_ordenar_numeros(editor.datos.registros[pk][campo]));
        }
        
        editor.ordenariando.push({
            orden:orden,
            pk:pk
        });
    }
    editor.ordenariando.sort(function(a,b){
        return a.orden==b.orden?0:(a.orden<b.orden?-1:1);
    });
    editor.refrescar();
}

Editor.prototype.ocultar_columna=function(boton_invocador){
    var editor=this;
    var elemento_td=boton_invocador.parentNode; // input->td
    var campo=elemento_td.getAttribute('nuestro_campo');
    editor.datos.definicion_campos[campo].invisible=true;
    editor.invisibles.push(campo);
    editor.refrescar();
}

Editor.prototype.mas_info_columna=function(boton_invocador){
    var editor=this;
    var elemento_td=boton_invocador.parentNode; // input->td
    var campo=elemento_td.getAttribute('nuestro_campo');
    var nuevo_valor=!editor.datos.definicion_campos[campo].masInfo;
    editor.datos.definicion_campos[campo].masInfo=nuevo_valor;
    editor.refrescar();
}

Editor.prototype.leer_anotaciones=function(num_col){
    var editor=this;
    if(!num_col){
        alert('no tengo num_col:'+num_col);
        return;
    }
    var celda_th=editor.tabla.tHead.rows[0].cells[num_col];
    editor.enviar_a_soporte({
        accion:'leer anotaciones', 
        grilla:editor.nombre_grilla
        }
    , celda_th 
    , function(respuesta){
        var tBodie=editor.tabla.tBodies[0];
        for(var i=0; i<editor.ordenariando.length; i++){
            var pk=editor.ordenariando[i].pk;
            var anotacion=respuesta[pk];
            var celda=tBodie.rows[i].cells[num_col];
            if(anotacion){
                celda.textContent=anotacion.mostrar;
                editor.datos.registros[pk].aux_anotacion=anotacion.mostrar;
                celda.title=anotacion.title;
            }else{
                celda.textContent='\u20AA';// '\u2123';
            }
        }
    }
    , true
    , true
    );
}

Editor.prototype.agregar_un_registro=function(boton_invocador){
    var editor=this;
    editor.enviar_a_soporte(
        {
            accion:'agregar_registro_provisorio', 
            grilla:editor.nombre_grilla,
            filtro_para_lectura:editor.filtro_para_lectura
        }, 
        boton_invocador, 
        function(respuesta){
            editor.datos=respuesta;
            editor.ordenariando=null;
            editor.refrescar();
        }
    );
}

Editor.prototype.abrir_subzona=function(celda_invocadora,texto_funcion_refrescar){
    var editor=this;
    var elemento_tr=celda_invocadora.parentNode; // input->td->tr
    var pk=elemento_tr.getAttribute('nuestro_pk');
    var elemento_table=elemento_tr.parentNode.parentNode; // tr->tbody->table
    var tmpRow=elemento_table.insertRow(elemento_tr.rowIndex+1);
    var tmpCell=tmpRow.insertCell(-1); // primera fila para poner el botón cerrar
    tmpCell.innerHTML=editor.HTML.boton_quitar_tr
    // +editor.HTML.boton_refrescar_tr.replace('texto_funcion_refrescar','"'+texto_funcion_refrescar+'"')
    ;
    tmpCell.setAttribute('columna_celda_madre',celda_invocadora.cellIndex);
    tmpCell=tmpRow.insertCell(-1);
    tmpCell.colSpan=editor.datos.cantidad_columnas-1;
    tmpCell.style.backgroundColor='lightCyan'; // '#8CF0E6';
    tmpCell.style.fontSize='100%';
    var tabla=document.createElement('table');
    tabla.className='sub_tabla';
    tabla.style.fontSize='120%';
    tmpCell.appendChild(tabla);
    tmpCell.className='sub_tabla';
    var unica_fila=tabla.insertRow(-1);
    unica_fila.className='sub_tabla';
    return {
        unica_fila:unica_fila, 
        pk:pk
    };
}

Editor.prototype.abrir_detalles_y_anotaciones=function(celda_invocadora){
    var editor=this;
    var zona=editor.abrir_subzona(celda_invocadora,'abrir_detalles_y_anotaciones');
    editor.agregar_subgrilla(zona.unica_fila, 'con_var', 'convar_', zona.pk, celda_invocadora);
    editor.agregar_subgrilla(zona.unica_fila, 'ano_con', 'anocon_', zona.pk, celda_invocadora);
    var tmpCell=zona.unica_fila.insertCell(-1);
    var esta=JSON.stringify(JSON.parse(zona.pk)[0]);
    esta="otra cosa a ver si era eso";
    tmpCell.innerHTML="<input type=button value='agregar anotación' onclick='"+editor.nombre_de_esta_variable+".agregar_anotacion(this,"+JSON.stringify(JSON.parse(zona.pk)[0])+")'>";
// tmpCell.innerHTML="<input type=button value='agregar anotación' onclick='"+editor.nombre_de_esta_variable+".agregar_anotacion(this,"+esta+")'>";
}

Editor.prototype.abrir_subgrilla=function(celda_invocadora,nombre_grilla,pk_subgrilla,mantener_arbol){
    var editor=this;
    var nombre_subgrilla=nombre_grilla||celda_invocadora.getAttribute('nuestro_campo').substr('aux_cant_'.length);
	var tablas_tmep = celda_invocadora.parentNode.parentNode.getElementsByTagName("table");
	var parent_subgrilla_existente;
	for(var tr = 0; tr<tablas_tmep.length;tr++){
		if(tablas_tmep[tr].getAttribute('nuestro_tabla') == nombre_subgrilla){
			parent_subgrilla_existente = celda_invocadora.parentNode;
			parent_subgrilla_existente.nextSibling.parentNode.removeChild(parent_subgrilla_existente.nextSibling);
		}
	}
    var zona=editor.abrir_subzona(celda_invocadora,'abrir_subgrilla');
    if(!mantener_arbol){
        guardar_en_localStorage("editor_arbol_profundidad",editor.profundidad+1);
        guardar_en_localStorage("editor_arbol_profundidad_"+editor.profundidad+1,JSON.stringify(
        {
            pk_fila:celda_invocadora.parentNode.getAttribute('nuestro_pk')
            , 
            num_columna:celda_invocadora.cellIndex
            , 
            nombre_grilla:nombre_grilla
            , 
            filtro_para_lectura:pk_subgrilla
        }
        ));
    }
    return editor.agregar_subgrilla(zona.unica_fila, nombre_subgrilla, nombre_subgrilla.substr(0,3)+'_', pk_subgrilla||zona.pk, celda_invocadora, mantener_arbol);
}

Editor.prototype.agregar_subgrilla=function(unica_fila, nombre_grilla, prefijo_tabla, pk_plana, elemento_para_tilde, mantener_arbol){
    var indice_editor=nombre_grilla+':'+pk_plana+':sub';
    var filtro_para_lectura={};
    filtro_para_lectura=JSON.parse(pk_plana);
    var editor=new Editor(indice_editor,nombre_grilla,filtro_para_lectura,this.profundidad+1);
    var tmpCell=unica_fila.insertCell(-1);
    tmpCell.innerHTML=editor.obtener_el_contenedor('span');
    tmpCell.className='sub_tabla';
    editor.cargar_grilla(elemento_para_tilde, mantener_arbol);
    return editor;
}

Editor.prototype.quitar_tr=function(boton_invocador, indice_editor){
    var editor=this;
    editor_elegido=indice_editor;
    guardar_en_localStorage("editor_arbol_profundidad",editor.profundidad);
    var elemento_tr=boton_invocador.parentNode.parentNode; // input->td->tr
    var elemento_table=elemento_tr.parentNode.parentNode; // tr->tbody->table
    elemento_table.deleteRow(elemento_tr.rowIndex);
}

Editor.prototype.refrescar_tr=function(boton_invocador,texto_funcion_refrescar){
    var columna_celda_madre=boton_invocador.parentNode.getAttribute('columna_celda_madre');
    var elemmento_tr=boton_invocador.parentNode.parentNode;
    var celda_madre=elemmento_tr.previousElementSibling.cells[columna_celda_madre];
    if(!celda_madre){
        alert('sin celda madre');
    }
    editor.quitar_tr(boton_invocador);
    editor[texto_funcion_refrescar](celda_madre);
}

Editor.prototype.agregar_anotacion=function(boton_invocador,consistencia){
    var editor=this;
    var anotacion=prompt('Anotación para la consistencia '+consistencia);
    if(anotacion){
        editor.enviar_a_soporte({
            accion:'anotar consistencia', 
            grilla:'consistencias', 
            consistencia:consistencia, 
            anotacion:anotacion
        }
        , boton_invocador
        , function(){
            var tabla=boton_invocador.parentNode.parentNode.parentNode.parentNode;
            var boton_invocante=tabla.parentNode.parentNode.cells[0].childNodes[0];
            editor.refrescar_tr(boton_invocante);
        }
        );
    }
}

Editor.prototype.asignar_valor=function(elemento,dato,tipo){
    var mostrar;
    var mostrarHTML;
    if(dato===null || dato===''){
        mostrar='';
    }else if(dato===false){
        mostrar="no";
        mostrarHTML="<small><i>no</i></small>";
    }else if(dato===true){
        mostrar="Sí";
        mostrarHTML="<b>Sí</b>";
    }else if(tipo==='timestamp'){
        var fecha=new Date(dato);
        if(fecha.toString()=='Invalid Date'){
            fecha=new Date(dato.substr(0,10)+'T'+dato.substr(11,8)+'Z');
        }
        mostrar=fecha.getDate()+'/'+(fecha.getMonth()+1)+'/'+fecha.getFullYear()+' '+fecha.getHours()+':'+fecha.getMinutes();
        mostrarHTML='<span title="'+fecha.getHours()+':'+fecha.getMinutes()+'">'+fecha.getDate()+'/'+(fecha.getMonth()+1)+'<small>/'+fecha.getFullYear()+'</small></span>';
    }else if(typeof(dato)=='object' && 'mostrar' in dato){
        mostrar=dato.mostrar;
    }else{
        mostrar=dato;
    }
    if(elemento && 'innerText' in elemento){
        if(mostrarHTML){
            elemento.innerHTML=mostrarHTML;
        }else{
            elemento.textContent = mostrar;
        }
    }
    return ''+mostrar;
}

var editor_elegido=null;
var en_celda=false;
var editores={};

document.addEventListener('keydown',function(evento){
    if(!en_celda && evento.which==67 && evento.ctrlKey){ // Ctrl-C
        if(editor_elegido && editores[editor_elegido] && editores[editor_elegido].datos){
            var datos=editores[editor_elegido].datos.registros;
            elemento_existente('div_para_portapapeles').style.visibility='visible';
            var para_portapapeles=elemento_existente('para_portapapeles'); 
            // para_portapapeles.style.visibility='visible';
            var rta='';
            var rta_tit='';
            var num_linea=0;
            for(var pk in datos){
                var linea=datos[pk];
                for(var columna in linea){
                    if(!num_linea){
                        rta_tit+=columna+'\t';
                    }
                    var celda=linea[columna];
                    rta+=editor.asignar_valor(null,celda).replace(/[\t\r\n]/g,' ')+'\t';
                }
                rta+='\n';
                num_linea++;
            }
            para_portapapeles.value=rta_tit+'\n'+rta;
            para_portapapeles.focus();
            para_portapapeles.select();
            setTimeout("elemento_existente('div_para_portapapeles').style.visibility='hidden';",3000);
        }
    } 
    if(!en_celda && evento.which==88 && evento.ctrlKey){ // Ctrl-X
        if(editor_elegido && editores[editor_elegido] && editores[editor_elegido].datos){
            datos=editores[editor_elegido].datos.registros;
            var enHTML = "<Table>";
            var titEnHtml= "<tr>";
            var cpoEnHtml = "<tr>";
            // para_portapapeles.style.visibility='visible';
            elemento_existente('div_para_portapapeles').style.visibility='visible';
            num_linea=0;
            for(pk in datos){
                linea=datos[pk];
                for(columna in linea){
                    if(!num_linea){
                        titEnHtml += "<td>"+columna + "</td>";
                    }
                    celda=linea[columna];
                    cpoEnHtml += "<td>"+editor.asignar_valor(null,celda).replace(/[\t\r\n]/g,' ')+ "</td>";
                }
                num_linea++;
                cpoEnHtml += "</tr>";
            }
            titEnHtml += "</tr>";
            enHTML += titEnHtml + cpoEnHtml + "</table>";
            var formExpo = "<form action=\"ficheroExcel.php\" method=\"post\" target=\"_blank\" id=\"FormularioExportacion\"><p>Exportar a Excel  </p><input type=\"hidden\" id=\"datos_a_enviar\" name=\"datos_a_enviar\" /></form>";  
                    
            document.getElementById("div_para_portapapeles").innerHTML = document.getElementById("div_para_portapapeles").innerHTML+formExpo;
            document.getElementById("datos_a_enviar").value = enHTML;
            document.forms["FormularioExportacion"].submit();
                    
            var contenedor = document.getElementById("div_para_portapapeles");
            var hijo = document.getElementById("FormularioExportacion");
            contenedor.removeChild(hijo);
            setTimeout("elemento_existente('div_para_portapapeles').style.visibility='hidden';",3000);
                    
        }
    } 
});  

