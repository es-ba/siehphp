"use strict";

function mostrar_mini_calendario(elementoContenedor, connector){

    var conf={
        top:  50+obtener_top_global(elementoContenedor),
        left: 60+obtener_left_global(elementoContenedor),
        anchoCuadradito:65,
        altoCuadradito:65,
        values:{},
    };

    var imgs={
        modoEditOff  :'../encuestas/lapiz_calendario.png',
        modoEditOn   :'../encuestas/lapiz_calendario_active.png',
        modoDeleteOff:'../encuestas/goma01_calendario.png',
        modoDeleteOn :'../encuestas/goma01_calendario_active.png',
    }

    var ximgs={
        modoEditOff:'clip_calendario.png',
        modoEditOn:'clip_calendario_active.png',
        modoDeleteOff:'goma_calendario.png',
        modoDeleteOn:'goma_calendario_active.png',
    }

    var refreshData = function refreshData(){
        connector.save(conf.values);
    }

    var fastEdit=function(event){
        if(conf.modoEdit){
            conf.values[this.myPosition]=true;
            this.showGood();
        }
        if(conf.modoDelete){
            conf.values[this.myPosition]=false;
            this.showGood();
        }
    }
    // img.onmousemove=fastEdit;
    var touchControl=function(event){
        Array.prototype.forEach.call(event.touches, function(touch){
            // consolelog.textContent+=touch.clientX+'\n';
            var secondElement = document.elementFromPoint(touch.clientX, touch.clientY);
            if(secondElement.tieneSentido){
                fastEdit.call(secondElement, event)
            }
            refreshData();
        });
        event.preventDefault();
    }

    function crearBox(contenedor, iFila, iColumna){
        var img = document.createElement('img');
        img.showGood = function showGood(){
            if(conf.values[this.myPosition]){
                this.src='../encuestas/cuadradotic_calendario.png';
            }else{
                this.src='../encuestas/cuadrado_calendario.png';
            }
        }
        img.draggable=false;
        img.tieneSentido=true;
        img.style.height='49px';
        img.style.width='49px';
        img.style.position='absolute';
        img.style.top=conf.top+conf.altoCuadradito*(iFila-1)+'px';
        img.style.left=conf.left+conf.anchoCuadradito*(iColumna-1)+'px';
        img.myPosition=[iFila,iColumna];
        img.onclick=function(){
            conf.values[this.myPosition]=!conf.values[this.myPosition];
            this.showGood();
            refreshData();
        }
        img.showGood();
        img.addEventListener('touchmove', touchControl, false);
        contenedor.appendChild(img);
    }


    function crearBoxes(contenedor){
        var clip;
        var goma;
        var showGood = function showGood(){
            if(conf.modoEdit){
                clip.src=imgs.modoEditOn;
                clip.style.left=conf.left+5.5*conf.anchoCuadradito+'px';
            }else{
                clip.src=imgs.modoEditOff;
                clip.style.left=conf.left+5.5*conf.anchoCuadradito+'px';
            }
            if(conf.modoDelete){
                goma.src=imgs.modoDeleteOn;
                goma.style.left=conf.left+5.5*conf.anchoCuadradito+'px';
            }else{
                goma.src=imgs.modoDeleteOff;
                goma.style.left=conf.left+5.5*conf.anchoCuadradito+'px';
            }
        }
        var fondo = document.createElement('img');
        fondo.draggable=false;
        fondo.style.height='290px';
        fondo.style.width='602px';
        fondo.src="../encuestas/fondo_calendario.png";
        fondo.ontouchmove=function(){
            event.preventDefault();
        }
        contenedor.appendChild(fondo);
        setTimeout(function(){
            connector.load(conf.values);
            conf.top = 70+obtener_top_global(fondo);
            conf.left=130+obtener_left_global(fondo);
            // var_horario_tel = JSON.stringify(conf);
            for(var iFila=1; iFila<=3; iFila++){
                for(var iColumna=1; iColumna<=5 || iColumna==6 && iFila==1; iColumna++){
                    crearBox(contenedor, iFila, iColumna);
                }
            }
            clip = document.createElement('img');
            clip.src=imgs.modoEditOff;
            clip.draggable=false;
            clip.style.height='60px';
            clip.style.width='86px';
            clip.style.position='absolute';
            clip.style.top=conf.top+1*conf.altoCuadradito+'px';
            contenedor.appendChild(clip);
            var clipClick=function(){
                conf.modoEdit=!conf.modoEdit;
                conf.modoEdit=true;
                if(conf.modoEdit){
                    conf.modoDelete=false;
                }
                showGood();
            }
            // clip.onclick=clipClick;
            clip.ontouchstart=clipClick;
            clip.ontouchmove=touchControl;
            goma = document.createElement('img');
            goma.src=imgs.modoDeleteOff;
            goma.draggable=false;
            goma.style.height='75px';
            goma.style.width='90px';
            goma.style.position='absolute';
            goma.style.top=conf.top+2*conf.altoCuadradito+'px';
            showGood();
            contenedor.appendChild(goma);
            var gomaClick=function(){
                conf.modoDelete=!conf.modoDelete;
                conf.modoDelete=true;
                if(conf.modoDelete){
                    conf.modoEdit=false;
                }
                showGood();
            }
            // goma.onclick=gomaClick;
            goma.ontouchstart=gomaClick;
            goma.ontouchmove=touchControl;
            fondo.addEventListener('touchmove', touchControl, false);
        },500);
    }

    crearBoxes(elementoContenedor);
}

window.addEventListener('load', function(){
    if(window.var_horario_tel){
        var_horario_tel.style.width='340px';
        var_horario_tel.style.height='20px';
        var_horario_tel.style.backgroundColor='#898';
        var_horario_tel.style.fontSize='8px';
        var trNuevo=document.createElement('tr');
        var cell = trNuevo.insertCell();
        cell.style.textAlign = 'right';
        cell.colSpan = 2;
        var trDeLaPregunta = document.querySelector("[referencia=pregunta-Te3_hora]");
        if(trDeLaPregunta){
            trDeLaPregunta.parentNode.insertBefore(trNuevo, trDeLaPregunta.nextSibling.nextSibling.nextSibling.nextSibling);
            setTimeout(function(){
                mostrar_mini_calendario(cell, {
                    save:function(values){
                        var_horario_tel.value=JSON.stringify(values);
                        ValidarOpcion("var_horario_tel");
                    },
                    load:function(values){
                        if(var_horario_tel.value){
                            var obj = JSON.parse(var_horario_tel.value);
                            for(var attr in obj){
                                values[attr]=obj[attr];
                            }
                        }
                    }
                });
            },500);
        }
    }
});