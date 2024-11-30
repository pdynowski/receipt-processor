package main

import (
	"net/http"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"fmt"
)

func main() {
	router := gin.Default()
	router.POST("/receipts/process", process)
	router.GET("/receipts/:id/points", getPoints)

	router.Run("localhost:8080")
}

type Receipt struct {
	ID 			uuid.UUID `json:"id"`
	Information string `json:"information"`
}

var receipts = []Receipt{}

func process(c *gin.Context) {
	var newReceipt Receipt
	id := uuid.New()

	receiptData, err := c.GetRawData()

	if err != nil{
		fmt.Println(err)
	}

	newReceipt = Receipt{
		ID: id,
		Information: string(receiptData),
	}

	receipts = append(receipts, newReceipt)
	
	c.JSON(http.StatusCreated, gin.H{"id": newReceipt.ID})
}

func getPoints(c *gin.Context) {
	id, err := uuid.Parse(c.Param("id"))

	if err != nil{
		fmt.Println(err)
	}

	for _, receipt := range receipts{
		if receipt.ID == id{
			points := calculatePoints(receipt.Information)
			c.JSON(http.StatusOK, gin.H{"points": points})
			return
		}
	}
	message := fmt.Sprintf("No receipt found with id: %s", id)
	c.JSON(http.StatusNotFound, gin.H{"message":message})
}
