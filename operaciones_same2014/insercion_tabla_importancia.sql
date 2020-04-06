INSERT INTO encu.importancia(
            importancia_importancia, importancia_tlg)
    select importancia_importancia, /*CAMPOS_AUDITORIA*/ from encu_anterior.importancia;