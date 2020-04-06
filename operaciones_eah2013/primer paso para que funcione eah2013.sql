INSERT INTO encu.operativos(
            ope_ope, ope_nombre, ope_ope_anterior, ope_tlg)
    VALUES ('eah2013', 'Encuesta Anual de Hogares 2013', 'eah2012', 1);


INSERT INTO encu.con_opc
select 'eah2013', conopc_conopc, conopc_texto, conopc_tlg from encu.con_opc where conopc_ope='eah2012';


INSERT INTO encu.opciones
    SELECT 'eah2013', opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, 
       opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg FROM encu.opciones where opc_ope='eah2012';

INSERT INTO encu.formularios
    select 'eah2013', for_for, for_nombre, for_es_principal, for_orden, for_tlg FROM encu.formularios where for_ope='eah2012';


