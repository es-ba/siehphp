INSERT INTO encu.semanas(
            sem_ope, sem_sem, sem_semana_referencia_desde, sem_semana_referencia_hasta, 
            sem_30dias_referencia_desde, sem_30dias_referencia_hasta, sem_mes_referencia, 
            sem_carga_enc_desde, sem_carga_enc_hasta, sem_carga_recu_desde, 
            sem_carga_recu_hasta, sem_tlg)
    VALUES ('ut2016', 1, '2016-04-01', '2016-04-07', 
            '2016-04-01', '2016-04-07', '2016-04-01', 
            '2016-04-01', '2016-12-07', '2016-04-01', '2016-12-07', 1);

update encu.variables 
  set var_editable_por='especial',
      var_expresion_habilitar='!"grilla-ut"'  
  where var_var='modulo_1';
  
  
update encu.preguntas
  set pre_texto='Diario de actividades', pre_aclaracion=null
  where pre_pre='MODULO_1';
    
    
update encu.variables 
  set var_editable_por='especial',
      var_expresion_habilitar='copia_version_cuest=-1234'  
  where var_var='modulo_1';
