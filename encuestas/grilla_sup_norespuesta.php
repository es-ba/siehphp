<?php
//UTF-8:SÍ
require_once "lo_imprescindible.php";
require_once "grilla_respuestas.php";
require_once "grilla_TEM.php";

class Grilla_supervision_para_proc extends Grilla_respuestas_para_proc{
    var $campo_total_personas='';
    var $alias_total_personas='';
    function __construct(){
        parent::__construct();
    }
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('SUP_');
        $this->campo_total_personas=count($this->filtrar_campos_del_operativo(array('total_r')))==0?'pla_total_m' :'pla_total_r';
        $this->alias_total_personas=str_replace('pla_', 's1_',$this->campo_total_personas);
        $t_pers= $this->campo_total_personas;
        $alias_t_pers= $this->alias_total_personas;
        $this->tabla->tablas_lookup["
           (select s.pla_enc as s1_enc, s.pla_hog as s1_hog, pla_respond s1_respond, pla_dominio as tem_dominio, pla_comuna as tem_comuna,
            pla_cod_enc as tem_cod_enc, pla_cod_recu as tem_cod_recu,pla_cod_sup as tem_cod_sup,
            pla_sup_aleat tem_sup_aleat, pla_sup_dirigida tem_sup_dirigida, pla_rea tem_rea, pla_norea tem_norea, pla_result_sup tem_result_sup,
            pla_norea_enc tem_norea_enc,pla_norea_recu tem_norea_recu, pla_norea_sup tem_norea_sup,
            pla_v1, pla_total_h as s1_total_h, $t_pers as $alias_t_pers,
            pla_razon1, pla_razon2_1,pla_razon2_2,pla_razon2_3,pla_razon2_4,pla_razon2_5,pla_razon2_6,pla_razon3,pla_razon2_7,pla_razon2_8,pla_razon2_9, i.pla_respondi i1_respondi
           from plana_s1_  s join plana_tem_ t on s.pla_enc=t.pla_enc  left join plana_i1_ i on s.pla_enc=i.pla_enc and s.pla_hog=i.pla_hog and s.pla_respond=i.pla_mie ) s1
        "]="pla_enc=s1_enc and pla_hog=s1_hog";
        $this->tabla->campos_lookup['s1_respond']=false;
        $this->tabla->campos_lookup['pla_v1']=false;
        $this->tabla->campos_lookup['s1_total_h']=false;
        $this->tabla->campos_lookup[$alias_t_pers]=false;
        $this->tabla->campos_lookup['pla_razon1']=false;
        $this->tabla->campos_lookup['pla_razon2_1']=false;
        $this->tabla->campos_lookup['pla_razon2_2']=false;
        $this->tabla->campos_lookup['pla_razon2_3']=false;
        $this->tabla->campos_lookup['pla_razon2_4']=false;
        $this->tabla->campos_lookup['pla_razon2_5']=false;
        $this->tabla->campos_lookup['pla_razon2_6']=false;
        $this->tabla->campos_lookup['pla_razon3']=false;
        $this->tabla->campos_lookup['pla_razon2_7']=false;
        $this->tabla->campos_lookup['pla_razon2_8']=false;
        $this->tabla->campos_lookup['pla_razon2_9']=false;
        $this->tabla->campos_lookup['tem_dominio']=false;
        $this->tabla->campos_lookup['tem_comuna']=false;
        $this->tabla->campos_lookup['tem_semana']=false;
        $this->tabla->campos_lookup['tem_cod_enc']=false;
        $this->tabla->campos_lookup['tem_cod_recu']=false;
        $this->tabla->campos_lookup['tem_cod_sup']=false;
        $this->tabla->campos_lookup['tem_sup_aleat']=false;
        $this->tabla->campos_lookup['tem_sup_aleat']=false;
        $this->tabla->campos_lookup['tem_sup_dirigida']=false;
        $this->tabla->campos_lookup['tem_rea']=false;
        $this->tabla->campos_lookup['tem_norea']=false;
        $this->tabla->campos_lookup['tem_norea_sup']=false;
        $this->tabla->campos_lookup['tem_result_sup']=false;
        $this->tabla->campos_lookup['tem_norea_enc']=false;
        $this->tabla->campos_lookup['tem_norea_recu']=false;
        $this->tabla->campos_lookup['i1_respondi']=false;        
        $this->tabla->clausula_where_agregada_manual=" and ( tem_sup_aleat is not null or tem_sup_dirigida is not null) ";                    
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='tem_estado';
        $heredados[]='tem_dominio';
        $heredados[]='tem_comuna';
        $heredados[]='tem_cod_enc';
        $heredados[]='tem_cod_recu';
        $heredados[]='tem_cod_sup';
        $heredados[]='tem_sup_aleat';
        $heredados[]='tem_sup_dirigida';
        $heredados[]='tem_rea';
        $heredados[]='tem_norea';
        $heredados[]='tem_result_sup';
        $heredados[]='tem_tip_sup';
        $heredados[]='tem_mod_sup';
        $heredados[]='tem_norea_enc';
        $heredados[]='tem_norea_recu';
        $heredados[]='s1_respond';
        $heredados[]='pla_enc';
        $heredados[]='pla_hog';
        $heredados[]='pla_mie';
        $heredados[]='pla_exm';
        $heredados[]='pla_razon1';
        $heredados[]='pla_razon3';
        $heredados[]='pla_razon2_1';
        $heredados[]='pla_razon2_2';
        $heredados[]='pla_razon2_3';
        $heredados[]='pla_razon2_4';
        $heredados[]='pla_razon2_5';
        $heredados[]='pla_razon2_6';
        $heredados[]='pla_razon2_7';
        $heredados[]='pla_razon2_8';
        $heredados[]='pla_razon2_9';
        $heredados[]='pla_sp2_0';
        $heredados[]='pla_sp2_1';
        $heredados[]='pla_sp2_2';
        $heredados[]='pla_sp2_3';
        $heredados[]='pla_sp2_4'; 
        $heredados[]='pla_sp2_5';
        $heredados[]='pla_sp2_6';
        $heredados[]='pla_sp2_6_4';
        $heredados[]='pla_sp2_7';
        $heredados[]='pla_sp2_8';
        $heredados[]='pla_sp2_9';
        return $heredados;
    }
    function permite_grilla_sin_filtro(){
        return false;
    }  
    function permite_grilla_sin_filtro_manual(){
        return true;
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(array('pla_enc', 'pla_hog', 's1_respond','tem_dominio','tem_comuna','tem_cod_enc','tem_cod_recu','tem_cod_sup',
            'tem_sup_aleat','tem_sup_dirigida','tem_rea', 'tem_norea','tem_result_sup', 'i1_respondi'),
            $this->filtrar_campos_del_operativo(array('pla_sp1', 'pla_sp4', 'pla_sp5', 'pla_sp5a'))
        );
    }           
    function cantidadColumnasFijas(){
        return 3;
    }
    function boton_enviar(){
        return array(
            'leyenda'=>'ir',
            'title'=>'abrir encuesta',
            'proceso'=>'ingresar_encuesta',
            'campos_parametros'=>array('tra_enc'=>null,'tra_hn'=>array('forzar_valor'=>-951)),
            'y_luego'=>'boton_ingresar_encuesta',
        );
    }
}
class Grilla_sup_norespuesta extends Grilla_supervision_para_proc{
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('SUP_');
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(parent::campos_a_listar($filtro_para_lectura),
            array('tem_norea_enc', 'tem_norea_recu'),
            $this->filtrar_campos_del_operativo(array(
                'pla_sp2_0','pla_razon1', 'pla_sp2_1', 'pla_razon2_1', 'pla_sp2_2', 'pla_razon2_2',
                'pla_sp2_3', 'pla_razon2_3', 'pla_sp2_4', 'pla_razon2_4', 
                'pla_sp2_5', 'pla_razon2_5', 'pla_sp2_6', 'pla_razon2_6', 
                'pla_sp2_6_4', 'pla_razon3', 'pla_sp2_7', 'pla_razon2_7', 'pla_sp2_8', 'pla_razon2_8', 'pla_sp2_9', 'pla_razon2_9'
            )));
    }
}
class Grilla_sup_vivhog extends Grilla_supervision_para_proc{
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('SUP_');
        $this->tabla->tablas_lookup["
           (select a.pla_enc as a1_enc, a.pla_hog as a1_hog, pla_v4 a1_v4, pla_h3 as a1_h3
           from plana_a1_  a ) a1
        "]="pla_enc=a1_enc and pla_hog=a1_hog";
        $this->tabla->campos_lookup['a1_v4']=false;
        $this->tabla->campos_lookup['a1_h3']=false;      
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(parent::campos_a_listar($filtro_para_lectura),
            $this->filtrar_campos_del_operativo(array('pla_sp3','pla_v1', 'pla_sp3_total','pla_tot_hoesp' ,'s1_total_h', 'pla_sp6',$this->alias_total_personas, 'pla_sp7','a1_v4', 'pla_sp8', 'a1_h3')
        ));
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='a1_v4';
        $heredados[]='a1_h3';  
        $heredados[]='pla_v1';
        $heredados[]='s1_total_h';        
        $heredados[]=$this->alias_total_personas;        
        return $heredados;
    }
}

