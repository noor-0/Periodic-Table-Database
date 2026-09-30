#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

RESULT=$($PSQL "
SELECT
  elements.atomic_number,
  elements.name,
  elements.symbol,
  types.type,
  properties.atomic_mass,
  properties.melting_point_celsius,
  properties.boiling_point_celsius
FROM elements
JOIN properties USING(atomic_number)
JOIN types USING(type_id)
WHERE elements.atomic_number::TEXT = '$1'
   OR elements.symbol = '$1'
   OR elements.name = '$1'
")

if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
  exit
fi

IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT <<< "$RESULT"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
