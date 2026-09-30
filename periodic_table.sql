DELETE FROM properties WHERE atomic_number = 1000;
DELETE FROM elements WHERE atomic_number = 1000;

ALTER TABLE properties
RENAME COLUMN weight TO atomic_mass;

ALTER TABLE properties
RENAME COLUMN melting_point TO melting_point_celsius;

ALTER TABLE properties
RENAME COLUMN boiling_point TO boiling_point_celsius;

ALTER TABLE elements
ALTER COLUMN symbol SET NOT NULL;

ALTER TABLE elements
ALTER COLUMN name SET NOT NULL;

ALTER TABLE properties
ALTER COLUMN melting_point_celsius SET NOT NULL;

ALTER TABLE properties
ALTER COLUMN boiling_point_celsius SET NOT NULL;

ALTER TABLE elements
ADD UNIQUE(symbol);

ALTER TABLE elements
ADD UNIQUE(name);

CREATE TABLE types (
  type_id SERIAL PRIMARY KEY,
  type VARCHAR(30) NOT NULL
);

INSERT INTO types(type)
VALUES ('metal'), ('metalloid'), ('nonmetal');

ALTER TABLE properties
ADD COLUMN type_id INT NOT NULL DEFAULT 1;

UPDATE properties
SET type_id = (
  SELECT type_id
  FROM types
  WHERE types.type = properties.type
);

ALTER TABLE properties
ADD FOREIGN KEY (type_id) REFERENCES types(type_id);

ALTER TABLE properties
DROP COLUMN type;

UPDATE elements
SET symbol = INITCAP(symbol);

ALTER TABLE properties
ALTER COLUMN atomic_mass TYPE DECIMAL
USING atomic_mass::DECIMAL;

UPDATE properties SET atomic_mass = 1.008 WHERE atomic_number = 1;
UPDATE properties SET atomic_mass = 4.003 WHERE atomic_number = 2;
UPDATE properties SET atomic_mass = 6.94 WHERE atomic_number = 3;
UPDATE properties SET atomic_mass = 9.012 WHERE atomic_number = 4;
UPDATE properties SET atomic_mass = 10.81 WHERE atomic_number = 5;
UPDATE properties SET atomic_mass = 12.011 WHERE atomic_number = 6;
UPDATE properties SET atomic_mass = 14.007 WHERE atomic_number = 7;
UPDATE properties SET atomic_mass = 15.999 WHERE atomic_number = 8;

INSERT INTO elements(atomic_number, symbol, name)
VALUES (9, 'F', 'Fluorine');

INSERT INTO properties(
  atomic_number,
  atomic_mass,
  melting_point_celsius,
  boiling_point_celsius,
  type_id
)
VALUES (9, 18.998, -220, -188.1, 3);

INSERT INTO elements(atomic_number, symbol, name)
VALUES (10, 'Ne', 'Neon');

INSERT INTO properties(
  atomic_number,
  atomic_mass,
  melting_point_celsius,
  boiling_point_celsius,
  type_id
)
VALUES (10, 20.18, -248.6, -246.1, 3);

ALTER TABLE properties
ALTER COLUMN type_id DROP DEFAULT;

ALTER TABLE properties
ADD FOREIGN KEY (atomic_number)
REFERENCES elements(atomic_number);
