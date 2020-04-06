<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "procesos.php";
require_once "comunes.php";

class Proceso_fin_de_campo extends Proceso_Formulario{
    function __construct(){
        parent::__construct(array(
            'titulo'=>'Fin de campo',
            'submenu'=>'procesamiento',
            'para_produccion'=>true,
            'permisos'=>array('grupo'=>'subcoor_campo','grupo1'=>'procesamiento'),
            'parametros'=>array(
                'tra_ope'=>array('invisible'=>true,'def'=>$GLOBALS['NOMBRE_APP']),
                'tra_replica'=>array('label'=>'réplica','tipo'=>'entero','aclaracion'=>'indique #todo para todas las réplicas'),
                'tra_rea'=>array('def'=>'#=1 | =3','label'=>'rea','aclaracion'=>'use | para indicar varias opciones'),
                'tra_comuna'=>array('label'=>'comuna','def'=>'#todo','aclaracion'=>'para rango use por ejemplo #>=1 & <=5'),
                'tra_dias'=>array('label'=>'días','def'=>'8','aclaracion'=>'días para fin de campo','tipo'=>'entero'),
            ),
            'bitacora'=>true,
            'boton'=>array('id'=>'procesar'),
        ));
    }
    function responder(){
        $intervalo='';
        $dias=$this->argumentos->tra_dias;
        if(!isset($this->argumentos->tra_replica)){
            return new Respuesta_Negativa("Error: El debe ingresar un número");
        }
        if(!isset($dias) || $dias===0){
            $intervalo='';
        }elseif($dias==1){
            $intervalo="- interval '1 day'";
        }else{
            $intervalo="- interval '$dias days'";
        }
        $procesadas=10;
        $campos_filtro=cambiar_prefijo($this->argumentos,'tra_','pla_');
        unset($campos_filtro->pla_ope);
        unset($campos_filtro->pla_dias);
        $filtro=$this->nuevo_objeto("Filtro_Normal",$campos_filtro);
        // return new Respuesta_Positiva("Procesaria ".json_encode($filtro->parametros)." /// ".$filtro->where);
        // select count(*) from respuestas, 
        // OJO GENERALIZAR la cantidad de días #709
        $ver=$this->db->ejecutar_sql(new Sql(<<<SQL
update respuestas
  set res_valor='1'
from (
select *,
    (
select max(tlg_momento)
from 
(select lag(hisres_valor) over (partition by hisres_enc order by hisres_tlg) as hisres_valor_anterior, *
  from his.his_respuestas
  where hisres_enc=pla_enc
    and hisres_ope='{$GLOBALS['nombre_app']}'
    and hisres_for='TEM'
    and hisres_mat=''
    and hisres_var='prox_rol') x inner join tiempo_logico on x.hisres_tlg=tlg_tlg
where hisres_valor_anterior is distinct from hisres_valor and hisres_valor='9'
    ) as cuando
  from plana_tem_
  where pla_prox_rol=9
    and pla_verificado in (1,3)
    and pla_estado_carga=2
    and pla_dispositivo = 1
    and {$filtro->where}
    and pla_fin_campo is null) x
  where x.cuando<current_timestamp {$intervalo} /* OJO GENERALIZAR ACÁ #708 antes decía - interval '2 days' */
    and res_enc=x.pla_enc
    and res_ope='{$GLOBALS['nombre_app']}'
    and res_for='TEM'
    and res_mat=''
    and res_var='fin_campo'
    and res_hog=0
    and res_mie=0
    and res_exm=0
SQL
        ,$filtro->parametros));
        $procesadas=$this->db->ultima_consulta->rowCount();
        return new Respuesta_Positiva("Procesadas con fin de campo $procesadas.");
    }
}
?>