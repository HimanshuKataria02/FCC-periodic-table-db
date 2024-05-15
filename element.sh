PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
SYMBOL=$1

if [[ -z $SYMBOL ]]
then 
  echo "Please provide an element as an argument."
else
  if [[ ! $SYMBOL =~ ^[0-9]+$ ]]; then 
    LENGTH=$(echo -n $SYMBOL | wc -m)
    if [[ $LENGTH -gt 2 ]]; then
      DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE name = '$SYMBOL'") 
      if [[ -z $DATA ]]; then
        echo "I could not find that element in the database."
      else
        while IFS='|' read -r BAR NUMBER SYMBOL NAME WEIGHT MELTING BOILING TYPE;
        do 
          echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        done <<< "$DATA"
      fi
    else
      DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE symbol = '$SYMBOL'")
      if [[ -z $DATA ]]; then
        echo "I could not find that element in the database."
      else
        while IFS='|' read -r BAR NUMBER SYMBOL NAME WEIGHT MELTING BOILING TYPE;
        do 
          echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        done <<< "$DATA"
      fi
    fi
  else
    DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number = '$SYMBOL'")
    if [[ -z $DATA ]]; then
      echo "I could not find that element in the database."
    else
      while IFS='|' read -r BAR NUMBER SYMBOL NAME WEIGHT MELTING BOILING TYPE;
          do 
            echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
          done <<< "$DATA"
    fi
  fi
fi
