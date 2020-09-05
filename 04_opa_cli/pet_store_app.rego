 # Attribute-based Access Control (ABAC)
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

#        ⬆︎
# rules with the same name e.g. `allow` express a logical OR operation
#        ⬇︎

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

# Multi logical statements inside a rule body express a logical AND operation
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
  msg := { "id"  : "5", "message" : "pet not a adopted" }
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
}