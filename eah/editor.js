"use strict";
// editor.js

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

function Editor(indice_editor,nombre_grilla,filtro_para_lectura,profundidad){
    this.indice_editor=indice_editor;
    this.nombre_grilla=nombre_grilla;
    this.profundidad=profundidad||1;
    this.datos=null;
    this.ordenariando;
    this.mapeo_pk_numfila={};
    this.con_anotaciones=false;
    this.HTML={};
    this.tabla=null;
    this.filtro_para_lectura=filtro_para_lectura;
    this.nombre_de_esta_variable='editores['+this.indice_editor.encomillar()+']';
    for(var clave in Editor.HTML){
        if(typeof(Editor.HTML[clave])=='string'){
            this.HTML[clave]=Editor.HTML[clave].replace('@@@@',this.nombre_de_esta_variable)
            .replace('@@@#',JSON.stringify(this.indice_editor));
        }else{
            this.HTML[clave]=Editor.HTML[clave];
        }
    }
    editores[this.indice_editor]=this;
}

Editor.prototype.obtener_el_contenedor=function(clase){
    clase=clase||'div';
    return "<"+clase+" id='"+this.nombre_de_esta_variable+"' style='background-image=url(imagenes/cargando.gif); background-repeat:no-repeat; min-width:100px; min-height:40px'></"+clase+">";
}

Editor.prototype.poner_el_contenedor=function(){
    document.write(this.obtener_el_contenedor());
}

Editor.id_temporario=1;

Editor.quitar_fondo=function(elemento_id){
    var elemento=elemento_existente(elemento_id);
    elemento.style.backgroundImage='none';
    elemento.style.backgroundRepeat='';
    elemento.style.backgroundPosition='';
}

Editor.enviar_a_soporte=function(parametros, elemento, hacer_si_ok, asincronico, sin_confirmar){
    elemento.style.backgroundImage=Editor.url_imagen_loading;
    elemento.style.backgroundRepeat='no-repeat';
    elemento.style.backgroundPosition='top right';
    Enviar('editor_soporte.php',parametros
        ,function(mensaje){
            hacer_si_ok(mensaje);
            if(!elemento.id){
                elemento.id="id_temporario"+Editor.id_temporario++;
            }
            if(sin_confirmar){
                Editor.quitar_fondo(elemento.id);
            }else{
                setTimeout('Editor.quitar_fondo('+elemento.id.encomillar()+')',3000);
                elemento.style.backgroundImage=Editor.url_imagen_confirmado;
                elemento.style.backgroundRepeat='no-repeat';
                elemento.style.backgroundPosition='top right';
            }
        }
        , function(mensaje_error){
            elemento.style.backgroundImage=Editor.url_imagen_error;
            elemento.title=mensaje_error;
        }
        , asincronico
        );
}

Editor.prototype.cargar_grilla=function(elemento_para_el_tilde,mantener_arbol){
    var editor=this;
    editor_elegido=editor.indice_editor;
	var fondo=elemento_para_el_tilde||elemento_existente(this.nombre_de_esta_variable);
	var hasta_profundidad=localStorage["editor_arbol_profundidad"];
	Editor.enviar_a_soporte({
		accion:'leer grilla', 
		grilla:this.nombre_grilla, 
		filtro_para_lectura:this.filtro_para_lectura
		}
	, fondo
	, function(datos){
		editor.datos=datos;
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
	}
	,true
	);
}

