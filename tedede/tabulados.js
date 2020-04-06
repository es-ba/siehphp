"use strict";
//
function Tabulados(){ // Objeto tabulados
    this.destino=document.getElementById('proceso_formulario_respuesta');
    this.claseTabla='tabulado';
    this.claseCap='tabulado_titulo';
}

Tabulados.prototype.preparar_destino=function(){ 
    if(!this.destino){ throw new Error('falta el destino para el tabulado'); }
    this.destino.innerHTML='';
    this.tabla=document.createElement('table');
    this.cap=this.tabla.createCaption();
    if(this.datos.expandido=='no'){
        this.datos.titulo=this.datos.titulo+ ' (MUESTRAL) ';
    }
    this.cap.textContent=this.datos.titulo;
    this.cap.className=this.claseCap;
    this.tabla.className=this.claseTabla;
    this.encabezado=this.tabla.createTHead();
    this.cuerpo=this.tabla.createTBody();
    this.numero_columna_segun_encabezado={}; // para cada posible elemento del encabezado devuelve el número de columna donde poner el dato, se calcula al colocar los encabezados y se usa al colocar los datos. 
    this.cantidad_campos={arriba:0, izquierda:0, esquina:0, centro:0};
    this.datos.ultimo_campo={arriba:null, izquierda:null, esquina:null, centro:null};
    this.datos.primer_campo={arriba:null, izquierda:null, esquina:null, centro:null};
    for(var n_campo in this.datos.campos){
        this.cantidad_campos[this.datos.campos[n_campo].posicion]++;
        this.datos.primer_campo[this.datos.campos[n_campo].posicion]=this.datos.primer_campo[this.datos.campos[n_campo].posicion] || n_campo;
        this.datos.ultimo_campo[this.datos.campos[n_campo].posicion]=n_campo;
    }
    proceso_formulario_respuesta.appendChild(this.tabla);
}

Tabulados.prototype.etiqueta_valor=function(registro, n_campo){
    var valor_pk=registro[n_campo];
    var valor_a_mostrar;
    if(this.datos.campos[n_campo].lookup && valor_pk in this.datos.campos[n_campo].lookup){
        valor_a_mostrar=this.datos.campos[n_campo].lookup[valor_pk];
    }else{
        valor_a_mostrar=valor_pk;
    }
    return valor_a_mostrar;            
}

Tabulados.prototype.obtener_matriz=function(){  
    this.matriz={
        superior:[],
        central:[],
        numero_columnas_campo_arriba:{},
        fila_de_la_clave_fila:{}
    }
    if(this.datos.tipo_tabulado!='frecuencia' && this.datos.tipo_tabulado!='promedio' && this.datos.tipo_tabulado!='mediana' && this.datos.tipo_tabulado!='suma'){
        for(var n_campo_a in this.datos.campos) if(this.datos.campos[n_campo_a].posicion=='arriba'){
            var fila={lateral:[], medio:[]};
            for(var n_campo_i in this.datos.campos) if(this.datos.campos[n_campo_i].posicion=='izquierda'){
                var celda=null;
                fila.lateral.push(celda);
            }        
        }
        for(var n_campo_i in this.datos.campos) if(this.datos.campos[n_campo_i].posicion=='arriba'){
            var colag = Math.round((this.datos.columnas.length-1)/2);
            for(var i=0; i<colag; i++){
                var celda=null;
                celda='';
                fila.lateral.push(celda);
            }
            var celda=null;
            celda=this.datos.campos[n_campo_i].titulo;
            fila.lateral.push(celda);
        }  
        this.matriz.superior.push(fila); 
    }    
    for(var n_campo_a in this.datos.campos) if(this.datos.campos[n_campo_a].posicion=='arriba'){
        var fila={lateral:[], medio:[]};
        for(var n_campo_i in this.datos.campos) if(this.datos.campos[n_campo_i].posicion=='izquierda'){
            var celda=null;
            if(n_campo_a==this.datos.ultimo_campo['arriba']){
                celda=this.datos.campos[n_campo_i].titulo;
            }
            fila.lateral.push(celda);
        }
        for(var i=0; i<this.datos.columnas.length; i++){
            var celda={
                valor:this.datos.columnas[i][n_campo_a],
                campo:n_campo_a
            }
            if(n_campo_a==this.datos.ultimo_campo['arriba']){
                this.matriz.numero_columnas_campo_arriba[JSON.stringify(this.datos.columnas[i])]=i;
            }
            fila.medio.push(celda);
        }
        this.matriz.superior.push(fila);
    }
    this.matriz.fila_de_la_clave_fila={}; // voy a mantener un registro indexado por la pk de la fila de cada fila insertada
    for(var i_cuerpo=0; i_cuerpo<this.datos.cuerpo.length; i_cuerpo++){
        var registro_cuerpo=this.datos.cuerpo[i_cuerpo];
        var registro={izquierda:{}, arriba:{}, esquina:{}, centro:{}};
        for(var n_campo in this.datos.campos){
            registro[this.datos.campos[n_campo].posicion][n_campo]=registro_cuerpo[n_campo];
        }
        var clave_fila=JSON.stringify(registro.izquierda);  
        if(this.matriz.fila_de_la_clave_fila[clave_fila]){
            var fila=this.matriz.fila_de_la_clave_fila[clave_fila];
        }else{
            var fila={lateral:[], medio:[], tipo_fila:'comun'};
            this.matriz.fila_de_la_clave_fila[clave_fila]=fila;
            this.matriz.central.push(fila);
            for(var n_campo_i in this.datos.campos) if(this.datos.campos[n_campo_i].posicion=='izquierda'){
                var celda={
                    valor:registro_cuerpo[n_campo_i],
                    campo:n_campo_i
                }
                fila.lateral.push(celda);
            }
            for(var i_columna=0; i_columna<this.datos.columnas.length; i_columna++){
                fila.medio.push(null);
            }
        }
        fila.medio[this.matriz.numero_columnas_campo_arriba[JSON.stringify(registro.arriba)]]={ 
            valor:registro.centro[this.datos.primer_campo.centro], 
            campo:this.datos.primer_campo.centro,
            todos_los_valores:registro.centro 
        };
    }
}

