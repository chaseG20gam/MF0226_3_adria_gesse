CREATE OR REPLACE FUNCTION fibonacci (n INT)
RETURNS BIGINT AS $$
DECLARE
    a BIGINT := 0; -- first value
    b BIGINT := 1; -- second value
    temp BIGINT -- aux value for the iteration loop
    i INT;
BEGIN
    IF n < 0 THEN -- quick validation to avoid negative numbers
        RAISE EXCEPTION 'value cannot be negative: %', n;
    END IF;

    IF n = 0 THEN   
        RETURN 0;
    ELSIF n = 1 THEN
        RETURN 1;
    END IF;

    FOR i IN 2..n LOOP
        temp := a + b; -- value
        a := b; -- put b where a
        b := temp; -- assign the value to b
    END LOOP;

    RETURN b;
END;
$$ LANGUAGE plpgsql;


-- use: SELECT fibbonacci(0)
-- references: StackOverflow, PostgresGuide.com, reddit