Editor.prototype.refrescar=function(){
    var editor=this;
    var elemento_destino_grilla=elemento_existente(editor.nombre_de_esta_variable);
    var cant_filas=editor.datos.cantidad_registros;
    if(cant_filas==0){
        elemento_destino_grilla.innerHTML="";
    }else{
        var tabla=document.createElement("table");
        this.tabla=tabla;
        tabla.id="t:"+this.nombre_de_la_variable;
        tabla.className="editor_tabla";
        tabla.border=1;
        tabla.setAttribute('nuestro_tabla',editor.nombre_grilla);
        var pk;
        var fila;
        var colocar_fila=function(){
            fila=editor.datos.registros[pk];
            var tmpRow = null;
            tmpRow=tabla.insertRow(-1);
            tmpRow.setAttribute('nuestro_pk',pk);
            tmpRow.name=pk;
            editor.mapeo_pk_numfila[pk]=tmpRow.rowIndex;
            var tmpCell = null;
            tmpCell=tmpRow.insertCell(-1);
            if(editor.datos.puede_eliminar){
                tmpCell.innerHTML=editor.HTML.boton_eliminar_registro;
            }
            if(editor.datos.boton_enviar){
                // tmpCell.innerHTML+=editor.HTML.boton_enviar(editor.datos.boton_enviar);
                tmpCell.innerHTML=tmpCell.innerHTML+editor.HTML.boton_enviar(editor.datos.boton_enviar,pk);
                tmpCell.className='editor_botonera_registro';
            }
            for(var campo in fila){ 
                var dato=fila[campo];
                tmpCell=tmpRow.insertCell(-1);
                tmpCell.onblur = function(nodo){
                    editor.el_onblur_de_celdas(this);
                };
                tmpCell.onfocus = function(nodo){
                    editor.el_onfocus_de_celdas(this);
                };
                tmpCell.onkeydown = function(nodo){
                    editor.el_onkeydown_de_celdas(this,event);
                };
                tmpCell.onkeypress = function(nodo){
                    editor.el_onkeypress_de_celdas(this,event);
                };
                tmpCell.setAttribute('nuestro_campo',campo);
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
                                throw new Exception("No está definida la forma de ver los subdatos de "+nombre_subgrilla);
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
                }
                editor.asignar_valor(tmpCell,dato);
                tmpCell.setAttribute('nuestro_tipo',typeof dato);
                if(typeof dato=='boolean'){
                    tmpCell.onfocus=function(){
                        editor.el_onfocus_de_bool(this);
                    };
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
        var tmpRow=tHead.insertRow(-1);
        tmpRow.className = 'tabla_titulos';
        var tmpCell = null;
        tmpCell=tmpRow.insertCell(-1);
        if(editor.datos.puede_insertar){
            tmpCell.innerHTML=editor.HTML.boton_agregar_registro;
        }
        for(var campo in fila){ 
            tmpCell=tmpRow.insertCell(-1);
            if(campo=='aux_anotacion'){
                setTimeout(editor.nombre_de_esta_variable+'.leer_anotaciones('+tmpCell.cellIndex+');',1000);
            }
            campo=campo.replace(editor.datos.rexexp_remover_en_nombre_de_campo,'').replace(/_/g,' ');
            tmpCell.textContent = campo;
        }
        editor.datos.cantidad_columnas=tmpRow.cells.length;
        var tmpRow=tHead.insertRow(-1);
        tmpRow.className = 'tabla_titulos';
        var tmpCell = null;
        tmpCell=tmpRow.insertCell(-1);
        tmpCell.innerHTML=editor.HTML.boton_herramientas;
        for(var campo in fila){ 
            tmpCell=tmpRow.insertCell(-1);
            tmpCell.innerHTML = editor.HTML.boton_ordenar;
            tmpCell.setAttribute('nuestro_campo',campo);
        }
        var tmpCaption=tabla.createCaption();
        tmpCaption.className="tabla_titulos";
        tmpCaption.innerHTML=
        //Editor.HTML_boton_ancho_fijo+Editor.HTML_separador_vertical+
        "Tabla: <b><span style='font-size:120%'>"+editor.nombre_grilla+"</span></b>, registros: "+cant_filas;
        elemento_destino_grilla.innerHTML="";
        elemento_destino_grilla.appendChild(tabla);
        return tabla;
    }
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
}

var mostrar_proxima_tecla=false;

Editor.prototype.el_onkeydown_de_celdas=function(nodo,evento){
    var editor=this;
    var proxima_celda
    if(evento.which==40 || evento.which==38){ // KeyDown, KeyUp
        var proxima_celda=editor.nodo_de_arriba_o_abajo(nodo,evento.which-39);
    }
    if(evento.ctrlKey && (evento.which==37 || evento.which==39)){ // izquierda o derecha
        proxima_celda=editor.nodo_de_izquierda_o_derecha(nodo,evento.which-38);
    }
    if(evento.ctrlKey && (evento.which==36)){ // home
        proxima_celda=editor.nodo_de_izquierda_o_derecha(nodo,1,-1);
    }
    if(evento.ctrlKey && (evento.which==35)){ // end
        proxima_celda=editor.nodo_de_izquierda_o_derecha(nodo,-1,nodo.parentNode.cells.length);
    }
    if(proxima_celda){
        proxima_celda.focus();
    }
    // 36 home 35 end 37 <=   => 39
    if(mostrar_proxima_tecla){
        var mostrar='evento: ';
        for(var i in evento){
            mostrar+=i+'='+evento[i]+' ';
        }
        alert(mostrar);
    }
    if(evento.which==113){
        mostrar_proxima_tecla=!mostrar_proxima_tecla;
    }
    if(evento.which==115){ //F4
        var celda_de_arriba=editor.nodo_de_arriba(nodo);
        if(celda_de_arriba){
            nodo.textContent=celda_de_arriba.textContent;
        }
        var celda_de_la_proxima_fila=editor.nodo_de_abajo(nodo);
        if(celda_de_la_proxima_fila){
            celda_de_la_proxima_fila.focus();
        }else{
            nodo.onblur();
        // editor.el_onblur
        }
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
    }else{
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
        nodo.style.backgroundImage=Editor.url_imagen_loading;
        nodo.style.backgroundRepeat='no-repeat';
        nodo.style.backgroundPosition='top right';
        var celda=nodo;
        Editor.enviar_a_soporte({
            accion:'grabar campo', 
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
                var fila=celda.parentNode;
                fila.setAttribute('nuestro_pk',respuesta.pk);
                delete editor.datos.registros[pk];
                editor.ordenariando=null;
            }
            editor.asignar_valor(celda,respuesta.valor_grabado);
        }
        );
    }
}

Editor.prototype.el_onfocus_de_celdas=function(nodo){
    en_celda=true;
}

Editor.prototype.el_onfocus_de_bool=function(nodo){
    var valor=nodo.textContent;
    if(valor.length>1){
        nodo.textContent=valor.substr(0,1);
    }
}

Editor.HTML={
    separador_vertical:" | "
    , 
    boton_ancho_fijo:"<input type=button value='Ancho Fijo' onclick='@@@@.ancho_fijo(this);'>"
    , 
    boton_herramientas:"<input type=button value=H class=editor_registro_boton title='Herramientas' onclick='@@@@.herramientas(this);'>"
    , 
    boton_exportar_excel:"<input type=button value=X class=editor_registro_boton title='Exportar a Excel' onclick='@@@@.exportar_excel(this);'>"
    , 
    boton_eliminar_registro:"<input type=button value='B' class='editor_registro_boton' title='Borrar registro' onclick='@@@@.eliminar_registro(this);'>"
    , 
    boton_ordenar:"<input type=button value='O' title='ordenar usando esta columna' onclick='@@@@.ordenar_por_columna(this)'>"
    , 
    boton_agregar_registro:"<input type=button value='A' title='Agregar un registro' onclick='@@@@.agregar_un_registro(this)'>"
    , 
    boton_quitar_tr:"<input type=button value='&#150;' title='ocultar' onclick='@@@@.quitar_tr(this,@@@#)'>"
    , 
    boton_refrescar_tr:"<input type=button value='&#8634;' title='refrescar' onclick='@@@@.refrescar_tr(this,texto_funcion_refrescar)'>"
    , 
    boton_enviar: function(boton_enviar,pk){
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

Editor.url_imagen_loading='url(imagenes/mini_loading.gif)';
Editor.url_imagen_error='url(imagenes/mini_Error.png)';
Editor.url_imagen_confirmado='url(imagenes/mini_confirmado.png)';

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
            boton_invocador.style.backgroundImage=
            Editor.enviar_a_soporte({
                accion:'eliminar registro', 
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
            }
            );
        }
    }
}