class Grilla_sup_familiar extends Grilla_supervision_para_proc{
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('SUP_');
        $this->tabla->tablas_lookup["
           (select p.pla_enc as p_enc, p.pla_hog as p_hog, p.pla_mie p_mie , pla_sexo p_sexo, pla_f_nac_d as p_f_nac_d, pla_f_nac_m as p_f_nac_m, pla_f_nac_a as p_f_nac_a, pla_p4 p_p4, pla_p5 p_p5, pla_edad_30
           from plana_s1_ s 
                left join plana_s1_p  p on s.pla_enc= p.pla_enc and s.pla_hog=p.pla_hog and s.pla_respond=p.pla_mie
                left join encu.plana_i1_ i on p.pla_enc=i.pla_enc and p.pla_hog= i.pla_hog and p.pla_mie= i.pla_mie
                --left join encu.plana_sup_ sp on sp.pla_enc=i.pla_enc and sp.pla_hog= i.pla_hog
            ) a1
        "]="pla_enc=p_enc and pla_hog=p_hog ";
        $this->tabla->campos_lookup['p_sexo']=false;
        $this->tabla->campos_lookup['p_p4']=false;      
        $this->tabla->campos_lookup['p_f_nac_d']=false;      
        $this->tabla->campos_lookup['p_f_nac_m']=false;      
        $this->tabla->campos_lookup['p_f_nac_a']=false;      
        $this->tabla->campos_lookup['p_p5']=false;      
        $this->tabla->campos_lookup['pla_edad_30']=false; 
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(parent::campos_a_listar($filtro_para_lectura),
            $this->filtrar_campos_del_operativo(array('pla_sp9', 'p_sexo', 'pla_sp10_d', 'p_f_nac_d',
                'pla_sp10_m', 'p_f_nac_m', 'pla_sp10_a', 'p_f_nac_a', 'pla_sp_edad_30', 'pla_edad_30', 'pla_sp11','p_p4', 'pla_sp12','p_p5')
        ));
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='p_sexo';
        $heredados[]='p_p4';
        $heredados[]='p_p5';
        $heredados[]='p_f_nac_d';
        $heredados[]='p_f_nac_m';
        $heredados[]='p_f_nac_a';
        $heredados[]='pla_edad_30';
        $heredados[]='pla_sp_edad_30';
        return $heredados;
    }
}

