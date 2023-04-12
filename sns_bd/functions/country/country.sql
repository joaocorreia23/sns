CREATE OR REPLACE FUNCTION get_countries(
    IN id_country BIGINT DEFAULT NULL
) RETURNS SETOF country AS $$
BEGIN
    IF id_country IS NULL THEN
        RETURN QUERY SELECT * FROM country;
    ELSE 
        RETURN QUERY SELECT * FROM country WHERE country.id_country = get_countries.id_country;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'O País com o Código: <%> não existe!', id_country;
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;