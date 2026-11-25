INSERT INTO encu.rama(
            ram_ram, ram_descripcion, ram_tlg)
select ram_ram, ram_descripcion, /*CAMPOS_AUDITORIA*/ from encu_anterior.rama;