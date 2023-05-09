--Create Address
CREATE OR REPLACE FUNCTION create_address(
    door_number VARCHAR(255) DEFAULT NULL,
    floor VARCHAR(255) DEFAULT NULL,
    address_name VARCHAR(255) DEFAULT NULL,
    zip_code VARCHAR(255) DEFAULT NULL,
    county VARCHAR(255) DEFAULT NULL,
    district VARCHAR(255) DEFAULT NULL,
    id_country BIGINT DEFAULT NULL
)
RETURNS BIGINT AS $$
DECLARE
    out_id_address BIGINT;
    out_id_district BIGINT;
    out_id_county BIGINT;
    out_id_zip_code BIGINT;
BEGIN

    IF id_country IS NULL THEN  
        RAISE EXCEPTION 'O id do país não pode ser nulo';
    END IF;

    --Check if district exists
    IF NOT EXISTS (SELECT id_district FROM district WHERE district.district_name = create_address.district AND district.id_country = create_address.id_country) THEN
        --DISTRICT NOT FOUND
        IF district IS NULL OR district = '' THEN
            RAISE EXCEPTION 'O distrito não pode ser nulo';
        ELSE
            INSERT INTO district (district_name, id_country) VALUES (create_address.district, create_address.id_country) RETURNING id_district INTO out_id_district;
        END IF;   
    ELSE
        SELECT id_district INTO out_id_district FROM district WHERE district.district_name = create_address.district AND district.id_country = create_address.id_country;
    END IF;

    --Check if county exists
    IF NOT EXISTS (SELECT id_county FROM county WHERE county.county_name = create_address.county AND county.id_district = out_id_district) THEN
       --COUNTY NOT FOUND
       IF county IS NULL OR county = '' THEN
            RAISE EXCEPTION 'O concelho não pode ser nulo';
        ELSE
            INSERT INTO county (county_name, id_district) VALUES (create_address.county, out_id_district) RETURNING id_county INTO out_id_county;
        END IF;
    ELSE
        SELECT id_county INTO out_id_county FROM county WHERE county.county_name = create_address.county AND county.id_district = out_id_district;
    END IF;

    --Check if Zip Code exists
    IF NOT EXISTS (SELECT id_zip_code FROM zip_code WHERE zip_code.zip_code = create_address.zip_code AND zip_code.id_county = out_id_county AND zip_code.address=create_address.address_name) THEN
        --ZIP CODE NOT FOUND
        IF zip_code IS NULL OR zip_code = '' THEN
            RAISE EXCEPTION 'O código postal não pode ser nulo';
        ELSEIF address_name IS NULL OR address_name = '' THEN
            RAISE EXCEPTION 'O endereço não pode ser nulo';
        ELSE
            INSERT INTO zip_code (zip_code, address, id_county) VALUES (create_address.zip_code, create_address.address_name, out_id_county) RETURNING id_zip_code INTO out_id_zip_code;
        END IF;
    ELSE
        SELECT id_zip_code INTO out_id_zip_code FROM zip_code WHERE zip_code.zip_code = create_address.zip_code AND zip_code.id_county = out_id_county;
    END IF;
    
    --Check if address exists
    IF NOT EXISTS (SELECT id_address FROM address WHERE address.door_number = create_address.door_number AND address.floor = create_address.floor AND address.id_zip_code = out_id_zip_code) THEN
        --ADDRESS NOT FOUND
        IF door_number IS NULL THEN
            RAISE EXCEPTION 'O número da porta não pode ser nulo';
        ELSE
            INSERT INTO address (door_number, floor, id_zip_code) VALUES (create_address.door_number, create_address.floor, out_id_zip_code) RETURNING id_address INTO out_id_address;
        END IF;
    ELSE
        SELECT id_address INTO out_id_address FROM address WHERE address.door_number = create_address.door_number AND address.floor = create_address.floor AND address.id_zip_code = out_id_zip_code;
    END IF;

    RETURN out_id_address;
END;
$$ LANGUAGE plpgsql;
--
--
--
