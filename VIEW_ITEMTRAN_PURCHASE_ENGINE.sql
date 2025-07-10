CREATE OR REPLACE VIEW VIEW_ITEMTRAN_PURCHASE_ENGINE AS
select v.entity_code,
       V.TAX_RATE1,
       V.tax_rate2,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.TAX_AMOUNT1 * (-1)
         ELSE
          V.TAX_AMOUNT1
       END) TAX_AMOUNT1,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.TAX_AMOUNT2 * (-1)
         ELSE
          V.TAX_AMOUNT2
       END) TAX_AMOUNT2,
       v.tcode,
       v.vrno,
       v.trantype,
       (SELECT EINVOICE_IRNNO
          FROM LHSSYS_EINVOICE_TRAN T
         WHERE T.ENTITY_CODE = V.ENTITY_CODE
           AND T.TCODE = V.TCODE
           AND T.VRNO = V.VRNO
           AND ROWNUM = 1) EINVOICE_IRNNO,
       (SELECT EINVOICE_IRNDATE
          FROM LHSSYS_EINVOICE_TRAN T
         WHERE T.ENTITY_CODE = V.ENTITY_CODE
           AND T.TCODE = V.TCODE
           AND T.VRNO = V.VRNO
           AND ROWNUM = 1) EINVOICE_IRNDATE,
       (SELECT EINVOICE_ACKNOWLEDGENO
          FROM LHSSYS_EINVOICE_TRAN T
         WHERE T.ENTITY_CODE = V.ENTITY_CODE
           AND T.TCODE = V.TCODE
           AND T.VRNO = V.VRNO
           AND ROWNUM = 1) EINVOICE_ACKNOWLEDGENO,
       v.acc_code,
       (case
         wheN v.tcode = 'P' THEN
          (select mis_code
             from acc_mis_mast k
            where k.mis_column = 'AREA'
              and k.acc_code = v.acc_code
              and rownum = 1)
         ELSE
          'NOT-DEFINED'
       END) acc_mis_code,
       v.sub_acc_code,
       v.broker_code,
       v.consignee_code,
       v.consignee_address_slno,
       v.addon_code,
       v.stax_code,
       am.broker_code intro_broker_code,

       (select acc_sch from acc_mast kk where v.acc_code = kk.acc_code) ACC_SCH,
       ---- SUBSTR(V.ACC_CODE, 1, 1) ACC_SCH,
       (select creditlimit from acc_mast where acc_code = v.acc_code) credit_limit,
       v.etax_code,
       (case v.tcode
         when 'G' then
          (LHS_UTILITY.GET_NAME('ACC_CODE',
                                (SELECT TRPT_CODE
                                   FROM VIEW_GATETRAN F
                                  WHERE (F.vrno, F.tcode, F.slno) =
                                        (SELECT H.ref2_vrno,
                                                H.ref2_tcode,
                                                H.ref2_slno
                                           FROM VIEW_ITEMTRAN H
                                          WHERE H.vrno = V.ref2_vrno
                                            AND H.tcode = V.ref2_tcode
                                            AND H.slno = V.ref2_slno
                                            AND H.entity_code = V.entity_code))))
         else
          null
       end) SHIPING_LINE,

       (case v.tcode
         when 'G' then
          (LHS_UTILITY.GET_NAME('ACC_CODE',
                                (SELECT clear_agent_acc_code
                                   FROM VIEW_GATETRAN F
                                  WHERE (F.vrno, F.tcode, F.slno) =
                                        (SELECT H.ref2_vrno,
                                                H.ref2_tcode,
                                                H.ref2_slno
                                           FROM VIEW_ITEMTRAN H
                                          WHERE H.vrno = V.ref2_vrno
                                            AND H.tcode = V.ref2_tcode
                                            AND H.slno = V.ref2_slno
                                            AND H.entity_code = V.entity_code))))
         else
          null
       end) clear_agent_acc_code,

       (select h.partyrefno
          from order_head h
         where h.entity_code = v.entity_code
           and h.tcode = v.order_tcode
           and h.vrno = v.order_vrno
           and h.amendno = v.order_amendno) partyrefno,
       (select h.partyrefdate
          from order_head h
         where h.entity_code = v.entity_code
           and h.tcode = v.order_tcode
           and h.vrno = v.order_vrno
           and h.amendno = v.order_amendno) partyrefdate,
       (select h.cramt
          from order_head h
         where h.entity_code = v.entity_code
           and h.tcode = v.order_tcode
           and h.vrno = v.order_vrno
           and h.amendno = v.order_amendno) PO_amount,
       v.partybillno,
       v.partybillamt,
       v.partybilldate,
       v.challanno,
       v.challandate,
       v.freight_basis,
       v.freight_rate,
       v.freight_adv,
       v.freight_amt,
       v.freight_credit,
       v.trpt_code,
       v.trucktype,
       v.vehicle_type,
       v.truckno,
       v.lrno,
       v.lrdate,
       v.rakeno,
       v.from_place,
       v.to_place,
       v.lifter_code,
       v.duedate,
       v.app_remark,
       v.approvedby,
       (LENGTH(v.RAKENO) - LENGTH(REPLACE(v.RAKENO, ',', '')) + 1) Container_Count,
       v.approveddate,
       v.valuationby,
       v.valuationdate,
       v.tokenno,
       v.tokendate,
       v.acc_vrno,
       v.acc_slno,
       v.acc_tcode,
       v.old_vrno,
       v.catalog_flag,
       v.invoice_flag,
       v.manual_flag,
       v.certificate_flag,
       v.otherdoc_flag,
       v.ibr_flag,
       v.currency_code,
       v.exchange_rate,
       v.brokerage_basis,
       v.brokerage_rate,
       v.payment_duedate,
       v.wslipno,
       v.gate_tcode,
       v.gate_vrno,
       v.waybill_form_initial,
       v.waybillno,
       v.waybill_date,
       v.grosswt,
       v.tearwt,
       v.netwt,
       v.bagwt,
       v.bags,
       v.gatetime,
       v.intime,
       v.outtime,
       v.irfield1,
       v.irfield2,
       v.irfield3,
       v.irfield4,
       v.irfield5,
       v.irfield6,
       v.irfield7,
       v.irfield8,
       v.irfield9,
       v.irfield10,
       v.irfield11,
       v.irfield12,
       v.irfield13,
       v.irfield14,
       v.irfield15,
       v.irfield16,
       v.irfield17,
       v.irfield18,
       v.irfield19,
       v.irfield20,
       v.afcode2,
       v.afcode3,
       v.afcode4,
       v.afcode5,
       v.afcode6,
       v.afcode7,
       v.afcode8,
       v.afcode9,
       v.afcode10,
       v.afcode11,
       v.afcode12,
       v.afcode13,
       v.afcode14,
       v.afcode15,
       v.afcode16,
       v.afcode17,
       v.afcode18,
       v.afrate2,
       v.afrate3,
       v.afrate4,
       v.afrate5,
       v.afrate6,
       v.afrate7,
       v.afrate8,
       v.afrate9,
       v.afrate10,
       v.afrate11,
       v.afrate12,
       v.afrate13,
       v.afrate14,
       v.afrate15,
       v.afrate16,
       v.afrate17,
       v.afrate18,
       v.afratei2,
       v.afratei3,
       v.afratei4,
       v.afratei5,
       v.afratei6,
       v.afratei7,
       v.afratei8,
       v.afratei9,
       v.afratei10,
       v.afratei11,
       v.afratei12,
       v.afratei13,
       v.afratei14,
       v.afratei15,
       v.afratei16,
       v.afratei17,
       v.afratei18,
       v.aflogic2,
       v.aflogic3,
       v.aflogic4,
       v.aflogic5,
       v.aflogic6,
       v.aflogic7,
       v.aflogic8,
       v.aflogic9,
       v.aflogic10,
       v.aflogic11,
       v.aflogic12,
       v.aflogic13,
       v.aflogic14,
       v.aflogic15,
       v.aflogic16,
       v.aflogic17,
       v.aflogic18,
       v.are_tcode,
       v.are_vrno,
       v.are_no,
       v.are_date,
       v.bom_id,
       v.shift_code,
       v.freight_order_tcode,
       v.freight_order_vrno,
       v.freight_order_slno,
       v.lastupdate,
       v.user_code,
       v.flag,
       v.bill_pass_type,
       v.delivery_from_slno,
       v.delivery_to_slno,
       v.slno,
       v.vrdate,
       v.div_code,
       v.item_code,
       v.um,
       v.other_div_code,
       v.cost_code,
       v.dept_code,
       v.plant_code,
       v.eqpt_code,
       v.make_code,
       v.remark,
       v.stock_type,
       v.godown_code,
       v.batchno,
       v.ref_slno,
       v.partyqty,
       v.reachedqty,
       v.qtyrecd,
       v.qtyissued,
       v.qtybilled,
       v.qty1,
       v.qty2,
       v.qty3,
       v.qty4,
       v.partyrate,
       v.aum,
       v.aqtyrecd,
       v.aqtyissued,
       v.rate_um,
       v.rate,
       v.arate,
       v.fc_rate,
       v.aumtoum,
       v.irate,
       v.iratei,
       v.tax_rate,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.TAX_AMOUNT * (-1)
         ELSE
          V.TAX_AMOUNT
       END) TAX_AMOUNT,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.TAX_ONAMOUNT * (-1)
         ELSE
          V.TAX_ONAMOUNT
       END) TAX_ONAMOUNT,
       v.provrate,
       v.cramt,
       v.dramt,
       /*(select sum(ib.dramt) from itemtran_body  ib
              where ib.entity_code = v.entity_code
              and ib.tcode = v.tcode
              and ib.vrno = v.vrno) dramt  ,*/
       v.valrecd,
       v.valissued,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.AFIELD1 * (-1)
         ELSE
          V.AFIELD1
       END) AFIELD1,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.AFIELD2 * (-1)
         ELSE
          V.AFIELD2
       END) AFIELD2,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.AFIELD3 * (-1)
         ELSE
          V.AFIELD3
       END) AFIELD3,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.AFIELD4 * (-1)
         ELSE
          V.AFIELD4
       END) AFIELD4,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.AFIELD5 * (-1)
         ELSE
          V.AFIELD5
       END) AFIELD5,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.AFIELD6 * (-1)
         ELSE
          V.AFIELD6
       END) AFIELD6,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.AFIELD7 * (-1)
         ELSE
          V.AFIELD7
       END) AFIELD7,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.AFIELD8 * (-1)
         ELSE
          V.AFIELD8
       END) AFIELD8,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.AFIELD9 * (-1)
         ELSE
          V.AFIELD9
       END) AFIELD9,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.AFIELD10 * (-1)
         ELSE
          V.AFIELD10
       END) AFIELD10,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.AFIELD11 * (-1)
         ELSE
          V.AFIELD11
       END) AFIELD11,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.AFIELD12 * (-1)
         ELSE
          V.AFIELD12
       END) AFIELD12,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.AFIELD13 * (-1)
         ELSE
          V.AFIELD13
       END) AFIELD13,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.AFIELD14 * (-1)
         ELSE
          V.AFIELD14
       END) AFIELD14,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.AFIELD15 * (-1)
         ELSE
          V.AFIELD15
       END) AFIELD15,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.AFIELD16 * (-1)
         ELSE
          V.AFIELD16
       END) AFIELD16,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.AFIELD17 * (-1)
         ELSE
          V.AFIELD17
       END) AFIELD17,
       (CASE
         WHEN V.tnature IN ('PCRNT', 'PRET') THEN
          V.AFIELD18 * (-1)
         ELSE
          V.AFIELD18
       END) AFIELD18,
       v.insp_remark,
       v.inspectedby,
       v.inspecteddate,
       v.next_insp_req_flag,
       v.next_inspectedby,
       v.next_inspecteddate,
       v.expiry_date,
       v.order_tcode,
       v.order_vrno,
       v.order_amendno,
       v.order_slno,
       (select ob.duedate
          from order_body ob
         where ob.entity_code = v.entity_code
           and ob.tcode = v.order_tcode
           and ob.vrno = v.order_vrno
           and ob.amendno = v.order_amendno
           and ob.slno = v.order_slno) order_delidate,
       (select ob.qtyorder
          from order_body ob
         where ob.entity_code = v.entity_code
           and ob.tcode = v.order_tcode
           and ob.vrno = v.order_vrno
           and ob.amendno = v.order_amendno
           and ob.slno = v.order_slno) order_qty,
       (select b.vrdate
          from order_body a, order_head b
         where a.entity_code = v.entity_code
           and a.tcode = v.order_tcode
           and a.vrno = v.order_vrno
           and a.amendno = v.order_amendno
           and a.slno = v.order_slno
           and a.entity_code = b.entity_code
           and a.contract_tcode = b.tcode
           and a.contract_vrno = b.vrno
           and a.contract_amendno = b.amendno) contract_vrdate,
       (select b.Irfield10
          from order_body a, order_head b
         where a.entity_code = v.entity_code
           and a.tcode = v.order_tcode
           and a.vrno = v.order_vrno
           and a.amendno = v.order_amendno
           and a.slno = v.order_slno
           and a.entity_code = b.entity_code
           and a.contract_tcode = b.tcode
           and a.contract_vrno = b.vrno
           and a.contract_amendno = b.amendno) contract_inv_rem,
       ----------------Payment
       (SELECT WM_CONCAT(DISTINCT PA.VRNO)
          FROM pay_advice_body PA
         WHERE PA.ENTITY_CODE = V.ENTITY_CODE
           AND PA.REF_VRNO = V.ACC_VRNO
           AND PA.REF_TCODE = V.ACC_TCODE
           AND ROWNUM = 1
         GROUP BY PA.REF_VRNO) ADVICE_VRNO,

       (SELECT WM_CONCAT(DISTINCT PA.TRANTYPE_NAME)
          FROM VIEW_PAY_ADVICE PA
         WHERE PA.ENTITY_CODE = V.ENTITY_CODE
           AND PA.REF_VRNO = V.ACC_VRNO
           AND PA.REF_TCODE = V.ACC_TCODE) ADVICE_TYPE,

       (SELECT wm_concat(DISTINCT PA.APPROVEDBY)
          FROM view_pay_advice PA
         WHERE PA.ENTITY_CODE = V.ENTITY_CODE
           AND PA.REF_VRNO = V.ACC_VRNO
           AND PA.REF_TCODE = V.ACC_TCODE
         GROUP BY PA.REF_VRNO) ADVICE_APPR_BY,

       (SELECT WM_CONCAT(DISTINCT PA.APPROVEDDATE)
          FROM VIEW_PAY_ADVICE PA
         WHERE PA.ENTITY_CODE = V.ENTITY_CODE
           AND PA.REF_VRNO = V.ACC_VRNO
           AND PA.REF_TCODE = V.ACC_TCODE) ADVICE_APPR_DATE,

       (SELECT NVL(SUM(PA.ADV_AMT), 0)
          FROM pay_advice_body PA
         WHERE PA.ENTITY_CODE = V.ENTITY_CODE
           AND PA.REF_VRNO = V.ACC_VRNO
           AND PA.REF_TCODE = V.ACC_TCODE
           AND ROWNUM = 1) ADVICE_AMT,

       (select WM_CONCAT(DISTINCT A.DR_VRNO)
          from alloc_tran a
         where a.entity_code = v.entity_code
           and a.cr_tcode = v.acc_tcode
           and a.cr_vrno = v.acc_vrno
           and a.cr_slno = v.acc_slno) PAYMENT_VRNO,

       (SELECT NVL(SUM(ALLOC_AMT), 0)
          FROM VIEW_PAY_ADVICE PA
         WHERE PA.ENTITY_CODE = V.ENTITY_CODE
           AND PA.REF_VRNO = V.ACC_VRNO
           AND PA.REF_TCODE = V.ACC_TCODE
         GROUP BY PA.REF_VRNO) PAYMENT_AMT,

       (SELECT WM_CONCAT(DISTINCT PA.VRNO)
          FROM pay_advice_body PA
         WHERE PA.ENTITY_CODE = V.ENTITY_CODE
           AND PA.REF_VRNO = V.order_vrno
           AND PA.REF_TCODE = V.order_tcode
           AND ROWNUM = 1
         GROUP BY PA.REF_VRNO) ADVANCE_ADVICE_VRNO,

       (SELECT NVL(SUM( PA.DRAMT), 0)
          FROM ACC_TRAN PA
         WHERE PA.ENTITY_CODE = V.ENTITY_CODE
           AND PA.order_vrno = V.order_vrno
          -- AND PA.REF_TCODE = V.order_tcode
          --- AND ROWNUM = 1
         /*GROUP BY PA.order_vrno*/) ADVANCE_ADVANCE_AMT,

        /* (SELECT AVG(NVL( PA.ADV_APP_AMT,0))
          FROM VIEW_PAY_ADVICE PA  \*, VIEW_ITEMTRAN_ENGINE V *\
         WHERE PA.ENTITY_CODE = V.ENTITY_CODE
           AND PA.ACC_CODE = V.ACC_CODE
          AND PA.REF_VRNO = V.order_VRNO
          --- AND ROWNUM = 1
        GROUP BY PA.ADV_APP_AMT,PA.REF_VRNO) ADVANCE_ADVANCE_AMT,*/



       (SELECT WM_CONCAT(DISTINCT R.ACC_VRNO)
          FROM VIEW_PAY_ADVICE_ALLOC R, PAY_ADVICE_BODY Y
         WHERE r.entity_code = y.entity_code
           and r.tcode = y.tcode
           and R.VRNO = Y.VRNO
           and r.slno = y.slno
           and y.entity_code = v.entity_code
           and y.ref_tcode = v.order_tcode
           and Y.REF_VRNO = V.ORDER_VRNO) ADVANCE_PAYMENT_VRNO,

       (SELECT NVL(SUM(PA.TDS_AMT), 0)
          FROM VIEW_PAY_ADVICE PA
         WHERE PA.ENTITY_CODE = V.ENTITY_CODE
           AND PA.REF_VRNO = V.order_vrno
           AND PA.REF_TCODE = V.order_tcode
           AND ROWNUM=1
         GROUP BY PA.REF_VRNO) ADVANCE_TDS_AMT,

           (SELECT NVL(SUM(PA.ALLOC_AMT), 0)
          FROM VIEW_PAY_ADVICE PA
         WHERE PA.ENTITY_CODE = V.ENTITY_CODE
           AND PA.REF_VRNO = V.order_vrno
           AND PA.REF_TCODE = V.order_tcode
         GROUP BY PA.REF_VRNO) ADVANCE_PAYMENT_AMT,


       (select WM_CONCAT(DISTINCT m.vrno)
          from itemtran_body m
         where M.entity_code = v.entity_code
           and M.ref1_tcode = v.acc_tcode
           and m.ref1_vrno = v.acc_vrno
           and nvl(m.ref1_slno, 1) = v.acc_slno
           and m.ref1_vrno is not null
           and rownum = 1) debit_note_no,




       (select WM_CONCAT(DISTINCT m.vrdate)
          from itemtran_body m
         where M.entity_code = v.entity_code
           and M.ref1_tcode = v.acc_tcode
           and m.ref1_vrno = v.acc_vrno
           and nvl(m.ref1_slno, 1) = v.acc_slno
           and m.ref1_vrno is not null
           and rownum = 1) debit_note_date,

       (select (sum(nvl(qtyrecd, 0)) + sum(nvl(qtyissued, 0)))
          from itemtran_body m
         where M.entity_code = v.entity_code
           and M.ref1_tcode = v.acc_tcode
           and m.ref1_vrno = v.acc_vrno
           and nvl(m.ref1_slno, 1) = v.acc_slno
           and m.ref1_vrno is not null) debit_note_qty,

       /*(select (sum(nvl(DRAMT, 0)))
          from itemtran_body m
         where M.entity_code = v.entity_code
           and M.ref1_tcode = v.acc_tcode
           and m.ref1_vrno = v.acc_vrno
           and nvl(m.ref1_slno, 1) = v.acc_slno
           and m.ref1_vrno is not null)*/

             (Select sum(b.dramt)
          From Itemtran_Body b
         Where b.Entity_Code = v.Entity_Code
           And (b.Ref1_Tcode, b.Ref1_Vrno/*, b.Ref1_Slno*/) In
               (Select h.Acc_Tcode, h.Acc_Vrno/*, h.Acc_Slno*/
                  From Itemtran_Head h
                 Where h.Entity_Code = v.Entity_Code
                   And h.Tcode = v.Tcode
                   And h.Vrno = v.Vrno)) debit_note_amt,



       -----------------Payment
       -------------
       CASE
         WHEN ACC_VRNO IS NOT NULL AND V.APPROVEDBY IS NOT NULL THEN
          'DAPPR'
         WHEN ACC_VRNO IS NULL AND V.APPROVEDBY IS NULL THEN
          'PAPPR'
         WHEN ACC_VRNO = 'CANCELLED' THEN
          'CANCEL'
         WHEN (V.ENTITY_CODE, V.TCODE, V.VRNO) IN
              (SELECT EI.ENTITY_CODE, EI.TCODE, EI.VRNO
                 FROM LHSSYS_EINVOICE_TRAN EI
                WHERE EI.ENTITY_CODE = ENTITY_CODE
                  AND EI.TCODE = TCODE
                  AND EI.VRNO = VRNO) THEN
          'DEINV'
         WHEN (V.ENTITY_CODE, V.TCODE, V.VRNO) NOT IN
              (SELECT EI.ENTITY_CODE, EI.TCODE, EI.VRNO
                 FROM LHSSYS_EINVOICE_TRAN EI
                WHERE EI.ENTITY_CODE = ENTITY_CODE
                  AND EI.TCODE = TCODE
                  AND EI.VRNO = VRNO) THEN
          'PEINV'
       END FLT_STATUS,
       --------------
       v.indent_tcode,
       v.indent_vrno,
       v.indent_slno,
       v.ref1_tcode,
       v.ref1_vrno,
       v.ref1_slno,
       v.qc_tcode,
       v.qc_vrno,
       v.ref2_tcode,
       v.ref2_vrno,
       v.ref2_slno,
       v.ref3_tcode,
       v.ref3_vrno,
       v.ref3_slno,
       v.ref4_tcode,
       v.ref4_vrno,
       v.ref4_slno,
       v.ref5_tcode,
       v.ref5_vrno,
       v.ref5_slno,
       v.ref6_tcode,
       v.ref6_vrno,
       v.ref6_slno,
       (select GB.CHALLANNO
          from GATEtran_head GB
         where gb.vrno in (select GB.ref2_vrno
                             from view_itemtran_GBOE GB
                            WHERE GB.entity_code = V.entity_code
                              AND GB.tcode = V.REF2_TCODE
                              AND GB.vrno = V.REF2_VRNO
                              AND GB.SLNO = V.REF2_SLNO)
           and gb.challanno is not null) IMS_BL_NO,
       (select GB.CHALLANDATE
          from GATEtran_head GB
         where gb.vrno in (select GB.ref2_vrno
                             from view_itemtran_GBOE GB
                            WHERE GB.entity_code = V.entity_code
                              AND GB.tcode = V.REF2_TCODE
                              AND GB.vrno = V.REF2_VRNO
                              AND GB.SLNO = V.REF2_SLNO)) IMS_BL_DT,
       (select GB.OUTDATE
          from GATEtran_head GB
         where gb.vrno in (select GB.ref2_vrno
                             from view_itemtran_GBOE GB
                            WHERE GB.entity_code = V.entity_code
                              AND GB.tcode = V.REF2_TCODE
                              AND GB.vrno = V.REF2_VRNO
                              AND GB.SLNO = V.REF2_SLNO)) IMS_ISSUE_DT,
       v.insp_dept_code,
       v.post_acc_code,
       v.post_sub_acc_code,
       v.other_godown_code,
       v.other_cost_code,
       v.other_item_code,
       v.unit_freight_rate,
       v.acc_year,
       v.series,
       v.tnature,
       v.bheading,
       v.stock_flag,
       v.irfhead1,
       v.irfhead2,
       v.irfhead3,
       v.irfhead4,
       v.irfhead5,
       v.irfhead6,
       v.irfhead7,
       v.irfhead8,
       v.irfhead9,
       v.irfhead10,
       v.irfhead11,
       v.irfhead12,
       v.irfhead13,
       v.irfhead14,
       v.irfhead15,
       v.irfhead16,
       v.irfhead17,
       v.irfhead18,
       v.irfhead19,
       v.irfhead20,
       v.vrprefix,
       v.neg_stock_flag,
       v.valuation_date,
       v.acc_vrdate,
       v.apartyqty,
       v.aqty1,
       v.aqty2,
       v.aqty3,
       v.aqty4,
       v.areachedqty,
       v.cntr_code,
       v.crcode,
       v.ct_tcode,
       v.ct_vrno,
       v.drcode,
       v.lc_tcode,
       v.lc_vrno,
       v.other_batchno,
       v.other_dept_code,
       v.other_ref_slno,
       v.other_stock_type,
       v.tp_book_no,
       v.tp_page_no,
       v.tranum,
       --v.issue_vrno,
       --v.issue_vrdate,
       (select M.CHALLANNO
          from itemtran_head M
         where M.entity_code = v.entity_code
           and M.tcode = v.ref2_tcode
           and m.vrno = v.ref2_vrno) BOE_NO,
       ------------------------------------------------
       (select m.user_code
          from itemtran_head M
         where M.entity_code = v.entity_code
           and M.tcode = v.ref1_tcode
           and m.vrno = v.ref1_vrno) REQ_USER,
       ---------------------------------------------------
       (select M.CHALLANDATE
          from itemtran_head M
         where M.entity_code = v.entity_code
           and M.tcode = v.ref2_tcode
           and m.vrno = v.ref2_vrno) BOE_DATE,
       v.wslip_slno,
       (select to_char(wm_concat(q.test_code))
          from qctran_body q
         where q.entity_code = v.entity_code
           and q.tcode = v.qc_tcode
           and q.vrno = v.qc_vrno) test_code,

       (select replace(to_char(wm_concat(q.test_result)), ',', ' || ')
          from qctran_body q
         where q.entity_code = v.entity_code
           and q.tcode = v.qc_tcode
           and q.vrno = v.qc_vrno) test_result,

       /*  (select nvl(sum(lhs_acc.get_alloc_amt(a.entity_code,
                                                    a.div_code,
                                                    a.dr_tcode,
                                                    a.dr_vrno,
                                                    a.dr_slno,
                                                    'DR',
                                                    a.dr_vrdate)),
                          0)
                 from alloc_tran a
                where a.entity_code = v.entity_code
                  and a.cr_tcode = v.acc_tcode
                  and a.cr_vrno = v.acc_vrno
                  and a.cr_slno = v.acc_slno) alloc_amt,*/

       (nvl(lhs_acc.get_alloc_amt(v.entity_code,
                                  null,
                                  v.tcode,
                                  v.vrno,
                                  v.slno,
                                  'DR',
                                  trunc(sysdate),
                                  null),
            0)) alloc_amt,

       (select max(a.cr_vrdate)
          from alloc_tran a
         where a.entity_code = v.entity_code
           and a.dr_tcode = v.acc_tcode
           and a.dr_vrno = v.acc_vrno
           and a.dr_slno = v.acc_slno) receipt_vrdate,

       (SELECT SUM(NVL(AT.CRAMT,0))
        /* AT.CRAMT*/
          FROM ACC_TRAN AT
         WHERE AT.ENTITY_CODE = V.entity_code
           AND AT.TCODE = V.acc_tcode
           AND AT.VRNO = V.acc_vrno
              --AND AT.PARTYBILLNO=V.partybillno
           AND AT.TDS_CODE IS NOT NULL
           AND AT.TDS_SLNO = 1
        /*AND AT.LOAN_CODE = 'TDS'*/
        ) TDS_AMOUNT,

       (SELECT SUM(NVL(AT.TDSAMT, 0))
          FROM ACC_TRAN AT
         WHERE AT.ENTITY_CODE = V.entity_code
           AND AT.TCODE = V.acc_tcode
           AND AT.VRNO = V.acc_vrno
           AND AT.TDS_CODE IS NOT NULL
           AND AT.LOAN_CODE = 'TDS') TDS_ON_AMOUNT,

       (SELECT SUM(NVL(AT.TDS_RATE, 0))
          FROM ACC_TRAN AT
         WHERE AT.ENTITY_CODE = V.entity_code
           AND AT.TCODE = V.acc_tcode
           AND AT.VRNO = V.acc_vrno
           AND AT.TDS_CODE IS NOT NULL
           AND AT.LOAN_CODE = 'TDS') TDS_RATE,

       m.item_nature,
       m.item_name,
       m.item_detail,
       m.shortname,
       m.item_status,
       m.item_sch,
       m.item_class,
       m.item_group,
       m.item_catg,
       m.parent_code,
       m.supplier_item_name,
       m.excise_tariff_code,
       m.item_size,
       m.ssg_parent_code,
       m.sg_parent_code,
       m.lab_qc_flag,
       m.g_parent_code,
       m.mfg_item_flag,
       m.cost_run_Seq,
       m.auto_idt_flag,
       M.ITEM_CLOSED_DATE,
       c.cost_sch,
       ssg_item_sch,
       sg_item_sch,
       g_item_sch,
       oh.emp_code,
       OH.PAYMENT_DUEDAYS,
       oh.vrdate order_vrdate,
       oh.amenddate order_amenddate,
       ih.vrdate indent_vrdate,
       oh.contract_tcode contract_tcode,
       oH.qtyorder,
       oH.qtycancelled,
       oh.contract_vrno contract_vrno,
       oh.contract_slno contract_slno,
       oh.contract_amendno contract_amendno,
       oh.quotation_tcode,
       oh.quotation_vrno,
       oh.quotation_slno,
       oh.quotation_amendno,
       (select qtyorder
          from order_body
         where entity_code = oh.entity_code
           and tcode = oh.contract_tcode
           and vrno = oh.contract_vrno
           and amendno = oh.contract_amendno
           and slno = oh.contract_slno) contract_qty,
       oh.rate order_rate,

       -------18-05-2023

       (select b.rate
          from order_body b
         where entity_code = oh.entity_code
           and tcode = oh.contract_tcode
           and vrno = oh.contract_vrno
           and amendno = oh.contract_amendno
           and slno = oh.contract_slno) contract_rate,
       -------

       (select net_rate
          from order_body
         where entity_code = oh.entity_code
           and tcode = oh.contract_tcode
           and vrno = oh.contract_vrno
           and amendno = oh.contract_amendno
           and slno = oh.contract_slno) cont_net_rate,

       (select fc_rate
          from order_body
         where entity_code = oh.entity_code
           and tcode = oh.contract_tcode
           and vrno = oh.contract_vrno
           and amendno = oh.contract_amendno
           and slno = oh.contract_slno) cont_fc_rate,

       am.acc_status,
       am.state_code,
       am.district,
       am.city,
       AM.supplier_type,
       NVL(POST_ACC_CODE,
           LHS_ACC.GET_POST_CODE(v.ENTITY_CODE,
                                 v.DIV_CODE,
                                 v.ACC_TCODE,
                                 v.ACC_VRNO,
                                 v.ACC_YEAR,
                                 m.ITEM_GROUP,
                                 v.TRANTYPE,
                                 v.STOCK_TYPE)) POST_CODE,
       (select item_nature_name
          from view_item_nature
         where item_nature = m.item_nature) item_nature_name,

       ----GST UPDATION START---
       m.gst_code,
       (select a.gstinno
          from view_address_mast a
         where slno = v.delivery_from_slno
           and acc_code = v.acc_code) Delivery_From_GSTINNO,
       (select a.gstinno
          from view_address_mast a
         where slno = v.delivery_to_slno
           and acc_code = v.acc_code) Delivery_to_GSTINNO,
       (select a.state_name
          from view_address_mast a
         where slno = v.delivery_from_slno
           and acc_code = v.acc_code) GST_From_state,
       (select a.state_name
          from view_address_mast a
         where slno = v.delivery_to_slno
           and acc_code = v.acc_code) GST_to_state,
       (select a.gst_state_code
          from view_address_mast a
         where slno = v.delivery_from_slno
           and acc_code = v.acc_code) GST_From_state_code,
       (select a.gst_state_code
          from view_address_mast a
         where slno = v.delivery_to_slno
           and acc_code = v.acc_code) GST_to_state_code,
       (select a.gstinno
          from view_address_mast a
         where slno = v.Consignee_Address_Slno
           and acc_code = v.CONSIGNEE_CODE) Consignee_GSTINNO,
       (select a.state_name
          from view_address_mast a
         where slno = v.Consignee_Address_Slno
           and acc_code = v.CONSIGNEE_CODE) Consignee_state,
       (select a.gst_state_code
          from view_address_mast a
         where slno = v.Consignee_Address_Slno
           and acc_code = v.CONSIGNEE_CODE) Consignee_state_code,

       ----GST UPDATION END---
       (select sum(nvl(ib.valissued, 0)) - sum(nvl(ib.valrecd, 0))
          from itemtran_issue_post ib
         where ib.entity_code = v.entity_code
           and ib.tcode = v.tcode
           and ib.vrno = v.vrno
           and ib.slno = v.slno) consumption_val,

       decode(item_nature,
              'SM',
              (select t.attr_value
                 from item_attr_mast t
                where t.attr_head = 'LEN'
                  and t.item_code = v.item_code
                  and rownum = 1)) item_length,
       decode(item_nature,
              'SM',
              (select t.attr_value
                 from item_attr_mast t
                where t.attr_head = 'DIA'
                  and t.item_code = v.item_code
                  and rownum = 1)) item_dia,

       (select h.vrdate
          from itemtran_head h
         where h.entity_code = v.entity_code
           and h.tcode = v.ref1_tcode
           and h.vrno = v.ref1_vrno) req_date,

       (select sum(nvl(p.partybillamt, 0))
          from itemtran_head p, itemtran_body q
         where p.entity_code = q.entity_code
           and p.tcode = q.tcode
           and p.vrno = q.vrno
           and q.entity_code = v.entity_code
           and q.order_tcode = v.order_tcode
           and q.order_vrno = v.order_vrno
           and q.order_amendno = v.order_amendno) tot_bill_amt,

       decode((select count(*)
                from pay_advice_body m
               where m.entity_code = v.entity_code
                 and m.ref_tcode = v.tcode
                 and m.ref_vrno = v.vrno),
              0,
              'NO',
              'YES') pay_done_agt_bill,
       decode((select count(*)
                from pay_advice_body m
               where m.entity_code = v.entity_code
                 and m.ref_tcode = v.tcode
                 and m.ref_vrno = v.vrno),
              0,
              'OPEN',
              'CLOSED') pay_pending_agt_bill,
          AC.SGST_TDS_AMT,
          AC.CGST_TDS_AMT,
          AC.IGST_TDS_AMT

  from view_itemtran v,
       view_item_mast m,
       cost_mast c,
       (select oh.entity_code,
               oh.tcode,
               oh.vrno,
               oh.amendno,
               oh.emp_code,
               oh.vrdate,
               oh.amenddate,
               OH.PAYMENT_MODE,
               OH.PAYMENT_DUE_BASIS,
               OH.PAYMENT_DUEDAYS,
               ob.slno,
               ob.qtyorder,
               ob.qtycancelled,
               ob.qtypermit,
               ob.rate,
               ob.contract_tcode,
               ob.contract_vrno,
               ob.contract_amendno,
               ob.contract_slno,
               ob.QUOTATION_TCODE,
               ob.QUOTATION_VRNO,
               ob.QUOTATION_SLNO,
               ob.QUOTATION_AMENDNO
          from order_head oh, order_body ob
         where oh.entity_code = ob.entity_code
           and oh.tcode = ob.tcode
           and oh.vrno = ob.vrno
           and oh.amendno = ob.amendno) oh,
       (select ih.entity_code,
               ih.tcode,
               ih.vrno,
               ih.vrdate,
               ib.slno,
               ib.aqtyindent,
               qtyindent
          from indent_head ih, indent_body ib
         where ih.entity_code = ib.entity_code
           and ih.tcode = ib.tcode
           and ih.vrno = ib.vrno) ih,

          (SELECT AT1.ENTITY_CODE, AT1.TCODE, AT1.VRNO, SUM(CASE WHEN C.AFCODE ='SGST' THEN AT1.CRAMT END) SGST_TDS_AMT,
                SUM(CASE WHEN C.AFCODE ='CGST' THEN AT1.CRAMT END) CGST_TDS_AMT,
                SUM(CASE WHEN C.AFCODE ='IGST' THEN AT1.CRAMT END) IGST_TDS_AMT

                FROM
                ACC_TRAN AT1 , EXCISE_CONFIG_MAST C
                WHERE AT1.ENTITY_CODE = C.ENTITY_CODE
                AND   AT1.ACC_CODE    = C.REVACC_CODE
                AND   SUBSTR(AT1.VRNO, 3, 2)  = SUBSTR(C.ACC_YEAR,4,4)
                AND   C.MODVAT_FLAG ='E'
                AND   NVL(AT1.CRAMT,0)>0
                AND   AT1.TCODE = 'P'
                GROUP  BY  AT1.ENTITY_CODE, AT1.TCODE, AT1.VRNO) AC,


       gatetran_head gh,
       wb_head wh,
       view_acc_mast am
 where v.item_code = m.item_code(+)
   and v.entity_code = oh.entity_code(+)
   and v.order_tcode = oh.tcode(+)
   and v.order_vrno = oh.vrno(+)
   and v.order_amendno = oh.amendno(+)
   and v.order_slno = oh.slno(+)

   and v.entity_code = gh.entity_code(+)
   and v.gate_vrno = gh.vrno(+)

   and v.entity_code = wh.entity_code(+)
   and v.wslipno = wh.wslipno(+)

   and v.entity_code = ih.entity_code(+)
   and v.indent_tcode = ih.tcode(+)
   and v.indent_vrno = ih.vrno(+)
   and v.indent_slno = ih.slno(+)

   and v.acc_code = am.acc_code(+)
   and v.cost_code = c.cost_code(+)

   AND V.entity_code =AC.ENTITY_CODE(+)
   AND V.ACC_tcode = AC.TCODE(+)
   AND V.acc_vrno  = AC.VRNO (+)

