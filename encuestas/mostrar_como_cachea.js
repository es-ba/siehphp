function mostrar_como_cachea(){
    if(!elemento_existente('div_principal')){
        var div=document.createElement('div');
        div.id='div_principal';
        document.body.appendChild(div);    
    }
    if(window.applicationCache) window.applicationCache.addEventListener('cached', function(e) {
        var texto=document.createElement('div');
        texto.textContent='Sistema cargado!';
        elemento_existente('div_principal').appendChild(texto);
    }, false);
    var cacheStatusValues = [];
    cacheStatusValues[0] = 'uncached';
    cacheStatusValues[1] = 'idle';
    cacheStatusValues[2] = 'checking';
    cacheStatusValues[3] = 'downloading';
    cacheStatusValues[4] = 'updateready';
    cacheStatusValues[5] = 'obsolete';
    var cachear={
        checking:{},
        downloading:{},
        error:{},
        noupdate:{},
        obsolete:{},
        progress:{},
        updateready:{},
    }
    for(var que_cachear in cachear){
        var message_ant;
        var texto;
        if(window.applicationCache) window.applicationCache.addEventListener(que_cachear, function(e) {
            var online, status, type, message;
            online = (navigator.onLine) ? 'sí' : 'no';
            status = cacheStatusValues[window.applicationCache.status];
            type = e.type;
            message = 'online: ' + online;
            message+= ', evento: ' + type;
            message+= ', estado: ' + status;
            var message_ok = 'online: sí, evento: progress, estado: downloading';
            if(message!==message_ok || message_ant!==message_ok || !texto){
                texto=document.createElement('div');
                elemento_existente('div_principal').appendChild(texto);
            }
            message_ant=message;
            if (type == 'error' && navigator.onLine) {
                message+= ' (!!)';
            }
            if(type=='progress'){
                message+=' '+e.loaded+'/'+e.total;
            }
            texto.className='log_manifest';
            texto.textContent=message;
            if(type!='progress'){
                var texto2=document.createElement('span');
                texto2.className='mensaje_alerta';
                texto2.textContent=' '+(e.message||e.url||'!');
                texto.appendChild(texto2);
            }
        }, false);
    }
}