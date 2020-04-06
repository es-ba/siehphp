CREATE TABLE encu.tem_temporaria(
    tem_enc         integer  NOT NULL,
    tem_id_marco    integer,        
    tem_comuna      integer,        
    tem_replica     integer,        
    tem_up          integer,        
    tem_lote        integer,        
    tem_clado       integer,        
    tem_ccodigo     integer,        
    tem_cnombre     character varying(255),    
    tem_hn          text,     
    tem_hp          character varying(255),    
    tem_hd          character varying(255),    
    tem_hab         character varying(255),    
    tem_h4          integer,     
    tem_usp         character varying(255),    
    tem_barrio      character varying(255),    
    tem_ident_edif  character varying(255),    
    tem_obs         character varying(255),    
    tem_frac_comun  integer,        
    tem_radio_comu  integer,        
    tem_mza_comuna  integer,        
    tem_marco       integer,        
    tem_titular     integer,        
    tem_zona        character varying(255),    
    tem_para_asignar    character varying(255),    
    tem_tlg             bigint    NOT NULL, 
    tem_dominio         integer,        
    tem_lote2011        character varying(255),    
    tem_participacion   integer,
    tem_etiquetas       integer,           
    tem_codpos          character varying(12),    
    tem_tipounidad      text,     
    tem_tot_hab         integer,
    tem_estrato         text,
 CONSTRAINT tem_temp_pkey PRIMARY KEY (tem_enc)
 );
ALTER TABLE encu.tem_temporaria OWNER TO tedede_php;


ALTER TABLE encu.tem 
    ADD COLUMN tem_etiquetas integer;
ALTER TABLE encu.tem 
    ADD COLUMN tem_tipounidad text;
ALTER TABLE encu.tem 
    ADD COLUMN tem_tot_hab integer;
ALTER TABLE encu.tem 
    ADD COLUMN tem_estrato text;

ALTER TABLE encu.plana_tem_ 
    ADD COLUMN pla_etiquetas integer;
ALTER TABLE encu.plana_tem_ 
    ADD COLUMN pla_tipounidad text;
ALTER TABLE encu.plana_tem_ 
    ADD COLUMN pla_tot_hab integer;
ALTER TABLE encu.plana_tem_  
    ADD COLUMN pla_estrato text;

 
    

