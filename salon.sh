#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Welcome to Shebang Salon ~~~~~\n"

SERVICE_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "Here is the list of services:\n"
  SERVICE_LIST=$($PSQL "select * from services")
  echo "$SERVICE_LIST" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  echo -e "\nWhich service do you want today?"
  read SERVICE_ID_SELECTED
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    SERVICE_MENU "Please choose a valid option."
  else
    SERVICE_NAME=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED")
    if [[ -z $SERVICE_NAME ]]
    then
      SERVICE_MENU "We don't have this service, please choose again."
    else
      echo -e "\nWhat's your phone number?"
      read CUSTOMER_PHONE
      CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'")
      if [[ -z $CUSTOMER_NAME ]]
      then
        echo -e "\nWe don't have your name in the record, what's your name?"
        read CUSTOMER_NAME
        INSERT_CUSTOMER=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
      fi
      echo -e "\nWhat time would you like your $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"
      read SERVICE_TIME
      CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$PHONE_NUMBER'")
      INSERT_APPOINTMENT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
      echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
    fi
  fi
}

SERVICE_MENU
