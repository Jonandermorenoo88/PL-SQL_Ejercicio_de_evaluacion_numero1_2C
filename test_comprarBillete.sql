create or replace procedure test_comprarBillete is
  v_numPlazasLibres viajes.nPlazasLibres%TYPE;
begin
      -- 1. Comprar un billete para un viaje inexistente
    begin
        comprarBillete(TIMESTAMP '0001-01-01 12:00:00', DATE '2010-04-15', 'Burgos', 'Madrid', 3);
        DBMS_OUTPUT.PUT_LINE('Mal no detecta NO_EXISTE_VIAJE.');
    EXCEPTION
        when OTHERS then
            if SQLCODE = -20002 then
                DBMS_OUTPUT.PUT_LINE('Detecta OK NO_EXISTE_VIAJE: ' || SQLERRM);
            else
                DBMS_OUTPUT.PUT_LINE('Mal no detecta NO_EXISTE_VIAJE: ' || SQLERRM);
            end if;
    end;
      
    -- 2. Verificar si el viaje con fecha '2009-01-22' y hora '08:30:00' existe
    begin
        select v.nPlazasLibres
        into v_numPlazasLibres
        from viajes v
        join recorridos r on v.idRecorrido = r.idRecorrido
        where r.estacionOrigen = 'Burgos'
          and r.estacionDestino = 'Madrid'
          and TO_CHAR(r.horaSalida, 'HH24:MI:SS') = '08:30:00'
          and v.fecha = DATE '2009-01-22';

        comprarBillete(TO_TIMESTAMP('0001-01-01 08:30:00', 'YYYY-MM-DD HH24:MI:SS.FF'), DATE '2009-01-22', 'Burgos', 'Madrid', 50);
        DBMS_OUTPUT.PUT_LINE('Mal no detecta NO_PLAZAS.');
    EXCEPTION
        when OTHERS then
            if SQLCODE = -20001 then
                DBMS_OUTPUT.PUT_LINE('Detecta OK NO_PLAZAS: ' || SQLERRM);
            else
                if SQLCODE = -20002 then
                    DBMS_OUTPUT.PUT_LINE('Mal no detecta NO_PLAZAS, pero detecta NO_EXISTE_VIAJE en lugar de NO_PLAZAS: ' || SQLERRM);
                else
                    DBMS_OUTPUT.PUT_LINE('Mal no detecta NO_PLAZAS: ' || SQLERRM);
                end if;
            end if;
    end;
      
      -- 3. Hacemos una compra de un billete de 5 plazas sin problemas
      declare
        varContenidoReal varchar(100);
        varContenidoEsperado    varchar(100):=  '11122/01/0925113550';
    begin
        comprarBillete(TO_TIMESTAMP('0001-01-01 08:30:00', 'YYYY-MM-DD HH24:MI:SS.FF'), DATE '2009-01-22', 'Burgos', 'Madrid', 5);
        
        select v.idViaje || v.idAutocar || v.idRecorrido || TO_CHAR(v.fecha, 'DD/MM/YY') || v.nPlazasLibres || v.realizado || v.idConductor || t.idTicket || t.cantidad || t.precio
        into varContenidoReal
        from viajes v
        join tickets t ON v.idViaje = t.idViaje
        where t.idTicket = 3;
        
        if varContenidoReal = varContenidoEsperado then
            DBMS_OUTPUT.PUT_LINE('BIEN: si modifica bien la BD.');
        else
            DBMS_OUTPUT.PUT_LINE('Mal: no modifica bien la BD. Real: ' || varContenidoReal || ' Esperado: ' || varContenidoEsperado);
        end if;
    EXCEPTION
        when OTHERS then
            DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
    end;
end test_comprarBillete;