var sin_cambio =function(x){return x}
Tabulados.prototype.desdoblar_mostrar=function(){
    var este=this;
    var zonas={superior:'encabezado', central:'cuerpo'};
    // var zonas={central:'cuerpo'};
    var cambiar_separador_decimal=function(x){
        var y= x;
        if (y===null ){
            y=0;
        }else {
            if (typeof y !== 'string'){
                y=String(y);
            }        
            y=y.replace('.', este.datos.separador_decimal);
        }
        return y;
    }    
    var poner_sep_decimal={};
    poner_sep_decimal.superior={lateral:sin_cambio, medio:sin_cambio};    
    poner_sep_decimal.central={lateral:sin_cambio, medio:cambiar_separador_decimal};    
    this.nuevaMatriz={};
    for(var zona in zonas){
        this.nuevaMatriz[zona]=[];
        for(var i=0; i<this.matriz[zona].length; i++){
            var fila_matriz_actual=this.matriz[zona][i];
            var fila_matriz_nueva={};
            for(var parte in fila_matriz_actual){
                fila_matriz_nueva[parte]=[];
                if(parte=='tipo_fila'){
                   fila_matriz_nueva[parte].push(fila_matriz_actual[parte]); //consultar porque queda como array de una posición
                }else{
                    for(var j=0; j<fila_matriz_actual[parte].length; j++){
                        var celda=fila_matriz_actual[parte][j];
                        if(celda===null){
                            fila_matriz_nueva[parte].push({mostrar:''}); 
                        }else if(celda.mostrar instanceof Array){
                           for(var k=0; k<celda.mostrar.length; k++){
                                fila_matriz_nueva[parte].push({
                                    // mostrar:(celda.mostrar[k] instanceof CeldaDeValores?celda.valor:celda.mostrar[k]), 
                                    mostrar:poner_sep_decimal[zona][parte](celda.mostrar[k]), 
                                    tipo:celda.tipo && celda.tipo[k]
                                }); 
                           }
                        }else if(celda.mostrar){
                            fila_matriz_nueva[parte].push({mostrar:poner_sep_decimal[zona][parte](celda.mostrar)+''}); 
                            //fila_matriz_nueva[parte].push({mostrar:celda.mostrar+''}); 

                        }else{
                           fila_matriz_nueva[parte].push({mostrar:(celda.valor===0?0:poner_sep_decimal[zona][parte](celda.valor||celda))+''});
                           //fila_matriz_nueva[parte].push({mostrar:(celda.valor===0?0:celda.valor||celda)+''});                           
                        }
                    }
                }
            }
            this.nuevaMatriz[zona][i]=fila_matriz_nueva;
        }
    }
    this.viejaMatriz=this.matriz;
    this.matriz=this.nuevaMatriz;
    // excepcionalmente:
    // this.matriz.superior=this.viejaMatriz.superior;
}

