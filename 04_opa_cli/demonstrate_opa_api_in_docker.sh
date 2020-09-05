#!/bin/bash

printf "\n\n    This script starts an OPA Server via docker compose and demonstrates using the API interface to execute policies.\n"
printf "\n\n**************    Starting opa via docker-compose   **************\n\n"
printf "    ----> docker-compose -f ./docker-compose_pet_shop.yml up -d "
read -n 1 -r -s -p $'\nPress enter to continue...\n'

docker-compose -f ./docker-compose_pet_shop.yml up -d 

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to check to make sure everything is started    **************\n\n"
printf "    ----> docker ps -a"
read -n 1 -r -s -p $'\nPress enter to continue...\n'
docker ps -a

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to show OPA's data    **************\n\n"
printf "    ----> curl --location --request GET 'http://localhost:8181/v1/data?pretty=true'"
read -n 1 -r -s -p $'\nPress enter to continue...\n'

curl --location --request GET 'http://localhost:8181/v1/data?pretty=true'

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to show OPA's Policies    **************\n\n"
printf "    ----> curl --location --request GET 'http://localhost:8181/v1/policies?pretty=true''"
read -n 1 -r -s -p $'\nPress enter to continue...\n'

curl --location --request GET 'http://localhost:8181/v1/policies?pretty=true'


read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to load user and pet reference data into OPA    **************\n\n"
printf "    ----> curl --location --request PUT 'http://localhost:8181/v1/data/reference?pretty=true'"
read -n 1 -r -s -p $'\nPress enter to continue...\n'

curl --location --request PUT 'http://localhost:8181/v1/data/reference?pretty=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data-raw '{
    "user_attributes": {
        "alice": {
            "tenure": 21,
            "title": "owner"
        },
        "bob": {
            "tenure": 15,
            "title": "employee"
        },
        "eve": {
            "tenure": 5,
            "title": "employee"
        },
        "dave": {
            "tenure": 5,
            "title": "customer"
        }
    },
    "pet_attributes": {
        "dog123": {
            "adopted": true,
            "age": 2,
            "breed": "terrier",
            "name": "toto"
        },
        "dog456": {
            "adopted": false,
            "age": 3,
            "breed": "german-shepherd",
            "name": "rintintin"
        },
        "dog789": {
            "adopted": false,
            "age": 2,
            "breed": "collie",
            "name": "lassie"
        },
        "cat123": {
            "adopted": false,
            "age": 1,
            "breed": "fictitious",
            "name": "cheshire"
        }
    }
}
'
printf "    ...Reference data loaded"

read -n 1 -r -s -p $'\nPress enter to continue...\n'
printf "\n\n**************    When we GET OPA Data again, there should be plenty there    **************\n\n"
printf "    ----> curl --location --request GET 'http://localhost:8181/v1/data?pretty=true'"
read -n 1 -r -s -p $'\nPress enter to continue...\n'

curl --location --request GET 'http://localhost:8181/v1/data?pretty=true'


read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to create an ABAC policy for the Pet Shop Application    **************\n\n"
printf "    ----> curl --location --request PUT 'http://localhost:8181/v1/policies/app/abac?pretty=true'"
read -n 1 -r -s -p $'\nPress enter to continue...\n'

curl --location --request PUT 'http://localhost:8181/v1/policies/app/abac?pretty=true' \
--header 'Content-Type: text/plain' \
--data-raw '# Attribute-based Access Control (ABAC)
# -------------------------------------
#
# This example implements ABAC for a Pet Store API. The Pet Store API allows
# users to look at pets, adopt them, update their stats, and so on. The policy
# controls which users can perform actions on which resources. The policy implements
# a Attribute-based Access Control model where users, resources, and actions have
# attributes and the policy makes decisions based on those attributes.
#
# This example shows how to:
#
#	* Implement ABAC using Rego that leverages external data.
#	* Define helper rules that provide useful abstractions (e.g., `user_is_senior`).
#
# For more information see:
#
#	* Rego comparison to other systems: https://www.openpolicyagent.org/docs/latest/comparison-to-other-systems/
#
# Hint: The Coverage feature lets you view the policy statements that were executed
# when the policy was last evaluated. Try enabling Coverage and running evaluation
# with different inputs.