Editor.prototype.exportar_excel=function(nodo){
    var editor=this;
    nodo.focus();
    nodo.select();
    document.execCommand( 'Copy' );
    alert('listo');
}

Editor.prototype.ordenar_por_columna=function(boton_invocador){
    var editor=this;
    var elemento_td=boton_invocador.parentNode; // input->td
    var elemento_tr=elemento_td.parentNode; // td->tr
    var elemento_table=elemento_tr.parentNode.parentNode; // tr->tbody->table
    editor.ordenariando=[];
    var campo=elemento_td.getAttribute('nuestro_campo');
    for(var pk in editor.datos.registros){
        editor.ordenariando.push({
            orden:para_ordenar_numeros(editor.datos.registros[pk][campo]),
            pk:pk
        });
    }
    editor.ordenariando.sort(function(a,b){
        return a.orden==b.orden?0:(a.orden<b.orden?-1:1);
    });
    editor.refrescar();
}

Editor.prototype.leer_anotaciones=function(num_col){
    var editor=this;
    if(!num_col){
        alert('no tengo num_col:'+num_col);
        return;
    }
    var celda_th=editor.tabla.tHead.rows[0].cells[num_col];
    Editor.enviar_a_soporte({
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
    Editor.enviar_a_soporte({
        accion:'agregar registro provisorio', 
        grilla:editor.nombre_grilla
        }
    , boton_invocador
    , function(respuesta){
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
    var esta=JSON.parse(zona.pk)[0].encomillar();
    esta="otra cosa a ver si era eso";
    tmpCell.innerHTML="<input type=button value='agregar anotación' onclick='"+editor.nombre_de_esta_variable+".agregar_anotacion(this,"+JSON.parse(zona.pk)[0].encomillar()+")'>";
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
        Editor.enviar_a_soporte({
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

Editor.prototype.asignar_valor=function(elemento,dato){
    var mostrar;
    if(dato===null){
        mostrar='';
    }else if(dato===false){
        mostrar="no";
    }else if(dato===true){
        mostrar="Sí";
    }else if(typeof(dato)=='object' && 'mostrar' in dato){
        mostrar=dato.mostrar;
    }else{
        mostrar=dato;
    }
    if(elemento && 'innerText' in elemento){
        if(dato===false){
            elemento.innerHTML="<small><i>no</i></small>";
        }else if(dato===true){
            elemento.innerHTML="<b>Sí</b>";
        }else{
            elemento.textContent = mostrar;
        }
    }
    return ''+mostrar;
}

var editor_elegido=null;
var en_celda=false;
var editores={};

document.onkeydown=function(){
	
    if(!en_celda && event.which==67 && event.ctrlKey){ // Ctrl-C
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
        if(!en_celda && event.which==88 && event.ctrlKey){ // Ctrl-X
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
   
}
function SetPieRemito(event){
    
    //var tamano = document.body.clientHeight;
    var tamano = document.body.offsetHeight;
    var paginas = 0;
    var resto = 0;
            
    paginas = tamano / 1318;
    resto = tamano % 1318;
    paginas = Math.floor(paginas);
                        
    if((1338 - resto) > 75 ){
        paginas++;
    }
    var altura = (1318 * paginas) - 75;
    document.getElementById("PieDePagina").style.top = altura.toString() + "px";
    document.getElementById("PieDePagina").style.position="absolute";
    document.getElementsByTagName("html").style.zoom = 1;
    
          
}