Tabulados.prototype.colocar_tabla=function(){
    var zonas={superior:'encabezado', central:'cuerpo'};
    for(var zona in zonas){
        for(var i=0; i<this.matriz[zona].length; i++){
            var fila_matriz=this.matriz[zona][i];
            var fila=this[zonas[zona]].insertRow(-1);
            for(var seccion in {lateral:null, medio:null}){
                for(var j=0; j<fila_matriz[seccion].length; j++){
                    var celda=fila.insertCell(-1);
                    this.colocar_celda(celda,fila_matriz[seccion][j]);
                }
            }
        }
    }
}

Tabulados.prototype.colocar_celda=function(destino,celda){
    if(typeof celda =='object' && celda!==null){
        if(celda.mostrar=='`'){ // para futuro colspan
            destino.textContent='';
            return;
        }
        if(celda.tipo=='sup'){
            var sup=document.createElement('sup');
            sup.textContent=celda.mostrar+'';
            destino.appendChild(sup);
            destino.classList.add('sup');
            return;
        }
        destino.textContent=(celda.mostrar==-1234567?'Total':celda.mostrar)+'';
        return;
        var texto='';
        if(celda.varios_campos){
            for(var n_campo_c in celda.todos_los_valores){
                texto+=' '+celda.todos_los_valores[n_campo_c];
            }
        }else if('mostrar' in celda){
            texto=celda.mostrar;
        }else{
            texto=celda.valor;
        }
        destino.textContent=texto;
    }else{
        destino.textContent=celda;
    }
}

/*
Tabulados.prototype.preparar_totales_internos=function(){
    var campos_izquierda={};
    var nombres_izquierda=[];
    for(var n_campo in this.datos.campos){
        if(this.datos.campos[n_campo].posicion=='izquierda'){
            campos_izquierda[n_campo]=this.datos.campos[n_campo];
            nombres_izquierda.push(n_campo);
            delete this.datos.campos[n_campo];
        }
    }
    this.cuerpo_original=this.datos.cuerpo;
    this.datos.cuerpo=[];
    for(var i=0; i<this.cuerpo_original.length; i++){
        var registro_original=this.cuerpo_original[i];
        var nuevo_campo_izquierda={};
        var nuevo_registro={};
        for(var n_campo_i in campos_izquierda){
            nuevo_campo_izquierda[n_campo_i]=registro_original[n_campo_i];
        }
        for(var n_campo in this.datos.campos){
            nuevo_registro[n_campo]=registro_original[n_campo];
        }
        nuevo_registro.unico_campo_izquierda=JSON.stringify(nuevo_campo_izquierda);
        this.datos.cuerpo.push(nuevo_registro);
    }
    this.datos.campos.unico_campo_izquierda={
        titulo:nombres_izquierda.join(' y '),
        tipo:'texto',
        posicion:'izquierda',
        lookup:{}
    }
}
*/

Tabulados.prototype.para_cada_fila_matriz=function(aplicar_esta_funcion){ 
    for(var zona in {superior:null, central:null}){
        var filas=this.matriz[zona];
        for(var i_fila=0; i_fila<filas.length; i_fila++){
            var fila=filas[i_fila];
            aplicar_esta_funcion(fila);
        }    
    }
}

Tabulados.prototype.para_cada_celda_matriz=function(aplicar_esta_funcion){ 
    this.para_cada_fila_matriz(function(fila){
        for(var parte in {lateral:null, medio:null}){
            var celdas=fila[parte];
            for(var i_celda=0; i_celda<celdas.length; i_celda++){
                var celda=celdas[i_celda];
                aplicar_esta_funcion(celda);
            }
        }
    });
}

/*
Tabulados.prototype.para_cada_celda_matriz=function(aplicar_esta_funcion){ 
    for(var zona in {superior:null, central:null}){
        var filas=this.matriz[zona];
        for(var i_fila=0; i_fila<filas.length; i_fila++){
            var fila=filas[i_fila];
            for(var parte in {lateral:null, medio:null}){
                var celdas=fila[parte];
                for(var i_celda=0; i_celda<celdas.length; i_celda++){
                    var celda=celdas[i_celda];
                    aplicar_esta_funcion(celda);
                }
            }
        }
    }
}
*/

