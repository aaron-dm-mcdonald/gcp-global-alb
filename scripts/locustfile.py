from locust import HttpUser, task, between
import re  # Regular expressions library for pattern matching

class WebsiteUser(HttpUser):
    # Wait between 1 and 3 seconds between tasks to simulate user think time
    wait_time = between(1, 3)

    def on_start(self):
        # Dictionary to map actual GCP region strings to labels like "Region A", "Region B"
        self.region_map = {}
        # Counter to keep track of how many unique regions we've seen so far
        self.region_counter = 0
        # Remember the last region we saw so we only print changes
        self.last_region = None

    @task
    def index(self):
        # Send an HTTP GET request to the root URL of the load balancer
        response = self.client.get("/")

        # If the request failed (status code not 200), print an error and stop
        if response.status_code != 200:
            print("Failed to get response")
            return

        # Use regex to extract the full line containing zone metadata from the HTML
        # The HTML snippet looks like: <p><b>Zone: </b> projects/123/zones/asia-northeast1-a</p>
        zone_line = re.search(r"<p><b>Zone: </b> (.+?)</p>", response.text)
        if not zone_line:
            print("Zone metadata not found")
            return

        # Extract the actual zone string (e.g., 'projects/123/zones/asia-northeast1-a')
        zone = zone_line.group(1)

        # Extract just the region part from the zone
        # For example, from 'asia-northeast1-a' extract 'asia-northeast1'
        # Regex breakdown:
        #   - zones\/  : literally matches 'zones/'
        #   - ([a-z0-9\-]+) : capture group for region name (letters, numbers, dashes)
        #   - -[a-z]$  : followed by a dash and a single letter at the end (the zone suffix)
        match = re.search(r"zones\/([a-z0-9\-]+)-[a-z]$", zone)
        if not match:
            print("Zone format not recognized")
            return

        region = match.group(1)  # Extracted region like 'asia-northeast1'

        # If this is a new region we've never seen before,
        # assign it a label like "Region A", "Region B", etc.
        if region not in self.region_map:
            self.region_counter += 1
            # chr(64 + 1) = 'A', chr(64 + 2) = 'B', etc.
            self.region_map[region] = f"Region {chr(64 + self.region_counter)}"

        # Only print the region if it's different from the last region
        # This avoids repeated prints if requests hit the same backend region
        if region != self.last_region:
            print(f"{self.region_map[region]}: {region}")
            self.last_region = region
