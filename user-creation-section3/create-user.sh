#!/bin/bash

echo "You are running the user creation script"

if [[ "${UID}" != 0 ]]
then
    echo "You are not the root user. Please run the script as a root user."
    exit 1
fi

if [[ "${#} -gt 1" ]]
then
    USERNAME=${1}
    shift
    NAME=${@}
else
    read -p "Please enter a username for the new user: " USERNAME
    read -p "Please enter the name of the new user: " NAME
fi

PASSWORD=$(date +%s%N | sha256 | head -c32)

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