package app.abac

#default allow = {
#    "allowed": false
#}


allow = response {
	user_is_owner
    response := {
        "allowed": true,
        "allowReason" : "user_is_owner"
    }
}

allow = response {
    user_is_employee_and_action_is_read
    response := {
        "allowed": true,
        "allowReason" : "user_is_employee and action_is_read"
    }
}

allow = response {
    user_is_employee_and_senior_and_action_is_update
    response := {
        "allowed": true,
        "allowReason" : "user_is_employee and senior and action_is_update"
    }
}

allow  = response {
    user_is_customer_and_action_is_read_and_pet_is_not_adopted
    response := {
        "allowed": true,
        "allowReason" : "user_is_customer and action_is_read and pet_is_not_adopted"
    }
}

allow = response {
    not user_is_owner
    not user_is_employee_and_action_is_read
    not user_is_employee_and_senior_and_action_is_update
    not user_is_customer_and_action_is_read_and_pet_is_not_adopted
    response := {
        "allowed": false,
        "messages" : messages
    }
}

user_is_owner {
	data.reference.user_attributes[input.user].title == "owner"
}

user_is_employee {
	data.reference.user_attributes[input.user].title == "employee"
}

user_is_customer {
	data.reference.user_attributes[input.user].title == "customer"
}

user_is_senior {
	data.reference.user_attributes[input.user].tenure > 8
}

action_is_read {
	input.action == "read"
}

action_is_update {
	input.action == "update"
}

pet_is_adopted {
	data.pet_attributes[input.resource].adopted == true
}

user_is_employee_and_action_is_read  {
	user_is_employee
	action_is_read
}

user_is_employee_and_senior_and_action_is_update  {
	user_is_employee
	user_is_senior
	action_is_update
}

user_is_customer_and_action_is_read_and_pet_is_not_adopted  {
	user_is_customer
	action_is_read
	not pet_is_adopted
}

messages[ msg ]{
  not user_is_owner
  msg := { "id"  : "1", "message" : "condition not met: user not an owner" }
}

messages[ msg ]{
  not user_is_employee
  msg := { "id"  : "2", "message" : "user not an employee" }
}

messages[ msg ]{
  not user_is_customer
  msg := { "id"  : "3", "message" : "user not a customer" }
}

messages[ msg ]{
  not user_is_senior
  msg := { "id"  : "4", "message" : "user not a senior" }
}

messages[ msg ]{
  not pet_is_adopted
  msg := { "id"  : "5", "message" : "pet is not adopted" }
}

messages[ msg ]{
  not user_is_employee_and_action_is_read
  msg := { "id"  : "6", "message" : "condition not met: user is employee and action is read" }
}

messages[ msg ]{
  not user_is_employee_and_senior_and_action_is_update
  msg := { "id"  : "7", "message" : "condition not met: user is employee and senior and action is update" }
}

messages[ msg ]{
  not user_is_customer_and_action_is_read_and_pet_is_not_adopted
  msg := { "id"  : "8", "message" : "condition not met: user is customer and action is read and pet is not adopted" }
}'
printf "    ...Pet Shop App ABAC Policy loaded\n"

read -n 1 -r -s -p $'\nPress enter to continue...\n'
printf "\n\n**************    This time when we show OPA's policies, there should be one there    **************\n\n"
printf "    ----> curl --location --request GET 'http://localhost:8181/v1/policies?pretty=true''"
read -n 1 -r -s -p $'\nPress enter to continue...\n'

curl --location --request GET 'http://localhost:8181/v1/policies?pretty=true'


read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    Bob, an employee, would like to read some data about a pet    **************\n\n"
printf "    ----> curl --location --request POST 'http://localhost:8181/v1/data/app/abac/allow?pretty=true' "
read -n 1 -r -s -p $'\nPress enter to continue...\n'

