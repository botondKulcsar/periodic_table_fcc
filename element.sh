#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

DISPLAY_INFO() {
   #if no element info found
  if [[ -z $1 ]]
    then
      echo "I could not find that element in the database."
  else
    #gather info about element
    echo $1 | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
  fi
}

FIND_BY_NAME() {
   #check if element exists by name
  ARGUMENT=$1
  ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name='$ARGUMENT'")
  DISPLAY_INFO "$ELEMENT_INFO"
}

FIND_BY_ATOMIC_NUMBER() {
  #check if element exists by atomic_number
  ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$1")
  DISPLAY_INFO "$ELEMENT_INFO"
}

FIND_BY_SYMBOL() {
   #check if element exists by symbol
  ARGUMENT=$1
  ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol='$ARGUMENT'")
  DISPLAY_INFO "$ELEMENT_INFO"
}

MAIN_MENU() {
  #if no arguments provided
  if [[ ! $1 ]]
    then
    echo "Please provide an element as an argument."

  else
    #check if argument is a number
    if [[ $1 =~ ^[0-9]+$ ]]
      then
      FIND_BY_ATOMIC_NUMBER $1
    else
      #check if argument is up to 2 chars long
      if [[ $1 =~ ^[a-zA-Z]{1,2}$ ]]
        then
        FIND_BY_SYMBOL $1
      else
        FIND_BY_NAME $1
      fi
    fi
  fi
}

MAIN_MENU $1
