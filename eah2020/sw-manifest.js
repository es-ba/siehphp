"use strict";
// TEMPLATE-START
var version = 'v 3.00e';
var appName = 'eah2020_test';
var urlsToCache = [
'../eah2020/eah2020_icon.png',
'../eah2020/eah2020_icon_super.png',
'../eah2020/eah2020_icon_capa.png',
'../tedede/comunes.js ',
'../tedede/cuantas_instancias.js ',
'../tedede/probador.css',
'../tedede/menu.css',
'../encuestas/encuestas.css',
'../encuestas/encuestas.js',
'../encuestas/mostrar_como_cachea.js',
'../encuestas/encu_especiales.js',
'../eah2020/eah2020.css',
'../eah2020/dbo_eah2020.js',
'../tedede/tedede.js ',
'../tedede/tedede.css ',
'../tedede/editor.js',
'../tedede/para_grilla.js',
'../tedede/tabulados.js',     //   #agregado para test
'../tedede/test_fondo_t.png', //   #agregado para test
'../eah2020/estructura_eah2020.js',
'../tercera/md5_paj.js',
'../tercera/aes.js',
'../eah2020/logo_app.png',
'../eah2020/logo_esperar.png',
'../eah2020/eah2020_fondo_t.png',
'../eah2020/eah2020_icon.gif',
'../eah2020/eah2020_icon_test.gif',
'../eah2020/eah2020_icon_desa.gif',
'../eah2020/eah2020_icon_capa.gif',
'../eah2020/eah2020.php?hacer=hoja_de_ruta',
'../eah2020/eah2020.php?hacer=hoja_de_ruta_super',
'../eah2020/eah2020.php?hacer=formularios_de_la_vivienda',
'../eah2020/eah2020.php?hacer=desplegar_formulario&todo={"tra_ope":"eah2020","tra_for":"S1","tra_mat":""}',
'../eah2020/eah2020.php?hacer=desplegar_formulario&todo={"tra_ope":"eah2020","tra_for":"S1","tra_mat":"P"}',
'../eah2020/eah2020.php?hacer=desplegar_formulario&todo={"tra_ope":"eah2020","tra_for":"A1","tra_mat":""}',
'../eah2020/eah2020.php?hacer=desplegar_formulario&todo={"tra_ope":"eah2020","tra_for":"I1","tra_mat":""}',
// '../eah2020/eah2020.php?hacer=desplegar_formulario&todo={"tra_ope":"eah2020","tra_for":"PMD","tra_mat":""}',
// '../eah2020/eah2020.php?hacer=desplegar_formulario&todo={"tra_ope":"eah2020","tra_for":"GH","tra_mat":""}',
'../eah2020/eah2020.php?hacer=desplegar_formulario&todo={"tra_ope":"eah2020","tra_for":"SUP","tra_mat":""}',
'../tedede/compatibilidad.js ',
'../imagenes/bloq_mayus.jpg',
'../encuestas/control_mini_cal.js',
'../encuestas/calendario01.png',
'../encuestas/lapiz_calendario_active.png',
'../encuestas/lapiz_calendario.png',
'../encuestas/goma01_calendario_active.png',
'../encuestas/goma01_calendario.png',
'../encuestas/cuadrado_calendario.png',
'../encuestas/cuadradotic_calendario.png',
'../encuestas/fondo_calendario.png',
'../tercera/require-bro.js',
'../service-worker-admin.js',
];
// TEMPLATE-END
var CACHE_NAME = appName + ':' + version;
var urlsCached;
// Fin de la espera?
self.addEventListener('install', async (evt) => {
    // @ts-expect-error Esperando que agregen el listener de 'fetch' en el sistema de tipos
    var event = evt;
    //si hay cambios no espero para cambiarlo
    // self.skipWaiting();
    console.log("instalando");
    event.waitUntil(caches.open(CACHE_NAME).then((cache) => Promise.all(urlsToCache.map(async (urlToCache) => {
        var error = null;
        try {
            await cache.add(urlToCache);
        }
        catch (err) {
            error = err;
        }
        var message = { type: 'caching', url: urlToCache, error };
        self.clients.matchAll({ includeUncontrolled: true }).then(clients => {
            for (const client of clients)
                client.postMessage(message);
        });
        if (error)
            throw error;
    }))));
    // idea de informar error: https://stackoverflow.com/questions/62909289/how-do-i-handle-a-rejected-promise-in-a-service-worker-install-event
});
var specialSources = {
    "@version": () => version,
    "@CACHE_NAME": () => CACHE_NAME,
    "@urlsToCache": () => urlsToCache.map(r => { var u = new URL(new Request(r).url); return u.pathname + u.search; })
};
self.addEventListener('fetch', async (evt) => {
    // @ts-expect-error Esperando que agregen el listener de 'fetch' en el sistema de tipos
    var event = evt;
    var sourceParts = event.request.url.split('/');
    var source = sourceParts[sourceParts.length - 1];
    console.log("source", source);
    if (source in specialSources) {
        var value = await specialSources[source]();
        var miBlob = new Blob([JSON.stringify(value)], { type: "application/json" });
        var opciones = { "status": 200, "statusText": typeof value === "string" ? value : "@json", ok: true };
        var miRespuesta = new Response(miBlob, opciones);
        event.respondWith(miRespuesta);
    }
    else {
        event.respondWith(caches.open(CACHE_NAME).then((cache) => cache.match(event.request).then((response) => {
            console.log("respuesta caché: ", response);
            return response || fetch(event.request).then((response) => {
                console.log("respuesta", response);
                if (!response) {
                    console.log("no tiene respuesta");
                    throw Error('without response');
                }
                return response;
            }).catch(async (err) => {
                console.log(err);
                var client = await self.clients.get(event.clientId);
                client.postMessage(err);
                return new Response(`<p>Se produjo un error al intentar cargar la p&aacute;gina, es posible que no haya conexi&oacute;n a internet</p><a href='/'>Volver a Hoja de Ruta</button>`, {
                    headers: { 'Content-Type': 'text/html' }
                });
            });
        })));
    }
});
self.addEventListener('activate', (evt) => {
    // @ts-expect-error Esperando que agregen el listener de 'fetch' en el sistema de tipos
    var event = evt;
    console.log("borrando caches viejas");
    event.waitUntil(caches.keys().then((cacheNames) => {
        return Promise.all(cacheNames.filter((cacheName) => cacheName != CACHE_NAME).map((cacheName) => {
            console.log("borrando cache ", cacheName);
            return caches.delete(cacheName);
        }));
    }));
});
self.addEventListener('message', function (evt) {
    console.log("mensaje: ", evt.data);
    if (evt.data == 'skipWaiting') {
        self.skipWaiting().then(() => console.log(version));
    }
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoic2VydmljZS13b3JrZXItd28tbWFuaWZlc3QuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi9zcmMvc2VydmljZS13b3JrZXItd28tbWFuaWZlc3QudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IkFBQUEsWUFBWSxDQUFDO0FBRWIsaUJBQWlCO0FBQ2pCLElBQUksT0FBTyxHQUFVLGFBQWEsQ0FBQztBQUNuQyxJQUFJLE9BQU8sR0FBVSxhQUFhLENBQUM7QUFDbkMsSUFBSSxXQUFXLEdBQVksRUFBQyxlQUFlLENBQUMsQ0FBQztBQUM3QyxlQUFlO0FBRWYsSUFBSSxVQUFVLEdBQVUsT0FBTyxHQUFDLEdBQUcsR0FBQyxPQUFPLENBQUM7QUFDNUMsSUFBSSxVQUFtQixDQUFBO0FBb0J2QixvQkFBb0I7QUFFcEIsSUFBSSxDQUFDLGdCQUFnQixDQUFDLFNBQVMsRUFBRSxLQUFLLEVBQUUsR0FBRyxFQUFDLEVBQUU7SUFDMUMsdUZBQXVGO0lBQ3ZGLElBQUksS0FBSyxHQUFjLEdBQUcsQ0FBQztJQUMzQix5Q0FBeUM7SUFDekMsc0JBQXNCO0lBQ3RCLE9BQU8sQ0FBQyxHQUFHLENBQUMsWUFBWSxDQUFDLENBQUE7SUFFekIsS0FBSyxDQUFDLFNBQVMsQ0FBQyxNQUFNLENBQUMsSUFBSSxDQUFDLFVBQVUsQ0FBQyxDQUFDLElBQUksQ0FBQyxDQUFDLEtBQUssRUFBQyxFQUFFLENBQ2xELE9BQU8sQ0FBQyxHQUFHLENBQUMsV0FBVyxDQUFDLEdBQUcsQ0FBQyxLQUFLLEVBQUMsVUFBVSxFQUFBLEVBQUU7UUFDMUMsSUFBSSxLQUFLLEdBQVksSUFBSSxDQUFDO1FBQzFCLElBQUc7WUFDQyxNQUFNLEtBQUssQ0FBQyxHQUFHLENBQUMsVUFBVSxDQUFDLENBQUE7U0FDOUI7UUFBQSxPQUFNLEdBQUcsRUFBQztZQUNQLEtBQUssR0FBQyxHQUFHLENBQUM7U0FDYjtRQUNELElBQUksT0FBTyxHQUFHLEVBQUMsSUFBSSxFQUFDLFNBQVMsRUFBRSxHQUFHLEVB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Q0FBQztZQUMxQyxPQUFPLE1BQU0sQ0FBQyxNQUFNLENBQUMsU0FBUyxDQUFDLENBQUM7UUFDcEMsQ0FBQyxDQUFDLENBQ0wsQ0FBQztJQUNOLENBQUMsQ0FBQyxDQUNMLENBQUM7QUFDTixDQUFDLENBQUMsQ0FBQztBQUVILElBQUksQ0FBQyxnQkFBZ0IsQ0FBQyxTQUFTLEVBQUUsVUFBUyxHQUFHO0lBQ3pDLE9BQU8sQ0FBQyxHQUFHLENBQUMsV0FBVyxFQUFFLEdBQUcsQ0FBQyxJQUFJLENBQUMsQ0FBQTtJQUNsQyxJQUFHLEdBQUcsQ0FBQyxJQUFJLElBQUUsYUFBYSxFQUFDO1FBQ3ZCLElBQUksQ0FBQyxXQUFXLEVBQUUsQ0FBQyxJQUFJLENBQUMsR0FBRSxFQUFFLENBQUEsT0FBTyxDQUFDLEdBQUcsQ0FBQyxPQUFPLENBQUMsQ0FBQyxDQUFDO0tBQ3JEO0FBQ0wsQ0FBQyxDQUFDLENBQUMiLCJzb3VyY2VzQ29udGVudCI6WyJcInVzZSBzdHJpY3RcIjtcclxuXHJcbi8vIFRFTVBMQVRFLVNUQVJUXHJcbnZhciB2ZXJzaW9uOnN0cmluZyA9ICcvKnZlcnNpb24qLyc7XHJcbnZhciBhcHBOYW1lOnN0cmluZyA9ICcvKmFwcE5hbWUqLyc7XHJcbnZhciB1cmxzVG9DYWNoZTpzdHJpbmdbXSA9IFsvKnVybHNUb0NhY2hlKi9dO1xyXG4vLyBURU1QTEFURS1FTkRcclxuXHJcbnZhciBDQUNIRV9OQU1FOnN0cmluZyA9IGFwcE5hbWUrJzonK3ZlcnNpb247XHJcbnZhciB1cmxzQ2FjaGVkOnN0cmluZ1tdXHJcblxyXG4vLyBFc3BlcmFuZG8gaHR0cHM6Ly9naXRodWIuY29tL21pY3Jvc29mdC9UeXBlU2NyaXB0L2lzc3Vlcy8xMTc4MVxyXG5pbnRlcmZhY2UgV2luZG93T3JXb3JrZXJHbG9iYWxTY29wZXtcclxuICAgIHNraXBXYWl0aW5nKCk6UHJvbWlzZTx2b2lkPlxyXG4gICAgY2xpZW50czp7XHJcbiAgICAgICAgZ2V0KGNsaWVudElkOkZldGNoRXZlbnRbJ2NsaWVudElkJ10pOlByb21pc2U8Q2xpZW50PlxyXG4gICAgICAgIG1hdGNoQWxsKHF1ZXJ5OmFueSk6UHJvbWlzZTxDbGllbnRbXT5cclxuICAgIH1cclxufVxyXG5cclxuaW50ZXJmYWNlIENsaWVudHtcclxuICAgIHBvc3RNZXNzYWdlKG1lc3NhZ2U6YW55KTp2b2lkXHJcbn1cclxuaW50ZXJmYWNlIEZldGNoRXZlbnQgZXh0ZW5kcyBFdmVudHtcclxuICAgIGNsaWVudElkOidjbGllbnRJZCd8J2V0Yy4uLidcclxuICAgIHJlcXVlc3Q6UmVxdWVzdFxyXG4gICAgcmVzcG9uZFdpdGgocHJvbWlzZTpQcm9taXNlPFJlc3BvbnNlPnxSZXNwb25zZSk6dm9pZFxyXG4gICAgd2FpdFVudGlsKHByb21pc2U6UHJvbWlzZTxhbnk+KTp2b2lkXHJcbn1cclxuLy8gRmluIGRlIGxhIGVzcGVyYT9cclxuXHJcbnNlbGYuYWRkRXZlbnRMaXN0ZW5lcignaW5zdGFsbCcsIGFzeW5jIChldnQpPT57XHJcbiAgICAvLyBAdHMtZXhwZWN0LWVycm9yIEVzcGVyYW5kbyBxdWUgYWdyZWdlbiBlbCBsaXN0ZW5lciBkZSAnZmV0Y2gnIGVuIGVsIHNpc3RlbWEgZGUgdGlwb3NcclxuICAgIHZhciBldmVudDpGZXRjaEV2ZW50ID0gZXZ0O1xyXG4gICAgLy9zaSBoYXkgY2FtYmlvcyBubyBlc3Blcm8gcGFyYSBjYW1iaWFybG9cclxuICAgIC8vIHNlbGYuc2tpcFdhaXRpbmcoKTtcclxuICAgIGNvbnNvbGUubG9nKFwiaW5zdGFsYW5kb1wiKVxyXG5cclxuICAgIGV2ZW50LndhaXRVbnRpbChjYWNoZXMub3BlbihDQUNIRV9OQU1FKS50aGVuKChjYWNoZSk9PlxyXG4gICAgICAgIFByb21pc2UuYWxsKHVybHNUb0NhY2hlLm1hcChhc3luYyB1cmxUb0NhY2hlPT57XHJcbiAgICAgICAgICAgIHZhciBlcnJvcjpFcnJvcnxudWxsPW51bGw7XHJcbiAgICAgICAgICAgIHRyeXtcclxuICAgICAgICAgICAgICAgIGF3YWl0IGNhY2hlLmFkZCh1cmxUb0NhY2hlKVxyXG4gICAgICAgICAgICB9Y2F0Y2goZXJyKXtcclxuICAgICAgICAgICAgICAgIGVycm9yPWVycjtcclxuICAgICAgICAgICAgfVxyXG4gICAgICAgICAgICB2YXIgbWVzc2FnZSA9IHt0eXBlOidjYWNoaW5nJywgdXJsOnVybFRvQ2FjaGUsIGVycm9yfTtcclxuICAgICAgICAgICAgc2VsZi5jbGllbnRzLm1hdGNoQWxsKHtpbmNsdWRlVW5jb250cm9sbGVkOiB0cnVlfSkudGhlbihjbGllbnRzID0+IHtcclxuICAgICAgICAgICAgICAgIGZvciAoY29uc3QgY2xpZW50IG9mIGNsaWVudHMpIGNsaWVudC5wb3N0TWVzc2FnZShtZXNzYWdlKTtcclxuICAgICAgICAgICAgfSk7XHJcbiAgICAgICAgICAgIGlmKGVycm9yKSB0aHJvdyBlcnJvcjtcclxuICAgICAgICB9KSlcclxuICAgICkpO1xyXG4gICAgLy8gaWRlYSBkZSBpbmZvcm1hciBlcnJvcjogaHR0cHM6Ly9zdGFja292ZXJmbG93LmNvbS9xdWVzdGlvbnMvNjI5MDkyODkvaG93LWRvLWktaGFuZGxlLWEtcmVqZWN0ZWQtcHJvbWlzZS1pbi1hLXNlcnZpY2Utd29ya2VyLWluc3RhbGwtZXZlbnRcclxufSk7XHJcblxyXG52YXIgc3BlY2lhbFNvdXJjZXM6e1trZXk6c3RyaW5nXTooKT0+UHJvbWlzZTxhbnk+fGFueX09e1xyXG4gICAgXCJAdmVyc2lvblwiOiAoKT0+dmVyc2lvbixcclxuICAgIFwiQENBQ0hFX05BTUVcIjogKCk9PkNBQ0hFX05BTUUsXHJcbiAgICBcIkB1cmxzVG9DYWNoZVwiOiAoKT0+dXJsc1RvQ2FjaGUubWFwKHI9Pnt2YXIgdSA9IG5ldyBVUkwobmV3IFJlcXVlc3QocikudXJsKTsgcmV0dXJuIHUucGF0aG5hbWUgKyB1LnNlYXJjaDt9KVxyXG59XHJcblxyXG5zZWxmLmFkZEV2ZW50TGlzdGVuZXIoJ2ZldGNoJywgYXN5bmMgKGV2dCk9PntcclxuICAgIC8vIEB0cy1leHBlY3QtZXJyb3IgRXNwZXJhbmRvIHF1ZSBhZ3JlZ2VuIGVsIGxpc3RlbmVyIGRlICdmZXRjaCcgZW4gZWwgc2lzdGVtYSBkZSB0aXBvc1xyXG4gICAgdmFyIGV2ZW50OkZldGNoRXZlbnQgPSBldnQ7XHJcbiAgICB2YXIgc291cmNlUGFydHMgPSBldmVudC5yZXF1ZXN0LnVybC5zcGxpdCgnLycpO1xyXG4gICAgdmFyIHNvdXJjZTpzdHJpbmcgPSBzb3VyY2VQYXJ0c1tzb3VyY2VQYXJ0cy5sZW5ndGgtMV07XHJcbiAgICBjb25zb2xlLmxvZyhcInNvdXJjZVwiLHNvdXJjZSlcclxuICAgIGlmKHNvdXJjZSBpbiBzcGVjaWFsU291cmNlcyl7XHJcbiAgICAgICAgdmFyIHZhbHVlID0gYXdhaXQgc3BlY2lhbFNvdXJjZXNbc291cmNlXSgpO1xyXG4gICAgICAgIHZhciBtaUJsb2IgPSBuZXcgQmxvYihbSlNPTi5zdHJpbmdpZnkodmFsdWUpXSwge3R5cGUgOiBcImFwcGxpY2F0aW9uL2pzb25cIn0pO1xyXG4gICAgICAgIHZhciBvcGNpb25lcyA9IHsgXCJzdGF0dXNcIiA6IDIwMCAsIFwic3RhdHVzVGV4dFwiOiB0eXBlb2YgdmFsdWUgPT09IFwic3RyaW5nXCI/dmFsdWU6XCJAanNvblwiLCBvazp0cnVlIH07XHJcbiAgICAgICAgdmFyIG1pUmVzcHVlc3RhID0gbmV3IFJlc3BvbnNlKG1pQmxvYixvcGNpb25lcyk7XHJcbiAgICAgICAgZXZlbnQucmVzcG9uZFdpdGgobWlSZXNwdWVzdGEpO1xyXG4gICAgfWVsc2V7XHJcbiAgICAgICAgZXZlbnQucmVzcG9uZFdpdGgoXHJcbiAgICAgICAgICAgIGNhY2hlcy5vcGVuKENBQ0hFX05BTUUpLnRoZW4oKGNhY2hlKT0+XHJcbiAgICAgICAgICAgICAgICBjYWNoZS5tYXRjaChldmVudC5yZXF1ZXN0KS50aGVuKChyZXNwb25zZSk9PntcclxuICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhcInJlc3B1ZXN0YSBjYWNow6k6IFwiLCByZXNwb25zZSlcclxuICAgICAgICAgICAgICAgICAgICByZXR1cm4gcmVzcG9uc2UgfHwgZmV0Y2goZXZlbnQucmVxdWVzdCkudGhlbigocmVzcG9uc2UpPT57XHJcbiAgICAgICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKFwicmVzcHVlc3RhXCIsIHJlc3BvbnNlKVxyXG4gICAgICAgICAgICAgICAgICAgICAgICBpZighcmVzcG9uc2UpIHtcclxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKFwibm8gdGllbmUgcmVzcHVlc3RhXCIpXHJcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB0aHJvdyBFcnJvcignd2l0aG91dCByZXNwb25zZScpO1xyXG4gICAgICAgICAgICAgICAgICAgICAgICB9XHJcbiAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiByZXNwb25zZTtcclxuICAgICAgICAgICAgICAgICAgICB9KS5jYXRjaChhc3luYyAoZXJyKT0+e1xyXG4gICAgICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhlcnIpXHJcbiAgICAgICAgICAgICAgICAgICAgICAgIHZhciBjbGllbnQgPSBhd2FpdCBzZWxmLmNsaWVudHMuZ2V0KGV2ZW50LmNsaWVudElkKTtcclxuICAgICAgICAgICAgICAgICAgICAgICAgY2xpZW50LnBvc3RNZXNzYWdlKGVycik7XHJcbiAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiBuZXcgUmVzcG9uc2UoYDxwPlNlIHByb2R1am8gdW4gZXJyb3IgYWwgaW50ZW50YXIgY2FyZ2FyIGxhIHAmYWFjdXRlO2dpbmEsIGVzIHBvc2libGUgcXVlIG5vIGhheWEgY29uZXhpJm9hY3V0ZTtuIGEgaW50ZXJuZXQ8L3A+PGEgaHJlZj0nLyc+Vm9sdmVyIGEgSG9qYSBkZSBSdXRhPC9idXR0b24+YCwge1xyXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgaGVhZGVyczogeydDb250ZW50LVR5cGUnOiAndGV4dC9odG1sJ31cclxuICAgICAgICAgICAgICAgICAgICAgICAgfSk7XHJcbiAgICAgICAgICAgICAgICAgICAgfSk7XHJcbiAgICAgICAgICAgICAgICB9KVxyXG4gICAgICAgICAgICApXHJcbiAgICAgICAgKTtcclxuICAgIH1cclxufSk7XHJcblxyXG5zZWxmLmFkZEV2ZW50TGlzdGVuZXIoJ2FjdGl2YXRlJywgKGV2dCk9PntcclxuICAgIC8vIEB0cy1leHBlY3QtZXJyb3IgRXNwZXJhbmRvIHF1ZSBhZ3JlZ2VuIGVsIGxpc3RlbmVyIGRlICdmZXRjaCcgZW4gZWwgc2lzdGVtYSBkZSB0aXBvc1xyXG4gICAgdmFyIGV2ZW50OkZldGNoRXZlbnQgPSBldnQ7XHJcbiAgICBjb25zb2xlLmxvZyhcImJvcnJhbmRvIGNhY2hlcyB2aWVqYXNcIilcclxuICAgIGV2ZW50LndhaXRVbnRpbChcclxuICAgICAgICBjYWNoZXMua2V5cygpLnRoZW4oKGNhY2hlTmFtZXMpPT57XHJcbiAgICAgICAgICAgIHJldHVybiBQcm9taXNlLmFsbChcclxuICAgICAgICAgICAgICAgIGNhY2hlTmFtZXMuZmlsdGVyKChjYWNoZU5hbWUpPT5cclxuICAgICAgICAgICAgICAgICAgICBjYWNoZU5hbWUgIT0gQ0FDSEVfTkFNRVxyXG4gICAgICAgICAgICAgICAgKS5tYXAoKGNhY2hlTmFtZSk9PntcclxuICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhcImJvcnJhbmRvIGNhY2hlIFwiLCBjYWNoZU5hbWUpO1xyXG4gICAgICAgICAgICAgICAgICAgIHJldHVybiBjYWNoZXMuZGVsZXRlKGNhY2hlTmFtZSk7XHJcbiAgICAgICAgICAgICAgICB9KVxyXG4gICAgICAgICAgICApO1xyXG4gICAgICAgIH0pXHJcbiAgICApO1xyXG59KTtcclxuXHJcbnNlbGYuYWRkRXZlbnRMaXN0ZW5lcignbWVzc2FnZScsIGZ1bmN0aW9uKGV2dCkge1xyXG4gICAgY29uc29sZS5sb2coXCJtZW5zYWplOiBcIiwgZXZ0LmRhdGEpXHJcbiAgICBpZihldnQuZGF0YT09J3NraXBXYWl0aW5nJyl7XHJcbiAgICAgICAgc2VsZi5za2lwV2FpdGluZygpLnRoZW4oKCk9PmNvbnNvbGUubG9nKHZlcnNpb24pKTtcclxuICAgIH1cclxufSk7Il19