Tabulados.prototype.cambiar_lookups=function(){ 
    var esto=this;
    this.para_cada_celda_matriz(function(celda){
        if(typeof celda =='object' && celda!==null){
            if(celda.campo=='pla_frecuencia' || celda.campo=='pla_tasa'){
                celda.mostrar=[celda.valor]; //OJO QUE ESTO PUEDE HABERSE ROTO
                celda.mostrar.push("`");
            }else{
                if(celda && !(celda.valor instanceof CeldaDeTotales) && celda.campo && esto.datos.campos[celda.campo].lookup && esto.datos.campos[celda.campo].lookup[celda.valor]){
                    celda.mostrar=[esto.datos.campos[celda.campo].lookup[celda.valor]];
                }else{
                    if(celda.valor == '-9'){
                        celda.mostrar=['Ns/Nc'];
                    }
                    // /* QUITAR ESTO PARA VER QUÉ SE ROMPE
                    for(var n_campo_i in esto.datos.campos){
                        if(esto.datos.tipo_tabulado=='comun'){
                            if(esto.datos.campos[n_campo_i].posicion=='izquierda'){
                                if((celda.valor == null && celda.campo && celda.campo == n_campo_i) || (esto.datos.tipo_tabulado=='tasa' && celda.valor == 0 && celda.campo == n_campo_i)){
                                    celda.mostrar=['Total X',"`"];
                                }
                            }else if(esto.datos.campos[n_campo_i].posicion=='esquina'){
                                celda.mostrar=[celda.valor+' x'];
                            }
                        }
                    }
                    if(!(esto.datos.tipo_tabulado=='comun') && 'pla_coefvar' in (celda.todos_los_valores||{})){
                        // celda.mostrar=[new CeldaDeValores()];
                        if(!celda.mostrar){
                            celda.mostrar=[celda.valor];
                        }
                        celda.mostrar.push(celda.todos_los_valores.pla_coefvar);
                    }
                    // */
                }
                if(esto.datos.campos[celda.campo].posicion=='esquina'){
                    celda.mostrar=['xxx'];
                }
                if(esto.datos.campos[celda.campo].posicion=='arriba'){
                    // if(esto.datos.modo2=='revisar'){
                    //     celda.mostrar.pop();
                    // }
                    if(esto.datos.modo=='revisar' && esto.datos.modo2!=='revisar'){
                        if('mostrar' in celda){
                            celda.mostrar.push("`");
                        }
                    }
                    if(esto.datos.coef_var){
                        if('mostrar' in celda){
                            celda.mostrar.push("`");
                        }
                    }
                }
            }
        }
    });
}

function CualquierValor(){
  // objeto especial para indicar que la celda corresponde a una fila de totales
}

function CeldaDeTotales(){
  // objeto especial para indicar que la celda corresponde a una fila de totales
}

function CeldaDeValores(){
}

CeldaDeTotales.prototype.toString=function(){
    return "Total";
}

Tabulados.prototype.agregar_fila_totales=function(filtro,lugar){
    var clave_fila_totales=JSON.stringify(filtro); 
    var fila_totales={lateral:[], medio:[], tipo_fila:'total'};
    this.matriz.fila_de_la_clave_fila[clave_fila_totales]=fila_totales;
    if(this.cantidad_campos.izquierda>1){
        for(var n_campo_f in filtro){
            if(n_campo_f==this.datos.ultimo_campo['izquierda']){ 
                var celda_vacia2={
                    valor:(filtro[n_campo_f] instanceof CualquierValor?new CeldaDeTotales():filtro[n_campo_f]),
                    campo:n_campo_f
                }
            }else{
                var celda_vacia1={
                    valor:(filtro[n_campo_f] instanceof CualquierValor?new CeldaDeTotales():filtro[n_campo_f]),
                    campo:n_campo_f
                }
            }
        }
        fila_totales.lateral.push(celda_vacia1);    
        fila_totales.lateral.push(celda_vacia2); 
    }else{
        for(var n_campo_f in filtro){
            var celda_vacia1={
                valor:(filtro[n_campo_f] instanceof CualquierValor?new CeldaDeTotales():filtro[n_campo_f]),
                campo:n_campo_f
            }
        }
        fila_totales.lateral.push(celda_vacia1);         
    }
    for(var i=0; i<this.datos.columnas.length; i++){
        var celda={
            valor:0.0,
            campo:'pla_cantidad'
        }
        fila_totales.medio.push(celda);
    }
    var primer_fila_sin_saltear=0;
    for(var i_fila=0; i_fila<this.matriz.central.length; i_fila++){
        var fila=this.matriz.central[i_fila];
        var saltear=false;
        if(fila.tipo_fila=='total'){
            saltear=true;
        }
        if(lugar==-1 ||lugar==0){
            var i=0;
            var increm = 1;
        }else{
            var i=1;
            var increm=-1;
        }
        for(var n_campo_f in filtro){
            if(n_campo_f==fila.lateral[i].campo){
                if(!(filtro[n_campo_f] instanceof CualquierValor) && filtro[n_campo_f]!=fila.lateral[i].valor){
                    saltear=true;
                }
            }  
            i=i+increm;
        }        
        if(!saltear){
            if(primer_fila_sin_saltear==0 && lugar==-1 && fila.tipo_fila!='total'){
               primer_fila_sin_saltear=i_fila;
            }
            for(var i=0; i<this.datos.columnas.length; i++){
                if(fila.medio[i]!==null){
                    fila_totales.medio[i].valor+=Number(fila.medio[i].valor);
                }
            }
        }
    }
    if(lugar==-1){
        lugar=primer_fila_sin_saltear;
    }
    this.matriz.central.splice(lugar,0,fila_totales);
}

