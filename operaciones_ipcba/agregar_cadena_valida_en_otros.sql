set search_path = cvp,comun,public;

/*
UPDATE cvp.relatr set valor=translate(replace(replace(replace(valor,'…','...'),'BLACK ¬ DECKER','BLACK & DECKER'),'S`RITE','SPRITE'),'ÀÈÌÒÙàèìòù`´','ÁÉÍÓÚáéíóú''''')
  where periodo in ('a2013m12','a2014m01')
    and valor is not null and length(valor)>0
    and valor<>translate(replace(replace(replace(valor,'…','...'),'BLACK ¬ DECKER','BLACK & DECKER'),'S`RITE','SPRITE'),'ÀÈÌÒÙàèìòù`´','ÁÉÍÓÚáéíóú''''');
*/

alter table cvp.agrupaciones add CONSTRAINT "texto invalido en nombreagrupacion de tabla agrupaciones" CHECK (comun.cadena_valida(nombreagrupacion, 'castellano'));
update cvp.grupos set nombregrupo='Equipos teléfonicos móviles' where nombregrupo='Equipos teléfonicos mòviles';
alter table cvp.grupos add CONSTRAINT "texto invalido en nombregrupo de tabla grupos" CHECK (comun.cadena_valida(nombregrupo, 'castellano'));
alter table cvp.atributos add CONSTRAINT "texto invalido en nombreatributo de tabla atributos" CHECK (comun.cadena_valida(nombreatributo, 'castellano'));
alter table cvp.atributos add CONSTRAINT "texto invalido en abratributo de tabla atributos" CHECK (comun.cadena_valida(abratributo, 'castellano'));
alter table cvp.atributos add CONSTRAINT "texto invalido en unidaddemedida de tabla atributos" CHECK (comun.cadena_valida(unidaddemedida, 'extendido'));
alter table cvp.atributos add CONSTRAINT "texto invalido en valorinicial de tabla atributos" CHECK (comun.cadena_valida(valorinicial, 'amplio'));

-- select caracteres_invalidos(unidaddemedida,'extendido'), * from cvp.atributos where not (comun.cadena_valida(unidaddemedida, 'extendido'));

alter table cvp.calculos add CONSTRAINT "texto invalido en motivocopia de tabla calculos" CHECK (comun.cadena_valida(motivocopia, 'amplio'));
