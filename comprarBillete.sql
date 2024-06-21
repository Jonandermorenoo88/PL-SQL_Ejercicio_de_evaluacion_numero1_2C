create or replace procedure comprarBillete( 
    arg_hora recorridos.horaSalida%type,
    arg_fecha viajes.fecha%type, 
    arg_origen recorridos.estacionorigen%type,
    arg_destino recorridos.estaciondestino%type, 
    arg_nroPlazas viajes.nplazaslibres%type
) is 
    v_idViaje viajes.idViaje%type;
    v_precio recorridos.precio%type;
    v_numPlazasLibres viajes.nPlazasLibres%type;
    c_noViaje exception;
    c_noPlazas exception;
    pragma exception_init(c_noViaje, -20002);
    pragma exception_init(c_noPlazas, -20001);

begin
  begin
        select v.idViaje, r.precio, v.nPlazasLibres
        into v_idViaje, v_precio, v_numPlazasLibres
        from viajes v
        join recorridos r on v.idRecorrido = r.idRecorrido
        where r.estacionOrigen = arg_origen
          and r.estacionDestino = arg_destino
          and to_char(r.horaSalida, 'HH24:MI:SS') = to_char(arg_hora, 'HH24:MI:SS')
          and v.fecha = arg_fecha
        for update of v.nPlazasLibres;
    exception
        when no_data_found then
            RAISE c_noViaje;
    end;

     if v_numPlazasLibres < arg_nroPlazas then
        RAISE c_noPlazas;
    end if;

    update viajes
    set nPlazasLibres = nPlazasLibres - arg_nroPlazas
    where idViaje = v_idViaje;

    insert into tickets(idTicket, idViaje, fechaCompra, cantidad, precio)
    values (seq_tickets.nextval, v_idViaje, sysdate, arg_nroPlazas, arg_nroPlazas * v_precio);
    
exception
    when c_noViaje then
        raise_application_error(-20002, 'No existe ese viaje para esa fecha, hora, origen y destino.');
    when c_noPlazas then
        raise_application_error(-20001, 'Plazas insuficientes. Se solicitaron ' || arg_nroPlazas || ' y solo quedan ' || v_numPlazasLibres);
    when others then
        raise;

end comprarBillete;