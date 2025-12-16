#!/bin/bash
# FMOD ARM64 Download Script for Plants vs Zombies
# Based on Celeste-FMOD2 by pixelomer

LIBRARY_NAME="fmodstudioapi20222linux"
TARGET_DIR="/home/parallels/Plants-Vs-Zombies/cocos2d/external/linux-specific/fmod/prebuilt/arm64"
TEMP_DIR="/tmp/fmod_download"

# Check dependencies
type curl 2>/dev/null >&2 || {
    echo "[-] curl is not installed"
    exit 1
}

type jq 2>/dev/null >&2 || {
    echo "[-] jq is not installed. Installing..."
    sudo apt-get install -y jq
}

set -e

mkdir -p "$TEMP_DIR"
mkdir -p "$TARGET_DIR"
cd "$TEMP_DIR"

curl() {
    command curl \
        -H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1' \
        -H 'Accept-Language: en-US,en;q=0.5' \
        "${@}"
}

if [ -f "fmod-login.json" ]; then
    echo "Loading existing credentials..."
    username="$(jq -r '.username' < "fmod-login.json")"
    password="$(jq -r '.password' < "fmod-login.json")"
    email="$(jq -r '.email' < "fmod-login.json")"
    echo "Using: ${email}"
else
    # Pick a domain
    echo -n "Choosing email domain... "
    mail_domain="$(curl -s 'https://api.mail.tm/domains' | jq -r '."hydra:member"[0].domain')"
    echo "${mail_domain}"

    # Generate credentials
    echo -n "Generating email... "
    username="$(dd if=/dev/urandom bs=1 count=30 2>/dev/null | base64 | sed 's/[\/+]//g' | tr '[:upper:]' '[:lower:]')"
    email="${username}@${mail_domain}"
    password="$(dd if=/dev/urandom bs=1 count=30 2>/dev/null | base64 | sed 's/[\/+]//g')"
    mail_auth="{\"address\":\"${email}\",\"password\":\"${password}\"}"
    echo "${email}"

    # Register api.mail.tm account
    echo -n "Registering temp email account... "
    mail_id="$(curl -s -H 'Content-Type: application/json' -d "${mail_auth}" -X POST 'https://api.mail.tm/accounts' | jq -r '.id')"
    echo "ok"

    # Authenticate with api.mail.tm
    echo -n "Authenticating with email service... "
    mail_token="$(curl -s -H 'Content-Type: application/json' -d "${mail_auth}" -X POST 'https://api.mail.tm/token' | jq -r '.token')"
    echo "ok"

    # Send sign up request
    echo -n "Creating fmod.com account... "
    register_data="\"{ \\\"username\\\":\\\"${username}\\\", \\\"password\\\":\\\"${password}\\\", \\\"company\\\":\\\"\\\", \\\"email\\\":\\\"${username}%40${mail_domain}\\\", \\\"name\\\":\\\"${username}\\\", \\\"ml_news\\\":false, \\\"ml_release\\\":false, \\\"industry\\\":1 }\""
    register_response="$(curl -s \
        -X POST \
        -H 'Referer: https://www.fmod.com/profile/register' \
        -H 'Content-Type: text/plain;charset=UTF-8' \
        -H 'Origin: https://www.fmod.com' \
        -d "${register_data}" \
        'https://www.fmod.com/api-register')"
    echo "ok"

    # Wait for registration email
    echo -n "Waiting for registration email... "
    while true; do
        mail_id="$(curl -s -H "Authorization: Bearer ${mail_token}" 'https://api.mail.tm/messages' | jq -r '."hydra:member"[0].id')"
        if [ "${mail_id}" = "null" ]; then
            sleep 3
        else
            break
        fi
    done
    echo "received"

    # Get the registration key
    echo -n "Getting registration key... "
    completion_url="$(curl -s -H "Authorization: Bearer ${mail_token}" "https://api.mail.tm/messages/${mail_id}" | jq -r '.text' | grep https | head -n1)"
    completion_key="$(echo -n "${completion_url}" | sed 's/.*\=//g')"
    echo "ok"

    # Complete the registration
    echo -n "Completing registration... "
    fmod_status="$(curl -s "https://www.fmod.com/api-registration" \
        -H "Referer: ${completion_url}" \
        -H "Authorization: FMOD ${completion_key}" | jq -r '.status')"
    echo "\"${fmod_status}\""

    # Save credentials
    echo -n "Saving credentials... "
    echo "{\"email\":\"${email}\",\"username\":\"${username}\",\"password\":\"${password}\"}" > fmod-login.json
    echo "done"
fi

# Get auth token
echo -n "Logging in to fmod.com... "
auth_data="$(curl -s "https://www.fmod.com/api-login" \
    -X POST \
    --user "${username}:${password}" \
    -H "Content-Type: text/plain;charset=UTF-8" \
    -H "Origin: https://www.fmod.com" \
    -H "Referer: https://www.fmod.com/login" \
    -d "{}")"
auth_token="$(echo -n "${auth_data}" | jq -r '.token')"
user_id="$(echo -n "${auth_data}" | jq -r '.user')"
echo "ok (user: ${user_id})"

# Get download link
echo "Requesting download link..."
download_link="$(curl -s "https://www.fmod.com/api-get-download-link?path=files/fmodstudio/api/Linux/&filename=${LIBRARY_NAME}.tar.gz&user_id=${user_id}" \
    -H "Authorization: FMOD ${auth_token}" \
    -H "Referer: https://www.fmod.com/download" | jq -r '.url')"

# Download the library
echo "Downloading FMOD library..."
curl \
    -H "Referer: https://www.fmod.com/" \
    -Lo "${LIBRARY_NAME}.tar.gz" \
    "${download_link}"

# Extract
echo -n "Extracting archive... "
rm -rf "${LIBRARY_NAME}"
tar -xzf "${LIBRARY_NAME}.tar.gz"
echo "done"

# Copy ARM64 libraries
echo "Copying ARM64 libraries to ${TARGET_DIR}..."
cp -v "${LIBRARY_NAME}/api/core/lib/arm64/libfmod.so.13" "${TARGET_DIR}/libfmod.so"
echo ""
echo "=== FMOD ARM64 library installed successfully! ==="
echo "Library location: ${TARGET_DIR}/libfmod.so"
echo ""
echo "Run the build script again to compile with audio support."