class Grilla_sup_trabajo extends Grilla_supervision_para_proc{
    var $campos_por_ope=[];
    var $lista_por_ope='';
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('SUP_');
        $this->campos_por_ope=$this->filtrar_campos_del_operativo(array('pla_t11','pla_t11_otro','pla_t11_0'));
        $this->lista_por_ope=implode(',' ,$this->campos_por_ope);
        $this->tabla->tablas_lookup["
           (select i.pla_enc as p_enc, i.pla_hog as p_hog, i.pla_mie p_mie , pla_t1 , pla_t2, pla_t3, pla_t9, $this->lista_por_ope, pla_t12, pla_cond_activ 
           from plana_s1_ s left join plana_i1_  i on s.pla_enc= i.pla_enc and s.pla_hog=i.pla_hog and s.pla_respond=i.pla_mie) i1
        "]="pla_enc=p_enc and pla_hog=p_hog ";
        $this->tabla->campos_lookup['pla_t1']=false;
        $this->tabla->campos_lookup['pla_t2']=false;      
        $this->tabla->campos_lookup['pla_t3']=false;      
        $this->tabla->campos_lookup['pla_t9']=false;      
        $this->tabla->campos_lookup['pla_t12']=false;      
        $this->tabla->campos_lookup['pla_cond_activ']=false;
        foreach ($this->campos_por_ope as $var_i1) {
            $this->tabla->campos_lookup[$var_i1]=false;
        }    
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(parent::campos_a_listar($filtro_para_lectura),
            $this->filtrar_campos_del_operativo(array('pla_sp13', 'pla_t1', 'pla_sp14', 'pla_t2','pla_sp15', 'pla_t3',
                'pla_sp16', 'pla_t9', 'pla_sp16a', 'pla_t11','pla_sp16a_esp', 'pla_t11_otro','pla_t11_0', 'pla_sp16b','pla_sp17', 'pla_t12', 'pla_sp_cond_activ', 'pla_cond_activ')
        ));
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='pla_t1';
        $heredados[]='pla_t2';  
        $heredados[]='pla_t3';
        $heredados[]='pla_t9';        
        $heredados[]='pla_t12';        
        $heredados[]='pla_cond_activ';        
        $heredados[]='pla_sp_cond_activ'; 
        foreach ($this->campos_por_ope as $var_i1) {
            $heredados[]=$var_i1;
        }           
        return $heredados;
    }
}

