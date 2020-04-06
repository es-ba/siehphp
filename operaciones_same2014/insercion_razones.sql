insert into encu.razones(raz_raz, raz_nombre, raz_prioridad, raz_tlg)
(select a.opc_opc||b.opc_opc ::integer, a.opc_texto||'. '||b.opc_texto, a.opc_opc::integer,1
from encu.opciones a join encu.opciones b on a.opc_ope=b.opc_ope
where a.opc_ope='same2014'
and a.opc_conopc='razon1'  and b.opc_conopc='razon2_'||a.opc_opc)
