CREATE OR REPLACE FUNCTION normalize_text(txt TEXT)
RETURNS TEXT AS $$
BEGIN
    IF txt NULL THEN
        RETURN 'UNKNOWN'; -- if txt param is NULL, return unknown
    END IF;

    RETURN UPPER(TRIM(txt)); -- any ither case return caps without spaces
END;
$$ LANGUAGE plpgsql;