class Grilla_sup_ingresos extends Grilla_supervision_para_proc{
    var $campos_por_ope=[];
    var $lista_por_ope='';
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('SUP_');
        //--variables que dependen de operativos
        /*
        $tabla_variables=$this->contexto->nuevo_objeto("Tabla_variables");
        $tabla_variables->leer_uno_si_hay(array(
            'var_ope'=>$GLOBALS['NOMBRE_APP'],
            'var_var'=>'i3_32'
        )); 
        $this->existe_i3_32=($tabla_variables->obtener_leido())?', pla_i3_32 ':'';
        */
        $this->campos_por_ope=$this->filtrar_campos_del_operativo(array('pla_i3_32', 'pla_i3_1', 'pla_i3_34', 'pla_i3_35', 'pla_i3_36'));
        $this->lista_por_ope=implode(',' ,$this->campos_por_ope);

        $q_lookup="
           (select i.pla_enc as p_enc, i.pla_hog as p_hog, i.pla_mie p_mie , pla_i3_2, pla_i3_3, pla_i3_4, pla_i3_5, pla_i3_6, pla_i3_7
              , pla_i3_81, pla_i3_82, pla_i3_11, pla_i3_31, pla_i3_12, pla_i3_13, pla_i3_13a, pla_i3_10, pla_i3_10_otro, pla_cant_i3
              , $this->lista_por_ope
              from plana_s1_ s left join plana_i1_  i on s.pla_enc= i.pla_enc and s.pla_hog=i.pla_hog and s.pla_respond=i.pla_mie
            ) i1
        ";
        $this->tabla->tablas_lookup[
        $q_lookup]="pla_enc=p_enc and pla_hog=p_hog ";
        //$this->tabla->campos_lookup['pla_i3_1'] =false;
        $this->tabla->campos_lookup['pla_i3_2'] =false;
        $this->tabla->campos_lookup['pla_i3_3'] =false;
        $this->tabla->campos_lookup['pla_i3_4'] =false;
        $this->tabla->campos_lookup['pla_i3_5'] =false;
        $this->tabla->campos_lookup['pla_i3_6'] =false;
        $this->tabla->campos_lookup['pla_i3_7'] =false;
        $this->tabla->campos_lookup['pla_i3_81']=false;
        $this->tabla->campos_lookup['pla_i3_82']=false;
        $this->tabla->campos_lookup['pla_i3_10']=false;
        $this->tabla->campos_lookup['pla_i3_10_otro']=false;
        $this->tabla->campos_lookup['pla_i3_11']=false;
        $this->tabla->campos_lookup['pla_i3_12']=false;
        $this->tabla->campos_lookup['pla_i3_13']=false;
        $this->tabla->campos_lookup['pla_i3_13a']=false;
        $this->tabla->campos_lookup['pla_i3_31'] =false;
        $this->tabla->campos_lookup['pla_cant_i3']=false;
        foreach ($this->campos_por_ope as $var_i1) {
            $this->tabla->campos_lookup[$var_i1]=false;
        }    

    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(parent::campos_a_listar($filtro_para_lectura),
            $this->filtrar_campos_del_operativo(array('pla_sp19_1','pla_i3_1','pla_sp19_34','pla_i3_34','pla_sp19_35','pla_i3_35','pla_sp19_36','pla_i3_36'
              , 'pla_sp19_2','pla_i3_2','pla_sp19_3', 'pla_i3_3', 'pla_sp19_4', 'pla_i3_4', 'pla_sp19_5','pla_i3_5', 'pla_sp19_6','pla_i3_6', 'pla_sp19_7','pla_i3_7'
              , 'pla_sp19_81','pla_i3_81', 'pla_sp19_82','pla_i3_82','pla_sp19_11','pla_i3_11','pla_sp19_32','pla_i3_32','pla_sp19_31','pla_i3_31'
              , 'pla_sp19_12','pla_i3_12', 'pla_sp19_13','pla_i3_13','pla_sp19_13a','pla_i3_13a'
              , 'pla_sp19_10','pla_i3_10', 'pla_sp19_especificar','pla_i3_10_otro','pla_cant_sp19','pla_cant_i3'
            ))
        );
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
       // $heredados[]='pla_i3_1';
        $heredados[]='pla_i3_2';
        $heredados[]='pla_i3_3';
        $heredados[]='pla_i3_4';
        $heredados[]='pla_i3_5';
        $heredados[]='pla_i3_6';
        $heredados[]='pla_i3_7';
        $heredados[]='pla_i3_81';
        $heredados[]='pla_i3_82';
        $heredados[]='pla_i3_11';
        $heredados[]='pla_i3_31';
        $heredados[]='pla_i3_12';
        $heredados[]='pla_i3_13';
        $heredados[]='pla_i3_13a';
        $heredados[]='pla_i3_10';
        $heredados[]='pla_i3_10_otro';
        $heredados[]='pla_cant_i3';
        $heredados[]='pla_cant_sp19';
        foreach ($this->campos_por_ope as $var_i1) {
            $heredados[]=$var_i1;
        }           

