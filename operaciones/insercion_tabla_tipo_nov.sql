INSERT INTO encu.tipo_nov(
            tiponov_tiponov, tiponov_tlg)
    select tiponov_tiponov, /*CAMPOS_AUDITORIA*/ from encu_anterior.tipo_nov;