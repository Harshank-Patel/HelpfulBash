#!/bin/bash

URL='https://www.recreation.gov/api/timedentry/availability/facility/10086745/monthlyAvailabilitySummaryView?year=2024&month=10&inventoryBucket=FIT&tourID=10086746'
AUTH_TOKEN='Bearer <Insert here>'


while true
do
  # Fetch data
  response=$(curl -s "$URL" \
    -H "accept: */*" \
    -H "accept-language: en-US,en;q=0.9" \
    -H "cookie: _gcl_au=1.1.386770688.1726324891; _ga=GA1.1.490907295.1726324891" \
    -H "priority: u=1, i" \
    -H "authorization: $AUTH_TOKEN" \
    -H "referer: https://www.recreation.gov/timed-entry/10086745/ticket/10086746" \
    -H "sec-ch-ua-mobile: ?0" \
    -H "sec-fetch-dest: empty" \
    -H "sec-fetch-mode: cors" \
    -H "sec-fetch-site: same-origin" \
    -H "user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36")

  # Extract available dates, times, and reservation info using jq
  available=$(echo $response | jq -r '
    .facility_availability_summary_view_by_local_date
    | to_entries[]
    | select(.value.tour_availability_summary_view_by_tour_id["10086746"].has_not_yet_released == false and .value.tour_availability_summary_view_by_tour_id["10086746"].has_reservable == true)
    | select(.value.tour_availability_summary_view_by_tour_id["10086746"].available_times != [])
    | "Date:  \(.key):     Available Number : \(.value.tour_availability_summary_view_by_tour_id["10086746"].available_times | join(", "))"
  ')

  # Check if any available times were found and print them
  if [ -n "$available" ]; then
    echo "Displaying the dates where tickets have been released & still available for bookings"
    echo "Available times:"
    echo "$available"
    echo ""
  else
    echo "No available times that meet the criteria."
  fi

  # Wait for 5 seconds before making the next request
  sleep 5
done