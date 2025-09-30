-- reference table:
CREATE TABLE empleados (
    id_empleado SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    salario NUMERIC(10, 2) NOT NULL
);

-- create the function

CREATE OR REPLACE FUNCTION validate_salary()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.salario < 1000 THEN -- verify if salary is valid
        RAISE EXCEPTION 'invalid salary: %', NEW.salario;
    END IF;
    RETURN NEW; -- if everything correct, then proceed
END;
$$ LANGUAGE plpgsql;

-- create the trigger in the eployees table

CREATE TRIGGER trg_validate_salary
BEFORE INSERT OR UPDATE ON empleados
FOR EACH ROW
EXECUTE FUNCTION validate_salary();