Tabulados.prototype.mostrar_porcentaje=function(porcentaje){
    return (porcentaje.toFixed(this.datos.cant_decimales)+'').replace('.',this.datos.separador_decimal);
}

Tabulados.prototype.agregar_columna_totales_y_mostrar=function(){
    if(this.datos.tipo_tabulado=='comun'){
        for(var i_fila=0; i_fila<this.matriz.central.length; i_fila++){
            var fila=this.matriz.central[i_fila];
            var suma=0.0;
            for(var i_celda=0; i_celda<fila.medio.length; i_celda++){
                if(fila.medio[i_celda]==null){
                    fila.medio[i_celda]={
                        valor:null,
                        campo:'pla_cantidad'
                    };
                }
                suma+=Number(fila.medio[i_celda].valor);
            }
            fila.medio.unshift({
                valor:suma,
                campo:'pla_cantidad'
            });
            for(var i_celda=1; i_celda<fila.medio.length; i_celda++){
                fila.medio[i_celda].mostrar=[];
                fila.medio[i_celda].tipo=[];
                if(this.datos.modo2!=='revisar'){
                    fila.medio[i_celda].mostrar.push(this.mostrar_porcentaje(Number(fila.medio[i_celda].valor)*100.0/suma));
                }
                if(this.datos.modo=='revisar'){
                    fila.medio[i_celda].mostrar.push(fila.medio[i_celda].valor);
                }
                if(this.datos.coef_var){
                    var nuevo_largo=fila.medio[i_celda].mostrar.push((fila.medio[i_celda].todos_los_valores||{}).pla_coefvar||'');
                    fila.medio[i_celda].tipo[nuevo_largo-1]='sup';
                }
            }
            fila.medio[0].mostrar=[];
            if(this.datos.modo2!=='revisar'){
                fila.medio[0].mostrar.push(this.mostrar_porcentaje(Number(100)));
            }
            if(this.datos.modo=='revisar'){
                fila.medio[0].mostrar.push(suma);
            }
        };
        for(var i_fila=0; i_fila<this.matriz.superior.length; i_fila++){
            var fila=this.matriz.superior[i_fila];
            if(i_fila==this.matriz.superior.length-1){
                // if(this.datos.modo2!=='revisar'){
                //     fila.medio.unshift("`");
                // }
                if(this.datos.modo=='revisar' && this.datos.modo2!=='revisar'){
                    fila.medio.unshift("`");
                }
                fila.medio.unshift("Total");
            }else{
                fila.medio.unshift(null);
            }
        };
    }else{
        if(this.datos.tipo_tabulado=='frecuencia'){
            for(var i_fila=0; i_fila<this.matriz.central.length; i_fila++){
                var fila=this.matriz.central[i_fila];
                for(var i_celda=0; i_celda<fila.medio.length; i_celda++){
                    var fila_total=this.matriz.central[0];
                    if(fila.medio[i_celda]==null){
                        fila.medio[i_celda]={
                            valor:null,
                            campo:'pla_cantidad'
                        };
                        var valor_fila=0;
                    }else{
                        var valor_fila=Number(fila.medio[i_celda].valor);
                    }
                    var valor_total=Number(fila_total.medio[i_celda].valor);
                    fila.medio[i_celda].mostrar=[];
                    if(this.datos.modo2!=='revisar'){
                        fila.medio[i_celda].mostrar.push(this.mostrar_porcentaje(valor_fila/valor_total*100));
                    }
                    if(this.datos.modo=='revisar'){
                        fila.medio[i_celda].mostrar.push(fila.medio[i_celda].valor);
                    }
                }
            }
        }
    }
}

