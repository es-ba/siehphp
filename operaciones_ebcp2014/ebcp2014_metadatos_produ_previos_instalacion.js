// REEMPLAZA TLG=1 y pone /*OTRA*/ y cambia el operativo

/* PARAMETROS: */
var nombreArchivo="ebcp2014_metadatos_produ_previos_instalacion";
var operativoAnterior='ebcp2014';
var operativoActual='Ebcp2015';
/* PROGRAMA */
var ForWriting=2;
var ForReading=1;
var ForAppending=8;
var env=WScript.CreateObject("WScript.Shell").Environment("Process");
var alert = function(s){WScript.Echo(s)}
var args=WScript.Arguments;
var objFSO = WScript.CreateObject("Scripting.FileSystemObject");
var objFile = objFSO.OpenTextFile(nombreArchivo+".backup", ForReading);
var strContents = objFile.ReadAll();
var nuevoContenido = strContents.replace(/^(.*), [0-9]*\);$/gm,'$1, 1);');
var nuevoContenido = nuevoContenido.replace(/^(.*);$/gm,'$1;/*OTRA*/');
//var nuevoContenido = nuevoContenido.replace(new RegExp("^([^']*)\) VALUES \('"+operativoAnterior+"',",'gm'),"$1) VALUES ('"+operativoActual+"',$2'");
//alert('tamanno '+strContents.length);
var objFileW = objFSO.CreateTextFile(nombreArchivo+".sql", true);

// matrices, formularios, preguntas, variables, opciones, saltos, filtros, bloques, con_opc

objFileW.Write("ALTER TABLE encu.bloques DROP CONSTRAINT bloques_formularios_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.bloques ADD CONSTRAINT bloques_formularios_fk FOREIGN KEY (blo_ope, blo_for) REFERENCES encu.formularios (for_ope, for_for) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.bloques DROP CONSTRAINT bloques_matrices_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.bloques ADD CONSTRAINT bloques_matrices_fk FOREIGN KEY (blo_ope, blo_for, blo_mat) REFERENCES encu.matrices (mat_ope, mat_for, mat_mat) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.con_var DROP CONSTRAINT con_var_consistencias_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.con_var ADD CONSTRAINT con_var_consistencias_fk FOREIGN KEY (convar_ope, convar_con) REFERENCES encu.consistencias (con_ope, con_con) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.con_var DROP CONSTRAINT con_var_variables_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.con_var ADD CONSTRAINT con_var_variables_fk FOREIGN KEY (convar_ope, convar_var) REFERENCES encu.variables (var_ope, var_var) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.con_var DROP CONSTRAINT con_var_formularios_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.con_var ADD CONSTRAINT con_var_formularios_fk FOREIGN KEY (convar_ope, convar_for) REFERENCES encu.formularios (for_ope, for_for) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.con_var DROP CONSTRAINT con_var_matrices_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.con_var ADD CONSTRAINT con_var_matrices_fk FOREIGN KEY (convar_ope, convar_for, convar_mat) REFERENCES encu.matrices (mat_ope, mat_for, mat_mat) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.filtros DROP CONSTRAINT filtros_formularios_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.filtros ADD CONSTRAINT filtros_formularios_fk FOREIGN KEY (fil_ope, fil_for) REFERENCES encu.formularios (for_ope, for_for) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.filtros DROP CONSTRAINT filtros_bloques_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.filtros ADD CONSTRAINT filtros_bloques_fk FOREIGN KEY (fil_ope, fil_for, fil_blo) REFERENCES encu.bloques (blo_ope, blo_for, blo_blo) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.filtros DROP CONSTRAINT filtros_matrices_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.filtros ADD CONSTRAINT filtros_matrices_fk FOREIGN KEY (fil_ope, fil_for, fil_mat) REFERENCES encu.matrices (mat_ope, mat_for, mat_mat) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.filtros DROP CONSTRAINT filtros_operativos_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.filtros ADD CONSTRAINT filtros_operativos_fk FOREIGN KEY (fil_ope) REFERENCES encu.operativos (ope_ope) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.opciones DROP CONSTRAINT opciones_con_opc_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.opciones ADD CONSTRAINT opciones_con_opc_fk FOREIGN KEY (opc_ope, opc_conopc) REFERENCES encu.con_opc (conopc_ope, conopc_conopc) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.opciones DROP CONSTRAINT opciones_operativos_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.opciones ADD CONSTRAINT opciones_operativos_fk FOREIGN KEY (opc_ope) REFERENCES encu.operativos (ope_ope) MATCH SIMPLE   ON UPDATE CASCADE ON DELETE NO ACTION DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.opciones DROP CONSTRAINT opciones_operativos_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.opciones ADD CONSTRAINT opciones_operativos_fk FOREIGN KEY (opc_ope) REFERENCES encu.operativos (ope_ope) MATCH SIMPLE   ON UPDATE CASCADE ON DELETE NO ACTION DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.saltos DROP CONSTRAINT saltos_con_opc_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.saltos ADD CONSTRAINT saltos_con_opc_fk FOREIGN KEY (sal_ope, sal_conopc) REFERENCES encu.con_opc (conopc_ope, conopc_conopc) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.saltos DROP CONSTRAINT saltos_opciones_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.saltos ADD CONSTRAINT saltos_opciones_fk FOREIGN KEY (sal_ope, sal_conopc, sal_opc) REFERENCES encu.opciones (opc_ope, opc_conopc, opc_opc) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.saltos DROP CONSTRAINT saltos_operativos_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.saltos ADD CONSTRAINT saltos_operativos_fk FOREIGN KEY (sal_ope) REFERENCES encu.operativos (ope_ope) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.saltos DROP CONSTRAINT saltos_variables_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.saltos ADD CONSTRAINT saltos_variables_fk FOREIGN KEY (sal_ope, sal_var) REFERENCES encu.variables (var_ope, var_var) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.variables DROP CONSTRAINT variables_con_opc_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.variables ADD CONSTRAINT variables_con_opc_fk FOREIGN KEY (var_ope, var_conopc) REFERENCES encu.con_opc (conopc_ope, conopc_conopc) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.variables DROP CONSTRAINT variables_formularios_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.variables ADD CONSTRAINT variables_formularios_fk FOREIGN KEY (var_ope, var_for) REFERENCES encu.formularios (for_ope, for_for) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.variables DROP CONSTRAINT variables_matrices_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.variables ADD CONSTRAINT variables_matrices_fk FOREIGN KEY (var_ope, var_for, var_mat) REFERENCES encu.matrices (mat_ope, mat_for, mat_mat) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.variables DROP CONSTRAINT variables_operativos_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.variables ADD CONSTRAINT variables_operativos_fk FOREIGN KEY (var_ope) REFERENCES encu.operativos (ope_ope) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");

objFileW.Write("ALTER TABLE encu.variables DROP CONSTRAINT variables_preguntas_fk;/*OTRA*/\n");
objFileW.Write("ALTER TABLE encu.variables ADD CONSTRAINT variables_preguntas_fk FOREIGN KEY (var_ope, var_pre) REFERENCES encu.preguntas (pre_ope, pre_pre) MATCH SIMPLE ON UPDATE CASCADE ON DELETE NO ACTION DEFERRABLE INITIALLY IMMEDIATE;/*OTRA*/\n");



objFileW.Write(nuevoContenido);
objFileW.Close();

