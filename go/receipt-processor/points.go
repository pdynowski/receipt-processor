package main

import (
	"encoding/json"
	"fmt"
	"math"
	"regexp"
	"strings"
	"strconv"
)

const (
	QUARTER_TOTAL_POINTS = 25
	DOLLAR_TOTAL_POINTS = 50
	POINTS_PER_PAIR_OF_ITEMS = 5
	DESCRIPTION_LENGTH_FACTOR_FOR_ITEM = 3
	PRICE_FACTOR_FOR_ITEM = 0.2
	POINTS_FOR_ODD_PURCHASE_DATE = 6
	EARLIEST_PURCHASE_HOUR = 14
	LATEST_PURCHASE_HOUR = 16
	POINTS_FOR_PURCHASE_TIME = 10
)

type Item struct{
	ShortDescription string `json:"shortDescription"`
	Price            string `json:"price"`
}

type ReceiptData struct{
	Retailer     string `json:"retailer"`
	PurchaseDate string `json:"purchaseDate"`
	PurchaseTime string `json:"purchaseTime"`
	Items        []Item `json:"items"`
	Total        string `json:"total"`

}

func calculatePoints(receiptInformation string) int {
	var receiptData ReceiptData
	err := json.Unmarshal([]byte(receiptInformation), &receiptData)
	if err != nil{
		fmt.Println(err)
	}
	points := 0
	points += pointsFromRetailer(receiptData.Retailer)
	points += pointsFromTotal(receiptData.Total)
	points += pointsFromDate(receiptData.PurchaseDate)
	points += pointsFromTime(receiptData.PurchaseTime)
	points += pointsFromItems(receiptData.Items)
	return points
}

func pointsFromRetailer(retailer string) int {
	regex := regexp.MustCompile(`[^a-zA-Z0-9]`)
	correctedRetailerName := regex.ReplaceAllString(retailer, "")
	return len([]rune(correctedRetailerName))
}

func pointsFromTotal(total string) int {
	cents := strings.Split(total, ".")[1]
	switch cents {
	case "00":
		return QUARTER_TOTAL_POINTS + DOLLAR_TOTAL_POINTS
	case "25", "50", "75":
		return QUARTER_TOTAL_POINTS
	default:
		return 0
	}
}

func pointsFromDate(date string) int {
	day := strings.Split(date, "-")[2]
	intDay, err := strconv.Atoi(day)
	if err != nil{
		fmt.Println(err)
	}
	if intDay % 2 == 0 {
		return 0
	} else {
		return POINTS_FOR_ODD_PURCHASE_DATE
	}
}

func pointsFromTime(time string) int {
	hour := strings.Split(time, ":")[0]
	intHour, err := strconv.Atoi(hour)
	if err != nil{
		fmt.Println(err)
	}
	if (intHour >= EARLIEST_PURCHASE_HOUR && intHour < LATEST_PURCHASE_HOUR) {
		return POINTS_FOR_PURCHASE_TIME
	} else {
		return 0
	}
}

func pointsFromItems(items []Item) int {
	return pointsFromItemCount(items) + pointsFromItemDescriptions(items)
}

func pointsFromItemCount(items []Item) int {
	return POINTS_PER_PAIR_OF_ITEMS * (len(items) / 2)
}

func pointsFromItemDescriptions(items []Item) int {
	points := 0
	for _, item := range items {
		points += pointsFromItemDescription(item)
	}
	return points
}

func pointsFromItemDescription(item Item) int {
	points := 0
	description := strings.TrimSpace(item.ShortDescription)
	if len([]rune(description)) % 3 == 0 {
		price, err := strconv.ParseFloat(item.Price, 32)
		if err != nil {  }
		points = int(math.Ceil(price * PRICE_FACTOR_FOR_ITEM))
	} 
	return points
}