curl --location --request POST 'http://localhost:8181/v1/data/app/abac/allow?pretty=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data-raw '{
  "input": {
    "user": "bob",
    "action": "read",
    "resource": "dog123"
  }
}'


read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    Alice, the owner, would like to read some data about a pet    **************\n\n"
printf "    ----> curl --location --request POST 'http://localhost:8181/v1/data/app/abac/allow?pretty=true' "
read -n 1 -r -s -p $'\nPress enter to continue...\n'

curl --location --request POST 'http://localhost:8181/v1/data/app/abac/allow?pretty=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data-raw '{
  "input": {
    "user": "alice",
    "action": "read",
    "resource": "dog123"
  }
}'


read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    Dave, a customer, would like to read some data about a pet that is up for adoption    **************\n\n"
printf "    ----> curl --location --request POST 'http://localhost:8181/v1/data/app/abac/allow?pretty=true' "
read -n 1 -r -s -p $'\nPress enter to continue...\n'

curl --location --request POST 'http://localhost:8181/v1/data/app/abac/allow?pretty=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data-raw '{
  "input": {
    "user": "dave",
    "action": "read",
    "resource": "dog123"
  }
}'

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    A un-registered user would like to read some data about a pet that is up for adoption    **************\n\n"
printf "    This time we have turned on some troubleshooting options.\n*   provenance - to tell use what version of the OPA we are using\n*   explain - to show us the rule execution flow\n*   metrics - to show how much time the rules take\n\n"
printf "    ----> curl --location --request POST 'http://localhost:8181/v1/data/app/abac/allow?provenance=true&pretty=true&explain=full&metrics=true&instrument=true' "
read -n 1 -r -s -p $'\nPress enter to continue...\n'

curl --location --request POST 'http://localhost:8181/v1/data/app/abac/allow?provenance=true&pretty=true&explain=full&metrics=true&instrument=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data-raw '{
  "input": {
    "user": "un-registered user",
    "action": "read",
    "resource": "dog123"
  }
}'

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to delete the Pet Shop App's Reference Data    **************\n\n"
printf "    You can also delete things that you load into OPA. This API deletes our reference data.\n\n"
printf "    ----> curl --location --request DELETE 'http://localhost:8181/v1/data/reference?pretty=true' "
read -n 1 -r -s -p $'\nPress enter to continue...\n'


curl --location --request DELETE 'http://localhost:8181/v1/data/reference?pretty=true' \
--header 'Accept: application/json' \
--data-raw ''


printf "    ...Reference data deleted "
read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    OPA's reference data tree should now be gone    **************\n\n"
printf "    **************    Make note that you can still see the policy     **************\n"
printf "    **************    tree as part of the data document.              **************\n\n"
printf "    ----> curl --location --request GET 'http://localhost:8181/v1/data?pretty=true'"
read -n 1 -r -s -p $'\nPress enter to continue...\n'

curl --location --request GET 'http://localhost:8181/v1/data?pretty=true'


read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to delete the Pet Shop App's ABAC Policy    **************\n\n"
printf "    ----> curl --location --request DELETE 'http://localhost:8181/v1/policies/app/abac' "
read -n 1 -r -s -p $'\nPress enter to continue...\n'

curl --location --request DELETE 'http://localhost:8181/v1/policies/app/abac'

printf "    ...Pet Shop App's ABAC policy deleted "
read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to show OPA's Policies    **************\n\n"
printf "    ----> curl --location --request GET 'http://localhost:8181/v1/policies?pretty=true' "
read -n 1 -r -s -p $'\nPress enter to continue...\n'

curl --location --request GET 'http://localhost:8181/v1/policies?pretty=true'


read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to clean up and remove docker instances    **************\n\n"
printf "    ----> docker-compose down"
read -n 1 -r -s -p $'\nPress enter to continue...\n'

docker-compose -f ./docker-compose_pet_shop.yml down
