INSERT INTO siscen.req_est_flu(
            reqestflu_origen, reqestflu_accion, reqestflu_destino, reqestflu_comentario_obligatorio, reqestflu_tlg)
    VALUES 
    
('borrador',	'confirmar'	,'confirmado' ,false,1),
('borrador',	'desafectar','desafectado',false,1),
('borrador',    'comentar'  ,'borrador'   ,true,1),
('duda',	    'contestar'	,'contestado' ,true,1),
('duda',	    'desafectar','desafectado',false,1),
('duda',	    'comentar'  ,'duda'       ,true,1),
--('rechazado',	'reabrir'	,'reabierto'  ,true,1),
--('rechazado',	'desafectar','desafectado',false,1),
--('rechazado',   'comentar'  ,'rechazado'  ,true,1),
('terminado',	'verificar'	,'verificado' ,false,1),
('terminado',	'reabrir'	,'reabierto'  ,true,1),
('terminado',	'comentar'  ,'terminado'  ,true,1),
('confirmado',	'terminar'	,'terminado'  ,false,1),
('confirmado',	'preguntar'	,'duda'       ,true,1),
--('confirmado',	'rechazar'	,'rechazado'  ,true,1),
('confirmado',	'comentar'  ,'confirmado' ,true,1),
('contestado',	'terminar'	,'terminado'  ,false,1),
('contestado',	'preguntar'	,'duda'       ,true,1),
--('contestado',	'rechazar'	,'rechazado'  ,true,1),
('contestado',	'comentar'  ,'contestado' ,true,1),
('reabierto',	'terminar'	,'terminado'  ,false,1),
('reabierto',	'preguntar'	,'duda'       ,true,1),
--('reabierto',	'rechazar'	,'rechazado'  ,true,1),
('reabierto',	'comentar'  ,'reabierto'  ,true,1),
('desafectado',	'comentar'  ,'desafectado',true,1);