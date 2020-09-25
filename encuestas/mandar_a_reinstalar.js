"use strict";

async function mandar_a_reinstalar(appName){
    /** @type {string[]}  */
    var rtas=[];
    try{
        var sw = await navigator.serviceWorker.ready;
        if(!sw){
            rtas.push('ERROR. No habia SW ready');
        }else{
            var pudo = await sw.unregister();
            rtas.push((pudo?'':'no ')+'pudo desinstalar el SW');
            var cacheNames = await caches.keys();
            var borrando = await Promise.all(
                cacheNames.filter((cacheName)=>
                    cacheName.substr(0,appName.length+1)==appName+':'
                ).map((cacheName)=>{
                    rtas.push('borrada la cache '+cacheName);
                    return caches.delete(cacheName);
                })
            );
            rtas.push((borrado?'':'no ')+'Borradas todas las caches!');
        }
    }catch(err){
        rtas.push('ERROR. NO SE TERMINO.');
        rtas.push(err.message);
    }
    return rtas;
}
