# Running the Rails App

1. Navigate in terminal to the `rails/receipt-processor` directory
2. Build the image for the rails app by typing `docker-compose build receipt-processor`
3. After the image builds, launch the app by typing `docker-compose up receipt-processor`
	- This should launch both the receipt-processor API and create and start a linked redis instance
4. Endpoints should now be available at `http://localhost:3000/<path>`
	- `http://localhost:3000/receipts/process`
	- `http://localhost:3000/receipts/:uuid/points`

# Running the Go App
1. Navigate in terminal to the `go/receipt-processor` directory
2. Type `go run .` in terminal
3. Endpoints should now be available at `http://localhost:8080/<path>`
	- `http://localhost:8080/receipts/process`
	- `http://localhost:8080/receipts/:uuid/points`