function console_log(message, obj, id){
    var div = document.createElement('div');
    div.appendChild(document.createTextNode(message));
    if(obj!=null){
        if(obj instanceof Error){
            div.appendChild(document.createTextNode(obj.message));
            div.style.color='red';
        }else{
            div.appendChild(document.createTextNode(JSON.stringify(obj)));
        }
    }
    document.getElementById(id||'console').appendChild(div);
}


    "use strict";

    class ServiceWorkerAdmin {
        constructor() {
            this.options = {};
            this.currentRegistration = null;
        }
        async installIfIsNotInstalled(opts) {
            var _a, _b, _c, _d, _e, _f, _g, _h, _j;
            try {
                this.options = opts;
                if ('serviceWorker' in navigator) {
                    var reg = await navigator.serviceWorker.register(`sw-manifest.js`);
                    var handleNewVersion = async () => {
                        var _a, _b;
                        (_b = (_a = this.options) === null || _a === void 0 ? void 0 : _a.onNewVersionAvailable) === null || _b === void 0 ? void 0 : _b.call(_a, async () => {
                            var _a, _b, _c, _d;
                            (_b = (_a = this.options) === null || _a === void 0 ? void 0 : _a.onReadyToStart) === null || _b === void 0 ? void 0 : _b.call(_a, true);
                            await ((_d = (_c = this.currentRegistration) === null || _c === void 0 ? void 0 : _c.waiting) === null || _d === void 0 ? void 0 : _d.postMessage('skipWaiting'));
                        });
                    };
                    (_b = (_a = this.options).onInfoMessage) === null || _b === void 0 ? void 0 : _b.call(_a, 'Registrado:' + !!reg.active + ',' + !!reg.installing + ',' + !!reg.waiting + ',' + ((_c = reg.active) === null || _c === void 0 ? void 0 : _c.state) + ',' + ((_d = reg.installing) === null || _d === void 0 ? void 0 : _d.state) + ',' + ((_e = reg.waiting) === null || _e === void 0 ? void 0 : _e.state));
                    console.log('Registered:', reg);
                    this.currentRegistration = reg;
                    //updatefound is fired if service-worker.js changes.
                    reg.onupdatefound = () => {
                        var _a, _b;
                        (_b = (_a = this.options).onInfoMessage) === null || _b === void 0 ? void 0 : _b.call(_a, 'Instalando');
                        // The updatefound event implies that reg.installing is set; see
                        // https://w3c.github.io/ServiceWorker/#service-worker-registration-updatefound-event
                        // @ts-ignore si estoy en onpudatefound es porque existe reg.installing
                        var installingWorker = reg.installing;
                        installingWorker.onstatechange = () => {
                            var _a, _b, _c, _d, _e, _f;
                            (_b = (_a = this.options).onInfoMessage) === null || _b === void 0 ? void 0 : _b.call(_a, installingWorker.state);
                            console.log("estado: ", installingWorker.state);
                            switch (installingWorker.state) {
                                case 'installed':
                                    if (navigator.serviceWorker.controller) {
                                        // At this point, the old content will have been purged and the fresh content will
                                        // have been added to the cache.
                                        // It's the perfect time to display a "New content is available; please refresh."
                                        // message in the page's interface.
                                        console.log('New or updated content is available.');
                                        handleNewVersion();
                                    }
                                    else {
                                        // At this point, everything has been precached.
                                        // It's the perfect time to display a "Content is cached for offline use." message.
                                        console.log('Content is now available offline!');
                                    }
                                    //setMessage(`Aplicación actualizada, por favor refresque la pantalla`,'all-ok');
                                    break;
                                case 'activated':
                                    //setMessage(`Aplicación actualizada, espere a que se refresque la pantalla`,'all-ok');
                                    setTimeout(async () => {
                                        var _a, _b, _c, _d;
                                        (_b = (_a = this.options).onInfoMessage) === null || _b === void 0 ? void 0 : _b.call(_a, 'INSTALADO DEBE REINICIAR');
                                        await ((_d = (_c = this.options) === null || _c === void 0 ? void 0 : _c.onJustInstalled) === null || _d === void 0 ? void 0 : _d.call(_c, () => {
                                            location.reload();
                                        }));
                                    }, 1000);
                                    break;
                                case 'redundant':
                                    (_d = (_c = this.options) === null || _c === void 0 ? void 0 : _c.onError) === null || _d === void 0 ? void 0 : _d.call(_c, new Error('redundant'), 'redundant installing');
                                    console.error(new Error('redundant'), 'redundant installing');
                                    break;
                                default:
                                    (_f = (_e = this.options).onInfoMessage) === null || _f === void 0 ? void 0 : _f.call(_e, 'other:' + installingWorker.state);
                            }
                        };
                        installingWorker.onerror = (evErr) => {
                            var _a, _b;
                            (_b = (_a = this.options) === null || _a === void 0 ? void 0 : _a.onError) === null || _b === void 0 ? void 0 : _b.call(_a, evErr.error, 'installingWorker');
                            console.error(evErr.error, 'installingWorker');
                        };
                    };
                    navigator.serviceWorker.onmessage = async (evMss) => {
                        var _a, _b, _c, _d, _e, _f;
                        if (evMss.data instanceof Error) {
                            (_b = (_a = this.options) === null || _a === void 0 ? void 0 : _a.onError) === null || _b === void 0 ? void 0 : _b.call(_a, evMss.data, 'from serviceWorker');
                        }
                        else {
                            if (evMss.data.type === 'caching') {
                                await ((_d = (_c = this.options) === null || _c === void 0 ? void 0 : _c.onEachFile) === null || _d === void 0 ? void 0 : _d.call(_c, evMss.data.url, evMss.data.error));
                                if (evMss.data.error) {
                                    await ((_f = (_e = this.options) === null || _e === void 0 ? void 0 : _e.onError) === null || _f === void 0 ? void 0 : _f.call(_e, evMss.data.error, 'caching ' + evMss.data.url));
                                }
                            }
                        }
                        console.error(evMss.data, 'from serviceWorker');
                    };
                    if (!!reg.waiting && reg.active) {
                        handleNewVersion();
                    }
                    (_g = (_f = this.options) === null || _f === void 0 ? void 0 : _f.onReadyToStart) === null || _g === void 0 ? void 0 : _g.call(_f, !reg.active);
                    var urlsToCache = await this.getSW("urlsToCache");
                    [
                        { obj: document.scripts, prop: 'src' },
                        { obj: document.images, prop: 'src' },
                        { obj: document.styleSheets, prop: 'href' },
                    ].forEach(def => {
                        Array.prototype.forEach.call(def.obj, node => {
                            var _a, _b;
                            var url = new URL(node[def.prop]);
                            var query = url.pathname + url.search;
                            if (!urlsToCache.includes(query)) {
                                (_b = (_a = this.options) === null || _a === void 0 ? void 0 : _a.onError) === null || _b === void 0 ? void 0 : _b.call(_a, new Error(`Resource "${query}" is not in manifest`), 'initializing service-worker');
                            }
                        });
                    });
                }
                else {
                    console.log('serviceWorkers no soportados');
                    // acá hay que elegir cómo dar el error:
                    // this.options.onError?.(new Error('serviceWorkers no soportados'));
                    throw Error('serviceWorkers no soportados');
                }
            }
            catch (err) {
                (_j = (_h = this.options) === null || _h === void 0 ? void 0 : _h.onError) === null || _j === void 0 ? void 0 : _j.call(_h, err, 'installing');
            }
        }
        async getSW(variable) {
            let response = await fetch("@" + variable);
            let varResult = response.statusText;
            if (varResult === "@json") {
                return response.json();
            }
            return varResult;
        }
        async uninstall() {
            var _a;
            var CACHE_NAME = await this.getSW("CACHE_NAME");
            await ((_a = this.currentRegistration) === null || _a === void 0 ? void 0 : _a.unregister());
            if (CACHE_NAME) {
                await caches.delete(CACHE_NAME);
            }
        }
        async check4newVersion() {
            var _a;
            // var reg = 
            await ((_a = this.currentRegistration) === null || _a === void 0 ? void 0 : _a.update());
            // return reg!=null && (!!reg.waiting || !!reg.installing);
        }
    }
