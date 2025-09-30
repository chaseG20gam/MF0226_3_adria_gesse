CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    precio NUMERIC (10, 2) NOT NULL,
    stock INT NOT NULL
);

CREATE TABLE productos_audit (
    id_audit SERIAL PRIMARY KEY,
    id_producto INT,
    campo_modificado TEXT,
    valor_anterior TEXT,
    valor_nuevo TEXT,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESSTAMP
);

CREATE OR REPLACE FUNCTION auditar_productos()
RETURNS TRIGGER AS $$
BEGIN

    -- i fprice changes
    IF NEW.precio <> OLD.precio AND NEW.stock = OLD.stock THEN
        INSERT INTO productos_audit (id_producto, campo_modificado, valor_anterior, valor_nuevo)
        VALUES (OLD.id_producto, 'precio', OLD.precio::TEXT, NEW.precio::TEXT);

    -- if stock changes
    ELSIF NEW.stock <> OLD.stock AND NEW.price = OLD.price THEN
        INSERT INTO productos_audit (id_producto, campo_modificado, valor_anterior, valor_nuevo)
        VALUES (OLD.id_producto, 'stock', OLD.stock::TEXT, NEW.stock::TEXT);
    
    -- if both changes
    ELSIF NEW.precio <> OLD.precio AND NEW.stock <> OLD.stock THEN
        -- insert two rows
        INSERT INTO productos_audit (id_producto, campo_modificado, valor_anterior, valor_nuevo)
        VALUES (OLD.id_producto, 'precio', OLD.precio::TEXT, NEW.precio::TEXT);

        INSERT INTO productos_audit (id_producto, campo_modificado, valor_anterior, valor_nuevo)
        VALUES (OLD.id_producto, 'stock', OLD.stock::TEXT, NEW.stock::TEXT);
    
    END IF;

    RETURN NEW;
END;

$$ LANGUAGE plpgsql;


CREATE TRIGGER IF NOT EXISTS trg_auditar_productos
AFTER UPDATE ON productos
FOR EACH ROW
EXECUTE FUNCTION auditar_productos();