CREATE OR REPLACE FUNCTION trg_products_auto_unavailable()
RETURNS trigger AS $$
BEGIN
    IF NEW.quantity_in_stock = 0 THEN
        NEW.is_available := FALSE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER products_auto_unavailable
BEFORE INSERT OR UPDATE ON products
FOR EACH ROW EXECUTE FUNCTION trg_products_auto_unavailable();

UPDATE products SET is_available = FALSE
WHERE quantity_in_stock = 0 AND is_available;