Tabulados.prototype.desplegar=function(datos){ 
    this.datos=datos;
    if(!('cuerpo' in this.datos)){ throw new Error('falta el cuerpo en los datos del tabulado'); }
    if(!('columnas' in this.datos)){ throw new Error('falta las columnas en los datos del tabulado'); }
    if(!('titulo' in this.datos)){ throw new Error('falta el título del tabulado'); }
    this.preparar_destino();
    this.obtener_matriz();
    if(this.datos.tipo_totales=='totales_internos'){
    //    this.agregar_fila_totales({pla_sexo:new CualquierValor(), pla_zona_3:new CualquierValor()},0);
        if(this.datos.modalidad!='normal' /*|| this.datos.tipo_tabulado!='comun'*/){
            var campos_totales={};
            for(var n_campo_a in this.datos.campos) if(this.datos.campos[n_campo_a].posicion=='izquierda'){
                campos_totales[n_campo_a]=new CualquierValor();
            }
            if(this.datos.ultimo_campo.arriba != 'pla_promedio' && this.datos.ultimo_campo.arriba != 'pla_mediana' && this.datos.ultimo_campo.arriba !='pla_tasa' && this.datos.ultimo_campo.arriba !='pla_suma') {
                this.agregar_fila_totales(campos_totales,0);
            }
            if(this.cantidad_campos.izquierda>1){
                var filtro_subtotales=new Array(); 
                for(var n_campo_a in this.datos.campos) if(this.datos.campos[n_campo_a].posicion=='izquierda'){
                    var varray_filtro=new Array(); 
                    var k=0;
                    var mi_filtro=n_campo_a;
                    for(var i_fila=0; i_fila<this.matriz.central.length ; i_fila++){
                        var fila=this.matriz.central[i_fila];
                        if(fila.tipo_fila=='comun'){
                            for(var i_celda=0; i_celda<fila.lateral.length; i_celda++){
                                if(fila.lateral[i_celda].campo==mi_filtro && varray_filtro.indexOf(fila.lateral[i_celda].valor )==-1/*!(fila.lateral[i_celda].valor in varray_filtro)*/){
                                    varray_filtro[k]=fila.lateral[i_celda].valor;
                                    k++;
                                }
                            }
                        }    
                    }
                    filtro_subtotales[mi_filtro]=varray_filtro;
                }
                var lugar=-1;
                for(var mi_filtro in filtro_subtotales){
                    for(var j=0;j<filtro_subtotales[mi_filtro].length;j++){
                        var filtro_para_agregar={};
                        filtro_para_agregar[mi_filtro]=filtro_subtotales[mi_filtro][j];
                        for(var n_campo_a in this.datos.campos) if(this.datos.campos[n_campo_a].posicion=='izquierda' && n_campo_a!=mi_filtro){ 
                            filtro_para_agregar[n_campo_a]=new CualquierValor(); 
                            if(lugar!=-1){
                               lugar++;
                            }
                            if(this.datos.ultimo_campo.arriba != 'pla_promedio' && this.datos.ultimo_campo.arriba != 'pla_mediana' && this.datos.ultimo_campo.arriba !='pla_tasa' && this.datos.ultimo_campo.arriba != 'pla_suma') {
                                this.agregar_fila_totales(filtro_para_agregar,lugar);  /* OJO cuando es mediana o promedio, si la muestra*/
                            }
                        }
                    }
                    lugar=0;
                } 
            } 
        }
        this.agregar_columna_totales_y_mostrar();
    }
    this.cambiar_lookups();
    this.desdoblar_mostrar();
    this.colocar_tabla();
}

function tabulado_generico(datos){
    var tabulado=new Tabulados();
    // if(!$esta_es_la_base_en_produccion){ proceso_formulario_respuesta.textContent=typeof datos=='string'?datos:JSON.stringify(datos,null,'  '); proceso_formulario_respuesta.style.whiteSpace='pre';  return; }
    tabulado.desplegar(datos);
}

window.addEventListener('load',function(){
    if(window.tra_revisar2){
        tra_revisar.addEventListener('click', function(){
            var otra_fila=tra_revisar2.parentNode.parentNode;
            if(tra_revisar.checked){
                otra_fila.style.display='';
                otra_fila.style.fontSize='80%';
            }else{
                otra_fila.style.display='none';
                tra_revisar2.checked=false;
            }
        });
    }
});