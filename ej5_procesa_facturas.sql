
Tabla de facturas (referencia para este ejercicio):
CREATE TABLE facturas (
    id_factura SERIAL PRIMARY KEY,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario NUMERIC(10,2) NOT NULL
);

Tabla de errores de facturación:
CREATE TABLE errores_log (
    id_error SERIAL PRIMARY KEY,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    mensaje TEXT,
    id_factura INT
);

CREATE OR REPLACE FUNCTION procesa_facturas()
RETURNS NUMERIC(20,2) AS $$
DECLARE
    -- var that runs each roe in facturas
    rec RECORD;

    -- var for count
    total NUMERIC(20,2) := 0;

    -- temp var to store facuras values
    importe NUMERIC(20,2);
BEGIN
    -- loop over all facturas
    FOR rec IN SELECT * FROM facturas LOOP
        BEGIN
            -- validation rules
            IF rec.precio_unitario = 0 THEN
                RAISE EXCEPTION 'Factura % inválida: precio_unitario = 0', rec.id_factura;
            ELSIF rec.cantidad < 0 THEN
                RAISE EXCEPTION 'Factura % inválida: cantidad < 0', rec.id_factura;
            END IF;

            -- if valid, calcule
            importe := rec.cantidad * rec.precio_unitario;

            -- count
            total := total + importe;

        EXCEPTION
            WHEN OTHERS THEN
                -- error log
                INSERT INTO errores_log (mensaje, id_factura)
                VALUES (SQLERRM, rec.id_factura);
                -- not using RAISE so the function does not abort
        END;
    END LOOP;

    -- retunr the count
    RETURN total;
END;

$$ LANGUAGE plpgsql;