        return $heredados;
    }
}

class Grilla_sup_educacion extends Grilla_supervision_para_proc{
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('SUP_');
        $columna_i3_13a= '';  // ,pla_i3_13a as i3_13a
        $columna_cant_i3= '';  // ,pla_i3_13a as i3_13a
        $columna_cant_i3_s= '';  // ,pla_i3_13a as i3_13a
        $this->tabla->tablas_lookup["
           (select i.pla_enc as p_enc, i.pla_hog as p_hog, i.pla_mie p_mie , pla_e2 as e2 , pla_e6 as e6, pla_e12 as e12, pla_e13 as e13, pla_e_nivela, pla_e_nivelb
           from plana_s1_ s left join plana_i1_  i on s.pla_enc= i.pla_enc and s.pla_hog=i.pla_hog and s.pla_respond=i.pla_mie
                ) i1
        "]="pla_enc=p_enc and pla_hog=p_hog ";
        $this->tabla->campos_lookup['e2']=false;
        $this->tabla->campos_lookup['e6']=false;      
        $this->tabla->campos_lookup['e12']=false;      
        $this->tabla->campos_lookup['e13']=false;      
        $this->tabla->campos_lookup['pla_e_nivela']=false;      
        $this->tabla->campos_lookup['pla_e_nivelb']=false;      
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(parent::campos_a_listar($filtro_para_lectura),
            $this->filtrar_campos_del_operativo(array('pla_sp20','e2', 'pla_sp21','e6','pla_sp22', 'e12', 'pla_sp23', 'e13','pla_sp_e_nivela', 'pla_e_nivela', 'pla_sp_e_nivelb', 'pla_e_nivelb'
        )));
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='e2';
        $heredados[]='e6';
        $heredados[]='e12';
        $heredados[]='e13';
        $heredados[]='pla_e_nivela';
        $heredados[]='pla_e_nivelb';
        $heredados[]='pla_sp_e_nivela';
        $heredados[]='pla_sp_e_nivelb';
        return $heredados;
    }
}


