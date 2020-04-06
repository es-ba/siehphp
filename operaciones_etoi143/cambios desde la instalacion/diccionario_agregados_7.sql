CREATE TABLE encu.diccionario_agregar (
  diccionario text,
  origen text,
  destino text
  )
  WITH (
  OIDS=FALSE
);
ALTER TABLE encu.diccionario_agregar
  OWNER TO tedede_php;


insert into encu.diccionario_agregar values
('sn5_esp_txt', 'capilla del barrio ','1'),
('sn5_esp_txt', 'carpa sanitaria','1'),
('sn5_esp_txt', 'puesto de la plaza','1'),
('sn5_esp_txt', 'camión sanitario','1'),
('sn5_esp_txt', 'Centro Comunitario','2'),
('sn5_esp_txt', 'Fundacion respirar a traves del hospital tornu','1'),
('sn5_esp_txt', 'Domicilio de un familiar','1'),
('sn5_esp_txt', 'Escuela/colegio','6'),
('sn5_esp_txt', 'lugar de trabajo','7'),
('sn5_esp_txt', 'Medicina laboral','2'),
('sn5_esp_txt', 'ART','6'),
('sn5_esp_txt', 'Medico de la facultad','1'),
('sn5_esp_txt', 'Medico del gimnasio','1'),
('sn5_esp_txt', 'Aeroparque','1'),
('sn5_esp_txt', 'AFA','1'),
('sn5_esp_txt', 'club','1'),
('sn5_esp_txt', 'otra provincia (sin aclarar tipo de establecimiento)','1'),
('sn5_esp_txt', 'otro pais (sin aclarar tipo de establecimiento)','8'),
('sn5_esp_txt', 'otro país en un hospital','1');

insert into encu.diccionario
select diccionario, true as completo, 1 as tlg from encu.diccionario_agregar group by diccionario, completo, tlg;

insert into encu.dictra
select diccionario,origen,destino::integer, 1 from encu.diccionario_agregar;

INSERT INTO encu.dicvar values
('sn5_esp_txt','sn5_esp',1);

drop table encu.diccionario_agregar;