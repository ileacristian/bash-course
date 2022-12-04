#!/bin/bash


echo "You are running the user creation script"

if [[ "${UID}" != 0 ]]
then
	echo "You are not the root user. Please run the script as a root user."
	exit 1
fi

read -p "Please enter a username for the new user: " USERNAME
read -p "Please enter the name of the new user: " NAME
read -p "Please enter a temporary password for the new user: " PASSWORD

useradd -m -c "${NAME}" "${USERNAME}"

echo "${PASSWORD}" | passwd --stdin "${USERNAME}"

passwd -e "${USERNAME}"
chage -d 0 "${USERNAME}"

if [[ "${?}" = 0 ]]
then
	echo "Successfully created new user with"
	echo "Username: ${USERNAME}"
	echo "For person: ${NAME}"
	echo "With temporary password ${PASSWORD}"
	echo "On hostname ${HOSTNAME}"
else
	echo "Failed to create user"
	userdel -r "${USERNAME}"
	exit 1
fi