class Grilla_sup_pmd extends Grilla_supervision_para_proc{
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('SUP_');
        $this->tabla->tablas_lookup["
           (select pmd.pla_enc p_enc, pmd.pla_hog p_hog, pla_ent_rea_pm, pla_respon, pla_pm86, pla_pm87, pla_pm87_esp
           from plana_pmd_ pmd
                ) pmd
        "]="pla_enc=p_enc and pla_hog=p_hog ";
         $this->tabla->campos_lookup['pla_ent_rea_pm']=false; 
         $this->tabla->campos_lookup['pla_respon']=false; 
         $this->tabla->campos_lookup['pla_pm86']=false; 
         $this->tabla->campos_lookup['pla_pm87']=false; 
         $this->tabla->campos_lookup['pla_pm87_esp']=false; 
    }
    function campos_a_listar($filtro_para_lectura){
        return array_merge(array('s1_respond','pla_enc', 'pla_hog','tem_dominio', 'tem_comuna','tem_semana', 'tem_estado', 'tem_cod_enc', 'tem_cod_recu', 'tem_cod_sup', 'tem_sup_aleat', 'tem_sup_dirigida', 'tem_rea', 'tem_norea','tem_result_sup', 'tem_norea_sup'),
            $this->filtrar_campos_del_operativo(array(
                'pla_ent_rea_pm', 'pla_respon', 'pla_sppmd1','pla_sppmd2' , 'pla_pm86', 'pla_sppmd86','pla_pm87', 'pla_sppmd87','pla_pm87_esp', 'pla_sppmd87_esp', 'pla_obs_campo_pob'
            )));
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        $heredados[]='tem_comuna';
        $heredados[]='tem_dominio';
        $heredados[]='tem_semana';
        $heredados[]='tem_estado';
        $heredados[]='tem_rea';
        $heredados[]='tem_norea';
        $heredados[]='tem_norea_sup';
        $heredados[]='tem_result_sup';
        $heredados[]='pla_ent_rea_pm'; 
        $heredados[]='pla_respon';
        $heredados[]='pla_sppmd1';
        $heredados[]='pla_sppmd2';  
        $heredados[]='pla_pm86';
        $heredados[]='pla_sppmd86';
        $heredados[]='pla_pm87'; 
        $heredados[]='pla_sppmd87';
        $heredados[]='pla_pm87_esp'; 
        $heredados[]='pla_sppmd87_esp';
        return $heredados;
    }
     function cantidadColumnasFijas(){
        return 3;
    }
    function responder_grabar_campo(){
        $this->tabla_plana_i1=$this->contexto->nuevo_objeto("Tabla_plana_SUP_");
        $tabla_variables=$this->contexto->nuevo_objeto("Tabla_variables");                
                $variable=quitar_prefijo($this->argumentos->campo,'pla_');
                $tabla_variables->leer_uno_si_hay(array(
                    'var_ope'=>$GLOBALS['NOMBRE_APP'],
                    'var_var'=>$variable,                    
                )); 
        if($tabla_variables->obtener_leido()){
            return parent::responder_grabar_campo();               
       }else{
            return $this->responder_grabar_campo_directo();
       }
    }
}


class Grilla_sup_discapacidad extends Grilla_supervision_para_proc{
    var $var_disca =['dd1','dd2','dd3','dd4','dd5','dd6','dd7','dd8','dd9','dd10','dd11','dd12','dd13','dd14','dd15','pd'];
    
    var $vcampos=[];
    var $vcampos_ls='';
    function iniciar($nombre_del_objeto_base){
        parent::iniciar('SUP_');
        foreach ($this->var_disca as $vari) {
            $this->vcampos[] = 'pla_'.$vari;
        };
        $this->vcampos_ls=implode(',',$this->filtrar_campos_del_operativo($this->vcampos));
        $this->vcampos_ls=$this->vcampos_ls==',' ||$this->vcampos_ls==null? '':','.$this->vcampos_ls; 
        
        $this->tabla->tablas_lookup["
           (select i.pla_enc as p_enc, i.pla_hog as p_hog, i.pla_mie p_mie  $this->vcampos_ls
                from plana_s1_ s 
                left join plana_i1_  i on s.pla_enc= i.pla_enc and s.pla_hog=i.pla_hog and s.pla_respond=i.pla_mie
                ) i1
        "]="pla_enc=p_enc and pla_hog=p_hog ";
        foreach ($this->vcampos as $vari) {
            $this->tabla->campos_lookup[$vari] =false;
        };
    }
    function campos_a_listar($filtro_para_lectura){
        $vlista=[];
        foreach ($this->vcampos as $vari) {
            $vlista[]=str_replace('pla_','pla_sp',$vari);
            $vlista[]=$vari;
        };

        return array_merge(parent::campos_a_listar($filtro_para_lectura),
            $this->filtrar_campos_del_operativo($vlista)
        );
    }
    function campos_solo_lectura(){
        $heredados=parent::campos_solo_lectura();
        foreach ($this->vcampos as $vari) {
            $heredados[]=$vari;
        }
        return $heredados;
    }
};



?>