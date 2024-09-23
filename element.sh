#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type
                FROM elements
                JOIN properties ON elements.atomic_number = properties.atomic_number
                JOIN types ON properties.type_id = types.type_id
                WHERE elements.atomic_number = '$1'
                   OR elements.symbol = '$1'
                   OR elements.name = '$1'")

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
fi