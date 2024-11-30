package main

import (
	"testing"
)

func TestPointsFromItemsForOddItems(t *testing.T) {
	items := []Item { {"",""}, {"",""}, {"",""}, {"",""},{"",""}}
	result := pointsFromItemCount(items)
	target := 10
	if result != target {
		t.Errorf("Result was incorrect, got %d, want: %d.", result, target)
	}
}

func TestPointsFromItemsForEvenItems(t *testing.T) {
	items := []Item { {"",""}, {"",""}, {"",""}, {"",""}}
	result := pointsFromItemCount(items)
	target := 10
	if result != target {
		t.Errorf("Result was incorrect, got %d, want: %d.", result, target)
	}
}

func TestPointsFromRetailerAllAlphanumeric(t *testing.T) {
	retailer := "Target"
	result := pointsFromRetailer(retailer)
	target := 6
	if result != target {
		t.Errorf("Result was incorrect, got %d, want: %d.", result, target)
	}
}

func TestPointsFromRetailerNotAllAlphanumeric(t *testing.T) {
	retailer := "M&M Corner Market"
	result := pointsFromRetailer(retailer)
	target := 14
	if result != target {
		t.Errorf("Result was incorrect, got %d, want: %d.", result, target)
	}
}

func TestPointsFromTotalEvenDollar(t *testing.T) {
	total := "7.00"
	result := pointsFromTotal(total)
	target := 75
	if result != target {
		t.Errorf("Result was incorrect, got %d, want: %d.", result, target)
	}
}

func TestPointsFromTotalQuarterNotEvenDollar(t *testing.T) {
	total := "7.25"
	result := pointsFromTotal(total)
	target := 25
	if result != target {
		t.Errorf("Result was incorrect, got %d, want: %d.", result, target)
	}
}

func TestPointsFromTotalNotQuarter(t *testing.T) {
	total := "7.28"
	result := pointsFromTotal(total)
	target := 0
	if result != target {
		t.Errorf("Result was incorrect, got %d, want: %d.", result, target)
	}
}

func TestPointsFromDateOddDay(t *testing.T) {
	date := "2024-11-29"
	result := pointsFromDate(date)
	target := 6
	if result != target {
		t.Errorf("Result was incorrect, got %d, want: %d.", result, target)
	}
}

func TestPointsFromDateEvenDay(t *testing.T) {
	date := "2024-11-28"
	result := pointsFromDate(date)
	target := 0
	if result != target {
		t.Errorf("Result was incorrect, got %d, want: %d.", result, target)
	}
}

func TestPointsFromTimeWithinHours(t *testing.T) {
	time := "14:01"
	result := pointsFromTime(time)
	target := 10
	if result != target {
		t.Errorf("Result was incorrect, got %d, want: %d.", result, target)
	}
}

func TestPointsFromTimeBeforeHours(t *testing.T) {
	time := "13:59"
	result := pointsFromTime(time)
	target := 0
	if result != target {
		t.Errorf("Result was incorrect, got %d, want: %d.", result, target)
	}
}

func TestPointsFromTimeAfterHours(t *testing.T) {
	time := "16:00"
	result := pointsFromTime(time)
	target := 0
	if result != target {
		t.Errorf("Result was incorrect, got %d, want: %d.", result, target)
	}
}

func TestPointsFromItemDescriptionWithTrimmedLengthDivisibleByThree(t *testing.T) {
	item := Item{"   Klarbrunn 12-PK 12 FL OZ  ", "12.00"}
	result := pointsFromItemDescription(item)
	target := 3
	if result != target {
		t.Errorf("Result was incorrect, got %d, want: %d.", result, target)
	}
	item2 := Item{"Emils Cheese Pizza", "12.25"}
	result2 := pointsFromItemDescription(item2)
	target2 := 3
	if result2 != target2 {
		t.Errorf("Result was incorrect, got %d, want: %d.", result2, target2)
	}
}

func TestPointsFromItemDescriptionWithTrimmedLengthNotDivisibleByThree(t *testing.T) {
	item := Item{"Gatorade", "2.25"}
	result := pointsFromItemDescription(item)
	target := 0
	if result != target {
		t.Errorf("Result was incorrect, got %d, want: %d.", result, target)
	}
}

func TestPointsFromItemDescriptions(t *testing.T) {
	items := []Item{ {"   Klarbrunn 12-PK 12 FL OZ  ", "12.00"}, 
					  {"Emils Cheese Pizza", "12.25"}, 
					  {"Gatorade", "2.25" },
					}
	result := pointsFromItemDescriptions(items)
	target := 6
	if result != target {
		t.Errorf("Result was incorrect, got %d, want: %d.", result, target)
	}
}

func TestPointsFromItems(t *testing.T) {
	items := []Item{ {"   Klarbrunn 12-PK 12 FL OZ  ", "12.00"}, 
					  {"Emils Cheese Pizza", "12.25"}, 
					  {"Gatorade", "2.25" },
					}
	result := pointsFromItems(items)
	target := 11
	if result != target {
		t.Errorf("Result was incorrect, got %d, want: %d.", result, target)
	}
}

func TestCalculatePoints(t *testing.T) {
	receiptInfo := "{\n  \"retailer\": \"Target\",\n  \"purchaseDate\": \"2022-01-01\",\n  \"purchaseTime\": \"13:01\",\n  \"items\": [\n    {\n      \"shortDescription\": \"Mountain Dew 12PK\",\n      \"price\": \"6.49\"\n    },\n    {\n      \"shortDescription\": \"Emils Cheese Pizza\",\n      \"price\": \"12.25\"\n    },\n    {\n      \"shortDescription\": \"Knorr Creamy Chicken\",\n      \"price\": \"1.26\"\n    },\n    {\n      \"shortDescription\": \"Doritos Nacho Cheese\",\n      \"price\": \"3.35\"\n    },\n    {\n      \"shortDescription\": \"   Klarbrunn 12-PK 12 FL OZ  \",\n      \"price\": \"12.00\"\n    }\n  ],\n  \"total\": \"35.35\"\n}"
	result := calculatePoints(receiptInfo)
	target := 28
	if result != target {
		t.Errorf("Result was incorrect, got %d, want: %d.", result, target)
	}
	receiptInfo2 := "{\n  \"retailer\": \"M&M Corner Market\",\n  \"purchaseDate\": \"2022-03-20\",\n  \"purchaseTime\": \"14:33\",\n  \"items\": [\n    {\n      \"shortDescription\": \"Gatorade\",\n      \"price\": \"2.25\"\n    },{\n      \"shortDescription\": \"Gatorade\",\n      \"price\": \"2.25\"\n    },{\n      \"shortDescription\": \"Gatorade\",\n      \"price\": \"2.25\"\n    },{\n      \"shortDescription\": \"Gatorade\",\n      \"price\": \"2.25\"\n    }\n  ],\n  \"total\": \"9.00\"\n}"
	result2 := calculatePoints(receiptInfo2)
	target2 := 109
	if result2 != target2 {
		t.Errorf("Result was incorrect, got %d, want: %d.", result2, target2)
	}

}