# Function to make API call and process the response
function make_api_call {
  # Make the API call using curl and store the response in a variable
  response=$(curl --silent --location 'https://apptapi.txdpsscheduler.com/api/AvailableLocation' \
    --header 'accept: application/json, text/plain, */*' \
    --header 'authorization: <Right click and find the token from the DMV's web portal>' \
    --header 'connection: keep-alive' \
    --header 'content-type: application/json;charset=UTF-8' \
    --header 'host: apptapi.txdpsscheduler.com' \
    --header 'origin: https://public.txdpsscheduler.com' \
    --header 'referer: https://public.txdpsscheduler.com/' \
    --header 'Cookie: ARRAffinity=a47a13b1fe6845855f0deaeead29654518b93ea0e7bb8a026cdb60b80f6e3bd5; ARRAffinitySameSite=a47a13b1fe6845855f0deaeead29654518b93ea0e7bb8a026cdb60b80f6e3bd5' \
    --data '{
        "TypeId": 81,
        "ZipCode": "78666",
        "CityName": "San Marcos",
        "PreferredDay": 0
    }')

  # Check if the response is valid JSON
  if echo "$response" | jq -e . >/dev/null 2>&1; then
    # Use jq to parse the response and extract Name and NextAvailableDate
    echo "$response" | jq -r '.[] | "Name: \(.Name), NextAvailableDate: \(.NextAvailableDate)"'
  else
    echo "Invalid JSON response: $response"
  fi
}

# Infinite loop to keep making the API call at random intervals
while true; do
  # Call the function to make the API call and print the result
  make_api_call

  # Generate a random sleep time between 120 and 180 seconds (2 to 3 minutes)
  sleep_time=$((RANDOM % 6 + 12))
  echo "Sleeping for $sleep_time seconds..."

  # Sleep for the random time interval
  sleep $sleep_time
done
