#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

QUERY="SELECT e.atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, types.type
       FROM public.elements e
       JOIN public.properties ON e.atomic_number = properties.atomic_number
       JOIN public.types ON properties.type_id = types.type_id"

# Check if input is an integer (atomic number) or a string (symbol or name)
if [[ $1 =~ ^[0-9]+$ ]]
then
  WHERE_CONDITION="WHERE e.atomic_number = $1"
else
  WHERE_CONDITION="WHERE e.symbol = '$1' OR e.name = '$1'"
fi

ELEMENT=$($PSQL "$QUERY $WHERE_CONDITION")

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
else
  IFS="|" read ATOMIC_NUMBER NAME SYMBOL MASS MELT_POINT BOIL_POINT TYPE <<< "$ELEMENT"
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
fi