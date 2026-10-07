#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $# -eq 0 ]]; then
  printf '%s\n' 'Please provide an element as an argument.'
  exit 0
fi

if [[ $# -ne 1 || ! $1 =~ ^[[:alnum:]]+$ ]]; then
  printf '%s\n' 'I could not find that element in the database.'
  exit 0
fi

result=$($PSQL "SELECT e.atomic_number || '|' || e.name || '|' || e.symbol || '|' || t.type || '|' || p.atomic_mass || '|' || p.melting_point_celsius || '|' || p.boiling_point_celsius FROM elements e JOIN properties p USING (atomic_number) JOIN types t USING (type_id) WHERE e.atomic_number::text = '$1' OR LOWER(e.symbol) = LOWER('$1') OR LOWER(e.name) = LOWER('$1');")

if [[ -z $result ]]; then
  printf '%s\n' 'I could not find that element in the database.'
  exit 0
fi

IFS='|' read -r atomic_number name symbol type atomic_mass melting_point boiling_point <<< "$result"
printf "The element with atomic number %s is %s (%s). It's a %s, with a mass of %s amu. %s has a melting point of %s celsius and a boiling point of %s celsius.\n" \
  "$atomic_number" "$name" "$symbol" "$type" "$atomic_mass" "$name" "$melting_point" "$boiling_point"
