var x={}
x.largoMaximo=768;
x.horas=12
x.renglonesHora=6
x.pixelPorRenglon=x.largoMaximo/x.horas/x.renglonesHora;
console.log(x);
var y={}
y.pixelPorRenglon=Math.floor(x.pixelPorRenglon);
y.largoMaximo=y.pixelPorRenglon*x.horas*x.renglonesHora;
console.log(y);