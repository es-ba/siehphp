-- Triggers: contar_pyg_resp_trg
ALTER TABLE  encu.plana_pg1_ DISABLE TRIGGER  contar_pyg_trg;
--Se reemplaza en eah2026  por los  nuevos triggers contar_pyg_resp_iu_trg y contar_pyg_resp_d_trg
DROP TRIGGER IF EXISTS contar_pyg_resp_trg ON encu.plana_pg1_;
CREATE OR REPLACE TRIGGER contar_pyg_resp_iu_trg
    AFTER INSERT OR UPDATE OF pla_entrea_pg1
    ON encu.plana_pg1_
    FOR EACH ROW
    EXECUTE FUNCTION encu.contar_pyg_res_enc_trg();


CREATE OR REPLACE TRIGGER contar_pyg_resp_d_trg
    AFTER DELETE
    ON encu.plana_pg1_
    FOR EACH ROW
    EXECUTE FUNCTION  encu.contar_pyg_res_enc_trg()
